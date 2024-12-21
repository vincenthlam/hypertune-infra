#!/bin/bash

set -e

echo "Verifying Setup..."

# Check for OCI CLI
if ! [ -x "$(command -v oci)" ]; then
  echo "OCI CLI is not installed. Please run install_deps.sh first."
  exit 1
fi

# Check for Terraform
if ! [ -x "$(command -v terraform)" ]; then
  echo "Terraform is not installed. Please run install_deps.sh first."
  exit 1
fi

# Check for OCI configuration
if [ ! -f ~/.oci/config ]; then
  echo "OCI CLI configuration not found in ~/.oci/config."
  exit 1
else
  echo "OCI CLI configuration found."
fi

# Verify OCI private key
if [ ! -f ~/.oci/oci_api_key.pem ]; then
  echo "OCI private key not found in ~/.oci/oci_api_key.pem."
  exit 1
else
  echo "OCI private key found."
fi

# Verify Python dependencies
echo "Checking Python dependencies..."
pip3 check || (echo "Python dependencies are not properly installed. Run install_deps.sh again." && exit 1)

echo "Setup verification completed successfully!"