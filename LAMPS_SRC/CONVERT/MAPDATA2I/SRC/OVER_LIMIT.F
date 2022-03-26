	LOGICAL FUNCTION OVER_LIMIT(INDEX)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C Description:
C       Each time we increment an index into a points array (be it PTS,
C       LINE_IN or LINE_OUT) we should test it won't run of the end of the
C       array. This test is therefore done often and warranted it's own
C       routine. And here it is....
C
C
	IMPLICIT	NONE
C
C Arguments
C
	INTEGER*4	INDEX
C
C Parameters
C
	INCLUDE 'LSL$CMNCOORD:MAXPTS.PAR'
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C------------------------------------------------------------------------------
C
	OVER_LIMIT = .FALSE.
C
	IF (INDEX.GT.MAXPTS) THEN
	   CALL LSL_PUTMSG(MD2I__OUTBUFFULL,MAXPTS)
	   OVER_LIMIT = .TRUE.
	ENDIF
C
C and that's it
C
	RETURN
	END
C
