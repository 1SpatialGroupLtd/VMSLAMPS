C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-06-13 17:49:26.000000000 +0100
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
	SUBROUTINE USRINI(ACTION,STRL,STR,CURSOR,CNDFLG,STATE,
     &	                  GOTFO,NCOORD,NACS,FSN,FC,MAP,LAYER,GT,
     &	                  ROTAT,THICK,RETCOD)
C
CDEC$	IDENT	'13JN91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Volume calculation routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	ACTION		! action to carry out
	INTEGER*4	STRL		! number of characters in STR
	CHARACTER*(*)	STR		! string passed to USER command
	REAL		CURSOR(2)	! coordinates of cursor
	LOGICAL		CNDFLG		! condition flag.
	CHARACTER*(*)	STATE		! current state
	LOGICAL		GOTFO		! TRUE if there is a found
					! object, FALSE otherwise, when
					! the next 4 arguments are 
					! undefined
	INTEGER*4	NCOORD		! number of coords
	INTEGER*4	NACS		! number of ACS
	INTEGER*4	FSN		! number of feature
	INTEGER*4	FC(4)		! feature status 
	INTEGER*4	MAP		! map
	INTEGER*4	LAYER		! layer
	INTEGER*4	GT		! graphical type
	REAL		ROTAT		! rotation if text or oriented
					! symbol (in radians)
	INTEGER*4	THICK		! size of text
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call processing
					!     routine
					! = 1 for get coords and ACs
					! = 2 for get coords without ACs
					! = 3 for get ACs without coords
					! = 4 for call processing routine
					!     without
					!     coords or ACs
					! = 5 for call completion routine
					!     without coords or ACs
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C Definition of all graphical types as parameters
C
	PARAMETER LINTYP = 1		! line string
	PARAMETER CLOTYP = 2		! clockwise circle arc
	PARAMETER ANTTYP = 3		! anti-clockwise circle arc
	PARAMETER CIRTYP = 4		! circum-circle arc
	PARAMETER FULTYP = 5		! full circumcircle
	PARAMETER CURTYP = 6		! interpolated curve
	PARAMETER UNOTYP = 7		! unoriented symbol
	PARAMETER ORITYP = 8		! oriented symbol
	PARAMETER SCATYP = 9		! scaled symbol
	PARAMETER TEXTYP = 10		! text
	PARAMETER STRTYP = 11		! symbol string
	PARAMETER ARETYP = 12		! fill area
C
	INCLUDE 'USRFEAT.CMN/LIST'		! common blocks
	INCLUDE 'USRKEEP.CMN/LIST'
C
C functions
C
	LOGICAL	RDREAL,RDLONG
C
C workspace
	INTEGER		I
C
C save arguments for later use
C
	USR_ACTION	= ACTION
	USR_STR		= STR
	USR_STRL	= STRL
	USR_CURSOR(1)	= CURSOR(1)
	USR_CURSOR(2)	= CURSOR(2)
	USR_CNDFLG	= CNDFLG
	USR_STATE	= STATE
	USR_STATEL	= LEN(STATE)
	USR_GOTFO	= GOTFO
	USR_NCOORD	= NCOORD
	USR_NACS	= NACS
	USR_FSN		= FSN
	DO 5, I=1,4
	   USR_FC(I)	= FC(I)
    5	CONTINUE
	USR_MAP		= MAP
	USR_LAYER	= LAYER
	USR_GT		= GT
	USR_ROTAT	= ROTAT
	USR_THK		= THICK
C
	ERROR = .FALSE.
	VARNUM = 0
C
C do some things for various actions
C
	GOTO (100,200,300,400,500,600),USR_ACTION
C
C there is no such action
C
	CALL WRITEF('Action %N is not defined',USR_ACTION)
	CALL TTWSTR('Action 1 gives information about this user routine')
C
C abort in this case
C
	RETCOD = 0
	GOTO 10000
C
C write out some information
C
100	CALL TTWSTR('This user routine performs volume calculations')
	CALL TTWSTR('Action 1 prints out this message')
	CALL TTWSTR('Action 2 sets bounding polygon')
	CALL TTWSTR('Action 3 begins a profile')
	CALL TTWSTR('Action 4 sets a profile')
	CALL TTWSTR('Action 5 calculates volume')
	CALL TTWSTR('Action 6 determines nearest profile to cursor')
C
C and don't do anything else
C
	RETCOD = 0
	GOTO 10000
C
C set up parameters for the calculation from the passed string
C and accept found feature as bounding polygon
C
200	IF (.NOT.GOTFO) THEN
	   CALL TTWSTR('There is no found feature')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (USR_GT.NE.LINTYP.AND.USR_GT.NE.CURTYP.AND.USR_GT.NE.ARETYP) THEN
	   CALL TTWSTR('Bounding polygon must be a line, curve, or area')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (USR_NCOORD.LT.3) THEN
	   CALL TTWSTR('Bounding polygon must have at least 3 points')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (USR_NCOORD.GE.MAXPTS) THEN
	   CALL WRITEF(
     &		'Bounding polygon must not have more than %N points',
     &			MAXPTS-1)
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
C decode string on end of command line
C
	IF (USR_STRL.LE.0) THEN
	   CALL TTWSTR('Parameters to user routine missing')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	CALL SETAUX(%REF(USR_STR),USR_STRL)
C
	IF (RDLONG(NPROF)) THEN
	   CALL TTWSTR('Error reading number of profiles')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (RDREAL(PROFANG)) THEN
	   CALL TTWSTR('Error reading angle of profiles')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
	PROFANG = PROFANG*3.14159265/180.0
C
	IF (RDREAL(PROFSPC)) THEN
	   CALL TTWSTR('Error reading profile spacing')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (RDLONG(DOSPC)) THEN
	   CALL TTWSTR('Error reading profile spacing logical')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
C Check things
	IF (DOSPC) THEN
	   IF (PROFSPC.LE.0.0) THEN
	      CALL TTWSTR('Profile spacing must be greater than 0.0')
	      ERROR = .TRUE.
	      RETCOD = 5		! go to USRRET
	      GOTO 10000
	   ENDIF
	ELSE
	   IF (NPROF.LE.0.OR.NPROF.GT.MAXPROF.OR.MOD(NPROF,2).EQ.0) THEN
	      CALL WRITEF(
     &	'Number of profiles must be an odd number between 1 and %N',
     &			MAXPROF)
	      ERROR = .TRUE.
	      RETCOD = 5		! go to USRRET
	      GOTO 10000
	   ENDIF
	ENDIF
C
	PROFNO = 0		! no profile number set yet
	NPTS  = 0
	RETCOD = 2		! get coordinates
	GOTO 10000
C
C prepare for a profile (expects profile number in string)
C
300	CONTINUE
C
C decode string on end of command line
C
	IF (USR_STRL.LE.0) THEN
	   CALL TTWSTR('Profile number missing')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	CALL SETAUX(%REF(USR_STR),USR_STRL)
C
	IF (RDLONG(PROFNO)) THEN
	   CALL TTWSTR('Error reading profile number')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (PROFNO.LE.0.OR.PROFNO.GT.NPROF) THEN
	   CALL TTWSTR('Profile number out of range')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	RETCOD = 4		! go to USRDO
	GOTO 10000
C
C accept a profile as found feature
C
400	IF (.NOT.GOTFO) THEN
	   CALL TTWSTR('There is no found feature')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (USR_GT.NE.LINTYP) THEN
	   CALL TTWSTR('Profile must be a linear feature')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (USR_NCOORD.GE.MAXPTS) THEN
	   CALL WRITEF(
     &		'Profile must not have more than %N points',
     &			MAXPTS-1)
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	IF (PROFNO.LE.0) THEN
	   CALL TTWSTR('Profile number not set')
	   ERROR = .TRUE.
	   RETCOD = 5		! go to USRRET
	   GOTO 10000
	ENDIF
C
	NPTS = 0
	RETCOD = 2		! get coordinates
	GOTO 10000
C
C return calculated volume
C
500	RETCOD = 4		! go to USRDO
	GOTO 10000
C
C return nearest profile
C
600	RETCOD = 4		! go to USRDO
	GOTO 10000
C
10000   CONTINUE
	RETURN
	END
