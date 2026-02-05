ARG	BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:bookworm
FROM	${BUILD_FROM}

ARG	BUILD_VERSION=2.0.1
ARG	BUILD_ARCH=x86_64
ARG	TTYD_VERSION=1.7.7
ARG	OPENCODE_VERSION=latest

ENV	NODE_ENV=production npm_config_update_notifier=false npm_config_fund=false

SHELL	["/bin/bash", "-xeo", "pipefail", "-c"]

COPY	rootfs/opt/ha-mcp-server/package*.json /opt/ha-mcp-server/
COPY	rootfs/opt/ha-lsp-server/package*.json /opt/ha-lsp-server/
RUN	export DEBIAN_FRONTEND=noninteractive; \
	apt-get update; \
	apt-get dist-upgrade -yq; \
	apt-get install -y --no-install-recommends ca-certificates curl git jq nodejs npm; \
	apt-get clean; apt-get autoclean; rm -rf /var/lib/apt/lists/*; \
	ARCH=$([ "$BUILD_ARCH" = "aarch64" ] && echo "aarch64" || echo "x86_64"); \
	curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.${ARCH}" -o /usr/bin/ttyd; \
	chmod +x /usr/bin/ttyd; \
	npm install -g opencode-ai@${OPENCODE_VERSION}; \
	npm cache clean --force; \
	cd /opt/ha-mcp-server && npm install --omit=dev; \
	cd /opt/ha-lsp-server && npm install --omit=dev; \
	npm cache clean --force; \
	mkdir -vp /data/.local/share/opencode /data/.config/opencode

COPY	rootfs	/

WORKDIR /homeassistant
HEALTHCHECK    --interval=30s --timeout=10s --start-period=5s --retries=3 CMD pgrep opencode > /dev/null || exit 1
ENV	NODE_OPTIONS="--max-old-space-size=512" \
	HOME=/data \
	XDG_DATA_HOME=/data/.local/share \
	XDG_CONFIG_HOME=/data/.config

LABEL \
    io.hass.name="HA OpenCode" \
    io.hass.description="AI coding agent for editing Home Assistant configuration" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}"
