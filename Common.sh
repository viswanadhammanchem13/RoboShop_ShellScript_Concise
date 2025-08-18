#!/bin/bash
START_TIME=$(date +%s)
USERID=$(id -u) #Stores User UID
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_Folder="/var/log/RoboShop_ShellScript_Concise"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_Folder/$SCRIPT_NAME.log"
mkdir -p $LOGS_Folder
SCRIPT_DIR=$PWD

echo -e  "$R Script Executed at:$START_TIME $N" | tee -a $LOG_FILE # Tee command Display the content on Screen

App_Setup(){

    id roboshop
    if [ $? -eq 0 ]
    then
        echo "Roboshop user is already created...Skipping"
    else 
        echo "Roboshop user is not created...Creating"
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        Validate $? "Creating Roboshop user"
    fi

    mkdir  -p /app
    Validate $? "Creating /app Dir"
    curl -o /tmp/$app_type.zip https://roboshop-artifacts.s3.amazonaws.com/$app_type-v3.zip &>>$LOG_FILE
    Validate $? "Downloading the $app_type Code"

    rm -rf /app/*
    cd /app &>>$LOG_FILE
    unzip /tmp/$app_type.zip &>>$LOG_FILE
    Validate $? "Unzip the Code"
}

NodeJS_Setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    Validate $? "Disabeling NodeJS"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    Validate $? "Enabling NodeJS:20"

    dnf install nodejs -y &>>$LOG_FILE
    Validate $? "Installling NodeJS"

    npm install &>>$LOG_FILE
    Validate $? "Dependencies installions"
}

Maven_Setup(){
    dnf install maven -y &>>$LOG_FILE
    Validate $? "Installing Maven and Java"

    mvn clean package  &>>$LOG_FILE
    VALIDATE $? "Packaging the shipping application"

    mv target/shipping-1.0.jar shipping.jar  &>>$LOG_FILE
    VALIDATE $? "Moving and renaming Jar file
}

Systemd_Setup(){
    cp $SCRIPT_DIR/$app_Service.Service /etc/systemd/system/$app_type.service &>>$LOG_FILE
    Validate $? "Coping $app_type Service"

    systemctl daemon-reload &>>$LOG_FILE
    Validate $? "System Daemon Reload"

    systemctl enable $app_type &>>$LOG_FILE
    Validate $? "Enabling $app_type Service"

    systemctl start $app_type &>>$LOG_FILE
    Validate $? "Starting $app_type Service"

}


Check_Root(){
    if [ $USERID -ne 0 ] #Checks Whether UID is = 0 or not
    then #!= 0 Enter into Loop
        echo -e "$R Error:Please Proceed the Installation with Sudo Access.. $N" | tee -a $LOG_FILE #Prints this messages on Screen
        exit 1 #!= 0 Don't Proceed with next command and Exit
    else #If =0 Enter into else loop
        echo -e "$Y  You Have Sudo Access..Please proceed the Installation $N" | tee -a $LOG_FILE #Prints this messages on Screen
    fi #Condition Ends
}

Validate (){ #Function Definition
    if [ $1 -eq 0 ] #Checks If Exit code equls to Zero, Yes
    then #Enter into Loop
        echo -e "$G $2...... is successful $N"  | tee -a $LOG_FILE #Prints this messages on Screen
    else #Checks If Exit code != Zero, No
        echo -e " $R $2 ......is failed $N" | tee -a $LOG_FILE #Prints this messages on Screen
        exit 1 #Condition Exits and Entire Script Fails.
    fi #Condition Ends
}
Print_Time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))

    echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE
}