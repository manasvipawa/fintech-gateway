# Fintech Instant Payment Gateway — Section B Live Demo Guide

Run everything from inside the `fintech-gateway/` folder. Each task lists the commands to type and what to show the examiner.

```
fintech-gateway/
├── Dockerfile            # Task 4
├── Jenkinsfile           # Task 3
├── k8s/deployment.yaml   # Task 5
└── terraform/main.tf     # Task 6
```

---

## Task 1 — Git (2 marks)

```bash
cd fintech-gateway
git init
git config user.name  "manasvipawa"
git config user.email "manasvi.pawa@gmail.com"

git add .
git commit -m "Initial commit: pipeline scaffolding"
git branch -M main

git checkout -b release-v1.0
echo "SETTLEMENT_CORE=ACTIVE" > gateway.conf
git add gateway.conf
git commit -m "Add gateway.conf with SETTLEMENT_CORE=ACTIVE"

git checkout main
git merge --no-ff release-v1.0 -m "Merge release-v1.0 into main"
git tag -a v1.0.0-final -m "Release v1.0.0-final: settlement core active"
```

**Show:**
```bash
git log --oneline --graph --all
git tag -n
git show v1.0.0-final --stat
cat gateway.conf
```

> Optional: push to GitHub so Jenkins can pull it:
> `git remote add origin https://github.com/manasvipawa/fintech-gateway.git && git push -u origin main --tags`

---

## Task 2 — Jira (1 mark) — done in the Jira web UI

1. Open your Scrum project → **Board** (active sprint).
2. Drag **PAY-101** and **PAY-102** into the **Done** column.
   (Create them first if they don't exist: Backlog → Create issue → add to sprint → Start sprint.)
3. Click **Complete sprint** (top-right of the board) → confirm.
4. Go to **Reports → Burndown Chart**, select the sprint you just completed.

**What to say about the burndown:** the guideline line falls straight to zero; the actual line steps down each time a ticket moves to Done. Ending at zero means all committed work was completed within the sprint.

---

## Task 3 — Jenkins Declarative Pipeline (2 marks)

`Jenkinsfile` uses `agent any` and has the three stages: **Build & Unit Test**, **Docker Build**, **Cluster Deploy**.

1. Jenkins → **New Item** → name `fintech-gateway-pipeline` → **Pipeline** → OK.
2. Under **Pipeline**, choose one:
   - **Pipeline script from SCM** → Git → your repo URL → branch `*/main` → Script Path `Jenkinsfile`, **or**
   - **Pipeline script** → paste the Jenkinsfile contents (then the workspace needs the project files; SCM is easier).
3. **Save → Build Now**.

**Show:** Stage View with all three stages green, and the Console Output containing `Unit test PASSED` and `kubectl get all -l tier=payment`.

> Jenkins needs `docker` and `kubectl` access. On Linux: `sudo usermod -aG docker jenkins && sudo systemctl restart jenkins`, and copy your kubeconfig to `/var/lib/jenkins/.kube/config` (owned by jenkins).

---

## Task 4 — Docker (2 marks)

```bash
docker build -t fintech-gateway:v1.0 .
docker run -d --name fintech-gateway -p 8081:80 fintech-gateway:v1.0
docker ps
```

**Show:**
```bash
docker ps --filter name=fintech-gateway
docker logs fintech-gateway          # prints: Payment Settlement Active
curl http://localhost:8081           # returns: Payment Settlement Active
```

Re-running? Clean up first: `docker rm -f fintech-gateway`

---

## Task 5 — Kubernetes (2 marks)

Start a cluster if needed: `minikube start` (or Docker Desktop's Kubernetes / kind).

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get all -l tier=payment
```

Expected: 2 pods `Running`, deployment `2/2`, service `payment-service` type `NodePort` with `80:30091/TCP`.

**Access it:**
- minikube: `minikube service payment-service --url` (or `curl $(minikube ip):30091`)
- Docker Desktop: `curl http://localhost:30091`

---

## Task 6 — IaC: Terraform + Ansible (1 mark)

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

Creates `terraform/payment.env` containing `URL=http://localhost:30091`.

**Verify with an Ansible ad-hoc command:**
```bash
ansible localhost -m command -a "cat payment.env"
```
or the more "Ansible-native" check:
```bash
ansible localhost -m ansible.builtin.slurp -a "src=payment.env"
```
(`slurp` returns base64; the `command` version is easier to read live.)

**Talking point:** `terraform.tfstate` now records that `payment.env` exists — run `terraform plan` again and it reports "No changes".

---

## Quick pre-exam checklist

```bash
git --version && docker --version && kubectl version --client \
  && terraform -version && ansible --version
```
Make sure Jenkins is running, the K8s cluster is up, and Docker Desktop/daemon is started before the clock begins.
