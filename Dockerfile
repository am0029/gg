FROM alpine:latest

ENV PORT=8080
RUN apk add --no-cache ca-certificates curl unzip

# 1. نصب Xray
RUN mkdir /tmp/xray && \
    curl -L -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray/xray.zip -d /tmp/xray && \
    install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
    rm -rf /tmp/xray

# 2. ساخت کانفیگ Xray با پروتکل XHTTP
RUN printf '{"log":{"loglevel":"none"},"inbounds":[{"port":8080,"protocol":"vless","settings":{"clients":[{"id":"24b4b1e1-7a89-45f6-858c-242cf53b5bdb"},{"id":"b1234567-89ab-cdef-0123-456789abcdef"}],"decryption":"none"},"streamSettings":{"network":"xhttp","xhttpSettings":{"path":"/godlovesus"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

CMD ["/usr/local/bin/xray", "-c", "/config.json"]
