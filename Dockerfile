FROM golang:1.14-alpine AS build

ADD files/ /

RUN \
  apk update && \
  apk --no-cache add git build-base ca-certificates && \
  update-ca-certificates && \
  go get github.com/PagerDuty/go-pagerduty && \
  cd $GOPATH/src/github.com/PagerDuty/go-pagerduty && \
  go get && go mod verify && go mod vendor && \
  CGO_ENABLED=0 go build -tags netgo -ldflags '-w -extldflags "-static"' -mod=vendor -o /bin/pd ./command && \
  chmod +x /bin/pd

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /bin/pd /bin/pd
ENTRYPOINT ["/bin/pd"]
