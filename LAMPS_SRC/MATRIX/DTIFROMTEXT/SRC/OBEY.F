C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-09-20 18:29:26.000000000 +0100
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
C
CDEC$	IDENT	'20SE93'
C
C	Copyright (C)	Laser-Scan Ltd., Cambridge
C	Created		Jon Barber		13-Aug-1991
C
CMOD	Standardised and /CUSTOMER=AUSLIG or MOBILE (JAPAN) added
C			Jon Barber		17-Sep-1993
C
C Description:
C	Decode command line for DTIFROMTEXT
C
	IMPLICIT	NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:DTIFROMTEXTMSG.PAR'	! DTIFROMTEXT messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'CMN:DTIFROMTEXT.CMN' 
C
C External functions
C
	EXTERNAL	DTIFROMTEXT_CLD		! Command language definition
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
C
	INTEGER		FLROPN			! Open text file
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
	HAD_Z     = .FALSE.
	HAD_XYZ   = .FALSE.
	HAD_REAL  = .FALSE.
	HAD_WORD  = .FALSE.
	HAD_BYTE  = .FALSE.
	HAD_LONG  = .FALSE.
	HAD_SW    = .FALSE.
	HAD_NW    = .FALSE.
	HAD_NE    = .FALSE.
	HAD_SE    = .FALSE.
	HAD_INDEX = .FALSE.
	HAD_CUST  = .FALSE.
	HAD_MOBILE = .FALSE.
	HAD_AUSLIG = .FALSE.
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'DTIFROMTEXT',.FALSE.,DTIFROMTEXT_CLD,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Get the input text name (P1) 
C
	STATUS = DCL_FILE( 'TEXT_FILE','TEXT.TXT',
     &					ABSENT,.FALSE.,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Store file length and name
C
	TXTLEN = FIL_LEN(1)
	TXTFIL = FILARY(1)(1:TXTLEN)
C
C Get the IFF output filename (P2)
C
	STATUS = DCL_FILE( 'DTI_FILE','LSL$DTI:DTI.DTI',
     &					ABSENT,.FALSE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name
C
	DTILEN = FIL_LEN(1)
	DTIFIL = FILARY(1)(1:DTILEN)
C
C /INDEX
C
	STATUS = DCL_QUAL('INDEX',HAD_INDEX,LOCAL,LOCNEG,.TRUE.)
	IF (.NOT.STATUS) THEN
	   STATUS = DTIFT__NOINDEXFILE
	   CALL LSL_PUTMSG(DTIFT__NOINDEXFILE)
	   GOTO 999
	ENDIF
C
	IF (HAD_INDEX) THEN
	   STATUS = DCL_FILE( 'INDEX','TEXT.INDEX',
     &					ABSENT,.FALSE.,.TRUE. )
	   IF (.NOT.STATUS) GOTO 999
C
C Store file length and name
C
	   INDLEN = FIL_LEN(1)
	   INDFIL = FILARY(1)(1:INDLEN)
	ENDIF
C
C /CUSTOMER
C
	STATUS = DCL_QUAL('CUSTOMER',HAD_CUST,LOCAL,LOCNEG,.TRUE.)
C
	IF (HAD_CUST) THEN
	   STATUS = DCL_QUAL('CUSTOMER.MOBILE',HAD_MOBILE,
     &					LOCAL,LOCNEG,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   STATUS = DCL_QUAL('CUSTOMER.AUSLIG',HAD_AUSLIG,
     &					LOCAL,LOCNEG,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
	ENDIF
C
C /Z
C
	STATUS = DCL_QUAL('Z',HAD_Z,LOCAL,LOCNEG,.TRUE.)
C
C /XYZ
C
	STATUS = DCL_QUAL('XYZ',HAD_XYZ,LOCAL,LOCNEG,.TRUE.)
C
C /REAL
C
	STATUS = DCL_QUAL('REAL',HAD_REAL,LOCAL,LOCNEG,.TRUE.)
C
C /LONG
C
	STATUS = DCL_QUAL('LONG',HAD_LONG,LOCAL,LOCNEG,.TRUE.)
C
C /WORD
C
	STATUS = DCL_QUAL('WORD',HAD_WORD,LOCAL,LOCNEG,.TRUE.)
C
C /BYTE
C
	STATUS = DCL_QUAL('BYTE',HAD_BYTE,LOCAL,LOCNEG,.TRUE.)
C
C /SW
C
	STATUS = DCL_QUAL('SW',HAD_SW,LOCAL,LOCNEG,.TRUE.)
C
C /NW
C
	STATUS = DCL_QUAL('NW',HAD_NW,LOCAL,LOCNEG,.TRUE.)
C
C /NE
C
	STATUS = DCL_QUAL('NE',HAD_NE,LOCAL,LOCNEG,.TRUE.)
C
C /SE
C
	STATUS = DCL_QUAL('SE',HAD_SE,LOCAL,LOCNEG,.TRUE.)
C
C /CLOCKWISE
C
	STATUS = DCL_QUAL('CLOCKWISE',HAD_CLK,LOCAL,LOCNEG,.TRUE.)
C
C /ANTICLOCKWISE
C
	STATUS = DCL_QUAL('ANTICLOCKWISE',HAD_ACLK,LOCAL,LOCNEG,.TRUE.)
C
	IF (.NOT.HAD_INDEX .AND.  .NOT.(HAD_MOBILE .OR. 
     &					HAD_AUSLIG) ) THEN
	   STATUS = DTIFT__NOINDEXFILE
	   CALL LSL_PUTMSG(DTIFT__NOINDEXFILE)
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
