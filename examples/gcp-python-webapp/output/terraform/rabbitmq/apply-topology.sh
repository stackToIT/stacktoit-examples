#!/usr/bin/env bash
# Declares topology.json on the RabbitMQ instance through the HTTP API of the broker. It changes the broker and nothing else. A person runs it, and nothing of it was run on STACKIT: the first
# call shows whether this credential may use the API from this machine.
set -euo pipefail
: "${RABBITMQ_HTTP_API_URI:?set RABBITMQ_HTTP_API_URI to the http_api_uri of the credential}"
: "${RABBITMQ_USERNAME:?set RABBITMQ_USERNAME to the username of the credential}"
: "${RABBITMQ_PASSWORD:?set RABBITMQ_PASSWORD to the password of the credential}"
: "${RABBITMQ_VHOST:?set RABBITMQ_VHOST to the virtual host at the end of the uri of the credential}"
here="$(cd "$(dirname "$0")" && pwd)"
topology="$here/topology.json"
if grep -q 'REQUIRED_' "$topology"; then
  printf '%s\n' "topology.json still holds names the source does not state. Replace each of these with the name on the broker:" >&2
  grep -o 'REQUIRED_[A-Z0-9_]*' "$topology" | sort -u >&2
  exit 2
fi
api="${RABBITMQ_HTTP_API_URI%/}"
case "$api" in
  */api) ;;
  *) api="$api/api" ;;
esac
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
umask 077
user="$(printf '%s:%s' "$RABBITMQ_USERNAME" "$RABBITMQ_PASSWORD" | sed 's/[\\"]/\\&/g')"
printf 'user = "%s"\n' "$user" > "$work/auth"
encoded() { jq -rn --arg v "$1" '$v|@uri'; }
vhost="$(encoded "$RABBITMQ_VHOST")"
call() { # method, path, optional body
  local code
  local data=()
  if [ -n "${3:-}" ]; then
    printf '%s' "$3" > "$work/body"
    data=(--data-binary "@$work/body")
  fi
  if ! code="$(curl -sS --max-time 30 -K "$work/auth" -o "$work/answer" -w '%{http_code}' -X "$1" -H 'content-type: application/json' "${data[@]+"${data[@]}"}" "$api/$2")"; then
    printf '%s\n' "$1 $2 did not reach the broker. Its address may not be open to this machine: check the ACL of the instance." >&2
    exit 3
  fi
  case "$code" in
    2??) ;;
    401|403)
      printf '%s\n' "$1 $2 answered $code: this credential may not do this. STACKIT and RabbitMQ state no tag for it; a credential takes its roles from CreateCredentials." >&2
      exit 4
      ;;
    *)
      printf '%s\n' "$1 $2 answered $code:" >&2
      cat "$work/answer" >&2
      exit 1
      ;;
  esac
}
call GET overview
while read -r item; do
  call PUT "exchanges/$vhost/$(encoded "$(jq -r .name <<<"$item")")" "$(jq -c 'del(.name)' <<<"$item")"
done < <(jq -c '.exchanges[]' "$topology")
while read -r item; do
  call PUT "policies/$vhost/$(encoded "migrated-$(jq -r .queue <<<"$item")")" \
    "$(jq -c '{pattern: ("^" + (.queue | gsub("(?<c>[.*+?^$(){}|\\[\\]\\\\])"; "\\\(.c)")) + "$"), "apply-to": "queues", priority: 0, definition}' <<<"$item")"
done < <(jq -c '.policies[]' "$topology")
while read -r item; do
  call PUT "queues/$vhost/$(encoded "$(jq -r .name <<<"$item")")" "$(jq -c 'del(.name)' <<<"$item")"
done < <(jq -c '.queues[]' "$topology")
while read -r item; do
  call POST "bindings/$vhost/e/$(encoded "$(jq -r .source <<<"$item")")/q/$(encoded "$(jq -r .queue <<<"$item")")" "$(jq -c '{routing_key}' <<<"$item")"
done < <(jq -c '.bindings[]' "$topology")
while read -r name; do
  call GET "queues/$vhost/$(encoded "$name")"
done < <(jq -r '.queues[].name' "$topology")
printf '%s\n' "$(jq '.exchanges | length' "$topology") exchanges and $(jq '.queues | length' "$topology") queues are declared and read back."
