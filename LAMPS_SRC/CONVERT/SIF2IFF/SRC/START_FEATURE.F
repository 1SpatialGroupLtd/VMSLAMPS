	SUBROUTINE	START_FEATURE
C
CDEC$	IDENT	'31JA90'
C
C
C	Copyright (C)Laser-Scan Ltd., Cambridge
C	Created			12-Jan-1990			J.M. Cadogan
C
C Description:
C
C	Start a new feature
C
	IMPLICIT	NONE
C
C parameter files
C
	INCLUDE	'LSL$CMNIFF:CB.STR'	! record structure definition
C
C common blocks
C
	INCLUDE 'CMN:IFF_FEATURE.CMN'
	INCLUDE 'CMN:IFF_POINTS.CMN'
	INCLUDE 'HERE:SIF2IFF.CMN'
C
C workspace
C
	INTEGER*2	ISTAT(4)	! for the FS entry
C
C...............................................................................
C
	FSN = FSN + 1					!next feature
	ISQ = 0						!let lsllib allocat ISQ
 	CALL IFFNF( FSN, ISQ )				! start the feature
C
C	........................................................................
C	calculate all the bits of the FS entry
C
	ISTAT(1) = FC
	ISTAT(2) = 0
	ISTAT(3) = 0
C
C	for texts, assume we have the digitised position
C
	IF ( IS_TEXT ) THEN
	   CALL LIB$INSV( JUSTIF,   0, 4, ISTAT(3) )
	   CALL LIB$INSV( STYLE,    4, 2, ISTAT(3) )
	   CALL LIB$INSV( CATEGORY, 6, 6, ISTAT(3) )
	   ISTAT(3) = ISTAT(3).OR.'8000'X   		! bits 14-15 = 2(text)
	ELSEIF ( IS_SYMBOL ) THEN
	   ISTAT(3) = ISTAT(3).OR.'4000'X   		! bits 14-15 = 1(symbol)
	ENDIF
C
	CALL IFFFS( ISTAT )				!write FS entry
C
C	........................................................................
C	if we have any AC's to output, do them here - heights only.
C
	IF (HAD_AC) CALL IFFAC(3,ACVAL)
C
C	........................................................................
C	BUG FIX. SIF2IFF  often generates very large TH entries which overflow
C	integer*2 bounds. This gives unexpected values in the IFF file and
C	should be checked for bounds.
C
	IF (HEIGHT.GT.MAX_TH) THEN
	  HEIGHT = MAX_TH
	ELSEIF (HEIGHT.LT.MIN_TH) THEN
	  HEIGHT = MIN_TH
	ENDIF

 	IF ( IS_TEXT ) CALL IFFTH( HEIGHT )
C
C	........................................................................
C	
	PEN_UP = .TRUE.					!pen up for the first ST
	DONE_ZS = .FALSE.				!No STs output yet
	DONE_ST = .FALSE.				!no ZSs output yet
C
C...............................................................................
C
	DONE_START_FEATURE = .TRUE.			!return status
	RETURN
	END
