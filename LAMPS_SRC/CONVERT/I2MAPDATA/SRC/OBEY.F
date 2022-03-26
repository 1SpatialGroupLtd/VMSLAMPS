	INTEGER*4 FUNCTION OBEY
C
CDEC$	IDENT	'19SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	 1-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Decode Command Line
C
C Description
C
C	Decodes the DCL command line and sets control variables. Command line
C	qualifier values override any corresponding keyword values specified
C	in the parameter file, although the command line is interpreted first.
C
C	This routine requires a special version of LSLLIB's DCL_QUAL, renamed
C	OBEY_QUAL, in which the third and fourth return arguments are
C	replaced, as follows:
C
C	ok = OBEY_QUAL( qualifier, had_qual, defaulted, negated, report )
C
C       out - long	ok		return status (as for LSLLIB version)
C        in - char	qualifier	qualifier name (as for LSLLIB version)
C       out - logical	had_qual	true if qualifier present, or present
C					by default (as for LSLLIB version)
C       out - logical	defaulted	true if qualifier present by default
C       out - logical	negated		true if qualifier negated (/NOxxx)
C        in - logical	report		true for local error reporting (as for
C					LSLLIB version)
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE '($STSDEF)/NOLIST'
C
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB filename expansion
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command line decoding
	INCLUDE	'CMN:FILES.CMN'      		! filenames
	INCLUDE	'CMN:CONTROL.CMN'      		! control variables
C
C External Declarations
C
	EXTERNAL	I2MAPDATA_CLD	! command language definition
C
C Functions
C
	INTEGER*4	DCL_STARTUP	! get and parse command line
	INTEGER*4	DCL_FILE	! get and parse filenames
	INTEGER*4	DCL_INT		! get integers
	INTEGER*4	DCL_STR		! get strings
C
	INTEGER*4	PARFILN		! parse a filename
C
	INTEGER*4	OBEY_QUAL	! look for a qualifier
	INTEGER*4	CHECK_AC_CODE	! check AC code is valid
C
C Local Variables
C
	INTEGER*4	OK		! status return code
C
	LOGICAL*4	ABSENT		! set if file parameter not found
	LOGICAL*4	IS_DEF		! set if qualifier present by default
	LOGICAL*4	IS_NEG		! set if qualifier negated
        LOGICAL*4	WHINGE		! set local error reporting
C
	LOGICAL*4	GOT_PAR		! got /PARAMETER qualifier ?
	LOGICAL*4	GOT_NAME	! got NAME keyword ?
	LOGICAL*4	GOT_CODE	! got CODE keyword ?
C
C Initialisation
C
	WHINGE   = .TRUE.		! report errors locally
C
	GOT_PAR  = .FALSE.
	GOT_NAME = .FALSE.
	GOT_CODE = .FALSE.
C
C Get and parse the command line
C
	OK = DCL_STARTUP( 'I2MAPDATA', .FALSE., I2MAPDATA_CLD, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the input IFF filename (P1) 
C
	OK = DCL_FILE( 'IN_FILESPEC', IFFTEM, ABSENT, .FALSE., WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Save the IFF filename and its length
C
	IFFFIL = FILARY(1)(1:FIL_LEN(1))
	IFFLEN = FIL_LEN(1)
C
C Set up the default MAPDATA filename - use the name part of the IFF filename,
C which is still in the filename parsing common block
C
	OK = PARFILN( MAPFIL, MAPLEN, STR_NAM(1:LEN_NAM), MAPTEM, .FALSE. )
	IF (.NOT. OK) THEN
	   CALL LSL_PUTMSG(OK)
	   IF ((OK .AND. STS$M_SEVERITY) .NE. STS$K_WARNING) 
     &	      GO TO 999
	ENDIF
C
C Get the output MAPDATA filename (P2)
C
	OK = DCL_FILE( 'OUT_FILESPEC', MAPFIL(1:MAPLEN),
     &	               ABSENT, .FALSE., WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Save the MAPDATA filename and its length
C
	IF (.NOT. ABSENT) THEN
	   MAPFIL = FILARY(1)(1:FIL_LEN(1))
	   MAPLEN = FIL_LEN(1)
	ENDIF
C
C /PARAMETER_FILE qualifier
C
	OK = OBEY_QUAL( 'PARAMETER_FILE', GOT_PAR, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C The absence of /PARAMETER_FILE is DISALLOWed and the filename is REQUIRED, 
C therefore we must always have it
C
	OK = DCL_FILE( 'PARAMETER_FILE', PARTEM, ABSENT, .FALSE., WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Save the parameter filename and its length
C
	PARFIL = FILARY(1)(1:FIL_LEN(1))
	PARLEN = FIL_LEN(1)
C
C Set up the default FRT filename - use the name part of the parameter
C filespec, which is still in the filename parsing common block
C
	OK = PARFILN( FRTFIL, FRTLEN, STR_NAM(1:LEN_NAM), FRTTEM, .FALSE. )
	IF (.NOT. OK) THEN
	   CALL LSL_PUTMSG(OK)
	   IF ((OK .AND. STS$M_SEVERITY) .NE. STS$K_WARNING) 
     &	      GO TO 999
	ENDIF
C
C /FRT_FILE qualifier
C
	OK = OBEY_QUAL( 'FRT_FILE', HAD_FRT, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the FRT filename if the qualifier is present
C
	IF (HAD_FRT) THEN
	   OK = DCL_FILE( 'FRT_FILE', FRTFIL(1:FRTLEN),
     &	                  ABSENT, .FALSE., WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Save the FRT filename and its length, if present
C
	   IF (.NOT. ABSENT) THEN
	      FRTFIL = FILARY(1)(1:FIL_LEN(1))
	      FRTLEN = FIL_LEN(1)
	   ENDIF
C
	ENDIF
C
C /LOG qualifier
C
	OK = OBEY_QUAL( 'LOG', HAD_LOG, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C /CURVE_AC qualifier
C
	OK = OBEY_QUAL( 'CURVE_AC', HAD_CURVE_AC, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the keywords if the qualifier is present
C
	IF (HAD_CURVE_AC) THEN
C
C /CURVE_AC NAME keyword
C
	   OK = OBEY_QUAL( 'CURVE_AC.NAME', GOT_NAME, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC name if the keyword is present
C
	   IF (GOT_NAME) THEN
	      OK = DCL_STR( 'CURVE_AC.NAME', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The name is REQUIRED, so assume there is a value
C
	      CURVE_AC_NAME = CARRAY(1)(1:STR_LEN(1))
	      CURVE_AC_LEN  = MIN(STR_LEN(1),NAME_MAX)
	   ENDIF
C
C /CURVE_AC CODE keyword
C
	   OK = OBEY_QUAL( 'CURVE_AC.CODE', GOT_CODE, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC code if the keyword is present
C
	   IF (GOT_CODE) THEN
	      OK = DCL_INT( 'CURVE_AC.CODE', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The code is REQUIRED, so assume there is a value
C
	      CURVE_AC_CODE = IARRAY(1)
C
C and check it is valid
C
	      OK = CHECK_AC_CODE(CURVE_AC_CODE)
              IF (.NOT. OK) GOTO 999
	   ENDIF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_CURVE_AC = IS_NEG
	ENDIF
C
C /PRIORITY_AC qualifier
C
	OK = OBEY_QUAL( 'PRIORITY_AC', HAD_PRIO_AC, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the keywords if the qualifier is present
C
	IF (HAD_PRIO_AC) THEN
C
C /PRIORITY_AC NAME keyword
C
	   OK = OBEY_QUAL( 'PRIORITY_AC.NAME',
     &	                   GOT_NAME, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC name if the keyword is present
C
	   IF (GOT_NAME) THEN
	      OK = DCL_STR( 'PRIORITY_AC.NAME', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The name is REQUIRED, so assume there is a value
C
	      PRIO_AC_NAME = CARRAY(1)(1:STR_LEN(1))
	      PRIO_AC_LEN  = MIN(STR_LEN(1),NAME_MAX)
	   ENDIF
C
C /PRIORITY_AC CODE keyword
C
	   OK = OBEY_QUAL( 'PRIORITY_AC.CODE',
     &	                   GOT_CODE, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC code if the keyword is present
C
	   IF (GOT_CODE) THEN
	      OK = DCL_INT( 'PRIORITY_AC.CODE', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The code is REQUIRED, so assume there is a value
C
	      PRIO_AC_CODE = IARRAY(1)
C
C and check it is valid
C
	      OK = CHECK_AC_CODE(PRIO_AC_CODE)
              IF (.NOT. OK) GOTO 999
	   ENDIF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_PRIO_AC = IS_NEG
	ENDIF
C
C /TEXT_AC qualifier
C
	OK = OBEY_QUAL( 'TEXT_AC', HAD_TEXT_AC, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the keywords if the qualifier is present
C
	IF (HAD_TEXT_AC) THEN
C
C /TEXT_AC NAME keyword
C
	   OK = OBEY_QUAL( 'TEXT_AC.NAME', GOT_NAME, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC name if the keyword is present
C
	   IF (GOT_NAME) THEN
	      OK = DCL_STR( 'TEXT_AC.NAME', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The name is REQUIRED, so assume there is a value
C
	      TEXT_AC_NAME = CARRAY(1)(1:STR_LEN(1))
	      TEXT_AC_LEN  = MIN(STR_LEN(1),NAME_MAX)
	   ENDIF
C
C /TEXT_AC CODE keyword
C
	   OK = OBEY_QUAL( 'TEXT_AC.CODE', GOT_CODE, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC code if the keyword is present
C
	   IF (GOT_CODE) THEN
	      OK = DCL_INT( 'TEXT_AC.CODE', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The code is REQUIRED, so assume there is a value
C
	      TEXT_AC_CODE = IARRAY(1)
C
C and check it is valid
C
	      OK = CHECK_AC_CODE(TEXT_AC_CODE)
              IF (.NOT. OK) GOTO 999
	   ENDIF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_TEXT_AC = IS_NEG
	ENDIF
C
C /ADD_OFFSET qualifier
C
	OK = OBEY_QUAL( 'ADD_OFFSET', HAD_OFFSET, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Save flag if the qualifier is present by default
C
	IF (HAD_OFFSET) THEN
	   DEF_OFFSET = IS_DEF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_OFFSET = IS_NEG
	ENDIF
C
C /DIVIDE qualifier
C
	OK = OBEY_QUAL( 'DIVIDE', HAD_DIVIDE, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the divisor if the qualifier is present
C
	IF (HAD_DIVIDE) THEN
	   OK = DCL_INT( 'DIVIDE', WHINGE )
           IF (.NOT. OK) GOTO 999
C
C We have supplied a default in the CLD module, so can assume we have a value
C
	   DIVISOR = IARRAY(1)
        ENDIF
C
C All done
C
999	OBEY = OK			! return error status
C
	RETURN
	END
