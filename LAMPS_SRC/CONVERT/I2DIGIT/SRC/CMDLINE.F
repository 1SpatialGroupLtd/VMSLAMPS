C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-21 14:07:06.000000000 +0100
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
CDEC$	IDENT	'13AU92'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	29-Nov-1991
C
C Description:
C
C	Module CMDLINE called by I2DIGIT in package CONVERT
C	Command line interpreter for I2DIGIT.
C
        IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'FILES.CMN'      		! I2DIGIT filenames
	INCLUDE	'COMMANDS.CMN'		  	! I2DIGIT command qualifiers
	INCLUDE	'GENERAL.CMN'	  		! General variables
C
C External functions
C
	INTEGER		I2DIGIT_CLD		! Command language definition
	EXTERNAL	I2DIGIT_CLD
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
	LOGICAL		DCL_INT			! Get an integer
	LOGICAL		DCL_REAL		! Get an real
	LOGICAL		DCL_STR			! Get a string arg
	LOGICAL		TTWSTR			! Write to terminal
	LOGICAL		PARFILN			! Parse filename
	INTEGER*4	LIB$FIND_FILE		! See if file exists
C
C Parameters
C
	CHARACTER*1	SQUOTE,DQUOTE
	PARAMETER	(SQUOTE='''')
	PARAMETER	(DQUOTE='"')
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4 	PRESENT			! True if qualifier detected
	INTEGER*4	ERROR			! Error flag
	INTEGER*4	I			! Loop count
	INTEGER*4	CONTEXT			! context for LIB$FIND_FILE
	INTEGER*4	IERR			! error code
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL 	HAD_QUAL		! True if qualifier present
	LOGICAL 	NEGATED			! True if qualifier negated
	CHARACTER*16	IFFPARSE		! IFF default
	CHARACTER	CH
C
	DATA		IFFPARSE  / 'LSL$IF:IFF.IFF;0' /
C
C *****************************************************************************
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'I2DIGIT',	! command verb
     &	                       .FALSE.,		! don't burst parameter lists
     &	                       I2DIGIT_CLD,	! our CLD file
     &                         .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999
C
C *****************************************************************************
C Get the IFF input filename
C
	STATUS = DCL_FILE( 'IFF_FILESPEC',	! qualifier name
     &	                    IFFPARSE,		! default filename
     &		            ABSENT,		! out - was name absent?
     &		            .FALSE.,		! only one file to process
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999
C
C Check if an input file spec was given
C
	IF (ABSENT) THEN
	   STATUS = I2DIGIT__NOINPUTFILE
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C Store IFF file length and name.
C
	IFFLEN  = FIL_LEN(1)
	IFFFILE = FILARY(1)(1:IFFLEN)
C
C Save name of file for partition in case /PARTITION_NAME was missing
C
	PARTNAME(1:10) = '          '
	PARTNAME(1:MIN0(10,LEN_NAM)) = STR_NAM(1:MIN0(10,LEN_NAM))
C
C Save name for temporary work file
C
	TMPLEN = 21 + LEN_NAM
	TMPFILE(1:TMPLEN) = 'SYS$DISK:'//STR_NAM(1:LEN_NAM)//'.I2DIGIT_TMP'
C
C Check whether file exists
C
	CONTEXT = 0		! clear context
	IERR = LIB$FIND_FILE(IFFFILE,IFFFILE,CONTEXT)
	CALL LIB$FIND_FILE_END(CONTEXT)
C
C The length of the filename may now be longer so scan string to find end
C
	DO 500 I = 1,C_MAX_SIZ
	   IF (IFFFILE(I:I).EQ.' ') THEN
	      IFFLEN = I-1
	      GOTO 510
	   ENDIF
500	CONTINUE
C
510	IF ( .NOT. IERR) THEN
	   STATUS = I2DIGIT__NOSUCHFILE
	   CALL LSL_PUTMSG(STATUS,IFFFILE(1:IFFLEN))
	   GOTO 999
	ENDIF
C
C *****************************************************************************
C
C Get the DIGIT output device name
C
	STATUS = DCL_FILE( 'DIGIT_TAPE_DEVICE',	! qualifier name
     &	                   ' ',			! default filename
     &		            ABSENT,		! out - was name absent?
     &		            .FALSE.,		! only one file to process
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999
C
C Store DIGIT device length and name
C
	DEVICELEN  = FIL_LEN(1)
	DEVICENAME = FILARY(1)(1:DEVICELEN)
C
C Check if DIGIT file-spec is a valid magtape device
C
	IF ( .NOT.HAD_DIR .AND. 		! No directory
     &       .NOT.HAD_NAM .AND.  		! No filename
     &	     .NOT.HAD_EXT .AND.			! No extension
     &       .NOT.HAD_VER      			! No version
     &	   ) THEN				! Possibly a magtape device
C          MAGTAPE = .TRUE.
	   CONTINUE
	ELSE					! Otherwise a disk file
	   STATUS = I2DIGIT__INVDEVICE
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C *****************************************************************************
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
C /[NO]APPEND - require file to appended after EOV marker (2 tape marks)
C
	STATUS = DCL_QUAL( 'APPEND',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
	HAD_APPEND = HAD_QUAL
C
C **********************************************************************
C /RESOLUTION=integer - set the DIGIT file resolution.
C
	STATUS = DCL_QUAL( 'RESOLUTION',	! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C Set default resolution
C
	RESOLUTION = 32
C
C and read its value into the CLD common block
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'RESOLUTION',	! qualifier name
     &			      .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF (IARRAY(1).GE.1 .AND. IARRAY(1).LT.100) THEN
	      RESOLUTION = IARRAY(1)
	      HAD_RES = .TRUE.
	   ELSE
	      RESOLUTION = 32
	      CALL LSL_PUTMSG(I2DIGIT__DEFRES,RESOLUTION)
	   ENDIF
	ENDIF
C
C **********************************************************************
C /[NO]PARAMETER - used as a lookup for FCs
C
	STATUS = DCL_QUAL( 'PARAMETER',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag and set the default filename
C
	HAD_PAR = HAD_QUAL
C
	IF ( HAD_PAR ) THEN
C
	   STATUS = DCL_FILE( 'PARAMETER',	! qualifier name
     &		               ' ',		! default filename
     &		               ABSENT,		! out - was name absent?
     &		               .FALSE.,		! only one file to process
     &		               .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   PARFILE = FILARY(1)(1:FIL_LEN(1))
	   PARLEN  = FIL_LEN(1)
C
C Check whether file exists
C
	   CONTEXT = 0				! clear context
	   IERR = LIB$FIND_FILE(PARFILE,PARFILE,CONTEXT)
	   CALL LIB$FIND_FILE_END(CONTEXT)
C
C The length of the filename may now be longer so scan string to find end
C
	   DO 600 I = 1,C_MAX_SIZ
	      IF (PARFILE(I:I).EQ.' ') THEN
	         PARLEN = I-1
	         GOTO 610
	      ENDIF
600	   CONTINUE
C
610	   IF ( .NOT. IERR ) THEN
	      STATUS = I2DIGIT__NOSUCHFILE
	      CALL LSL_PUTMSG(STATUS,PARFILE(1:PARLEN))
	      GOTO 999
	   ENDIF
	   IF (HAD_LOG) CALL WRITEF('Parameter file : %S',PARFILE(1:PARLEN))
	ENDIF
C
C **********************************************************************
C /BLOCKSIZE=integer - set the magtape block size
C Must be a multple of 128 (ie the sector size)
C
C	STATUS = DCL_QUAL( 'BLOCKSIZE',		! qualifier name
C     &		            HAD_QUAL,		! out - globally there
C     &		            PRESENT,		! out - locally there
C     &		            NEGATED,		! out - true if negated
C     &		            .TRUE. )		! deal with errors itself
C
C	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C set the flag 
C
C	HAD_BLKSIZ = HAD_QUAL
C
C and read its value(s) into the CLD common block
C
C 	IF ( HAD_QUAL ) THEN
C	   STATUS = DCL_INT( 'BLOCKSIZE',	! qualifier name
C     &			      .TRUE. )		! deal with errors itself
C	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C	   IF (IARRAY(1).GT.65535) THEN
C	      CALL LSL_PUTMSG(I2DIGIT__BLKSIZ,65535)
C	      CALL LSL_ADDMSG(I2DIGIT__DEFSIZ,12288)
C	      IARRAY(1) = 12288
C	   ENDIF
C	   TAPEBUFSIZE = IARRAY(1)		! remember the value
C	ELSE
C	   IF (MAGTAPE) THEN
C	      CALL LSL_PUTMSG(I2DIGIT__BLKSIZ,12288)
C	   ENDIF
C	   TAPEBUFSIZE = 12288
C	ENDIF
C
C **********************************************************************
C /LAYER=(list) - select the layers from the IFF file to be converted
C
	STATUS= DCL_QUAL( 'LAYER',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C if the switch was present, then record as much, and read its value(s)
C into the CLD common block, from where we will copy them.
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'LAYER',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   NUM_LAYER = NUMINT
	   DO 80 I = 1, NUM_LAYER
	      LAYER_LIST(I) = IARRAY(I)
80	   CONTINUE
	   HAD_LAYER = .TRUE.			! remember we've had it
	ENDIF
C
C **********************************************************************
C /FC=(list) - select the FCs from the IFF file to be converted
C
	STATUS= DCL_QUAL( 'FC',			! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C if the switch was present, then record as much, and read its value(s)
C into the CLD common block, from where we will copy them.
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'FC',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   NUM_FC = NUMINT
	   DO 90 I = 1, NUM_FC
	      FC_LIST(I) = IARRAY(I)
90	   CONTINUE
	   HAD_FC = .TRUE.			! remember we've had it
	ENDIF
C
C **********************************************************************
C /PARTITION_NAME - the partition name to go in the sctor header.
C
	STATUS= DCL_QUAL( 'PARTITION_NAME',	! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C Remove any single or double quotes that may be around name
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_STR( 'PARTITION_NAME',	! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF ( CARRAY(1)(1:1).EQ.SQUOTE .OR.
     &		CARRAY(1)(1:1).EQ.DQUOTE ) THEN
	      CARRAY(1)  = CARRAY(1)(2:)
	      STR_LEN(1) = STR_LEN(1) - 1
	      IF ( CARRAY(1)(STR_LEN(1):STR_LEN(1)).EQ.SQUOTE .OR.
     &		   CARRAY(1)(STR_LEN(1):STR_LEN(1)).EQ.DQUOTE ) THEN
	         CARRAY(1)  = CARRAY(1)(1:STR_LEN(1)-1)
	         STR_LEN(1) = STR_LEN(1) - 1
	      ENDIF
	   ENDIF
C
	   PARTNAME(1:10) = CARRAY(1)(1:MIN0(10,STR_LEN(1)))
C	   PARTNAME(1:MIN0(10,STR_LEN(1))) = CARRAY(1)(1:MIN0(10,STR_LEN(1)))
C
	   IF (STR_LEN(1).GT.10) THEN
	      CALL LSL_PUTMSG(I2DIGIT__LONGNAME,PARTNAME(1:10))
	   ENDIF
	ENDIF
C
	HAD_PARTNAME = .TRUE.
C
C Check partition name for invalid characters like underscores
C
	CH=PARTNAME(1:1)
	IF (.NOT.((CH.GE.'A'.AND.CH.LE.'Z') .OR.
     &	          (CH.GE.'a'.AND.CH.LE.'z') .OR.
     &	          (CH.EQ.' '))) THEN
	   STATUS = I2DIGIT__INVNAME
	   CALL LSL_PUTMSG(STATUS,PARTNAME(1:10))
	   GOTO 999
	ENDIF
	DO 900 I = 2,10
	   CH=PARTNAME(I:I)
	   IF (.NOT.((CH.GE.'A'.AND.CH.LE.'Z') .OR.
     &		     (CH.GE.'a'.AND.CH.LE.'z') .OR.
     &		     (CH.GE.'0'.AND.CH.LE.'9') .OR.
     &		     (CH.EQ.' '))) THEN
	      STATUS = I2DIGIT__INVNAME
	      CALL LSL_PUTMSG(STATUS,PARTNAME(1:10))
	      GOTO 999
	   ENDIF
900	CONTINUE
C
C **********************************************************************
C /SCALE_IFF - number of ground mm represented by 1 IFF file unit
C
	STATUS= DCL_QUAL( 'SCALE_IFF',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	SCALEIFF = 1000.0			! default to metres
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'SCALE_IFF',	! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
	   SCALEIFF = RARRAY(1)
	   HAD_SCALEIFF = .TRUE.
	   IF (SCALEIFF.LE.0.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'IFF scale')
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
C **********************************************************************
C /SCALE_SHEET - number of ground units represented by 1 sheet unit
C
	STATUS= DCL_QUAL( 'SCALE_SHEET',	! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'SCALE_SHEET',	! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
	   SCALESHEET = RARRAY(1)
	   HAD_SCALESHEET = .TRUE.
	   IF (SCALESHEET.LE.0.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'SHEET scale')
	      STATUS = .FALSE.
	      GOTO 999
	   ENDIF
	ENDIF
C
C Default value is taken from Map Descriptor
C
C **********************************************************************
C /SCALE_FACTOR - number of sheet mm represented by 1 IFF file unit
C
	STATUS= DCL_QUAL( 'SCALE_FACTOR',	! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	SCALEFACTOR = 1.0			! default to 1
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'SCALE_FACTOR',	! qualifier name
     &			      .TRUE. )		! let routine complain itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C If no argument given, SCALEFACTOR will remain as 1.
C If an argument is given, check that it is valid.
C
	   IF (NUMREA.GT.0) THEN
	      SCALEFACTOR = RARRAY(1)
	      IF (SCALEFACTOR.LE.0.0) THEN
		 CALL LSL_PUTMSG(I2DIGIT__BADSCALE,'SCALE_FACTOR')
		 STATUS = .FALSE.
		 GOTO 999
	      ENDIF
	   ENDIF
	   HAD_SCALEFACTOR = .TRUE.
	ENDIF
C
C **********************************************************************
C /OFFSET=(integer,integer) - set the DIGIT pixel offset.
C
	STATUS = DCL_QUAL( 'OFFSET',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C Set default offset
C
	OFFSET(1) = 1
	OFFSET(2) = 1
C
C and read its value into the CLD common block
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'OFFSET',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF (NUMINT.NE.2) THEN
	      CALL LSL_PUTMSG(I2DIGIT__TWONUMS)
	      STATUS = .FALSE.
	      GOTO 999	      
	   ENDIF
	   IF (IARRAY(1).LT.1 .OR. IARRAY(2).LT.1) THEN
	      CALL LSL_PUTMSG(I2DIGIT__MINOFFSET)
	      STATUS = .FALSE.
	      GOTO 999	      
	   ENDIF
	   OFFSET(1) = IARRAY(1)
	   OFFSET(2) = IARRAY(2)
	   HAD_OFFSET = .TRUE.
	ENDIF
C
C **********************************************************************
C /BORDER=integer - set the border width in DIGIT pixels.
C
	STATUS = DCL_QUAL( 'BORDER',		! qualifier name
     &		            HAD_QUAL,		! out - globally there
     &		            PRESENT,		! out - locally there
     &		            NEGATED,		! out - true if negated
     &		            .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
C Set default border
C
	BORDER = 0
C
C and read its value into the CLD common block
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_INT( 'BORDER',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
	   IF (IARRAY(1).LT.0) THEN
	      CALL LSL_PUTMSG(I2DIGIT__BADBORDER)
	      STATUS = .FALSE.
	      GOTO 999	      
	   ENDIF
	   BORDER = IARRAY(1)
	   HAD_BORDER = .TRUE.
	ENDIF
C
C **********************************************************************
C /XMIN - minimum X coord of area
C
	STATUS= DCL_QUAL( 'XMIN',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'XMIN',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
	   XMIN = RARRAY(1)
	   HAD_XMIN = .TRUE.
	ENDIF
C
C **********************************************************************
C /XMAX - maximum X value of area
C
	STATUS= DCL_QUAL( 'XMAX',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'XMAX',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
	   XMAX = RARRAY(1)
	   HAD_XMAX = .TRUE.
	ENDIF
C
C **********************************************************************
C /YMIN - minimum Y value of area
C
	STATUS= DCL_QUAL( 'YMIN',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'YMIN',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
	   YMIN = RARRAY(1)
	   HAD_YMIN = .TRUE.
	ENDIF
C
C **********************************************************************
C /YMAX - maximum Y value of area
C
	STATUS= DCL_QUAL( 'YMAX',		! qualifier name
     &		           HAD_QUAL,		! out - globally there
     &		           PRESENT,		! out - locally there
     &		           NEGATED,		! out - true if negated
     &		           .TRUE. )		! deal with errors itself
C
	IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
C
 	IF ( HAD_QUAL ) THEN
	   STATUS = DCL_REAL( 'YMAX',		! qualifier name
     &			      .TRUE. )		! deal with errors itself
C
	   IF ( .NOT.STATUS ) GOTO 999		! failed - give up with status
	   YMAX = RARRAY(1)
	   HAD_YMAX = .TRUE.
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
