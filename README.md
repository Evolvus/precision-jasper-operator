# precision-jasper-operator
This is an interesting Module developed to create an excel file from RDBMS table.
It uses - 
1) Bash 4+
2) JaspersStarter : http://jasperstarter.cenote.de
3) Java 8

## Usage
### Download the program
git clone https://github.com/prashantevolvus/precision-jasper-operator.git
### create container.reg
report_name,table_name,report_header
### Execute
run.sh container.reg


## Things to do
1) Right now it supports MySQL and Oracle. Need to support more RDBMS
2) Integrate with Precision100


## Report Customisation
Use the .config.sh to customise your report
Some of the things that you can customise is given below.
Make sure that the fonts are available otherwise it does not compile.

### Column level customisation --> 
COLUMN_BACK_COLOR="#CEDE1F"

COLUMN_FONT_TYPE="Arial"

COLUMN_FONT_SIZE="12"

COLUMN_HEIGHT="15"

### Header Customisation -->
HEADER_BACK_COLOR="#CEDE1F"

HEADER_FONT_TYPE="Arial"

HEADER_FONT_SIZE="16"

HEADER_HEIGHT="30"

### Data format Customisation -->
FLOAT_PATTERN=#,##0.00

DATE_PATTERN="d-M-yyyy"

