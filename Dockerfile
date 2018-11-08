# Build Gpdex in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc git musl-dev linux-headers

ADD . /go-pdexchain
RUN cd /go-pdexchain && make gpdex

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-pdexchain/build/bin/gpdex /usr/local/bin/

EXPOSE 7996 7997 47380/tcp 47380/udp
ENTRYPOINT ["gpdex"]
