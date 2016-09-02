#!/bin/bash

cd /upload-preprocessing-service/upload-preprocessing-service/

python manage.py migrate
python manage.py collectstatic --no-input

/etc/init.d/nginx restart

gunicorn upload_preprocessing_service.wsgi:application


