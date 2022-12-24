C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 17:18:46.000000000 +0000
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
	SUBROUTINE USRPCB(SIZE,USERXY,USERFLG,
     &	              MAX_ATTR,USERNATT,USERATTC,
     &	              USERIATTV,USERRATTV,RETCOD)
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
	INTEGER*4	SIZE		! input:  maximum number of
					!         coords to pass back
					! output: actual number of
					!         coords passed back
					! with this call
	REAL		USERXY(2,SIZE)	! coords
	LOGICAL*1	USERFLG(SIZE)	! flags (visibility only)
	INTEGER		MAX_ATTR	! maximum number of attributes
	INTEGER		USERNATT	! number of attributes present
	INTEGER		USERATTC(MAX_ATTR)	! attribute codes
C
C the following two arrays are equivalenced in the calling routine
	INTEGER		USERIATTV(MAX_ATTR,*)	! integer values
	REAL		USERRATTV(MAX_ATTR,*)	! real values
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call USRRET
					! = 1 for write more coords, if
					!     there are any, or else
					!     call USRRET
					! = 4 for abort, call USRRET
C
C	All these arguments are writable.
C
C working storage
C
	INCLUDE 	'USRKEEP.CMN'
	INCLUDE		'USRFEAT.CMN'	
C
	INTEGER		BUFFSZ
	PARAMETER	(BUFFSZ=20)
C
	INTEGER*4	I,J,K
	INTEGER*4	NPTS
C
C get number of points to send
C
C don't send more than maximum number
C ===================================
C
	NPTS=MIN(BUFFSZ,SIZE)
	IF (TEXTFEAT) NPTS = 1
C
C ===================================
C
	IF ((NHPTS+NPTS).GT.USR_NCOORD) THEN ! there are not NPTS left
	   SIZE=MOD(USR_NCOORD,NPTS)
	ELSE
	   SIZE=MIN(NPTS,USR_NCOORD)
	ENDIF
C
	USERNATT = FEATNATT	
C
C set up attribute codes for this block of data
	DO 10, I= 1,USERNATT
	   USERATTC(I) = FEATATTC(I)
   10	CONTINUE
C
C fill arrays
	DO 20, I=1,SIZE
	   J=NHPTS+I
	   USERXY(1,I)=COORD(1,J)
	   USERXY(2,I)=COORD(2,J)
	   USERFLG(I)=FLG(J)	   
	   DO 20, K = 1,USERNATT
	      USERIATTV(K,I) = FEATIATTV(K,J)
	   CONTINUE
   20	CONTINUE
C
	NHPTS=NHPTS+SIZE
C
	RETCOD=1			! when all coordinates sent
					! USRRET will be called
C
	RETURN
	END
