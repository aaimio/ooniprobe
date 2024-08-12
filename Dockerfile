FROM alpine:3.20 AS builder

ARG TARGET_VERSION  \
    TARGET_FILE

RUN mkdir -p /build && \
    apk add --no-cache wget && \
    wget -q -O /build/ooniprobe \
    "https://github.com/ooni/probe-cli/releases/download/$TARGET_VERSION/ooniprobe-$TARGET_FILE" && \
    chmod +x /build/ooniprobe

FROM alpine:3.20

COPY --from=builder /build/ooniprobe /.ooniprobe/ooniprobe
COPY ./scripts/probe.sh /.ooniprobe/probe.sh

RUN chmod +x /.ooniprobe/probe.sh

# TODO: Create non-privileged user, but permissions on volumes are pain, plz help

ENTRYPOINT ["/bin/sh", "/.ooniprobe/probe.sh"]