$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-03-09 15:37:36.000000000 +0000
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
$!MOD	 Bug fix - SAVENAME symbol incorrectly spelt as SAVENAM for
$!	 LP output 						TJH 09-Mar-1987
$!
$! Command procedure to print out the contents of the SECURE master 
$! archive directory
$!
$	OPEN/ERR=EX_IT/READ MA LSL$SECURE:MARCHIVE.DAT
$	ON CONTROL_Y THEN GOTO A2
$ A1:	READ/END=A2 MA LINE			! secure information
$       LABEL=F$EXTRACT(F$LOCATE("L",LINE),7,LINE) ! SECURE tape label
$       USRNAM=F$EXTRACT(8,13,LINE)		! username
$       QDATE=F$EXTRACT(22,11,LINE)		! date of archive
$       OPERATOR=F$EXTRACT(34,13,LINE)		! operator name
$	TMPLINE=F$EXTRACT(48,85,LINE)		! saveset name ...
$	SAVENAME=F$EXTRACT(0,F$LOCATE(" ",TMPLINE),TMPLINE)
$!
$! Extract parts of original file spec
$	LINE=F$EXTRACT(133,F$LENGTH(LINE),LINE) ! get file-spec field only
$	FDEVICE="UNKNOWN"			! allow for "" default
$	COLPOS=F$LOCATE(":",LINE)
$	IF COLPOS.NE.F$LENGTH(LINE) THEN -
		FDEVICE=F$EXTRACT(0,COLPOS+1,LINE)
$       FDIRECTORY=F$PARSE(LINE,,,"DIRECTORY")
$       FILENAME=F$PARSE(LINE,,,"NAME")
$       EXTNE=F$PARSE(LINE,,,"TYPE")
$       VERSION=F$PARSE(LINE,,,"VERSION")
$	COMPFIL:='FILENAME''EXTNE''VERSION'
$!
$! And write it all out
$	IF LP_OUT THEN GOTO LP_OUTPUT
$	WS " "
$	WS "User:               ''USRNAM'     Date of archive:    ''QDATE'"
$	FIELD="                                                                                 "
$	FIELD[0,38]:="Original device:    ''FDEVICE'"
$	FIELD[38,40]:="Tape label:         ''LABEL'"
$	WS FIELD
$	WS "Original directory: ''FDIRECTORY'"
$	WS "File:               ''COMPFIL'"
$	WS "Saveset name:       ''SAVENAME'"
$	WS "Archive operator:   ''OPERATOR'"
$	GOTO A1
$!
$! Line printer output
$ LP_OUTPUT:
$	WO " "
$	WO "User:               ''USRNAM'     Date of archive:    ''QDATE'"
$	FIELD[0,38]:="Original device:    ''FDEVICE'"
$	FIELD[38,40]:="Tape label:         ''LABEL'"
$	WO FIELD
$	WO "Original directory: ''FDIRECTORY'"
$	WO "File:               ''COMPFIL'"
$	WO "Saveset name:       ''SAVENAME'"
$	WO "Archive operator:   ''OPERATOR'"
$	GOTO A1
$ A2:	CLOSE MA
$	EXIT
$ EX_IT:
$	WS "%SECURE-W-ERROPNDIR, error opening Secure directory file"
