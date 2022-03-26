	LOGICAL FUNCTION CHECK_GT(LINEFC,FC,GT)
C
CDEC$	IDENT	'25SE91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description
C	Routine called check GT of feature in FRT is what was expected.
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'		! FRT command block
C
C Arguments
C
	INTEGER*2	LINEFC,FC,GT		! The FC and GT to check
C
C Functions called
C
	LOGICAL*4	FRTFND			! Find entry in FRT
C
C Local variables
C
	LOGICAL*4	STATUS			! Success/failure of routine
C
C-----------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
	IF (FRTFND(FC)) THEN 		! generates its own message
	   STATUS=.FALSE.
	ELSE
	   IF (FRTGT.NE.GT) THEN
	      STATUS=ICASE__WRONGGT
	      CALL LSL_PUTMSG(STATUS,LINEFC)
	   ENDIF
	ENDIF
C
	CHECK_GT = STATUS
	RETURN
	END
