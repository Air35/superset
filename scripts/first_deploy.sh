#!/bin/bash

#PROJECT_DIR=$(dirname "$PWD")
PROJECT_DIR="$PWD"
DEFAULT_DIR="$PROJECT_DIR/default"
DOCKER_TEMPLATE_DIR="$DEFAULT_DIR/docker-compose"

USER_UID=$(id -u)
USER_GID=$(id -g)

SUPERSET_EXAMPLE_ENV="$DOCKER_TEMPLATE_DIR/superset_env_example.conf"
SUPERSET_ENV="$PROJECT_DIR/.env"

SUPERSET_DOCKERFILE_EXAMPLE="$DEFAULT_DIR/Dockerfile.example"
SUPERSET_DOCKERFILE="$PROJECT_DIR/Dockerfile"

SUPERSET_CONFIG_EXAMPLE="$DEFAULT_DIR/superset_config_example.py"
SUPERSET_CONFIG="$PROJECT_DIR/volumes/superset_config/superset_config.py"

SUPERSET_DBPASS=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
SUPERSET_SECRET=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)
#Fallback de versão
SUPERSET_VERSION="6.1.0"

VERSOES_SUPORTADAS=(
    #"6.0.0"
    "6.1.0"
    #"6.1.1"
)

#mkdir -p secrets
mkdir -p volumes/{db_data,redis,superset_home,superset_config,superset_docker}

echo "Pasta do projeto: $PROJECT_DIR"
echo "Senhas Geradas:"
echo "Senha banco: $SUPERSET_DBPASS"
echo "Senha api: $SUPERSET_SECRET"

echo "Informe o nome do Cliente:"
read -r SUPERSET_CLIENTE

echo "Informe a tag da versão desejada:"

echo "Versões Suportadas:"

for ((i=0; i<${#VERSOES_SUPORTADAS[@]}; i+=2)); do
    printf -- "- %-35s" "${VERSOES_SUPORTADAS[$i]}"

    if [[ $((i+1)) -lt ${#VERSOES_SUPORTADAS[@]} ]]; then
        printf -- "- %s" "${VERSOES_SUPORTADAS[$((i+1))]}"
    fi

    echo
done

read -r SUPERSET_VERSION

cp "$SUPERSET_EXAMPLE_ENV" "$SUPERSET_ENV"

sed -i "s/superset_db_password/$SUPERSET_DBPASS/g" "$SUPERSET_ENV"
sed -i "s/SUPERSET_SUPER_SECRET_KEY/$SUPERSET_SECRET/g" "$SUPERSET_ENV"
sed -i "s/superset_cliente/$SUPERSET_CLIENTE/g" "$SUPERSET_ENV"
sed -i "s/user_uid/$USER_UID/g" "$SUPERSET_ENV"
sed -i "s/user_gid/$USER_GID/g" "$SUPERSET_ENV"

cp "$SUPERSET_DOCKERFILE_EXAMPLE" "$SUPERSET_DOCKERFILE"

cp "$SUPERSET_CONFIG_EXAMPLE" "$SUPERSET_CONFIG"

sed -i "s/superset_version/$SUPERSET_VERSION/g" "$SUPERSET_DOCKERFILE"
