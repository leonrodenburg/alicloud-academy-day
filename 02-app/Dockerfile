FROM golang:1.15-alpine AS builder
WORKDIR /src/
COPY . /src/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /bin/app main.go

# ---

FROM scratch
COPY --from=builder /bin/app /bin/app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/bin/app"]
