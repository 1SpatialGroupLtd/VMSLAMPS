C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-08-09 08:57:40.000000000 +0100
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
	LOGICAL FUNCTION JNCTEX( RPOSX, RPOSY, NARMS)
C
C
CDEC$	IDENT	'31OC89'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C	Created.					FJB  22-Sept-1989
CMOD	look at all arms to determine which category	PGH   9-Aug-1991
C
C Extract nodes at each junction
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN/LIST'
	INCLUDE 'LSL$CMNIFF:IFFJUN.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:DLG_DATA.CMN/LIST'
C
C Workspace:
	INTEGER*2	NARMS
	INTEGER*2	NVERTX
	INTEGER*2	NN
	INTEGER*2	NNN
	INTEGER*2	LCOUNT
	INTEGER*2	IECODE
	INTEGER*2	IELEN
	INTEGER*2	NPTS
	INTEGER*2	IENDS
C
	INTEGER		SAVE_LPOSH
	INTEGER		SAVE_OFFSET
	INTEGER		LSTRP
	INTEGER		LP_SAVE(20)
C
	REAL		RPOSX
	REAL		RPOSY
C
	LOGICAL		J_GOOD
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL	SS$_NORMAL	! normal successful completion
C
C Assume the best
	JNCTEX = %LOC(SS$_NORMAL)
C
	IF(NARMS .GT. 0)THEN
C
C Now at a junction (node).
C Check that this junction does not have a pointer to a single point feature
C which is assumed to be a point node feature already representing this node.
C Also skip junctions not referencing this category.
	   SAVE_LPOSH = LPOSH
	   SAVE_OFFSET = IFPOSJ
C
C Examine each arm
	   LCOUNT = 0
	   J_GOOD = .FALSE.
	   DO 50,NN=1,NARMS
	      CALL JIHR(NN,LSTRP,NVERTX)
	      IF (LSTRP .GT. CAT_CODE(CAT_NUM,5) .AND.
     &		  LSTRP .LT. CAT_CODE(CAT_NUM,6)      ) J_GOOD = .TRUE.
	      IF(NVERTX .EQ. 1) THEN
	         LCOUNT = LCOUNT + 1
	         LP_SAVE(LCOUNT) = LSTRP
	      ENDIF
50	   CONTINUE
C
C Ignore a junction referencing all features not in this layer
	   IF( .NOT. J_GOOD ) GOTO 1000 ! jump out
C
C Examine each ST entry
	   IF(LCOUNT .GT. 0)THEN
	   DO 100,NNN=1,LCOUNT
	      CALL IFFPKE(IECODE,IELEN,LP_SAVE(NNN))  ! jump to ST entry
	      IF(IELEN .EQ. -1) THEN
	         JNCTEX=I2DLG__UNEXPEOF
		 CALL LSL_PUTMSG(JNCTEX)
		 GOTO 1000
	      ENDIF
	      CALL EIHRS(NPTS,IENDS)
	      IF(NPTS .EQ. 0) THEN          ! not an ST entry
		 JNCTEX=I2DLG__UNEXPEOF
		 CALL LSL_PUTMSG(JNCTEX)
		 GOTO 1000
	      ENDIF
C
C Test single point feature ( covering special case of header reference
C  feature in layer 0)
	      IF( (NPTS  .EQ. 1) .AND.
     &		  (IENDS .EQ. 0) .AND.
     &		  (LP_SAVE(NNN) .GT. CAT_CODE(1,5)) )GOTO 1000 ! jump out 
C
100	   CONTINUE
	   ENDIF
C
C Haven't found any point features so count this node
C
	   NODE_COUNT = NODE_COUNT + 1
	   NODE_POS(NODE_COUNT,1) = SAVE_LPOSH
	   NODE_POS(NODE_COUNT,2) = SAVE_OFFSET
C
	ENDIF
C
1000	IF(JNCTEX)JNCTEX = %LOC(SS$_NORMAL)
C
	RETURN
	END
