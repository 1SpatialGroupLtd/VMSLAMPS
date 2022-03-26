	LOGICAL FUNCTION SKIP_CONTLIN
C
CDEC$	IDENT	'17JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	17-Jul-1990
C
C	CONVERT SIF2IFF Utility - get SIF coords in a SIF command line
C
C Description
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
C
C Common Blocks
C
C
C Functions called
C
	LOGICAL		READSTR		! read a string
	LOGICAL		CONT_LINE	! continuation line
C
C Local Variables
C
	CHARACTER*80	DUMSTR		! dummy character string
	INTEGER*4	LEN		! string length
C
C Assume that everything goes well
C
	SKIP_CONTLIN = .TRUE.
C
10	LEN = READSTR(DUMSTR)
C
C If LEN is 0 treat as no continuation line.
C
	IF (LEN.NE.0) THEN
	   IF (DUMSTR(LEN:LEN).EQ.',') THEN
	     IF (.NOT.CONT_LINE()) GOTO 9999
	     GOTO 10
	   ENDIF
	ENDIF
	GOTO 9000
C
9999	SKIP_CONTLIN = .FALSE.
C
9000	RETURN
	END
