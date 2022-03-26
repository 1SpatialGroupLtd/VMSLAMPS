	SUBROUTINE LCMWARN(INSTR)
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		14-06-92
C
	IMPLICIT NONE
C
C Always output a message, and if needed do one to the listing file.
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
	INCLUDE 'HERE:LCM.CMN'
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
	INCLUDE 'HERE:LCMMSG.PAR'
C
C Arguments
	CHARACTER*(*)	INSTR
C
C Functions
C
C..............................................................................
C
	IF (LIST) THEN					!is there a list file?
	  CALL FLWSEL(LIST_LUN)				! select it
	  CALL FLWSTR('% '//INSTR)			! output data
	ENDIF
C
C	........................................................................
C 	lslputmsgs (bleughh!) HAVE to be used.. for all terminal output

	IF (.NOT.QUIET) THEN
	  CALL LSL_PUTMSG(LCM__WARN,INSTR)
	ENDIF
C
C..............................................................................
C
	RETURN
	END
