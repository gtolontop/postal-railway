  #!/bin/bash
  mkdir -p /config
  envsubst < /postal-template.yml > /config/postal.yml
  cat /config/postal.yml
  postal initialize || true
  echo "=== Creating admin user ==="
  postal make-user <<EOF
  admin@fivelink.lol
  Fivelink
  Admin
  motdepasse
  EOF
  echo "=== Starting server ==="
  exec /docker-entrypoint.sh "$@"
