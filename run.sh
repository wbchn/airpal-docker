#!/bin/bash

cd /airpal-master/

# auto gen yml using env
if [ ! -f /airpal-master/reference.yml ]
then
cp /airpal-master/reference.example.yml /airpal-master/reference.yml
sed -i "s|MYSQL_USER|root|g" /airpal-master/reference.yml
sed -i "s|MYSQl_PASSWORD|${MYSQL_ENV_MYSQL_ROOT_PASSWORD}|g" /airpal-master/reference.yml
sed -i "s|MYSQL_DB_NAME|${AIRPAL_DB_NAME}|g" /airpal-master/reference.yml
sed -i "s|jdbc:mysql://127.0.0.1:3306/airpaldb|jdbc:mysql://${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}/${AIRPAL_DB_NAME}|g" /airpal-master/reference.yml
sed -i "s|http://presto-coordinator-url.com|${PRESTO_COORDINATOR_URL}|g" /airpal-master/reference.yml

mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS ${AIRPAL_DB_NAME}"
fi

java -Duser.timezone=UTC -cp build/libs/airpal-*-all.jar com.airbnb.airpal.AirpalApplication db migrate reference.yml
java -server -Duser.timezone=UTC -cp build/libs/airpal-*-all.jar com.airbnb.airpal.AirpalApplication server reference.yml