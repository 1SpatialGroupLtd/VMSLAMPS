C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-06-28 13:35:06.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
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
