#!/bin/bash

#PROJECT_DIR=$(dirname "$PWD")
PROJECT_DIR="$PWD"

SUPERSET_EXAMPLE_ENV="$PROJECT_DIR/superset_env_example.conf"
SUPERSET_ENV="$PROJECT_DIR/.env"

SUPERSET_DBPASS=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
SUPERSET_ADMIN_PASS=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
SUPERSET_SECRET=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)
SUPERSET_VERSION=5.0.0

mkdir -p secrets 
mkdir -p volumes/{db_data,redis,superset_home,superset_config,superset_docker}

echo "Pasta do projeto: $PROJECT_DIR"
echo "Senhas Geradas:"
echo "Senha banco: $SUPERSET_DBPASS"
echo "Senha api: $SUPERSET_SECRET"

echo "Informe o nome do Cliente:"
read -r SUPERSET_CLIENTE

#echo "Informe a tag da versão desejada:"
#read -r SUPERSET_VERSION

cp "$SUPERSET_EXAMPLE_ENV" "$SUPERSET_ENV"

sed -i "s/superset_db_password/$SUPERSET_DBPASS/g" "$SUPERSET_ENV"
sed -i "s/superset_admin_password/$SUPERSET_ADMIN_PASS/g" "$SUPERSET_ENV"
sed -i "s/SUPERSET_SUPER_SECRET_KEY/$SUPERSET_SECRET/g" "$SUPERSET_ENV"
sed -i "s/superset_cliente/$SUPERSET_CLIENTE/g" "$SUPERSET_ENV"
sed -i "s/superset_version/$SUPERSET_VERSION/g" "$SUPERSET_ENV"