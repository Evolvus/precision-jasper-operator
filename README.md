# precision-jasper-operator
This is an interesting Module developed to create an excel file from RDBMS table.
It uses -
1) Bash 4+ [Tested on Linux and Mac only]
2) JaspersStarter : http://jasperstarter.cenote.de [Library is packaged ]
3) Java 8
4) JasperReports [Library is packaged]

## Usage
### Download the program
git clone https://github.com/prashantevolvus/precision-jasper-operator.git
### create container.reg
report_name,table_name,report_header

**report_name** - This is used to identify the report. This will be used for the  report file name.  
**table_name** - If only table name is provided It will search for the table in default schema specified in DB_DEF_SCHEMA/USER in configuration file (.config.sh).
It can be qualified with schema/user like owner.table_name\
**report_header** - Descriptive report header inside the report.

### Database
.config.sh has the properties that connects to Database.
Right now only MySQL and Oracle is supported.
#### JDBC Driver
JasperReports uses JDBC driver to connect to the database. Since most JDBC drivers have complicated licensing issue, we do not ship the driver.

You need to copy the JDBC driver in the lib directory

### Execute
`Usage: run.sh -c=<Container File Name> [-f=<Report format>] [-r=<Report Name>] [-m=<Mode>]`  

|Parameter Name|Mandatory|Possible Values|Description|
|--------------|---------|---------------|-----------|
|Container File Name|Mandatory|Filename|Filename usually .reg file should be in root directory|
|Report format|Optional (Default xlsx)|view, xlsx, csv, pdf, rtf, xls, xlsMeta,  docx, odt, ods, pptx, csvMeta, html, xhtml, xml, jrprint|Report format to be generated|
|Report Name|Optional (Default All reports in the container)|report name in container|report name- the first parameter in container. Only this report will be generated|
|Mode|Optional (Defaults to BOTH)|BOTH / COMPILE / EXECUTE / COMPILE : Generates JRXML and Compiles to JASPER / EXECUTE : Generates Report / BOTH : COMPILES AND EXECUTES|



## Report Customisation
Use the .config.sh to customise your report
Some of the things that you can customise is given below.
Make sure that the fonts configured are available in the Linux otherwise jasper report does not compile.

The link below provides simple instruction to install the fonts -
https://medium.com/source-words/how-to-manually-install-update-and-uninstall-fonts-on-linux-a8d09a3853b0


### Column level customisation -->
```
COLUMN_BACK_COLOR="#CEDE1F"
COLUMN_FONT_TYPE="Arial"
COLUMN_FONT_SIZE="12"
COLUMN_HEIGHT="15"
```
### Header Customisation -->
```
HEADER_BACK_COLOR="#CEDE1F"
HEADER_FONT_TYPE="Arial"
HEADER_FONT_SIZE="16"
HEADER_HEIGHT="30"
```
### Data format Customisation -->
Refer MS Excel help for date and float formats
```
FLOAT_PATTERN=#,##0.00
DATE_PATTERN="d-M-yyyy"
```
## Licenses of libraries used
|Library|License|Version|
|-------|-------|-------|
|argparse4j|0.5.0|MIT|
|commons-beanutils|1.9.3|Apache 2.0|
|commons-collections|3.2.2|Apache 2.0|
|commons-digester|2.1.0|Apache 2.0|
|commons-logging|1.1.1|Apache 2.0|
|jasperreports|6.7.0|LGPL|
|jasperreports-fonts|6.0.0|LGPL|
|jasperstarter|-|Apache 2.0|
|log4j|1.2.17|Apache 2.0|
|rhino|1.7.7.2|MPL 2.0|

## Things to do
|Action No|Action|Priority|Status|
|---------|------|--------|------|
|1| Right now it supports MySQL and Oracle. Need to support more RDBMS|Low|Open|
|2| Integrate with Precision100|High|Open|
|3| Support CSV and PDF and make that configurable|High|Open|
|4| Execute individual report within the container through parameter|High|WIP|
|5| Banner at the start up|Low|Open|

## Thank you
A big thank you to -
1) Team of JasperStarter (http://jasperstarter.cenote.de/team-list.html) and specially to Volker Voßkämper and Barbora Berlinger.
2) Jasper Reports team
