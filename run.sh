#!/bin/bash

# Port aus HA Addon Config lesen
PORT=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
  http://supervisor/addons/self/info | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('network',{}).get('8000/tcp', 8000))" 2>/dev/null || echo "8000")

if [ -z "${PORT}" ] || [ "${PORT}" = "None" ] || [ "${PORT}" = "null" ]; then
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
