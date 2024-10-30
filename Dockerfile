FROM golang:1.23-alpine3.20 AS builder

ARG ARCH=amd64

WORKDIR /tasmota-exporter/
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$ARCH go build -o app ./cmd

FROM alpine:3.20

WORKDIR /work
COPY --from=builder /tasmota-exporter/app app

CMD ["/work/app"]
