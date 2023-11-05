#!/bin/bash
airflow db init
echo "AUTH_ROLE_PUBLIC = 'Admin'" >> webserver_config.py
airflow connections add 'postgres_ops' \
    --conn-type 'postgres' \
    --conn-login $OPS_POSTGRES_USER \
    --conn-password $OPS_POSTGRES_PASSWORD \
    --conn-host $OPS_POSTGRES_CONTAINER_NAME \
    --conn-port $OPS_POSTGRES_PORT \
    --conn-schema $OPS_POSTGRES_DB
airflow connections add 'postgres_dw' \
    --conn-type 'postgres' \
    --conn-login $DW_POSTGRES_USER \
    --conn-password $DW_POSTGRES_PASSWORD \
    --conn-host $DW_POSTGRES_CONTAINER_NAME \
    --conn-port $DW_POSTGRES_PORT \
    --conn-schema $DW_POSTGRES_DB
airflow webserver