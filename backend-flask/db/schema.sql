Zabuza007

postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]

export CONNECTION_URL="postgresql://postgres:password@localhost:5432/cruddur"

gp env CONNECTION_URL="postgresql://postgres:password@localhost:5432/cruddur"

export PROD_CONNECTION_URL="postgresql://cruddurroot:Zabuza007@cruddur-db-instance.cybtgwxoa2s0.us-east-1.rds.amazonaws.com"

gp env PROD_CONNECTION_URL="postgresql://cruddurroot:Zabuza007@cruddur-db-instance.cybtgwxoa2s0.us-east-1.rds.amazonaws.com"
