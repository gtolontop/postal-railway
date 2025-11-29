  #!/bin/bash
  mkdir -p /config
  envsubst < /postal-template.yml > /config/postal.yml
  cat /config/postal.yml
  postal initialize || true
  exec /docker-entrypoint.sh "$@"
