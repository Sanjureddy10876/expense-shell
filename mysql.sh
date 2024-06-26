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

echo "Please Enter DB password:"
read -s mysql_root_password

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

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysqld"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysqld"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "setting root password"

#Below code will be useful for idempotent nature

mysql -h db.santhosh78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL root password setup"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N"
fi