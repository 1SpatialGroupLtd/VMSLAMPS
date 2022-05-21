C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-25 11:56:22.000000000 +0100
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
	LOGICAL FUNCTION CLSFIL
C
CDEC$	IDENT	'25OC89'
C
C	Copyright 			Laser-Scan Ltd., Cambridge, England.
C
C	Created						RWR	21-Nov-1985
C
C	Modified					APB	19-Oct-1989
C
C Description:
C
C 	Closes any open files
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNLSL:MTOVCM.CMN'
	INCLUDE 	'LSL$CMNLSL:CLD.CMN'
C
C Working storage
C
	INTEGER  	STATUS
	INTEGER		ERROR
C
C Functions
C
	LOGICAL		DTI_CLOSE
	LOGICAL		MTOEOF
	LOGICAL		FLWCLO
C
C-------------------------------------------------------------------------------
C
C Close input
C
	IF (INOP) THEN
	   STATUS=DTI_CLOSE( INLUN,.FALSE.,.FALSE.,ERROR )
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG( DTI2DEM__ERCLSDTI )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG(ERROR)
	      GOTO 999
	   ENDIF
	ENDIF
C
C Close output
C
	IF (OUTOP) THEN
	   IF (ISTAPE) THEN
C
C Write 2 EOF markers as an EOT mark
C
	      STATUS = MTOEOF()
	      STATUS = MTOEOF()
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( DTI2DEM__ERRMKEOT,DEVNAM(1:DEVNAML) )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	         GOTO 999
	      ENDIF
	   ELSE
	      STATUS = FLWCLO(OUTLUN,ERROR)
	      IF (.NOT.STATUS) THEN
	         CALL LSL_PUTMSG( DTI2DEM__ERCLSDEM,FILARY(1)(1:FIL_LEN(1)) )
	         IF ( STATUS.EQ.LSL__SYSERR ) CALL LSL_ADDMSG(ERROR)
	         GOTO 999
	      ENDIF
	   ENDIF
	ENDIF
C
999	CLSFIL = STATUS
C
	RETURN
	END
