#!/usr/bin/env bash
if [ ! -d /code ]; then
  mkdir /code
fi
cd /code
if [ ! -f /code/manage.py ]; then
  echo "No project exists. Performing initial setup..."
  pip install django --break-system-packages
  django-admin startproject "$PROJECT_DIR" /code
  pip install --upgrade pip --break-system-packages
  pip install -r requirements.txt
  python3 manage.py migrate
  rm db.sqlite3
  sed -i "s/SECRET_KEY = '.*'/SECRET_KEY = os.environ.get(\"SECRET_KEY\")/g" "$PROJECT_DIR"/settings.py
  sed -i "s/DEBUG = .*/DEBUG = os.environ.get(\"DEBUG\", default=0)/g" "$PROJECT_DIR"/settings.py
  sed -i "s/ALLOWED_HOSTS = .*/ALLOWED_HOSTS = os.environ.get(\"ALLOWED_HOSTS\").split(',')/g" "$PROJECT_DIR"/settings.py
else
  echo "Project exists. Starting..."
  pip install django --break-system-packages
  pip install --upgrade pip --break-system-packages
  pip install -r requirements.txt
  python3 manage.py migrate
fi
python3 manage.py runserver 0.0.0.0:8000

