	LOGICAL FUNCTION READ_SEP(CH)
C
CDEC$	IDENT	'30JA90'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - read a seperator in a SIF file
C
	IMPLICIT	NONE
C
C Parameter files
C
C
C Common Blocks
C
C
C Functions
C
	LOGICAL		RDCH			! read character
C
C Arguements
C
	CHARACTER	CH			! required seperator
C
C Workspace
C
	BYTE		ISEP			! ASCII code of CH
	BYTE		ICH			! ASCII code of found char.
	LOGICAL		EOLN			! end of line flag
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	READ_SEP = .TRUE.
C
C Get ASCII code of seperator
C
	ISEP = ICHAR(CH)
C
C Read next char
C
	EOLN = RDCH(ICH)
C
C Not got required separator - return failure
C
	IF (ICH.NE.ISEP) READ_SEP = .FALSE.
C
	RETURN
	END
