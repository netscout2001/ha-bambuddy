#!/usr/bin/with-contenv bashio
declare debug
declare port
declare plate_detection

debug=$(bashio::config 'debug')
port=$(bashio::addon.port "8000/tcp")

if [ "${port}" = "null" ] || [ -z "${port}" ]; then
  port="8000"
fi

bashio::log.info 'Link data dir'
mkdir -p /data/data
mkdir -p /data/logs
rm -r /app/data
rm -r /app/logs
ln -s /data/data /app/data
ln -s /data/logs /app/logs

cd /app

if [ "${debug}" = "true" ]; then
  bashio::log.info 'Enabling debug mode'
  export DEBUG=true
fi

bashio::log.info "numpy test: $(python3 -c 'import numpy; print(numpy.__version__)' 2>&1)"
bashio::log.info "cv2 test: $(python3 -c 'import cv2; print(cv2.__version__)' 2>&1)"

bashio::log.info "Start Bambuddy on port ${port} ..."
exec uvicorn backend.app.main:app --host 0.0.0.0 --port "${port}" --loop asyncio
