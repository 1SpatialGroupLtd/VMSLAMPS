	INTEGER FUNCTION OBEY
CDEC$	IDENT	'19AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			13-Nov-1989			A.P.Brown
C
C Description:
C
C	Read the CCG SIF AA file
C
	IMPLICIT	NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:AA2IFFMSG.PAR'		! AA2IFF messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'CMN:FILE.CMN'      		! 
C
C External functions
C
	EXTERNAL	AA2IFF_CLD		! Command language definition
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
C
	INTEGER		FLROPN			! Open AA file
	INTEGER		IFFCREATE		! Start IFF
	LOGICAL		RDPAR			! Read PAR file
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL		LOCAL
	LOGICAL		LOCNEG
C
C-------------------------------------------------------------------------------
C Initialise
C
	HAD_PAR = .FALSE.
	HAD_FRT = .FALSE.
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'AA2IFF',.FALSE.,AA2IFF_CLD,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Get the AA input filename (P1) 
C
	STATUS = DCL_FILE( 'AA_FILESPEC','LSL$AA:AA.MAP',
     &					ABSENT,.FALSE.,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Store AA file length and name
C
	AALEN  = FIL_LEN(1)
	AAFILE = FILARY(1)(1:AALEN)
C
C Get the IFF output filename (P2)
C
	STATUS = DCL_FILE( 'IFF_FILESPEC','LSL$IF:IFF.IFF',
     &					ABSENT,.FALSE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name
C
	IFFLEN  = FIL_LEN(1)
	IFFFILE = FILARY(1)(1:IFFLEN)
C
C Get FRT file
C
	STATUS = DCL_QUAL('FRT', HAD_FRT, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_FRT) THEN
	   STATUS = DCL_FILE('FRT','LSL$FRT:AA.FRT',
     &					ABSENT,.FALSE.,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   FRTLEN  = FIL_LEN(1)
	   FRTFILE = FILARY(1)(1:FRTLEN)
	ENDIF
C
C Get PAR file
C
	STATUS = DCL_QUAL('PARAMETER_FILE', HAD_PAR, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_PAR) THEN
	   STATUS = DCL_FILE('PARAMETER_FILE','LSL$LOOKUP:AA.PAR',
     &					ABSENT,.FALSE.,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   PARLEN  = FIL_LEN(1)
	   PARFILE = FILARY(1)(1:PARLEN)
	ENDIF
C
C Open input AA file
C
	STATUS = FLROPN(AALUN,AAFILE(1:AALEN))
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(AA2I__UNAOPNAA,AAFILE(1:AALEN))
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C Open, read and close PAR file and FRT file (required for PAR file)
C
	IF (HAD_PAR) THEN
	   STATUS = RDPAR()
	   IF (.NOT.STATUS) GOTO 999
	ENDIF
C
C Open IFF file
C
	STATUS = IFFCREATE(IFFLUN,IFFFILE(1:IFFLEN))
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(AA2I__UNACREIFF,IFFFILE(1:IFFLEN))
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C All done
C
999	OBEY = STATUS				! Return status to caller
C
	RETURN
	END
C
