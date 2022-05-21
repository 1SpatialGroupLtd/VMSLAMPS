C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-24 17:38:38.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	PROGRAM I2GEN
C
CDEC$	IDENT	'22AP91'
C
C       Created as a Bureau jiffy	ST  22-Apr-1991
C
C    Copyright Laser-Scan Laboratories Ltd., Cambridge, England
C
	IMPLICIT NONE
C
C Functions
C
	LOGICAL		CMDLIN
	LOGICAL		GET_FILES
	LOGICAL		RD_PAR
	LOGICAL		PROCESS
C
	LOGICAL		FLWCLO
C
C Parameters
C
	INCLUDE 'PARAMS.PAR'
C
C Common
C
	INCLUDE 'COMMAND.CMN'
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C ......................................................................
C
C Initialise LSLLIB
C
	CALL LSL_INIT
C
C Get and decode command line
C
	LSL_STATUS=CMDLIN()
	IF (.NOT.LSL_STATUS) GOTO 999
C	
C Open IFF input file and GEN output file
C
	LSL_STATUS=GET_FILES()
	IF (.NOT.LSL_STATUS) GOTO 999
C
C Open and decode any parameter file
C
	LSL_STATUS=RD_PAR()
	IF (.NOT.LSL_STATUS) GOTO 800
C
C Do the actual formatting work.
C
	LSL_STATUS=PROCESS()
	IF (.NOT.LSL_STATUS) GOTO 800
C
C Close down files
C
800	CALL IFFCLO(IFFLUN)
	CALL FLWCLO(GENLUN)
	CALL FLWCLO(TXTLUN)
	CALL WRITEF('Files closed.')
C
C Force LSL_STATUS to SS$_NORMAL if all is well
C
	IF (LSL_STATUS) LSL_STATUS=%LOC(SS$_NORMAL)
C
C And exit setting $STATUS as we go
C
999	CALL LSL_EXIT
	END
