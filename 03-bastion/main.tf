module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]

  #convert StringList to List and get the first element
  # subnet_id              = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
  subnet_id              = local.public_subnet_id

  # data.aws_ssm_parameter.public_subnet_ids.value --> subnet-0fb5e440bc039f2f0,subnet-07a1adf2e5ade5fe5
  # split(",", data.aws_ssm_parameter.public_subnet_ids.value) -->
  # ["subnet-0fb5e440bc039f2f0",
  #  "subnet-07a1adf2e5ade5fe5"
  # ]
  #
  # element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0) -->
  # ["subnet-0fb5e440bc039f2f0"
  # ]

  ami       = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}