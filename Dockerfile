FROM alpine:latest

# busybox-extras provides a tiny httpd so the container stays running
RUN apk add --no-cache busybox-extras \
    && mkdir -p /www \
    && echo "Payment Settlement Active" > /www/index.html

EXPOSE 80

# Prints the message to logs, then serves it on port 80 (foreground)
CMD ["sh", "-c", "echo 'Payment Settlement Active' && busybox-extras httpd -f -p 80 -h /www"]
