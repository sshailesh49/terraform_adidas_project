resource "aws_redshiftserverless_workgroup" "wg" {
  workgroup_name = "${var.project_name}-workgroup"
  base_capacity  = 8
  namespace_name = aws_redshiftserverless_namespace.ns.namespace_name
}


resource "aws_redshiftserverless_namespace" "ns" {
  namespace_name      = "${var.project_name}-ns"
  admin_username      = var.redshift_master_username
  admin_user_password = var.redshift_master_password
  db_name             = "dev"
}


