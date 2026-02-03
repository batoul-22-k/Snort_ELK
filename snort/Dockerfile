FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  && apt-get install -y --no-install-recommends debconf-utils ca-certificates wget gnupg  && echo "snort snort/interface string eth0" | debconf-set-selections  && echo "snort snort/address_range string 172.30.0.30/32" | debconf-set-selections  && apt-get install -y --no-install-recommends snort snort-rules-default iproute2 tcpdump  && rm -rf /var/lib/apt/lists/*

COPY snort.conf /etc/snort/snort.conf
COPY classification.config /etc/snort/classification.config
COPY reference.config /etc/snort/reference.config
COPY preproc_rules /etc/snort/preproc_rules
COPY rules /etc/snort/rules
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh  && mkdir -p /var/log/snort  && chown -R snort:snort /var/log/snort || true

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-i","eth0","-c","/etc/snort/snort.conf","-A","fast","-k","none","-q","-u","snort","-g","snort"]
