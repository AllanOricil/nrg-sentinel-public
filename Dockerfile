# ─────────────────────────────────────────────────────────────────────────────
# NRG Sentinel — production Node-RED image
#
# ENTRYPOINT is the Sentinel wrapper, NOT the bare node-red binary.
# This guarantees:
#   • settings.js signature is verified before Node-RED starts (optional)
#   • Sentinel preload is always injected via --require
#   • No malicious npm package can displace the entrypoint (absolute path)
#
# Build:
#   docker build --build-arg NODERED_VERSION=latest -t nrg-sentinel .
#
# Run (unsigned settings):
#   docker run -p 1880:1880 \
#     -v $(pwd)/settings.js:/etc/nodered/settings.js:ro \
#     -v $(pwd)/data:/data \
#     nrg-sentinel
#
# Run (signed settings):
#   docker run -p 1880:1880 \
#     -v $(pwd)/settings.js:/etc/nodered/settings.js:ro \
#     -v $(pwd)/settings.js.sig:/etc/nodered/settings.js.sig:ro \
#     -v $(pwd)/data:/data \
#     -e NRG_SENTINEL_PUBLIC_KEY=/run/secrets/sentinel.pub \
#     --mount type=secret,id=sentinel_pub,target=/run/secrets/sentinel.pub \
#     nrg-sentinel
# ─────────────────────────────────────────────────────────────────────────────

ARG NODE_VERSION=22
ARG NODERED_VERSION=latest

FROM node:${NODE_VERSION}-alpine AS base

# ── System dependencies ───────────────────────────────────────────────────────
RUN apk add --no-cache \
        dumb-init \
        git \
        openssh-client

# ── Non-root user ─────────────────────────────────────────────────────────────
RUN addgroup -S nodered && adduser -S nodered -G nodered

# ── Install Node-RED and Sentinel in an isolated app directory ─────────────────
#
# We install here (owned by root) so the node-red process user cannot
# modify the installed packages at runtime — including the Sentinel entrypoint.

WORKDIR /usr/src/nodered

RUN --mount=type=cache,target=/root/.npm \
    npm install \
        node-red@${NODERED_VERSION} \
        @allanoricil/nrg-sentinel \
        --omit=dev \
        --no-audit \
        --no-fund \
        --loglevel=error

# Make the entrypoint executable, then lock the entire install as read-only.
#
# chmod -R a-w removes write permission for everyone — including root.
# Root can still restore it with chmod, but any silent in-container
# modification (e.g. via a privilege-escalated malicious node) would
# require an explicit chmod first, making tampering visible in audit logs.
#
# Execute bits are preserved; only write is removed.
RUN chmod +x /usr/src/nodered/node_modules/@allanoricil/nrg-sentinel/bin/node-red.js \
 && chmod -R a-w /usr/src/nodered

# ── Runtime data directory ────────────────────────────────────────────────────
#
# /data  — Node-RED userDir: flows.json, settings.js, credentials, custom nodes
#
# Ownership split is the core of the container's security model:
#
#   /usr/src/nodered   owned by root, chmod a-w  → nobody can write here
#   /etc/nodered       owned by root, chmod a-w  → nobody can write here
#   /data              owned by nodered           → process CAN write here
#
# The Node-RED process (nodered user) can install custom nodes into
# /data/node_modules/, save flows, and write credentials — all normal
# operation.  But it cannot touch /usr/src/nodered/node_modules/, so a
# malicious custom node cannot:
#   • replace  @allanoricil/nrg-sentinel/bin/node-red.js  (the entrypoint)
#   • patch    @allanoricil/nrg-sentinel/preload.js
#   • overwrite node-red itself
#
# The remaining attack surface — malicious code running inside the same
# process via /data/node_modules — is what Sentinel's preload and plugin
# guards are designed to block.  The ownership split protects files on
# disk; Sentinel protects the runtime.
#
# Mount a volume here so user data persists across container restarts.

# /etc/nodered — settings directory, owned by root, readable by nodered.
# The process can read settings.js but cannot modify it, so a malicious
# custom node cannot alter its own capabilities by editing the file.
# Mount settings.js here as a read-only bind mount or Docker config.
RUN mkdir -p /etc/nodered \
 && chown root:root /etc/nodered \
 && chmod 555 /etc/nodered

RUN mkdir -p /data && chown nodered:nodered /data

USER nodered
WORKDIR /data

VOLUME ["/data"]

EXPOSE 1880

# ── Entrypoint ────────────────────────────────────────────────────────────────
#
# dumb-init:   reaps zombies, forwards signals correctly (PID 1 problem)
# node:        absolute path — not resolved via PATH or node_modules/.bin
# wrapper:     absolute path — cannot be displaced by packages in /data
#
# The wrapper injects --require preload.js then execs the real node-red.

ENTRYPOINT [ \
    "dumb-init", "--", \
    "node", "/usr/src/nodered/node_modules/@allanoricil/nrg-sentinel/bin/node-red.js" \
]

CMD [ \
    "--settings", "/etc/nodered/settings.js", \
    "--userDir",  "/data" \
]
