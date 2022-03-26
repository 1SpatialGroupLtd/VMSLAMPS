	LOGICAL FUNCTION DO_VOL
C
CDEC$	IDENT	'17MY91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Volume calculation routine
C
        IMPLICIT NONE
C
	INCLUDE		'USRKEEP.CMN'
	INCLUDE 	'USRFEAT.CMN'
C
C workspace
	INTEGER		I
	LOGICAL		ODD
C
C check all profiles measured
	DO 10 I=1,NPROF
	   IF (.NOT.PDONE(I)) THEN
	      CALL TTWSTR('One or more profiles have not been measured yet')
	      CALL WRITEF('   for example, profile %N',I)
	      DO_VOL = .FALSE.
	      GOTO 9999
	   ENDIF
10	CONTINUE
C
C integrate the volume using Prismoidal rule (i.e. Simpson's)
C see Ron's book - Practical Field Surveying..., page 558
C
	VOLUME = 0D0
	ODD = .TRUE.
	DO 20 I=1,NPROF
	   IF (ODD) THEN
	      VOLUME = VOLUME + 4*AREA(I)
	   ELSE
	      VOLUME = VOLUME + 2*AREA(I)
	   ENDIF
	   ODD = .NOT.ODD
20	CONTINUE
	VOLUME = VOLUME*((PYMAX-PYMIN)/(NPROF+1))/3.0D0
C
	DO_VOL = .TRUE.
C
9999	RETURN
	END
