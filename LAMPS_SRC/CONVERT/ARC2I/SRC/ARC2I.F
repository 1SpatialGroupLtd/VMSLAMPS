	PROGRAM	ARC2I
C
CDEC$	IDENT	'19FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	29-Nov-1990
C
C Description:
C
C	Module ARC2I in package CONVERT
C	Conversion utility to read in an ARC/INFO EXPORT data file
C	and write an IFF file.
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'ARC2IMSG.PAR'			! ARC2I messages
	INCLUDE 'LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'($STSDEF)/NOLIST'		! For severity of errors
	INCLUDE	'LSL$CMNLSL:CLD.CMN'		! DCL command interpretation
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSL_STATUS lives here
	INCLUDE	'FILES.CMN'			! ARC2I filenames
	INCLUDE	'COMMANDS.CMN'			! Command line values
	INCLUDE	'GENERAL.CMN'			! General variables
	INCLUDE 'TABLES.CMN'			! For ANNO_TAB initialisation
C
C Functions
C
	LOGICAL		CMDLINE			! Command line interpreter
	LOGICAL		INIT_TAPE		! Initialise magtape
	LOGICAL		CREATE_FILES		! Create TMP and EXPORT files
	LOGICAL		CREATE_IFF		! Create IFF file
	LOGICAL		CLOSE_FILES		! Close EXP, TMP and IFF files
	LOGICAL		PROCESS			! Process EXPORT file
	LOGICAL		NEXT_EXPORT		! Find next EXPORT file on tape
	LOGICAL		RDPAR			! Read parameter file
	LOGICAL		FRTINI			! Open FRT
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	OK			! Routine success
	INTEGER*4	FILE_NUM		! Number of file on tape
	INTEGER*4	I,COUNT			! Counter for select list
	LOGICAL		MESSAGE			! Output tape handling message
C
C------------------------------------------------------------------------------
C
C Initialise LSLLIB
C
	CALL LSL_INIT
C
C Initialise ANNO_TAB
C
	DO 10 I = 1,MAX_ANNO_NUM
	   ANNO_TAB(ANNO_FC,I)  = -1
	   ANNO_TAB(ANNO_LEV,I) = -1
	   ANNO_TAB(ANNO_SYM,I) = -1
10	CONTINUE
C
C Decode the command line
C
	STATUS = CMDLINE()
	IF ( .NOT.STATUS ) GOTO 9999
C
C Now for the FRT if it was requested
C
	IF (HAD_FRT) THEN
	  IF (FRTINI(FRTFILE(1:FRTLEN))) THEN
	      CALL LSL_PUTMSG(ARC2I__ERRRDFRT,FRTFILE(1:FRTLEN))
	      GOTO 9999
	  ENDIF
C
C otherwise set up the standard ACD definitions
C
	ELSE
	   CALL FRT_ACDINI()
	ENDIF
C
C Read the parameter file
C
	IF ( HAD_PAR ) THEN
	   STATUS = RDPAR()
	   IF ( .NOT.STATUS ) GOTO 9999
	ENDIF
C
C Initialise magtape
C
	IF ( MAGTAPE ) THEN 
	   STATUS = INIT_TAPE()
	   IF ( .NOT.STATUS ) GOTO 9999
	ENDIF
C
	MESSAGE = .TRUE.
	FILE_NUM = 1
	COUNT = 1
C
C Find the next file on tape to process
C
100	IF ( HAD_SELECT ) THEN
	   LAST_LINE = .FALSE.
	   IF ( SEL_LIST(COUNT).NE.FILE_NUM ) THEN
	      IF ( MESSAGE ) THEN
	         CALL WRITEF('Looking for start of next EXPORT file.')
	         MESSAGE = .FALSE.
	      ENDIF
	      STATUS = NEXT_EXPORT()
	      IF ( .NOT.STATUS ) THEN
	         IF ( STATUS .EQ. ARC2I__NOFILES ) CALL LSL_PUTMSG( STATUS )
	         GOTO 9999
	      ENDIF
	      FILE_NUM = FILE_NUM + 1
	      GOTO 100
	   ELSE
	      MESSAGE = .TRUE.
	   ENDIF
	ENDIF
C
C Open and create TMP and EXPORT files. This is a copy of the EXPORT IFO section
C
	IF ( MAGTAPE .AND. HAD_LOG ) THEN
	   CALL WRITEF(' ')
	   CALL WRITEF('PROCESSING file %^L%I0 on tape',FILE_NUM)
	ENDIF
C
	STATUS = CREATE_FILES()
	IF ( .NOT.STATUS ) GOTO 9999

C EXPORT and TMP file are now both open for read...
C
	STATUS = CREATE_IFF()
	IF ( .NOT.STATUS ) GOTO 900
C
C IFF file created with all header information...
C
	STATUS = PROCESS()
	IF ( .NOT.STATUS ) GOTO 900
C
C Close the EXPORT, TMP and IFF files
C
900	STATUS = CLOSE_FILES( .NOT.STATUS )	! Delete IFF file if an error
	IF ( .NOT.STATUS ) GOTO 9999
C
CCCC    IF ( HAD_SELECT .AND. COUNT.GE.NUM_SEL ) GOTO 9999
	IF ( HAD_SELECT .AND. COUNT.GE.NUM_SEL ) THEN
	   IF (.NOT.HAD_REWIND) THEN
C
C Leave tape header a beginning of next file
C
	      LAST_LINE = .FALSE.
	      STATUS = NEXT_EXPORT()
	      IF ( .NOT.STATUS ) THEN
	         IF ( STATUS .EQ. ARC2I__NOFILES ) CALL LSL_PUTMSG( STATUS )
	         GOTO 9999
	      ENDIF
	   ENDIF
	   GOTO 9999
	ENDIF
C
	IF ( MAGTAPE ) THEN
	   OK = NEXT_EXPORT()
	   IF ( OK ) THEN			! recover from error and process
	      IF ( EXPBEGIN ) THEN
	         STATUS = LSL__NORMAL		! next EXPORT file on tape.
	         FILE_NUM = FILE_NUM + 1	! Number of next file on tape
	         COUNT = COUNT + 1		! Next file in sel_list
	         GOTO 100
	      ELSE
	         GOTO 9999			! Normal successful completion
	      ENDIF
	   ELSE
	      IF ( OK.EQ.ARC2I__NOFILES	.AND. .NOT.HAD_SELECT ) GOTO 9999
	      STATUS = .FALSE.
	      GOTO 9999				! next_export failed
	   ENDIF
	ENDIF
C
C Reduce severity of status if it is a warning.
C
9999	IF ((LSL_STATUS .AND. STS$M_SEVERITY).EQ.STS$K_WARNING) THEN
	   LSL_STATUS = LSL__NORMAL
	ENDIF
C
	CALL LSL_EXIT
	END
