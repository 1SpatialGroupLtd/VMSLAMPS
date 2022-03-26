	SUBROUTINE USRPCB(SIZE,USERXY,USERFLG,
     &	              MAX_ATTR,USERNATT,USERATTC,
     &	              USERIATTV,USERRATTV,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	28-Nov-1988
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Dummy user routine
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
					! = 0 abort, dont call completion
					!     routine
					! = 1 for write more coords, if
					!     there are any, or else
					!     call USRRET
					! = 4 for abort, call completion
					!     routine
C
C	All these arguments are writable.
C
C don't send more than maximum number of attributes -- most important
C ===================================================================
C
C this is a dummy routine that does nothing
C
	RETCOD=0
C
	RETURN
	END
