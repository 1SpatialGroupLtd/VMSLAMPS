C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 16:57:48.000000000 +0000
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
C       Author Ron Russell			RWR	30-Nov-1988
C
C Description
C
C	LITES2 cartographic editor user command routines.
C	Dummy user routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	SIZE		! number of coords passed
					! with this call
	REAL		USERXY(2,SIZE)	! coordinates
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER		MAX_ATTR	! maximum number of attributes
	INTEGER		USERNATT	! number of attributes present
	INTEGER		USERATTC(MAX_ATTR)	! attribute codes
	INTEGER		USERDATATYPES(MAX_ATTR)	! datatypes of attributes
	INTEGER		USERNAMELENS(MAX_ATTR)	! name lengths
	CHARACTER*(*)	USERNAMES(MAX_ATTR)	! names of attributes
C
C the following two arrays are equivalenced in the calling routine
	INTEGER		USERIATTV(MAX_ATTR,*)	! integer values
	REAL		USERRATTV(MAX_ATTR,*)	! real values
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call processing
					!     routine
					! = 1 for get more coords
					!     or call processing routine,
					!     if no more
					! = 4 for abort, but call
					!     processing routine
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C	the following parameter is for testing if an attribute value
C	is present for a particular point
C
C	NOTE: this must be tested against an integer, which has
C	been equivalenced onto the real value to be tested
C
	INTEGER*4	IABSENT
	PARAMETER	(IABSENT = '80000000'X)
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
