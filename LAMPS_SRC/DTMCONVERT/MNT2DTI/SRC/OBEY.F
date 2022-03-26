	LOGICAL FUNCTION OBEY
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	23-Jul-1990
C
C Description:
C
C	Module OBEY called by MNT2DTI in package DTMCONVERT
C	Command line interpreter for MNT2DTI
C
C	Command syntax:
C
C	MNT2DTI[/LOG][/VALIDATE] Input MNT-file Output DTI-file
C
        IMPLICIT NONE
C
C Included Parameter Files
C
C
C Messages
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$MNT2DTI:MNT2DTIMSG.PAR'	! MNT2DTI messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'LSL$MNT2DTI:FILE.CMN'      	! MNT2DTI filenames
	INCLUDE	'LSL$MNT2DTI:COMMANDS.CMN'  	! MNT2DTI command qualifiers
C
C External functions
C
	EXTERNAL	MNT2DTI_CLD		! Command language definition
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
	LOGICAL		DCL_INT			! Get an integer parameter
	LOGICAL		TTWSTR			! Write to terminal
	LOGICAL		PARFILN			! Parse filename
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	CHARACTER*15	MNTPARSE		! Name to parse MNT against
	CHARACTER*14	DTIPARSE		! Name to parse DTI against
	LOGICAL 	HAD_QUAL		! True if qualifier present
	LOGICAL 	NEGATED			! True if qualifier negated
	INTEGER 	PRESENT			! True if qualifier detected
	INTEGER		ERROR			! Error flag
	CHARACTER*(C_MAX_SIZ)	TMPFILE		! Temporary filename
	INTEGER		LENGTH			! Temporary filename length
C
	DATA		MNTPARSE  / 'SYS$DISK:.MNT;0' / 
	DATA		DTIPARSE  / 'LSL$DTI:.DTI;0' /
C
C-------------------------------------------------------------------------------
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'MNT2DTI',.FALSE.,MNT2DTI_CLD,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Get the MNT input filename (P1) 
C
	STATUS = DCL_FILE( 'MNT_FILESPEC',' ',ABSENT,.TRUE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store MNT file length and name
C
	MNTLEN  = FIL_LEN(1)
	MNTFILE = FILARY(1)(1:MNTLEN)
C
C Check if MNT file-spec is a valid filename or possibly just a magtape device
C
	IF ( .NOT.HAD_DIR .AND. 		! No directory
     &       .NOT.HAD_NAM .AND.  		! No filename
     &	     .NOT.HAD_EXT .AND.			! No extension
     &       .NOT.HAD_VER      			! No version
     &	   ) THEN				! Possibly a magtape device
	   MAGTAPE = .TRUE.
	ELSE					! Otherwise a disk file
C
C Try parsing the MNT file-spec against SYS$DISK:.MNT;0
C
	   STATUS = PARFILN( TMPFILE,LENGTH,MNTFILE,MNTPARSE,.TRUE. )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( MNT2DTI__INVFILNAM,MNTFILE(1:MNTLEN) )
	   ELSE
	      MNTFILE = TMPFILE
	      MNTLEN  = LENGTH
	   ENDIF
	ENDIF
C
C Get the DTI output filename (P2)
C
	STATUS = DCL_FILE( 'DTI_FILESPEC',DTIPARSE,ABSENT,.TRUE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store DTI file length and name
C
	DTILEN  = FIL_LEN(1)
	DTIFILE = FILARY(1)(1:DTILEN)
C
C Decode all the qualifiers for the command line:
C
C	/LOG   -  Display logging information
C
	STATUS = DCL_QUAL('LOG',LOG,PRESENT,NEGATED,.TRUE.)
	IF ( .NOT.STATUS ) GOTO 999
C
C	/VALIDATE   -  Validate elevation data against range
C
	STATUS = DCL_QUAL('VALIDATE',VALIDATE,PRESENT,NEGATED,.TRUE.)
	IF ( .NOT.STATUS ) GOTO 999
C
C	/HEADER   -  Command to skip tape header blocks if present
C
	STATUS = DCL_QUAL('HEADER',HEADER,PRESENT,NEGATED,.TRUE.)
	IF ( .NOT.STATUS ) GOTO 999
C
C	/BLOCKSIZE=[4096]   -  Set physical tape blocksize
C
	STATUS = DCL_QUAL('BLOCKSIZE',HAD_QUAL,PRESENT,NEGATED,.TRUE.)
	IF ( .NOT.STATUS ) GOTO 999
	IF (HAD_QUAL) THEN
	   STATUS = DCL_INT( 'BLOCKSIZE',ERROR )
	   IF ( .NOT.STATUS ) GOTO 999
	BLKSIZ = IARRAY(1)
	ENDIF
C
C	/SELECT=[all]   -  Select file sequence from tape
C
	STATUS = DCL_QUAL('SELECT',HAD_QUAL,PRESENT,NEGATED,.TRUE.)
	IF ( .NOT.STATUS ) GOTO 999
	IF (HAD_QUAL) THEN
	   STATUS = DCL_INT( 'SELECT',ERROR )
	   IF ( .NOT.STATUS ) GOTO 999
	   SELECT = .TRUE.
	ENDIF
C
C All done
C
999	CONTINUE
	OBEY = STATUS				! Return status to caller
C
	RETURN
	END
