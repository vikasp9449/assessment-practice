# assessment-practice
Container Validation
Docker Build
docker build -t sample-service:v1 .

Health Check
curl localhost:8080/health

Response:

{"status":"UP"}

Vulnerability Scan
Tool: Trivy

Result: No CRITICAL vulnerabilities found.

Accepted Findings: None




Secret Manager stores secrets.

Cloud Run runtime service account receives:

roles/secretmanager.secretAccessor

Cloud Run references Secret Manager at runtime.


Terraform State Strategy
Remote Backend: GCS Bucket

Environment Separation: Separate state prefixes

dev/state.tfstate prod/state.tfstate

Locking: Terraform state locking via GCS generation checks.

Change Control: PR review → Terraform Plan → Approval → Apply.




CI/CD
Pull Request:

Unit tests
Terraform validation
Terraform tests
Docker build
Trivy scan
Main Branch:

Build immutable image
Terraform plan
Manual approval
Terraform apply
Cloud Run deployment
Authentication:

GitHub OIDC
Workload Identity Federation
Rollback:

Cloud Run revision rollback
Concurrency:

Single production deployment at a time



## Actual OIDC Setup
gcloud iam workload-identity-pools create github-pool \
  --location=global

gcloud iam workload-identity-pools providers create-oidc github-provider \
  --location=global \
  --workload-identity-pool=github-pool \
  --issuer-uri=https://token.actions.githubusercontent.com

gcloud iam service-accounts create github-deployer

gcloud iam service-accounts add-iam-policy-binding \
github-deployer@PROJECT_ID.iam.gserviceaccount.com \
--role=roles/iam.workloadIdentityUser \
--member="principalSet://iam.googleapis.com/..."


Terraform init:
terraform init "-backend-config=environments/dev/backend.tfbackend" -reconfigure

