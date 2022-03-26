	LOGICAL FUNCTION OPEN_FILES
C
CDEC$	IDENT	'11DE91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	11-Dec-1991
C
C Description:
C	Open input IFF and temporary work files
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! For access to IERCD
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! Needed for FILES.CMN
	INCLUDE 'FILES.CMN'			! File LUNs, etc
	INCLUDE 'GENERAL.CMN'			! General variables
	INCLUDE 'COMMANDS.CMN'			! Command line switches
C
C Functions
C
	INTEGER*4	FLWOPB			! open file for block write
C
C Local variables
C
	INTEGER*4	IERR
C
C------------------------------------------------------------------------------
C
C Open input IFF file read only
C
	CALL IFFERM(.FALSE.)              ! turn off error messages
	CALL IFFOPN(IFFLUN,IFFFILE,0)
	CALL IFFERM(.TRUE.)               ! turn on error messages
	IFF_OPEN = IERCD.EQ.0
	IF (.NOT.IFF_OPEN) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERROPN,IFFFILE(1:IFFLEN))
	   CALL IFFERR
	   GOTO 999
	ENDIF
	IF (HAD_LOG) CALL WRITEF('IFF file       : %S',IFFFILE(1:IFFLEN))
C
C Open TMP file
C
	TMP_OPEN = FLWOPB(TMPLUN,TMPFILE(1:TMPLEN),IERR)
	IF (.NOT.TMP_OPEN) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERROPNTMP)
	   GOTO 999
	ENDIF
C
999	OPEN_FILES = IFF_OPEN .AND. TMP_OPEN
C
	RETURN
	END




