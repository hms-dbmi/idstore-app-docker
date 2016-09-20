#
#USER_UUID=$(uuidgen)
#APP_UUID=$(uuidgen)

#vault write auth/app-id/map/app-id/$APP_UUID value='id-store-app-secrets'
#vault write auth/app-id/map/user-id/$USER_UUID value=$APP_UUID

ONETIME_TOKEN=$(vault token-create -policy="id-store-app-secrets" -use-limit=9 -ttl="1m" -format="json" | jq -r .auth.client_token)
echo $ONETIME_TOKEN
docker stop idstore-app
docker rm idstore-app

docker run --name idstore-app -p 443:443 -e ONETIME_TOKEN=$ONETIME_TOKEN \
											-i -t dbmi/idstore-app-docker

#docker exec -i -t idstore-app /bin/bash
#-e SECRET_KEY="TEST" \
#									-e UPS_MYSQL_USERNAME="root" \
#									-e UPS_MYSQL_PASSWORD="root" \
#									-e UPS_MYSQL_HOSTNAME="192.168.99.100" \
#									-e UPS_MYSQL_PORT="3306" \
#									-e UPS_KEY="LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlDWEFJQkFBS0JnUUNzN1RYZ2xTZlREMGt6YlJiR094R3lOMWpQQ0sxck9yWG9OVis0UFpLbzJpSFp2bnBoCnlER1llbEJJQzNiQ2tKVVNBMXNBb0wrb1ZQZDBzbmFNQ2FRMUxSaDhtUlM0VmJOWndIN1pnTXdDK1c2bHhJVC8KdFlQOENrRXAzY3FKdHVyUkZKNDA4Y2dsVEtRTFlKRlpQSlA2cTBUNy9QcWcweFlZOHA5ekg4c1U4UUlEQVFBQgpBb0dBY1BJYVQ0NThUWEZkZVZaV0dyRjRGSFByOElXVlowVVlqUXRYY3FuY3dhWi9sNDIrdDJFZmE1endGSzVRCktqSnUreTN2NFZBYy9tQklwQkx3TlBVVEo0bEFlQmhCS0dWUVYyNmlSbERGMGIzLzJYNFcwRmJzKzJOaXRxQjcKbmNVRzE1UDkvT3dxL2dwL05DL3NGdmJhdHVIYzNmMFJyMS83ZnV1RDU2Vy85a0VDUVFEWjlFeG5uS0JDQ0FoRQoycENpa3hYQWM1TUpVUnBuT1dvZWdBWmc0QitxQ2lDd2FRWHUwdi9ydDJRL3BqMEs2dlpqaHY5d0V5YzNxSy9RCkJRS050NkRKQWtFQXl4ekRwWlpONENYWU5WUlhsZ2VWWXU1aXBvZ3FlcWROcjVuU2NBT1kyMUFPYTJrM0ovMXoKcXZnSkxJZjFVZ0xpQ0NWVkZPM2NFdW90d25YRmlnak82UUpCQU1PR3B4aDRhVWh6ZmorT3VCd3d5VjI2RVJsVgptZE1xcmFtby9vL2Y0R2doNTh0Nm5DanhQMGVPWVMrOGlaeUd4dnpvZWJWb2FWRkVVbHpTY2NVRERBa0NRRmwvCnJUNHp3dEQ0SEJNenZQeGhEeFJ1MG8xckJyelJKOHd1emFtS0REcm5SZE5TbzNrOWwxQkl4MUlWL3FWS20rclcKK0d5bWV3amlvNU5DYmU3cS9yRUNRQnVFNFhxZVlDN3ZyNVVzTGdTbklkY0ZDSUd3bGVNNWdOZ09QeGpTNmRiaAp5WGovNkR3UlhmdHIwZWIxNXZ0MG9OTDFBRGRiODExUVBFNXZPbEpqaDlJPQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=" \
#									-e UPS_CERT="LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURuekNDQXdpZ0F3SUJBZ0lKQU1EaG95amRFNUJ5TUEwR0NTcUdTSWIzRFFFQkJRVUFNSUdTTVFzd0NRWUQKVlFRR0V3SlZVekVMTUFrR0ExVUVDQk1DVFVFeER6QU5CZ05WQkFjVEJrSnZjM1J2YmpFTk1Bc0dBMVVFQ2hNRQpSRUpOU1RFUk1BOEdBMVVFQ3hNSVJHRjBZVU52Y21VeEVqQVFCZ05WQkFNVENXMXRZMlIxWm1acFpURXZNQzBHCkNTcUdTSWIzRFFFSkFSWWdiV2xqYUdGbGJGOXRZMlIxWm1acFpVQm9iWE11YUdGeWRtRnlaQzVsWkhVd0hoY04KTVRZd09UQTJNVFV5T1RNeFdoY05NVFl4TURBMk1UVXlPVE14V2pDQmtqRUxNQWtHQTFVRUJoTUNWVk14Q3pBSgpCZ05WQkFnVEFrMUJNUTh3RFFZRFZRUUhFd1pDYjNOMGIyNHhEVEFMQmdOVkJBb1RCRVJDVFVreEVUQVBCZ05WCkJBc1RDRVJoZEdGRGIzSmxNUkl3RUFZRFZRUURFd2x0YldOa2RXWm1hV1V4THpBdEJna3Foa2lHOXcwQkNRRVcKSUcxcFkyaGhaV3hmYldOa2RXWm1hV1ZBYUcxekxtaGhjblpoY21RdVpXUjFNSUdmTUEwR0NTcUdTSWIzRFFFQgpBUVVBQTRHTkFEQ0JpUUtCZ1FDczdUWGdsU2ZURDBremJSYkdPeEd5TjFqUENLMXJPclhvTlYrNFBaS28yaUhaCnZucGh5REdZZWxCSUMzYkNrSlVTQTFzQW9MK29WUGQwc25hTUNhUTFMUmg4bVJTNFZiTlp3SDdaZ013QytXNmwKeElUL3RZUDhDa0VwM2NxSnR1clJGSjQwOGNnbFRLUUxZSkZaUEpQNnEwVDcvUHFnMHhZWThwOXpIOHNVOFFJRApBUUFCbzRINk1JSDNNQjBHQTFVZERnUVdCQlNwVUFIcTlhVzdKRW5lSjJwdWIxMUZFVkFoekRDQnh3WURWUjBqCkJJRy9NSUc4Z0JTcFVBSHE5YVc3SkVuZUoycHViMTFGRVZBaHpLR0JtS1NCbFRDQmtqRUxNQWtHQTFVRUJoTUMKVlZNeEN6QUpCZ05WQkFnVEFrMUJNUTh3RFFZRFZRUUhFd1pDYjNOMGIyNHhEVEFMQmdOVkJBb1RCRVJDVFVreApFVEFQQmdOVkJBc1RDRVJoZEdGRGIzSmxNUkl3RUFZRFZRUURFd2x0YldOa2RXWm1hV1V4THpBdEJna3Foa2lHCjl3MEJDUUVXSUcxcFkyaGhaV3hmYldOa2RXWm1hV1ZBYUcxekxtaGhjblpoY21RdVpXUjFnZ2tBd09HaktOMFQKa0hJd0RBWURWUjBUQkFVd0F3RUIvekFOQmdrcWhraUc5dzBCQVFVRkFBT0JnUUNSMk00NURMR0drNFdlalZlRwpqRGI3WU90WlliOGw5YzZRdGVFa290TTY0YVlETzNrTnhERkdVVzRtZkorZDBySXBVNy9jY2hCTkp0SWVNelVtCmdHMkRJT3RiY2k2M1pNOGRHWkVVWUJhaFZYbEUveDk1bzVHMWtLZlQzTHY5b0FFRXVJczhrMGEwRkpMc2NLZG0Kb3BXLzZWc0M4MWgyRGpoSXdEVlRnVExmekE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==" \
