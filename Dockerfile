ARG BUILD_FROM
FROM ghcr.io/maziggy/bambuddy:0.2.2 AS builder
# Zeige wo cv2 liegt
# RUN find /usr -name "cv2*" 2>/dev/null
FROM $BUILD_FROM

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
  build-base \
  linux-headers \
  curl \
  ffmpeg \
  libstdc++ \
  libgomp

# Install Python dependencies
COPY --from=builder /app/requirements.txt ./
RUN sed -i 's/opencv-python-headless/# opencv-python-headless/' /app/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install --root-user-action=ignore -r requirements.txt

COPY --from=builder /app /app

# Copy opencv from builder
COPY --from=builder /usr/local/lib/python3.13/site-packages/cv2 /usr/local/lib/python3.14/site-packages/cv2


ENV PYTHONUNBUFFERED=1
ENV DATA_DIR=/app/data
ENV LOG_DIR=/app/logs

COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]