#!/bin/bash

app_type= Catalogue

source ./Common.sh

Check_Root

NodeJS_Setup

App_Setup

Systemd_Setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>LOG_FILE
Validate $? "Coping MongoDB Repo"

dnf install mongodb-mongosh -y
Validate $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.daws84s.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -eq 0 ]
then
    echo " Data is Already Loaded"
else
    echo "Data is Not Loaded..Loading"
    mongosh --host mongodb.manchem.site  </app/db/master-data.js
    Validate $? "Loading the Data"
fi

Print_Time

