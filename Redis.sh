#!/bin/bash

app_type=redis

sudo ./Common.sh

Check_Root

dnf module disable redis -y &>>$LOG_FILE
Validate $? "Disabling Redis"

dnf module enable redis:7 -y &>>$LOG_FILE
Validate $? "Enabling Redis"

dnf install redis -y &>>$LOG_FILE
Validate $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
Validate $? "Edited redis.conf to accept remote connections"

systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE
Validate $? "Starting Redis Service"

Print_Time
