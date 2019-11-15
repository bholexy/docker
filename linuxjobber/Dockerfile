# create database user as below if needed
# To connect an external database, you might need to create the user like this:
# CREATE USER 'linuxjobber2'@'localhost' IDENTIFIED WITH mysql_native_password BY '8iu7*IU&';
# GRANT ALL PRIVILEGES ON *.* TO 'linuxjobber2'@'localhost' with grant option;
# CREATE USER 'linuxjobber2'@'%' IDENTIFIED WITH mysql_native_password BY '8iu7*IU&';
# GRANT ALL PRIVILEGES ON *.* TO 'linuxjobber2'@'%' with grant option;

FROM centos:7

MAINTAINER The CentOS Project <cloud-ops@centos.org>

LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40

RUN yum -y install wget epel-release
RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all

RUN yum -y update && yum -y install git


RUN yum -y install httpd-devel \
                   zlib-devel \
                   bzip2-devel \
                   openssl-devel \
                   ncurses-devel \
                   sqlite-devel \
                   readline \
                   https://centos7.iuscommunity.org/ius-release.rpm \
                   python36u \
                   python36u-pip \
                   python36u-devel \
                   uwsgi \
                   uwsgi-plugin-python36u \
                   nginx \
                   python-pip \
                   mysql-devel

RUN yum -y group install "Development Tools"

RUN  yum clean all;

RUN yum -y install gcc

RUN pip install --upgrade pip && pip install boto && pip install boto3
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm python36u python36u-devel python36u-pip
RUN pip install pathlib
RUN /bin/pip3.6 install django==2.1
RUN /bin/pip3.6 install channels
RUN /bin/pip3.6 install djangorestframework
RUN /bin/pip3.6 install django-cors-headers
RUN /bin/pip3.6 install mysqlclient
RUN /bin/pip3.6 install mysql-connector-python
RUN /bin/pip3.6 install djangorestframework-jwt
RUN /bin/pip3.6 install Pillow channels_redis
RUN /bin/pip3.6 install stripe selenium django-ckeditor boto

RUN mkdir -p /linuxjobber/
RUN mkdir -p /usr/share/nginx/web/classroom
COPY www/ /linuxjobber/www/
COPY nginx.conf /etc/nginx/
# COPY package.json /linuxjobber
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Angular Implentation
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install -y nodejs && yum install -y gcc-c++ make sshpass
#COPY www/ /linuxjobber/www/
COPY environment.prod.ts /linuxjobber/www/Angular/src/environments/

RUN yum install -y uwsgi-logger-file uwsgi-plugin-python36u --skip-broken 

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR=/root/.nvm
# RUN cd /linuxjobber/www/Angular && . $HOME/.nvm/nvm.sh && nvm install stable
RUN cd /linuxjobber/www/Angular && . $HOME/.nvm/nvm.sh && npm install
RUN git config --global user.email "joseph.showunmi@linuxjobber.com"
RUN git config --global user.name "joseph.showunmi"
RUN cd /linuxjobber/www/Angular/ && . $HOME/.nvm/nvm.sh && npm run-script build 
# RUN cd /linuxjobber/www/Angular/ && . $HOME/.nvm/nvm.sh  && ng build --prod --aot
# RUN cd /linuxjobber/www/Angular/  && ng build --prod --aot
#RUN yes | cp -r /linuxjobber//www/Angular/dist/groupclass/assets/ /linuxjobber/classroom/dist/classroom/src/
RUN yes | cp -r /linuxjobber/www/Angular/dist/groupclass/* /usr/share/nginx/web/classroom

# Python Implementation

RUN cd /linuxjobber/www/Django/Linuxjobber/ && /bin/python3.6 -m pip install  -r requirement.txt
COPY settings.ini /linuxjobber/www/Django/Linuxjobber/
COPY settings.py /linuxjobber/www/Django/Linuxjobber/Linuxjobber/settings.py
#RUN cd /linuxjobber/www/Django/Linuxjobber/ && /bin/python3.6 manage.py makemigrations && /bin/python3.6 manage.py migrate
RUN touch /etc/uwsgi.d/linuxjobber.ini 
RUN echo "[uwsgi]" > /etc/uwsgi.d/linuxjobber.ini
RUN echo "socket = /run/linuxjobberuwsgi/uwsgi.sock" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "chmod-socket = 775" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "chdir = /linuxjobber/www/Django/Linuxjobber" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "master = true" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "module = Linuxjobber.wsgi:application" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "uid = uwsgi" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "gid = uwsgi" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "processes = 1" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "threads = 1" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "plugins = python36u,logfile" >> /etc/uwsgi.d/linuxjobber.ini
RUN echo "http-websockets = true" >> /etc/uwsgi.d/linuxjobber.ini

RUN mkdir -p /run/linuxjobberuwsgi/
RUN chgrp nginx /run/linuxjobberuwsgi
RUN chmod 2775 /run/linuxjobberuwsgi
RUN touch /run/linuxjobberuwsgi/uwsgi.sock

# COPY backup.sh /web/
RUN yes | cp -r media /linuxjobber/www/Django/Linuxjobber/media 
RUN chmod -R 777 /linuxjobber/www/Django/Linuxjobber/media
RUN touch /linuxjobber/www/Django/Linuxjobber/django_dev.log
RUN touch /linuxjobber/www/Django/Linuxjobber/django_dba.log
RUN touch /linuxjobber/www/Django/Linuxjobber/django_production.log
RUN cd /linuxjobber/www/Django/Linuxjobber/ && chmod -R 777 django_dba.log django_dev.log django_production.log

#RUN rm -rf /linuxjobber/www/Django/Linuxjobber/home/migrations/00* 000*
#RUN rm -rf /linuxjobber/www/Django/Linuxjobber/Courses/migrations/00* 000*

RUN chgrp -R 0 /linuxjobber/www/Django/* /start.sh /run /run/* /run/linuxjobberuwsgi/* /etc /usr/share/nginx /var/lib /var/log /usr/sbin/uwsgi \
    && chmod -R g=u /linuxjobber/www/Django/* /start.sh /run /run/* /run/linuxjobberuwsgi/* /etc /usr/share/nginx /usr/sbin/uwsgi  /var/lib /var/log

EXPOSE 4000 7000
CMD ["/start.sh"]
