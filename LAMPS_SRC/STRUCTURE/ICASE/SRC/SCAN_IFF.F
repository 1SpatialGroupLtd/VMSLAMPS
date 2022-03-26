	LOGICAL FUNCTION SCAN_IFF
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C       Routine to read IFF file and call the routines. An initial pass of
C	the IFF file is required which builds a list of ST addresses and the
C	corresponding FC and widths.
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
C Functions called
C
	LOGICAL*4	ADJACENT_ARM
C
C Local Variables
C
	INTEGER*4	NPTS
	LOGICAL		HADST
	REAL*4		XJUN,YJUN
	INTEGER*4	STATUS		! success (or not)
	INTEGER*2	IOVNUM		! output overlay number
	INTEGER*2	IOVS		! 
	INTEGER*2	IFCODE		! feature code(=FSTAT(1))
	INTEGER*2	IECODE		! entry code
	INTEGER*2	IELEN		! length of IECODE
	INTEGER*2	IENDS		! pen up/down marker
	INTEGER*2	FSTAT(4)	! from FS entry
	INTEGER*4	JBPOS		! junction block position
	INTEGER*4	JBOFF		! junction block offset
	INTEGER*4	CURPOS		! current position
	INTEGER*4	ST_ADDR		! current (or next, at start
C					! of feature) ST position
	INTEGER*4	SEG1(2)		! addr of first segment on lines right
	INTEGER*4	SEG2(2)		! addr of last segment on lines right
	INTEGER*4	SEG3(2)		! addr of first segment on reversed 
C					! lines right
	INTEGER*4	SEG4(2)		! addr of last segment on reversed 
C					! lines right
C note: SEGn(1) is the address of an adjacent segment
C       SEGn(2) is the point number at which the segment joins the line we are
C               intereseted in.
C
C------------------------------------------------------------------------------
C
	CALL WRITEF('Generating output features...')
C
C Reset feature number in file
C
	NF=0
C
C Read in next entry
C
100	CALL IFFSEL(INLUN)
	CALL IFFNXT(IECODE,IELEN)
	IF (IELEN.LT.0) GOTO 9000
	IF (IECODE.EQ.'NF') GOTO 200
	IF (IECODE.EQ.'FS') GOTO 300
	IF (IECODE.EQ.'JP') GOTO 400
	IF (IECODE.EQ.'ST') GOTO 500
	IF (IECODE.EQ.'EF') GOTO 600
	IF (IECODE.EQ.'RA') GOTO 700
	IF (IECODE.EQ.'HI') GOTO 800
	IF (IECODE.EQ.'NO') GOTO 900
	IF (IECODE.EQ.'EO') GOTO 1000
	IF (IECODE.EQ.'EJ') GOTO 1100
	IF (IECODE.EQ.'NS') CALL EIHCPY(OUTLUN)
	IF (IECODE.EQ.'MH') CALL EIHCPY(OUTLUN)
	IF (IECODE.EQ.'MD') CALL EIHCPY(OUTLUN)
	IF (IECODE.EQ.'CC') CALL EIHCPY(OUTLUN)
	IF (IECODE.EQ.'CP') CALL EIHCPY(OUTLUN)
	GOTO 100
C
C-----------------------------------------------------------------------------
C NF entry
C
C Get FSN and reset some flags
C
200	HADST=.FALSE.
	WARNED_NF = 0		! to prevent many warnings per feature
	CALL EIHRI(NF,1,1)
	GOTO 100
C
C-----------------------------------------------------------------------------
C FS entry
C
C Get feature code
C
300	CALL EIHR(FSTAT,4,1)
	IFCODE=FSTAT(1)
C
C If text or symbol bit are set, ignore the feature.
C
	IF ((FSTAT(3).AND.'4000'X).NE.0) THEN ! ignore symbol feature
	   CALL IFFNXC('EF',IELEN)
	   GOTO 100
	ELSEIF ((FSTAT(3).AND.'8000'X).NE.0) THEN ! ignore text feature
	   CALL IFFNXC('EF',IELEN)
	   GOTO 100
	ENDIF
C
C If FC not in list in parameter file, ignore the feature.
C       
C	IF(STWID(1,IFCODE).LT.0.0 .OR. STWID(2,IFCODE).LT.0.0)THEN
	IF (CASECODE(IFCODE).LT.0 .OR. AREACODE(IFCODE).LT.0) THEN
	   CALL LSL_PUTMSG(ICASE__IGNORED,NF,IFCODE)
	   CALL IFFNXC('EF',IELEN)
	   GOTO 100
	ENDIF
	GOTO 100
C
C-----------------------------------------------------------------------------
C JP entry
C
C extract JB position
C
400	CALL EIHRL(JBPOS,1,1)
	CALL EIHR (JBOFF,1,3)
C
C save current position
C
	CURPOS=LPOSH
C
C get ST position if at start of feature
C
	IF (.NOT.HADST) THEN	! this is the first JP
	   CALL IFFNXC('ST',IELEN)
	   ST_ADDR=LPOSH
C
C extract co-ords of junction for checking against co-ords at JB
C
	   CALL EIHRS(NPTS, IENDS)
	   CALL EIHRR(XJUN,1,1)
	   CALL EIHRR(YJUN,1,3)
C
C Use first JP to get ST addresses of arms joining start of current line
C
	   STATUS = ADJACENT_ARM(JBPOS,JBOFF,ST_ADDR,-1,XJUN,YJUN,SEG1)
	   IF (.NOT.STATUS) GOTO 9999
	   STATUS = ADJACENT_ARM(JBPOS,JBOFF,ST_ADDR,1,XJUN,YJUN,SEG4)
	   IF (.NOT.STATUS) GOTO 9999
C
	ELSE			! this is the second JP
C
C Use second JP to get ST addresses of arms joining end of current line
C
	   STATUS = ADJACENT_ARM(JBPOS,JBOFF,ST_ADDR,1,XJUN,YJUN,SEG2)
	   IF (.NOT.STATUS) GOTO 9999
	   STATUS = ADJACENT_ARM(JBPOS,JBOFF,ST_ADDR,-1,XJUN,YJUN,SEG3)
	   IF (.NOT.STATUS) GOTO 9999
C
	ENDIF
C
C go back to main body of file
C
	CALL IFFPKE(IECODE,IELEN,CURPOS)
	GOTO 100
C
C-----------------------------------------------------------------------------
C ST entry
C
C Record that ST has been seen, so that we know we are at the start
C or end if a JP is encountered (these are the only possibilities)
C
500	HADST=.TRUE.
	ST_ADDR = LPOSH
C
	CALL EIHRS( NPTS, IENDS)
	IF(NPTS.LT.2)THEN	! Ignore single point features
	   CALL IFFNXC('EF',IELEN)
	   GOTO 100
	ENDIF
C
C Get last point to verify with point held at junction arm when get 2nd JP
C
	CALL EIHRR(XJUN,1,NPTS*4-3)
	CALL EIHRR(YJUN,1,NPTS*4-1)
	GOTO 100
C
C-----------------------------------------------------------------------------
C EF entry
C
C save current position
C
600	CURPOS=LPOSH
C
C Create casings 
C
	IF (HAD_CASINGS) THEN
	   CALL CREATE_CASINGS(SEG1,SEG2,SEG3,SEG4,ST_ADDR,FSTAT(1))
	ENDIF
C
C Create road fills
C
	IF (HAD_FILLS) THEN
	   CALL CREATE_FILLS(SEG1,SEG2,SEG3,SEG4,ST_ADDR,FSTAT(1))
	ENDIF
C
C go back to main body of file
C
	CALL IFFPKE(IECODE,IELEN,CURPOS)
	GOTO 100
C       
C-----------------------------------------------------------------------------
C RA entry
C
C Save address of range entry to patch in later
C
700	RAPOS=LPOSH
	CALL EIHCPY(OUTLUN)
	GOTO 100
C
C-----------------------------------------------------------------------------
C HI entry
C
C
800	CALL IFFSEL(OUTLUN)
	CALL IFFHI
	GOTO 100
C
C-----------------------------------------------------------------------------
C NO entry
C
900	CALL IFFSEL(OUTLUN)
	IOVNUM=1
	NOPOS=LPOSE
	CALL IFFNO(IOVNUM,IOVS,0)
	GOTO 100
C
C-----------------------------------------------------------------------------
C EO entry
C
1000	CALL IFFSEL(OUTLUN)
	CALL IFFUNO(NOPOS)
	CALL IFFEO
	GOTO 100
C
C-----------------------------------------------------------------------------
C EJ entry
C
1100	CALL IFFSEL(OUTLUN)
	CALL IFFEM
	CALL IFFEJ
C
C now go back and set the RA entry
C
9000	CALL IFFSEL(OUTLUN)
	CALL IFFPKE(IECODE,IELEN,RAPOS)
	IF (IECODE.NE.'RA') THEN
	   STATUS=ICASE__NORA
	   CALL LSL_PUTMSG(ICASE__NORA)
	   GOTO 9999
	ELSE
	   CALL EIHWR(RANGE,4,1)
	ENDIF
C
9999	SCAN_IFF = STATUS
	RETURN
	END
