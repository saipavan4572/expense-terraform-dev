resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "String"    ## AWS Notation -- type = "String"
  value = module.vpc.vpc_id
}