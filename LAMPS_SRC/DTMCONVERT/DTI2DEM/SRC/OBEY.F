C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-26 10:37:06.000000000 +0100
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
	LOGICAL FUNCTION OBEY
C
CDEC$	IDENT	'26OC89'
C
C 	Copyright 			Laser-Scan Ltd., Cambridge, England.
C
C 	Created						RWR	27-Jan-1989
C
C 	Modified					APB	17-Oct-1989
C
C		Updated into DTMCONVERT to use LSLLIB, DTILIB 
C		and standard message
C Description:
C
C 	Gets and decodes the command line for DTI2DEM
C
C Command syntax:
C
C 	DTI2DEM[/PLAN=value][/HEIGHT=value][/REWIND][BLOCK=int] 
C			 dtifile [demfile]
C
C 	where value is either FEET,METRES or  METERS
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 	'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE		'LSL$CMNDTI:DTILIBMSG.PAR'
	INCLUDE		'LSL$CMNDTI:DTIPAR.PAR'
C
C Common blocks
C
	INCLUDE 	'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE 	'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE 	'LSL$CMNLSL:CLD.CMN'	   ! LSLLIB command processing
	INCLUDE 	'LSL$CMNLSL:FILENAME.CMN'  ! Ditto
	INCLUDE		'LSL$CMNDTI:DTIHDR.CMN'	   ! DTI header 
	INCLUDE		'LSL$CMNDTI:DTIPROJ.CMN'   ! DTI projection record
C
C Functions
C
	LOGICAL		DCL_STARTUP
	LOGICAL		DCL_QUAL
	LOGICAL		DCL_FILE
	LOGICAL		DCL_STR
	LOGICAL		DCL_INT
	LOGICAL		DTI_OPEN
	LOGICAL		OPENOUT
	LOGICAL		DTI_PRINT_HEADER	! Print DTI header record
	LOGICAL		DTI_PRINT_PROJECTION	! Print DTI projection record
C
C Local variables
C
	LOGICAL		WHINGE			! internal error reporting
	LOGICAL		DUMMY1			! returned values that 
	LOGICAL		DUMMY2			!  we are not interested in
	INTEGER		DUMMYI			!
	LOGICAL		HADIT			! was there anything there?
	LOGICAL		ABSENT			! was it not there?
	CHARACTER*20	DEFIN			! default input file name
	INTEGER 	DEFLIN			! length of default file name
	INTEGER		STATUS		
C
	EXTERNAL	DTI2DEM_CLD
C
	DATA DEFIN /'LSL$DTI:.DTI;'/
	DATA DEFLIN/13/
C
	DATA WHINGE/.TRUE./	! internal error reporting?
C
C-------------------------------------------------------------------------------
C
C Get command line
C
	OBEY=DCL_STARTUP('DTI2DEM',	! command verb
     &	               .FALSE.,		! don't split parameter lists
     &	               DTI2DEM_CLD,	! CLD module name
     &	               WHINGE)		! allow routine error reporting
C
	IF (.NOT.OBEY) THEN
	   CALL LSL_PUTMSG( OBEY )
	   GOTO 999
	ENDIF
C
C Check for qualifiers
C
C /block
C
	OBEY=DCL_QUAL('BLOCK',
     &	            HADIT,
     &	            DUMMY1,
     &	            DUMMY2,
     &	            WHINGE)
C
	IF (.NOT.OBEY) THEN
	   GOTO 999
	ELSEIF (HADIT) THEN			! get value for BLKSIZ
	   OBEY=DCL_INT('BLOCK',WHINGE)
	   IF (.NOT.OBEY) THEN
	      GOTO 999
	   ELSE
	      IF ((IARRAY(1).GE.RECSIZ.AND.IARRAY(1).LE.MAXBLK).AND.
     &	               MOD(IARRAY(1),RECSIZ).EQ.0) THEN
	         BLKSIZ=IARRAY(1)
	      ELSE
	         CALL LSL_PUTMSG(DTI2DEM__BADBLKSIZ,BLKSIZ)
	      ENDIF
	   ENDIF
	ENDIF
C
C /plan
C
	OBEY=DCL_QUAL('PLAN',
     &	            HADIT,
     &	            DUMMY1,
     &	            DUMMY2,
     &	            WHINGE)
C
	IF (.NOT.OBEY) THEN
	   GOTO 999
	ELSE				! get value for plan
	   OBEY=DCL_STR('PLAN',WHINGE)
	   IF (.NOT.OBEY) THEN
	      GOTO 999
	   ELSE
	      PLNMET=CARRAY(1)(1:STR_LEN(1)).NE.'FEET'
	   ENDIF
	ENDIF
C
C /height
C
	OBEY=DCL_QUAL('HEIGHT',
     &	            HADIT,
     &	            DUMMY1,
     &	            DUMMY2,
     &	            WHINGE)
C
	IF (.NOT.OBEY) THEN
	   GOTO 999
	ELSE				! get value for height
	   OBEY=DCL_STR('HEIGHT',WHINGE)
	   IF (.NOT.OBEY) THEN
	      GOTO 999
	   ELSE				! override BLKDATed value
	      IF (CARRAY(1)(1:STR_LEN(1)).EQ.'FEET') DEMZUN = 1
	   ENDIF
	ENDIF
C
C /rewind
C
	OBEY=DCL_QUAL('REWIND',
     &	            REWIND,		! set flag in GENERAL
     &	            DUMMY1,
     &	            DUMMY2,
     &	            WHINGE)
C
	IF (.NOT.OBEY) GOTO 999
C
C Get input file
C
	OBEY=DCL_FILE('IN_FILESPEC',
     &	            DEFIN(1:DEFLIN),
     &	            DUMMY1,		! can't be absent
     &	            .FALSE.,		! will not accept a list
     &	            WHINGE)
C
	IF (.NOT.OBEY) GOTO 999
C
C Try to open this DTI file on unit INLUN
C
	OBEY = DTI_OPEN( INLUN,FILARY(1)(1:FIL_LEN(1)),FIL_LEN(1),
     &			.FALSE.,WHINGE )
	IF (.NOT.OBEY) THEN
	   CALL LSL_PUTMSG(DTI2DEM__ERROPNDTI,FILARY(1)(1:FIL_LEN(1)))	
	   IF ( OBEY .EQ. DTI__SYSERR ) CALL LSL_ADDMSG( WHINGE )
	   GOTO 999
	ELSE
	   INOP=.TRUE.
	ENDIF
C
C Report on the header for the DTI file
C
	CALL LSL_PUTMSG( DTI2DEM__DTIHDRTYP,
     &                   HEADER_NAMES(HEADER_TYPE(INLUN)) )
	STATUS = DTI_PRINT_HEADER( INLUN,UNITS_MET  )
C
C Report if a projection record was found
C
	IF ( HEADER_TYPE(INLUN).EQ.5 .AND. HAD_PROJ_RECORD(INLUN) ) THEN
	   CALL LSL_ADDMSG( DTI2DEM__PRJREC )
	   STATUS = DTI_PRINT_PROJECTION( INLUN )
	ENDIF
C
C Use this name for the name of the DEM in common DEMA
C (using the parsed name from LSL$CMNLSL:FILENAME, put there by DCL_FILE)
C
	IF (HAD_NAM) THEN
	   DEMNAM=STR_NAM(1:LEN_NAM)
	   DEMNAML=LEN_NAM
	   INFILN=STR_NAM(1:LEN_NAM)
	   INFILNL=LEN_NAM
	ENDIF
C
C Now get output spec
C
	OBEY=DCL_FILE('OUT_FILESPEC',
     &	            'SYS$DISK:'//DEMNAM(1:DEMNAML)//'.DEM',
     &	            DUMMY1,		! required by CLD
     &	            .FALSE.,		! only one, not a list
     &	            WHINGE)
C
	IF (.NOT.OBEY) GOTO 999
C
C and try to open it
C
	OBEY=OPENOUT(FILARY(1)(1:FIL_LEN(1)))
	IF (.NOT.OBEY) GOTO 999
C	   
999	CONTINUE
	RETURN
	END
