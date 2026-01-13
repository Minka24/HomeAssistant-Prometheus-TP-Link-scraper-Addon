#!/usr/bin/with-contenv sh
echo "Starting TL-SG Prometheus Exporter..."
exec /venv/bin/python3 /app/exporter.py \
  --host "$SWITCH_IP" \
  --user "$USERNAME" \
  --password "$PASSWORD"
