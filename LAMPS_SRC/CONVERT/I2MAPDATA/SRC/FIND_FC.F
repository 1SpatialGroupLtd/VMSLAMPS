	LOGICAL FUNCTION FIND_FC(WHICH_FC)
C
CDEC$	IDENT	'21SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	20-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Find FC in CODE table
C
C Description
C
C	Finds a feature code in the CODE table.
C
C	Returns .TRUE. if the FC is present, .FALSE. otherwise.
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
C
C Arguments
C
	INTEGER*4	WHICH_FC		! feature code
C
C Local variables
C
	INTEGER*4	I			! counter
C
C Assume success
C
	FIND_FC = .TRUE.
C
C Initialise current FC index
C
	FC_IND = 0
C
C Check if we have any entries
C
	IF ( FC_NUM.LE.0 ) GOTO 9999
C
C Now search the CODE table for the FC
C
	I = 0
C
 100	I = I + 1
	IF ( FC_TAB(FC_FC,I).NE.WHICH_FC .AND. I.LT.FC_NUM ) GOTO 100
C
C Check if the FC is present, and if so set the current index
C
	IF ( FC_TAB(FC_FC,I).NE.WHICH_FC ) GOTO 9999
	FC_IND = I
C
	GOTO 10000
C
C Failure
C
9999	FIND_FC = .FALSE.
C
C Return
C
10000	RETURN
	END
