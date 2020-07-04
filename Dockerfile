FROM golang:1.14-alpine AS build

LABEL maintainer="lmasaya@gmail.com"

ARG CONFD_VERSION=0.16.0

ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/

RUN \
  apk update && \
  apk --no-cache add git build-base ca-certificates && \
  update-ca-certificates && \
  go get github.com/PagerDuty/go-pagerduty && \
  cd $GOPATH/src/github.com/PagerDuty/go-pagerduty && \
  go get && go mod verify && go mod vendor && \
  CGO_ENABLED=0 go build -tags netgo -ldflags '-w -extldflags "-static"' -mod=vendor -o /bin/pd ./command && \
  chmod +x /bin/pd

RUN \
  apk add --no-cache \
    bzip2 \
    make && \
  mkdir -p /go/src/github.com/kelseyhightower/confd && \
  cd /go/src/github.com/kelseyhightower/confd && \
  tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz && \
  CGO_ENABLED=0 go build -tags netgo -ldflags '-w -extldflags "-static"' -o /bin/confd . && \
  rm -rf /tmp/v${CONFD_VERSION}.tar.gz && \
  chmod +x /bin/confd

FROM alpine:3.12
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /bin/pd /bin/pd
COPY --from=build /bin/confd /bin/confd
ADD files/ /

ENTRYPOINT ["/bin/entrypoint.sh"]
