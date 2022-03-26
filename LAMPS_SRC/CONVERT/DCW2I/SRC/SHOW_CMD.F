	LOGICAL FUNCTION SHOW_CMD()
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	19-May-1992
C
C Description:
C
C	Function to show selections
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
C
C Functions
C
	LOGICAL 	RDCOMM  	! read command from line
C
C Command table
C
	EXTERNAL	SHOW_CMD_TABLE
	INTEGER		SHOW_CMD_TABLE
C
C Local workspace
C
	INTEGER*4	CMD     	! decoded command number
C
C ......................................................................
C
	SHOW_CMD=.TRUE.			! assume success
C
	CMD=RDCOMM(SHOW_CMD_TABLE)	! get command
C
C Branch to deal with each sub command
C
	GOTO (
     &		10,	! nothing/error
     &		20,	! ALL
     &		30,	! ENABLE
     &		40	! SELECTIONS
     &			), CMD+1
C
C command number out of range
C
	SHOW_CMD=.FALSE.
	GOTO 50
C
C ......................................................................
C Error
10	CALL WRITEF(' ')
	CALL WRITEF('Available SHOW command qualifiers are:')
	CALL WRITEF(' ')
	CALL WRITEF('ALL  ENABLE  SELECTIONS')
	CALL WRITEF(' ')
	SHOW_CMD=.FALSE.
	GOTO 50
C
C ......................................................................
C SHOW ALL command
C
20	IF (HAD_DEVICE) THEN
	   CALL WRITEF ('Device name      : %S',DEVICENAM(1:DEVICELEN))
	ELSE
	   CALL WRITEF ('Device name      : UNDEFINED')
	ENDIF
	IF (HAD_TARGET) THEN
	   CALL WRITEF ('Target directory : %S',TARGETNAM(1:TARGETLEN))
	ELSE
	   CALL WRITEF ('Target directory : UNDEFINED')
	ENDIF
	CALL WRITEF
	CALL WRITEF('Text gap tol  : %^F%F0.3',TEXTGAP)
	CALL WRITEF
	CALL SHOW_ENA(1)
	CALL SHOW_SEL(1)
	GOTO 50
C
C ......................................................................
C SHOW ENABLE command
C
30	CALL SHOW_ENA(1)
	GOTO 50
C
C ......................................................................
C SHOW SELECTIONS command
C
40	CALL SHOW_SEL(1)
	GOTO 50
C
C ......................................................................
C
50	RETURN
	END
