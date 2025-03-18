FROM alpine:latest

WORKDIR /shared

COPY images/logo.svg /shared/logo.svg
COPY images/favicon-16x16.png /shared/favicon-16x16.png
COPY images/favicon-32x32.png /shared/favicon-32x32.png

