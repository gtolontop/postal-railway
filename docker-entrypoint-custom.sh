  #!/bin/bash
  set -e

  echo "=== Generating postal.yml from environment variables ==="

  mkdir -p /config

  cat > /config/postal.yml << EOFCONFIG
  web:
    host: ${POSTAL_WEB_HOST:-postal.example.com}
    protocol: https

  main_db:
    host: ${MYSQL_HOST:-localhost}
    port: ${MYSQL_PORT:-3306}
    username: ${MYSQL_USER:-root}
    password: "${MYSQL_PASSWORD:-}"
    database: ${MYSQL_DATABASE:-postal}
    pool_size: 5

  message_db:
    host: ${MYSQL_HOST:-localhost}
    port: ${MYSQL_PORT:-3306}
    username: ${MYSQL_USER:-root}
    password: "${MYSQL_PASSWORD:-}"
    prefix: postal_msg_

  rabbitmq:
    host: ${RABBITMQ_HOST:-localhost}
    port: ${RABBITMQ_PORT:-5672}
    username: ${RABBITMQ_USER:-guest}
    password: "${RABBITMQ_PASSWORD:-}"
    vhost: ${RABBITMQ_VHOST:-/}

  smtp_server:
    port: ${SMTP_PORT:-25}
    tls_enabled: false
    proxy_protocol: false

  dns:
    mx_records:
      - mx.${POSTAL_WEB_HOST:-postal.example.com}
    smtp_server_hostname: ${POSTAL_SMTP_HOST:-smtp.example.com}
    spf_include: spf.${POSTAL_WEB_HOST:-postal.example.com}
    return_path_domain: rp.${POSTAL_WEB_HOST:-postal.example.com}
    track_domain: track.${POSTAL_WEB_HOST:-postal.example.com}

  rails:
    secret_key: ${SECRET_KEY:-default_secret_key_change_me}
  EOFCONFIG

  echo "=== postal.yml generated ==="

  # Initialize database if not already done
  echo "=== Checking if database needs initialization ==="
  if ! postal db:status > /dev/null 2>&1; then
    echo "=== Initializing Postal database ==="
    postal initialize || true
  fi

  echo "=== Starting Postal ==="
  exec /docker-entrypoint.sh "$@"
