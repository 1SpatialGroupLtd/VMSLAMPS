	LOGICAL FUNCTION RDPAR
CDEC$	IDENT '16AP91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Jon Barber				21-Mar-1991
C	Ripped off from DSTPARLIB
C
C	CONVERT AA2IFF Utility - to read parameter file 
C
C Description
C
C	This function reads the parameter file which relates AA
C	feature codes (and optional curved line flags) to IFF 
C	feature codes
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'	! LSLLIB READSTR definitions
	INCLUDE 'CMN:AA2IFFMSG.PAR'		! AA2IFF messages
C
C Common Blocks
C
	INCLUDE 'CMN:FILE.CMN'
C
C Local Parameters
C
	BYTE		PLING			! comment delimiter
	PARAMETER	(PLING = '!')
C
C Functions called
C
	INTEGER*4	FLROPN		! open file
	INTEGER*4	FLRCLO		! close file
	INTEGER*4	FLRLIN		! read in a line from file
	INTEGER		READSTR
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDINT		! read next integer
	LOGICAL		RDLONG		! read next integer
	LOGICAL		FRTINI		! open FRT file
C
C Local Variables
C
	INTEGER		LEN
	INTEGER*4	RESULT		! command read result
	INTEGER*4	RETCOD		! system error code
	BYTE		SINGCHAR	! character read
	INTEGER		LINE		! line number
	INTEGER*2	FCODE		! FC
	CHARACTER*32	ACODE
	LOGICAL		OK
C
C---------------------------------------------------------------------
C Initialise FRT file for the GT's of the FC's in the parameter file
C
	OK = FRTINI(FRTFILE(1:FRTLEN))
	IF (OK) THEN
	   CALL LSL_PUTMSG(AA2I__ERROPNFRT, FRTFILE(1:FRTLEN))
	   RDPAR = AA2I__ERROPNFRT
	   GOTO 999
	ENDIF
C
C	IF (HAD_LOG) CALL LSL_PUTMSG(AA2I__OPNFRT,FRTFILE(1:FRTLEN))
C
C Open PARAMETER file, read only
C
	RDPAR = FLROPN(PARLUN,PARFILE(1:PARLEN),RETCOD)
C
C If unsuccessful, output message and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(AA2I__ERROPNPAR,PARFILE(1:PARLEN))
	   RDPAR = AA2I__ERROPNPAR
	   GOTO 999
	ENDIF
C
C	IF (HAD_LOG) CALL LSL_PUTMSG(DSTPAR__OPNPAR,PARFIL(1:PARLEN))
C
	LINE = 0
	FC_CNT = 0
C
C Get a line
C
8000	CONTINUE
	LINE = LINE + 1
C
	RDPAR = FLRLIN(,,,RETCOD)
C
	IF (RDPAR.EQ.LSL__EOF) THEN
	   RDPAR = LSL__NORMAL		! not an error
	   GOTO 9998
	ENDIF
C
C If unsuccessful, output message, and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(AA2I__ERRRDPAR,LINE)
	   CALL LSL_ADDMSG(RDPAR)
	   GOTO 9998
	ENDIF
C
C Now reset the decoding pointer to the start of the line
C
	CALL BSLN
C
C Check for a comment delimiter - ignore an empty line
C
	IF (RDCHS(SINGCHAR)) GOTO 8000
	IF (SINGCHAR.EQ.PLING) THEN
	   GOTO 8000			! ignore line
	ELSE
	   CALL BSCH			! unread non-pling
	ENDIF
C
C Read AA code
C
	LEN = READSTR(ACODE,,ON_SPACE)
C
	OK = RDINT(FCODE)
	IF (OK .OR. FCODE.LT.0) THEN
	   CALL LSL_PUTMSG(AA2I__ERRRDPAR, LINE)
	   GOTO 8000
	ENDIF
C
C Get 'C' if present
C
C	OK = RDCHS(SINGCHAR)
C
C If char found, check for 'c' OR 'C'
C
C	IF (.NOT.OK .AND. SINGCHAR.NE.'C' .AND. SINGCHAR.NE.'c') THEN
C	   CALL LSL_PUTMSG(AA2I__ERRRDPAR, LINE)
C	   GOTO 8000
C	ENDIF
C
C C found for curved line
C
	FC_CNT = FC_CNT + 1
C
	AA_LEN(FC_CNT)  = LEN
	AA_CODE(FC_CNT) = ACODE(1:LEN)
	IFF_FC(FC_CNT)  = FCODE
C
C	IF (OK) THEN			! no char found
C	   HAD_C(FC_CNT) = .FALSE.
C	ELSE				! found 'c' or 'C'
C	   HAD_C(FC_CNT) = .TRUE.
C	ENDIF
C
	GOTO 8000
C
C Close the PARAMETER file
C
9998	CONTINUE
C
	IF (FC_CNT.LE.0) THEN
	   CALL LSL_PUTMSG(AA2I__NOPARFC)
	   RDPAR = AA2I__NOPARFC
	   GOTO 1000
	ENDIF
C
C report statistics
C
C	IF (HAD_LOG) THEN
C	   CALL LSL_PUTMSG(AA2I__FCFND,FC_CNT)
C	ENDIF
C
1000	CALL FLRCLO(PARLUN,RETCOD)
C
999	RETURN
	END
C
