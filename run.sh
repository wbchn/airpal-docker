#!/bin/bash

cd /airpal-master/

# auto gen yml using env
if [ ! -f /airpal-master/reference.yml ]
then
cp /airpal-master/reference.example.yml /airpal-master/reference.yml
sed -i "s|MYSQL_USER|root|g" /airpal-master/reference.yml
sed -i "s|MYSQl_PASSWORD|${MYSQL_ENV_MYSQL_ROOT_PASSWORD}|g" /airpal-master/reference.yml
sed -i "s|MYSQL_DB_NAME|${AIRPAL_DB_NAME}|g" /airpal-master/reference.yml
sed -i "s|jdbc:mysql://127.0.0.1:3306/MYSQL_DB_NAME|jdbc:mysql://${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}/${AIRPAL_DB_NAME}|g" /airpal-master/reference.yml
sed -i "s|http://presto-coordinator-url.com|${PRESTO_COORDINATOR_URL}|g" /airpal-master/reference.yml

# wait db ready
for i in $(seq 1 12); do
  echo "connect mysql $i times."
  mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS ${AIRPAL_DB_NAME}"
  if [ $? -eq 0 ]; then break; fi
  sleep 10
done # end for
fi

java -Duser.timezone=UTC -cp build/libs/airpal-*-all.jar com.airbnb.airpal.AirpalApplication db migrate reference.yml
java -server -Duser.timezone=UTC -cp build/libs/airpal-*-all.jar com.airbnb.airpal.AirpalApplication server reference.yml
