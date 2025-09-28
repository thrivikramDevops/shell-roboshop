#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-08b4f075ffdaf44ed"  #Security Group ID

R='\e[31m'
G='\e[32m'
Y='\e[33m'
N='\e[0m'

for instance in $@
    do
    INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]' --query 'Instances[0].PrivateIpAddress' --output text)
    if [ $instance != "frontend" ]; then
        echo "Instance $instance is created with Private IP: $INSTANCE_ID"
        IP_ADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$instance" --query 'Reservations[].Instances[].PrivateIpAddress' --output text)
        echo -e "Instance $instance is created with Private IP $R $IP_ADDRESS $N"
    else
        echo "Instance $instance is created with Public IP: $INSTANCE_ID"
        IP_ADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$instance" --query 'Reservations[].Instances[].PublicIpAddress' --output text)
        echo -e "Instance $instance is created with Public IP $R $IP_ADDRESS $N"
    fi
    echo "----------------------------------------------"
    echo "$instance $IP_ADDRESS" 
done