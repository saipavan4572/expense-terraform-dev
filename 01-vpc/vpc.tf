module "vpc" {
    #source = "../terraform-aws-vpc"     #if working in local we can give module location path
    source = "git::https://github.com/saipavan4572/terraform-aws-vpc?ref=main"

    project_name = var.project_name
    common_tags = var.common_tags
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = var.is_peering_required
    ## here we are passing the peering value as true so it will connect to the default VPC in the account. 
}