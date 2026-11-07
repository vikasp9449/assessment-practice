# 1. Mock the GCP Provider to run locally without requiring GCP credentials
mock_provider "google" {}

# 2. Define global test inputs passed into the root module
variables {
  project_id            = "optum-test-project"
  service_name          = "stateless-app"
  image                 = "us-central1-docker.pkg.dev/optum-test-project/app-repo/service:latest"
  cpu                   = "1000m"
  memory                = "512Mi"
  timeout               = 300
  concurrency           = 80
  min_instances         = 1
  max_instances         = 10
  ingress_type          = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  allow_unauthenticated = false
}

# Run 1: Test Service Account Naming & Resource Naming in Dev
run "verify_dev_naming_convention" {
  command = plan

  variables {
    environment = "dev"
  }

  assert {
    condition     = module.cloud_run.service_name == "stateless-app-dev"
    error_message = "Cloud Run service name output must match pattern {service_name}-{environment}."
  }

  assert {
    condition     = module.cloud_run.service_account == "stateless-app-dev-sa@optum-test-project.iam.gserviceaccount.com"
    error_message = "Runtime service account email does not match expected naming convention."
  }
}

# Run 2: Test Security Ingress & Least Privilege Access Controls in Prod
run "verify_prod_security_controls" {
  command = plan

  variables {
    environment           = "prod"
    ingress_type          = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
    allow_unauthenticated = false
  }

  assert {
    condition     = module.cloud_run.service_name == "stateless-app-prod"
    error_message = "Cloud Run service name in prod must include the prod environment suffix."
  }
}