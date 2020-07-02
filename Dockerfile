FROM golang:1.14-alpine AS build

RUN \
  apk --no-cache add git build-base && \
  go get github.com/PagerDuty/go-pagerduty && \
  cd $GOPATH/src/github.com/PagerDuty/go-pagerduty && \
  go get && go mod verify && go mod vendor && \
  CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w -extldflags "-static"' -mod=vendor -o /bin/pd ./command && \
  chmod +x /bin/pd

FROM scratch
COPY --from=build /bin/pd /bin/pd
