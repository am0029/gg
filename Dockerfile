FROM alpine:latest

ENV PORT=80
ENV UUID=24b4b1e1-7a89-45f6-858c-242cf53b5bdb

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

RUN mkdir /tmp/xray && \
    curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray/xray.zip -d /tmp/xray && \
    install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
    rm -rf /tmp/xray

RUN printf '{"inbounds":[{"port":%s,"protocol":"vless","settings":{"clients":[{"id":"%s"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/chat"}}}],"outbounds":[{"protocol":"freedom"}]}' "$PORT" "$UUID" > /config.json

CMD ["/usr/local/bin/xray", "-c", "/config.json"]

