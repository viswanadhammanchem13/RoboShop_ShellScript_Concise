#!/bin/bash

app_type=shipping

app_Service=Shipping

source ./Common.sh

App_Setup

Check_Root

echo "Please Enter Root Password to SetUp"
read -s MYSQL_ROOT_PWD

Maven_Setup

Systemd_Setup

dnf install mysql -y  &>>$LOG_FILE
Validate $? "Install MySQL"

mysql -h mysql.manchem.site -u root -p$MYSQL_ROOT_PWD -e 'use cities' &>>$LOG_FILE
if [ $? -eq 0 ]
then
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
else
    echo -e "Data is Not loaded into MySQL ... $Y Loading $N"
    mysql -h mysql.manchem.site -uroot -p$MYSQL_ROOT_PWD < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.manchem.site -uroot -p$MYSQL_ROOT_PWD < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.manchem.site -uroot -p$MYSQL_ROOT_PWD < /app/db/master-data.sql &>>$LOG_FILE
fi
Validate $? "Loading data into MySQL"

systemctl restart $app_type &>>$LOG_FILE
Validate $? "Restarting $app_type  Service"

Print_Time

