	LOGICAL FUNCTION PROCESS_INPUT
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		9-06-92
C
	IMPLICIT NONE
C
C Utility to compress LITES2 command macros into a more compact form.
C It does this by:
C	removing comments
C	compressing lines
C	shortening LITES2 commands to 4 characters
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:FILENAME.CMN'
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:LCM.CMN'
C
C Functions:
C
	LOGICAL	READ_LINE
C
C Workspace:
	INTEGER		OK			! Function return
C
C .....................................................................
C
	OK = .TRUE.
C
	DO WHILE (OK)
	  OK = READ_LINE(IN_LUN)
	  IF (OK) THEN
	    LINE_COUNT = LINE_COUNT +1
	    CALL PROCESS_BUFFER()
	  ENDIF
	END DO	
C
	CALL FLUSH()				! flush the buffer
C
C .....................................................................
C
9999	PROCESS_INPUT = OK
	RETURN
	END
