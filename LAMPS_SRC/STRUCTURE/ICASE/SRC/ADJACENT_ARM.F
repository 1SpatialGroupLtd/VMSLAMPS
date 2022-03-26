	LOGICAL FUNCTION ADJACENT_ARM(JBPOS,JBOFF,ST_ADDR,DIR,NODEX,NODEY,SEG)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	14-Oct-1991
C
C Description
C	Routine called after finding ST address. The first JP address has been
C       saved and passed in as JBPOS (with JBOFF). NODEX/Y is used to verify
C       the point in the ST is the same as the node point in the JB.
C       Returns SEG containing the address and point position in ST of the
C       arm at one of the ends. Which end depends on DIR.
C
	IMPLICIT NONE
C
C Message parameters
C
	INCLUDE	'LSL$ICASE:ICASEMSG.PAR'	! ICASE messages
C
C Common Blocks
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C Arguments
C
	INTEGER*4	JBPOS,JBOFF ! Address and offset of JB
	INTEGER*4	ST_ADDR,DIR	! Address of current ST entry
	REAL		NODEX,NODEY	! XY position of node
	INTEGER*4	SEG(2)		! Line segment info
C
C Local Variables
C
	INTEGER*4	I,NUM		! general
	INTEGER*2	IECODE		! entry code
	INTEGER*2	IELEN		! length of IECODE
	INTEGER*2	NARMS		! arms of junction from JB
C
	LOGICAL		WANT_FIRST	! general flag
	LOGICAL		WANT_LAST	! general flag
C
	INTEGER*4	STATUS		! function success status
	INTEGER*4	FIRST_SEG(2)	! to save first segment info
	INTEGER*4	LAST_SEG(2)	! to save last segment info
	INTEGER*4	PREV_SEG(2)	! to save previous segment info
	INTEGER*4	CURR_SEG(2)	! to save current segment info
	REAL		XJUN,YJUN	! to be compared against NODEX/Y
C
C------------------------------------------------------------------------------
C
	STATUS=.TRUE.
C
C go to junction block and get junction position
C
	CALL IFFPKE(IECODE,IELEN,JBPOS)
C
C junction co-ords (only required for checking)
C
	CALL EIHRR(XJUN,1,JBOFF+1)
	CALL EIHRR(YJUN,1,JBOFF+3)
	IF(ABS(XJUN-NODEX).GT.0.1.OR.ABS(YJUN-NODEY).GT.0.1)THEN
	   STATUS=ICASE__ERRINNODE
	   CALL LSL_PUTMSG(STATUS,NF)
	   GOTO 9999
	ENDIF
C
C number of arms
C
	CALL EIHR(NARMS,1,JBOFF)
C
	WANT_FIRST = .FALSE.
	WANT_LAST  = .FALSE.
	NUM = 0
C
C Loop thro JB, pulling out addresses to compare to ST_ADDR
C
	DO 140 I=1,NARMS
	   CALL EIHRL(CURR_SEG(1),1,JBOFF+2+(I*3))
	   CALL EIHR (CURR_SEG(2),1,JBOFF+4+(I*3))
C       
C Save first and last values
C
	   IF (I.EQ.1) THEN
	      FIRST_SEG(1) = CURR_SEG(1)
	      FIRST_SEG(2) = CURR_SEG(2)
	   ENDIF
	   IF (I.EQ.NARMS) THEN
	      LAST_SEG(1) = CURR_SEG(1)
	      LAST_SEG(2) = CURR_SEG(2)
	   ENDIF
C
C Num set when in middle of list to be current segment position + 1
C
	   IF (I.EQ.NUM) THEN
	      SEG(1) = CURR_SEG(1)
	      SEG(2) = CURR_SEG(2)
	      GOTO 9999
	   ENDIF
C
C See if we have a match
C
	   IF (CURR_SEG(1).EQ.ST_ADDR) THEN
	      IF (DIR.LT.0) THEN
		 IF (I.EQ.1) THEN
		    WANT_LAST = .TRUE.
		 ELSE
		    SEG(1) = PREV_SEG(1)
		    SEG(2) = PREV_SEG(2)
		    GOTO 9999
		 ENDIF
	      ELSE
		 IF (I.EQ.NARMS) THEN
		    WANT_FIRST = .TRUE.
		 ELSE
		    NUM = I+1
		 ENDIF
	      ENDIF
	   ENDIF
	   PREV_SEG(1) = CURR_SEG(1)
	   PREV_SEG(2) = CURR_SEG(2)
140	CONTINUE
C       
	IF (WANT_FIRST) THEN
	   SEG(1) = FIRST_SEG(1)
	   SEG(2) = FIRST_SEG(2)
	ENDIF
C
	IF (WANT_LAST) THEN
	   SEG(1) = LAST_SEG(1)
	   SEG(2) = LAST_SEG(2)
	ENDIF
C
9999	ADJACENT_ARM=STATUS
	RETURN
	END
