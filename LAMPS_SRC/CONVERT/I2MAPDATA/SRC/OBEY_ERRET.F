	OPTIONS /I4
	INTEGER FUNCTION OBEY_ERRET(SIGARGS,MECHARGS)
C
CDEC$	IDENT	'19SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England
C
CMOD	Special version, renamed OBEY_ERRET, for	RJH  19-Sep-1994
CMOD	   I2MAPDATA; references a local common block,
CMOD	   LOCAL_REPORT
C	Created (as DCL_ERRET)				 TJH 22-OCT-1985
C
C To be declared as an exception handler. Unwinds to the subroutine 
C that declared us, pretending that the subroutine that was called 
C has returned with an error.
C
	IMPLICIT NONE
C
C Common block to carry LOCAL_REPORT through into this condition handler
	LOGICAL*4	LOCAL_REPORT	! report error locally?
	COMMON /OBEY_REPORT/ LOCAL_REPORT	
C
C arguments:
	INTEGER SIGARGS(*),MECHARGS(*)
C
C parameters:
	INCLUDE '($SSDEF)'
C
C ......................................................................
C
	IF (LOCAL_REPORT) THEN
	   SIGARGS(1)=SIGARGS(1)-2 ! subtract PC/PSL from signal array
	   CALL SYS$PUTMSG(SIGARGS,,,)	
	   SIGARGS(1)=SIGARGS(1)+2 ! replace PC/PSL in signal array
	ENDIF
	OBEY_ERRET=SS$_CONTINUE
	RETURN
	END
