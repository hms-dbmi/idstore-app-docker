FROM python:3.4.5-wheezy

RUN pip install django

RUN git clone -b development https://github.com/hms-dbmi/upload-preprocessing-service.git

RUN pip install -r /upload-preprocessing-service/requirements.txt

RUN cd /upload-preprocessing-service/ && python manage.py migrate

WORKDIR /upload-preprocessing-service/

CMD python manage.py runserver 0.0.0.0:8000