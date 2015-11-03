
# Airpal-Docker

This is docker image for [Airpal](https://airbnb.github.io/airpal/)(PrestoDB webUI).

## Build
```
docker build -t data/airpal .
```

## How to use this image

### Run Airpal image with an exists mysql

#### Airpal configure
Save below config as `reference.yml`, and modify:
```
# Logging settings
logging:

  loggers:
    org.apache.shiro: INFO

  # The default level of all loggers. Can be OFF, ERROR, WARN, INFO, DEBUG, TRACE, or ALL.
  level: INFO

# HTTP-specific options.
server:
  applicationConnectors:
    - type: http
      port: 8081
      idleTimeout: 10 seconds

  adminConnectors:
    - type: http
      port: 8082

shiro:
  iniConfigs: ["classpath:shiro_allow_all.ini"]

dataSourceFactory:
  driverClass: com.mysql.jdbc.Driver
  user: <your-mysql-username>
  password: <your-mysql-password>
  url: jdbc:mysql://<your-mysql-host>:3306/<your-mysql-airpal-db-name>

# The URL to the Presto coordinator.
prestoCoordinator: http://<your-presto-host>:<your-presto-port>
```

#### Run

```
docker run --name airpal -v `pwd`/reference.yml:/airpal-master/reference.yml -idt data/airpal
```

After running, using `docker logs -f --tail 0 airpal` monitor airpal logs.


### Run Airpal image with Mysql image

#### Start Mysql Container
```
docker run --name airpal-mysql -e MYSQL_ROOT_PASSWORD="lapria" -d mysql:5.6
```

#### Run
link mysql container and set presot url in env:
```
docker run --name airpal --link airpal-mysql:mysql -e PRESTO_COORDINATOR_URL=http://10.248.136.189:8080 -idt data/airpal
```

After running, using `docker logs -f --tail 0 airpal` monitor airpal logs.


## Others

### AWS EMR - presto-sandbox
default presto port is `8889`.

### Other presto
default presto port is `8080`, setting in coordinator configure: `<presto-install-path>/etc/config.properties`
