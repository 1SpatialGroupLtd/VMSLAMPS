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
C	Dummy routine
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
					! > 100 - call the routine to get
					!  map header information (for map
					!  RETCOD - 100)
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
C announce ourselves
C
	PRINT 10,ACTION
   10	FORMAT('0LITES2 User routine',I5
     &	       /' This version is a dummy that does not do anything'//)
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
