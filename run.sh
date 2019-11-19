#!/usr/local/bin/bash

cd bin
while read -r line;
do
  pd1=$(echo $line | cut -d "," -f 1)
  TABLE=$(echo $line | cut -d "," -f 2)
  HEADER=$(echo $line | cut -d "," -f 3)
  echo "Generating jrxml from the template..."
  echo $HEADER
  ./jrxml_template.sh $TABLE "$HEADER" > ../temp/"$pd1".jrxml
  echo "Compiling JRXML to Jasper..."
  ./jasperstarter cp -o ../temp/"$pd1" ../temp/"$pd1".jrxml
  echo "Running the report..."
  ./jasperstarter pr ../temp/${pd1}.jasper -o ../output/${pd1} -f xlsx -t mysql -H 127.0.0.1 -u root -p evolvus*123 -n project_management --db-driver com.mysql.cj.jdbc.Driver --jdbc-dir ../lib/.
  echo "Report generated."

done < $1
