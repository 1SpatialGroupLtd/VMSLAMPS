	LOGICAL FUNCTION CLOSE_FILES( DEL_IFF )
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Nov-1990
C
C Description:
C
C	Module CLOSE_FILES called by ARC2I in package CONVERT
C	Closes EXPORT, TMP and IFF files
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
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
C
C Arguments
C
	LOGICAL		DEL_IFF			! Delete IFF file
C
C Functions
C
	LOGICAL		FLRCLO			! Close read file
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	STATUS = .TRUE.
C
C Close EXPORT file.
C
	IF ( MAGTAPE ) THEN
C
	ELSE
	   OK = FLRCLO(EXPLUN,IERR)
	   IF ( .NOT.OK ) THEN
	      STATUS = ARC2I__ERRCLO
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	   ENDIF
	ENDIF
C
C Close TMP file.
C
	OK = FLRCLO(TMPLUN,IERR)
	IF ( .NOT.OK ) THEN
	   STATUS = ARC2I__ERRCLO
	   CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	   CALL LSL_ADDMSG( OK )
	   IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	ENDIF
C
C There is no LSLLIB routine to delete a file opened for read. (only write)
C We must therefore use LIB$DELETE_FILE.
C
	CALL LIB$DELETE_FILE(TMPFILE(1:TMPLEN)//';*')
C
C Close IFF file. Delete it if an error
C
	IF ( DEL_IFF ) THEN
	   CALL IFFCDL( IFFLUN,, )		! Close and delete IFF file
	ELSE
	   CALL IFFCLO( IFFLUN,, )		! Close IFF file.
	ENDIF
C
	IF ( HAD_LOG.AND.STATUS ) CALL WRITEF('Files closed.')
C
9000	CLOSE_FILES = STATUS
C
	RETURN
	END