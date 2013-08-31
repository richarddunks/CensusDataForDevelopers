if [ -z $1 ]; then
  DB_HOSTNAME="localhost"
else
  DB_HOSTNAME=$1  
fi

if [ -z $2 ]; then
  DB_USERNAME=$USER
else
  DB_USERNAME=$2
fi

if [ -z $3 ]; then
  DATABASE="postgres"
else
  DATABASE=$3
fi

if [ -z $4 ]; then
  DB_PORT="5432"
else
  DB_PORT=$4
fi

if [ -z $5 ]; then
  DB_SCHEMA="public"
else
  DB_SCHEMA=$5
fi

LOOPFLAG=0
while [ 0 -eq $LOOPFLAG ]; do
  echo "The hostname is $DB_HOSTNAME, the username is $DB_USERNAME, the database name is $DATABASE, the port is $DB_PORT, and the schema name is $DB_SCHEMA"
  echo "Is this correct and do you have the password in your ~/.pgpass file (y/n)? (your life will suck for the next 20 minutes if it's not the right host or you don't have the configuration information in .pgpass so check it now)"
  read response

  if [ $response = "y" ]; then
    LOOPFLAG=1
  else
    echo "Enter hostname"
    read DB_HOSTNAME
    echo "Enter username"
    read DB_USERNAME
    echo "Enter database name"
    read DATABASE
    echo "Enter port number"
    read DB_PORT
    echo "Enter schema name"
    read DB_SCHEMA
  fi

done
#end variable setting process

#create folder for demographic data 
mkdir -m 755 demographics_data/

#enter into folder
cd demographics_data/

echo "Downloading demographic profile table from US Census website"

#Download the 2010 demographic profile file from census website
wget "http://www2.census.gov/geo/tiger/TIGER2010DP1/Tract_2010Census_DP1.zip"

#unzip file
unzip -d ./ Tract_2010Census_DP1.zip

#upload to DATABASE
shp2pgsql -I -s 4269 "Tract_2010Census_DP1.shp" $DB_SCHEMA.dp1 | psql -h $DB_HOSTNAME -U $DB_USERNAME -p $DB_PORT -d $DATABASE -q




