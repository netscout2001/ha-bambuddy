FROM ghcr.io/maziggy/bambuddy:0.2.2.1
RUN cat /proc/self/cmdline 2>/dev/null | tr '\0' ' ' || true
RUN ls -la /usr/local/bin/ | grep -i entry || true  
RUN find / -name "entrypoint*" -o -name "docker-entrypoint*" 2>/dev/null | head -10 || true
RUN cat /Dockerfile 2>/dev/null || true

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl jq bash \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/lib/bashio \
  && curl -fsSL https://raw.githubusercontent.com/hassio-addons/bashio/master/lib/bashio.sh \
     -o /usr/lib/bashio/bashio.sh

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV DATA_DIR=/app/data
ENV LOG_DIR=/app/logs

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]