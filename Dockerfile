FROM alpine:3.19

WORKDIR /app

# Install curl
RUN apk add --no-cache curl

# Copy the pre-built binary
COPY echo-server .

# Expose port 8080
EXPOSE 8080

# Run the binary
CMD ["./echo-server"]
