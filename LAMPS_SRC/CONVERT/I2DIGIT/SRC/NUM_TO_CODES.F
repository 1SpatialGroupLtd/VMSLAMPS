	SUBROUTINE NUM_TO_CODES(NUMBER,NUMCODES,CODEARRAY)
C
CDEC$	IDENT	'12DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	12-Decov-1991
C
C Description:
C       Convert the value of NUMBER into a set of individual digits
C       and store the result in CODEARRAY. The input number should never
C       exceed 999 so only three digits are required. NUMCODES is used by
C       the calling routine to tell how many values in CODEARRAY.
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'CODES.CMN'
C
C Local Variables
C
	INTEGER*2	NUMBER
	INTEGER*2	NUMCODES
	INTEGER*2	CODEARRAY(3)
C
C------------------------------------------------------------------------------
C
	IF (NUMBER.LT.10) THEN
	   CODEARRAY(1) = NUMBER
	   NUMCODES = 1
	ELSEIF (NUMBER.LT.100) THEN
	   CODEARRAY(1) = NUMBER / 10
	   CODEARRAY(2) = MOD(NUMBER,10)
	   NUMCODES = 2
	ELSEIF (NUMBER.LT.1000) THEN
	   CODEARRAY(1) = NUMBER / 100
	   CODEARRAY(2) = (MOD(NUMBER,100)) / 10
	   CODEARRAY(3) = MOD(NUMBER,10)
	   NUMCODES = 3
	ELSE
	   NUMCODES = 0
	ENDIF
C
	RETURN
	END
