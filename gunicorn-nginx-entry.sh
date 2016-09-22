#!/bin/bash

/vault/vault auth $ONETIME_TOKEN

DJANGO_SECRET=$(/vault/vault read -field=value $VAULT_PATH/django_secret)
UPS_MYSQL_USERNAME_VAULT=$(/vault/vault read -field=value $VAULT_PATH/mysql_username)
UPS_MYSQL_PASSWORD_VAULT=$(/vault/vault read -field=value $VAULT_PATH/mysql_password)
UPS_MYSQL_PORT_VAULT=$(/vault/vault read -field=value $VAULT_PATH/mysql_port)
UPS_MYSQL_HOSTNAME_VAULT=$(/vault/vault read -field=value $VAULT_PATH/mysql_hostname)

UPS_KEY=$(/vault/vault read -field=value $VAULT_PATH/ssl_key)
UPS_CERT=$(/vault/vault read -field=value $VAULT_PATH/ssl_cert)
UPS_CERT_CHAIN=$(/vault/vault read -field=value $VAULT_PATH/ssl_cert_chain)

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