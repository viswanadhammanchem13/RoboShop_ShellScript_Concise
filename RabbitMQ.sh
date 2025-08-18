#!/bin/bash

source ./Common.sh

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
Validate $? "Copying RabbitMQ Repo"

dnf install rabbitmq-server -y
# dnf install rabbitmq-server -y 2>&1 | tee -a $LOG_FILE
Validate $? "Installing RabbitMQ Server"

systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
Validate $? "Enabling and Starting the RabbitMQ Service"

rabbitmqctl add_user roboshop $RABBITMQ_PWD &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
Validate $? "Adding UN and PWD,Permissions Of the RabbitMQ"

Print_Time