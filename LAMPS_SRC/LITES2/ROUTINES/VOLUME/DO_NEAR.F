	LOGICAL FUNCTION DO_NEAR
C
CDEC$	IDENT	'13JN91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Get profile nearest cursor
C
        IMPLICIT NONE
C
C functions
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
	IF (PROFANG.NE.0.0) CALL FILL_ROTATE(
     &				-PROFANG,USR_CURSOR(1),USR_CURSOR(2))
	IF (PYMAX-PYMIN.EQ.0.0) THEN	! avoid zero divide
	   NEARP = 0
	ELSE
	   NEARP = NINT((USR_CURSOR(2)-PYMIN)/(PYMAX-PYMIN)*(NPROF+1))
	ENDIF
C
	IF (NPROF.LE.0.OR.NEARP.LE.0.OR.NEARP.GT.NPROF) THEN
	   CALL TTWSTR('Cursor is not near any profile')
	   DO_NEAR = .FALSE.
	   GOTO 9999
	ENDIF
C
	DO_NEAR = .TRUE.
C
9999	RETURN
	END
