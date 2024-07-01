#!/bin/bash

# Script usage
# ./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

# Setup and validate arguments (again, don't copy comments)
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

# Retrieve hardware specification variables
# xargs is a trick to trim leading and trailing white spaces
hostname=$(hostname -f)
cpu_number=$(lscpu | grep "^CPU(s):" | awk '{print $2}' | xargs)
cpu_architecture=$(lscpu | grep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(lscpu | grep "Model name:" | awk -F: '{print $2}' | xargs)
cpu_mhz=$(lscpu | grep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(lscpu | grep "L2 cache:" | awk '{print $3}' | sed 's/K//' | xargs)
total_mem=$(grep "MemTotal:" /proc/meminfo | awk '{print $2}' | xargs)
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Current time in `2019-11-26 14:40:19` UTC format
insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem)
VALUES ('$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, '$timestamp', $total_mem);"

export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?