#!/bin/bash
set -e

echo "=== Generating postal.yml from environment variables ==="

# Create config directory if not exists
mkdir -p /config

# Generate postal.yml from environment variables
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
cat /config/postal.yml
echo "=== End of postal.yml ==="

# Run the original docker entrypoint with all arguments
exec /docker-entrypoint.sh "$@"
