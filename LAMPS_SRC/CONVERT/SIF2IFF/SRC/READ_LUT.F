	LOGICAL FUNCTION READ_LUT
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Read the LUT for FC to CCSM conversion
C
	IMPLICIT	NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:LUN.PAR'			! logical unit numbers
	INCLUDE	'CMN:SIF2IFFMSG.PAR'		! messages
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'CMN:FILES.CMN'
	INCLUDE 'CMN:LUT.CMN'
C
	INTEGER		STATUS
	INTEGER*4	RETCOD		! system error code
	INTEGER		I
	INTEGER*2	LENGTH		! Number of bytes in record A
	PARAMETER	( LENGTH=32 )
C
	LOGICAL		FLROPN
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		RDINT
	LOGICAL		READSTR
C
C-------------------------------------------------------------------------------
C
C Assume succes
C
	READ_LUT = .TRUE.
C
	STATUS = FLROPN( LUTLUN,LUTFIL(1:LUTLEN),RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. STATUS) THEN
	   CALL LSL_PUTMSG(SIF2IFF__ERROPNPAR,LUTFIL(1:LUTLEN))
	   CALL LSL_ADDMSG(STATUS)
	   IF (STATUS .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   READ_LUT = .FALSE.
	   GOTO 999
	ENDIF
C
	CALL SET_TXTLIM( LENGTH )	! Number of bytes in text buffer	
	NUMFC = 0
100	CONTINUE
	   STATUS = FLRLIN()
	   IF ( STATUS .EQ. LSL__EOF ) GOTO 200
	   IF ( CHAR(TXTBUF(1)) .EQ. '!' ) GOTO 100
	   NUMFC = NUMFC + 1
	   CALL BSLN
	   STATUS = RDINT( FC_CCSM_LUT(NUMFC).FC )
	   FC_CCSM_LUT(NUMFC).CCSM = '            '
	   STATUS = READSTR( FC_CCSM_LUT(NUMFC).CCSM(1:2) )
	   STATUS = READSTR( FC_CCSM_LUT(NUMFC).CCSM(4:8) )
	   STATUS = READSTR( FC_CCSM_LUT(NUMFC).CCSM(10:12) )
	   GOTO 100
C
200	CONTINUE
C
	STATUS = FLRCLO(LUTLUN)
C
999	RETURN
	END
