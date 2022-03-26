	LOGICAL FUNCTION CONVERTR(TYPE)
C
CDEC$	IDENT	'16AU91'
C
C       Copyright Laser-Scan Ltd., Cambridge, England.
C
C       Author CCB	Jiffy				21-May-1991
C	Mod		JB				13-Aug-1991
C	Standardised and extended
C
C Description
C
        IMPLICIT NONE
C
C arguments
	INTEGER	TYPE		! data type
C
	IF (TYPE.EQ.1) THEN
	   CALL TTWSTR('Creating BYTE file')
	ELSEIF (TYPE.EQ.2) THEN
	   CALL TTWSTR('Creating WORD file')
	ELSEIF (TYPE.EQ.3) THEN
	   CALL TTWSTR('Creating LONG DTI file')
	ELSEIF (TYPE.EQ.4) THEN
	   CALL TTWSTR('Creating REAL DTI file')
	ENDIF
C
	CONVERTR = .TRUE.		! success
C
1000	RETURN
	END
C
