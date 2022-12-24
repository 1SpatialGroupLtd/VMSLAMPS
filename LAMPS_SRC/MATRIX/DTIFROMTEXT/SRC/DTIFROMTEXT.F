C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-09-20 17:43:34.000000000 +0100
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
	PROGRAM	DTIFROMTEXT
C
CDEC$	IDENT	'20SE93'
C
C       Copyright Laser-Scan Ltd., Cambridge, England.
C
C       Author	Clarke Brunt	Jiffy			21-May-1991
C	Mod	Jon Barber				13-Aug-1991
C		Standardised and extended to create REAL,
C		LONG, WORD or BYTE DTI files, and to read
C		Z or X,Y,Z values
C
C	Mod	Jon Barber				17-Sep-1993
C		Standardised and /CUSTOMER = MOBILE (JAPAN) or
C					     AUSLIG added
C
C Ability to process AUSLIG (x,y,z) or 	MOBILE (JAPAN) z or 
C other (z) data with the appropriate qualifiers
C
C Description
C	To convert text file to DTI
C	Z, SW, CLK by default via command line decoder
C
        IMPLICIT NONE
C
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
C
	INCLUDE 'LSL$CMNDTI:DTILIBMSG.PAR'
	INCLUDE 'HERE:DTIFROMTEXTMSG.PAR'
	INCLUDE 'HERE:DTIFROMTEXT.CMN'
C
C functions
	LOGICAL	RDCHS
	LOGICAL	RDLONG
	LOGICAL	RDREAL
	LOGICAL	RDDBLE
C
	INTEGER	TTRSTR
	INTEGER	FLROPN	
	INTEGER	FLRLIN
	INTEGER	PARFILN
	INTEGER	DTI_CREATE,DTI_CLOSE,DTI_MINMAX_DATA
C
	LOGICAL	CONVERT
	LOGICAL	CONVERT_MOBILE
	LOGICAL	CONVERTR
	INTEGER	OBEY
C
C workspace
	INTEGER		OK,IERR
	REAL*8		XORI,YORI
	INTEGER		XSIZE,YSIZE
	REAL		XGRID_SIZE,YGRID_SIZE
	BYTE		CH
C
	CALL LSL_INIT(.TRUE.)
	CALL DTI_INIT
C
C Decode command line
C
	OK = OBEY()
	IF (.NOT.OK) GOTO 10000
C
C open index file unless AUSLIG set: origin reset later from x,y data
C					at first line of data
C			 MOBILE(JAPAN)  set: set origin only from index file
C
	IF (HAD_AUSLIG) THEN
	   HAD_XYZ  = .TRUE.		! ensure x,y,z flag set
	   HAD_Z    = .FALSE.		! ensure z flag unset

	   HAD_SW   = .TRUE.

	   HAD_ACLK = .TRUE.		! ensure aclk flag set
	   HAD_CLK  = .FALSE.		! ensure clk flag unset
C
	   XSIZE = 101
	   YSIZE = 101
	   DTIPROJ_PROJECTION(1) = 100		! geog
	   DTIPROJ_UNITS(1) 	 = 4		! degrees
	   DTIPROJ_SAMPLE(1,1) 	 = 0.005	! 18"
	   DTIPROJ_SAMPLE(2,1)   = 0.005	! 18"
	   X_GRID(1) 		 = 0.005
	   Y_GRID(1) 		 = 0.005
C
	ELSEIF (HAD_MOBILE) THEN
	   HAD_Z   = .TRUE.		! ensure z flag set
	   HAD_XYZ = .FALSE.
C
	   HAD_NW  = .TRUE.		! ensure NW flag set
	   HAD_SW  = .FALSE.		! ensure SW flag unset
C
	   HAD_CLK  = .TRUE.
	   HAD_ACLK = .FALSE.
C
	   XSIZE = 320
	   YSIZE = 320
	   DTIPROJ_PROJECTION(1) = 100		   ! geog
	   DTIPROJ_UNITS(1) 	 = 4		   ! degrees
	   DTIPROJ_SAMPLE(1,1)   = 1.0/320.0	   ! 1 deg/320
	   DTIPROJ_SAMPLE(2,1)   = (2.0/3.0)/320.0 ! 40 min/320
	   X_GRID(1) 		 = 1.0/320.0
	   Y_GRID(1) 		 = (2.0/3.0)/320.0
	ENDIF
C
C Use index file to get any file origins, leaving mobile (JAPAN) or
C AUSLIG stuff set
C
	IF (HAD_INDEX) THEN
	   OK = FLROPN(INDLUN,INDFIL(1:INDLEN))
	   IF (.NOT.OK) THEN
	     CALL LSL_PUTMSG(DTIFT__INDEXOPNERR)
	     CALL LSL_ADDMSG(OK)
	     GOTO 10000
	   ENDIF
C
10	   OK = FLRLIN()
	   IF (.NOT.OK) THEN
	      CALL LSL_PUTMSG(DTIFT__INDEXFILERR)
	      CALL LSL_ADDMSG(OK)
	      GOTO 1000
	   ENDIF
C
	   CALL BSLN
	   OK = RDCHS(CH)
	   IF (OK) GOTO 10
C
C Check for comment
C
	   IF (CH.EQ.'!') GOTO 10
C
	   CALL BSLN
	   IF (RDDBLE(XORI))	GOTO 980
	   IF (RDDBLE(YORI)) 	GOTO 980
C
	   X_OFFSET(1) = XORI
	   Y_OFFSET(1) = YORI
	   DTIPROJ_ORIGIN(1,1) = XORI
	   DTIPROJ_ORIGIN(2,1) = YORI

	   IF (HAD_MOBILE .OR. HAD_AUSLIG) GOTO 45

	   IF (RDLONG(XSIZE)) 	   GOTO 980
	   IF (RDLONG(YSIZE)) 	   GOTO 980
	   IF (RDREAL(XGRID_SIZE)) GOTO 980
	   IF (RDREAL(YGRID_SIZE)) GOTO 980
C
	   IF (XSIZE.LE.0 .OR. YSIZE.LE.0 .OR. 
     &	    XGRID_SIZE.LE.0.0 .OR. YGRID_SIZE.LE.0.0) GOTO 980
C
	   X_GRID(1) = XGRID_SIZE
	   Y_GRID(1) = YGRID_SIZE
C
	   DTIPROJ_SAMPLE(1,1) = XGRID_SIZE
	   DTIPROJ_SAMPLE(2,1) = YGRID_SIZE
C
45	   CALL FLRCLO(INDLUN)
	ENDIF
C
	X_EXTENT(1) = XSIZE
	Y_EXTENT(1) = YSIZE
C
C Open text file
C
50	CONTINUE
C
	OK = FLROPN(TXTLUN,TXTFIL(:TXTLEN))
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(DTIFT__TEXTOPNERR)
	   CALL LSL_ADDMSG(OK)
	   GOTO 1000
	ENDIF
C
C Set the datatype
C
	DATA_TYPE(1) = DATA_WORD		! default
C
	IF (HAD_REAL) THEN
	   DATA_TYPE(1) = DATA_REAL
	ELSEIF (HAD_LONG) THEN
	   DATA_TYPE(1) = DATA_LONG
	ELSEIF (HAD_WORD) THEN
	   DATA_TYPE(1) = DATA_WORD
	ELSEIF (HAD_BYTE) THEN
	   DATA_TYPE(1) = DATA_BYTE
	ENDIF
C
C Set the corner, (clockwise assumed for the present)
C
	DTI_ORDER_CORNER(1) = DTI_ORDER_SW
C
	IF (HAD_SW) THEN
	   DTI_ORDER_CORNER(1) = DTI_ORDER_SW
	ELSEIF (HAD_NW) THEN
	   DTI_ORDER_CORNER(1) = DTI_ORDER_NW
	ELSEIF (HAD_NE) THEN
	   DTI_ORDER_CORNER(1) = DTI_ORDER_NE
	ELSEIF (HAD_SE) THEN
	   DTI_ORDER_CORNER(1) = DTI_ORDER_SE
	ENDIF
C
	DTI_ORDER_DIRECTION(1) = DTI_ORDER_CLOCKWISE
C
	IF (HAD_CLK) THEN
	   DTI_ORDER_DIRECTION(1) = DTI_ORDER_CLOCKWISE
	ELSEIF (HAD_ACLK) THEN
	   DTI_ORDER_DIRECTION(1) = DTI_ORDER_ANTICLOCKWISE
	ENDIF
C
	OK = CONVERTR(DATA_TYPE(1))
C
C create DTI file
C
	OK = DTI_CREATE(DTILUN,
     &		DTIFIL(:DTILEN),DTILEN,
     &		DTI_LSLA,
     &		DEFAULT_LSLA_HEADER+DTIPROJ_RECORD_LENGTH,
     &		DATA_TYPE(1),
     &		XSIZE,YSIZE,IERR)
C
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.DTI__SYSERR) CALL LSL_ADDMSG(IERR)
	   GOTO 1000
	ENDIF
C
	HAD_PROJ_RECORD(1) = .TRUE.
	DTIPROJ_RECORD_OFFSET(1) = DEFAULT_LSLA_HEADER
C
C and off we go
C
	IF (HAD_MOBILE) THEN
	  OK = CONVERT_MOBILE( %VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			%VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			%VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			%VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			XSIZE,YSIZE,DATA_TYPE(DTILUN) )
C
	ELSE
	  OK = CONVERT( %VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			%VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			%VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			%VAL(SEC_ADDR(1)+DATA_OFFSET(1)),
     &			XSIZE,YSIZE,DATA_TYPE(DTILUN) )
	ENDIF
C
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(DTIFT__TEXTFILERR)
	ENDIF
C
	CALL FLRCLO(TXTLUN)
C
	OK = DTI_MINMAX_DATA(DTILUN,.TRUE.,IERR)
C
	OK = DTI_CLOSE(DTILUN,.TRUE.,.FALSE.,IERR)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.DTI__SYSERR) CALL LSL_PUTMSG(IERR)
	ENDIF
C
	GOTO 1000
C
980	CALL LSL_PUTMSG(DTIFT__INDEXFILERR)
C
C Close index file
C
1000	IF (HAD_INDEX) CALL FLRCLO(INDLUN)
C
10000	CALL LSL_EXIT
	END
C
