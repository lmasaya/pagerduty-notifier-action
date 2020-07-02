FROM golang:1.14-alpine AS build

RUN \
  apk --no-cache add git build-base && \
  go get github.com/PagerDuty/go-pagerduty && \
  cd $GOPATH/src/github.com/PagerDuty/go-pagerduty && \
  CGO_ENABLED=0 go build -tags netgo -ldflags '-w -extldflags "-static"' -o /bin/pd && \
  chmod +x /bin/pd

FROM alpine:3.12
COPY --from=build /bin/pd /bin/pd

ENTRYPOINT["/bin/pd"]
