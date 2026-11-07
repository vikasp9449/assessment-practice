run "service_name_test" {

  assert {
    condition     = module.cloudrun.service_name != ""
    error_message = "Service name should not be empty"
  }
}

run "environment_test" {

  assert {
    condition     = var.max_instances > 0
    error_message = "Max instances must be greater than zero"
  }
}