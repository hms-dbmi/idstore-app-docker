docker stop ups
docker rm ups

docker run --name ups -p 80:80 -p 443:443 	-e SECRET_KEY="TEST" \
									-e UPS_MYSQL_USERNAME="root" \
									-e UPS_MYSQL_PASSWORD="root" \
									-e UPS_MYSQL_HOSTNAME="192.168.99.100" \
									-e UPS_MYSQL_PORT="3306" \
									-i -t dbmi/upload-preprocessing-service-docker

#docker exec -i -t ups /bin/bash
