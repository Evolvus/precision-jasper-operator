#!/usr/local/bin/bash
source ./.config.sh

usageOption () {
  echo "Usage: run.sh -c=<Container File Name> [-f=<Report format>] [-r=<Report Name>] [-m=<Mode>]"
  echo "Container File Name - Should be available in the root directory of application"
  echo "Report format -  [Default xlsx] Available format view, xlsx, csv, pdf, rtf, xls, xlsMeta,  docx, odt, ods, pptx, csvMeta, html, xhtml, xml, jrprint"
  echo "Report Name - [Default All reports] If only one report needs to be executed. This report should be in the container file."
  echo "Mode - [Default BOTH] Available Mode COMPILE: Generates JRXML and Compiles to JASPER | EXECUTE: Generates Report | BOTH: COMPILES AND EXECUTES"
}

REPORTFORMAT="xlsx"
MODE="BOTH"
for i in "$@"
do
case $i in
    -c=*|--container=*)
    CONTAINER="${i#*=}"
    if [[ ! -s $CONTAINER ]] ; then
      echo "ERROR: File doesn't exist or is empty. Exiting..."
      usageOption
      exit -1
    fi
    ;;
    -m=*|--mode=*)
    MODE="${i#*=}"
    if [[ ${MODE^^} != "BOTH"  &&  ${MODE^^} != "COMPILE" && ${MODE^^} != "EXECUTE" ]] ; then
      echo "ERROR: Wrong mode provided. Available Mode - "
      echo "BOTH|COMPILE|EXECUTE"
      usageOption
      exit -1
    fi
    ;;
    -f=*|--reportformat=*)
    REPORTFORMAT="${i#*=}"
    check=`echo "view, xlsx, csv, pdf, rtf, xls, xlsMeta,  docx, odt, ods, pptx, csvMeta, html, xhtml, xml, jrprint," | grep $REPORTFORMAT","| wc -l`
    if [[ $check -ne "1" ]] ; then
      echo "ERROR: Unsupported report format. Choose one from Below - "
      echo "view, xlsx, csv, pdf, rtf, xls, xlsMeta,  docx, odt, ods, pptx, csvMeta, html, xhtml, xml, jrprint"
      usageOption
      exit -1
    fi
    ;;
    -r=*|--report=*)
    SPECIFICREPORT="${i#*=}"
    ;;
    *)
        echo "ERROR: Unknown Option. Exiting..."
        usageOption
        exit -1
    ;;
esac
done

if [ -z $CONTAINER ] ; then
  echo "ERROR: Container not provided. Exiting..."
  echo ""
  usageOption
  exit -1
fi



while read -r line;
do
  if [[ ${line:0:1} == "#" ]] ; then continue; fi
  if [[ -z $line ]] ; then continue; fi

  pd1=$(echo $line | cut -d "," -f 1)
  if [[ ! -z $SPECIFICREPORT  ]] && [[ $pd1 != $SPECIFICREPORT ]] ; then continue; fi

  TABLE=$(echo $line | cut -d "," -f 2)
  HEADER=$(echo $line | cut -d "," -f 3)
  echo "Processing Report $HEADER"


  if [[ ${MODE^^} == "BOTH" || ${MODE^^} == "COMPILE" ]] ; then
    echo "Generating jrxml from the template..."
    ./bin/jrxml_template.sh $TABLE "$HEADER" > ./temp/"$pd1".jrxml
    echo "Compiling JRXML to Jasper..."
    ./bin/jasperstarter cp -o ./temp/"$pd1" ./temp/"$pd1".jrxml

  fi
  if [[ ${MODE^^} == "BOTH" || ${MODE^^} == "EXECUTE" ]] ; then
    echo "Running the report..."
    if [ "$DB_TYPE" == "MYSQL" ]; then
      ./bin/jasperstarter pr ./temp/${pd1}.jasper -o ./output/${pd1} -f $REPORTFORMAT -t mysql -u $MYSQL_USER -p $MYSQL_PASSWORD -H $MYSQL_HOST --db-port $MYSQL_PORT -n $DB_DEF_SCHEMA --jdbc-dir ./lib
    elif [ "$DB_TYPE" == "ORACLE" ]; then
      ./bin/jasperstarter pr ./temp/${pd1}.jasper -o ./output/${pd1} -f $REPORTFORMAT -t oracle --db-sid $ORA_SID -u $ORA_USER -p $ORA_PASSWORD -H $ORA_HOST --db-port $ORA_PORT -n $DB_DEF_SCHEMA --jdbc-dir ./lib
    fi
  fi
  echo "Report generated - $HEADER"

done < $CONTAINER
