FROM golang:1.23-alpine3.20 AS builder

WORKDIR /tasmota-exporter/
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -o app ./cmd

FROM alpine:3.20

RUN set -eux \
    && apk --no-cache upgrade

WORKDIR /work
COPY --from=builder /tasmota-exporter/app app

CMD ["/work/app"]
