\c host_agent

BEGIN;

CREATE TABLE IF NOT EXISTS PUBLIC.host_info 
(
    id               SERIAL PRIMARY KEY, 
    hostname         VARCHAR NOT NULL UNIQUE, 
    cpu_number       INT2 NOT NULL, 
    cpu_architecture VARCHAR NOT NULL, 
    cpu_model        VARCHAR NOT NULL, 
    cpu_mhz          FLOAT8 NOT NULL, 
    l2_cache         INT4 NOT NULL, 
    "timestamp"      TIMESTAMP NULL, 
    total_mem        INT4 NULL 
);

CREATE TABLE IF NOT EXISTS PUBLIC.host_usage 
(
    "timestamp"    TIMESTAMP NOT NULL, 
    host_id        INT NOT NULL, 
    memory_free    INT4 NOT NULL, 
    cpu_idle       INT2 NOT NULL, 
    cpu_kernel     INT2 NOT NULL, 
    disk_io        INT4 NOT NULL, 
    disk_available INT4 NOT NULL, 
    CONSTRAINT host_usage_host_info_fk FOREIGN KEY (host_id) REFERENCES host_info(id)
);

COMMIT;
