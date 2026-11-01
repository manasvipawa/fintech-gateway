#!/usr/bin/env bash
# Task 1 - Git: release branch, gateway.conf, --no-ff merge, annotated tag
# Runs in a fresh demo repo (workspace/upi-gateway) so it can be repeated live
source "$(dirname "$0")/lib.sh"

REPO="$ROOT/workspace/upi-gateway"
rm -rf "$REPO"
mkdir -p "$REPO"
cd "$REPO"

banner "TASK 1: GIT RELEASE BRANCHING"
run 'git init -q -b main'
run 'git config user.name "manasvipawa"'
run 'git config user.email "manasvi.pawa@gmail.com"'
run 'git commit -q --allow-empty -m "chore: initial commit"'   # main needs a base to merge into

run 'git checkout -b release-v1.0'
run 'echo "SETTLEMENT_CORE=ACTIVE" > gateway.conf'
run 'git add gateway.conf'
run 'git commit -m "feat: add gateway.conf with SETTLEMENT_CORE=ACTIVE"'

run 'git checkout main'
run 'git merge --no-ff release-v1.0 -m "Merge branch release-v1.0 into main"'
run 'git tag -a v1.0.0-final -m "Release v1.0.0-final: settlement core active"'

banner "VERIFICATION"
run 'git log --oneline --graph --all --decorate'
run 'git tag -n'
run 'git show v1.0.0-final --stat --no-patch'
run 'cat gateway.conf'

ok "Task 1 done: branch merged with --no-ff and tagged v1.0.0-final"
