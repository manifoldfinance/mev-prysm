# syntax=docker/dockerfile:1
FROM golang:1.19 as builder
WORKDIR /build
ADD . /build/
RUN mkdir out
RUN --mount=type=cache,target=/root/.cache/go-build go build -o out ./cmd/...


FROM alpine

RUN apk add --no-cache libgcc libstdc++ libc6-compat
WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/out/* /app/beacon-chain
ENTRYPOINT ["/app/beacon-chain"]
