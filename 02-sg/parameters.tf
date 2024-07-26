resource "aws_ssm_parameter" "db_sg_id" {
  name  = "/${var.project_name}/${var.environment}/db_sg_id"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "String"    ## AWS Notation -- type = "String"
  value = module.db.sg_id
}

resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/backend_sg_id"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "String"    ## AWS Notation -- type = "String"
  value = module.backend.sg_id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/frontend_sg_id"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "String"    ## AWS Notation -- type = "String"
  value = module.frontend.sg_id
}