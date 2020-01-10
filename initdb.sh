#!/bin/bash

exec >/tmp/initdb.log 2>&1
set -x

source /etc/profile.d/postgres_ld_lib_path.sh
env | grep -i LD_LIB
/opt/rh/rh-postgresql10/root/usr/bin/initdb -D /var/opt/rh/rh-postgresql10/lib/pgsql/data 
