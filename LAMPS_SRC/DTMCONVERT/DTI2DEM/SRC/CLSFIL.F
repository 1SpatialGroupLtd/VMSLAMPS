	LOGICAL FUNCTION CLSFIL
C
CDEC$	IDENT	'25OC89'
C
C	Copyright 			Laser-Scan Ltd., Cambridge, England.
C
C	Created						RWR	21-Nov-1985
C
C	Modified					APB	19-Oct-1989
C
C Description:
C
C 	Closes any open files
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'LSL$DTI2DEM:DTI2DEMMSG.PAR'
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
	INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
	INCLUDE		'LSL$CMNLSL:MTOVCM.CMN'
	INCLUDE 	'LSL$CMNLSL:CLD.CMN'
C
C Working storage
C
	INTEGER  	STATUS
	INTEGER		ERROR
C
C Functions
C
	LOGICAL		DTI_CLOSE
	LOGICAL		MTOEOF
	LOGICAL		FLWCLO
C
C-------------------------------------------------------------------------------
C
C Close input
C
	IF (INOP) THEN
	   STATUS=DTI_CLOSE( INLUN,.FALSE.,.FALSE.,ERROR )
	   IF (.NOT.STATUS) THEN
	      CALL LSL_PUTMSG( DTI2DEM__ERCLSDTI )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG(ERROR)
	      GOTO 999
	   ENDIF
	ENDIF
C
C Close output
C
	IF (OUTOP) THEN
	   IF (ISTAPE) THEN
C
C Write 2 EOF markers as an EOT mark
C
	      STATUS = MTOEOF()
	      STATUS = MTOEOF()
	      IF ( .NOT.STATUS ) THEN
	         CALL LSL_PUTMSG( DTI2DEM__ERRMKEOT,DEVNAM(1:DEVNAML) )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	         GOTO 999
	      ENDIF
	   ELSE
	      STATUS = FLWCLO(OUTLUN,ERROR)
	      IF (.NOT.STATUS) THEN
	         CALL LSL_PUTMSG( DTI2DEM__ERCLSDEM,FILARY(1)(1:FIL_LEN(1)) )
	         IF ( STATUS.EQ.LSL__SYSERR ) CALL LSL_ADDMSG(ERROR)
	         GOTO 999
	      ENDIF
	   ENDIF
	ENDIF
C
999	CLSFIL = STATUS
C
	RETURN
	END
