        LOGICAL FUNCTION CLOSE_IFF
C
CDEC$	IDENT   '02JL91'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	15-Jan-1990
C
C	CONVERT SIF2IFF Utility - Close IFF file
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE '($STSDEF)/NOLIST'
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	! message definitions
	INCLUDE 'CMN:LUN.PAR'		! logical unit numbers
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'		! filenames
	INCLUDE 'CMN:FLAGS.CMN'		! flag variables
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF map data
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
C
C Local Variables
C
	LOGICAL		IFF_ERR		! had IFF error ?
C
C See if we had an IFF error
C
	IFF_ERR = ((IERCD .NE. 0) .OR. (IERNM .NE. 1)) 
C
C Close the output file 
C
	IF (LSL_STATUS) THEN
	   CALL IFFCLO(IFFLUN)
	ELSEIF (DONE_START_MAP) THEN
	   CALL IFFCLO(IFFLUN,LSL_STATUS)
	ELSE
	   CALL IFFCDL(IFFLUN)
	ENDIF
C
C Output an appropriate message
C
	IF (((IERCD .NE. 0) .OR. (IERNM .NE. 1)) .AND. 
     &	    .NOT. IFF_ERR) THEN
	   CALL LSL_PUTMSG(SIF2IFF__IFFCLOERR)
	ELSE 
	   IF (DONE_START_MAP) THEN
	      IF (LSL_STATUS .OR. 
     &	         ((LSL_STATUS .AND. STS$M_SEVERITY) .EQ. STS$K_WARNING))
     &	         THEN
	         IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__IFFCLOSED)
	      ELSE
	         IF (HAD_LOG) CALL LSL_ADDMSG(SIF2IFF__IFFCLOSED)
	      ENDIF
	   ELSE
	      CALL LSL_ADDMSG(SIF2IFF__IFFDELETED)
	   ENDIF
	ENDIF
C
C Assign function value
C
	CLOSE_IFF = ((IERCD .EQ. 0) .AND. (IERNM .EQ. 1))
C
C Return
C
	RETURN
        END
