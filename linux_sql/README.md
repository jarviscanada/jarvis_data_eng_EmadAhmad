# Linux Cluster Monitoring Agent

## Introduction
This project is designed to monitor and log hardware specifications and usage data from multiple Linux server hosts into a centralized PostgreSQL database. The primary users are system administrators and IT professionals who need to track server performance and resource utilization. Technologies used include Bash scripting for automation, Docker for containerization, PostgreSQL for database management, and Git for version control. The system captures key hardware details and dynamic usage statistics to facilitate proactive infrastructure management and performance tuning.

## Quick Start
```bash
# Start a PostgreSQL instance using psql_docker.sh
./scripts/psql_docker.sh start|stop|create [db_username] [db_password]

# Create tables using ddl.sql
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# Insert hardware specs data into the DB using host_info.sh
bash scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

# Insert hardware usage data into the DB using host_usage.sh
bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password

# Setup a crontab entry to run host_usage.sh every minute
crontab -e
# Add the following line
* * * * * bash /path/to/host_usage.sh psql_host psql_port db_name psql_user psql_password &> /tmp/host_usage.log
```
# Implementation

## Scripts
psql_docker.sh
This script manages a PostgreSQL instance using Docker.

```bash
# Start PostgreSQL container
./scripts/psql_docker.sh start

# Stop PostgreSQL container
./scripts/psql_docker.sh stop

# Create PostgreSQL container
./scripts/psql_docker.sh create db_username db_password
```

host_info.sh
Captures hardware specifications and inserts them into the host_info table.

```bash
# Usage
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
```

host_usage.sh
Collects real-time hardware usage data and inserts it into the host_usage table.

```bash
# Usage
./scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```

crontab
Automates the execution of host_usage.sh at regular intervals.

```bash
# Edit crontab
crontab -e

# Add the following line to run host_usage.sh every minute
* * * * * bash /path/to/host_usage.sh psql_host psql_port db_name psql_user psql_password &> /tmp/host_usage.log

```
