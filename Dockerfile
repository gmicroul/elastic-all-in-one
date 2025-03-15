# Use an ARM-compatible base image (e.g., CentOS)
FROM docker.elastic.co/elasticsearch/elasticsearch:8.17.3-arm64

# Create a non-root user with sudo privileges
RUN sudo groupadd elastic && \
    sudo useradd -m -s /bin/bash -g elastic elastic && \
    sudo usermod -aG sudo elastic && \
    sudo mkdir -p /home/elastic && \
    sudo chown elastic:elastic /home/elastic

# Set the working directory
WORKDIR /usr/local

# Install dependencies
RUN sudo apt-get update -y && \
    sudo apt-get install -y --no-install-recommends \
    wget \
    && sudo rm -rf /var/lib/apt/lists/*

# Download and install Kibana
RUN sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.3-linux-aarch64.tar.gz \
    && sudo tar -xzf kibana-8.17.3-linux-aarch64.tar.gz \
    && sudo  mv kibana-8.17.3-linux-aarch64 /usr/local/kibana \
    && sudo rm kibana-8.17.3-linux-aarch64.tar.gz

# Expose ports
EXPOSE 9200 5601

# Configure Elasticsearch (if needed)
COPY conf/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

# Configure Kibana (if needed)
COPY conf/kibana.yml /usr/local/kibana/config/kibana.yml

# Use supervisord to run both services
COPY conf/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
