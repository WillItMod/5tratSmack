#!/usr/bin/env bash
set -Eeuo pipefail

APP_ROOT_CANDIDATES=(
  /opt/5tratumos/apps/5tratsmack
  /opt/5tratsmack
)

usage() {
  cat <<'EOF'
Usage: sudo bash prototype-ungate.sh [--check]

Removes an inherited block-1000 mining gate from a PUBLIC 5tratSmack
prototype. The script refuses to operate on the DEV build and never touches
wallet, blockchain, pool-history or trading volumes.

  --check   Inspect the prototype without changing or restarting anything.
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

compose_channel="$(sed -n \
  's/^[[:space:]]*APP_CHANNEL:[[:space:]]*//p' "$compose_file" |
  tr -d '"'\''[:space:]' | head -n 1)"
container_channel="$(
  {
    docker inspect 5tratsmack-app \
      --format '{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null || true
  } | sed -n 's/^APP_CHANNEL=//p' | head -n 1
)"

if [[ "$compose_channel" != "PUBLIC" || "$container_channel" != "PUBLIC" ]]; then
  echo "Refusing to continue: this is not the PUBLIC prototype build." >&2
  echo "The block-1000 gate must remain enabled on the DEV release." >&2
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
configured_gate="$(read_env_value FIVETRAT_MINING_ACTIVATION_HEIGHT)"
app_gate="$(read_container_value 5tratsmack-app FIVETRAT_MINING_ACTIVATION_HEIGHT)"
pool_gate="$(read_container_value 5trat-ckpool FIVETRAT_MINING_ACTIVATION_HEIGHT)"
stratum_mapping="$(docker port 5trat-ckpool 3333/tcp 2>/dev/null || true)"

echo "5tratSmack public prototype"
echo "  Installation: $app_root"
echo "  Release:      ${release_tag:-unknown}"
echo "  Saved gate:   ${configured_gate:-unset}"
echo "  App gate:     ${app_gate:-unavailable}"
echo "  Pool gate:    ${pool_gate:-unavailable}"
echo "  Stratum:      ${stratum_mapping:-unavailable}"

if [[ "$check_only" -eq 1 ]]; then
  if [[ "${configured_gate:-0}" == "0" \
    && "$app_gate" == "0" \
    && "$pool_gate" == "0" \
    && "$stratum_mapping" == *":57557" ]]; then
    echo "Prototype mining is already ungated."
    exit 0
  fi
  echo "Prototype mining requires repair." >&2
  exit 1
fi

env_stage="$(mktemp "$app_root/.env.prototype-ungate.XXXXXX")"
cleanup() {
  rm -f "$env_stage"
}
trap cleanup EXIT HUP INT TERM
umask 077

awk '
  BEGIN { replaced = 0 }
  /^FIVETRAT_MINING_ACTIVATION_HEIGHT=/ {
    if (!replaced) {
      print "FIVETRAT_MINING_ACTIVATION_HEIGHT=0"
      replaced = 1
    }
    next
  }
  { print }
  END {
    if (!replaced) {
      print "FIVETRAT_MINING_ACTIVATION_HEIGHT=0"
    }
  }
' "$env_file" >"$env_stage"

docker compose \
  --project-directory "$app_root" \
  --env-file "$env_stage" \
  config --quiet

install -m 0600 "$env_stage" "$env_file"
docker compose \
  --project-directory "$app_root" \
  --env-file "$env_file" \
  up -d --no-deps --force-recreate ckpool app

for _ in $(seq 1 30); do
  app_gate="$(read_container_value 5tratsmack-app FIVETRAT_MINING_ACTIVATION_HEIGHT)"
  pool_gate="$(read_container_value 5trat-ckpool FIVETRAT_MINING_ACTIVATION_HEIGHT)"
  stratum_mapping="$(docker port 5trat-ckpool 3333/tcp 2>/dev/null || true)"
  if [[ "$app_gate" == "0" \
    && "$pool_gate" == "0" \
    && "$stratum_mapping" == *":57557" ]]; then
    break
  fi
  sleep 1
done

[[ "$app_gate" == "0" && "$pool_gate" == "0" ]] || {
  echo "The prototype containers did not adopt mining gate 0." >&2
  exit 1
}
[[ "$stratum_mapping" == *":57557" ]] || {
  echo "The prototype Stratum port is not published on TCP 57557." >&2
  exit 1
}

echo
echo "Prototype mining is ungated."
echo "Stratum is available at ${stratum_mapping}."
echo "Wallet, blockchain and trading volumes were not changed."
