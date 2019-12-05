#!/bin/bash

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
  
  ./jasperstarter pr ../temp/${pd1}.jasper -o ../output/${pd1} -f xlsx -t oracle --db-sid GLFNCMI -u precision -p 987#654#32Masterlove -H 10.138.2.33 --db-port 1521 --jdbc-dir ../lib
 
  echo "Report generated."

done < $1
