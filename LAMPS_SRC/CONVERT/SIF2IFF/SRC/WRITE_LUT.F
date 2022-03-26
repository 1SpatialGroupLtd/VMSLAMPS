	SUBROUTINE 	WRITE_LUT
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Write the new LUT for FC to CCSM conversion
C
	IMPLICIT	NONE
C
	INCLUDE 'CMN:LUN.PAR'
C
	INCLUDE 'LSL$CMNLSL:EXPC.CMN'		! LSLLIB expand buffer
	INCLUDE 'CMN:FILES.CMN'
	INCLUDE 'CMN:LUT.CMN'
C
	INTEGER		STATUS
	INTEGER		I
	INTEGER*2	LENGTH		! Number of bytes in record A
	PARAMETER	( LENGTH=32 )
C
	LOGICAL		FLWOPN
	LOGICAL		FLWLIN
	LOGICAL		FLWCLO
	INTEGER*2	EXPAND
	LOGICAL		RDINT
	LOGICAL		READSTR
C
	INTEGER*2	LEN
C
C-------------------------------------------------------------------------------
C
	STATUS = FLWOPN( NEWLUTLUN,NEWLUTFIL )
	IF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( STATUS )
	   STOP '%SIF2IFF-F-ABORT exiting with error status'
	ENDIF
C
C
	DO 100 I = 1, NUMFC
	   LEN = EXPAND( '%^W%I3   %S   !',
     &                   FC_CCSM_LUT(I).FC,
     &                   FC_CCSM_LUT(I).CCSM )
	   STATUS = FLWLIN( EXPBUF )
100	CONTINUE
C
	STATUS = FLWCLO(NEWLUTLUN)
C
	RETURN
	END
