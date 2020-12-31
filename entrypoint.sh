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

# The container starts interactively. It requires the container runtime to be
# set to interactive with TTY. e.g. `--tty` and `--interactive` when using
# podman or docker CLI.
#
# The container can be started with `--detach`, using the podman/docker/kubectl
# attach command to attach at a later point. Use ctrl+p, ctrl+q to detach again.
#
# When attached, we can then use the CLI normally, i.e. run `login` + `info`.
protonmail-bridge --cli --log-level ${LOG_LEVEL}
