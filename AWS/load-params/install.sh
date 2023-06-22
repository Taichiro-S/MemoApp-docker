#!/bin/bash

# ---------------------------------
# Install middlewares.
# ---------------------------------

# Install Node.js
# curl -sL https://rpm.nodesource.com/setup_12.x | bash -
# yum install -y nodejs

# Install jq
curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x /usr/local/bin/jq


# ---------------------------------
# Install load-params.service
# ---------------------------------
INITENV_NAME="load-params"
INITENV_SHELL="/etc/rc.d/${INITENV_NAME}.sh"
INITENV_SERVICE="/etc/systemd/system/${INITENV_NAME}.service"

# Install initialize environments shell script.
rm -rf "${INITENV_SHELL}" "${INITENV_SERVICE}"
cp "${INITENV_SHELL##*/}" "${INITENV_SHELL}"
chmod +x "${INITENV_SHELL}"

# Install load systems parameter service.
cp "${INITENV_SERVICE##*/}" "${INITENV_SERVICE}"
chmod +x "${INITENV_SERVICE}"
systemctl daemon-reload
systemctl enable ${INITENV_NAME}
systemctl start ${INITENV_NAME}


# ---------------------------------
# Install tastylog.service
# ---------------------------------
# APP_NAME="tastylog"
# APP_SERVICE="/etc/systemd/system/${APP_NAME}.service"

# Install application service
# rm -rf "${APP_SERVICE}"
# cp "${APP_SERVICE##*/}" "${APP_SERVICE}"
# chmod +x "${APP_SERVICE}"
# systemctl daemon-reload
