	LOGICAL FUNCTION FIRST_PASS
C
CDEC$	IDENT	'01NO91'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	1-Nov-1991
C
C Description:
C       Routine to perform an initial pass of the IFF file to builds a list of
C       ST addresses and the corresponding FC and widths.
C
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:CMDLIN.CMN'
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C Local Variables
C
	CHARACTER*80	CASESTAT
	CHARACTER*80	FILLSTAT
	INTEGER*4	NPTS
	LOGICAL		HAD_ST
	LOGICAL		HAD_FS
	LOGICAL		HAD_JP1
	LOGICAL		HAD_ANY_JPS
!	REAL*4		XJUN,YJUN
	INTEGER*4	STATUS		! success (or not)
!	INTEGER*2	IOVNUM		! output overlay number
!	INTEGER*2	IOVS		! 
!	INTEGER*2	IFCODE		! feature code(=FSTAT(1))
	INTEGER*2	IECODE		! entry code
	INTEGER*2	IELEN		! length of IECODE
	INTEGER*2	IENDS		! pen up/down marker
	INTEGER*2	FSTAT(4)	! from FS entry
!	INTEGER*4	JBPOS		! junction block position
!	INTEGER*4	JBOFF		! junction block offset
!	INTEGER*4	CURPOS		! current position
!	INTEGER*4	ST_ADDR		! current (or next, at start
C					! of feature) ST position
!	INTEGER*4	SEG1(2)		! addr of first segment on lines right
!	INTEGER*4	SEG2(2)		! addr of last segment on lines right
!	INTEGER*4	SEG3(2)		! addr of first segment on reversed 
C					! lines right
	INTEGER*4	SEG4(2)		! addr of last segment on reversed 
C					! lines right
C note: SEGn(1) is the address of an adjacent segment
C       SEGn(2) is the point number at which the segment joins the line we are
C               intereseted in.
C
C------------------------------------------------------------------------------
C
	STATUS=.TRUE.
C
C Give feedback to user as to what is going on..
C
	IF (HAD_CASINGS) THEN
	   CASESTAT(1:10)='Selected  '
	ELSE
	   CASESTAT(1:10)='Deselected'
	ENDIF
C
	IF (HAD_FILLS) THEN
	   FILLSTAT(1:10)='Selected  '
	ELSE
	   FILLSTAT(1:10)='Deselected'
	ENDIF
C
	IF (HAD_FRT) CALL WRITEF('FRT file:          %S',FRTFILE(1:FRTLEN))
	IF (HAD_PAR) CALL WRITEF('Parameter file:    %S',PARFILE(1:PARLEN))
	CALL WRITEF('Warning Tolerance: %F0.1',TOL)
	CALL WRITEF('Road Casings:      %S',CASESTAT(1:10))
	CALL WRITEF('Road Fills:        %S',FILLSTAT(1:10))
	CALL WRITEF('Performing initial pass of IFF file...')
C
C
C First read through file to store the width of each line with the address of
C its ST entry because when following JP address to an ST we need to know the
C line's width
C
C Need to check file is not corrupt (or even unstructured).
C
	HAD_ANY_JPS=.FALSE.
	HAD_ST=.FALSE.
	HAD_FS=.FALSE.
	HAD_JP1=.FALSE.
	STWIDPTR=0
C
10	CALL IFFNXT(IECODE,IELEN)
	IF(IELEN.LT.0) GOTO 500		! end of input
C
	IF(IECODE.EQ.'NF')THEN
	   CALL EIHRI(NF,1,1)
	   HAD_ST=.FALSE.
	   HAD_FS=.FALSE.
	   HAD_JP1=.FALSE.
	ELSEIF(IECODE.EQ.'FS')THEN
	   HAD_FS=.TRUE.
	   CALL EIHR(FSTAT,4,1)
	   IF (((FSTAT(3).AND.'4000'X).NE.0) .OR.
     &	       ((FSTAT(3).AND.'8000'X).NE.0) .OR.
     &	       (CASECODE(FSTAT(1)).LT.0) .OR.
     &	       (AREACODE(FSTAT(1)).LT.0)) THEN
	      CALL IFFNXC('EF',IELEN)
	   ENDIF
	ELSEIF(IECODE.EQ.'JP')THEN
	   HAD_ANY_JPS=.TRUE.
	   IF (.NOT.HAD_FS) GOTO 100
	   IF (.NOT.HAD_ST) THEN
	      HAD_JP1=.TRUE.
	   ENDIF
	ELSEIF(IECODE.EQ.'ST')THEN
	   HAD_ST=.TRUE.
	   CALL EIHRS(NPTS,IENDS)
	   IF (NPTS.GT.1) THEN
	      IF (.NOT.HAD_FS) GOTO 100
	      IF (.NOT.HAD_JP1) GOTO 500
	      STWIDPTR=STWIDPTR+1
	      STINFO(1,STWIDPTR)=LPOSH
	      STINFO(2,STWIDPTR)=FSTAT(1)
	      STWID(1,STWIDPTR)=CASEWIDTH(FSTAT(1))
	      STWID(2,STWIDPTR)=AREAWIDTH(FSTAT(1))
	   ENDIF
	ELSEIF(IECODE.EQ.'EF')THEN
	   IF (.NOT.HAD_ST) GOTO 100
	   IF (.NOT.HAD_FS) GOTO 100
	ENDIF
	GOTO 10
C
C Error in IFF file
C
100	STATUS=ICASE__IFFCORRUPT
	CALL LSL_PUTMSG(STATUS,NF)
	GOTO 999
C
C Reached end of file
C
500	IF (.NOT.HAD_ANY_JPS) THEN
	   STATUS=ICASE__UNSTRUCTURED
	   CALL LSL_PUTMSG(STATUS)
	ENDIF
C
999	FIRST_PASS=STATUS
C
C Rewind the file
C
	CALL IFFRWD
C
	RETURN
	END
