C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-04-07 13:35:38.000000000 +0100
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
CDEC$	IDENT	'07AP93'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					A.P.Brown 13-Nov-1989
C
C	Add /LOG and /MULTIPLY 			J Barber   5-Apr-1993

C Description:
C
C	Read the CCG SIF AA file
C
	IMPLICIT	NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:AA2IFFMSG.PAR'		! AA2IFF messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'CMN:FILE.CMN'      		! 
	INCLUDE	'CMN:IFF.CMN'      		! 
C
C External functions
C
	EXTERNAL	AA2IFF_CLD		! Command language definition
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
	LOGICAL		DCL_INT			! Get an integer
C
	INTEGER		FLROPN			! Open AA file
	INTEGER		IFFCREATE		! Start IFF
	LOGICAL		RDPAR			! Read PAR file
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL		LOCAL
	LOGICAL		LOCNEG
C
C-------------------------------------------------------------------------------
C Initialise
C
	HAD_LOG  = .FALSE.
	HAD_MULT = .FALSE.
	HAD_PAR  = .FALSE.
	HAD_FRT  = .FALSE.
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'AA2IFF',.FALSE.,AA2IFF_CLD,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Get the AA input filename (P1) 
C
	STATUS = DCL_FILE( 'AA_FILESPEC','LSL$AA:AA.MAP',
     &					ABSENT,.FALSE.,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Store AA file length and name
C
	AALEN  = FIL_LEN(1)
	AAFILE = FILARY(1)(1:AALEN)
C
C Get the IFF output filename (P2)
C
	STATUS = DCL_FILE( 'IFF_FILESPEC','LSL$IF:IFF.IFF',
     &					ABSENT,.FALSE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name
C
	IFFLEN  = FIL_LEN(1)
	IFFFILE = FILARY(1)(1:IFFLEN)
C
C Get FRT file
C
	STATUS = DCL_QUAL('FRT', HAD_FRT, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_FRT) THEN
	   STATUS = DCL_FILE('FRT','LSL$FRT:AA.FRT',
     &					ABSENT,.FALSE.,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   FRTLEN  = FIL_LEN(1)
	   FRTFILE = FILARY(1)(1:FRTLEN)
	ENDIF
C
C Get PAR file
C
	STATUS = DCL_QUAL('PARAMETER_FILE', HAD_PAR, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_PAR) THEN
	   STATUS = DCL_FILE('PARAMETER_FILE','LSL$LOOKUP:AA.PAR',
     &					ABSENT,.FALSE.,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   PARLEN  = FIL_LEN(1)
	   PARFILE = FILARY(1)(1:PARLEN)
	ENDIF
C
C Get LOG
C
	STATUS = DCL_QUAL('LOG', HAD_LOG, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
C Get MULTIPLY
C
	SCALE_FACTOR = 1
C
	STATUS = DCL_QUAL('MULTIPLY', HAD_MULT, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_MULT) THEN
	   STATUS= DCL_INT ('MULTIPLY', .TRUE.)
           IF (.NOT.STATUS) GOTO 999
C
	   MULTIPLY = IARRAY(1)
	   SCALE_FACTOR = MULTIPLY
        ENDIF
C
C Open input AA file
C
	STATUS = FLROPN(AALUN,AAFILE(1:AALEN))
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(AA2I__UNAOPNAA,AAFILE(1:AALEN))
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C Open, read and close PAR file and FRT file (required for PAR file)
C
	IF (HAD_PAR) THEN
	   STATUS = RDPAR()
	   IF (.NOT.STATUS) GOTO 999
	ENDIF
C
C Open IFF file
C
	STATUS = IFFCREATE(IFFLUN,IFFFILE(1:IFFLEN))
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(AA2I__UNACREIFF,IFFFILE(1:IFFLEN))
	   CALL LSL_PUTMSG(STATUS)
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
