#!/bin/bash

source ./Common.sh
Check_Root
app_type=mongoDB
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>LOG_FILE
Validate $? "Coping of MongoDB Repo"

dnf install mongodb-org -y &>>LOG_FILE
Validate $? "MongoDB Installation"

systemctl enable mongod | tee -a $LOG_FILE
Validate $? "MongoDB Service Enabled" 

systemctl start mongod | tee -a $LOG_FILE
Validate $? "MongoDB Service Started" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
Validate $? "Editing MongoDB conf file for remote connections"

systemctl restart mongod
Validate $? "MongoDB Service ReStarted" 

Print_Time