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

# queries.sql

The `queries.sql` file includes SQL queries to address various business questions related to the Linux Cluster Monitoring Agent project, analyzing hardware and usage data stored in the PostgreSQL database.

## SQL Queries in queries.sql

- **Group Hosts by Hardware Info:** Groups hosts by CPU count and sorts them by memory size within each group.
- **Average Memory Usage:** Calculates the average memory usage percentage over 5-minute intervals for each host.
- **Detect Host Failures:** Identifies host failures by detecting hosts that log fewer than three data points within a 5-minute interval.

```bash
# To run the queries
psql -h psql_host -p psql_port -d db_name -U psql_user -f queries.sql
```

# Database Modeling

## host_info Table Schema

| Column            | Data Type | Constraints      | Description              |
|-------------------|-----------|------------------|--------------------------|
| id                | SERIAL    | PRIMARY KEY      | Auto-incrementing ID     |
| hostname          | VARCHAR   | NOT NULL, UNIQUE | Fully qualified hostname |
| cpu_number        | INT2      | NOT NULL         | Number of CPUs           |
| cpu_architecture  | VARCHAR   | NOT NULL         | CPU architecture         |
| cpu_model         | VARCHAR   | NOT NULL         | CPU model                |
| cpu_mhz           | FLOAT8    | NOT NULL         | CPU frequency in MHz     |
| l2_cache          | INT4      | NOT NULL         | L2 cache size in kB      |
| total_mem         | INT4      | NOT NULL         | Total memory in kB       |
| timestamp         | TIMESTAMP | NOT NULL         | Record timestamp         |

## host_usage Table Schema

| Column          | Data Type | Constraints                | Description               |
|-----------------|-----------|----------------------------|---------------------------|
| timestamp       | TIMESTAMP | NOT NULL                   | Record timestamp          |
| host_id         | SERIAL    | PRIMARY KEY, FOREIGN KEY   | Reference to host_info    |
| memory_free     | INT4      | NOT NULL                   | Free memory in MB         |
| cpu_idle        | INT2      | NOT NULL                   | CPU idle percentage       |
| cpu_kernel      | INT2      | NOT NULL                   | CPU kernel time percentage|
| disk_io         | INT4      | NOT NULL                   | Disk I/O operations count |
| disk_available  | INT4      | NOT NULL                   | Available disk space in MB|

# Test

Testing involved executing each Bash script and verifying data insertion into the PostgreSQL database. The scripts executed successfully, and the database tables were populated accurately.

# Deployment

The project was deployed using GitHub for version control, Docker for managing the PostgreSQL container, and crontab for automating periodic data collection tasks.

# Improvements

- Improve error handling and logging in scripts.
- Implement data validation checks before inserting data into the database.
- Establish data retention policies to manage database size over time.
