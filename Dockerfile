# Build stage: Debian buster, Python venv, dumb-init
FROM docker.io/debian:buster-slim AS build

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes \
      wget python3-venv gcc libpython3-dev && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip

RUN /venv/bin/pip install dumb-init

# Build venv with requirements
FROM build AS build-venv
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Final distroless image
FROM gcr.io/distroless/python3-debian10

COPY --from=build /venv/bin/dumb-init /usr/bin/dumb-init
WORKDIR /app
COPY --from=build-venv /venv /venv
COPY tl-sg-prometheus-exporter.py /app/exporter.py
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/app/run.sh"]
