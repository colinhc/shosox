FROM 9bkerzya/avari:base

RUN apt-get update \
    && apt-get install -y shadowsocks-libev

ADD *.sh /sox/
ADD ufw.yml /sox/
WORKDIR /sox

CMD ["/bin/bash", "sox.sh"]

