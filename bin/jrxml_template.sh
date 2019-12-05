#!/bin/bash
source ../.config.sh
TABLE=$1
HEADER=$2
#mapfile -t collist < <(mysql -B --column-names=0 -h127.0.0.1 -uroot -pevolvus*123 -e "SELECT
#concat(COLUMN_NAME,'|',least(200,case when data_type not in ('VARCHAR','CHAR') then 200 else character_maximum_length end),'|',data_type)  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'project_management' AND TABLE_NAME = 'products' order by ORDINAL_POSITION;")


collist=($(sqlplus -s precision/987#654#32Masterlove@GLFNCMI<<eof
set pages 0
set head off
set feed off
select column_name||'|'||200||'|'||data_type||'|'||nvl(data_scale,0) from all_tab_columns where table_name = '$TABLE'  order by column_id;
exit
eof))

#collist=("id" "Product_Name" "Product Descrition" "isCOE" "Product Manager" "Product Director" "profit_centre")
#collen=(50 100 300 50 100 100 50)
FA1="<field name='"
FA11="' class='java."
FA12="'>"
FA2="<property name='com.jaspersoft.studio.field.label' value='"
FA21="'/>"
FA3="<property name='com.jaspersoft.studio.field.tree.path' value='"
FA31="'/> "
FA4="</field>"

FB1="<staticText>"
FB2="<reportElement mode='Opaque' x='"
FB21="' y='0' width='"
FB22="' height='${COLUMN_HEIGHT}' backcolor='${COLUMN_BACK_COLOR}' uuid='"
FB23="'>"
FB3="<property name='com.jaspersoft.studio.spreadsheet.connectionID' value='"
FB31="'/>"
FB4="</reportElement>"
FB5="<textElement textAlignment='Center'>"
FB6="<font size='${COLUMN_FONT_SIZE}' fontName='${COLUMN_FONT_TYPE}' isBold='true'/>"
FB7="</textElement>"
FB8="<text><![CDATA["
FB81="]]></text>"
FB9="</staticText>"


FC1="<textField >"
FC1FLOAT="<textField isStretchWithOverflow='true' pattern='${FLOAT_PATTERN}"
FC1DATE="<textField isStretchWithOverflow='true' pattern='${DATE_PATTERN}'>"

FCX2="<reportElement  x='"
FCX21="' y='0' width='"
FCX22="' height='${COLUMN_HEIGHT}' uuid='"
FCX23="'>"

#this has to be single quotes or the $F vanishes in heredocs
FC2='<textFieldExpression><![CDATA[$F{'
FC21="}]]></textFieldExpression>"
FC3="</textField>"
FC4="<textElement textAlignment='Right'/>"

FBOXA="<box>"
FBOXB="<pen lineWidth='0.5'/>"
FBOXC="</box>"

FBOX1="	<topPen lineWidth='0.5' lineStyle='Solid' lineColor='#000000'/>"
FBOX2="	<leftPen lineWidth='0.5' lineStyle='Solid' lineColor='#000000'/>"
FBOX3="	<bottomPen lineWidth='0.5' lineStyle='Solid' lineColor='#000000'/>"
FBOX4="	<rightPen lineWidth='0.5' lineStyle='Solid' lineColor='#000000'/>"

CONN1='de3a888a-9c4a-48e6-8f13-679d0708aed'
CONN2='90627c11-88ad-4e8e-90d6-799c451e9a3'
CONN3='552ccdff-69ba-439d-85ad-a946cc00599'



cat << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Jaspersoft Studio version 6.10.0.final using JasperReports Library version 6.10.0-unknown  -->
<jasperReport xmlns="http://jasperreports.sourceforge.net/jasperreports" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://jasperreports.sourceforge.net/jasperreports http://jasperreports.sourceforge.net/xsd/jasperreport.xsd" name="Blank_A4_1" language="javascript" pageWidth="842" pageHeight="595" orientation="Landscape" whenNoDataType="NoDataSection" columnWidth="802" leftMargin="20" rightMargin="20" topMargin="20" bottomMargin="20" isIgnorePagination="true" uuid="c6cfa916-021a-4d19-8a3f-5b15fcebf617">
	<property name="com.jaspersoft.studio.data.sql.tables" value=""/>
	<property name="com.jaspersoft.studio.data.defaultdataadapter" value="Sample DB"/>
	<property name="net.sf.jasperreports.export.xls.one.page.per.sheet" value="true"/>
	<property name="net.sf.jasperreports.export.xls.remove.empty.space.between.rows" value="true"/>
	<property name="net.sf.jasperreports.export.xls.remove.empty.space.between.columns" value="true"/>
	<property name="net.sf.jasperreports.export.xls.white.page.background" value="false"/>
	<property name="net.sf.jasperreports.export.xls.detect.cell.type" value="true"/>
	<property name="net.sf.jasperreports.export.xls.ignore.graphics" value="false"/>
	<property name="net.sf.jasperreports.page.break.no.pagination" value="apply"/>
	<property name="net.sf.jasperreports.export.xls.sheet.names.all" value="Data/Footnotes"/>
	<property name="net.sf.jasperreports.export.xls.freeze.row" value="3"/>
	<property name="net.sf.jasperreports.print.keep.full.text" value="true"/>
	<property name="net.sf.jasperreports.exports.xls.font.size.fix.enabled" value="false"/>
	<property name="com.jaspersoft.studio.unit." value="pixel"/>
	<property name="com.jaspersoft.studio.unit.pageHeight" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.pageWidth" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.topMargin" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.bottomMargin" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.leftMargin" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.rightMargin" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.columnWidth" value="pixel"/>
	<property name="com.jaspersoft.studio.unit.columnSpacing" value="pixel"/>
	<!-- @Anish
			Here twe mention the query. It is always select * from <<table name>> below the products table must be replaced by table name.
				The table name must come from operator parameter
	-->
	<queryString language="SQL">
		<![CDATA[select * from ${TABLE}]]>
	</queryString>
	<!-- @Anish
		Here you need to loop [Velocity foreach] depending on the number of columns in the table we add fields.
		We need to specify class name (based on data type) and 	column name 	<property name="com.jaspersoft.studio.field.label" value="id"/>
		class java.lang.Integer or java.lang.String needs to be appropriately replaced
  -->
$(
for col in "${collist[@]}"; do
  colname=$(echo $col | cut -d "|" -f 1)
  collen=$(echo $col | cut -d "|" -f 2)
	coltype=$(echo $col | cut -d "|" -f 3)
	colscale=$(echo $col | cut -d "|" -f 4)
	typtrn=""
	if [ $coltype = "int" ]
	then
			typtrn="lang.Integer"
	elif [ $coltype = "NUMBER" ] && [ $colscale -ne 0 ];
	then
			typtrn="lang.Float"
	elif [ $coltype = "DATE" ]
	then
			typtrn="util.Date"
	else
			typtrn="lang.String"
	fi
	printf '%020s\n' "${FA1}${colname}${FA11}${typtrn}${FA12}"
	printf '%4s\n' "${FA2}${colname}${FA21}"
	printf '%4s\n' "${FA3}${TABLE}${FA31}"
	printf '%2s\n\n' "${FA4}"

done
)

	<background>
		<band splitType="Stretch">
			<property name="com.jaspersoft.studio.layout" value="com.jaspersoft.studio.editor.layout.spreadsheet.SpreadsheetLayout"/>
		</band>
	</background>
	<title>
		<band height="44" splitType="Stretch">
			<staticText>
				<reportElement x="0" y="14" mode="Opaque" width="400" height="${HEADER_HEIGHT}" backcolor="${HEADER_BACK_COLOR}" uuid="48b31c60-4e24-4a63-b6eb-6c7c0275b003"/>
				<box>
					<pen lineWidth="0.5"/>
				</box>
				<textElement textAlignment="Left">
					<font fontName="${HEADER_FONT_TYPE}" size="${HEADER_FONT_SIZE}" isBold="true"/>
				</textElement>
				<!-- @Anish
					This is the report header
					This again can come from operator parameter.
				-->
				<text><![CDATA[${HEADER}]]></text>
			</staticText>
		</band>
	</title>
	<columnHeader>
		<!-- @Anish
		These are Column headers
			Here again loop. For each loop  changing -  are
				1) x coordinate
				2) width
				3) Column name in <text><![CDATA[id]]></text>
			We could use the oracle data type of column to fix the width and x coordinate.
			x coordinate = previous column x coordinate (first column this will be zero)+ previous column width
			width = column size of oracle
			Please note x,y,width,height store pixel

		-->
		<band height="30" splitType="Stretch">
			<property name="com.jaspersoft.studio.layout" value="com.jaspersoft.studio.editor.layout.spreadsheet.SpreadsheetLayout"/>

			$(
			i=0
			x=0
			for col in "${collist[@]}"; do
        colname=$(echo $col | cut -d "|" -f 1)
        wdth=$(echo $col | cut -d "|" -f 2)
				coltype=$(echo $col | cut -d "|" -f 3)

				str="${col// /_}"

				printf '%2s\n' "${FB1}"

				printf '%4s\n' "${FB2}${x}${FB21}${wdth}${FB22}${CONN1}${i}${FB23}"
				printf '%4s\n' "${FB3}${CONN2}${i}${FB31}"
				printf '%2s\n' "${FB4}"

				printf '%2s\n' "${FBOXA}"
				printf '%2s\n' "${FBOXB}"
				printf '%2s\n' "${FBOXC}"

				printf '%2s\n' "${FB5}"
				printf '%2s\n' "${FB6}"
				printf '%2s\n' "${FB7}"
				printf '%2s\n' "${FB8}${colname^^}${FB81}"
				printf '%2s\n' "${FB9}"
				i=$((i+1))
				x=$((x+wdth))

			done
			)

		</band>
	</columnHeader>
	<detail>
		<band height="43" splitType="Immediate">
			<property name="com.jaspersoft.studio.unit.height" value="px"/>
			<property name="com.jaspersoft.studio.layout" value="com.jaspersoft.studio.editor.layout.spreadsheet.SpreadsheetLayout"/>
			<!-- @Anish
			These are data
				Here again loop. For each loop  changing -  are
					1) x coordinate
					2) width
					3) Column name in <textFieldExpression><![CDATA[$F{id}]]></textFieldExpression>
				We could use the oracle data type of column to fix the width and x coordinate.
				x coordinate = previous column x coordinate (first column this will be zero)+ previous column width
				width = column size of oracle
				Please note x,y,width,height store pixel

			-->

			$(
			i=0
			x=0
			for col in "${collist[@]}"; do
        colname=$(echo $col | cut -d "|" -f 1)
        wdth=$(echo $col | cut -d "|" -f 2)
				coltype=$(echo $col | cut -d "|" -f 3)
				colscale=$(echo $col | cut -d "|" -f 4)

	                        if [ $coltype = "NUMBER" ] && [ $colscale -ne 0 ];
				then
						printf '%2s' "${FC1FLOAT}"
					if [ $colscale -eq 2 ];
					then
						printf '%.s0' {1..2}
					elif [ $colscale -eq 6 ];
					then
						printf '%.s0' {1..6}
					elif [ $colscale -eq 7 ];
					then
						printf '%.s0' {1..7}
					else
						printf '%.s0' {1..2}
					fi
					printf "'>\n"	
						
				elif [ $coltype = "DATE" ]
				then
						printf '%2s\n' "${FC1DATE}"
				else
					printf '%2s\n' "${FC1}"
				fi
				str="${colname// /_}"
				printf '%4s\n' "${FCX2}${x}${FCX21}${wdth}${FCX22}${CONN3}${i}${FCX23}"
				printf '%4s\n' "${FB3}${CONN2}${i}${FB31}"
				printf '%2s\n' "${FB4}"
				printf '%2s\n' "${FBOXA}"
				printf '%2s\n' "${FBOXB}"
				printf '%2s\n' "${FBOXC}"
	                        if [ $coltype = "NUMBER" ] && [ $colscale -ne 0 ];
				then
					printf '%2s\n' "${FC4}"
				fi
				printf '%2s\n' "${FC2}${colname}${FC21}"
				printf '%2s\n' "${FC3}"

				i=$((i+1))
				x=$((x+wdth))

			done
			)

		</band>
	</detail>
</jasperReport>

EOF
