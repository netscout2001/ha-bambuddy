#!/bin/bash

PORT=$(bashio::addon.port "8000/tcp" 2>/dev/null || echo "8000")

if [ "${PORT}" = "null" ] || [ -z "${PORT}" ]; then
  PORT="8000"
fi

echo "[INFO] Link data dir"
mkdir -p /data/data
mkdir -p /data/logs
rm -rf /app/data
rm -rf /app/logs
ln -s /data/data /app/data
ln -s /data/logs /app/logs

cd /app

echo "[INFO] Start Bambuddy on port ${PORT} ..."
exec uvicorn backend.app.main:app --host 0.0.0.0 --port "${PORT}" --loop asyncio