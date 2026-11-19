#!/bin/sh

set -e

echo "--> Collect Static Files..."
python readysetai/manage.py collectstatic --noinput

echo "--> Create DB Tables..."
python readysetai/manage.py makemigrations
python readysetai/manage.py migrate

echo "--> Create ADMIN User"
python readysetai/manage.py create_default_superuser || echo "ADMIN User already exists"

echo "--> Start Uvicorn..."

exec /opt/venv/bin/gunicorn --bind 0.0.0.0:8080 --reload --workers 3 --chdir /app/readysetai readysetai.wsgi:application