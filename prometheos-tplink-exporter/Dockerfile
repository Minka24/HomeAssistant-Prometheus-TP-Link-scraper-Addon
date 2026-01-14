# Single-stage image: Debian bullseye, Python venv, dumb-init
FROM docker.io/debian:bullseye-slim

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes \
      wget python3-venv gcc libpython3-dev dumb-init && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip

WORKDIR /app

# Install Python requirements
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Copy application and scripts
COPY tl-sg-prometheus-exporter.py /app/exporter.py
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/app/run.sh"]
