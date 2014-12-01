#!/bin/bash

# Fix bad permissions of mounted volume
chmod 700 /var/lib/postgresql/9.3/main
chown -R postgres:postgres /var/lib/postgresql/9.3/main
# Start Postgres
/etc/init.d/postgresql start
# If you changed your password, update it below:
cat > /msf/config/database.yml << EOF
production:
    adapter: postgresql
    database: msf_database
    username: msf_user
    password: Pa55word
    host: 127.0.0.1
    port: 5432
    pool: 75
    timeout: 5
EOF
