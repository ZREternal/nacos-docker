#!/bin/bash
docker run -dit --name nacos-mysql-test -e MYSQL_ROOT_PASSWORD=000000 -v ./mysql-data:/var/lib/mysql mysql:5.7
sleep 5
#!/bin/bash

while true; do
    result=$(docker exec -it nacos-mysql-test sh -c 'echo $(service mysql status) |grep not')
    if [[ -n $result ]]; then
        echo "MySQL服务未运行"
        sleep 1
    else
        echo "MySQL服务已运行"
        # 在这里执行后续的操作
        break
    fi
done

sleep 20
docker exec -it nacos-mysql-test sh -c 'mysql -uroot -p000000 -e "CREATE DATABASE nacos_config CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"'
docker cp nacos.sql nacos-mysql-test:/root/
docker exec -it nacos-mysql-test sh -c 'mysql -uroot -p000000 nacos_config< /root/nacos.sql'
sleep 5
docker exec -it nacos-mysql-test sh -c 'mysql -uroot -p000000 -e "show databases;use nacos_config;show tables"'
docker rm -f nacos-mysql-test
