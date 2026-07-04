#Monitoring module

#Cloud watch log group for application log
resource "aws_cloudwatch_log_group" "application" {
  name = "aws/ec2/${var.environment}-application"
  retention_in_days = 7

  tags = {
    Name = "${var.environment}-application-logs"
    Environment = var.environment
  }
}