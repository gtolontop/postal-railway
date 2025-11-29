  FROM ghcr.io/postalserver/postal:latest

  USER root

  RUN echo '#!/bin/bash\n\
  set -e\n\
  mkdir -p /config\n\
  echo "web:" > /config/postal.yml\n\
  echo "  host: ${POSTAL_WEB_HOST}" >> /config/postal.yml\n\
  echo "  protocol: https" >> /config/postal.yml\n\
  echo "main_db:" >> /config/postal.yml\n\
  echo "  host: ${MYSQL_HOST}" >> /config/postal.yml\n\
  echo "  port: ${MYSQL_PORT}" >> /config/postal.yml\n\
  echo "  username: ${MYSQL_USER}" >> /config/postal.yml\n\
  echo "  password: ${MYSQL_PASSWORD}" >> /config/postal.yml\n\
  echo "  database: ${MYSQL_DATABASE}" >> /config/postal.yml\n\
  echo "  pool_size: 5" >> /config/postal.yml\n\
  echo "message_db:" >> /config/postal.yml\n\
  echo "  host: ${MYSQL_HOST}" >> /config/postal.yml\n\
  echo "  port: ${MYSQL_PORT}" >> /config/postal.yml\n\
  echo "  username: ${MYSQL_USER}" >> /config/postal.yml\n\
  echo "  password: ${MYSQL_PASSWORD}" >> /config/postal.yml\n\
  echo "  prefix: postal_msg_" >> /config/postal.yml\n\
  echo "rabbitmq:" >> /config/postal.yml\n\
  echo "  host: ${RABBITMQ_HOST}" >> /config/postal.yml\n\
  echo "  port: ${RABBITMQ_PORT}" >> /config/postal.yml\n\
  echo "  username: ${RABBITMQ_USER}" >> /config/postal.yml\n\
  echo "  password: ${RABBITMQ_PASSWORD}" >> /config/postal.yml\n\
  echo "  vhost: ${RABBITMQ_VHOST}" >> /config/postal.yml\n\
  echo "smtp_server:" >> /config/postal.yml\n\
  echo "  port: 25" >> /config/postal.yml\n\
  echo "  tls_enabled: false" >> /config/postal.yml\n\
  echo "dns:" >> /config/postal.yml\n\
  echo "  mx_records:" >> /config/postal.yml\n\
  echo "    - mx.${POSTAL_WEB_HOST}" >> /config/postal.yml\n\
  echo "  smtp_server_hostname: ${POSTAL_SMTP_HOST}" >> /config/postal.yml\n\
  echo "rails:" >> /config/postal.yml\n\
  echo "  secret_key: ${SECRET_KEY}" >> /config/postal.yml\n\
  cat /config/postal.yml\n\
  postal initialize || echo "Already initialized"\n\
  exec /docker-entrypoint.sh "$@"' > /start.sh && chmod +x /start.sh

  ENTRYPOINT ["/bin/bash", "/start.sh"]
  CMD ["postal", "web-server"]
