	SUBROUTINE USRGMH(MH_LEN,MH,WRITE_MH,MD_LEN,MD,WRITE_MD,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Template
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	MH_LEN		! input  - length of original MH
					! output - length of updated MH
	INTEGER*2	MH(MH_LEN)	! map header - NOTE INTEGER*2
	LOGICAL*4	WRITE_MH	! input  - TRUE if MH is writeable
					! output - TRUE if MH is to be written
	INTEGER*4	MD_LEN		! input  - length of original MD
					! output - length of updated MD
	INTEGER*2	MD(MD_LEN)	! map descriptor - NOTE INTEGER*2
	LOGICAL*4	WRITE_MD	! input  - TRUE if MD is writeable
					! output - TRUE if MD is to be written
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
					! > 100 - call this routine again
C
C	All these arguments may be considered writeable but note that
C	the new lengths of the arrays MUST not be longer than the
C	original arrays
C
C	Trying to write a map header or a map descriptor to a file that
C	has been opened for READing only will cause an error.
C
C	Writing a new map header or map descriptor will not affect the
C	idea that LITES2 has of the origin and scale, and the system,
C	variables $MHARR, $MHLEN, $MDARR and $MDLEN although the output
C	file will contain the changes.
C
C	Changes to the projection parts of the map descriptor (ie apart
C	from the origin and scale) require an intimate knowledge of
C	Laser-Scan's projection software. It is recommended that such
C	changes are made using the program ITRANS.
C
C do not write anything back
	WRITE_MH = .FALSE.
	WRITE_MD = .FALSE.
C
	RETCOD = 0				! stop
C
10000   CONTINUE
	RETURN
	END
