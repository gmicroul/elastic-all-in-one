# Use an ARM64 base image with systemd
FROM ubuntu:latest

RUN curl -fsSL https://elastic.co/start-local | sh

RUN systemctl unmask elasticsearch.service kibana.service 

# Expose ports
EXPOSE 9200 9300 5601 5044 9220 8200

# Start services
CMD ["/usr/sbin/init"]
