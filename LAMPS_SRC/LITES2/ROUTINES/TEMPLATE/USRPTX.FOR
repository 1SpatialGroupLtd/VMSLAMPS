	SUBROUTINE USRPTX(TEXT,TEXTL,TS,THICK,ROT)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	 7-Dec-1988
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Dummy routine
C
        IMPLICIT NONE
C
C Arguments
C
	CHARACTER*(*)	TEXT		! text string, if text feature
	INTEGER*4	TEXTL		!  input: max size of TEXT
					! output: actual size of TEXT
	INTEGER*4	TS(4)		! feature status for texts
	INTEGER*4	THICK		! height of text
	REAL		ROT		! angle of text
C
C	All these arguments are writable.
C
C 	This routine does nothing
C
	RETURN
	END
