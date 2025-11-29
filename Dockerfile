  FROM ghcr.io/postalserver/postal:latest

  USER root

  # Copy and fix line endings
  COPY docker-entrypoint-custom.sh /docker-entrypoint-custom.sh
  RUN sed -i 's/\r$//' /docker-entrypoint-custom.sh && chmod +x /docker-entrypoint-custom.sh

  ENTRYPOINT ["/bin/bash", "/docker-entrypoint-custom.sh"]
  CMD ["postal", "web-server"]
