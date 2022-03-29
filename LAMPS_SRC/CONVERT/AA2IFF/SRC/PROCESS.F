	SUBROUTINE 	PROCESS
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C
C Description:
C
C	Process the AA file
C
	IMPLICIT	NONE
	INCLUDE 'CMN:AA.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
	INCLUDE 'LSL$CMNIFF:MHDEF.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
C
	INCLUDE 'CMN:IFF.PAR'
C
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
	INTEGER		STATUS
	INTEGER		ERROR
C
	LOGICAL 	TTRSTR
	LOGICAL 	FLROPN
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		RDLONG
	LOGICAL		READSTR
	LOGICAL		RDCH
	LOGICAL		RDINT
	LOGICAL		RDREAL
C
	INTEGER		RECNUM
	INTEGER		LEN
	INTEGER		I
	BYTE		ICH
	INTEGER*2	FC_PART1
	INTEGER*2	FC_PART2
	INTEGER*2	OLDLAYER
	INTEGER*2	LAYER
	INTEGER		XYVAL
	REAL		X,Y
	INTEGER*2	AXIS
	REAL		PI
	PARAMETER	(PI=3.1415926)
	LOGICAL		FIRST_FEATURE
C
C Record types
C
	CHARACTER*7	RECTYPE
	CHARACTER*7	SEGMENT
	CHARACTER*4	CODE
	CHARACTER*1	CHARNUM
C
C-------------------------------------------------------------------------------
C
	STATUS = FLROPN( 2, AAFILE(1:AALEN) )
	IS_LINE = .TRUE.
	FIRST_FEATURE = .TRUE.
	SEGMENT = 'SEGMENT'
	CODE = 'CODE'
C
C Read the header record first
C
	RECNUM = 0
	CALL SET_TXTLIM(80)
	STATUS = FLRLIN()
	CALL BSLN
	XMIN = 0.0
	YMIN = 0.0
	STATUS = RDREAL(XMAX)
C
	STATUS = RDREAL(YMAX)
C
C Control points for IFF section
C
 	CPS(1,1) = REAL(XMIN - XMIN)
 	CPS(2,1) = REAL(YMAX - YMIN)
 	CPS(1,2) = REAL(XMIN - XMIN)
 	CPS(2,2) = REAL(YMIN - YMIN)
 	CPS(1,3) = REAL(XMAX - XMIN)
 	CPS(2,3) = REAL(YMIN - YMIN)
 	CPS(1,4) = REAL(XMAX - XMIN)
 	CPS(2,4) = REAL(YMAX - YMIN)
C
	CALL IFF_START		! Write start of IFF file
C
C	
C Now read the data for real
C
	CALL SET_TXTLIM(80)
500	STATUS = FLRLIN()
	IF ( STATUS .EQ. LSL__EOF ) GOTO 999
501	CALL BSLN
	LEN = READSTR(RECTYPE,,ON_SPACE)
	RECNUM = RECNUM + 1
	CALL WRITEF( 'Record #%^L%I0 is type %S',RECNUM,RECTYPE(1:LEN) )
C
C SEGMENT command
C
	IF ( RECTYPE(1:LEN) .EQ. SEGMENT) THEN
	   STATUS = RDLONG(FSN)
	   CALL WRITEF( 'FSN #%^W%I0',FSN )
	   GOTO 500
C
C CODE command
C
	ELSEIF( RECTYPE(1:LEN) .EQ. CODE) THEN
C
C read 1st digit - first part of FC
C
	   STATUS = RDCH(ICH)
	   STATUS = RDCH(ICH)
	   CHARNUM = CHAR(ICH)
	   READ(CHARNUM,*) FC_PART1
	   CALL WRITEF( 'FC_PART1 #%^W%I0',FC_PART1 )
C
C
C read 2nd digit - layer number
C
	   STATUS = RDCH(ICH)
	   CHARNUM = CHAR(ICH)
	   READ(CHARNUM,*) LAYER
	   IF (FIRST_FEATURE) THEN
	      CALL IFFNO(LAYER,0,0)		! start new layer
	      OLDLAYER = LAYER
	      CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	   ENDIF   
C
	   IF (OLDLAYER.NE.LAYER) THEN
	      CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	      CALL IFFEO			! end the layer
C
	      LPOSNO = LPOSE
	      CALL IFFNO(LAYER,0,0)		! start new layer
	      OLDLAYER = LAYER
	      CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	   ENDIF
C
C read 3rd digit - skip the point
C
	   STATUS = RDCH(ICH)
C
C read last two digits as a number - second part of FC
C
	   STATUS = RDINT(FC_PART2)
C
	   FC = (FC_PART1*1000) + FC_PART2
	   CALL WRITEF( 'FC_PART2 #%^W%I0',FC_PART2 )
C
	   IF (FIRST_FEATURE) FIRST_FEATURE = .FALSE.
	   GOTO 500
C
C Read block of coords.
C
	ELSE
	   CALL BSLN
	   CALL START_FEATURE
C
20	   STATUS = RDREAL(X)
	   IF (STATUS) THEN
	      CALL WRITE_FEATURE
	      GOTO 501
	   ENDIF
	   STATUS = RDREAL(Y)
	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1)',X,Y )
	   CALL COORD( X,Y )

	   STATUS = FLRLIN()
	   CALL BSLN
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      CALL WRITE_FEATURE
	      GOTO 999
	   ENDIF
	   GOTO 20
	ENDIF
C
C Tidy up
C
999	CONTINUE
C
C Finish off the IFF file
C
	CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	CALL IFFEO			! end the layer
	CALL IFFEM			! end the map
	CALL IFFEJ			! end the 'job'
C
C and close it
C
	STATUS = FLRCLO(2)
C
	RETURN
	END
