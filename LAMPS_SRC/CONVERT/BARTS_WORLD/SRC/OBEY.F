	INTEGER FUNCTION OBEY
CDEC$	IDENT	'02OC91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C
C Description:
C
	IMPLICIT	NONE
C
C	INCLUDE	'CMN:BARTSMSG.PAR'		! BARTS messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'CMN:FILE.CMN'      		! 
C
C External functions
C
	EXTERNAL	BARTS_CLD		! Command language definition
C
C Functions
C
	INTEGER		DCL_STARTUP		! Command line read and parse
	INTEGER		DCL_FILE		! Get file name
	INTEGER		DCL_QUAL		! Get a qualifier 
	INTEGER		DCL_REAL		! Get a REAL qualifier 
C
	INTEGER		FLROPN			! Open BARTS file
	INTEGER		FLWOPN			! Open TEXT file
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL		LOCAL
	LOGICAL		LOCNEG
C
C-------------------------------------------------------------------------------
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'BARTS',.FALSE.,BARTS_CLD,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Get the BARTS input filename (P1) 
C
	STATUS = DCL_FILE( 'IN_FILESPEC','BART.IDX',
     &					ABSENT,.FALSE.,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Store BARTS file length and name
C
	BARTLEN  = FIL_LEN(1)
	BARTFILE = FILARY(1)(1:BARTLEN)
C
C Get the output filename (P2)
C
	STATUS = DCL_FILE( 'TXT_FILESPEC','TXT.TXT',
     &					ABSENT,.FALSE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name
C
	TXTLEN  = FIL_LEN(1)
	TXTFILE = FILARY(1)(1:TXTLEN)
C
C Get TOLERANCE qualifier
C
C	STATUS = DCL_QUAL('TOLERANCE',HAD_TOL,LOCAL,LOCNEG,.TRUE.)
C	IF (.NOT.STATUS) GOTO 999
C
C	IF (HAD_TOL) THEN
C	   STATUS = DCL_REAL('TOLERANCE',.TRUE.)
C	   IF (.NOT.STATUS) GOTO 999
C	   TOLERANCE = RARRAY(1)
C	   IF (TOLERANCE.LE.0) THEN
C	      CALL WRITEF (' Unusable tolerance')
C	      STATUS = .FALSE.
C	      GOTO 999
C	   ENDIF
C	ENDIF
C
C Get MORPHOLOGY qualifier
C
C	STATUS = DCL_QUAL('MORPHOLOGY',HAD_MOR,LOCAL,LOCNEG,.TRUE.)
C	IF (.NOT.STATUS) GOTO 999
C
C Open input BARTS file
C
	STATUS = FLROPN(BARTLUN,BARTFILE(1:BARTLEN))
	IF (.NOT.STATUS) THEN
C	   CALL LSL_PUTMSG(BARTS__UNAOPNBART,BARTFILE(1:BARTLEN))
C	   CALL LSL_PUTMSG(STATUS)
	   CALL WRITEF ('Unable to open input file %S',
     &					BARTFILE(1:BARTLEN))
	   GOTO 999
	ENDIF
C
C Open TXT file
C
	STATUS = FLWOPN(TXTLUN,TXTFILE(1:TXTLEN))
	IF (.NOT.STATUS) THEN
C	   CALL LSL_PUTMSG(BARTS__UNACRETXT,TXTFILE(1:TXTLEN))
C	   CALL LSL_PUTMSG(STATUS)
	   CALL WRITEF ('Unable to open output file %S',
     &					TXTFILE(1:TXTLEN))
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
