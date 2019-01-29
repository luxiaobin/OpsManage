#!/bin/bash
echo_supervisord_conf > /etc/supervisord.conf
export PYTHONOPTIMIZE=1
cat > /etc/supervisord.conf << EOF
[unix_http_server]
file=/tmp/supervisor.sock
[supervisord]
logfile=/tmp/supervisord.log
logfile_maxbytes=50MB
logfile_backups=10
loglevel=info
pidfile=/tmp/supervisord.pid
nodaemon=false
minfds=1024
minprocs=200
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ; use a unix:// URL  for a unix socket
[program:celery-worker-default]
command=/usr/bin/python manage.py celery worker --loglevel=info -E -Q default
directory=/mnt/OpsManage
stdout_logfile=/var/log/celery-worker-default.log
autostart=true
autorestart=true
redirect_stderr=true
stopsignal=QUIT
numprocs=1
[program:celery-worker-ansible]
command=/usr/bin/python manage.py celery worker --loglevel=info -E -Q ansible
directory=/mnt/OpsManage
stdout_logfile=/var/log/celery-worker-ansible.log
autostart=true
autorestart=true
redirect_stderr=true
stopsignal=QUIT
numprocs=1
[program:celery-beat]
command=/usr/bin/python manage.py celery beat
directory=/mnt/OpsManage
stdout_logfile=/var/log/celery-beat.log
autostart=true
autorestart=true
redirect_stderr=true
stopsignal=QUIT
numprocs=1
[program:celery-cam]
command=/usr/bin/python manage.py celerycam
directory=/mnt/OpsManage
stdout_logfile=/var/log/celery-celerycam.log
autostart=true
autorestart=true
redirect_stderr=true
stopsignal=QUIT
numprocs=1
EOF
/usr/bin/supervisord -c /etc/supervisord.conf
sleep 3
cd /mnt/OpsManage/
python /mnt/OpsManage/manage.py runserver 0.0.0.0:8000