C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-05 13:16:34.000000000 +0000
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
	LOGICAL FUNCTION GET_COMMAND
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description:
C       Read and decode command line
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	  ! DCL command decoding
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN' ! LSLLIB filename expansion
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	  ! LSLLIB status flag
C
C Functions called
C
        INTEGER*4       DCL_STARTUP	! looks for command line
	INTEGER*4	DCL_FILE	! reads & parses file title
	INTEGER*4	DCL_QUAL	! looks for specified qualifier
	INTEGER*4	DCL_INT		! read integers
	INTEGER*4	DCL_REAL	! read reals
	INTEGER*4	EXPFLN		! expand filename
	INTEGER*4	LIB$FIND_FILE	! See if file exists
C
C Local variables
C
	CHARACTER*80	IN_TEM
	INTEGER*4	OK		! error return
	INTEGER*4	I		! counter
	LOGICAL*4	ABSENT		! set if file param. not found
	LOGICAL*4	LOCAL		! set if qual. is local
	LOGICAL*4	LOCNEG		! set if qual. locally negated
        LOGICAL*4	WHINGE		! set-local error reporting
	INTEGER*4	CONTEXT		! context for LIB$FIND_FILE
	INTEGER*4	IERR		! error code
C
C Command Language Definitions
C
	EXTERNAL	ICASE_CLD
C
C------------------------------------------------------------------------------
C
C Initialisation for command line decoding
C
	WHINGE = .TRUE.			! report errors locally
C
C Get command line. DCL_STARTUP will return SS$NORMAL if all well.
C
	OK=DCL_STARTUP('ICASE'		! command verb
     &      ,.FALSE.			! don't split parameter lists
     &	    ,ICASE_CLD			! CLD module name
     &      ,WHINGE)			! set -local error reporting
        IF(.NOT.OK) GOTO 999
C
C Get input file-name 
C
	IN_TEM='LSL$IF:.IFF'
	OK=DCL_FILE('IN_FILESPEC'	! parameter label
     &		,IN_TEM			! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Transfer file-spec 
C
	INFILE = FILARY(1)(1:FIL_LEN(1))
	INLEN = FIL_LEN(1)
C
C Check whether file exists
C
	CONTEXT = 0		! clear context
	IERR = LIB$FIND_FILE(INFILE,INFILE,CONTEXT)
	CALL LIB$FIND_FILE_END(CONTEXT)
C
C The length of the filename may now be longer so scan string to find end
C
	   DO 100 I = 1,C_MAX_SIZ
	      IF (INFILE(I:I).EQ.' ') THEN
		 INLEN = I-1
		 GOTO 110
	      ENDIF
100	   CONTINUE
C
110	IF ( .NOT. IERR ) THEN
	   OK = ICASE__NOIFF
	   CALL LSL_PUTMSG(OK,INFILE(1:INLEN))
	   GOTO 999
	ENDIF
C
C Set up the default output filename - the input filename is already in 
C the FILENAME common block, as a result of calling DCL_FILE
C
	HAD_VER = .FALSE.
	OK = EXPFLN(OUTFILE,OUTLEN)
	IF (.NOT. OK) CALL LSL_PUTMSG(OK)	! just a warning
C
C------------------------------------------------------------------------------
C
C Get output file-name if it is there
C
	OK=DCL_FILE('OUT_FILESPEC'	! parameter label
     &		,OUTFILE(1:OUTLEN)	! default is input filename
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Set file-spec 
C
	IF (.NOT. ABSENT) THEN
	   OUTFILE = FILARY(1)(1:FIL_LEN(1))
	   OUTLEN = FIL_LEN(1)
	ENDIF
C
C------------------------------------------------------------------------------
C
C /FRT qualifier
C
	OK=DCL_QUAL('FRT'		! qual. name
     &        		,HAD_FRT	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C If we have the qualifier, get the actual filename which is REQUIRED 
C so must be there
C
	IF (HAD_FRT) THEN
	   OK=DCL_FILE('FRT'		! qualifier
     &		,'LSL$FRT:FRT.FRT;0'	! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	   IF(.NOT.OK) GOTO 999
C
C Set file-spec 
C
	   IF (ABSENT) THEN
	      FRTFILE = 'LSL$FRT:FRT.FRT;0'
	      FRTLEN = 17
	   ELSE
	      FRTFILE = FILARY(1)(1:FIL_LEN(1))
	      FRTLEN = FIL_LEN(1)
	   ENDIF
C
C Check whether file exists
C
	   CONTEXT = 0		! clear context
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
	      OK = ICASE__NOFRT
	      CALL LSL_PUTMSG(OK)
	      GOTO 999
	   ENDIF
C
	ENDIF
C
C------------------------------------------------------------------------------
C
C /PARAMETER qualifier
C
	PARFILE='.PAR'
	PARLEN=4
	OK=DCL_QUAL('PARAMETER'		! qual. name
     &        		,HAD_PAR	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C If we have the qualifier, get the actual filename which is REQUIRED 
C so must be there
C
	IF (HAD_PAR) THEN
	   OK=DCL_FILE('PARAMETER'	! qualifier
     &		,PARFILE(1:PARLEN)	! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	   IF(.NOT.OK) GOTO 999
C
C Set file-spec 
C
	   PARFILE= FILARY(1)(1:FIL_LEN(1))
	   PARLEN = FIL_LEN(1)
C
C Check whether file exists
C
	   CONTEXT = 0		! clear context
	   IERR = LIB$FIND_FILE(PARFILE,PARFILE,CONTEXT)
	   CALL LIB$FIND_FILE_END(CONTEXT)
C
C The length of the filename may now be longer so scan string to find end
C
	   DO 700 I = 1,C_MAX_SIZ
	      IF (PARFILE(I:I).EQ.' ') THEN
		 PARLEN = I-1
		 GOTO 710
	      ENDIF
700	   CONTINUE
C
710	   IF ( .NOT. IERR ) THEN
	      OK = ICASE__NOPARFILE
	      CALL LSL_PUTMSG(OK)
	      GOTO 999
	   ENDIF
	ENDIF
C
C------------------------------------------------------------------------------
C
C Get /TOLERANCE qualifier (segment length tolerance)
C
	OK=DCL_QUAL('TOLERANCE'		! qual. name
     &        		,HAD_TOL	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Get real value for tolerance
C
	IF (HAD_TOL) THEN
	   OK = DCL_REAL('TOLERANCE',.TRUE.)
	   IF (.NOT.OK) GOTO 999
C
	   IF (RARRAY(1).GE.0) THEN
	      TOL = RARRAY(1)
	   ELSE
	      CALL LSL_PUTMSG(ICASE__INVALTOL)
	      HAD_TOL = .FALSE.
	   END IF
	END IF
C
C------------------------------------------------------------------------------
C
C /CASINGS qualifier
C
	OK=DCL_QUAL('CASINGS'		! qual. name
     &        		,HAD_CASINGS	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C------------------------------------------------------------------------------
C
C /FILLS qualifier
C
	OK=DCL_QUAL('FILLS'		! qual. name
     &	    		 ,HAD_FILLS	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Check presence of either /CASINGS or /FILLS
C
	OK = HAD_CASINGS.OR.HAD_FILLS
	IF (.NOT.OK) THEN
	   OK = ICASE__CASEORFILL
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C------------------------------------------------------------------------------
C
C Assign function value
C
999	GET_COMMAND = OK
	IN_OPEN = .FALSE.
	OUT_OPEN = .FALSE.
C
C Return
C
	RETURN
	END
