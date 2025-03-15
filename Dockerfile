# Use an ARM64 base image with systemd
FROM rockylinux/rockylinux:9-ubi-init

# Set environment
 ENV PATH=/usr/share/elasticsearch/bin:$PATH
#sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
#    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
# Install dependencies
RUN yum update -y && yum install -y wget \
    && wget  https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.3-aarch64.rpm \
    && wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.3-aarch64.rpm \
    && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.3-aarch64.rpm \
    && rpm -i *.rpm
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
