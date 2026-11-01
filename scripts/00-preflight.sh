#!/usr/bin/env bash
# Pre-exam check: tools installed, Docker + Kubernetes up, Jenkins running
source "$(dirname "$0")/lib.sh"

banner "TOOL VERSIONS"
run 'git --version'
run 'docker --version'
run 'kubectl version --client | head -1'
run 'terraform -version | head -1'
run 'ansible --version | head -1'

banner "DOCKER ENGINE"
run 'docker info --format "Server version: {{.ServerVersion}}"'

banner "KUBERNETES CLUSTER"
run 'kubectl get nodes'

banner "JENKINS"
if [ "$(docker ps -q -f name=^jenkins$)" ]; then
  ok "Jenkins container is running"
else
  run 'docker start jenkins'
  ok "Jenkins started (give it ~30s before opening it)"
fi
echo "Open: http://localhost:8080"

ok "Preflight complete - ready for the demo"
