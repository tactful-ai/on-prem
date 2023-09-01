#!/bin/bash

source ./tests/utils_testing.sh

# Namespace name
NAMESPACE="metallb-test"

# Deploy the namespace
kubectl create namespace "$NAMESPACE"

# Deploy a simple web application as a test deployment
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
        - name: web-app
          image: nginx
          ports:
            - containerPort: 80
EOF

# Expose the web application using a service with MetalLB (no loadBalancerIP)
kubectl apply -n "$NAMESPACE" -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web-app
  ports:
    - protocol: TCP
      port: 80
  type: LoadBalancer
EOF

# Wait for the LoadBalancer IP to be assigned
LB_IP=""
while [ -z "$LB_IP" ]; do
  LB_IP=$(kubectl -n "$NAMESPACE" get svc/web-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
  sleep 5
done
echo "LoadBalancer IP: $LB_IP"

# Get the name of one of the pods in the namespace
POD_NAME=$(kubectl get -n "$NAMESPACE" pod -l app=web-app -o jsonpath='{.items[0].metadata.name}')

echo "pod name is $POD_NAME"

# Test the web application by accessing it via an internal pod
if kubectl exec -n "$NAMESPACE" "$POD_NAME" -- curl -s http://web-service | grep -q "Welcome to nginx"; then
  print_result "Web application access via LoadBalancer" true
else
  print_result "Web application access via LoadBalancer" false
fi

# Clean up
kubectl delete -n "$NAMESPACE" deployment/web-app
kubectl delete -n "$NAMESPACE" service/web-service
kubectl delete namespace "$NAMESPACE"
