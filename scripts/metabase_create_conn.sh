#!/bin/bash
echo "$2"

# Extracting the user
DW_POSTGRES_USER=$(echo $DW_POSTGRES_URI | sed -E 's#.*://([^:]+):.*#\1#')

# Extracting the password
DW_POSTGRES_PASSWORD=$(echo $DW_POSTGRES_URI | sed -E 's#.*://[^:]+:([^@]+)@.*#\1#')

# Extracting the host
DW_POSTGRES_HOST=$(echo $DW_POSTGRES_URI | sed -E 's#.*://[^@]+@([^/]+).*#\1#')

# Extracting the database
DW_POSTGRES_DB=$(echo $DW_POSTGRES_URI | sed -E 's#.*/([^?]+)\?.*#\1#')

if ! echo "$2" | grep -q "Postgres DW"; then
    echo 'Setting up data warehouse source'
    echo $DW_POSTGRES_URI
    echo $DW_POSTGRES_HOST
    echo $DW_POSTGRES_USER
    echo $DW_POSTGRES_PASSWORD
    echo $DW_POSTGRES_DB
    echo "
    {
        'engine': 'postgres',
        'name': 'Postgres DW',
        'details': {
            'host':'$DW_POSTGRES_HOST',
            'user':'$DW_POSTGRES_USER',
            'password':'$DW_POSTGRES_PASSWORD',
            'db':'$DW_POSTGRES_DB',
            'ssl': 'true'
        }
    }
    " > file.json
    sed 's/'\''/\"/g' file.json > file2.json
    cat file2.json
    curl -s -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: $3" \
    http://$1/api/database \
    --data-binary @file2.json
else
    echo "'Postgres DW' found in the database list, exiting..."
fi
