FROM python:3.5

RUN pip install django
RUN pip install gunicorn

RUN	apt-get -y update && \
 	apt-get -y install nginx

COPY ups.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/ups.conf /etc/nginx/sites-enabled/ups.conf

RUN rm -rf /etc/nginx/sites-available/default

COPY gunicorn-nginx-entry.sh /

RUN chmod u+x gunicorn-nginx-entry.sh

RUN mkdir /upload-preprocessing-service/
RUN mkdir /upload-preprocessing-service/static/

WORKDIR /upload-preprocessing-service/

RUN  echo "hi" && git clone -b development https://github.com/hms-dbmi/upload-preprocessing-service.git

RUN pip install -r /upload-preprocessing-service/upload-preprocessing-service/requirements.txt

WORKDIR /

ENTRYPOINT ["./gunicorn-nginx-entry.sh"]