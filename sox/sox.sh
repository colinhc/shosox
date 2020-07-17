#!/bin/bash

if [[ $MODE = "client" ]]; then ./client_sox.sh;
else ./server_sox.sh; fi

