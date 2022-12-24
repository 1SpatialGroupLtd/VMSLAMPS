C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 17:18:04.000000000 +0000
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
	SUBROUTINE USRSTO(FSN,FC,MAP,LAYER,TXTF,NOPTS,NAC,
     &	                  ROTAT,THICK,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	FSN		! feature serial number to use
					! (set to -1 for unknown)
	INTEGER*4	FC(4)		! feature status to use
					! (set FC(I) to -1 for unknown)
	INTEGER*4	MAP		! map to put feature in
					! (set to -1 for unknown)
	INTEGER*4	LAYER		! layer to use
					! (set to -1 for unknown)
	LOGICAL		TXTF		! .TRUE. if FC =-1 and want
					! to create a text feature
	INTEGER*4	NOPTS		! number of points in feature
	INTEGER*4	NAC		! number of ACs in feature
	REAL		ROTAT		! rotation if text or oriented
					! symbol (in radians)
	INTEGER*4	THICK		! size of text
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call USRRET
					! = 1 for ask for data
					! = 4 abort, call USRRET
C
C all the arguments in this subroutine are writable
C
C working storage
C
	INTEGER*4	I,J
	INTEGER*4	LEN
	REAL		TIME
	CHARACTER*80	STR
	REAL		LAST_COORD(2)
C
	INCLUDE		'USRKEEP.CMN'
	INCLUDE		'USRFEAT.CMN'
C
C
	NHPTS=0
	NHACS=0
C
C constructing several features?
	IF (USR_ACTION.EQ.10) THEN
C
C is random number generator initialised?
	   IF (RAN_SEED.EQ.0) THEN
	      RAN_SEED = SECNDS(0.0) * 100.0
	      IF (.NOT.RAN_SEED) RAN_SEED = RAN_SEED + 1 ! ensure odd
	   ENDIF
C
C contruct in map 1, layer 1, with FSN and FC from attribute set
	   IF (USR_MAP .EQ.0) USR_MAP = 1
	   IF (USR_LAYER.EQ.0) USR_LAYER = 1
	   USR_FSN  = -1
	   USR_NACS = 0
	   USR_FC(1) = -1		! linear features
	   USR_NCOORD = 0
C
	   LAST_COORD(1) = (UXWIN-LXWIN)*RAN(RAN_SEED) + LXWIN
	   LAST_COORD(2) = (UYWIN-LYWIN)*RAN(RAN_SEED) + LYWIN
	   LEN = MAX(2,INT(RAN(RAN_SEED)*(NUMPTS*1)))
	   PRINT *,'Number of points is',LEN
	   PRINT *,' '
	   DO 5, I=1,LEN
	      USR_NCOORD = USR_NCOORD + 1
    2	      COORD(1,USR_NCOORD) = LAST_COORD(1) +
     &	                              (20.0*RAN(RAN_SEED) - 10.0)
	      COORD(2,USR_NCOORD) = LAST_COORD(2) +
     &	                              (20.0*RAN(RAN_SEED) - 10.0)
	      IF (COORD(1,USR_NCOORD).GT.UXWIN.OR.
     &	          COORD(1,USR_NCOORD).LT.LXWIN.OR.
     &	          COORD(2,USR_NCOORD).GT.UYWIN.OR.
     &	          COORD(2,USR_NCOORD).LT.LYWIN) GOTO 2
	      FLG(USR_NCOORD) = 1
	      LAST_COORD(1) = COORD(1,USR_NCOORD)
	      LAST_COORD(2) = COORD(2,USR_NCOORD)
    5	   CONTINUE
	ENDIF
C
C set up data about feature to create
C
	FSN=USR_FSN				! feature number
	DO 10, I=1,4				! feature status
	   FC(I)=USR_FC(I)
   10	CONTINUE
	MAP=USR_MAP				! map
	LAYER=USR_LAYER				! layer
	TXTF=TEXTFEAT.AND.(FC(1).EQ.-1)		! default text FC
	NOPTS=USR_NCOORD			! number of points
	NAC=USR_NACS				! number of ACs
	ROTAT=USR_ROTAT				! rotation
	THICK=USR_THK				! text height
C	
	RETCOD=1
C
	RETURN
	END
