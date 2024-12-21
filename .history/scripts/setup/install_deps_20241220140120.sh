#!/bin/bash

set -e

echo "Installing Dependencies..."

# Install Terraform
if ! [ -x "$(command -v terraform)" ]; then
  echo "Installing Terraform..."
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install -y terraform
else
  echo "Terraform is already installed."
fi

# Install OCI CLI
if ! [ -x "$(command -v oci)" ]; then
  echo "Installing OCI CLI..."
  bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" --accept-all-defaults
else
  echo "OCI CLI is already installed."
fi

# Install Python Dependencies
if ! [ -x "$(command -v pip3)" ]; then
  echo "Installing Python3 pip..."
  sudo apt-get install -y python3-pip
fi

echo "Installing Python dependencies..."
pip3 install -r scripts/setup/requirements.txt

echo "Dependencies installed successfully!"