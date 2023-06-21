#!/bin/bash
# AWS region and ALB/NLB information
REGION="Your aws region"
LOAD_BALANCER_ARN="Your Load balancer ARN"
TARGET_GROUP_ARN1="Your Target Group ARN"
TARGET_GROUP_ARN2="Your Target Group ARN "
INSTANCE_ID="your instance id"
#// start the ec2 instance and validate the instance state "running" or not
aws ec2 start-instances --instance-ids $INSTANCE_ID
#//health check pass 200 from instance
sleep 15
while true
do
  STATUS1=$(curl -s -o /dev/null -w "%{http_code}"http://Ip1:8088/service1/)
  STATUS2=$(curl -s -o /dev/null -w "%{http_code}" http://Ip2:8087/service2/)
    if [ $STATUS1 -eq 200 ] && [ $STATUS2 -eq 200 ] ; then

      break
      else
      sleep 1
      fi
      echo "waiting for health check"
      done
      echo "health check passed"
#      // register the instance to target group
      aws elbv2 register-targets --target-group-arn $TARGET_GROUP_ARN1 --targets Id=$INSTANCE_ID
      aws elbv2 register-targets --target-group-arn $TARGET_GROUP_ARN2 --targets Id=$INSTANCE_ID
      echo "registered to target group"
exit
