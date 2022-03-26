	SUBROUTINE ADD_WORD(INWORD)
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Add the word to the output buffer. The bytes are swapped here.
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'COMMANDS.CMN'		! Commands line switches
	INCLUDE	'GENERAL.CMN'		! General variables
C
C Local Variables
C
	INTEGER*2	DBX,DBY
	INTEGER*2	INWORD
	INTEGER*2	COPYWORD
	INTEGER*2	NEWWORD
	BYTE		COPYBYTE(2)
	BYTE		NEWBYTE(2)
C
	EQUIVALENCE	(COPYWORD,COPYBYTE(1))
	EQUIVALENCE	(NEWWORD,NEWBYTE(1))
C
C------------------------------------------------------------------------------
C
	COPYWORD = INWORD
	NEWBYTE(1) = COPYBYTE(2)	! swap dem bytes around
	NEWBYTE(2) = COPYBYTE(1)
C
	IF (DISKBUFPTR.GT.DISKBUFSIZE) CALL FLUSH
	DBY = (DISKBUFPTR-1) / DISKBLOCKSIZE + 1
	DBX = (DISKBUFPTR-((DBY-1)*DISKBLOCKSIZE))
C
	DISKBLOCK(DBX,DBY)=NEWWORD	! for final output
C	DISKBLOCK(DBX,DBY)=COPYWORD 	! for debugging on VAX - but not needed
	DISKBUFPTR = DISKBUFPTR + 1	! now that MTDUMP has /SWAP
C
	RETURN
	END
