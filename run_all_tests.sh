#!/bin/bash

# Find and run all test scripts in the 'tests' folder
for test_script in tests/*; do
  if [[ "$test_script" == tests/test* ]]; then
    if [ -f "$test_script" ]; then
    echo "Running $test_script..."
    source $test_script
    fi
  fi
done

# Define the URL for the latest Sonobuoy release
SONOBUOY_URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.16/sonobuoy_0.56.16_linux_amd64.tar.gz"

# Define the installation directory for Sonobuoy
INSTALL_DIR="/usr/local/bin"

# Define the output directory for test results
OUTPUT_DIR="$PWD/sonobuoy-results"

# Check if Sonobuoy is already installed
if [ -x "$INSTALL_DIR/sonobuoy" ]; then
    echo "Sonobuoy is already installed."
else
    echo "Sonobuoy is not installed. Downloading and installing..."

    # Download Sonobuoy and move it to the installation directory
    curl -Lo sonobuoy "$SONOBUOY_URL"

    # Extract the contents of the downloaded archive
    tar xvzf sonobuoy

    chmod +x sonobuoy

    sudo mv sonobuoy "$INSTALL_DIR"
fi

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run Sonobuoy tests
sonobuoy run --wait --plugin-env=e2e.E2E_EXTRA_ARGS=--allowed-not-ready-nodes=1

# Retrieve the results
sonobuoy retrieve "$OUTPUT_DIR"

# Extract the results
tar xzf "$OUTPUT_DIR"/*.tar.gz -C "$OUTPUT_DIR"

echo "Sonobuoy tests completed. Results are stored in: $OUTPUT_DIR"
