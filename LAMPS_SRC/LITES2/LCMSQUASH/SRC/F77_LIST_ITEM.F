	SUBROUTINE F77_LIST_ITEM(INSTR)
C
CDEC$	IDENT	'05OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		14-06-92
C
	IMPLICIT NONE
C
C Always output a message to the listing file.
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Arguments
	CHARACTER*(*)	INSTR
C
C Functions
C
C..............................................................................
C
	IF (LIST) THEN					!is there a list file?
	  CALL EXPAND('%T%T%S',INSTR)			!make up warning
	  CALL FLWSEL(LIST_LUN)				! select it
	  CALL FLWLIN()					! output data
	ENDIF
C
C..............................................................................
C
	RETURN
	END
