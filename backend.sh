#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename "$0" .sh)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
C="\e[36m"
W="\e[37m"
N="\033[0m"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2....$R FAILED $N"
        exit 1 
    else 
        echo -e "$2....$G SUCCESS $N"
    fi
}
if [ $USERID -ne 0 ]
then 
    echo "Please run this script with root access."
    exit 1 #manuvally exit if error comes
else
    echo "You are the super user."
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodjs"

dnf module enable nodejs:20 -y &>>$LOGFILE

VALIDATE $? "enabling nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installing nodejs"

id expense
if [ $? -ne 0]
then useradd expense &>>$LOGFILE
     VALIDATE $? "creating user expense"
else 
    echo -e "user expense already created.. $Y SKIPPING $N"
fi

#curl -sL https://rpm.nodesource.com/setup