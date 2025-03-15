# Use an ARM-compatible base image (e.g., CentOS)
FROM docker.elastic.co/elasticsearch/elasticsearch:8.17.3-arm64

# Create a non-root user with sudo privileges
RUN groupadd -g 1000 elastic && \
    useradd -u 1000 -g elastic -d /home/elastic -s /bin/bash elastic && \
    usermod -aG sudo elastic && \
    mkdir -p /home/elastic && \
    chown elastic:elastic /home/elastic
    
# Set the working directory
WORKDIR /usr/local

# Install dependencies
RUN sudo apt-get update -y && \
    sudo apt-get install -y --no-install-recommends \
    wget \
    && sudo rm -rf /var/lib/apt/lists/*

# Download and install Kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.3-linux-aarch64.tar.gz \
    && tar -xzf kibana-8.17.3-linux-aarch64.tar.gz \
    && mv kibana-8.17.3-linux-aarch64 /usr/local/kibana \
    && rm kibana-8.17.3-linux-aarch64.tar.gz

# Expose ports
EXPOSE 9200 5601

# Configure Elasticsearch (if needed)
COPY conf/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

# Configure Kibana (if needed)
COPY conf/kibana.yml /usr/local/kibana/config/kibana.yml

# Use supervisord to run both services
COPY conf/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
