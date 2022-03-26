	LOGICAL FUNCTION SHOW_ENA(CHOICE)
C
CDEC$	IDENT	'19AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	19-May-1992
C
C Description:
C
C	Function to show all or individual options selected.
C       CHOICE = 1   - show all settings
C       CHOICE = 2   - show reply
C       CHOICE = 3   - show verbose
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
C
C Arguments
C
	INTEGER*4	CHOICE
C
C***********************************************************************
C
	IF (.NOT.HAD_ENA_REPLY .AND. CHOICE.GT.1) GOTO 100
C
C Show reply setting
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.2) THEN
	   IF (HAD_ENA_REPLY) THEN
	      CALL WRITEF('Command reply : ENABLED')
	   ELSE
	      CALL WRITEF('Command reply : DISABLED')
	   ENDIF
	ENDIF
C
C Show verbose setting
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.3) THEN
	   IF (HAD_ENA_VERB) THEN
	      CALL WRITEF('Verbose       : ENABLED')
	   ELSE
	      CALL WRITEF('Verbose       : DISABLED')
	   ENDIF
	ENDIF
C
	CALL WRITEF
100	RETURN
	END
