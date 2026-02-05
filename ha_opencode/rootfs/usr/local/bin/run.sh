#!/usr/bin/env bash
set -e

# =============================================================================
# HA OpenCode - Home Assistant App - Main Entry Point
# =============================================================================

# Use bashio for proper Home Assistant app logging if available
if command -v bashio &> /dev/null; then
    bashio::log.info "=============================================="
    bashio::log.info "  HA OpenCode for Home Assistant"
    bashio::log.info "  Starting services..."
    bashio::log.info "=============================================="
else
    echo "[INFO] =============================================="
    echo "[INFO]   HA OpenCode for Home Assistant"
    echo "[INFO]   Starting services..."
    echo "[INFO] =============================================="
fi

# Export supervisor token for child processes
export SUPERVISOR_TOKEN="${SUPERVISOR_TOKEN}"

# Set home to persistent data directory
export HOME="/data"
export XDG_DATA_HOME="/data/.local/share"
export XDG_CONFIG_HOME="/data/.config"

# Ensure data directories exist with proper structure
mkdir -p /data/.local/share/opencode
mkdir -p /data/.config/opencode

# Copy default MCP config if it doesn't exist
if [ ! -f "/data/.config/opencode/opencode.json" ]; then
    cp /opt/ha-mcp-server/opencode-ha.json /data/.config/opencode/opencode.json
    if command -v bashio &> /dev/null; then
        bashio::log.info "Created default OpenCode configuration"
    fi
fi

# Performance: Set Node.js options for better memory management
export NODE_OPTIONS="--max-old-space-size=256"

if command -v bashio &> /dev/null; then
    bashio::log.info "Starting OpenCode server on port 4096..."
else
    echo "[INFO] Starting OpenCode server on port 4096..."
fi

exec opencode serve --hostname 0.0.0.0 --port 4096
