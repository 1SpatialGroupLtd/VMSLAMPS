	LOGICAL FUNCTION OUTREC(FINAL)
C
CDEC$	IDENT	'25OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	27-Jan-1986
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C
C	Outputs a record consisting of OUTSTR
C
	IMPLICIT NONE
C
C Argument
C
	LOGICAL		FINAL		! .TRUE. if last record output
					! ie flush buffers
C 
C Parameters
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE 'LSL$DTI2DEM:DTI2DEMMSG.PAR'	! DTI2DEM message definitions
C
C Common block
C
	INCLUDE 	'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE 	'LSL$CMNLSL:MTOVCM.CMN'
C
C Local variables
C
	INTEGER		STATUS
	INTEGER		ERROR
C
C Functions
C
	LOGICAL		MTOWRB
	LOGICAL		FLWSTR
C
C-------------------------------------------------------------------------------
C
   10	FORMAT(A)
C
	IF (ISTAPE) THEN
	   WRITE(OUTBLK(BLKPTR:BLKSIZ),10) OUTSTR
	   BLKPTR=BLKPTR+RECSIZ
	   IF ((BLKPTR.GE.BLKSIZ).OR.FINAL) THEN
	      STATUS = MTOWRB(%REF(OUTBLK),BLKSIZ)
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( DTI2DEM__ERRWRTTB,DEVNAM(1:DEVNAML) )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	         GOTO 900
	      ENDIF
C
C Reset output block
C
	      BLKPTR=1
	      OUTBLK=' '
	   ENDIF
	ELSE
	   STATUS = FLWSTR( OUTSTR,ERROR )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( DTI2DEM__ERRWRTREC )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( ERROR )
	      GOTO 900
	   ENDIF
	ENDIF
C
	OUTREC=.TRUE.
C
  900	CONTINUE
	RETURN
	END
