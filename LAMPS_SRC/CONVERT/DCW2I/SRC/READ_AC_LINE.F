	LOGICAL FUNCTION READ_AC_LINE(LINE)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	9-June-1992
C
C Description:
C
C	Function to read a line of the attribute code file and store it away
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
C
C Functions
C
	LOGICAL		STORE_AC_INFO	! stuff the data away
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDLONG		! read long int
	INTEGER*4	READSTR
C
C Local workspace
C
	INTEGER*4	LEN
	INTEGER*4	LINE
	INTEGER*4	CODE
	INTEGER*4	FCODE
	INTEGER*4	ACODE
	LOGICAL*4	OK
	CHARACTER*40	TMP
	CHARACTER*40	ACNAME
	CHARACTER*1	ACTYPE
C
C ......................................................................
C
	READ_AC_LINE =.TRUE.		! assume success
C
C Read the Attribute Code
C
	IF (RDLONG(CODE)) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTREAD,'AC code',LINE)
	   GOTO 500
	ENDIF
	IF (CODE.LT.0 .OR. CODE.GT.32767) THEN
	   CALL LSL_PUTMSG(DCW2I__OUTOFRANGE,'Attribute code',CODE,LINE)
	   GOTO 500
	ENDIF
	ACODE = CODE
C
C Read the Feature Code
C
	IF (RDLONG(CODE)) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTREAD,'feature code',LINE)
	   GOTO 500
	ENDIF
	IF (CODE.LT.0 .OR. CODE.GT.32767) THEN
	   CALL LSL_PUTMSG(DCW2I__OUTOFRANGE,'Feature code',CODE,LINE)
	   GOTO 500
	ENDIF
	FCODE = CODE
C
C Read attribute name
C
	LEN = READSTR(ACNAME,,ON_SPACE,,)
	IF (LEN.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTREAD,'attribute name',LINE)
	   GOTO 500
	ENDIF
	LEN=LEN+1
	ACNAME(LEN:LEN)=CHAR(0)
	CALL STR$UPCASE(ACNAME,ACNAME)
C
C Read attribute type
C
	LEN = READSTR(TMP,,ON_SPACE,,)
	IF (LEN.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTREAD,'attribute type',LINE)
	   GOTO 500
	ENDIF
	IF (LEN.GT.1 .OR.
     &	   (TMP(1:1).NE.'I'.AND.TMP(1:1).NE.'i'.AND.
     &	    TMP(1:1).NE.'D'.AND.TMP(1:1).NE.'d'.AND.
     &	    TMP(1:1).NE.'T'.AND.TMP(1:1).NE.'t')) THEN
	   CALL LSL_PUTMSG(DCW2I__ACTYPE,LINE)
	   GOTO 500
	ENDIF
	CALL STR$UPCASE(TMP,TMP)
	ACTYPE = TMP(1:1)
C
C Store it away in the linked list
C
	OK = STORE_AC_INFO(%REF(ACODE),
     &	                   %REF(FCODE),
     &	                   %REF(ACNAME),
     &	                   %REF(ICHAR(ACTYPE(1:1))))
C
C OK, get next line 
C
	GOTO 999
C
C ......................................................................
C
500	READ_AC_LINE = .FALSE.
999	RETURN
	END
