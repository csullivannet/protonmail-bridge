# protonmail-bridge

## Overview

An OCI/Docker compatible image for ProtonMail Bridge for Linux

## Environment variables

The image currently only accepts the `LOG_LEVEL` environment variable, which
corresponds directly to the bridge CLI's log level. Accepted values are:
`panic, fatal, error, warn, info, debug, debug-client, debug-server`.

## Using the bridge image

The bridge CLI is interactive. It requires the container runtime to be set to interactive with TTY. e.g. `--tty` and `--interactive` when using podman or
docker CLI.

The container can be started with `--detach`, using the podman/docker/kubectl
attach command to attach at a later point. Use `CTRL+P`, followed by `CTRL+Q` to
detach again. When attached, we can then use the CLI normally, i.e. run `login`
and `info`.

Actions that restart the bridge will stop/kill the container. You may consider
running the container with a restart policy.

## Persisting data

If you need to persist data, such as logs, user preferences, or certificates,
the bridge will use the following paths inside the container:

### `/root/.cache/protonmail/bridge/logs/`

Logs are stored here. A typical filename for the log is:
`v<VERSION>_<HASH>_<EPOCH>.log`. E.g. `v1.5.2_072ce54fe1_1609548950.log`.

### `/root/.cache/protonmail/bridge/c11/`

Contains:
- `bridge.lock`: ensures only a single instance of the bridge is running.
- The mailbox database, to be used by clients.
- `prefs.json`: Saved user preferences.
- `user_info.json`: Saved IMAP cache (i.e. subscribed mailboxes)

### `/root/.config/protonmail/bridge/`

Used to store TLS certificate and key: `cert.pem`, `key.pem`.

## Example run

```
# podman run \
    --tty \
    --interactive \
    --detach \
    --name bridge \
    --publish 1143:1143 \
    --publish 1025:1025 \
    ghcr.io/csullivannet/protonmail-bridge/bridge:1.5.2-1
# podman attach bridge
>>>
>>> login
Username: <USERNAME>
Password: <PASSWORD>
Authenticating ...
Two factor code: <2FACODE>
Adding account ...
Account <USERNAME> was added successfully.
>>> info
Configuration for <USERNAME>@protonmail.com
IMAP Settings
Address:   127.0.0.1
IMAP port: 1143
Username:  <USERNAME>@protonmail.com
Password:  <BRIDGE_PASSWORD>
Security:  STARTTLS

SMTP Settings
Address:   127.0.0.1
IMAP port: 1025
Username:  <USERNAME>@protonmail.com
Password:  <BRIDGE_PASSWORD>
Security:  STARTTLS

>>> <CTRL+P><CTRL+Q>
```

## Common problems

### Self-signed certs

The bridge will automatically generate a self-signed cert to use when connecting
with STARTTLS. While some clients like Thunderbird may allow you to store an
exception to bypass TLS errors, others may not be so easily bypassed.

The bridge allows you to define your own cert and key, which must be located at
the following paths inside the running container:

```
/root/.config/protonmail/bridge/cert.pem
/root/.config/protonmail/bridge/key.pem
```
