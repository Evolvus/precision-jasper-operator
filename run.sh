#!/usr/local/bin/bash


echo "Generating jrxml from the template..."
cd bin
./jrxml_template.sh products "Product Report" > ../temp/prod.jrxml
echo "Compiling JRXML to Jasper..."
./jasperstarter cp -o ../temp/prod ../temp/prod.jrxml
echo "Running the report..."
./jasperstarter pr ../temp/prod.jasper -o ../output/prod -f xlsx -t mysql -H 127.0.0.1 -u root -p evolvus*123 -n project_management --db-driver com.mysql.cj.jdbc.Driver --jdbc-dir ../lib/.
echo "Report generated."
cd -
