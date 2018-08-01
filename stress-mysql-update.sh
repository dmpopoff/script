#!/bin/bash
/usr/bin/docker stop mysql-test ;
sleep 10s \
&& sudo rm -rf ./mysqldata-test/* && /usr/bin/docker run --rm --ulimit nofile=500000:500000 -v ./conf/my.cnf:/etc/my.cnf -v ./mysqldata-test/:/var/lib/mysql -p3307:3306 --name=mysql-test -d -e MYSQL_ROOT_PASSWORD=1234 mysql:5.7 \
&& sleep 33s && /usr/bin/docker exec -i mysql-test mysql -uroot -p1234 --execute="create database stressdb;" && ls -Art /mnt/backup_mysql* | tail -n 1 | xargs -I{} sh -c '/usr/bin/docker exec -i mysql-test mysql -uroot -p1234 mysql <{}' \
&& ls -Art /mnt/backup_stressdb* | tail -n 1 | xargs -I{} sh -c '/usr/bin/docker exec -i mysql-test mysql -uroot -p1234 stressdb <{}' \
&&  docker exec -i mysql-test mysql -uroot -p1234 --execute="flush privileges;"
