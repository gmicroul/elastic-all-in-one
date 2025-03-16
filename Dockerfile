# 使用带有 sudo 支持的基础镜像
FROM ubuntu:24.04

# 更新包索引
RUN apt update && \
    apt install -y --no-install-recommends \
    wget supervisor \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 安装 Elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.3-linux-aarch64.tar.gz --no-check-certificate && \
    tar -xzf elasticsearch-8.17.3-linux-aarch64.tar.gz && ls -ltrh  && pwd && \
    mv elasticsearch-8.17.3 /usr/local/elasticsearch && \
    rm elasticsearch-8.17.3-linux-aarch64.tar.gz

# 安装 Kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.3-linux-aarch64.tar.gz --no-check-certificate && \
    tar -xzf kibana-8.17.3-linux-aarch64.tar.gz && ls -ltrh  && pwd &&\
    mv kibana-8.17.3 /usr/local/kibana && \
    rm kibana-8.17.3-linux-aarch64.tar.gz

# 创建非 root 用户
RUN useradd -m -s /bin/bash -d /home/elastic elastic && \
    usermod -aG sudo elastic && \
    chown -R elastic:elastic /usr/local/elasticsearch && \
    chown -R elastic:elastic /usr/local/kibana && \
    mkdir -p /var/log/supervisord && \
    chown -R elastic:elastic /var/log/supervisord
    #find / -name supervisord.log
    #chmod 777 /var/log/supervisord.log

# 配置 elasticsearch.yml 和 kibana.yml
COPY conf/elasticsearch.yml /usr/local/elasticsearch/config/elasticsearch.yml
COPY conf/kibana.yml /usr/local/kibana/config/kibana.yml

# 使用 supervisord 管理服务
COPY conf/supervisord.conf /etc/supervisord.conf

# 切换到 elastic 用户
USER elastic

CMD ["/usr/bin/supervisord", "-n"]
