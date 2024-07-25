#!/usr/bin/env bash
cd /code
if [ ! -f /code/manage.py ]; then
  pip install django --break-system-packages
  django-admin startproject ashdestefano /code
fi
pip install --upgrade pip --break-system-packages
pip install -r requirements.txt
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8000

