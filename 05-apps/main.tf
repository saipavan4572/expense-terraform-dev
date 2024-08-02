module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-backend"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]

  #convert StringList to List and get the first element
  # subnet_id              = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
  subnet_id              = local.private_subnet_id

  ami       = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        name = "${var.project_name}-${var.environment}-backend"
    }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-frontend"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  #convert StringList to List and get the first element
  # subnet_id              = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
  subnet_id              = local.public_subnet_id

  ami       = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-ansible"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]

  #convert StringList to List and get the first element
  # subnet_id              = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
  subnet_id              = local.public_subnet_id

  ami       = data.aws_ami.ami_info.id
  user_data = file("expense.sh")
  ## after creating the AWS instance immediately it will run the commands/script file specified in user_data section during the AWS instance creation.

  tags = merge(
    var.common_tags,
    {
        name = "${var.project_name}-${var.environment}-ansible"
    }
  )
  depends_on = [module.backend, module.frontend]
  ## terraform try to create all the modules paralally. Usually ansible should create after the backend and frontend modules so by adding the depends_on parameter it will create ansible after backend & frontend creation.
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend.private_ip
      ]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.private_ip
      ]
    },
              ## this record is needed if we use "frontend.pspkdevops.online" in expense-ansible-roles - inventory.ini file, otherwise we can map private ip instead of public ip to pspkdevops.online as below.

    {
      name    = ""  #pspkdevops.online
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip
      ]
    },
          # {
          #   name    = ""  #pspkdevops.online
          #   type    = "A"
          #   ttl     = 1
          #   records = [
          #     module.frontend.private_ip
          #   ]
          # },
  ]

}