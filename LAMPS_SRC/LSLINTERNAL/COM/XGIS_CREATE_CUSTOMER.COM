$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-04-23 09:47:56.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$!	FILE	XGIS_CREATE_CUSTOMER
$!	IDENT	'25AU92'
$!
$! 	Copyright ©  Laser-Scan Ltd, Cambridge, England
$!
$! 	Author Paul Hardy					PGH 21-Jun-1990
$!MOD	Modified						APB  7-Sep-1990
$!MOD	LSL$SITE_ROOT, LSL$XGIS_FLOW_ROOT and 
$!	LSL$XGIS_RESULT_ROOT directories created		TJH 16-Oct-1990
$!MOD	Now assumes POLYGONS always shipped, licence stuff
$!	added							TJH 07-Mar-1991
$!MOD	Tidies							TJH 12-Mar-1991
$!MOD	CUSTOMER name now limited to 16 characters (SPR 1134)	TJH 15-Mar-1991
$!MOD	IF RDB now copies pattern database from PUBLIC_ROOT
$! 								TJH 21-Mar-1991
$!MOD	HORIZON TELECOMMS specific stuff added			TJH 12-Jun-1991
$!MOD	Telecomns licence created				TJH 15-Aug-1991
$!MOD	Terrain visualisation licence option added.		JMC 23-Oct-1991
$!MOD	No longer creates data directories for real CUSTOMER.	TJH 11-Nov-1991
$!MOD	Now handles UPDATE as licenced option in METROPOLIS.	TJH 27-Jan-1992
$!MOD	Advanced gazetteer, land charges and land terrier 
$!	licence options.					TJH 12-Feb-1992
$!MOD	All required directories now created			TJH 27-Feb-1992
$!MOD	Move XGIS from LSL$SOURCE_ROOT to LSL$XGIS_SOURCE_ROOT	APB 11-Mar-1992
$!MOD	Full account taken of product packaging			TJH 01-Apr-1992
$!MOD	MAPPER added						TJH 26-May-1992
$!MOD	MAPPER gazetteer option added				TJH 19-Jun-1992
$!MOD	EGDS added, and site root directories created		TJH 07-Jul-1992
$!MOD	Add COMPOSITE TEXT option				APB 23-Apr-1993
$!
$! Command file to create directories for a new XGIS CUSTOMER.
$! Specific to LSL
$!
	WS := WRITE SYS$OUTPUT
$!
$! Assume things
$!
$	ROOT="LSL$XGIS_SOURCE_ROOT:"
$	PREFIX="$XGIS_"
$	POLYGONS="N"
$	TERRAIN = "N"
$	TERRAIN_VISUALISATION = "N"
$	TELECOMMS = "N"
$	NETWORK = "N"
$	LINKNODE = "N"
$	ADV_GAZ = "N"
$	GAZ = "N"
$	LAND_CHARGES = "N"
$	LAND_TERRIER = "N"
$	COMPOSITE_TEXT = "N"
$!
$!
$	TYPE SYS$INPUT

+------------------------------------------------------------------------------+
|                                                                              |
|          XGIS customer generation procedure XGIS_CREATE_CUSTOMER             |
|                                                                              |
|                 For use with XGIS Version 1.3 and above                      |
|                                                                              |
|          If you plan to create an RDB database ensure that there are         |
|          at least 1000 free blocks on LSL$DATA_ROOT: !                       |
|                                                                              |
|          This procedure calls XGISINI for the new customer so any            |
|          existing XGIS initialisation will be superseded.                    |
|                                                                              |
|                    Type Ctrl/Z if you wish to exit                           |
|                                                                              |
+------------------------------------------------------------------------------+


$       READ/END=EXIT/PROMPT="Do you wish ONLY to generate a new licence file for this customer? [N] " SYS$COMMAND LICENCE_ONLY
$!
$! Get customer name
$!
$GET_CUSTOMER:
$	WS " "
$       READ/END=EXIT/PROMPT="Customer name e.g. LSLCAM (Max 16 characters) " SYS$COMMAND NEW_CUSTOMER_NAME
$	NEW_CUSTOMER_NAME=F$EDIT(NEW_CUSTOMER_NAME,"UPCASE,COLLAPSE")
$	IF NEW_CUSTOMER_NAME.EQS."" THEN GOTO GET_CUSTOMER
$	IF F$LENGTH(NEW_CUSTOMER_NAME).GT.16
$	THEN
$	   WS " "
$	   WS "Too many characters in ""''NEW_CUSTOMER_NAME'"". Try again.
$	   WS " "
$	   GOTO GET_CUSTOMER
$	ENDIF
$	CUSTDIR=F$SEARCH("''ROOT'[000000]$XGIS_''NEW_CUSTOMER_NAME'.DIR;1")
$	IF LICENCE_ONLY 
$	THEN 
$	   IF CUSTDIR.EQS."" 
$	   THEN
$	      NEW_CUSTOMER_NAMENAM=F$PARSE(CUSTDIR,,,"NAME")
$	      WS "Customer ",NEW_CUSTOMER_NAME," does not exist so cannot generate a new licence for it"
$	      NEW_CUSTOMER_NAME=""
$	      GOTO GET_CUSTOMER
$	   ENDIF
$	ELSE
$	   IF CUSTDIR.NES."" 
$	   THEN
$	      NEW_CUSTOMER_NAMENAM=F$PARSE(CUSTDIR,,,"NAME")
$	      WS NEW_CUSTOMER_NAME," is invalid new customer ([''NEW_CUSTOMER_NAMENAM'] exists)."
$	      NEW_CUSTOMER_NAME=""
$	      GOTO GET_CUSTOMER
$	   ENDIF
$	ENDIF
$	PATHSPEC=ROOT+"["+PREFIX+NEW_CUSTOMER_NAME
$	CUSTOMER=NEW_CUSTOMER_NAME
$!
$! Get PRODUCT name
$!
$GET_PRODUCT:
$	WS " "
$       READ/END=EXIT/PROMPT="PRODUCT name (Horizon/Metropolis/Mapper/EGDS) [Metropolis] " SYS$COMMAND PRODUCT_NAME
$	PRODUCT_NAME=F$EDIT(PRODUCT_NAME,"UPCASE,COLLAPSE")
$	IF PRODUCT_NAME.EQS."" THEN PRODUCT_NAME="METROPOLIS"
$	PRODUCT_NAMELEN=F$LENGTH(PRODUCT_NAME)
$       IF PRODUCT_NAME.EQS.F$EXTRACT(0,PRODUCT_NAMELEN,"METROPOLIS")
$	THEN 
$	   PRODUCT_NAME="METROPOLIS"
$	ELSE
$          IF PRODUCT_NAME.EQS.F$EXTRACT(0,PRODUCT_NAMELEN,"HORIZON")
$	   THEN 
$	      PRODUCT_NAME="HORIZON"
$	   ELSE
$             IF PRODUCT_NAME.EQS.F$EXTRACT(0,PRODUCT_NAMELEN,"MAPPER")
$	      THEN 
$	         PRODUCT_NAME="MAPPER"
$	      ELSE
$                IF PRODUCT_NAME.EQS.F$EXTRACT(0,PRODUCT_NAMELEN,"EGDS")
$	         THEN 
$	            PRODUCT_NAME="EGDS"
$	         ELSE
$	            WS PRODUCT_NAME," is invalid. Products are METROPOLIS, MAPPER, HORIZON and EGDS"
$	            PRODUCT_NAME=""
$ 	            GOTO GET_PRODUCT
$	         ENDIF
$	      ENDIF
$	   ENDIF
$	ENDIF
$	PRODUCT = PRODUCT_NAME
$!
$! What flavour of HORIZON or METROPOLIS is it - or is it EGDS or MAPPER?
$GET_PRODUCT_TYPE:
$	WS " "
$	PRODUCT_TYPE=""
$	IF PRODUCT.EQS."MAPPER" THEN GOTO GET_LICENCE_DETAILS
$	IF PRODUCT.EQS."EGDS" THEN GOTO GET_LICENCE_DETAILS
$	IF PRODUCT.EQS."METROPOLIS"
$	THEN
$         READ/END=EXIT/PROMPT="Is ''CUSTOMER' a METROPOLIS ""Query"", ""Update"" or ""Analysis"" sale? [ANALYSIS] " -
				SYS$COMMAND PRODUCT_TYPE
$	   PRODUCT_TYPE=F$EDIT(PRODUCT_TYPE,"UPCASE,COLLAPSE")
$	   IF PRODUCT_TYPE .EQS."" 
$	   THEN 
$	      PRODUCT_TYPE="ANALYSIS"
$	   ELSE
$	      IF PRODUCT_TYPE.EQS.F$EXTRACT(0,F$LENGTH(PRODUCT_TYPE),"ANALYSIS")
$	      THEN
$	         PRODUCT_TYPE="ANALYSIS"
$	      ELSE
$	         IF PRODUCT_TYPE.EQS.F$EXTRACT(0,F$LENGTH(PRODUCT_TYPE),-
							"UPDATE")
$	         THEN
$	            PRODUCT_TYPE="UPDATE"
$	         ELSE
$	            IF PRODUCT_TYPE.EQS.F$EXTRACT(0,F$LENGTH(PRODUCT_TYPE),-
							"QUERY")
$	            THEN
$	               PRODUCT_TYPE="QUERY"
$	   TYPE SYS$INPUT

As this is a METROPOLIS "Query" customer it will not receive a licence for
the UPDATE application. The Sales force are instructed to only sell METROPOLIS
"Query" to sites already having a METROPOLIS "Update" or METROPOLIS "Analysis"
product. It is important that the "Query" product is set up as a
separate $XGIS_* customer to avoid sharing of the licence file. If you are
unsure of what to do, type Ctrl_Z to abort and ask for assistance. 

$	            ENDIF
$	         ENDIF
$	      ENDIF
$	   ENDIF
$	ELSE
$         READ/END=EXIT/PROMPT="Is ''CUSTOMER' a HORIZON ""Datum"", ""Relief"" or ""View"" sale? [VIEW] " -
					SYS$COMMAND PRODUCT_TYPE
$	   PRODUCT_TYPE=F$EDIT(PRODUCT_TYPE,"UPCASE,COLLAPSE")
$	   IF PRODUCT_TYPE .EQS."" 
$	   THEN 
$	      PRODUCT_TYPE="VIEW"
$	   ELSE
$	      IF PRODUCT_TYPE.EQS.F$EXTRACT(0,F$LENGTH(PRODUCT_TYPE),"DATUM")
$	      THEN
$	         PRODUCT_TYPE="DATUM"
$	      ELSE
$	         IF PRODUCT_TYPE.EQS.F$EXTRACT(0,F$LENGTH(PRODUCT_TYPE),-
							"VIEW")
$	         THEN
$	            PRODUCT_TYPE="VIEW"
$	         ELSE
$	            IF PRODUCT_TYPE.EQS.F$EXTRACT(0,F$LENGTH(PRODUCT_TYPE),-
							"RELIEF")
$	            THEN
$	               PRODUCT_TYPE="RELIEF"
$	            ENDIF
$	         ENDIF
$	      ENDIF
$	   ENDIF
$	ENDIF
$	IF PRODUCT_TYPE.NES."ANALYSIS".AND.PRODUCT_TYPE.NES."UPDATE" -
		.AND.PRODUCT_TYPE.NES."DATUM".AND.PRODUCT_TYPE.NES."RELIEF" -
		.AND.PRODUCT_TYPE.NES."VIEW".AND.PRODUCT_TYPE.NES."QUERY"
$	THEN
$	   WS " "
$	   WS "Unknown ''PRODUCT' product type ""''PRODUCT_TYPE'"""
$	   WS " "
$	   GOTO GET_PRODUCT_TYPE
$	ENDIF
$!
$GET_LICENCE_DETAILS:
$	IF PRODUCT_TYPE.EQS."RELIEF".OR.PRODUCT_TYPE.EQS."VIEW" THEN TERRAIN="Y"
$	IF PRODUCT_TYPE.EQS."VIEW" THEN TERRAIN_VISUALISATION="Y"
$	IF PRODUCT_TYPE.EQS."ANALYSIS".OR.PRODUCT_TYPE.EQS."RELIEF" -
		.OR.PRODUCT_TYPE.EQS."VIEW"
$	THEN
$	   LINKNODE="Y"
$	   POLYGONS="Y"
$	ENDIF
$	TYPE SYS$INPUT

Which of the following optional XGIS utilities/applications are to be shipped?

$	IF PRODUCT.EQS."EGDS"
$	THEN
$          READ/END=EXIT/PROMPT="LINKNODE? " SYS$COMMAND LINKNODE
$          READ/END=EXIT/PROMPT="POLYGONS? " SYS$COMMAND POLYGONS
$	ENDIF
$	IF PRODUCT_TYPE.EQS."ANALYSIS"
$	THEN			! available on full metropolis only
$          READ/END=EXIT/PROMPT="LAND CHARGES? " SYS$COMMAND LAND_CHARGES
$          READ/END=EXIT/PROMPT="LAND TERRIER? " SYS$COMMAND LAND_TERRIER
$	ENDIF
$	IF PRODUCT_TYPE.EQS."ANALYSIS" -
	.OR.PRODUCT_TYPE.EQS."VIEW".OR.PRODUCT_TYPE.EQS."RELIEF" -
	.OR.PRODUCT.EQS."EGDS"
$	THEN
$          READ/END=EXIT/PROMPT="NETWORK? " SYS$COMMAND NETWORK
$	ENDIF
$	IF PRODUCT.EQS."MAPPER"
$	THEN
$          READ/END=EXIT/PROMPT="GAZETTEER? " SYS$COMMAND GAZ
$	ENDIF
$       READ/END=EXIT/PROMPT="ADVANCED GAZETTEER? " SYS$COMMAND ADV_GAZ
$       READ/END=EXIT/PROMPT="COMPOSITE TEXT? " SYS$COMMAND COMPOSITE_TEXT
$	IF PRODUCT.EQS."HORIZON"
$	THEN
$	   READ/END=EXIT/PROMPT="TELECOMMS? " SYS$COMMAND TELECOMMS
$	ENDIF
$!
$	WS " "
$	WS "Before starting to set up any aspect of this customer, please confirm"
$	IF PRODUCT_TYPE.EQS.""
$	THEN
$	   WS "that the customer is to be ''CUSTOMER' running ''PRODUCT'"
$	ELSE
$	   WS "that the customer is to be ''CUSTOMER' running a ''PRODUCT' ""''PRODUCT_TYPE'"""
$	ENDIF
$	EGDS="False"
$	IF PRODUCT.EQS."EGDS" THEN EGDS="True"
$	IF	     .NOT. LAND_CHARGES - 
		.AND..NOT. LAND_TERRIER -
		.AND..NOT. TELECOMMS -
		.AND..NOT. GAZ -
		.AND..NOT. ADV_GAZ -
		.AND..NOT. COMPOSITE_TEXT -
		.AND..NOT. NETWORK -
		.AND..NOT. (EGDS.AND.POLYGONS) -
		.AND..NOT. (EGDS.AND.LINKNODE)
$	THEN
$	   WS "with no optional utilities/applications."
$	ELSE
$	   WS "with the following optional utilities/applications:"
$	   WS " "
$	   IF EGDS.AND.POLYGONS THEN 	WS "            POLYGONS"
$	   IF EGDS.AND.LINKNODE THEN 	WS "            LINKNODE"
$	   IF TELECOMMS THEN 	WS "            TELECOMMS"
$	   IF LAND_CHARGES THEN WS "            LAND_CHARGES"
$	   IF LAND_TERRIER THEN WS "            LAND_TERRIER"
$	   IF ADV_GAZ THEN 	WS "            ADVANCED_GAZETTEER"
$	   IF GAZ THEN 		WS "            GAZETTEER"
$	   IF NETWORK THEN 	WS "            NETWORK"
$	   IF COMPOSITE_TEXT THEN 	WS "            COMPOSITE TEXT"
$	   WS " "
$	ENDIF
$!
$       READ/END=EXIT/PROMPT="OK to proceed? [YES] " SYS$COMMAND YES
$	YES=F$EDIT(YES,"UPCASE,COLLAPSE")
$	IF YES.EQS."" THEN YES="YES"
$	IF .NOT. YES
$	THEN
$	   WS " "
$	   WS "Abandoning customer creation/licence update."
$	   WS " "
$	   GOTO EXIT
$	ENDIF
$!	
$	IF LICENCE_ONLY THEN GOTO CREATE_LICENCE
$!
$GET_DBMS:
$	DEFDBMS = "RDB"
$	WS " "
$       READ/END=EXIT/PROMPT="Database system (Rdb/ORACLE/Ingres/IDM)? [Rdb] " SYS$COMMAND DBMS
$	DBMS=F$EDIT(DBMS,"UPCASE,COLLAPSE")
$	IF DBMS.EQS.""
$	THEN
$	   DBMS = DEFDBMS
$	   GOTO FAKE_CUST
$	ENDIF
$	IF DBMS .EQS. F$EXTRACT(0,F$LENGTH(DBMS),"RDB")
$	THEN
$	   DBMS="RDB"
$	   GOTO FAKE_CUST
$	ENDIF
$	IF DBMS .EQS. F$EXTRACT(0,F$LENGTH(DBMS),"INGRES")
$	THEN
$	   DBMS="INGRES"
$	   GOTO FAKE_CUST
$	ENDIF
$	IF DBMS .EQS. F$EXTRACT(0,F$LENGTH(DBMS),"ORACLE")
$	THEN
$	   DBMS="ORACLE"
$	   GOTO FAKE_CUST
$	ENDIF
$	IF DBMS .EQS. F$EXTRACT(0,F$LENGTH(DBMS),"IDM")
$	THEN
$	   DBMS="IDM"
$	   GOTO FAKE_CUST
$	ENDIF
$!
$	WS "Invalid RDBMS choice ""'DBMS'"". Try again."
$	GOTO GET_DBMS
$!
$FAKE_CUST:
$	TYPE SYS$INPUT

If you are generating a fake "customer" for LSL internal use only, the
procedure will now create all the required data directories on
LSL$XGIS_DATA_ROOT: and site specific directories on LSL$XGIS_SITE_ROOT:.
Clearly, if you are creating a new external customer there is no need to
generate all the data and site directories on Laser-Scan's system.

$       READ/END=EXIT/PROMPT="Is this a real (external) customer? [YES] " SYS$COMMAND EXTERNAL_CUST
$	IF EXTERNAL_CUST .OR. EXTERNAL_CUST .EQS. "" THEN EXTERNAL_CUST="Y"
$!
$! Now create directories
$!
$	WS " "
$	WS "Directory tree will be ''PATHSPEC'...]"
$	WS " "
$       READ/END=EXIT/PROMPT="OK to proceed? [YES] " SYS$COMMAND YES
$	YES=F$EDIT(YES,"UPCASE,COLLAPSE")
$	IF YES.EQS."" THEN YES="YES"
$	IF .NOT. YES
$	THEN
$	   WS " "
$	   WS "Abandoning customer creation/licence update."
$	   WS " "
$	   GOTO EXIT
$	ENDIF
$!
$	WS "Creating root directories..."
$	CREATE/DIR/LOG 'PATHSPEC'.CMD]
$	CREATE/DIR/LOG 'PATHSPEC'.COM]
$	CREATE/DIR/LOG 'PATHSPEC'.EXE]
$	CREATE/DIR/LOG 'PATHSPEC'.FRT]
$	CREATE/DIR/LOG 'PATHSPEC'.LOOKUP]
$	CREATE/DIR/LOG 'PATHSPEC'.REPORT]
$	CREATE/DIR/LOG 'PATHSPEC'.SQL]
$	CREATE/DIR/LOG 'PATHSPEC'.UIL]
$!
$! Copy template initialisation LCM and COM files to customer directory
$!
$	WS "Copying template initialisation files..."
$	WS "''PATHSPEC'.COM]XGIS_''CUSTOMER'_INI.COM created"
$	COPY/NOLOG LSL$XGIS_SOURCE_ROOT:[XGIS.COM]XGIS_TEMPLATE.COM -
		'PATHSPEC'.COM]XGIS_'CUSTOMER'_INI.COM
$	WS "''PATHSPEC'.COM]XGIS_CUSTOMER.COM created"
$	COPY/NOLOG LSL$XGIS_SOURCE_ROOT:[XGIS.CMD]XGIS_CUSTOMER.LCM -
		'PATHSPEC'.CMD]
$	WS "''PATHSPEC'.COM]XGIS_INI_CUSTOMER.COM created"
$	COPY/NOLOG LSL$XGIS_SOURCE_ROOT:[XGIS.CMD]XGIS_INI_CUSTOMER.LCM -
		'PATHSPEC'.CMD]
$!
$! Copy template EGDS specific initialisation files (if product EGDS)
$!
$	IF PRODUCT_NAME.EQS."EGDS"
$	THEN
$	   COPY/NOLOG LSL$XGIS_SOURCE_ROOT:[XGIS.COM]EGDS_WKSTN.DAT -
		'PATHSPEC'.LOOKUP]
$          WS "''PATHSPEC'.LOOKUP]EGDS_WKSTN.DAT created"
$	   COPY/NOLOG LSL$XGIS_SOURCE_ROOT:[XGIS.COM]EGDS_PROCESSES.DAT -
		'PATHSPEC'.LOOKUP]
$          WS "''PATHSPEC'.LOOKUP]EGDS_PROCESSES.DAT created"
$	ENDIF
$!
$	XGISINI 'PRODUCT_NAME' 'CUSTOMER' SOURCE 'DBMS'
$!
$! Create data directories
$!
$	IF EXTERNAL_CUST THEN GOTO GENERATE_DATABASE
$!
$	WS " "
$	WS "Data directories will be created on LSL$DATA_ROOT:[''PRODUCT'.''CUSTOMER']"
$	WS " "
$!
$       READ/END=EXIT/PROMPT="OK to proceed? [YES] " SYS$COMMAND YES
$	YES=F$EDIT(YES,"UPCASE,COLLAPSE")
$	IF YES.EQS."" THEN YES="YES"
$	IF .NOT. YES
$	THEN
$	   WS " "
$	   WS "Abandoning data directory creation."
$	   WS " "
$	   GOTO GENERATE_DATABASE
$	ENDIF
$!
$!------------------------------------------------------------------------------
$! Actually create the directories
$!
$!  N.B The argument to subroutine CREDIR can be changed to suit site 
$!      requirements. 
$!
$! Site root directories...
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT']
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER']
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.CMD]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.COM]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.EXE]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.FRT]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.LOOKUP]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.REPORT]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.SQL]
$	CALL CREDIR LSL$SITE_ROOT:['PRODUCT'.'CUSTOMER'.UIL]
$! Generic data directories...
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT']
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER']
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.IFF]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.KEYMAPS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.SECIFF]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.SECDTI]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.'DBMS']
$!
$! Create EGDS specific data directories
$!
$	IF EGDS
$	THEN
$	   CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.EGDS]
$	   CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.EGDS.DEMO]
$	   CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.EGDS.GCP]
$	   CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.EGDS.HISTORY]
$	   CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.EGDS.LOG]
$	ENDIF
$!
$! Create top level results and flowline directories
$!
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE]
$!
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.PLOTFILES]
$!
$	IF .NOT.LINKNODE THEN GOTO DO_POLYGONS
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.LINK_NODE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.LINK_NODE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.LINK_NODE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.LINK_NODE.START]
$DO_POLYGONS:
$	IF .NOT.POLYGONS THEN GOTO DO_TERRAIN
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.POLYGONS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.POLYGONS.CREATE.POLYGONS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.POLYGONS.CREATE.PIP]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.POLYGONS.OVERLAY]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.POLYGONS.LPP]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.POLYGONS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.POLYGONS.CREATE.POLYGONS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.POLYGONS.CREATE.PIP]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.POLYGONS.OVERLAY]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.POLYGONS.LPP]
$!
$DO_TERRAIN:
$	IF .NOT.TERRAIN THEN GOTO DO_NETWORK
$!
$! TERRAIN directories
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.ASPECT]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.SLOPES]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.COVERAGE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.HEIGHT]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.SHADE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.ASPECT]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.CONTOUR]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.COVERAGE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.HEIGHT]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.SHADE]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.SLOPES]
$!
$	IF .NOT.TERRAIN_VISUALISATION THEN GOTO DO_NETWORK
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TERRAIN.3DPICTURE]
$!
$ DO_NETWORK:
$	IF .NOT.NETWORK THEN GOTO DO_TELECOMMS
$!
$! NETWORK directories
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.NETWORK]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.FLOWLINE.NETWORK]
$!
$ DO_TELECOMMS:
$	IF .NOT.TELECOMMS THEN GOTO GENERATE_DATABASE
$!
$! TELECOMMS directories
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.BUILDING_CLUTTER]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.WATER_CLUTTER]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.VEG_CLUTTER]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TELECOMMS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TELECOMMS.PROFILES]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TELECOMMS.STRENGTH]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TELECOMMS.LOSS_MAP]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TELECOMMS.CONTOURS]
$	CALL CREDIR LSL$DATA_ROOT:['PRODUCT'.'CUSTOMER'.RESULTS.TELECOMMS.INTERFERENCE]
$!
$ GENERATE_DATABASE:
$	IF F$EXTRACT(0,F$LENGTH(DBMS),"RDB") .EQS. DBMS 
$	THEN
$	   TYPE SYS$INPUT

Normally LSL ship the standard RdB product database on LSL$PUBLIC_ROOT. This is
moved to the correct data directory at the customer site by the LSLINSTALL_GIS
procedure. If however, LSL have undertaken to modify the standard database for
this customer, (perhaps to add some target tables or start-up strata), it will
have to be created for modification at LSL before shipment. 

SUMMARY:
         If this is a "fake customer", for LSL use only, answer YES.

         If this is a real (external) customer, to whom LSL have promised to
         supply a customised database, answer YES.

         If this is a real (external) customer, to receive a standard template
         database, answer NO. 

$          READ/END=EXIT/PROMPT=-
           "Do you want the database created (YES/NO) [NO]? " -
           SYS$COMMAND CREATE_DB
$	   CREATE_DB = F$EDIT(CREATE_DB,"UPCASE,COLLAPSE")
$	   IF CREATE_DB .EQS. "Y" 
$	   THEN
$GET_WHERE:
$	      IF EXTERNAL_CUST
$	      THEN
$	        WS " "
$	        WS "Where do you want the database created"
$	        READ/END=EXIT/PROMPT= -
		"e.g. LSL$DATA_ROOT:[RWH.TEMP] ? " SYS$COMMAND WHERE_DB
$		IF WHERE_DB.EQS."" THEN WHERE_DB="HERE:"
$	        WHERE_DB = F$EDIT(WHERE_DB,"UPCASE,COLLAPSE")
$		ON ERROR THEN CONTINUE
$		CREATE 'WHERE_DB''CUSTOMER'_TRY.TMP
$	        IF .NOT. $STATUS
$		THEN
$		   WS " "
$		   WS "Unable to create database in ''WHERE_DB'  Try again."
$		   WS " "
$		   GOTO GET_WHERE
$		ENDIF
$		DELETE/NOLOG/NOCONFIRM 'WHERE_DB''CUSTOMER'_TRY.TMP;*
$		DATABASE_STRING="''WHERE_DB'''CUSTOMER';"
$	      ELSE
$		DATABASE_STRING="LSL$DATA_ROOT:[''PRODUCT'.''CUSTOMER'.RDB]''CUSTOMER'"
$	      ENDIF
$	      WS " "
$	      WS "Creating Rdb database ''DATABASE_STRING' from PUBLIC_ROOT pattern"
$	      COPY LSL$PUBLIC_ROOT:['PRODUCT'.DATABASE]'PRODUCT'.RDB -
					'DATABASE_STRING'.RDB
$	      COPY LSL$PUBLIC_ROOT:['PRODUCT'.DATABASE]'PRODUCT'.SNP -
					'DATABASE_STRING'.SNP
$	   ENDIF
$	ELSE
$	   WS " "
$	   WS "The ''DBMS' database cannot be created automatically"
$	   WS "Please consult the installation guide or ATG personnel"
$	ENDIF
$!
$ CREATE_LICENCE:
$	WS " "
$	WS "Creating  new licence file LSL$XGIS_SOURCE_ROOT:[$XGIS_''CUSTOMER'.LOOKUP]XGIS_OPTIONS.LIC"
$	WS " "
$!
$	DO_PURGE=""
$	IF F$SEARCH("LSL$XGIS_SOURCE_ROOT:[$XGIS_''CUSTOMER'.LOOKUP]XGIS_OPTIONS.LIC") -
		.NES."" THEN DO_PURGE="T"
$! Create and open a new licence file
$	OPEN/WRITE LIC LSL$XGIS_SOURCE_ROOT:[$XGIS_'CUSTOMER'.LOOKUP]XGIS_OPTIONS.LIC
$	WRITE LIC "''PRODUCT'"
$	IF PRODUCT_TYPE.NES."QUERY" THEN WRITE LIC "XGIS_UPDATE_APPLICATION"
$	IF LINKNODE     THEN WRITE LIC "XGIS_LINKNODE_APPLICATION"
$	IF POLYGONS     THEN WRITE LIC "XGIS_POLYGONS_APPLICATION"
$	IF LAND_CHARGES THEN WRITE LIC "XGIS_LAND_CHARGES_APPLICATION"
$	IF LAND_TERRIER THEN WRITE LIC "XGIS_LAND_TERRIER_APPLICATION"
$	IF NETWORK      THEN WRITE LIC "XGIS_NETWORK_APPLICATION"
$	IF ADV_GAZ      THEN WRITE LIC "XGIS_ADVANCED_GAZETTEER_APPLICATION"
$	IF COMPOSITE_TEXT      THEN WRITE LIC "XGIS_COMPOSITE_TEXT"
$	IF TERRAIN      THEN WRITE LIC "XGIS_TERRAIN_APPLICATION"
$	IF TELECOMMS    THEN WRITE LIC "XGIS_TELECOMMS_APPLICATION"
$	IF TERRAIN_VISUALISATION THEN WRITE LIC "XGIS_TERRAIN_VISUALISATION_APPLICATION"
$	CLOSE LIC
$	IF DO_PURGE THEN PURGE/NOLOG LSL$XGIS_SOURCE_ROOT:[$XGIS_'CUSTOMER'.LOOKUP]XGIS_OPTIONS.LIC
$	GOTO EXIT
$!
$!
$!=======================================================================
$!			S U B R O U T I N E
$PRESS_RETURN: 
$!=======================================================================
$!
$! subroutine to prompt user to press return
$!
$	   WS " "
$          READ/END=EXIT/PROMPT="Press RETURN to continue  " SYS$COMMAND YES
$	RETURN
$!
$!=======================================================================
$!			S U B R O U T I N E
$CREDIR: SUBROUTINE
$!=======================================================================
$!
$! subroutine to test for passed directory and if absent, create it
$!
$! Parameters:
$!	P1	= directory specification
$!
$	TEMP_DEV=F$PARSE(P1,,,"DEVICE","SYNTAX_ONLY")
$	TEMP_DIR=F$PARSE(P1,,,"DIRECTORY","SYNTAX_ONLY") 
$	IF F$LOCATE(".",TEMP_DIR).NE.F$LENGTH(TEMP_DIR)
$	THEN
$	  I=F$LENGTH(TEMP_DIR)
$L1:	   I=I-1
$	   IF F$EXTRACT(I,1,TEMP_DIR).EQS."."
$	   THEN
$	     DIR_NAME=F$EXTRACT(I+1,F$LENGTH(TEMP_DIR)-I,TEMP_DIR) - "]"
$	     TEMP_FILE="''TEMP_DEV'''F$EXTRACT(0,I,TEMP_DIR)']''DIR_NAME'.DIR;"
$	   ELSE
$	     GOTO L1
$	   ENDIF
$	ELSE
$	   TEMP_DIR=F$EXTRACT(1,F$LENGTH(TEMP_DIR)-2,TEMP_DIR)
$	   TEMP_FILE=TEMP_DEV+"[000000]"+TEMP_DIR+".DIR;"
$	ENDIF
$	IF F$SEARCH("''TEMP_FILE'").EQS."" THEN -
		CREATE/LOG/DIRECTORY 'P1'
$	RETURN
$ ENDSUBROUTINE

$EXIT:
$	EXIT
