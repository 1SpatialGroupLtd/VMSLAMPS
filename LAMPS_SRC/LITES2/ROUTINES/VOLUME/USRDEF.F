	SUBROUTINE USRDEF(VARNAM_LEN,VARNAM,INDEX,INTVAL,REALVAL,
     &	                     DBLVAL,CHARVAL_LEN,CHARVAL)
C
CDEC$	IDENT	'13JN91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Volume calculation routine
C
        IMPLICIT NONE
C
C Arguments
	INTEGER		VARNAM_LEN	! input: maximum size of VARNAM
					! output: size of VARNAM
	CHARACTER*(*)	VARNAM		! variable name to set
	INTEGER		INDEX		! element if VARNAM is array
	INTEGER		INTVAL		! integer value to set
	REAL		REALVAL		! real value to set
	REAL*8		DBLVAL		! double value to set
	INTEGER		CHARVAL_LEN	! input: maximum size of CHARVAL
					! output: size of CHARVAL
	CHARACTER*(*)	CHARVAL		! character value to set
C
	INCLUDE	'USRKEEP.CMN'
C
	VARNAM_LEN = VARL
	VARNAM = VAR
	INDEX = VARSUB
	REALVAL = RVAL
	INTVAL = IVAL
C
	RETURN
	END
