	LOGICAL FUNCTION GETATTINFO(ACCODE,PTRTOTEXT,DATATYPE)
C
CDEC$	IDENT	'19JA94'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created							ST  18-Feb-1991
C
CMOD    When determining the width of an attribute name by	ST  19-Jan-1994
C	searching the name for a space, the initial length
C       should be set to the maximum, 16. Mod 1333.
C
C Description:
C
C	Function GETATTINFO called by I2ARC in package CONVERT
C       It takes an attribute code and looks for it in the ACD common block

C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:I2ARCMSG.PAR'		! I2ARC messages
C
C Common blocks
C
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'		! FRT data
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! ACD data
	INCLUDE	'HERE:TABLES.CMN'		! Attribute data
C
	INTEGER*2	ACCODE
	INTEGER*4	PTRTOTEXT
	INTEGER*4	DATATYPE
C
C Functions called
C
	LOGICAL		ACDFND
C
C Local Variables
C
	INTEGER*4	LINE		! count line numbers
	INTEGER*4	I		! counter
	INTEGER*4	J		! counter
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	LOGICAL		GOT_IT		! got FC in FC-layer table ?
	BYTE		CH		! character read
	INTEGER*4	TLEN		! actual string length
	INTEGER*2	TEXT_LEN	! length field
	INTEGER*4	TEXT_DESCR(2)	! descriptor
	BYTE		TEXT(80)	! the text buffer
	CHARACTER*80	TEXTSTR		! the text as a string

	EQUIVALENCE(TEXT_DESCR(1),TEXT_LEN)
	EQUIVALENCE(TEXT,TEXTSTR)
C
C-------------------------------------------------------------------------------
C
C Assume that everything goes well
C
	GETATTINFO = .TRUE.
C
C Set up fake string
C
	TEXT_DESCR(1) = 0
	TEXT_DESCR(2) = %LOC(TEXT)
	TEXT_LEN = 80
C
	DO 5 I = 1,TEXT_LEN
	   TEXT(I)=0
5	CONTINUE
C
	IF (.NOT.ACDFND(ACCODE)) THEN
	   DATATYPE = ACD_DATA_TYPE
	   IF (ACCODE.LT.1000) THEN
C
C For default attributes the EXPORT name will have to be the ACD group name
C
	      IF (.NOT.ACDFND(ACCODE)) THEN
	         TEXTSTR(1:ACD_NAME_LEN) = ACD_NAME(1:ACD_NAME_LEN)
	         PTRTOTEXT = TEXT_DESCR(2)
	         GOTO 9000
	      ENDIF
	   ELSE
C
C Find EXPORT attribute name in the list created from the parameter file.
C
	      DO 10 I = 1,MAX_ATTR_NUM
	         IF (ACCODE.EQ.ATTR_TAB(1,I)) THEN
		    TLEN = 16	! max size for ATTR_NAM
	            DO 20 J = 1,20
	               IF (ATTR_NAM(I)(J:J).EQ.' ') THEN
	                  TLEN = J-1
	                  GOTO 30
		       ENDIF
20	            CONTINUE
30	            TEXTSTR(1:TLEN) = ATTR_NAM(I)(1:TLEN) 
	            PTRTOTEXT = TEXT_DESCR(2)
	            GOTO 9000
	         ENDIF
10	      CONTINUE
	   ENDIF
	ENDIF
C
C Failure to find attribute name...
C
	IF (.NOT.ACDFND(ACCODE)) THEN
C
C Give error message using ACD group name
C
	   CALL LSL_PUTMSG( I2ARC__MISSATTDEF,ACCODE,ACD_NAME(1:ACD_NAME_LEN))
	ENDIF
C
	GETATTINFO = .FALSE.
C
C Return
C
9000	RETURN
	END
