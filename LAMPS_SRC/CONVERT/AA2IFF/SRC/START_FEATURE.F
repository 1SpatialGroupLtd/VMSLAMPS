	SUBROUTINE	START_FEATURE
CDEC$	IDENT	'18AP91'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C	Created				9-Nov-1989	A.P.Brown
C	Mod				9-Apr-1991	J Barber
C
C Description:
C
C	Start a new feature.
C
C	AA2IFF:
C 	This routine is called by AA2IFF before all the coords have been
C	read, so the default of 0 may give a line FC for a one point symbol
C
C	AAGAZ2IFF:
C	IS_TEXT true signifies called by AAGAZ2IFF, so check that the FC
C	(either from par file or default of 999 if missing from supplied
C	par file; or AA code derivation for no par file) is a TEXT
C
C
	IMPLICIT	NONE
C
C parameter files
C
	INCLUDE	'LSL$CMNFRT:FRTCOM.CMN'	! FRT definitions
C
C common blocks
C
	INCLUDE 'CMN:AA2IFFMSG.PAR'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C functions
	LOGICAL		FRTFND
C
C workspace
C
	INTEGER*2	ISTAT(4)	! for the FS entry
	LOGICAL		OK
C
	DATA	HEIGHT  / 6 /		! Fixed pointsize
C
C-------------------------------------------------------------------------------
C calculate all the bits of the FS entry
C
	ISTAT(1) = FC
C
	ISTAT(2) = 0
	ISTAT(3) = 0
C
C AA2IFF feature codes are linear by default, unles the parameter file 
C specifies a symbol FC for single coordinate entries
C AAGAZ2IFF feature codes are always texts and IS_TEXT .TRUE.
C
	IS_SYMBOL = .FALSE.
C
C Check FRT file for FC to get symbol GT 
C
	IF (HAD_PAR) THEN
	   OK = FRTFND(FC,.FALSE.)
	   IF (OK) CALL LSL_PUTMSG(AA2I__ERRFNDFC, FC)
C
	   IF (FRTGT.EQ.UNOTYP .OR. FRTGT.EQ.ORITYP .OR.
     &	       FRTGT.EQ.SCATYP) IS_SYMBOL = .TRUE.
C
	   IF (IS_TEXT .AND. FRTGT.NE.TEXTYP) 
     &			CALL LSL_PUTMSG(AA2I__NOTEXTFTR,FC)
	ENDIF
C
C for texts (set in AAGAZ2IFF), assume we have the digitised position
C
	IF ( IS_TEXT ) THEN
	   CALL LIB$INSV( JUSTIF,   0, 4, ISTAT(3) )
	   CALL LIB$INSV( STYLE,    4, 2, ISTAT(3) )
	   CALL LIB$INSV( CATEGORY, 6, 6, ISTAT(3) )
	   ISTAT(3) = ISTAT(3).OR.'8000'X   ! bits 14-15 = 2 (text)
	ELSEIF ( IS_SYMBOL ) THEN
	   ISTAT(3) = ISTAT(3).OR.'4000'X   ! bits 14-15 = 1 (symbol)
	ENDIF
C
C so write the FS entry
C
	CALL IFFFS( ISTAT )
C
C Write a fixed Text Height (pointsize 6)
C
 	IF (IS_TEXT) CALL IFFTH(HEIGHT)
C
C signal pen up for the first ST
C
	PEN_UP = .TRUE.
C
C and we haven't output any ZS/ST's for this feature yet
C
	DONE_ZS = .FALSE.
C
C so we've finished START_FEATURE
C
	DONE_START_FEATURE = .TRUE.
C
C and that's it
C
	RETURN
	END
C