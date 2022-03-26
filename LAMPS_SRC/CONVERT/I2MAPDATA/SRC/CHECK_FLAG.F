	SUBROUTINE CHECK_FLAG(FLAG,IS_CURVE)
C
CDEC$	IDENT	'11OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C	CONVERT I2MAPDATA Utility - Check flag
C
C Description
C
C	Checks the validity of a curve or priority flag
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'	! for messages
	INCLUDE	'CMN:GEN.PAR'		! for UNSET_FLAG
C
C Common blocks
C
	INCLUDE	'CMN:IFF.CMN'		! IFF stuff
C
C Arguments
C
	INTEGER*4	FLAG		! the curve or priority as an int
	LOGICAL		IS_CURVE	! Are we checking the CURVE flag?
C
C------------------------------------------------------------------------------
C
C Checking a CURVE flag
C
 	IF (IS_CURVE) THEN
	   IF (FLAG.EQ.IFF_ABSENT) FLAG = UNSET_FLAG
C
C Should be 'C   ' or '    '
C
	   IF (FLAG.NE.'C   ' .AND.FLAG.NE.'I   '.AND.FLAG.NE.UNSET_FLAG) THEN
	      CALL LSL_PUTMSG(I2MD__UNKCURFLG,POINTNUM,FSN)
	      FLAG = UNSET_FLAG
	   ENDIF
	ELSE
C
C Check PRIORITY flag
C
	   IF (FLAG.EQ.IFF_ABSENT) FLAG = UNSET_FLAG
C
C Should be 'H   ', 'L   ' or '    '
C
	   IF (FLAG.NE.'H   '.AND.FLAG.NE.'L   '.AND.FLAG.NE.UNSET_FLAG) THEN
	      CALL LSL_PUTMSG(I2MD__UNKPRIOFLG,POINTNUM,FSN)
	      FLAG = UNSET_FLAG
	   ENDIF
	ENDIF
C
C Return
C
	RETURN
	END
