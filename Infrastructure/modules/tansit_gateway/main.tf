#Transit gateway for both vpc
resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway for VPCs"

  amazon_side_asn = 64512
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "${var.environment}-transit-gateway"
    Environment = var.environment
  }
}

#VPC attachment to transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "bastion" {
  subnet_ids = module.bastion_vpc.public_subnet_id
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = module.bastion_vpc.bastion_vpc_id

  tags = {
    Name= "${var.environment}-vpc_bastion_attachment"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids = [ module.vpc.private_subnet_ids ]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.environment}-vpc-main-attachment"
    Environment = var.environment
  }
}

#Add Routes for both VPCs
resource "aws_route" "bastion_to_main" {
  route_table_id = module.bastion_vpc.bastion_public_route_table_id
  destination_cidr_block = var.vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "main_to_bastion" {
  route_table_id = [ module.vpc.private_route_table_ids ]
  destination_cidr_block = var.bastion_vpc_cidr
  transit_gateway_id = aws_ec2_transit_gateway.main.id
}