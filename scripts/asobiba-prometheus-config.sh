#!/bin/bash

# Set up variables for directory paths and repo
CONFIG_REPO="https://github.com/soma-kurisu/asobiba-prometheus-config"
PERSISTENT_CLONE_DIR="$HOME/src/asobiba/asobiba-prometheus-config"
PROMETHEUS_CONFIG_DIR="/opt/monitor/prometheus"
ALERTMANAGER_CONFIG_DIR="/opt/monitor/alertmanager"

# Clone the configuration repository if it doesn't exist
if [ ! -d "$PERSISTENT_CLONE_DIR" ]; then
    git clone $CONFIG_REPO $PERSISTENT_CLONE_DIR
else
    echo "Configuration directory already exists. Updating..."
    git -C $PERSISTENT_CLONE_DIR pull
fi

# Check if the clone was successful
if [ -d "$PERSISTENT_CLONE_DIR" ]; then
    echo "Repository is ready."

    # Create symbolic links for Prometheus configuration files
    if [ -f "$PERSISTENT_CLONE_DIR/prometheus/prometheus.yml" ] && [ -f "$PERSISTENT_CLONE_DIR/prometheus/rules.yml" ]; then
        ln -sf "$PERSISTENT_CLONE_DIR/prometheus/prometheus.yml" "$PROMETHEUS_CONFIG_DIR/prometheus.yml"
        ln -sf "$PERSISTENT_CLONE_DIR/prometheus/rules.yml" "$PROMETHEUS_CONFIG_DIR/rules.yml"
        echo "Prometheus configuration files linked."
    else
        echo "Prometheus configuration files not found in the repository."
    fi

    # Create symbolic links for Alertmanager configuration file
    if [ -f "$PERSISTENT_CLONE_DIR/alertmanager/alertmanager.yml" ]; then
        ln -sf "$PERSISTENT_CLONE_DIR/alertmanager/alertmanager.yml" "$ALERTMANAGER_CONFIG_DIR/alertmanager.yml"
        echo "Alertmanager configuration file linked."
    else
        echo "Alertmanager configuration file not found in the repository."
    fi

else
    echo "Failed to prepare the configuration repository."
fi