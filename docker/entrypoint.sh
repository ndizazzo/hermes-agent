#!/bin/bash
set -e

HERMES_HOME="/opt/data"
INSTALL_DIR="/opt/hermes"

if [ "$(id -u)" = "0" ]; then
    if [ -n "$HERMES_UID" ] && [ "$HERMES_UID" != "$(id -u hermes)" ]; then
        usermod -u "$HERMES_UID" hermes
    fi

    if [ -n "$HERMES_GID" ] && [ "$HERMES_GID" != "$(id -g hermes)" ]; then
        groupmod -g "$HERMES_GID" hermes
    fi

    actual_hermes_uid=$(id -u hermes)
    if [ "$(stat -c %u "$HERMES_HOME" 2>/dev/null)" != "$actual_hermes_uid" ]; then
        chown -R hermes:hermes "$HERMES_HOME"
    fi

    echo "Dropping root privileges"
    exec gosu hermes "$0" "$@"
fi

source "${INSTALL_DIR}/.venv/bin/activate"
mkdir -p "$HERMES_HOME"/{sessions,logs,skills,plans,workspace,home}

exec hermes "$@"
