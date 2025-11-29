FROM ghcr.io/postalserver/postal:latest

# Copy custom entrypoint that generates config from env vars
COPY docker-entrypoint-custom.sh /docker-entrypoint-custom.sh
RUN chmod +x /docker-entrypoint-custom.sh

ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["postal", "web-server"]
