#!/bin/bash

ansible-playbook ufw.yml

ss-server \
        -a www-data \
	-s ${REMOTE_ADDR} \
	-p ${REMOTE_PORT} \
	-m ${CIPHER_TYPE} \
	-k "$(cat ${REMOTE_PSS_FILE})" \
        -t 600 \
        -n 51200 \
        --fast-open \
        -u
