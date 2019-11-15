#!/bin/bash

/usr/sbin/nginx
/bin/chmod -R 777 /run/linuxjobberuwsgi/
cd /linuxjobber/www/Django/Linuxjobber && nohup python3.6 manage.py runserver 0.0.0.0:4000 &
/usr/sbin/uwsgi --ini /etc/uwsgi.d/linuxjobber.ini
/bin/chmod -R 777 /run/linuxjobberuwsgi/
