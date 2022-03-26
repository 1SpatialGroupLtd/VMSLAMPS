	LOGICAL FUNCTION FILE_EXISTS(PATH)
C
CDEC$	IDENT	'22MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	22-May-1992
C
C Description:
C
C       Routine to check for the existance of a file. If is does exists, it
C       immediately closes it again. Otherwise the function returns false.
C
	IMPLICIT NONE
C
C Functions
C
	INTEGER*4	FLRCLO			! close file
	INTEGER*4	FLROPN			! open file
C
C Local workspace
C
	CHARACTER*(*)	PATH			! working path name
C
C ......................................................................
C
	FILE_EXISTS = FLROPN(1,PATH,,)
C
	IF (FILE_EXISTS) CALL FLRCLO(1)
C
C ......................................................................
C
999	RETURN
	END
