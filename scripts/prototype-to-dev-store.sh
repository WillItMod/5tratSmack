#!/usr/bin/env bash
set -Eeuo pipefail

APP_ID="axe5tratsmack"
STORE_CHANNEL="dev"
APP_ROOT="${FIVETRAT_5TRATUMOS_APP_ROOT:-/opt/5tratumos/apps}"
STATE_ROOT="${FIVETRAT_5TRATUMOS_STATE_ROOT:-/var/lib/5tratumos/apps}"
DEST_DATA="${STATE_ROOT}/${APP_ID}/data"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

log() {
  printf '[5tratSmack handover] %s\n' "$*"
}

fail() {
  printf '[5tratSmack handover] ERROR: %s\n' "$*" >&2
  exit 1
}

if [[ "$(id -u)" -ne 0 ]]; then
  command -v sudo >/dev/null 2>&1 || fail "run this script as root"
  exec sudo -E bash "$0" "$@"
fi

for command_name in curl docker 5tratumos python3 tar; do
  command -v "$command_name" >/dev/null 2>&1 \
    || fail "required command is unavailable: ${command_name}"
done

docker info >/dev/null 2>&1 || fail "Docker is unavailable"

prototype_containers=(
  5trat-p2p-helper
  5trat-dex-p2p-helper
  5trat-node-a
  5trat-node-b
  5trat-node-c
  5trat-swap
  5trat-ckpool
  5tratsmack-app
)
existing_prototype=()
running_prototype=()
declare -A original_restart=()

for container in "${prototype_containers[@]}"; do
  if ! docker inspect "$container" >/dev/null 2>&1; then
    continue
  fi
  existing_prototype+=("$container")
  original_restart["$container"]="$(docker inspect --format '{{.HostConfig.RestartPolicy.Name}}' "$container")"
  if [[ "$(docker inspect --format '{{.State.Running}}' "$container")" == "true" ]]; then
    running_prototype+=("$container")
  fi
done

store_started=0
handover_complete=0
rollback() {
  local exit_code=$?
  trap - EXIT
  if [[ "$handover_complete" -eq 1 ]]; then
    return
  fi
  if [[ "$store_started" -eq 1 ]]; then
    5tratumos app down "$APP_ID" >/dev/null 2>&1 || true
  fi
  for container in "${existing_prototype[@]}"; do
    policy="${original_restart[$container]:-unless-stopped}"
    [[ -n "$policy" ]] || policy="no"
    docker update --restart="$policy" "$container" >/dev/null 2>&1 || true
  done
  for container in "${running_prototype[@]}"; do
    docker start "$container" >/dev/null 2>&1 || true
  done
  printf '[5tratSmack handover] The DEV handover failed. The previous prototype was restored where possible.\n' >&2
  exit "$exit_code"
}
trap rollback EXIT

mount_source() {
  local container="$1"
  local destination="$2"
  docker inspect --format \
    "{{range .Mounts}}{{if eq .Destination \"${destination}\"}}{{.Source}}{{end}}{{end}}" \
    "$container" 2>/dev/null
}

copy_tree() {
  local source="$1"
  local destination="$2"
  [[ -d "$source" ]] || return 0
  install -d -m 0755 "$destination"
  (
    cd "$source"
    tar cpf - .
  ) | (
    cd "$destination"
    tar xpf -
  )
}

if [[ "${#existing_prototype[@]}" -gt 0 ]]; then
  log "Prototype detected; preserving its named volumes and handing them to the DEV app."

  if [[ -d "${APP_ROOT}/${APP_ID}" ]]; then
    5tratumos app down "$APP_ID" >/dev/null 2>&1 || true
  fi

  for container in "${existing_prototype[@]}"; do
    docker update --restart=no "$container" >/dev/null
  done
  if [[ "${#running_prototype[@]}" -gt 0 ]]; then
    docker stop -t 120 "${running_prototype[@]}" >/dev/null
  fi

  node_source="$(mount_source 5trat-node-a /data)"
  pool_source="$(mount_source 5tratsmack-app /data/pool)"
  ui_source="$(mount_source 5tratsmack-app /data/ui/state)"
  p2p_source="$(mount_source 5tratsmack-app /data/p2p-state)"
  dex_source="$(mount_source 5tratsmack-app /data/dex-p2p-state)"
  swap_source="$(mount_source 5tratsmack-app /data/swap)"
  if [[ -z "$dex_source" ]]; then
    dex_source="$(mount_source 5trat-dex-p2p-helper /state)"
  fi

  [[ -n "$node_source" && -d "$node_source" ]] \
    || fail "the prototype node volume could not be located"
  [[ -n "$pool_source" && -d "$pool_source" ]] \
    || fail "the prototype pool volume could not be located"
  [[ -n "$ui_source" && -d "$ui_source" ]] \
    || fail "the prototype application-state volume could not be located"

  if [[ -d "$DEST_DATA" ]] && find "$DEST_DATA" -mindepth 1 -print -quit | grep -q .; then
    backup="${DEST_DATA}.pre-prototype-handover-${STAMP}"
    log "Preserving the existing DEV data directory at ${backup}."
    mv "$DEST_DATA" "$backup"
  fi
  install -d -m 0755 "$DEST_DATA"

  copy_tree "$node_source" "${DEST_DATA}/node"
  copy_tree "$pool_source" "${DEST_DATA}/pool"
  copy_tree "$ui_source" "${DEST_DATA}/ui/state"
  copy_tree "$p2p_source" "${DEST_DATA}/p2p-state"
  copy_tree "$dex_source" "${DEST_DATA}/dex-p2p-state"
  copy_tree "$swap_source" "${DEST_DATA}/swap"
  chown -R 1000:1000 "$DEST_DATA"
fi

log "Synchronizing the 5tratumOS DEV community store."
5tratumos store sync "$STORE_CHANNEL"

store_started=1
if [[ -f "${APP_ROOT}/${APP_ID}/docker-compose.yml" ]]; then
  log "Repairing or updating the existing DEV installation."
  5tratumos app update "$APP_ID" --channel "$STORE_CHANNEL"
else
  log "Installing the DEV application."
  5tratumos app install "$APP_ID" --channel "$STORE_CHANNEL"
  5tratumos app up "$APP_ID"
fi

ready=0
for _ in $(seq 1 90); do
  if curl -fsS http://127.0.0.1:21226/api/about >/dev/null 2>&1; then
    ready=1
    break
  fi
  sleep 2
done
[[ "$ready" -eq 1 ]] || fail "the DEV application did not become healthy"

handover_complete=1
trap - EXIT
log "DEV handover complete. Prototype containers remain stopped with restart disabled as a rollback copy."
log "Open 5tratSmack from the 5tratumOS sidebar; future updates are managed by the DEV community store."
