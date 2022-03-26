        INTEGER*4  FUNCTION OPEN_FILES()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB  11-Aug-1989
C
C Get input and output files
C
	IMPLICIT NONE
C
C System parameters
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C Functions:
C
	INTEGER*4	OPEN_IFF	! open IFF file for readonly
	INTEGER*4	OPEN_FRT	! open FRT file containing ACD table
	INTEGER*4	OPEN_DLG	! open DLG file for write
C
C Workspace:
C
C
C ......................................................................
C
C
	OPEN_FILES=%LOC(SS$_NORMAL)
C
C Open IFF input file
C
	OPEN_FILES = OPEN_IFF()
	IF(OPEN_FILES)THEN
C
C Open FRT lookup table
C
	   OPEN_FILES = OPEN_FRT()
	   IF(OPEN_FILES)THEN
C
C Open DLG file
C
	      OPEN_FILES = OPEN_DLG()
C
	   ENDIF
C
	ENDIF
C
C ......................................................................
C
	IF (OPEN_FILES) OPEN_FILES=%LOC(SS$_NORMAL) ! normal completion?
	RETURN
	END
