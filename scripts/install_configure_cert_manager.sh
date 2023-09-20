#!/bin/bash

# Define the namespace where Cert-Manager will be installed
CERT_MANAGER_NAMESPACE="cert-manager"

# Define the destination path for downloading the CRDs YAML file
TMP_FOLDER="/tmp"
CRDS_FILE="${TMP_FOLDER}/cert-manager.crds.yaml"

# Download the Cert-Manager CRDs file into the /tmp folder
echo "Downloading Cert-Manager CRDs..."
wget -O "${CRDS_FILE}" https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.crds.yaml

# Extract Cert-Manager version from CRDs YAML
CERT_MANAGER_VERSION=$(grep "app.kubernetes.io/version" "${CRDS_FILE}" | awk '{print $2}' | sed 's/"//g' | head -n 1)

# Step 1: Create the Cert-Manager namespace (if it doesn't exist)
echo "Step 1: Creating the Cert-Manager namespace..."
kubectl create namespace "${CERT_MANAGER_NAMESPACE}"

# Step 2: Add the Jetstack Helm repository
echo "Step 2: Adding the Jetstack Helm repository..."
helm repo add jetstack https://charts.jetstack.io

# Step 3: Install Cert-Manager using Helm
echo "Step 3: Installing Cert-Manager using Helm..."
helm install cert-manager jetstack/cert-manager --namespace "${CERT_MANAGER_NAMESPACE}" --version "${CERT_MANAGER_VERSION}" --set installCRDs=true


echo "Cert-Manager installation complete!"
