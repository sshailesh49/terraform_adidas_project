output "api_invoke_url" {
  value = module.apigw.api_invoke_url
}


output "sqs_queue_url" {
  value = module.sqs.queue_url
}


output "redshift_workgroup" {
  value = module.redshift.workgroup_endpoint
}