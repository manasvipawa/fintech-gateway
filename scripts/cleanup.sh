#!/usr/bin/env bash
# Reset everything so the demo can be run again from scratch
# (Jenkins is left running on purpose)
source "$(dirname "$0")/lib.sh"
set +e   # keep going even if something is already gone

banner "CLEANUP"
run 'docker rm -f fintech-gateway'
run 'kubectl delete -f k8s/deployment.yaml --ignore-not-found'
run '(cd terraform && terraform destroy -auto-approve)'
run 'rm -rf workspace/upi-gateway'

ok "Clean - ready to run the scripts again"
