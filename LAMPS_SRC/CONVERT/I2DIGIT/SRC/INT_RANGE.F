	INTEGER*4 FUNCTION INT_RANGE(N,RMIN,RMAX,EXCEPTION,ROW,COL)
C
CDEC$	IDENT	'10DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	10-Dec-1991
C
C Description:
C       A routine to check that the values held in a particular entry
C       of the parameter file is in the correct range. In most cased the
C       value can have an exception. (ie -1 means undefined).
C
        IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'GENERAL.CMN'			! for UNDEFINED
C
	INTEGER*4	ROW,COL
	INTEGER*4	N,RMIN,RMAX,EXCEPTION
C
C------------------------------------------------------------------------------
C
	INT_RANGE = (N.EQ.EXCEPTION.OR.
     &		     N.EQ.UNDEFINED.OR.
     &		    (N.GE.RMIN.AND.N.LE.RMAX))
C
	IF (.NOT.INT_RANGE) CALL LSL_PUTMSG(I2DIGIT__ERRINPAR,COL,ROW)
C
	RETURN
	END
