C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-25 16:40:48.000000000 +0100
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
	INTEGER FUNCTION OBEY
CDEC$	IDENT	'25AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C
C Description:
C
	IMPLICIT	NONE
C
C	INCLUDE	'CMN:MOBILEMSG.PAR'		! MOBILE messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'CMN:FILE.CMN'      		! 
C
C External functions
C
	EXTERNAL	MOBILE_CLD		! Command language definition
C
C Functions
C
	INTEGER		DCL_STARTUP		! Command line read and parse
	INTEGER		DCL_FILE		! Get file name
	INTEGER		DCL_QUAL		! Get a qualifier 
	INTEGER		DCL_REAL		! Get a REAL qualifier 
C
	INTEGER		FLROPN			! Open MOBILE file
	INTEGER		FLWOPN			! Open TEXT file
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL		LOCAL
	LOGICAL		LOCNEG
C
C-------------------------------------------------------------------------------
C
	HAD_TOL = .FALSE.
	HAD_MOR = .FALSE.
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'MOBILE',.FALSE.,MOBILE_CLD,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Get the Mobile input filename (P1) 
C
	STATUS = DCL_FILE( 'MOB_FILESPEC','MOB.TXT',
     &					ABSENT,.FALSE.,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Store Mobile file length and name
C
	MOBLEN  = FIL_LEN(1)
	MOBFILE = FILARY(1)(1:MOBLEN)
C
C Get the output filename (P2)
C
	STATUS = DCL_FILE( 'TXT_FILESPEC','TXT.TXT',
     &					ABSENT,.FALSE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name
C
	TXTLEN  = FIL_LEN(1)
	TXTFILE = FILARY(1)(1:TXTLEN)
C
C Get TOLERANCE qualifier
C
	STATUS = DCL_QUAL('TOLERANCE',HAD_TOL,LOCAL,LOCNEG,.TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_TOL) THEN
	   STATUS = DCL_REAL('TOLERANCE',.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
	   TOLERANCE = RARRAY(1)
	   IF (TOLERANCE.LE.0) THEN
	      CALL WRITEF (' Unusable tolerance')
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
C Get MORPHOLOGY qualifier
C
	STATUS = DCL_QUAL('MORPHOLOGY',HAD_MOR,LOCAL,LOCNEG,.TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
C Open input Mobile file
C
	STATUS = FLROPN(MOBLUN,MOBFILE(1:MOBLEN))
	IF (.NOT.STATUS) THEN
C	   CALL LSL_PUTMSG(MOBILE__UNAOPNMOB,MOBFILE(1:MOBLEN))
C	   CALL LSL_PUTMSG(STATUS)
	   CALL WRITEF ('Unable to open input file %S',
     &					MOBFILE(1:MOBLEN))
	   GOTO 999
	ENDIF
C
C Open TXT file
C
	STATUS = FLWOPN(TXTLUN,TXTFILE(1:TXTLEN))
	IF (.NOT.STATUS) THEN
C	   CALL LSL_PUTMSG(MOBILE__UNACRETXT,TXTFILE(1:TXTLEN))
C	   CALL LSL_PUTMSG(STATUS)
	   CALL WRITEF ('Unable to open output file %S',
     &					TXTFILE(1:TXTLEN))
	   GOTO 999
	ENDIF
C
C All done
C
999	OBEY = STATUS				! Return status to caller
C
	RETURN
	END
C
