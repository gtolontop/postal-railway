  FROM ghcr.io/postalserver/postal:latest

  USER root

  COPY <<EOF /start.sh
  #!/bin/bash
  set -e
  echo "=== Starting Postal Setup ==="
  mkdir -p /config

  cat > /config/postal.yml << YAMLEND
  web:
    host: \${POSTAL_WEB_HOST}
    protocol: https
  main_db:
    host: \${MYSQL_HOST}
    port: \${MYSQL_PORT}
    username: \${MYSQL_USER}
    password: "\${MYSQL_PASSWORD}"
    database: \${MYSQL_DATABASE}
    pool_size: 5
  message_db:
    host: \${MYSQL_HOST}
    port: \${MYSQL_PORT}
    username: \${MYSQL_USER}
    password: "\${MYSQL_PASSWORD}"
    prefix: postal_msg_
  rabbitmq:
    host: \${RABBITMQ_HOST}
    port: \${RABBITMQ_PORT}
    username: \${RABBITMQ_USER}
    password: "\${RABBITMQ_PASSWORD}"
    vhost: \${RABBITMQ_VHOST}
  smtp_server:
    port: 25
    tls_enabled: false
  dns:
    mx_records:
      - mx.\${POSTAL_WEB_HOST}
    smtp_server_hostname: \${POSTAL_SMTP_HOST}
  rails:
    secret_key: \${SECRET_KEY}
  YAMLEND

  echo "=== Config generated ==="
  cat /config/postal.yml
  echo "=== Initializing DB ==="
  postal initialize || echo "Already done"
  echo "=== Starting server ==="
  exec /docker-entrypoint.sh "\$@"
  EOF

  RUN chmod +x /start.sh

  ENTRYPOINT ["/bin/bash", "/start.sh"]
  CMD ["postal", "web-server"]
