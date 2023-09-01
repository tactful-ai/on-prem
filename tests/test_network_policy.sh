#!/bin/bash

source ./tests/utils_testing.sh

# Namespace name
NAMESPACE="network-policy-test"

# Deploy the namespace
kubectl create namespace "$NAMESPACE"

# Deploy two pods in the namespace
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod1
  labels:
    app: pod1
spec:
  containers:
    - name: container
      image: nginx
      ports:
        - containerPort: 80
EOF

kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod2
  labels:
    app: pod2
spec:
  containers:
    - name: container
      image: nginx
      ports:
        - containerPort: 80
EOF

# Deploy services for pod1 and pod2
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: pod1-svc
spec:
  selector:
    app: pod1
  ports:
    - protocol: TCP
      port: 80
EOF

kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: pod2-svc
spec:
  selector:
    app: pod2
  ports:
    - protocol: TCP
      port: 80
EOF

# Create a network policy to allow traffic between pods using labels
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-pod1-pod2
spec:
  podSelector:
    matchLabels:
      app: pod1
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: pod2
EOF

echo "Services and network policy created."

# Ping from pod1 to pod2's service (should pass)
if kubectl exec -n "$NAMESPACE" pod/pod1 -- curl --connect-timeout 60 -s http://pod2-svc; then
  print_result "Ping test before network policy" true
else
  print_result "Ping test before network policy" false
fi


# Apply a network policy to deny traffic between pods
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-pod1-pod2
spec:
  podSelector:
    matchLabels:
      app: pod2
  ingress:
    - from:
        - podSelector:
            matchLabels:
              access: "true"
EOF

# Ping from pod1 to pod2's service (should fail)
if kubectl exec -n "$NAMESPACE" pod/pod1 -- curl --connect-timeout 10 -s http://pod2-svc; then
  print_result "Ping test after network policy (unexpected pass)" false
else
  print_result "Ping test after network policy (expected fail)" true
fi

# # Clean up
kubectl delete -n "$NAMESPACE" pod/pod1
kubectl delete -n "$NAMESPACE" pod/pod2
kubectl delete -n "$NAMESPACE" service/pod1-svc
kubectl delete -n "$NAMESPACE" service/pod2-svc
kubectl delete -n "$NAMESPACE" networkpolicy/allow-pod1-pod2
kubectl delete -n "$NAMESPACE" networkpolicy/deny-pod1-pod2
kubectl delete namespace "$NAMESPACE"
