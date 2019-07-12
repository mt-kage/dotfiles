#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

function execute() {
    echo "[${SCRIPT_DIR}/${1}.sh] START"
    /bin/bash "${SCRIPT_DIR}/${1}.sh"
}

# exec
execute brew_init