#!/bin/bash
source ./.config.sh

while read -r line;
do
  if [[ ${line:0:1} == "#" ]] ; then continue; fi
  if [ -z "$line" ] ; then continue; fi
  if [-z ]
  pd1=$(echo $line | cut -d "," -f 1)
  TABLE=$(echo $line | cut -d "," -f 2)
  HEADER=$(echo $line | cut -d "," -f 3)
  echo "Processing Report $HEADER"
  echo "Generating jrxml from the template..."
  ./bin/jrxml_template.sh $TABLE "$HEADER" > ./temp/"$pd1".jrxml
  echo "Compiling JRXML to Jasper..."
  ./bin/jasperstarter cp -o ./temp/"$pd1" ./temp/"$pd1".jrxml
  echo "Running the report..."

  if [ "$DB_TYPE" == "MYSQL" ]; then
    ./bin/jasperstarter pr ./temp/${pd1}.jasper -o ./output/${pd1} -f xlsx -t mysql -u $MYSQL_USER -p $MYSQL_PASSWORD -H $MYSQL_HOST --db-port $MYSQL_PORT -n $DB_DEF_SCHEMA --jdbc-dir ./lib
  elif [ "$DB_TYPE" == "ORACLE" ]; then
    ./bin/jasperstarter pr ./temp/${pd1}.jasper -o ./output/${pd1} -f xlsx -t oracle --db-sid $ORA_SID -u $ORA_USER -p $ORA_PASSWORD -H $ORA_HOST --db-port $ORA_PORT -n $DB_DEF_SCHEMA --jdbc-dir ./lib
  fi
  echo "Report generated - $HEADER"

done < $1
