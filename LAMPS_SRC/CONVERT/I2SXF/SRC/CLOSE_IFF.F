        LOGICAL FUNCTION CLOSE_IFF
C
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Close IFF file
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'($STSDEF)/NOLIST'
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Close the input file 
C
	CALL IFFCLO(IFFLUN)
C
C Output an appropriate message
C
	IF ((IERCD .NE. 0) .OR. (IERNM .NE. 1)) THEN
	   CALL LSL_PUTMSG(I2SXF__IFFCLOERR)
	ELSE IF (HAD_LOG) THEN
	   IF (LSL_STATUS .OR. 
     &	      ((LSL_STATUS .AND. STS$M_SEVERITY) .EQ. STS$K_WARNING)) 
     &	      THEN
	      CALL LSL_PUTMSG(I2SXF__IFFCLOSED)
	   ELSE
	      CALL LSL_ADDMSG(I2SXF__IFFCLOSED)
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
