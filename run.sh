#!/usr/local/bin/bash
source ./.config.sh

usageOption () {
  echo "Usage: run.sh [-c=<Container File Name> | -d=<Direct details>] [-f=<Report format>] [-r=<Report Name>] [-m=<Mode>]"
  echo "Container File Name - Provide Full path and container file name. If just the container file name is provided then it will be picked from current directory"
  echo "Direct Details - <report_name>,<table_name>,<report_header> comma separated single report generation"
  echo "Report format -  [Default xlsx] Available format view, xlsx, csv, pdf, rtf, xls, xlsMeta,  docx, odt, ods, pptx, csvMeta, html, xhtml, xml, jrprint"
  echo "Report Name - [Default All reports] If only one report needs to be executed. This report should be in the container file."
  echo "Mode - [Default BOTH] Available Mode COMPILE: Generates JRXML and Compiles to JASPER | EXECUTE: Generates Report | BOTH: COMPILES AND EXECUTES"
}

processReport () {
  echo "Processing Report $HEADER"
  if [[ ${MODE^^} == "BOTH" || ${MODE^^} == "COMPILE" ]] ; then
    echo "Generating jrxml from the template..."
    ./bin/jrxml_template.sh $TABLE "$HEADER" > ./temp/"$REPORTNAME".jrxml
    echo "Compiling JRXML to Jasper..."
    ./bin/jasperstarter cp -o ./temp/"$REPORTNAME" ./temp/"$REPORTNAME".jrxml
  fi
  if [[ ${MODE^^} == "BOTH" || ${MODE^^} == "EXECUTE" ]] ; then
    echo "Running the report..."
    if [ "$DB_TYPE" == "MYSQL" ]; then
      ./bin/jasperstarter pr ./temp/${REPORTNAME}.jasper -o ./output/${REPORTNAME} -f $REPORTFORMAT -t mysql -u $MYSQL_USER -p $MYSQL_PASSWORD -H $MYSQL_HOST --db-port $MYSQL_PORT -n $DB_DEF_SCHEMA --jdbc-dir ./lib
    elif [ "$DB_TYPE" == "ORACLE" ]; then
      ./bin/jasperstarter pr ./temp/${REPORTNAME}.jasper -o ./output/${REPORTNAME} -f $REPORTFORMAT -t oracle --db-sid $ORA_SID -u $ORA_USER -p $ORA_PASSWORD -H $ORA_HOST --db-port $ORA_PORT -n $DB_DEF_SCHEMA --jdbc-dir ./lib
    fi
  fi
  echo "Report generated - $HEADER"
}

retrieveDirect () {
  REPORTNAME=$(echo $DIRECT | cut -d "," -f 1)
  TABLE=$(echo $DIRECT | cut -d "," -f 2)
  HEADER=$(echo $DIRECT | cut -d "," -f 3)
}

processContainer () {
  while read -r DIRECT;
  do
    if [[ ${DIRECT:0:1} == "#" ]] ; then continue; fi
    if [[ -z $DIRECT ]] ; then continue; fi

    retrieveDirect

    if [[ ! -z $SPECIFICREPORT  ]] && [[ $REPORTNAME != $SPECIFICREPORT ]] ; then continue; fi

    processReport

  done < $CONTAINER
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
    -d=*|--direct=*)
      DIRECT="${i#*=}"
      if [[ -z $DIRECT ]] ; then
        echo "ERROR: Direct value is empty. Exiting..."
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

if [[ ! -z $CONTAINER ]] ; then
  processContainer
elif [[ ! -z $DIRECT ]]; then
  retrieveDirect
  processReport
else
  echo "ERROR: Container or Direct Value not provided. Exiting..."
  echo ""
  usageOption
  exit -1
fi
