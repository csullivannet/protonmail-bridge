#!/usr/bin/env bash

set +eux

# Set the log level:
# panic, fatal, error, warn, info, debug, debug-client, debug-server
LOG_LEVEL=${LOG_LEVEL:-warn}

# GPG Parameters should be unique to each user and must be generated at runtime.
if [ ! -f /opt/bridge/gpg_done ]; then
  gpg --generate-key --batch /opt/bridge/gpgparams
  pass init key
  touch /opt/bridge/gpg_done
fi

protonmail-bridge --cli --log-level ${LOG_LEVEL}
