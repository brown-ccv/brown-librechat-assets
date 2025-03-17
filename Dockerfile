# Use a lightweight Nginx image
FROM alpine:latest

WORKDIR /shared

# Copy the custom logo into the shared directory
COPY images/logo.png /shared/logo.png

# Command to keep the container running (so it doesn’t exit immediately)
CMD ["sleep", "infinity"]
