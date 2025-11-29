  FROM ghcr.io/postalserver/postal:latest

  USER root

  # Copy custom entrypoint that generates config from env vars
  COPY --chmod=755 docker-entrypoint-custom.sh /docker-entrypoint-custom.sh

  ENTRYPOINT ["/docker-entrypoint-custom.sh"]
  CMD ["postal", "web-server"]
