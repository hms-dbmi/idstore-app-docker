FROM python:3.5

RUN pip install django
RUN pip install gunicorn

RUN	apt-get -y update && \
 	apt-get -y install nginx

COPY ups.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/ups.conf /etc/nginx/sites-enabled/ups.conf

RUN rm -rf /etc/nginx/sites-available/default

RUN mkdir /etc/nginx/ssl/
RUN chmod 710 /etc/nginx/ssl/

COPY gunicorn-nginx-entry.sh /

RUN chmod u+x gunicorn-nginx-entry.sh

RUN mkdir /idstore-app/
RUN mkdir /idstore-app/static/

WORKDIR /idstore-app/

RUN  echo "hi" && git clone -b development https://github.com/hms-dbmi/idstore-app.git

RUN pip install -r /idstore-app/idstore-app/requirements.txt

WORKDIR /

ENTRYPOINT ["./gunicorn-nginx-entry.sh"]