	LOGICAL FUNCTION EXAMINE_TERM()
C
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created from DTMCEATE module TRIANG.SRC		ST	13-May-1992
C
C Description:
C
C	Function to examine SYS$OUTPUT to see if it is assigned to a terminal
C	If it is we must determine whether it is a CRT or not.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE '($DVIDEF)/NOLIST'
	INCLUDE	'($DCDEF)/NOLIST'
	INCLUDE	'($SSDEF)/NOLIST'
C
C Local workspace
C
	INTEGER		VALUE		! for GETDVI
	LOGICAL		LIB$GETDVI	! get term characteristics etc.
	LOGICAL		IS_TERM
C
C ......................................................................
C
C Initialise
C
	IS_TERM=.FALSE.
C
C See if output is to a terminal
C
	EXAMINE_TERM=LIB$GETDVI(DVI$_DEVCLASS,,'SYS$OUTPUT',VALUE,,)
	IF (EXAMINE_TERM) THEN			 ! success?
	   IF (VALUE.EQ.DC$_TERM) IS_TERM=.TRUE. ! it is a terminal?
	ELSE
	   CALL LSL_PUTMSG(EXAMINE_TERM)
	   GOTO 10
	ENDIF
C
C If we have a terminal, is it a CRT?
C
	IF (IS_TERM) THEN	
	  EXAMINE_TERM=LIB$GETDVI(DVI$_TT_SCOPE,,'SYS$OUTPUT',VALUE,,)
	  IF (.NOT.EXAMINE_TERM) THEN
	     CALL LSL_PUTMSG(EXAMINE_TERM)
	  ENDIF	
	ENDIF
10	IF (EXAMINE_TERM) EXAMINE_TERM=SS$_NORMAL
	RETURN
	END
