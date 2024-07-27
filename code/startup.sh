#!/usr/bin/env bash
echo "Waiting for postgres..."

while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  sleep 0.1
done

echo "PostgreSQL started"

if [ ! -d /code ]; then
  mkdir /code
fi
cd /code
if [ ! -f /code/manage.py ]; then
  echo "No project exists. Performing initial setup..."
  pip install django --break-system-packages
  echo "Creating project..."
  django-admin startproject "$PROJECT_DIR" /code
  echo "Upgrading pip..."
  pip install --upgrade pip --break-system-packages
  echo "Installing dependencies..."
  pip install -r requirements.txt --break-system-packages
  echo "Migrating..."
  python3 manage.py migrate
  echo "Cleaning up files..."
  rm db.sqlite3
  sed -i "s/from pathlib import Path/from pathlib import Path\nimport os\n/g" "$PROJECT_DIR"/settings.py
  sed -i "s/SECRET_KEY = '.*'/SECRET_KEY = os.environ.get(\"SECRET_KEY\")/g" "$PROJECT_DIR"/settings.py
  sed -i "s/DEBUG = .*/DEBUG = os.environ.get(\"DEBUG\", default=0)/g" "$PROJECT_DIR"/settings.py
  sed -i "s/ALLOWED_HOSTS = .*/ALLOWED_HOSTS = os.environ.get(\"DJANGO_ALLOWED_HOSTS\").split(' ')/g" "$PROJECT_DIR"/settings.py
  sed -i "s/'ENGINE': .*/'ENGINE': os.environ.get('POSTGRES_ENGINE', 'django.db.backends.sqlite3'),/g" "$PROJECT_DIR"/settings.py
  sed -i "s/'NAME': BASE_DIR \/ 'db.sqlite3',/'NAME': os.environ.get('POSTGRES_DB', BASE_DIR \/ 'db.sqlite3'),\n        'USER': os.environ.get('POSTGRES_USER', 'user'),\n        'PASSWORD': os.environ.get('POSTGRES_PASSWORD', 'password'),\n        'HOST': os.environ.get('POSTGRES_HOST', 'localhost'),\n        'PORT': os.environ.get('POSTGRES_PORT', '5432'),/g" "$PROJECT_DIR"/settings.py
else
  echo "Project exists. Upgrading..."
  pip install --upgrade pip --break-system-packages
  echo "Installing dependencies..."
  pip install -r requirements.txt --break-system-packages
  echo "Migrating..."
  python3 manage.py migrate
fi
echo "Starting server..."
python3 manage.py runserver 0.0.0.0:8000

