  #!/bin/bash
  mkdir -p /config
  envsubst < /postal-template.yml > /config/postal.yml
  cat /config/postal.yml
  postal initialize || true
  echo "=== Creating admin user ==="
  echo -e "admin@fivelink.lol\nFivelink\nAdmin\nmotdepasse" | postal make-user || echo "User exists"
  echo "=== Starting worker in background ==="
  postal run-worker &
  echo "=== Starting web server ==="
  postal run-web
