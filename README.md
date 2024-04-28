# About
This repository is a prometheus configuration playground. It is inteded to be used in conjunction with [asobiba-prometheus-python](https://github.com/soma-kurisu/asobiba-prometheus-python), a python playground for prometheus.

## Usage
We need to perform several steps using Bash commands. Below, I provide a detailed guide that includes downloading the latest binaries for Prometheus, Alertmanager, and Node Exporter using `curl`, verifying their SHA-256 checksums, extracting them to specific directories, and making the binaries executable.

### Step 1: Download the Binaries

First, we need to find the download URLs for the latest versions of Prometheus, Alertmanager, and Node Exporter. These URLs can be obtained from their respective github releases pages. For the sake of this example, I'll use placeholder URLs; you should replace them with the actual latest URLs.

```bash
# Define download URLs
PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/vx.y.z/prometheus-x.y.z.linux-amd64.tar.gz"
ALERTMANAGER_URL="https://github.com/prometheus/alertmanager/releases/download/vx.y.z/alertmanager-x.y.z.linux-amd64.tar.gz"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/vx.y.z/node_exporter-x.y.z.linux-amd64.tar.gz"

# Download the tarballs
curl -L $PROMETHEUS_URL -o prometheus.tar.gz
curl -L $ALERTMANAGER_URL -o alertmanager.tar.gz
curl -L $NODE_EXPORTER_URL -o node_exporter.tar.gz
```

### Step 2: Verify SHA-256 Checksums

After downloading, you should verify the integrity of the files using SHA-256 checksums. Again, you'll need to obtain the correct checksums from the releases page or a trusted source.

```bash
# Assume these are the correct checksums
echo "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef  prometheus.tar.gz" > prometheus.sha256
echo "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890  alertmanager.tar.gz" > alertmanager.sha256
echo "fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210  node_exporter.tar.gz" > node_exporter.sha256

# Verify checksums
sha256sum -c prometheus.sha256
sha256sum -c alertmanager.sha256
sha256sum -c node_exporter.sha256
```

### Step 3: Extract and Move to `/opt/monitor`

Now, extract the tarballs into the respective directories within `/opt/monitor`.

```bash
# Create directories
mkdir -p /opt/monitor/{prometheus,alertmanager,node__exporter}

# Extract files
tar -xzf prometheus.tar.gz --strip-components=1 -C /opt/monitor/prometheus
tar -xzf alertmanager.tar.gz --strip-components=1 -C /opt/monitor/alertmanager
tar -xzf node_exporter.tar.gz --strip-components=1 -C /opt/monitor/node_exporter
```

### Step 4: Make Binaries Executable

Finally, you'll want to ensure that the binaries are executable.

```bash
# Make binaries executable
chmod +x /opt/monitor/prometheus/prometheus
chmod +x /opt/monitor/alertmanager/alertmanager
chmod +x /opt/monitor/node_exporter/node_exporter
```

### Notes

- Ensure you have the necessary permissions to write to `/opt/monitor/`. If not, you may need to prepend `doas` or `sudo` to the `mkdir`, `tar`, and `chmod` commands.
- Always verify the SHA-256 checksums from a trusted source to ensure the integrity and authenticity of the files you download.
- Replace the URLs and checksums with the actual values from the official Prometheus, Alertmanager, and Node Exporter github releases pages.

## Configuration
To create soft links to the configuration files for Prometheus and Alertmanager from this github repository, you can follow these steps. This will include cloning the repository and then creating symbolic links to the configuration files in the appropriate directories.

Here's a complete script that does the following:
1. Clones the repository.
2. Creates symbolic links to the configuration files for Prometheus and Alertmanager.

```bash
#!/bin/bash

# Set up variables for directory paths and repo
CONFIG_REPO="https://github.com/soma-kurisu/asobiba-prometheus-config"
PERSISTENT_CLONE_DIR="~/src/asobiba/asobiba-prometheus-config"
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

# End of script
```

### Explanation
1. **Variables Setup**: Paths and URLs are stored in variables for easier modifications and readability.
2. **Repository Cloning**: The script clones the github repository to your home's playground source directory.
3. **Symbolic Links Creation**:
   - Checks if the configuration files exist in the cloned repository.
   - Creates symbolic links (`ln -sf`) from the repository's configuration files to the expected locations in the binary directories. The `-s` flag creates a symbolic link, and `-f` forces the creation by removing existing files if necessary.

### Usage
- Ensure you have `git` installed on your system to clone the repository.
- You might need to run this script with `doas` or `sudo` if your user does not have the necessary permissions to write to `/usr/local/bin/` or its subdirectories.
- This script assumes that the directory structure in the cloned repository matches the expected paths. If the structure of the repository changes, you will need to update the paths in the script accordingly.

### Notes
For convenience, you can also just run the script directly from this github repository by using curl and piping it into your shell.

```bash
curl -sSL https://raw.githubusercontent.com/soma-kurisu/asobiba-prometheus-config/main/scripts/asobiba-prometheus-config.sh | bash
```

Eventually prepend the `bash` command with `doas` or `sudo` if higher privileges are needed.

## Symlinking Prometheus, Alertmanager, and Node Exporter Binaries
To ensure easy execution of the Prometheus tools from any location on your system, we will create symbolic links in `/usr/local/bin` for the main executables of Prometheus, Alertmanager, and Node Exporter. These applications have been installed in `/opt/monitor/`.

### Prerequisites
Ensure that you have the necessary permissions to create symbolic links in `/usr/local/bin`. Typically, you need to have root access to perform these operations.

### Creating Symlinks
Navigate to `/usr/local/bin` and create symlinks for the Prometheus binaries:

1. **Prometheus**

   ```bash
   sudo ln -s /opt/monitor/prometheus/prometheus /usr/local/bin/prometheus
   ```

2. **Alertmanager**

   Create a symlink for the Alertmanager binary:

   ```bash
   sudo ln -s /opt/monitor/alertmanager/alertmanager /usr/local/bin/alertmanager
   ```

3. **Node Exporter**

   And for the Node Exporter as well:

   ```bash
   sudo ln -s /opt/monitor/node_exporter/node_exporter /usr/local/bin/node_exporter
   ```

### Verification

To verify that the symlinks have been created successfully, you can run the following commands:

```bash
ls -l /usr/local/bin/prometheus
ls -l /usr/local/bin/alertmanager
ls -l /usr/local/bin/node_exporter
```

Each command should output details of the symlink pointing to the respective binary in `/opt/monitor/`.

### Running the Applications

With the symlinks in place, you can now run `prometheus`, `alertmanager`, and `node_exporter` directly from the command line without specifying their full paths:

```bash
prometheus --version
alertmanager --version
node_exporter --version
```

These commands will display the version information for each application, indicating that the symlinks are functioning correctly.