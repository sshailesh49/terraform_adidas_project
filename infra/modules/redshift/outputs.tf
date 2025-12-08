output "workgroup_endpoint" {
  value = aws_redshiftserverless_workgroup.wg.endpoint[0].address
}

output "workgroup_port" {
  value = aws_redshiftserverless_workgroup.wg.endpoint[0].port
}

output "database_name" {
  value = aws_redshiftserverless_namespace.ns.db_name
}

output "master_username" {
  value = aws_redshiftserverless_namespace.ns.admin_username
}
output "workgroup_name" {
  value = aws_redshiftserverless_workgroup.wg.workgroup_name
}
