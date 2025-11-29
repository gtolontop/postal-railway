  #!/bin/bash
  set -e

  echo "=== Generating postal.yml from environment variables ==="

  mkdir -p /config

  cat > /config/postal.yml << 'EOFCONFIG'
  web:
    host: POSTAL_WEB_HOST_PLACEHOLDER
    protocol: https

  main_db:
    host: MYSQL_HOST_PLACEHOLDER
    port: MYSQL_PORT_PLACEHOLDER
    username: MYSQL_USER_PLACEHOLDER
    password: "MYSQL_PASSWORD_PLACEHOLDER"
    database: MYSQL_DATABASE_PLACEHOLDER
    pool_size: 5

  message_db:
    host: MYSQL_HOST_PLACEHOLDER
    port: MYSQL_PORT_PLACEHOLDER
    username: MYSQL_USER_PLACEHOLDER
    password: "MYSQL_PASSWORD_PLACEHOLDER"
    prefix: postal_msg_

  rabbitmq:
    host: RABBITMQ_HOST_PLACEHOLDER
    port: RABBITMQ_PORT_PLACEHOLDER
    username: RABBITMQ_USER_PLACEHOLDER
    password: "RABBITMQ_PASSWORD_PLACEHOLDER"
    vhost: RABBITMQ_VHOST_PLACEHOLDER

  smtp_server:
    port: 25
    tls_enabled: false
    proxy_protocol: false

  dns:
    mx_records:
      - mx.postal.fivelink.lol
    smtp_server_hostname: smtp.fivelink.lol
    spf_include: spf.postal.fivelink.lol
    return_path_domain: rp.postal.fivelink.lol
    track_domain: track.postal.fivelink.lol

  rails:
    secret_key: SECRET_KEY_PLACEHOLDER
  EOFCONFIG

  sed -i "s/POSTAL_WEB_HOST_PLACEHOLDER/${POSTAL_WEB_HOST:-postal.example.com}/g" /config/postal.yml
  sed -i "s/MYSQL_HOST_PLACEHOLDER/${MYSQL_HOST:-localhost}/g" /config/postal.yml
  sed -i "s/MYSQL_PORT_PLACEHOLDER/${MYSQL_PORT:-3306}/g" /config/postal.yml
  sed -i "s/MYSQL_USER_PLACEHOLDER/${MYSQL_USER:-root}/g" /config/postal.yml
  sed -i "s/MYSQL_PASSWORD_PLACEHOLDER/${MYSQL_PASSWORD:-}/g" /config/postal.yml
  sed -i "s/MYSQL_DATABASE_PLACEHOLDER/${MYSQL_DATABASE:-postal}/g" /config/postal.yml
  sed -i "s/RABBITMQ_HOST_PLACEHOLDER/${RABBITMQ_HOST:-localhost}/g" /config/postal.yml
  sed -i "s/RABBITMQ_PORT_PLACEHOLDER/${RABBITMQ_PORT:-5672}/g" /config/postal.yml
  sed -i "s/RABBITMQ_USER_PLACEHOLDER/${RABBITMQ_USER:-guest}/g" /config/postal.yml
  sed -i "s/RABBITMQ_PASSWORD_PLACEHOLDER/${RABBITMQ_PASSWORD:-}/g" /config/postal.yml
  sed -i "s/RABBITMQ_VHOST_PLACEHOLDER/${RABBITMQ_VHOST:-\/}/g" /config/postal.yml
  sed -i "s/SECRET_KEY_PLACEHOLDER/${SECRET_KEY:-defaultkey}/g" /config/postal.yml

  echo "=== postal.yml generated ==="
  cat /config/postal.yml

  echo "=== Initializing Postal database ==="
  postal initialize || echo "Already initialized"

  echo "=== Starting Postal ==="
  exec /docker-entrypoint.sh "$@"
