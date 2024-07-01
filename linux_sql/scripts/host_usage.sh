#!/bin/bash

# Script usage
# bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password

# Assign CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check the number of arguments
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

# Retrieve hardware specification variables
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n1 | xargs)
disk_io=$(vmstat -d | awk 'NR==3{print $10}' | xargs)
disk_available=$(df -BM / | grep '/' | awk '{print $4}' | sed 's/M//' | xargs)
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Subquery to find matching id in host_info table
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
id=$(psql -t -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$host_id" )


# Construct the INSERT statement
insert_stmt="INSERT INTO host_usage(timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES('$timestamp', '$id', '$memory_free', '$cpu_idle', '$cpu_kernel', '$disk_io', '$disk_available')"

# Set up env var for psql cmd
export PGPASSWORD=$psql_password
# Insert data into the database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?
