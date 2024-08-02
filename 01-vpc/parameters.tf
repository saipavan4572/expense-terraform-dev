resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "String"    ## AWS Notation -- type = "String"
  value = module.vpc.vpc_id
}

## list in terraform datatype --> String and value like --> ["id1","id2"]
## list in AWS parameter store datatype --> StringList and value like --> id1,id2
## the values from the terraform need to be stored into AWS parameter store so we need convert to the AWS datatype and then store.
resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "StringList"    ## AWS Notation -- type = "String"
  value = join("," ,module.vpc.public_subnet_ids)   ##converting list to StringList
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "StringList"    ## AWS Notation -- type = "String"
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"    ## ex: vpc-0f3218f3f5776f9a5
  type  = "String"    ## AWS Notation -- type = "String"
  value = module.vpc.database_subnet_group_name
}