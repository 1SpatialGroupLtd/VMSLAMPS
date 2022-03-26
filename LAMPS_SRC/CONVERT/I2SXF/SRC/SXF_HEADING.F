        INTEGER*4 FUNCTION SXF_HEADING(IECODE,IELEN)
C
CDEC$	IDENT	'12JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					BPE	19-Jun-1990
C
C	CONVERT I2SXF Utility - Build SXF file heading
C
C Description
C
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'
	INCLUDE 'LSL$CMNLSL:EXPC.CMN' 		! LSLLIB output common
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'		! map descriptor common
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Functions called
C
	INTEGER*2	EXPAND			! text expand
	INTEGER*4	FLWLIN			! write text buffer
	INTEGER*4	TTWLIN			! write text buffer
	INTEGER*4	FLWSEL			! select output file
	INTEGER*4	PUTFLN			! put file name in common
C
C Local variables
C
	INTEGER*4	OK			! file output status
	INTEGER*4	IERR			! error code
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	IECODE			! entry type
	INTEGER*2	IELEN			! entry length
	INTEGER*2	ILEN			! output buffer length
	INTEGER*2	IYEAR			! year of execution
	INTEGER*2	IDAY			! day of execution
	INTEGER*2	IMONTH			! month of execution
	REAL*4		RABUF(4)		! range values
C
	LOGICAL*4	HAD_RANGE		! flag if range read
	LOGICAL*4	HAD_MAPD		! flag if map descriptor read
C
	CHARACTER*16	USER			! user name
	CHARACTER*16	EXCCODE                 ! execution code
	CHARACTER*32	COORDSYS		! used coordinate system
	CHARACTER*6	LOGNUMBER
C
	DATA		USER	/'Bertil          '/
	DATA		EXCCODE	/'                '/
	DATA		COORDSYS/'                                '/
	DATA		LOGNUMBER/'      '/
C
C...............................................................................
C
	HAD_RANGE = .FALSE.
	HAD_MAPD  = .FALSE.
C
	OK = PUTFLN(SXFFIL)
C
	OK = FLWSEL(SXFLUN)
	IF(OK .NE. LSL__NORMAL) THEN
	    CALL LSL_PUTMSG(I2SXF__ERRSELSXF)
	    SXF_HEADING = LSL__ILLEGLUN
	    GO TO 991
	ENDIF
C
10	CALL IFFNXT(IECODE,IELEN)
	IF (IELEN .EQ. -1 .OR. IERCD .NE. 0) GO TO 991
C
	IF (IECODE .EQ. 'RA' ) GO TO 20         ! range entry
	IF (IECODE .EQ. 'HI' ) GO TO 10		! skip history entry
	IF (IECODE .EQ. 'MH' ) GO TO 10		! skip map header entry
	IF (IECODE .EQ. 'MD' ) GO TO 30         ! map descriptor entry
C
	GO TO 100				! Go and proces data
C
C...............................................................................
C 	Range entry
C
20	CALL EIHRR(RABUF,4,1)			! read the range values
	HAD_RANGE = .TRUE.
	GO TO 10
C
C	........................................................................
C	 Map descriptor entry
C
30	CALL EIHRI(MD2ARR,MD2LEN,1)		! read map descriptor
	HAD_MAPD = .TRUE.
	GO TO 10
C
C...............................................................................
C
100	IF(HAD_RANGE .AND. HAD_MAPD) THEN
C
C	........................................................................
C	G post in SXF file
C
	    ILEN = EXPAND('G,I2SXF Ver 1.x   ,%S6,G,%S32,K,%I2;',
     &                    STR_NAM,COORDSYS,12)
	    OK = FLWLIN(EXPBUF,ILEN,IERR)
C
C	........................................................................
C	H post in SXF file
C
	    ILEN = EXPAND('H,%(6%F8.0,%)%F8.0,%I3;',
     &                     MD2LOC(2),MD2LOC(1),RABUF(3),RABUF(1),
     &	                   RABUF(4),RABUF(2),MD2SCL,20)	
	    OK = FLWLIN(EXPBUF,ILEN,IERR)
C
C	........................................................................
C	J post in SXF file
C                  
	    EXCCODE = IFFFIL
	    CALL IDATE(IMONTH,IDAY,IYEAR)
C
	    ILEN = EXPAND('J,%S16,%S16,%S6,%^W%P019%I2-%I2-%I2;',
     &                    USER,EXCCODE,LOGNUMBER,IYEAR,IMONTH,IDAY)
	    OK = FLWLIN(EXPBUF,ILEN,IERR)
C
C	........................................................................
C	I post in SXF file
C
	    ILEN = EXPAND('I,%I3,%S62;',170,'Laser Scan  VTRAK System')
	    OK = FLWLIN(EXPBUF,ILEN,IERR)
C
C	........................................................................
C	F post in SXF file
C
	    ILEN = EXPAND('F,%S62;','VIAK AB 1990')  	! free text
	    OK = FLWLIN(EXPBUF,ILEN,IERR)
C
	    SXF_HEADING = LSL__NORMAL
	ELSE
	    CALL LSL_PUTMSG(I2SXF__NORA)
	    SXF_HEADING = LSL__MISSARGS
	ENDIF
C
C...............................................................................
C Return
C
  991	CONTINUE
	RETURN
        END
