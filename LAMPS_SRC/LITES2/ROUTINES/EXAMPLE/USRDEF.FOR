	SUBROUTINE USRDEF(VARNAM_LEN,VARNAM,INDEX,INTVAL,REALVAL,
     &	                     DBLVAL,CHARVAL_LEN,CHARVAL)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	26-Jun-1990
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Example user routine
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
C functions
	INTEGER		LIB$GET_INPUT
	INTEGER		I
C
	PRINT 5
5	FORMAT(/)
C
C ask for all data that this routine requires - only the relevant data
C will be used by LITES2, depending on the type of the variable.
10	CONTINUE
	IF (.NOT.LIB$GET_INPUT(VARNAM,'Enter name of variable to set: ',
     &	      VARNAM_LEN)) THEN
	   PRINT 1000
	   GOTO 999
	ENDIF
C
20	CONTINUE
	IF (.NOT.LIB$GET_INPUT(CHARVAL,
     &	      'Enter subscipt of variable (if a variable array) : ',
     &	      CHARVAL_LEN)) THEN
	   PRINT 1000
	   GOTO 999
	ENDIF
	IF (CHARVAL_LEN.GT.0) READ (CHARVAL(1:CHARVAL_LEN),*,ERR=20) INDEX
C
30	CONTINUE
	IF (.NOT.LIB$GET_INPUT(CHARVAL,'Enter integer value of variable: ',
     &	      CHARVAL_LEN)) THEN
	   PRINT 1000
	   GOTO 999
	ENDIF
	IF (CHARVAL_LEN.GT.0) READ (CHARVAL(1:CHARVAL_LEN),*,ERR=30) INTVAL
C
40	CONTINUE
	IF (.NOT.LIB$GET_INPUT(CHARVAL,'Enter real value of variable: ',
     &	      CHARVAL_LEN)) THEN
	   PRINT 1000
	   GOTO 999
	ENDIF
	IF (CHARVAL_LEN.GT.0) READ (CHARVAL(1:CHARVAL_LEN),*,ERR=40) REALVAL
C
50	CONTINUE
	IF (.NOT.LIB$GET_INPUT(CHARVAL,'Enter double value of variable: ',
     &	      CHARVAL_LEN)) THEN
	   PRINT 1000
	   GOTO 999
	ENDIF
	IF (CHARVAL_LEN.GT.0) READ (CHARVAL(1:CHARVAL_LEN),*,ERR=50) DBLVAL
C
60	CONTINUE
	IF (.NOT.LIB$GET_INPUT(CHARVAL,'Enter character value of variable: ',
     &	      CHARVAL_LEN)) THEN
	   PRINT 1000
	   GOTO 999
	ENDIF
C
999	CONTINUE
	RETURN
1000	FORMAT(/'Error reading from terminal '//)
	END
