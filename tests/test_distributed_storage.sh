#!/bin/bash

# Source the utils_testing.sh script
source ./tests/utils_testing.sh

# Namespace name
NAMESPACE="storage-resilience-test"

# PVC, PV, and StorageClass names
PVC_NAME="my-pvc"
PV_NAME="my-pv"


# Get the node names
NODE1="worker-node-1"
NODE2="worker-node-2"

# Create the namespace
kubectl create namespace "$NAMESPACE"

# Deploy the PV and PVC with ReadWriteMany access mode
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $PV_NAME
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany # Set access mode to ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: $STORAGE_CLASS
  hostPath:
    path: /tmp/storage-resilience # Adjust the path as needed
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $PVC_NAME
spec:
  accessModes:
    - ReadWriteMany # Set access mode to ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: $STORAGE_CLASS
EOF


# Wait for the PV and PVC to be bound
while [[ $(kubectl get pv -n "$NAMESPACE" $PV_NAME -o 'jsonpath={..status.phase}') != "Bound" ]] || [[ $(kubectl get pvc -n "$NAMESPACE" $PVC_NAME -o 'jsonpath={..status.phase}') != "Bound" ]]; do
  echo "Waiting for PV/PVC to be bound..."
  sleep 1
done

# Deploy the first pod with an empty PVC
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: first-pod
spec:
  nodeSelector:
    kubernetes.io/hostname: $NODE1 # Ensure it runs on Node1
  containers:
    - name: my-container
      image: busybox
      command: ["/bin/sh", "-c", "echo 'Hello from First Pod' > /data/data.txt && sleep 600"]
      volumeMounts:
        - name: my-volume
          mountPath: /data
  volumes:
    - name: my-volume
      persistentVolumeClaim:
        claimName: $PVC_NAME
EOF

# Wait for the first pod to be running
kubectl wait --for=condition=Ready -n "$NAMESPACE" pod/first-pod --timeout=120s

# Check if data exists in the first pod
FIRST_POD_DATA=$(kubectl exec -n "$NAMESPACE" pod/first-pod -- cat /data/data.txt)

if [ "$FIRST_POD_DATA" == "Hello from First Pod" ]; then
  print_result "Data in First Pod: Passed" true
else
  print_result "Data in First Pod: Failed" false
  exit 1
fi

# Delete the first pod to simulate rescheduling
kubectl delete -n "$NAMESPACE" pod/first-pod

# Wait for the first pod to be deleted
kubectl wait --for=delete -n "$NAMESPACE" pod/first-pod

# Deploy the second pod with nodeSelector to ensure it runs on Node2
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: second-pod
spec:
  nodeSelector:
    kubernetes.io/hostname: $NODE2 # Specify the node you want to use for scheduling
  containers:
    - name: my-container
      image: busybox
      command: ["/bin/sh", "-c", "sleep 600"]
      volumeMounts:
        - name: my-volume
          mountPath: /data
  volumes:
    - name: my-volume
      persistentVolumeClaim:
        claimName: $PVC_NAME
EOF

# Wait for the second pod to be running
kubectl wait --for=condition=Ready -n "$NAMESPACE" pod/second-pod --timeout=60s

# Check if data exists in the second pod
SECOND_POD_DATA=$(kubectl exec -n "$NAMESPACE" pod/second-pod -- cat /data/data.txt)

if [ "$SECOND_POD_DATA" == "Hello from First Pod" ]; then
  print_result "Data in Second Pod: Passed" true
else
  print_result "Data in Second Pod: Failed" false
  exit 1
fi

# Clean up
kubectl delete -n "$NAMESPACE" pod/second-pod
kubectl delete -n "$NAMESPACE" pvc/$PVC_NAME
kubectl delete namespace "$NAMESPACE"

print_result "Storage Resilience Test: Completed" true
