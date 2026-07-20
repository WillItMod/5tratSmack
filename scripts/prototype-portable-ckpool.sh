#!/usr/bin/env bash
set -Eeuo pipefail

APP_ROOT_CANDIDATES=(
  /opt/5tratumos/apps/5tratsmack
  /opt/5tratsmack
)
PORTABLE_IMAGE="ghcr.io/willitmod/5tratsmack-ckpool@sha256:598761756695aa2fabdbe9fea7cc8fe0b1313387ce64cf405b9e2618e0d16d54"
LOCAL_IMAGE="5trat-ckpool:private"
ROLLBACK_IMAGE="5trat-ckpool:prototype-portable-rollback"
CONTAINER="5trat-ckpool"

usage() {
  cat <<'EOF'
Usage: sudo bash prototype-portable-ckpool.sh [--check]

Replaces only the PUBLIC prototype's ckpool executable with a baseline-safe
AMD64/ARM64 image. This repairs the repeated "Illegal instruction" / exit 132
failure on older AMD64 processors.

The helper refuses to operate on the DEV release. It does not modify wallet,
blockchain, pool-history, app-state or trading volumes.

  --check   Inspect the installed pool without changing or restarting it.
EOF
}

check_only=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check) check_only=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run this script with sudo." >&2
  exit 1
fi

command -v docker >/dev/null 2>&1 || {
  echo "Docker is unavailable." >&2
  exit 1
}
docker compose version >/dev/null 2>&1 || {
  echo "Docker Compose v2 is unavailable." >&2
  exit 1
}

case "$(uname -m)" in
  x86_64|amd64|aarch64|arm64) ;;
  *)
    echo "This repair supports only 64-bit AMD/Intel and ARM hosts." >&2
    exit 1
    ;;
esac

app_root=""
for candidate in "${APP_ROOT_CANDIDATES[@]}"; do
  if [[ -f "$candidate/docker-compose.yml" && -f "$candidate/.env" ]]; then
    app_root="$candidate"
    break
  fi
done
[[ -n "$app_root" ]] || {
  echo "A public prototype installation was not found." >&2
  exit 1
}

compose_file="$app_root/docker-compose.yml"
env_file="$app_root/.env"

compose_channel="$(
  sed -n 's/^[[:space:]]*APP_CHANNEL:[[:space:]]*//p' "$compose_file" |
    tr -d '"'\''[:space:]' |
    head -n 1
)"
container_channel="$(
  {
    docker inspect 5tratsmack-app \
      --format '{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null || true
  } | sed -n 's/^APP_CHANNEL=//p' | head -n 1
)"

if [[ "$compose_channel" != "PUBLIC" || "$container_channel" != "PUBLIC" ]]; then
  echo "Refusing to continue: this is not the PUBLIC prototype build." >&2
  echo "The DEV release is deliberately unchanged by this repair." >&2
  exit 1
fi

read_env_value() {
  local name="$1"
  sed -n "s/^${name}=//p" "$env_file" | head -n 1
}

read_container_value() {
  local container="$1" name="$2"
  {
    docker inspect "$container" \
      --format '{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null || true
  } | sed -n "s/^${name}=//p" | head -n 1
}

release_tag="$(read_env_value FIVETRAT_RELEASE_TAG)"
saved_gate="$(read_env_value FIVETRAT_MINING_ACTIVATION_HEIGHT)"
pool_gate="$(read_container_value "$CONTAINER" FIVETRAT_MINING_ACTIVATION_HEIGHT)"
container_state="$(
  docker inspect "$CONTAINER" \
    --format '{{.State.Status}} (exit {{.State.ExitCode}}, Docker restarts {{.RestartCount}})' \
    2>/dev/null || true
)"
container_image="$(
  docker inspect "$CONTAINER" --format '{{.Image}}' 2>/dev/null || true
)"
stratum_mapping="$(docker port "$CONTAINER" 3333/tcp 2>/dev/null || true)"
fatal_log_count="$(
  {
    docker logs --tail 500 "$CONTAINER" 2>&1 || true
  } | grep -Eic 'illegal instruction|core dumped|exited unexpectedly with code 132' || true
)"

echo "5tratSmack public prototype pool"
echo "  Installation: $app_root"
echo "  Release:      ${release_tag:-unknown}"
echo "  Saved gate:   ${saved_gate:-unset}"
echo "  Pool gate:    ${pool_gate:-unavailable}"
echo "  State:        ${container_state:-unavailable}"
echo "  Stratum:      ${stratum_mapping:-unavailable}"
echo "  CPU crashes:  ${fatal_log_count:-0} in the latest 500 log lines"

if [[ "$check_only" -eq 1 ]]; then
  portable_id="$(
    docker image inspect "$PORTABLE_IMAGE" --format '{{.Id}}' 2>/dev/null || true
  )"
  if [[ -n "$portable_id" \
    && "$container_image" == "$portable_id" \
    && "$container_state" == running* \
    && "${fatal_log_count:-0}" == "0" ]]; then
    echo "The portable ckpool repair is installed and healthy."
    exit 0
  fi
  echo "The portable ckpool repair is not installed or is not healthy." >&2
  exit 1
fi

if [[ "${saved_gate:-0}" != "0" || "$pool_gate" != "0" ]]; then
  echo "Refusing to change the pool while this prototype is block-gated." >&2
  echo "Run the prototype ungate helper first, then rerun this repair." >&2
  exit 1
fi

rollback() {
  local original_status="$?"
  trap - ERR
  echo "Portable pool validation failed; restoring the previous pool image." >&2
  if docker image inspect "$ROLLBACK_IMAGE" >/dev/null 2>&1; then
    docker tag "$ROLLBACK_IMAGE" "$LOCAL_IMAGE"
    docker compose \
      --project-directory "$app_root" \
      --env-file "$env_file" \
      up -d --no-deps --force-recreate ckpool || true
  fi
  exit "$original_status"
}
trap rollback ERR

echo
echo "Downloading the immutable portable pool image ..."
docker pull "$PORTABLE_IMAGE"

current_image_id="$(
  docker inspect "$CONTAINER" --format '{{.Image}}' 2>/dev/null || true
)"
[[ -n "$current_image_id" ]] || {
  echo "The existing prototype pool container is unavailable." >&2
  false
}

docker tag "$current_image_id" "$ROLLBACK_IMAGE"
docker tag "$PORTABLE_IMAGE" "$LOCAL_IMAGE"

echo "Recreating only the prototype pool service ..."
docker compose \
  --project-directory "$app_root" \
  --env-file "$env_file" \
  up -d --no-deps --force-recreate ckpool

ready=0
for _ in $(seq 1 45); do
  state="$(docker inspect "$CONTAINER" --format '{{.State.Status}}' 2>/dev/null || true)"
  logs="$(docker logs "$CONTAINER" 2>&1 || true)"
  if [[ "$state" == "running" ]] \
    && grep -Fq 'ckpool generator ready' <<<"$logs" \
    && grep -Fq 'ckpool stratifier ready' <<<"$logs" \
    && grep -Fq 'Connected to bitcoind' <<<"$logs"; then
    ready=1
    break
  fi
  sleep 1
done
[[ "$ready" -eq 1 ]] || {
  echo "The portable pool did not reach ready state." >&2
  false
}

# Clem's incompatible build normally failed during the first template/jackpot
# cycles. Observe several cycles before declaring the repair successful.
sleep 30

state="$(docker inspect "$CONTAINER" --format '{{.State.Status}}' 2>/dev/null || true)"
logs="$(docker logs "$CONTAINER" 2>&1 || true)"
[[ "$state" == "running" ]] || {
  echo "The portable pool stopped during validation." >&2
  false
}
if grep -Eqi 'illegal instruction|core dumped|exited unexpectedly with code 132' <<<"$logs"; then
  echo "The portable pool reported another CPU instruction failure." >&2
  false
fi
grep -Fq 'Network diff set to' <<<"$logs" || {
  echo "The portable pool did not receive a live network difficulty." >&2
  false
}

stratum_mapping="$(docker port "$CONTAINER" 3333/tcp 2>/dev/null || true)"
[[ "$stratum_mapping" == *":57557" ]] || {
  echo "The prototype Stratum port is not published on TCP 57557." >&2
  false
}

trap - ERR
docker image rm "$ROLLBACK_IMAGE" >/dev/null 2>&1 || true

echo
echo "Portable ckpool repair installed successfully."
echo "Stratum is available at ${stratum_mapping}."
echo "No wallet, blockchain, pool-history, app-state or trading volume changed."
