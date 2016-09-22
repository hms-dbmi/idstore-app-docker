ONETIME_TOKEN=$(vault token-create -policy="id-store-app-secrets" -use-limit=9 -ttl="1m" -format="json" | jq -r .auth.client_token)

docker stop idstore-app
docker rm idstore-app

docker run --name idstore-app -p 443:443 -e ONETIME_TOKEN=$ONETIME_TOKEN \
										-e VAULT_ADDR=https://vault.aws.dbmi.hms.harvard.edu:443 \
										-e VAULT_SKIP_VERIFY=1 \
										-e VAULT_PATH=secret/udn/idstore -i -t dbmi/idstore-app-docker

#docker exec -i -t idstore-app /bin/bash