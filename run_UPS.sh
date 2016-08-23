docker stop ups
docker rm ups

docker run --name ups -p 8000:8000 -i -t dbmi/upload-preprocessing-service

#docker exec -i -t ups /bin/bash