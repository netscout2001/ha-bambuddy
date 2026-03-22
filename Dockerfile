ARG BUILD_FROM
FROM ghcr.io/maziggy/bambuddy:0.2.2.1 AS builder
FROM $BUILD_FROM

WORKDIR /app
RUN apk add --no-cache \
  build-base \
  linux-headers \
  curl \
  ffmpeg \
  libstdc++ \
  libgomp \
  libavif

COPY --from=builder /app/requirements.txt ./
RUN sed -i 's/opencv-python-headless/# opencv-python-headless/' /app/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install --root-user-action=ignore -r requirements.txt
COPY --from=builder /app /app

ENV PYTHONUNBUFFERED=1
ENV DATA_DIR=/app/data
ENV LOG_DIR=/app/logs
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]