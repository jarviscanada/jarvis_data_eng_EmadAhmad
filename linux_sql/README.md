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
