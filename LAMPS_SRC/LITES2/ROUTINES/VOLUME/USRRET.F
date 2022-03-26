	SUBROUTINE USRRET(CNDFLG,RTSTRL,RTSTR,RETCOD)
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
C	Volume calculation routine
C
        IMPLICIT NONE
C
C Arguments
C
	LOGICAL		CNDFLG		! LITES2 conditional flag
	INTEGER*4	RTSTRL		!  input: maximum size of RTSTR
					! output: size of RTSTR
	CHARACTER*(*)	RTSTR		! LITES2 command line, to be 
					! executed before any other
					! command
	INTEGER*4	RETCOD		! return code
					! = 0 for abort
					! = 1 for CNDFLG to be set
					!     and command to be executed
					! = 2 for call USRDO again
					! = 3 for call USRDEF
C
	INCLUDE	'USRFEAT.CMN'
	INCLUDE	'USRKEEP.CMN'
C
C working storage
C
	INTEGER*4	I
C
	RTSTRL = 0		! never execute LITES2 command
	CNDFLG = .FALSE.	! assume failure
	VARSUB = 0		! assume no subscript
C
	IF (ERROR) THEN
	   RETCOD = 1		! set condition
	   GOTO 9999
	ENDIF
C
	GOTO (9000,200,300,400,500,600), USR_ACTION
	GOTO 9000
C
C here from routine setting parameters and bounding polygon
C set variables to answers
200	VARNUM = VARNUM+1
	GOTO (201,202,203,204), VARNUM
C
C mark all profiles as not done yet
	DO 210 I=1,NPROF
	   PDONE(I) = .FALSE.
210	CONTINUE
	GOTO 1000
C
201	VAR = 'VOL_RMSRES'
	VARL = 10
	RVAL = RMSRES
	GOTO 1010
C
202	VAR = 'VOL_MAXRES'
	VARL = 10
	RVAL = MAXRES
	GOTO 1010
C
203	CONTINUE
C
C if required, then calculate number of profiles to do here
	IF (DOSPC) THEN
	   NPROF = 2*NINT((PYMAX-PYMIN)/PROFSPC/2.0)-1
	   IF (NPROF.LE.0) NPROF = 1
	   IF (NPROF.GT.MAXPROF) NPROF = MAXPROF
	ENDIF
C
	VAR = 'VOL_UNPROF'
	VARL = 10
	IVAL = NPROF
	GOTO 1010
C
204	VAR = 'VOL_USPACE'
	VARL = 10
	RVAL = (PYMAX-PYMIN)/(NPROF+1)
	GOTO 1010
C
C here from routine preparing to digitise a profile
C set variables to answers
300	VARNUM = VARNUM+1
	IF (VARNUM.GT.3) GOTO 1000
C
	VAR = 'VOL_CURS'
	VARL = 8
	VARSUB = VARNUM		! subscripted variable
	RVAL = PSTART(VARNUM)
	GOTO 1010
C
C here from routine accepting a profile
C set variables to answers
400	VARNUM = VARNUM+1
	GOTO (401,402,403), VARNUM
	GOTO 1000
C
401	VAR = 'VOL_RMSRES'
	VARL = 10
	RVAL = RMSRES
	GOTO 1010
C
402	VAR = 'VOL_MAXRES'
	VARL = 10
	RVAL = MAXRES
	GOTO 1010
C
403	VAR = 'VOL_AREA'
	VARL = 8
	RVAL = AREA(PROFNO)
	GOTO 1010
C
C here from routine calculating volume
C set variables to answers
500	VARNUM = VARNUM+1
	GOTO (501), VARNUM
	GOTO 1000
C
501	VAR = 'VOL_VOLUME'
	VARL = 10
	RVAL = VOLUME
	GOTO 1010
C
C here from routine finding nearest profile
C set variables to answers
600	VARNUM = VARNUM+1
	GOTO (601), VARNUM
	GOTO 1000
C
601	VAR = 'VOL_PROFNO'
	VARL = 10
	IVAL = NEARP
	GOTO 1010
C
C here with successful exit
1000	CNDFLG = .TRUE.	! success
	RETCOD = 1		! done
	GOTO 9999
C
C here to set a variable
1010	RETCOD = 3		! set variable
	GOTO 9999
C
C invalid action
C
9000	CALL WRITEF('Unknown action %N for user routine USRRET',USR_ACTION)
	CALL TTWSTR('User routine being aborted')
	RETCOD = 1
C
9999	CONTINUE
	RETURN
	END
