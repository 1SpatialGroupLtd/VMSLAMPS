	INTEGER FUNCTION OBEY_QUAL(QUAL,HAD_QUAL,DEFAULTED,NEGATED,WHINGE)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England
C	
CMOD	Use in MAPDATA2I. Mod 1400.			ST   20-Sep-1994
CMOD	Special version, renamed OBEY_QUAL, for		RJH  31-Aug-1994
CMOD	   I2MAPDATA; ; references a local common block,
CMOD	   LOCAL_REPORT; replaces arguments LOCAL and
CMOD	   LOCNEG with DEFAULTED and NEGATED
CMOD	/LSL_STATUS/ added				TJH  21-Nov-1985
C	Created (as DCL_QUAL)				TJH  27-Aug-1985
C
C Searches for the DCL qualifier specified by QUAL and HAD_QUAL
C is set .TRUE. if qualifier is found. Function returns set to 
C SS$_NORMAL if all is well. Local error reporting (via condition
C handler ) may be invoked by setting  WHINGE .TRUE.. 
C If the qualifier is present by default then DEFAULTED is set .TRUE.. If a
C qualifier is negated (ie present as /NO_THING) then NEGATED is set .TRUE..
C
	IMPLICIT NONE
C
	INTEGER*4 	CLI$_ABSENT, CLI$_PRESENT, CLI$_DEFAULTED,
     &			CLI$_NEGATED, CLI$_LOCNEG, CLI$_LOCPRES
	EXTERNAL 	CLI$_ABSENT, CLI$_PRESENT, CLI$_DEFAULTED,
     &			CLI$_NEGATED, CLI$_LOCNEG, CLI$_LOCPRES
	INTEGER 	CLI$PRESENT
C
	CHARACTER*(*)	QUAL		! the desired DCL qualifier
	LOGICAL		HAD_QUAL	! .T. if qualifier found
	LOGICAL		DEFAULTED	! .T. if qualifier defaulted
	LOGICAL		NEGATED		! .T. if qualifier negated
	LOGICAL*4	WHINGE		! .T. if local error reporting
C
C condition handler
	EXTERNAL	OBEY_ERRET
C
C Common block to control error reporting in condition handler
	LOGICAL*4	LOCAL_REPORT	! .T. if local error reporting
	COMMON /OBEY_REPORT/ LOCAL_REPORT	
C
	INCLUDE 	'LSL$CMNLSL:STATUS.CMN'
	INCLUDE 	'($SSDEF)'
	INCLUDE 	'($STSDEF)'
C
C
C------------------------------------------------------------------------------
C
	HAD_QUAL = .FALSE.		! we won't find it
	DEFAULTED = .FALSE.		! if so it is not defaulted
	NEGATED = .FALSE.		! and it is positive
	LOCAL_REPORT=WHINGE		! condition handler to scream?
C
C Establish condition handler
	CALL LIB$ESTABLISH( OBEY_ERRET )
C
	OBEY_QUAL = CLI$PRESENT(QUAL)	
C
	IF (OBEY_QUAL) THEN
	   HAD_QUAL = .TRUE.			! set flag
	ELSE IF ((OBEY_QUAL.NE.%LOC(CLI$_ABSENT)
     &		.AND.
     &           OBEY_QUAL.NE.%LOC(CLI$_DEFAULTED)
     &		.AND.
     &           OBEY_QUAL.NE.%LOC(CLI$_LOCNEG)
     &		.AND.
     &           OBEY_QUAL.NE.%LOC(CLI$_NEGATED)
     &		.AND.
     &		(IBITS(OBEY_QUAL,0,3).NE.STS$K_WARNING))) THEN
C
	   CALL LIB$SIGNAL (%VAL(OBEY_QUAL))	! signal the error
C
C Revert to normal error processing
	   CALL LIB$REVERT
	   LSL_STATUS=OBEY_QUAL.OR.LSL_QUIET	! set $status 
	   RETURN
	ENDIF
C
C If the qualifier was present by default (HAD_QUAL = .TRUE.), then
C signal this fact.
	IF (OBEY_QUAL.EQ.%LOC(CLI$_DEFAULTED)) DEFAULTED = .TRUE.
C
C If the qualifier was negated (HAD_QUAL = .FALSE.) do the same
	IF (OBEY_QUAL.EQ.%LOC(CLI$_NEGATED)) NEGATED = .TRUE.
C
C Make sure termination status is correct
	IF ((OBEY_QUAL.EQ.%LOC(CLI$_ABSENT)
     &		.OR.
     &           OBEY_QUAL.EQ.%LOC(CLI$_DEFAULTED)
     &		.OR.
     &           OBEY_QUAL.EQ.%LOC(CLI$_LOCNEG)
     &		.OR.
     &           OBEY_QUAL.EQ.%LOC(CLI$_LOCPRES)
     &		.OR.
     &           OBEY_QUAL.EQ.%LOC(CLI$_PRESENT)
     &		.OR.
     &           OBEY_QUAL.EQ.%LOC(CLI$_NEGATED)))
     &     OBEY_QUAL = SS$_NORMAL
C
C Revert to normal error processing
	CALL LIB$REVERT
	LSL_STATUS=OBEY_QUAL.OR.LSL_QUIET	! set $status 
C
C------------------------------------------------------------------------------
C
	RETURN
	END
