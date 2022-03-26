	INTEGER*4 FUNCTION GET_TMP_LINE( NO_EOF_MSG )
C
CDEC$	IDENT	'09DE91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Nov-1990
C
C Description:
C
C	Module GET_TMP_LINE called by ARC2I in package CONVERT
C	Reads a line from the TMP file into TXTBUF
C	This is put into its own routine to save duplicating code
C	The EOF message can be disabled by calling the function with .TRUE.
C	
C-------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
C
C Arguments
C
	LOGICAL		NO_EOF_MSG		! disable EOF message
C
C Functions
C
	LOGICAL		FLRLIN			! Read a record
	LOGICAL		FLRSEL			! Select LUN
	LOGICAL		HAVE_I_AN_ARG		! Test for presencwe of argument
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
	LOGICAL		NO_MSG			! no EOF message
C
C-------------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
C Most of the time the function will be called with no argument. Therefore
C we need to check if it's missing and assign FALSE to NO_MSG
C
	NO_MSG = .FALSE.
	IF (HAVE_I_AN_ARG(1)) THEN
	   IF ( NO_EOF_MSG ) NO_MSG = .TRUE.
	ENDIF
C
	CALL FLRSEL(TMPLUN)
C
	OK = FLRLIN(,,,IERR)
	IF ( .NOT.OK ) THEN
	   IF ( OK.EQ.LSL__EOF ) THEN
	      IF ( .NOT.NO_MSG ) CALL LSL_PUTMSG( ARC2I__UNEXPEOF )
	   ELSE
	      CALL LSL_PUTMSG( ARC2I__RDLNTMP )
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSREAD ) CALL LSL_ADDMSG( IERR )
	   ENDIF
	   STATUS = OK
	ENDIF
	CALL BSLN
C
999	GET_TMP_LINE = STATUS
C
	RETURN
	END