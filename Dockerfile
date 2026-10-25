FROM alpine:latest

ENV PORT=8080
RUN apk add --no-cache ca-certificates curl unzip openssl

# 1. نصب Xray
RUN mkdir /tmp/xray && \
    curl -L -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray/xray.zip -d /tmp/xray && \
    install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
    rm -rf /tmp/xray

# 2. ساخت گواهی SSL خودامضا (برای اینکه TLS کار کنه)
RUN openssl req -x509 -newkey rsa:2048 -keyout /key.pem -out /cert.pem -days 3650 -nodes -subj "/CN=likely-daisy-digidanesh1234-f73a8475.koyeb.app"

# 3. ساخت کانفیگ ترکیبی (TCP به همراه Fallback برای WS)
RUN printf '{"log":{"loglevel":"none"},"inbounds":[{"port":8080,"protocol":"vless","settings":{"clients":[{"id":"24b4b1e1-7a89-45f6-858c-242cf53b5bdb"},{"id":"b1234567-89ab-cdef-0123-456789abcdef"}],"decryption":"none","fallbacks":[{"path":"/godlovesus","dest":8081}]},"streamSettings":{"network":"tcp","security":"tls","tlsSettings":{"certificates":[{"certificateFile":"/cert.pem","keyFile":"/key.pem"}]}}},{"port":8081,"protocol":"vless","settings":{"clients":[{"id":"24b4b1e1-7a89-45f6-858c-242cf53b5bdb"},{"id":"b1234567-89ab-cdef-0123-456789abcdef"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/godlovesus"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

CMD ["/usr/local/bin/xray", "-c", "/config.json"]
