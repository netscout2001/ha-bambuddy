FROM ghcr.io/maziggy/bambuddy:0.2.2.1
RUN cat /proc/1/cmdline || true
RUN ls -la / || true
RUN ls -la /app || true

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