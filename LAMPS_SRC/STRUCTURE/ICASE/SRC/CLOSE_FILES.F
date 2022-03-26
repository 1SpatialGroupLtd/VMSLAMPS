	LOGICAL*4 FUNCTION CLOSE_FILES
C
CDEC$	IDENT	'12SE91'
C
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description
C       Close files. If they are open.
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'	! File LUNs, etc
!	INCLUDE 'LSL$CMNLSL:CLD.CMN'	! DCL command decoding
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! Access to IERCD
C
	INTEGER*4	STATUS
C
C------------------------------------------------------------------------------
C
	STATUS=.TRUE.
C
	IF (IN_OPEN) THEN
	   CALL IFFERM(.FALSE.)		! turn off error messages
	   CALL IFFCLO(INLUN)
	   CALL IFFERM(.TRUE.)		! turn on error messages
	   STATUS = IERCD.EQ.0
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG(STATUS,INFILE(:INLEN))
	      CALL IFFERR
	      GOTO 999
	   ENDIF
	   IN_OPEN=.FALSE.
	ENDIF
C
	IF (OUT_OPEN) THEN
	   CALL IFFERM(.FALSE.)		! turn off error messages
	   CALL IFFCLO(OUTLUN)
	   CALL IFFERM(.TRUE.)		! turn on error messages
	   STATUS = IERCD.EQ.0
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG(STATUS,OUTFILE(:OUTLEN))
	      CALL IFFERR
	      GOTO 999
	   ENDIF
	   OUT_OPEN=.FALSE.
	ENDIF
C
999	CLOSE_FILES=STATUS
	RETURN
	END
