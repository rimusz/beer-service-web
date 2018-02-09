FROM golang:1.9.3-alpine as builder
WORKDIR /src
ADD beer-service-web.go /src
RUN CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -ldflags="-s -w" -o beer-service-web

FROM scratch
COPY --from=builder /src/beer-service-web .
CMD ["/beer-service-web"]
EXPOSE 8080
