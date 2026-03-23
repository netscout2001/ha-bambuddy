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


FROM ghcr.io/maziggy/bambuddy:0.2.2.1
RUN ls -la /usr/local/bin/ 2>/dev/null || true
RUN ls -la /usr/bin/ | grep -i uvi 2>/dev/null || true  
RUN cat /start.sh 2>/dev/null || true
RUN cat /docker-entrypoint.sh 2>/dev/null || true
RUN find /etc -name "supervisord*" 2>/dev/null || true
RUN find / -maxdepth 3 -name "*.sh" 2>/dev/null | head -20 || true

COPY rootfs /
RUN chmod +x /etc/services.d/bambuddy/run
