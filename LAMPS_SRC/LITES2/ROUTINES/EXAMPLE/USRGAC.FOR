C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-12-06 14:54:50.000000000 +0000
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
	SUBROUTINE USRGAC(ACTYPE,ACIVAL,ACTXTL,ACTXT,RETCOD)
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
	INTEGER*4	ACTYPE		! type of AC
	INTEGER*4	ACIVAL		! AC value
					! note: to read a real AC value,
					! a copy of this will have to
					! be equivalenced to a real
	INTEGER*4	ACTXTL		! number of characters in ACTXT
	CHARACTER*(*)	ACTXT		! text (maximum of 80 chars)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call USRDO
					! = 1 for get more ACs if there
					!     are any, or start getting
					!     coords if reqd, or call
					!     USRDO if coords not reqd
					! = 2 stop getting ACs, start
					!     getting cooordinates
					! = 4 for call USRDO right away
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C working storage
C
	INCLUDE	'USRKEEP.CMN'
	INCLUDE 'USRFEAT.CMN'
C
	REAL		ACRVAL
	INTEGER*4	ACVAL
	EQUIVALENCE	(ACRVAL,ACVAL)		! to interpret type 3 ACs
	LOGICAL		TO_FILE
C
	GOTO (9000,200,9000,9000,9000,9000,700,9000,9000,
     &	      9000,9000,200) USR_ACTION
	GOTO 9000
C
C listing details of feature
C
  200	CONTINUE
	TO_FILE = USR_ACTION .EQ. 12
	NHACS=NHACS+1
C
C list this AC
C
	IF (ACTYPE.EQ.3) THEN			! height AC
	   ACVAL=ACIVAL
	   IF (ACTXTL.GT.0) THEN		! with text
	      IF (TO_FILE) THEN
		 WRITE(6 210) ACTYPE,ACRVAL,ACTXT(1:ACTXTL)
	      ELSE
		 PRINT 210,ACTYPE,ACRVAL,ACTXT(1:ACTXTL)
	      ENDIF
  210	      FORMAT(I7,F12.3,5X,A)
	   ELSE					! no text
	      IF (TO_FILE) THEN
		 WRITE(6, 215) ACTYPE,ACRVAL
	      ELSE
		 PRINT 215,ACTYPE,ACRVAL
	      ENDIF
  215	      FORMAT(I7,F12.3)
	   ENDIF
	ELSE					! TC/CH/non-height AC
	   IF (ACTXTL.GT.0) THEN		! with text
	      IF (TO_FILE) THEN
		 WRITE(6 220) ACTYPE,ACIVAL,ACTXT(1:ACTXTL)
	      ELSE
		 PRINT 220,ACTYPE,ACIVAL,ACTXT(1:ACTXTL)
	      ENDIF
  220	      FORMAT(I7,I9,8X,A)
	   ELSE					! no text
	      IF (TO_FILE) THEN
		 WRITE(6,225) ACTYPE,ACIVAL
	      ELSE
		 PRINT 225,ACTYPE,ACIVAL
	      ENDIF
  225	      FORMAT(I7,I9)
	   ENDIF
	ENDIF
C
C if that was last one, output message for coordinates
C
	IF (NHACS.EQ.USR_NACS) THEN
	   IF (TO_FILE) THEN
	      WRITE(6,230) USR_NCOORD
	   ELSE	      
	      PRINT 230,USR_NCOORD
	   ENDIF
	ENDIF
 230	FORMAT(/' The',I6,' coords are:-'//
     &	             11X,'X',14X,'Y',6X,'Flags'//)
C
C get more ACs or coordinates
C
	RETCOD=1
	GOTO 9999
C
C get and store feature
C
  700	CONTINUE
	NHACS=NHACS+1
	TYPE(NHACS)=ACTYPE
	VALUE(NHACS)=ACIVAL
	TXTL(NHACS)=ACTXTL
	TXT(NHACS)=ACTXT(1:ACTXTL)
	IF (NHACS.LT.NUMACS.AND.NHACS.LT.USR_NACS) THEN
	   RETCOD=1			! get more ACs
	ELSE
	   RETCOD=2			! all space for ACs full,
	ENDIF				! get coords now
	GOTO 9999
C
C invalid action
C
 9000	CONTINUE
	PRINT 9010,USR_ACTION
 9010	FORMAT(' Unknown action',I6,' for user routine USRGAC'//
     &	       ' User routine being aborted'/)
C
	RETCOD=0
C
 9999	CONTINUE
	RETURN
	END
