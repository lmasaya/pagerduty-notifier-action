FROM golang:1.14-alpine AS build

RUN \
  apk --no-cache add git build-base && \
  go get github.com/PagerDuty/go-pagerduty && \
  cd $GOPATH/src/github.com/PagerDuty/go-pagerduty && \
  make install

FROM scratch
COPY --from=build /bin/pd /bin/pd
