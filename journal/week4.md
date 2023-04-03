# Week 4 — Postgres and RDS

## Provision RDS Instance

```sh
aws rds create-db-instance \
  --db-instance-identifier cruddur-db-instance \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version  14.6 \
  --master-username Zabuza \
  --master-user-password Zabuza007 \
  --allocated-storage 20 \
  --availability-zone us-east-1a \
  --backup-retention-period 0 \
  --port 5432 \
  --no-multi-az \
  --db-name cruddur \
  --storage-type gp2 \
  --publicly-accessible \
  --storage-encrypted \
  --enable-performance-insights \
  --performance-insights-retention-period 7 \
  --no-deletion-protection
```

> This will take about 10-15 mins

> Always remember when you turn off the RDS on the aws console it will come upp after 7days(do more research)


# Next step
To connect to psql via the psql client cli tool remember to use the host flag to specific localhost.

```
psql -Upostgres --host localhost
```


- Create a DB
```sql
CREATE database cruddur;
```


- Create a folder called db in the backend and add a file called schema.sql


## Add UUID Extension

We are going to have Postgres generate out UUIDs.
We'll need to use an extension called:
```
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

## Import Script

We'll create a new SQL file called `schema.sql`
and we'll place it in `backend-flask/db`

cd to to backend directory and paste:

The command to import:
```
psql cruddur < db/schema.sql -h localhost -U postgres
```

- paste on the bash terminal to export thr connection url:
```
export CONNECTION_URL="postgresql://postgres:password@localhost:5432/cruddur"
```

then run :
```
psql $CONNECTION_URL
```
To test the connection

![Alt text](../journal_images/psql.png)


##
we created a new folder called bin inside the backend-flask folder, and created 3 files
db-create
db-drop
db-schema-load
use the ccommand to locate the usrbin:
```
whereis bash
```

inside those three files paste the text:
```sh
#! usr/bin/bash
```

- cd to the backend-flask directory and we are going to change their mode and grant this files user and exceute permisssion:
```sh
chmod u+x bin/db-create
```
```sh
chmod u+x bin/db-drop
```
```sh
chmod u+x bin/db-schema-load
```

