# Use an ARM64 base image with systemd
FROM centos:latest

# Set environment
 ENV PATH=/usr/share/elasticsearch/bin:$PATH

# Install dependencies
RUN yum install -y \
    wget \
    && wget https://artifacts.elastic.co/GPG-KEY-elasticsearch \
    && rpm --import GPG-KEY-elasticsearch \
    && yum install -y epel-release \
    && yum install -y elasticsearch logstash kibana fleet-server

# Configure Elasticsearch
RUN echo "vm.max_map_count=262144" > /etc/sysctl.conf \
    && sysctl -p \
    && echo -e "xpack.security.enabled: true\nxpack.security.http.ssl.enabled: true" >> /etc/elasticsearch/elasticsearch.yml

# Configure Logstash
RUN echo "xpack.monitoring.elasticsearch.hosts: [\"localhost:9200\"]" >> /etc/logstash/logstash.yml

# Configure Kibana
RUN echo "elasticsearch.hosts: [\"http://localhost:9200\"]" >> /etc/kibana/kibana.yml \
    && echo "fleet.enabled: true" >> /etc/kibana/kibana.yml

# Enable systemd
RUN systemctl unmask elasticsearch.service logstash.service kibana.service fleet-server.service

# Expose ports
EXPOSE 9200 9300 5601 5044 9220 8200

# Start services
CMD ["/usr/sbin/init"]
