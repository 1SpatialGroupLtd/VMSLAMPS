C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-12-06 14:51:34.000000000 +0000
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
	SUBROUTINE USRGCB(SIZE,USERXY,USRFLG,
     &	                 MAX_ATTR,USERNATT,USERATTC,
     &	                 USERDATATYPES,USERNAMELENS,USERNAMES,USERIATTV,
     &	                 USERRATTV,RETCOD)
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
	INTEGER*4	SIZE		! number of corrds passed
					! with this call
	REAL		USERXY(2,SIZE)	! coords
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER		MAX_ATTR	! maximum number of attributes
	INTEGER		USERNATT	! number of attributes present
	INTEGER		USERATTC(MAX_ATTR)	! attribute codes
	INTEGER		USERDATATYPES(MAX_ATTR)	! datatypes if attributes
	INTEGER		USERNAMELENS(MAX_ATTR)	! name lengths
	CHARACTER*(*)	USERNAMES(MAX_ATTR)		! names
C
C the following two arrays are equivalenced in the calling routine
	INTEGER		USERIATTV(MAX_ATTR,*)	! integer values
	REAL		USERRATTV(MAX_ATTR,*)	! real values
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call USRDO
					! = 1 for get more coords
					!     or call USRDO, if no more
					! = 4 for abort, but call USRDO
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C working storage
C
	INCLUDE	'USRKEEP.CMN'
	INCLUDE 'USRFEAT.CMN'
C
	INTEGER*4	IABSENT
	PARAMETER	(IABSENT = '80000000'X)
C
	INTEGER*4	I		! loop counter
	INTEGER*4	J,K
	REAL		TOPZ
	INTEGER		TOPPT
	INTEGER		ZINDEX
	CHARACTER*80	OUTSTR
	INTEGER		ATTCINDEX(20)
	INTEGER		INT4
	REAL		REAL4
	EQUIVALENCE	(INT4,REAL4)
	LOGICAL		TO_FILE
C
C switch on number  of USER routine
C
	GOTO (9000,200,9000,9000,9000,9000,700,700,9000,
     &	      9000,9000,200) USR_ACTION
	GOTO 9000
C
C listing details of feature
C
  200	CONTINUE
	TO_FILE = USR_ACTION .EQ. 12
C
C find names
	ZINDEX = 0
	OUTSTR = '  Pt     X        Y'
  201	FORMAT(' ',A8)
  202	FORMAT(A)
	DO 205, I = 1,USERNATT
	   IF (USERNAMES(I)(1:USERNAMELENS(I)).EQ.'Z') THEN
	      ZINDEX = I
	   ENDIF
	   J = 6+(I+1)*9
	   WRITE(OUTSTR(J:J+8),201),
     &	         USERNAMES(I)(1:MIN(USERNAMELENS(I),8))
  205	CONTINUE
C
C output header
	IF (TO_FILE) THEN
	   WRITE (6, *) ' '
	   WRITE (6,202) OUTSTR
	   WRITE (6, *) ' '
	ELSE
	   PRINT *,' '
	   PRINT 202,OUTSTR
	   PRINT *,' '
	ENDIF
C
C list this lot of coordinates
  210	FORMAT(F14.3)
  211	FORMAT('     ',A4)
  215	FORMAT(' ',I8)
  216	FORMAT('     -   ')
  217	FORMAT(' ',I4,2F14.3)
	DO 220,I=1,SIZE
	   WRITE(OUTSTR,217),I+NHPTS,USERXY(1,I),USERXY(2,I)
	   DO 219,J=1,MIN(USERNATT,6)
	      K = 6+(J+1)*9
	      IF (USERIATTV(J,I).EQ.IABSENT) THEN
	         WRITE(OUTSTR(K:K+8),216)
	      ELSEIF (USERDATATYPES(J).EQ.2) THEN
	         WRITE(OUTSTR(K:K+8),210),USERRATTV(J,I)
	      ELSEIF (USERDATATYPES(J).EQ.3) THEN
	         WRITE(OUTSTR(K:K+8),211),USERRATTV(J,I)
	      ELSE
	         WRITE(OUTSTR(K:K+8),215),USERIATTV(J,I)
	      ENDIF
  219	   CONTINUE
C
C output header
	   IF (TO_FILE) THEN
	      WRITE(6, 202) OUTSTR
	   ELSE
	      PRINT 202,OUTSTR
	   ENDIF
C       
  220	CONTINUE
C
  	NHPTS=NHPTS+SIZE
C
C get more points
	RETCOD=1
	GOTO 9999
C
C get and store feature
C
  700	CONTINUE
	IF ((NHPTS+SIZE).GT.NUMPTS) THEN
	   PRINT 710
  710	   FORMAT(' Tried to store too many coordinates in USRGCB'/
     &	          ' User routine abandoned'/)
	   RETCOD=0
	ELSE
C
	   DO 720, I=1,SIZE
	      J=NHPTS+I
	      COORD(1,J)=USERXY(1,I)
	      COORD(2,J)=USERXY(2,I)
	      IF (ZINDEX.GT.0) THEN
	         COORD(3,J) = USERRATTV(ZINDEX,I)
	      ELSE
	         INT4 = IABSENT
	         COORD(3,J) = REAL4	! equivalenced
	      ENDIF
	      FLG(J)=USRFLG(I)
  720	   CONTINUE
C
C this block of attributes may not be in same order as previous blocks
C so we have to have an index array to put them into our common block
C
	   DO 740, I = 1,USERNATT
C
C is this attribute in our list already?
	      DO 730, J = 1,FEATNATT
	         IF (FEATATTC(J).EQ.USERATTC(I)) THEN
	            ATTCINDEX(I) = J
	            GOTO 740
	         ENDIF
  730	      CONTINUE
C
C we have not had this feature already, so add it to feature's attributes
	      IF (FEATNATT.LT.NUMATTS) THEN
	         FEATNATT = FEATNATT + 1
	         FEATATTC(FEATNATT) = USERATTC(I)
	         FEATATTDT(FEATNATT) = USERDATATYPES(I)
	         ATTCINDEX(I) = FEATNATT
	      ELSE
C
C no room for this attribute, so throw it away
	         ATTCINDEX(I) = 0
	      ENDIF
  740	   CONTINUE
C
C now add the data to the data structure
	   DO 770, I= 1,SIZE
C
C first set all columns to absent
	      DO 750, J = 1,NUMATTS
	         FEATIATTV(J,I+NHPTS) = IABSENT
  750	      CONTINUE
C
C and the actual data
	      DO 760, J = 1,USERNATT
	         K = ATTCINDEX(J)
	         IF (K.GT.0) FEATIATTV(K,I+NHPTS) = USERIATTV(J,I)
  760	      CONTINUE
  770	   CONTINUE
C	   	   
C get more coordinates if there are any
	   NHPTS=NHPTS+SIZE
	   RETCOD=1
	ENDIF
	GOTO 9999
C
C invalid action
C
 9000	CONTINUE
	PRINT 9010,USR_ACTION
 9010	FORMAT(' Unknown action',I6,' for user routine USRGCB'//
     &	       ' User routine being aborted'/)
C
	RETCOD=0
C
 9999	CONTINUE
	RETURN
	END
