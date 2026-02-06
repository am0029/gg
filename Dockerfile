# FROM alpine:latest

# ENV PORT=80
# # تعریف ۴ شناسه منحصر‌به‌فرد
# ENV UUID1=24b4b1e1-7a89-45f6-858c-242cf53b5bdb
# ENV UUID2=b1234567-89ab-cdef-0123-456789abcdef
# ENV UUID3=c9876543-21ba-fedc-3210-abcdef012345
# ENV UUID4=d5555555-4444-3333-2222-111111111111

# RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

# RUN mkdir /tmp/xray && \
#     curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
#     unzip /tmp/xray/xray.zip -d /tmp/xray && \
#     install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
#     rm -rf /tmp/xray

# # اضافه کردن ۴ کلاینت به فایل کانفیگ
# RUN printf '{"inbounds":[{"port":%s,"protocol":"vless","settings":{"clients":[{"id":"%s"},{"id":"%s"},{"id":"%s"},{"id":"%s"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/chat"}}}],"outbounds":[{"protocol":"freedom"}]}' \
#     "$PORT" "$UUID1" "$UUID2" "$UUID3" "$UUID4" > /config.json

# CMD ["/usr/local/bin/xray", "-c", "/config.json"]




# FROM alpine:latest

# ENV PORT=8080
# RUN apk add --no-cache ca-certificates curl unzip

# RUN mkdir /tmp/xray && \
#     curl -L -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
#     unzip /tmp/xray/xray.zip -d /tmp/xray && \
#     install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
#     rm -rf /tmp/xray

# RUN printf '{"log":{"loglevel":"none"},"inbounds":[{"port":8080,"protocol":"vless","settings":{"clients":[{"id":"24b4b1e1-7a89-45f6-858c-242cf53b5bdb"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/chat"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

# CMD ["/usr/local/bin/xray", "-c", "/config.json"]






FROM alpine:latest

# تنظیم پورت روی 8080 برای هماهنگی با لاگ‌های قبلی تو
ENV PORT=8080

RUN apk add --no-cache ca-certificates curl unzip

# دانلود و نصب آخرین نسخه Xray
RUN mkdir /tmp/xray && \
    curl -L -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray/xray.zip -d /tmp/xray && \
    install -m 755 /tmp/xray/xray /usr/local/bin/xray && \
    rm -rf /tmp/xray

# ساخت فایل کانفیگ با پروتکل gRPC (مخصوص دور زدن فیلترینگ ایران)
RUN printf '{"log":{"loglevel":"none"},"inbounds":[{"port":8080,"protocol":"vless","settings":{"clients":[{"id":"24b4b1e1-7a89-45f6-858c-242cf53b5bdb"}],"decryption":"none"},"streamSettings":{"network":"grpc","grpcSettings":{"serviceName":"chat-service"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

# دستور اجرای Xray
CMD ["/usr/local/bin/xray", "-c", "/config.json"]
