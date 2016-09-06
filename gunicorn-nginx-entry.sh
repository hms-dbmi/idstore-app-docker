#!/bin/bash

echo $UPS_KEY | base64 -d >> /etc/nginx/ssl/UPS_KEY.key
echo $UPS_CERT | base64 -d >> /etc/nginx/ssl/UPS_CERT.crt
echo $UPS_CERT_CHAIN | base64 -d >> /etc/nginx/ssl/UPS_CERT.crt

chmod 710 /etc/nginx/ssl/*

cd /upload-preprocessing-service/upload-preprocessing-service/

python manage.py migrate
python manage.py collectstatic --no-input

/etc/init.d/nginx restart

gunicorn upload_preprocessing_service.wsgi:application


