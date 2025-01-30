# Build stage
FROM golang:1.22-alpine3.19 AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o echo-server

# Final stage
FROM alpine:3.19

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/echo-server .

# Expose port 8080
EXPOSE 8080

# Run the binary
CMD ["./echo-server"]
