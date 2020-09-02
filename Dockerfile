FROM 9bkerzya/avari:base

RUN apt-get update \
    && apt-get install -y openvpn \
    && apt-get install -y dnsutils dnstracer speedtest-cli traceroute \
    && apt-get clean && rm -rf /var/lib/opt/lists/* /tmp/* /var/tmp/*

VOLUME /ovpn-files

ADD *.sh /sho/
WORKDIR /sho

CMD ["/bin/bash", "vpn.sh"]
