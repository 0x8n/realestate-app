FROM golang:1.23.4-alpine AS builder

WORKDIR /app

# Install Git (required for some Go modules)
RUN apk add --no-cache git

# Copy go.mod go.sum first (for better cacing)
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the Go binary
RUN go build -o server .

###
# Stage 2: Run the binary in a minimal image
FROM alpine 

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/server .

# Use a non-root user 
RUN adduser -D appuser
USER appuser

EXPOSE 8080

CMD ["./server"]