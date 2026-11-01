#!/usr/bin/env bash
# Task 4 - Docker: build fintech-gateway:v1.0, run detached on 8081:80, verify
source "$(dirname "$0")/lib.sh"

banner "TASK 4: DOCKER BUILD & RUN"
run 'cat Dockerfile'
run 'docker rm -f fintech-gateway >/dev/null 2>&1 || true'   # clean slate for a re-run
run 'docker build -t fintech-gateway:v1.0 .'
run 'docker run -d --name fintech-gateway -p 8081:80 fintech-gateway:v1.0'
sleep 2

banner "VERIFICATION"
run 'docker ps --filter name=^fintech-gateway$'
run 'docker logs fintech-gateway'
run 'curl -s http://localhost:8081'

ok "Task 4 done: container Up on 0.0.0.0:8081->80"
