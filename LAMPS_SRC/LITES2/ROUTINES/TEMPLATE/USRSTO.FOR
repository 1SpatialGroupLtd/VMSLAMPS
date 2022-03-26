	SUBROUTINE USRSTO(FSN,FC,MAP,LAYER,TXTF,NOPTS,NAC,
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
	INTEGER*4	FSN		! feature serial number to use
					! (set to -1 for unknown)
	INTEGER*4	FC(4)		! feature status to use
					! (set FC(I) to -1 for unknown)
	INTEGER*4	MAP		! map to put feature in
					! (set to -1 for unknown)
	INTEGER*4	LAYER		! layer to use
					! (set to -1 for unknown)
	LOGICAL		TXTF		! .TRUE. if FC =-1 and want
					! to create a text feature
	INTEGER*4	NOPTS		! number of points in feature
	INTEGER*4	NAC		! number of ACs in feature
	REAL		ROTAT		! rotation if text or oriented
					! symbol (in radians)
	INTEGER*4	THICK		! size of text
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call completion
					!     routine
					! = 1 for ask for data
					! = 4 abort, call completion
					!     routine
C
C all the arguments in this subroutine are writable
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
