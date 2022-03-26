	LOGICAL FUNCTION RDADTTAB
C
CDEC$	IDENT	'25FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					St	17-Jan-1991
C
C Description
C
C	Reads an ADT table field which denotes whether the attribute
C	is from the .AAT or the .PAT EXPORT table
C
C	Returns FALSE if something goes wrong with a command line, 
C	TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'ARC2IMSG.PAR'	 	! message definitions
C
C Common Blocks
C
	INCLUDE 'COMMANDS.CMN'		! translation tables
	INCLUDE 'TABLES.CMN'		! translation tables
	INCLUDE	'LSL$CMNFRT:FRTACD.CMN'	! FRT ACD common block
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
C
C Functions called
C
	INTEGER*4	RDCOMM		! read a command
C
C Local Variables
C
	INTEGER*4		 RESULT		! command read result
C
C External declaration
C
	INTEGER*4	TABCMD_CMD_TABLE
	EXTERNAL	TABCMD_CMD_TABLE
C
C------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	RDADTTAB = .TRUE.
C
C Read the command describing which EXPORT table an attribute belongs to
C
	RESULT = RDCOMM(TABCMD_CMD_TABLE)
	IF (RESULT.LE.0) GOTO 9999
C
	GOTO (400,400) RESULT			! and despatch
	CALL LSL_PUTMSG(ARC2I__UNKCMD,CMDNST)	! unknown command
	GOTO 9999
C
C Set the field indicator (AAT table = 1 , PAT table = 2)
C
400	ATTR_TAB(ATTR_EXPTAB,ATTR_PTR) = RESULT
C
C Set flag depending on the value of RESULT
C
	IF (RESULT.EQ.1) THEN
	   HAD_ARCATT = .TRUE.
	ELSEIF (RESULT.EQ.2) THEN
	   HAD_PNTATT = .TRUE.
	ENDIF
C
C and finish
C
	GOTO 9000			! success
C
C Errors
C
9999	RDADTTAB = .FALSE.		! failure
C
C Return
C
9000	RETURN
	END