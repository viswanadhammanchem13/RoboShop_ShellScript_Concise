#!/bin/bash
app_type=mysql

source ./Common.sh

echo "Please Enter Root Password to SetUp"
read -s MYSQL_ROOT_PWD

Check_Root

dnf install mysql-server -y &>>$LOG_FILE
Validate $? "MYSQL Installation"

systemctl enable mysqld &>>$LOG_FILE
Validate $? "Enabling MYSQL Service"

systemctl start mysqld &>>$LOG_FILE
Validate $? "Starting MYSQL Service"

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PWD &>>$LOG_FILE
Validate $? "Creating MYSQL Password"

Print_Time
