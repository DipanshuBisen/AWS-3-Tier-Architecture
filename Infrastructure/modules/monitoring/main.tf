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

#RDS cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name = "${var.environment}-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/RDS"
  period = "300"
  statistic = "Average"
  threshold = "80"
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = []

  dimensions = {
    DBInstanceIdentifie = var.rds_instance_id
  }

  tags = {
    Name        = "${var.environment}-rds-cpu-alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "reds_memory" {
  alarm_name = "${var.environment}-rds-low-memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "2"
  metric_name = "FreeableMemory"
  namespace = "AWS/RDS"
  period = "300"
  statistic = "Average"
  threshold = "268435456" # 256MB in bytes
  alarm_description = "This metric monitors RDS free memory"
  alarm_actions = []
   
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  tags = {
    Name        = "${var.environment}-rds-memory-alarm"
    Environment = var.environment
  }
}