	SUBROUTINE TEXT_FCODE(FCODE,LEVEL,SYMBOL)
C
CDEC$	IDENT	'19FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	18-Feb-1993
C
C Description:
C
C	Function TEXT_FCODE called from GET_TXTSIX in ARC2I.
C	It gets the VERSION 6.0 text feature code by looking up the text
C       LEVEL and SYMBOL in the lookup table - ANNO_TAB.
C
C------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'ARC2IMSG.PAR'			! ARC2I messages
C
C Common blocks
C
	INCLUDE	'COMMANDS.CMN'			! For HAD_LOG
	INCLUDE	'TABLES.CMN'			! The lookup table ANNO_TAB
	INCLUDE	'IFFINFO.CMN'			! IFF information
C
C Arguments
C
	INTEGER*2	FCODE			! The resultant feature code
	INTEGER*4	LEVEL			! The text LEVEL
	INTEGER*4	SYMBOL			! The text SYMBOL
C
C Local Variables
C
	INTEGER*4	I			! Loop counter
C
C------------------------------------------------------------------------------
C
C Use null FC to check at end if it was set
C
	FCODE = -1
C
	DO 100 I = 1,ANNO_PTR
	   IF (ANNO_TAB(ANNO_LEV,I).EQ.-1) THEN
	      IF (ANNO_TAB(ANNO_SYM,I).EQ.SYMBOL) THEN
C
C FC derived from SYMBOL only
C
		 FCODE = ANNO_TAB(ANNO_FC,I)
		 GOTO 900
	      ENDIF
	   ENDIF
C
	   IF (ANNO_TAB(ANNO_SYM,I).EQ.-1) THEN
	      IF (ANNO_TAB(ANNO_LEV,I).EQ.LEVEL) THEN
C
C FC derived from LEVEL only
C
		 FCODE = ANNO_TAB(ANNO_FC,I)
		 GOTO 900
	      ENDIF
	   ENDIF
C
	   IF ((ANNO_TAB(ANNO_LEV,I).EQ.LEVEL) .AND.
     &	       (ANNO_TAB(ANNO_SYM,I).EQ.SYMBOL)) THEN
C
C FC derived from LEVEL amnd SYMBOL
C
	      FCODE = ANNO_TAB(ANNO_FC,I)
	      GOTO 900
	   ENDIF
100	CONTINUE
C
C Report a warning if feature code was not found in parameter file
C
	IF (FCODE.EQ.-1.AND.HAD_LOG) THEN
	   CALL LSL_PUTMSG(ARC2I__DEFAULTFC,LEVEL,SYMBOL)
	ENDIF
	FCODE = TEXT_FC
C
900	RETURN
	END
