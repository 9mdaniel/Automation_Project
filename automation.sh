#!/bin/sh

#update all
sudo apt update -y

#install apache2 if not already installed
dpkg -s apache2 &> /dev/null  

    if [ $? -ne 0 ]

        then
            #echo "not installed"  
			sudo apt install apache2

        else
            echo    "already installed apache2"
    fi

#Ensure that the apache2 service is running and enabled
servstat=$(service apache2 status)
s3_bucket="upgrad-daniel"
myname="daniel"
timestamp=$(date '+%d%m%Y-%H%M%S')

if [[ $servstat == *"active (running)"* ]]; then
  echo "process is running"
  find . -iname '*.log' -print0 | xargs -0 tar -cvf - ./var/log/apache2/* > /tmp/${myname}-httpd-logs-${timestamp}.tar
fi



#S3 bucket copy
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar