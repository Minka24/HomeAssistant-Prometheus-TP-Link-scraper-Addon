# Build stage: Debian bullseye, Python venv, dumb-init
FROM docker.io/debian:bullseye-slim AS build

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes \
      wget python3-venv gcc libpython3-dev && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip

RUN /venv/bin/pip install dumb-init

# Make run.sh executable in build stage so final distroless image doesn't need chmod
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Build venv with requirements
FROM build AS build-venv
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Final distroless image
FROM gcr.io/distroless/python3-debian11

COPY --from=build /venv/bin/dumb-init /usr/bin/dumb-init
WORKDIR /app
COPY --from=build-venv /venv /venv
COPY tl-sg-prometheus-exporter.py /app/exporter.py
COPY --from=build /app/run.sh /app/run.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/app/run.sh"]
