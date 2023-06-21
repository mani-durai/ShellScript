#!/bin/bash
# AWS region and ALB/NLB information
REGION="Your aws region"
LOAD_BALANCER_ARN="Your Load balancer ARN"
TARGET_GROUP_ARN1="Your Target Group ARN"
TARGET_GROUP_ARN2="Your Target Group ARN"
INSTANCE_ID="your instance id"

#//Deregister instance from target group and validate deregister process success and stop the instance
aws elbv2 deregister-targets --region "$REGION"  --target-group-arn "$TARGET_GROUP_ARN1" --targets Id="$INSTANCE_ID"
aws elbv2 deregister-targets --region "$REGION"  --target-group-arn "$TARGET_GROUP_ARN2" --targets Id="$INSTANCE_ID"
while true; do
  state1=aws elbv2 describe-target-health --region "$REGION" --target-group-arn "$TARGET_GROUP_ARN1" --targets Id="$INSTANCE_ID" --query 'TargetHealthDescriptions[*].TargetHealth.State' --output text
  state2=aws elbv2 describe-target-health --region "$REGION" --target-group-arn "$TARGET_GROUP_ARN2" --targets Id="$INSTANCE_ID" --query 'TargetHealthDescriptions[*].TargetHealth.State' --output text
  if [ $state1 == "unused" ] && [ $state2 == "unused" ]; then
      echo "Instance deregistered"
      aws ec2 stop-instances --region "$REGION" --instance-ids "$INSTANCE_ID"
      break
      else
      echo "Instance deregistering"
      sleep 5
      fi
      done
      echo "Instance stopped"
exit 0