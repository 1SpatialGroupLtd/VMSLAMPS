	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'25SE91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description:
C	Open input, output and FRT files
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
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'	! FRT command block
C
	LOGICAL*4	FRTINI		! Initialise reading from FRT
	LOGICAL*4	FAILED		! Reading FRT failed
C
C------------------------------------------------------------------------------
C
C Open FRT file
C
	IF (HAD_FRT) THEN
	   FAILED = FRTINI(FRTFILE(:FRTLEN))		!open the FRT file
	   IF (FAILED) THEN
	      CALL LSL_PUTMSG(ICASE__ERRRDFRT,FRTFILE(:FRTLEN) )
	      CALL LSL_ADDMSG( FAILED )
	      IN_OPEN = .FALSE.           		! force routine to fail
	      OUT_OPEN = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
C open input file read only
C
	CALL IFFERM(.FALSE.)              ! turn off error messages
	CALL IFFOPN(INLUN,INFILE,0)
	CALL IFFERM(.TRUE.)               ! turn on error messages
	IN_OPEN = IERCD.EQ.0
	IF (.NOT.IN_OPEN) THEN
	   CALL LSL_PUTMSG(ICASE__ERROPN,INFILE(1:INLEN))
	ENDIF
C
C open output file
C
	CALL IFFERM(.FALSE.)              ! turn off error messages
	CALL IFFOPN(OUTLUN,OUTFILE)
	CALL IFFERM(.TRUE.)               ! turn on error messages
	OUT_OPEN = IERCD.EQ.0
	IF (.NOT.OUT_OPEN) THEN
	   CALL LSL_PUTMSG(ICASE__ERROPN,OUTFILE(1:OUTLEN))
	ELSE
	   IF (IN_OPEN) CALL IFFSEL(INLUN)
	ENDIF
C
999	OPEN_FILES = IN_OPEN .AND. OUT_OPEN
C
	RETURN
	END
