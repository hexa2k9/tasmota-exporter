FROM golang:1.23-alpine3.20 AS builder

WORKDIR /tasmota-exporter/
COPY . .

RUN set -eux \
    && export ARCH=$(uname -m) \
    && if [[ "${ARCH}" == "aarch64" ]]; then export PLAT="arm64"; elif [[ "${ARCH}" == "x86_64" ]]; then export PLAT="amd64"; else exit 1; fi \
    && go mod download \
    && CGO_ENABLED=0 GOOS=linux GOARCH=${PLAT} go build -o app ./cmd

FROM alpine:3.20

RUN set -eux \
    && apk --no-cache upgrade

WORKDIR /work
COPY --from=builder /tasmota-exporter/app app

CMD ["/work/app"]
