FROM debian:12
COPY znc.conf /home/znc/.znc/configs/znc.conf
# 创建用户并安装依赖
RUN useradd -ms /bin/bash znc && \
    apt update && \
    apt install -y znc curl && \
    chmod 777 /home/znc/.znc/configs/znc.conf && \
    apt install -y debian-keyring debian-archive-keyring apt-transport-https && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    apt update && \
    apt install caddy && \
    apt clean

# 端口和启动
EXPOSE 8080
EXPOSE 8081
CMD ["su", "znc", "-c", "znc && caddy reverse-proxy --from :8080 --to 127.0.0.1:8081"]
