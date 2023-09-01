#!/bin/bash

source ./tests/utils_testing.sh

# Namespace name
NAMESPACE="shared-namespace"

# PVC and StorageClass names
PVC_NAME="my-shared-pvc"

# Create the namespace
kubectl create namespace "$NAMESPACE"

# Deploy the PVC
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $PVC_NAME
  namespace: $NAMESPACE
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: $STORAGE_CLASS
  resources:
    requests:
      storage: 1Gi
EOF

# Wait for the PVC to be bound
while [[ $(kubectl get pvc -n "$NAMESPACE" $PVC_NAME -o 'jsonpath={..status.phase}') != "Bound" ]]; do echo "waiting for PVC status" && sleep 1; done


# Deploy the pods in the namespace
for POD_NAME in "pod1" "pod2"; do
  kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: $POD_NAME
  namespace: $NAMESPACE
spec:
  containers:
    - name: container
      image: busybox
      command: ["/bin/sh", "-c", "while true; do sleep 3600; done"]
      volumeMounts:
        - name: shared-volume
          mountPath: /data
  volumes:
    - name: shared-volume
      persistentVolumeClaim:
        claimName: $PVC_NAME
EOF
done

# Wait for the pods to be ready
for POD_NAME in "pod1" "pod2"; do
  kubectl wait --for=condition=Ready -n "$NAMESPACE" pod/$POD_NAME --timeout=120s
done


# Execute commands in the first pod
kubectl exec -n "$NAMESPACE" pod/pod1 -- /bin/sh -c "mkdir -p /data/myfolder && echo 'Data written by Pod1' > /data/myfolder/data.txt"

# Execute commands in the second pod and validate the write
READ_DATA=$(kubectl exec -n "$NAMESPACE" pod/pod2 -- /bin/sh -c "cat /data/myfolder/data.txt")

# Validate the read data
EXPECTED_DATA="Data written by Pod1"
if [ "$READ_DATA" == "$EXPECTED_DATA" ]; then
  print_result "Pod2 can Read Data wriiten By pod1." true
else
  print_result "Validation failed: Data does not match. the expected was: $EXPECTED_DATA  but found: $READ_DATA " false
fi

# Execute commands in the second pod to write data
kubectl exec -n "$NAMESPACE" pod/pod2 -- /bin/sh -c "echo 'Data written by Pod2' > /data/myfolder/data.txt"

# Execute commands in the first pod and validate the write
READ_DATA=$(kubectl exec -n "$NAMESPACE" pod/pod1 -- /bin/sh -c "cat /data/myfolder/data.txt")

# Validate the read data
EXPECTED_DATA="Data written by Pod2"
if [ "$READ_DATA" == "$EXPECTED_DATA" ]; then
  print_result "Pod1 can Read Data wriiten By pod2." true
else
  print_result "Validation failed: Data does not match. the expected was: $EXPECTED_DATA  but found: $READ_DATA " false
fi

# Clean up
kubectl delete -n "$NAMESPACE" pod/pod1
kubectl delete -n "$NAMESPACE" pod/pod2
kubectl delete -n "$NAMESPACE" pvc/$PVC_NAME
kubectl delete namespace "$NAMESPACE"
