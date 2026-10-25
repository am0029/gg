FROM alpine:latest

ENV PORT=8080
RUN apk add --no-cache ca-certificates curl unzip

# 1. نصب Xray
RUN mkdir /tmp/xray && \
    curl -L -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray/xray.zip -d /tmp/xray && \
    install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
    rm -rf /tmp/xray

# 2. نصب Cloudflared (فقط نصب میشه، اختیاری)
RUN curl -L -o /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# 3. ساخت کانفیگ Xray (دقیقاً همون وب‌سوکت سالم خودت)
RUN printf '{"log":{"loglevel":"none"},"dns":{"servers":["1.1.1.1","8.8.8.8"]},"inbounds":[{"port":8080,"protocol":"vless","settings":{"clients":[{"id":"24b4b1e1-7a89-45f6-858c-242cf53b5bdb"},{"id":"b1234567-89ab-cdef-0123-456789abcdef"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/godlovesus"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

# 4. اسکریپت برای اجرای همزمان Xray و Cloudflared
RUN printf '#!/bin/sh\n/usr/local/bin/xray -c /config.json &\n/usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN"\n' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
