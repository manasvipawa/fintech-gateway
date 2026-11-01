#!/usr/bin/env bash
# Task 5 - Kubernetes: 2 replicas of nginx:alpine (tier=payment) behind NodePort 30091
source "$(dirname "$0")/lib.sh"

banner "TASK 5: KUBERNETES DEPLOYMENT + NODEPORT"
run 'kubectl get nodes'
run 'cat k8s/deployment.yaml'
run 'kubectl apply -f k8s/deployment.yaml'
run 'kubectl rollout status deployment/payment-deployment --timeout=120s'

banner "VERIFICATION"
run 'kubectl get all -l tier=payment'
run 'curl -s http://localhost:30091 | grep -o "<title>.*</title>" || echo "(open http://localhost:30091 in the browser)"'

ok "Task 5 done: 2/2 pods Running, Service NodePort 80:30091"
