C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-12-06 14:05:58.000000000 +0000
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
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example user routine
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
C working storage
C
	INTEGER*4	I			! loop counter
	REAL		X,Y
C
	INCLUDE 'USRFEAT.CMN/LIST'		! common blocks
	INCLUDE 'USRKEEP.CMN/LIST'
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
	TEXTFEAT	= (USR_GOTFO.AND.(USR_GT.EQ.TEXTYP))
	USR_ROTAT	= ROTAT
	USR_THK		= THICK
C
C do some things for various actions
C
	GOTO (100,200,300,400,500,600,700,700,900,1000,1100,1200),USR_ACTION
C
C there is no such action
C
	PRINT 20,USR_ACTION
   20	FORMAT(' Action',I5,' is undefined'/
     &	      ' USER 1 gives information about this user routine'//)
C
C abort in this case
C
	RETCOD=0
	GOTO 10000
C
C write out some information
C
  100	CONTINUE
	PRINT 110
  110	FORMAT(' This is an example of the user routine. It contains'/
     &	   ' examples of some of its features.'//
     &	   ' USER  1 prints out this message'/
     &	   ' USER  2 prints out information about the current feature'/
     &	   ' USER  3 prints out the string on the end of USER command'/
     &	   ' USER  4 prints out the current cursor position'/
     &	   ' USER  5 prints out the current state'/
     &	   ' USER  6 prints out the value of the condition flag and'/
     &	   '         allows you to change it'/
     &	   ' USER  7 allows you to change the position of the ',
     &	    'current feature'/
     &	   ' USER  8 allows you to change the ACs of the current',
     &	    ' feature'/
     &	   ' USER  9 allows you to enter a command to LITES2'/
     &	   ' USER 10 constructs several different features'/
     &     ' USER 11 allows LITES2 variables to be set by the',
     &	   ' user routine, then as USER 9'/
     &	   ' USER 12 writes out data about current feature to a file'/
     &	   '         specified by string on end of command'//)
C
C and don't do anything else
C
	RETCOD=0
	GOTO 10000
C
C list found feature
C
  200	CONTINUE
	IF (GOTFO) THEN
C
C 	write header
C
	   PRINT 210,USR_FSN,USR_LAYER,USR_MAP,USR_GT,(USR_FC(I),I=1,4)
  210	   FORMAT(' Feature number ',I5,2X,'Layer ',I4,2X,'Map ',I4,2X,
     &	            'Graphical type ',I4//' Feature status ',4(I5,2X))
C
C 	initialise counters
C
	   NHACS  = 0
	   NHPTS  = 0
	   NHTXTS = 0
C
C	   now get ACs and Coords
C
	   IF (USR_NACS.GT.0) THEN		! there are some ACs
	      PRINT 220,USR_NACS
  220	      FORMAT(/' There are',I3,' ACs. They are:-'//
     &	            ' AC type     AC value   Text'/)
	      RETCOD=1
	   ELSE					! there are no ACs
	      RETCOD=2
	   ENDIF
	ELSE
C
C there is no found object
C
	   PRINT 240
  240	   FORMAT(' There is no found object'/)
	   RETCOD=0
	ENDIF
	GOTO 10000
C
C do something with string on end of command line
C
  300	CONTINUE
	IF (USR_STRL.GT.0) THEN
	   PRINT 320,USR_STRL,USR_STR(1:USR_STRL)
  320	   FORMAT(' String on end of command line (length',I4,') is:-'/
     &	            ' "',A,'"'/)
	ELSE
	   PRINT 330
  330	   FORMAT(' There was no string on the command line'/)
	ENDIF
C
	RETCOD=0			! and don't do anything else
	GOTO 10000
C
C show current cursor position
C
  400	CONTINUE
	PRINT 410,USR_CURSOR(1),USR_CURSOR(2)
  410	FORMAT(' Cursor position:-',2F15.3/)
	RETCOD=0			! and don't do anything else
	GOTO 10000
C
C print out the current state
C
  500	CONTINUE
	PRINT 510,USR_STATE(1:USR_STATEL)
  510	FORMAT(' Current state is ',A/)
	RETCOD=0			! and don't do anything else
	GOTO 10000
C
C do something about condition flag
C
  600	CONTINUE
	PRINT 610,USR_CNDFLG
  610	FORMAT(' Condition flag is set to ',L/)
C
C now call USRDO
C
	RETCOD=4
	GOTO 10000
C
C change feature, USER 7 (position) and USER 8 (ACs)
C so need to store it first
C
  700	CONTINUE
	IF (.NOT.USR_GOTFO) THEN
	   PRINT 710
  710	   FORMAT(' No feature to alter'/)
	   RETCOD=0			! and don't do anything else
	ELSE
C
C check that the feature is not too big
C
	   IF (USR_NACS.GT.NUMACS.OR.USR_NCOORD.GT.NUMPTS) THEN
	      PRINT 720,NUMACS,NUMPTS,USR_FSN,USR_NACS,USR_NCOORD
  720	      FORMAT(' User routine can only store features with less ',
     &	             'than',I4,' ACs'/' and less than',I5,' points.'/
     &	             ' FSN',I6,' has',I4,' ACs and',I5,' points'/)
	      RETCOD=0			! don't do anything else

	   ELSEIF((USR_GT.EQ.TEXTYP).AND.USR_NCOORD.GT.NUMTXTS) THEN
	      PRINT 730,NUMTXTS,USR_FSN,USR_NCOORD
  730	      FORMAT(' User routine can only store features with less ',
     &	             'than',I4,' Text components.'/
     &	             ' FSN',I6,' has',I4,' text components.'/)
	      RETCOD=0			! don't do anything else
	   ELSE
C
C	   get coordinates and ACs (if altering position)
C
	      NHACS=0				! initialise counters
	      NHPTS=0
	      FEATNATT = 0
	      NHTXTS = 0
	      IF (USR_NACS.EQ.0.OR.ACTION.EQ.8) THEN
	         RETCOD=2			! get coordinates
	      ELSE
	         RETCOD=1			! get ACs
	      ENDIF
	   ENDIF
	ENDIF
	GOTO 10000
C
C send a command to LITES2
C
  900	CONTINUE
	RETCOD=4		! get into USRDO
	GOTO 10000
C
C construct several features
 1000	CONTINUE 
C
C not valid in INITIAL state
	IF (STATE.EQ.'INITIAL') THEN
	   PRINT 1040
 1040	   FORMAT(' Cannot construct features in INITIAL state'/)
	   RETCOD=0
	ELSE
	   FIRST_DO = .TRUE.
	   RETCOD=4		! get into USRDO
	ENDIF
	GOTO 10000
C
C set LITES2 variables
C
 1100	CONTINUE
	RETCOD=4		! get into USRDO
	GOTO 10000
C
C list found feature
C
 1200	CONTINUE
	IF (GOTFO) THEN
	   IF (USR_STRL.GT.0) THEN
	      OPEN(UNIT=6,FILE=STR(1:STRL),ERR=1220,STATUS = 'NEW')
	   ELSE
	      PRINT 330
	   ENDIF
C
C 	write header
C
	   WRITE(6,210,ERR=1220)
     &		 USR_FSN,USR_LAYER,USR_MAP,USR_GT,(USR_FC(I),I=1,4)
C
C 	initialise counters
C
	   NHACS  = 0
	   NHPTS  = 0
	   NHTXTS = 0
C
C	   now get ACs and Coords
C
	   IF (USR_NACS.GT.0) THEN		! there are some ACs
	      PRINT 220,USR_NACS
	      RETCOD=1
	   ELSE					! there are no ACs
	      RETCOD=2
	   ENDIF
	ELSE
C
C there is no found object
C
	   PRINT 240
	   RETCOD=0
	ENDIF
	GOTO 10000
C
C error opening/writing to file
 1220	CONTINUE
	PRINT 1224
 1224	FORMAT(' Error opening or writing to file'/)
	RETCOD = 0
	GOTO 10000
C
10000   CONTINUE
	RETURN
	END
