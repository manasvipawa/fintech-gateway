#!/usr/bin/env bash
# Task 3 - Jenkins: make sure Jenkins is up and can reach Docker + Kubernetes
# The pipeline itself is triggered from the Jenkins UI (Build Now)
source "$(dirname "$0")/lib.sh"

banner "TASK 3: JENKINS DECLARATIVE PIPELINE"
if [ -z "$(docker ps -q -f name=^jenkins$)" ]; then
  run 'docker start jenkins'
  echo "Waiting for Jenkins to come up..."
  for i in $(seq 1 30); do
    curl -s -o /dev/null http://localhost:8080/login && break
    sleep 2
  done
fi

run 'docker ps --filter name=^jenkins$'

banner "JENKINS CAN REACH DOCKER + KUBERNETES"
run 'docker exec jenkins docker --version'
run 'docker exec jenkins kubectl get nodes'

banner "PIPELINE DEFINITION (Jenkinsfile)"
run 'cat Jenkinsfile'

ok "Now open http://localhost:8080 -> fintech-gateway-pipeline -> Build Now"
echo "   Show: Stage View (3 green stages) + Console Output ending in 'Finished: SUCCESS'"
