  FROM ghcr.io/postalserver/postal:latest

  USER root

  RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

  COPY postal-template.yml /postal-template.yml
  COPY start.sh /start.sh
  RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

  ENTRYPOINT ["/bin/bash", "/start.sh"]
  CMD ["postal", "web-server"]
