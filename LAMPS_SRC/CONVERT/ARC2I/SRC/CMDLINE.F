C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-04-02 18:31:34.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	LOGICAL FUNCTION CMDLINE
C
CDEC$	IDENT	'02AP93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	20-Nov-1990
C
C Description:
C
C	Module CMDLINE called by ARC2I in package CONVERT
C	Command line interpreter for ARC2I
C
C	Command syntax:
C
C	ARC2I [/ARC_ID=keyword]
C	      [/FRT]
C	      [/LOG]
C             [/ID_TO_FC]
C             [/REWIND]
C	      [/BLOCKSIZE=integer]
C	      [/PARAMETER=file]
C	      [/POINT_ID=keyword]
C	      [/SCALE=integer]
C	      [/SELECT=integer_list]
C             [/VERBOSE]
C	      Input-EXPORT-file Output-IFF-file
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'HERE:FILES.CMN'      		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'	  	! ARC2I command qualifiers
	INCLUDE	'HERE:GENERAL.CMN'	  	! General variables
C
C External functions
C
	INTEGER		ARC2I_CLD		! Command language definition
	EXTERNAL	ARC2I_CLD
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
	LOGICAL		DCL_INT			! Get an integer parameter
	LOGICAL		TTWSTR			! Write to terminal
	LOGICAL		PARFILN			! Parse filename
	INTEGER*4	LIB$FIND_FILE		! See if file exists
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL 	HAD_QUAL		! True if qualifier present
	LOGICAL 	NEGATED			! True if qualifier negated
	INTEGER*4 	PRESENT			! True if qualifier detected
	INTEGER*4	ERROR			! Error flag
	CHARACTER*15	EXPPARSE		! EXPORT default
	CHARACTER*13	IFFPARSE		! IFF default
	CHARACTER*(C_MAX_SIZ)	TESTFILE	! Temporary filename
	INTEGER*4	TESTLEN			! Temporary filename length
	INTEGER*4	I			! Loop count
	INTEGER*4	CONTEXT			! context for LIB$FIND_FILE
	INTEGER*4	IERR			! error code
	CHARACTER*(C_MAX_SIZ)	COPYNAM		! copy of name part of file
	INTEGER*4	COPYLEN			! length of the above
	LOGICAL 	ID_USER,ID_INT		! temporary flags for /ARC_ID
C
	DATA		EXPPARSE  / 'SYS$DISK:.E00;0' / 
	DATA		IFFPARSE  / 'LSL$IF:.IFF' /
C
C *****************************************************************************
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'ARC2I',		! command verb
     &	                       .FALSE.,		! don't burst parameter lists
     &	                       ARC2I_CLD,	! our CLD file
     &                         .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999
C
C *****************************************************************************
C Get the EXPORT input filename
C
	STATUS = DCL_FILE( 'EXP_FILESPEC',	! qualifier name
     &	                   ' ',			! default filename
     &		            ABSENT,		! out - was name absent?
     &		            .FALSE.,		! only one file to process
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999
C
C Store EXPORT file length and name
C
	EXPLEN  = FIL_LEN(1)
	EXPFILE = FILARY(1)(1:EXPLEN)
C
C Check if EXP file-spec is a valid filename or possibly just a magtape device
C
	IF ( .NOT.HAD_DIR .AND. 		! No directory
     &       .NOT.HAD_NAM .AND.  		! No filename
     &	     .NOT.HAD_EXT .AND.			! No extension
     &       .NOT.HAD_VER      			! No version
     &	   ) THEN				! Possibly a magtape device
	   MAGTAPE = .TRUE.
	ELSE					! Otherwise a disk file
C
C Try parsing the EXP file-spec against SYS$DISK:.E00;0
C
	   MAGTAPE = .FALSE.
	   STATUS = PARFILN( TESTFILE,TESTLEN,EXPFILE,EXPPARSE,.TRUE. )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( ARC2I__INVFILNAM,EXPFILE(1:EXPLEN) )
	   ELSE
	      EXPLEN  = TESTLEN
	      EXPFILE(1:EXPLEN) = TESTFILE(1:TESTLEN)
C
C Save a copy of the name part for the output file
C
	      COPYLEN = LEN_NAM
	      COPYNAM(1:COPYLEN) = STR_NAM(1:LEN_NAM)
	   ENDIF
	ENDIF
C
C *****************************************************************************
C Get the IFF output filename
C
	STATUS = DCL_FILE( 'IFF_FILESPEC',	! qualifier name
     &	                    IFFPARSE,		! default filename
     &		            ABSENT,		! out - was name absent?
     &		            .FALSE.,		! only one file to process
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name. Magtape names will be fetched in GET_FILENAME
C
	HAD_OUTPUT = .NOT.ABSENT
C
	IF ( HAD_OUTPUT ) THEN
C
C Save a copy of the name part of the output file
C
	   COPYLEN = LEN_NAM
	   COPYNAM(1:COPYLEN) = STR_NAM(1:LEN_NAM)
	ENDIF
C
	IF ( .NOT.MAGTAPE ) THEN
	   IFFLEN = COPYLEN + 11
	   IFFFILE(1:IFFLEN) = 'LSL$IF:'//COPYNAM(1:COPYLEN)//'.IFF'
	   TMPLEN = COPYLEN + 19
	   TMPFILE(1:TMPLEN) = 'SYS$DISK:'//COPYNAM(1:COPYLEN)//'.ARC2I_TMP'
	ENDIF
C
C **********************************************************************
C /ARC_ID - state which attribute field is to be used to determine which
C attributes are attached to features.
C
	STATUS = DCL_QUAL( 'ARC_ID',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	ARC_ID = USER_ID
C
	IF (HAD_QUAL) THEN
C
C Check for the keywords
C
	   STATUS = DCL_QUAL('ARC_ID.USER_ID',	! keyword name
     &	   	             ID_USER,		! out - globally there
     &		             PRESENT,		! out - locally there
     &		             NEGATED,		! out - true if negated
     &		             .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   STATUS = DCL_QUAL('ARC_ID.INTERNAL_ID',! keyword name
     &	   	             ID_INT,		! out - globally there
     &		             PRESENT,		! out - locally there
     &		             NEGATED,		! out - true if negated
     &		             .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF (ID_USER) THEN
	      ARC_ID = USER_ID
	   ELSEIF (ID_INT) THEN
	      ARC_ID = INTERNAL_ID
	   ELSE
	      ARC_ID = USER_ID
	   ENDIF
	ENDIF
C
C **********************************************************************
C /POINT_ID - state which attribute field is to be used to determine which
C attributes are attached to features.
C
	STATUS = DCL_QUAL( 'POINT_ID',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	POINT_ID = USER_ID
C
	IF (HAD_QUAL) THEN
C
C Check for the keywords
C
	   STATUS = DCL_QUAL('POINT_ID.USER_ID',! keyword name
     &	   	             ID_USER,		! out - globally there
     &		             PRESENT,		! out - locally there
     &		             NEGATED,		! out - true if negated
     &		             .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   STATUS = DCL_QUAL('POINT_ID.INTERNAL_ID',! keyword name
     &	   	             ID_INT,		! out - globally there
     &		             PRESENT,		! out - locally there
     &		             NEGATED,		! out - true if negated
     &		             .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF (ID_USER) THEN
	      POINT_ID = USER_ID
	   ELSEIF (ID_INT) THEN
	      POINT_ID = INTERNAL_ID
	   ELSE
	      POINT_ID = USER_ID
	   ENDIF
	ENDIF
C
C **********************************************************************
C /[NO]LOG - require informational messages to be output
C
	STATUS = DCL_QUAL( 'LOG',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_LOG = HAD_QUAL
C
C **********************************************************************
C /[NO]ID_TO_FC - extract FC from ID 
C
	STATUS = DCL_QUAL( 'ID_TO_FC',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_ID_TO_FC = HAD_QUAL
C
C **********************************************************************
C /[NO]VERBOSE - require details about attribute assignments
C
	STATUS = DCL_QUAL( 'VERBOSE',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_VERBOSE = HAD_QUAL
C
C **********************************************************************
C /[NO]REWIND - require the tape to be rewound when the program is executed
C
	STATUS = DCL_QUAL( 'REWIND',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_REWIND = HAD_QUAL
C
C **********************************************************************
C /PARAMETER=file - specifies the parameter file used in the convertion
C
	STATUS = DCL_QUAL('PARAMETER',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C If we have the qualifier, get the actual filename which is REQUIRED 
C so must be there
C
	HAD_PAR = HAD_QUAL
C
	IF ( HAD_PAR )THEN
	   STATUS = DCL_FILE('PARAMETER',	! qualifier
     &			      ' ',		! default file-name
     &		              ABSENT,		! set if no file-name
     &			      .FALSE.,		! don't expect list of files
     &          	      .TRUE.)		! set-local error reporting
	   IF ( .NOT.STATUS ) GOTO 999
C
	   PARFILE = FILARY(1)(1:FIL_LEN(1))
	   PARLEN  = FIL_LEN(1)
C
C Check whether file exists
C
	   CONTEXT = 0			! clear context
	   IERR = LIB$FIND_FILE(PARFILE,PARFILE,CONTEXT)
	   CALL LIB$FIND_FILE_END(CONTEXT)
C
C The length of the filename may now be longer so scan string to find end
C
	   DO 500 I = 1,C_MAX_SIZ
	      IF (PARFILE(I:I).EQ.' ') THEN
	         PARLEN = I-1
	         GOTO 510
	      ENDIF
500	   CONTINUE
C
510	   IF ( .NOT. IERR) THEN
	      STATUS = ARC2I__NOPARFILE
	      CALL LSL_PUTMSG( STATUS )
	      GOTO 999
	   ENDIF
	   IF ( HAD_LOG ) CALL WRITEF('Parameter file : %S',PARFILE(1:PARLEN) )
	ELSE
	   CALL LSL_PUTMSG( ARC2I__NOPAR )
	ENDIF
C
C **********************************************************************
C /[NO]FRT[=file] - use FRT file to find oriented symbols and read ACD's
C
	STATUS = DCL_QUAL( 'FRT',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag and set the default filename
C
	HAD_FRT = HAD_QUAL
C
	IF ( HAD_FRT ) THEN
C
	   STATUS = DCL_FILE( 'FRT',		! qualifier name
     &		               'LSL$FRT:.FRT',	! default filename
     &		               ABSENT,		! out - was name absent?
     &		               .FALSE.,		! only one file to process
     &		               .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   FRTFILE = FILARY(1)(1:FIL_LEN(1))
	   FRTLEN  = FIL_LEN(1)
C
C Check whether file exists
C
	   CONTEXT = 0				! clear context
	   IERR = LIB$FIND_FILE(FRTFILE,FRTFILE,CONTEXT)
	   CALL LIB$FIND_FILE_END(CONTEXT)
C
C The length of the filename may now be longer so scan string to find end
C
	   DO 600 I = 1,C_MAX_SIZ
	      IF (FRTFILE(I:I).EQ.' ') THEN
	         FRTLEN = I-1
	         GOTO 610
	      ENDIF
600	   CONTINUE
C
610	   IF ( .NOT. IERR ) THEN
	      STATUS = ARC2I__NOFRT
	      CALL LSL_PUTMSG( STATUS )
	      GOTO 999
	   ENDIF
	   IF ( HAD_LOG ) CALL WRITEF('FRT file       : %S',FRTFILE(1:FRTLEN) )
	ENDIF
C
C **********************************************************************
C /SCALE=integer - used to fill in the MD scale and used as a factor for
C                  the text height
C
	STATUS = DCL_QUAL( 'SCALE',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_SCALE = HAD_QUAL
C
C and read its value(s) into the CLD common block
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'SCALE',		! qualifier name
     &			 .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   SCALE = IARRAY(1)			! remember the value
	ENDIF
C
C **********************************************************************
C /BLOCKSIZE=integer - set the magtape block size
C
	STATUS = DCL_QUAL( 'BLOCKSIZE',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_BLKSIZ = HAD_QUAL
C
C and read its value(s) into the CLD common block
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'BLOCKSIZE',	! qualifier name
     &			 .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF (IARRAY(1).GT.65535) THEN
	      CALL LSL_PUTMSG( ARC2I__BLKSIZ,65535 )
	      IARRAY(1) = 65535
	   ENDIF
	   BLKSIZ = IARRAY(1)			! remember the value
	ELSE
	   IF (MAGTAPE) THEN
	      CALL LSL_PUTMSG( ARC2I__BLKSIZ,8000 )
	   ENDIF
	   BLKSIZ = 8000
	ENDIF
C
C **********************************************************************
C /SELECT=(list) - select the files from the magtape to be converted
C
	STATUS= DCL_QUAL( 'SELECT',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C if the switch was present, then record as much, and read its value(s)
C into the CLD common block, where we will leave them.
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'SELECT',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   NUM_SEL = NUMINT
	   DO 90 I = 1, NUM_SEL
	      SEL_LIST(I) = IARRAY(I)
90	   CONTINUE
	   HAD_SELECT = .TRUE.			! remember we've had it
	   IF ( MAGTAPE ) THEN
	      IF ( HAD_OUTPUT ) THEN
	         IF ( NUM_SEL.EQ.1) THEN
C
C If processing tape with one file on /SELECT list then an output filename is
C permitted. Otherwise it will be taken from each file in GET_FILENAME
C
	            IFFLEN = COPYLEN + 11
	            IFFFILE(1:IFFLEN) = 'LSL$IF:'//COPYNAM(1:COPYLEN)//'.IFF'
	            TMPLEN = COPYLEN + 19
	            TMPFILE(1:TMPLEN) = 'SYS$DISK:'//COPYNAM(1:COPYLEN)//'.ARC2I_TMP'
	         ELSE
	            CALL LSL_PUTMSG( ARC2I__OUTFILIGNORE )
	            HAD_OUTPUT = .FALSE.
	         ENDIF
	      ENDIF
	   ELSE
	      CALL LSL_PUTMSG( ARC2I__QUALIGNORE )
	      HAD_SELECT = .FALSE.
	   ENDIF
	ENDIF
C
C **********************************************************************
C
C All done
C
999	CONTINUE
	CMDLINE = STATUS			! Return status to caller
C
	RETURN
	END
C
