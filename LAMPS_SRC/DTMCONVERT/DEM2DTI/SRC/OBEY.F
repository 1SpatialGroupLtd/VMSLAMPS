C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-16 12:09:12.000000000 +0100
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
	LOGICAL FUNCTION OBEY
C
CDEC$	IDENT	'30OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	04-Oct-1989
C
C Description:
C
C	Module OBEY called by DEM2DTI in package DTMCONVERT
C	Command line interpreter for DEM2DTI
C
C	Command syntax:
C
C	DEM2DTI[/LOG][/VALIDATE] Input DEM-file Output DTI-file
C
        IMPLICIT NONE
C
C Included Parameter Files
C
C
C Messages
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'	! DEM2DTI messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'LSL$DEM2DTI:FILE.CMN'      	! DEM2DTI filenames
	INCLUDE	'LSL$DEM2DTI:COMMANDS.CMN'  	! DEM2DTI command qualifiers
C
C External functions
C
	EXTERNAL	DEM2DTI_CLD		! Command language definition
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
	CHARACTER*15	DEMPARSE		! Name to parse DEM against
	CHARACTER*14	DTIPARSE		! Name to parse DTI against
	LOGICAL 	HAD_QUAL		! True if qualifier present
	LOGICAL 	NEGATED			! True if qualifier negated
	INTEGER 	PRESENT			! True if qualifier detected
	INTEGER		ERROR			! Error flag
	CHARACTER*(C_MAX_SIZ)	TMPFILE		! Temporary filename
	INTEGER		LENGTH			! Temporary filename length
C
	DATA		DEMPARSE  / 'SYS$DISK:.DEM;0' / 
	DATA		DTIPARSE  / 'LSL$DTI:.DTI;0' /
C
C-------------------------------------------------------------------------------
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'DEM2DTI',.FALSE.,DEM2DTI_CLD,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Get the DEM input filename (P1) 
C
	STATUS = DCL_FILE( 'DEM_FILESPEC',' ',ABSENT,.TRUE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store DEM file length and name
C
	DEMLEN  = FIL_LEN(1)
	DEMFILE = FILARY(1)(1:DEMLEN)
C
C Check if DEM file-spec is a valid filename or possibly just a magtape device
C
	IF ( .NOT.HAD_DIR .AND. 		! No directory
     &       .NOT.HAD_NAM .AND.  		! No filename
     &	     .NOT.HAD_EXT .AND.			! No extension
     &       .NOT.HAD_VER      			! No version
     &	   ) THEN				! Possibly a magtape device
	   MAGTAPE = .TRUE.
	ELSE					! Otherwise a disk file
C
C Try parsing the DEM file-spec against SYS$DISK:.DEM;0
C
	   STATUS = PARFILN( TMPFILE,LENGTH,DEMFILE,DEMPARSE,.TRUE. )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( DEM2DTI__INVFILNAM,DEMFILE(1:DEMLEN) )
	   ELSE
	      DEMFILE = TMPFILE
	      DEMLEN  = LENGTH
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
	   IF ( IARRAY(1) .GE. RECSIZ .AND. 
     &          IARRAY(1).LE.MAXBLK   .AND.
     &          MOD(IARRAY(1),RECSIZ) .EQ. 0 ) THEN
	      BLKSIZ = IARRAY(1)
	   ELSE
	      CALL LSL_PUTMSG( DEM2DTI__BADBLKSIZ,BLKSIZ )	      
	   ENDIF
	ENDIF
C
C All done
C
999	CONTINUE
	OBEY = STATUS				! Return status to caller
C
	RETURN
	END
C
