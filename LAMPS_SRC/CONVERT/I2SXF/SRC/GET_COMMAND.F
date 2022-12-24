C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-10 16:46:36.000000000 +0100
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
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	09-May-1990
C
C	CONVERT I2SXF Utility - Get and decode command line
C
C Description
C
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE '($STSDEF)/NOLIST'
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Local Parameters
C
	CHARACTER*(*)	IFFTEM		! IFF input file default
	PARAMETER	(IFFTEM  = 'LSL$IF:IFF.IFF')
	CHARACTER*(*)	SXFTEM		! IFF input file default
	PARAMETER	(SXFTEM  = 'LSL$SXF:SXF.SXF')
	CHARACTER*(*)	FRTTEM		! IFF input file default
	PARAMETER	(FRTTEM  = 'LSL$FRT:.FRT')
	CHARACTER*(*)	PARTEM		! IFF input file default
	PARAMETER	(PARTEM  = 'LSL$LOOKUP:I2SXF.I2SXF_PAR')
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:CLD.CMN'		! DCL command decoding
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Functions called
C
        INTEGER*4       DCL_STARTUP	! looks for command line
	INTEGER*4	DCL_FILE	! reads & parses file title
	INTEGER*4	DCL_QUAL	! looks for specified qualifier
	INTEGER*4	DCL_INT		! read integers
	INTEGER*4	PARFILN		! parse filename
C
C Local variables
C
	INTEGER*4	OK		! error return
	INTEGER*4	I		! counter
	LOGICAL*4	ABSENT		! set if file param. not found
	LOGICAL*4	LOCAL		! set if qual. is local
	LOGICAL*4	LOCNEG		! set if qual. locally negated
        LOGICAL*4	WHINGE		! set-local error reporting
	LOGICAL*4	GOT_PAR		! got /PARAMETER qualifier ?
	LOGICAL*4	GOT_FC		! got /FC        qualifier ?
	LOGICAL*4	GOT_LAY		! got /LAYER     qualifier ?
C
	CHARACTER*(C_NAM_SIZ)	PARNAM	! parameter file name part
	INTEGER*4		NAMLEN	! its length
C
C Command Language Definitions
C
 	EXTERNAL	I2SXF_CLD
C
C Initialisation for command line decoding
C
	WHINGE = .TRUE.			! report errors locally
C
C Get command line. DCL_STARTUP will return SS$NORMAL if all well.
C
	OK=DCL_STARTUP('I2SXF'		! command verb
     &      ,.FALSE.			! don't split parameter lists
     &      ,I2SXF_CLD			! CLD module name
     &      ,WHINGE)			! set -local error reporting
        IF(.NOT.OK) GOTO 999
C
C Get input file-name 
C
	OK=DCL_FILE('IN_FILESPEC'	! parameter label
     &		,IFFTEM			! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Transfer file-spec 
C
	IFFFIL = FILARY(1)(1:FIL_LEN(1))
	IFFLEN = FIL_LEN(1)
C
C Get output file-name 
C
	OK=DCL_FILE('OUT_FILESPEC'	! parameter label
     &		,SXFTEM			! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Transfer file-spec 
C
	SXFFIL = FILARY(1)(1:FIL_LEN(1))
	SXFLEN = FIL_LEN(1)
C
C /PARAMETER qualifier
C
	OK=DCL_QUAL('PARAMETER'		! qual. name
     &        		,GOT_PAR	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C The absence of /PARAMETER is DISALLOWed and the name is REQUIRED, 
C therefore we must always have it, so testing for it is not actually
C necessary
C
	OK=DCL_FILE('PARAMETER'		! qualifier
     &		,PARTEM			! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Set file-spec 
C
	PARFIL = FILARY(1)(1:FIL_LEN(1))
	PARLEN = FIL_LEN(1)
C
C Save the name part of the parameter filename, which is still in the 
C filename parsing common block
C
	PARNAM = STR_NAM(1:LEN_NAM)
	NAMLEN = MIN(LEN_NAM,C_NAM_SIZ)
C
C Use that to set up the default FRT filename 
C
	OK = PARFILN(FRTFIL,FRTLEN,PARNAM(1:NAMLEN),FRTTEM,.FALSE.)
	IF (.NOT. OK) THEN
	   CALL LSL_PUTMSG(OK)
	   IF ((OK .AND. STS$M_SEVERITY) .NE. STS$K_WARNING) 
     &	      GO TO 999
	ENDIF
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
C If we have the qualifier, get the actual filename if there is one
C
	IF (HAD_FRT) THEN
	   OK=DCL_FILE('FRT'		! qualifier
     &		,FRTFIL(1:FRTLEN)	! default file-name
     &		,ABSENT			! set if no file-name
     &		,.FALSE.		! don't expect list of files
     &          ,WHINGE)		! set-local error reporting
	   IF(.NOT.OK) GOTO 999
C
C Set file-spec 
C
	   IF (.NOT. ABSENT) THEN
	      FRTFIL = FILARY(1)(1:FIL_LEN(1))
	      FRTLEN = FIL_LEN(1)
	   ENDIF
	ENDIF
C
C /LOG qualifier
C
	OK=DCL_QUAL('LOG'		! qual. name
     &        		,HAD_LOG	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C /FC qualifier
C
	OK=DCL_QUAL('FC'		! qual. name
     &        		,GOT_FC		! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Get the feature codes 
C
	IF (GOT_FC) THEN
	   OK=DCL_INT('FC'		! qual. name
     &			,WHINGE)	! set-local error reporting
	   IF(.NOT.OK) GOTO 999
C
C and save them for later use
C
	   NUM_FC = NUMINT
	   DO 10 I=1,NUMINT
	      FC_LIST(I) = IARRAY(I)
10	   CONTINUE
	ENDIF
C
C /LAYER qualifier
C
	OK=DCL_QUAL('LAYER'		! qual. name
     &        		,GOT_LAY	! returned .T. if qual. found
     &			,LOCAL		! set if qual local to parameter
     &			,LOCNEG		! set if qual. negated locally
     &			,WHINGE)	! set-local error reporting
	IF(.NOT.OK) GOTO 999
C
C Get the layers
C
	IF (GOT_LAY) THEN
	   OK=DCL_INT('LAYER'		! qual. name
     &			,WHINGE)	! set-local error reporting
	   IF(.NOT.OK) GOTO 999
C
C and save them for later use
C
	   NUM_LAY = NUMINT
	   DO 20 I=1,NUMINT
	      LAY_LIST(I) = IARRAY(I)
20	   CONTINUE
	ENDIF
C
C Assign function value
C
999	GET_COMMAND = OK
C
C Return
C
	RETURN
	END
