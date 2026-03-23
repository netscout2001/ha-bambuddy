FROM ghcr.io/maziggy/bambuddy:0.2.2.1

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl jq bash \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/lib/bashio \
  && curl -fsSL https://raw.githubusercontent.com/hassio-addons/bashio/master/lib/bashio.sh \
     -o /usr/lib/bashio/bashio.sh

ENV PYTHONUNBUFFERED=1
ENV DATA_DIR=/app/data
ENV LOG_DIR=/app/logs

# Originalen Startprozess deaktivieren
RUN find /etc/services.d -mindepth 1 -maxdepth 1 ! -name "bambuddy" -exec rm -rf {} + 2>/dev/null || true
RUN find /etc/cont-init.d -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null || true

COPY rootfs /
RUN chmod +x /etc/services.d/bambuddy/run
