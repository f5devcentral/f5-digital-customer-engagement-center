output "harness_tfvars" {
  value       = local_file.harness_tfvars.filename
  description = <<EOD
The name of the generated harness.tfvars file that will be a common input to all
test fixtures.
EOD
}
