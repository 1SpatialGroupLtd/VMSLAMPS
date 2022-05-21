C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1997-03-26 14:00:04.000000000 +0000
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
	LOGICAL FUNCTION GO_CMD()
C
CDEC$	IDENT	'26MR97'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	19-May-1992
C
C Description:
C
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
C
C Local workspace
C
	INTEGER*4	I		! loop count
	CHARACTER*2	TMPC
C
C ......................................................................
C
C Only GO if DEVICE, LIBRARY, TARGET given and all CLASSES selected
C If COVERAGES not given, default to all - give warning
C If GEOREF not given, default to all - give warning
C
	GO_CMD = .TRUE.		! assume success
C
C Check library
C
	IF (LIBRARY.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTGO,'the library')
	   GO_CMD = .FALSE.
	   GOTO 50
	ENDIF
C
C Check device
C
	IF (.NOT.HAD_DEVICE) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTGO,'a device')
	   GO_CMD = .FALSE.
	   GOTO 50
	ENDIF
C
C Check target directory
C
	IF (.NOT.HAD_TARGET) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTGO,'a target directory')
	   GO_CMD = .FALSE.
	   GOTO 50
	ENDIF
C
C Check FCT was given. No point in GOing without it because no features will
C be selected.
C
	IF (.NOT.HAD_FCT) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTGO,'a Feature Code Table')
	   GO_CMD = .FALSE.
	   GOTO 50
	ENDIF
C
C Check if any classes selected
C
	IF (.NOT.(WANT_AREAS  .OR. WANT_LINES  .OR.
     &	          WANT_POINTS .OR. WANT_TEXT)) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTGO,'at least one class')
	   GO_CMD = .FALSE.
	   GOTO 50
	ENDIF
C
C Check coverages
C
	IF (.NOT.HAD_SEL_COV) THEN
	   CALL LSL_PUTMSG(DCW2I__ALLSEL,'coverages')
	   HAD_SEL_COV = .TRUE.
	   DO 10 I = STARTPOS,ENDPOS
	      COVER_SEL(I) = 1
10	   CONTINUE
	ENDIF
C
C Check GEOREFs
C
	IF (LIBRARY.NE.BROWSE .AND. .NOT.HAD_SEL_GEO) THEN
	   CALL LSL_PUTMSG(DCW2I__ALLSEL,'GEOREFs')
	   ALL_GEO_SEL = .TRUE.
	ENDIF
C
C Report on final selections
C
	CALL WRITEF
	CALL SHOW_SEL(1)
C
C Copy over all coverage selections into another array to save humping
C unnecessary junk around.
C
	NUM_COV_SEL = 0
	DO 20 I = STARTPOS, ENDPOS
	   IF (COVER_SEL(I).EQ.1) THEN
	      NUM_COV_SEL = NUM_COV_SEL + 1
	      TMPC = COVERAGE(I)(1:2)		! TMPC used so that code VESTs
	      COV_SEL(NUM_COV_SEL)(1:2) = TMPC	! properly when optimised.
	   ENDIF
20	CONTINUE
C
C ......................................................................
C
50	CALL WRITEF
	RETURN
	END
