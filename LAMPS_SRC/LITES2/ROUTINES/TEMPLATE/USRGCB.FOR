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
