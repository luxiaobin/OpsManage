FROM centos:7.4.1708
RUN yum install -y wget git zlib zlib-devel readline-devel sqlite-devel bzip2-devel openssl-devel gdbm-devel libdbi-devel ncurses-libs kernel-devel libxslt-devel libffi-devel python-devel mysql-devel zlib-devel sshpass libtool make
RUN cd /usr/local/src && wget --no-check-certificate https://github.com/pypa/pip/archive/1.5.5.tar.gz -O pip-1.5.5.tar.gz   && wget --no-check-certificate https://pypi.python.org/packages/f7/94/eee867605a99ac113c4108534ad7c292ed48bf1d06dfe7b63daa51e49987/setuptools-28.0.0.tar.gz#md5=9b23df90e1510c7353a5cf07873dcd22
RUN cd /usr/local/src && tar -xzvf setuptools-28.0.0.tar.gz && tar -xzvf pip-1.5.5.tar.gz && cd setuptools-28.0.0 && python setup.py install && cd ../pip-1.5.5 && python setup.py install && pip install -U pip && easy_install paramiko==2.4.1
RUN mkdir -p /etc/ansible/ && echo -ne "[defaults]\nlibrary = /usr/share/ansible/my_modules/\nhost_key_checking = False\n" > /etc/ansible/ansible.cfg && echo "welliam" | passwd --stdin root
ADD . /mnt/OpsManage/
RUN pip install -r /mnt/OpsManage/requirements.txt
RUN cd /mnt/OpsManage/  && python manage.py makemigrations OpsManage && python manage.py makemigrations wiki && python manage.py makemigrations orders && python manage.py makemigrations filemanage && python manage.py migrate && python manage.py loaddata superuser.json
CMD  bash /mnt/OpsManage/start.sh
EXPOSE 8000