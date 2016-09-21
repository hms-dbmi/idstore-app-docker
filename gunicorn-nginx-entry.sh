#!/bin/bash

#vault write -format json auth/app-id/login app_id=$APP_ID user_id=$USER_ID | jq -r .auth.client_token > /root/secretstash.txt

export VAULT_ADDR=https://vault.aws.dbmi.hms.harvard.edu:443 
export VAULT_SKIP_VERIFY=1

/vault/vault auth $ONETIME_TOKEN

DJANGO_SECRET=$(/vault/vault read -field=value secret/udn/udndev/ups_django_secret)
UPS_MYSQL_USERNAME_VAULT=$(/vault/vault read -field=value secret/udn/udndev/ups_mysql_username)
UPS_MYSQL_PASSWORD_VAULT=$(/vault/vault read -field=value secret/udn/udndev/ups_mysql_password)
UPS_MYSQL_PORT_VAULT=$(/vault/vault read -field=value secret/udn/udndev/ups_mysql_port)
UPS_MYSQL_HOSTNAME_VAULT=$(/vault/vault read -field=value secret/udn/udndev/ups_mysql_hostname)

UPS_KEY=$(/vault/vault read -field=value secret/udn/udndev/ups_ssl_key)
UPS_CERT=$(/vault/vault read -field=value secret/udn/udndev/ups_ssl_cert)
UPS_CERT_CHAIN=$(/vault/vault read -field=value secret/udn/udndev/ups_ssl_cert_chain)

export SECRET_KEY=$DJANGO_SECRET
export UPS_MYSQL_USERNAME=$UPS_MYSQL_USERNAME_VAULT
export UPS_MYSQL_PASSWORD=$UPS_MYSQL_PASSWORD_VAULT
export UPS_MYSQL_PORT=$UPS_MYSQL_PORT_VAULT
export UPS_MYSQL_HOSTNAME=$UPS_MYSQL_HOSTNAME_VAULT

echo $UPS_KEY | base64 -d >> /etc/nginx/ssl/UPS_KEY.key
echo $UPS_CERT | base64 -d >> /etc/nginx/ssl/UPS_CERT.crt
echo $UPS_CERT_CHAIN | base64 -d >> /etc/nginx/ssl/UPS_CERT.crt

chmod 710 /etc/nginx/ssl/*

cd /idstore-app/idstore-app/

python manage.py migrate
python manage.py collectstatic --no-input

/etc/init.d/nginx restart

gunicorn idstore-app.wsgi:application