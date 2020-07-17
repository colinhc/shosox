#!/bin/bash

ss-local \
    -a www-data \
    -s ${REMOTE_ADDR} \
    -p ${REMOTE_PORT} \
    -k "$(cat ${REMOTE_PSS_FILE})" \
    -m ${CIPHER_TYPE} \
    -b ${LOCAL_ADDR} \
    -l ${LOCAL_PORT} \
    --fast-open \
    -v

