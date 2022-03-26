	SUBROUTINE	CONDAT
C
CDEC$	IDENT	'30JA90'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - Convert SIF data
C
	IMPLICIT	NONE
C
C Parameter files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'		! messages
	INCLUDE 'CMN:LUN.PAR'			! logical unit numbers
C
C Common Blocks
C
	INCLUDE 'CMN:FILES.CMN'
C
C Functions
C
	LOGICAL		RDSIF			! read SIF parameters
	LOGICAL		WRITE_START		! initial IFF info
C
C Workspace
C
	LOGICAL		OK			! function call status
C
C-------------------------------------------------------------------------------
C
C
C Write IFF file header info.
C
	OK = WRITE_START()
	IF (.NOT.OK) GOTO 999
C
C Read command string from SIF file
C
	OK = RDSIF()
	IF (.NOT.OK) THEN
	   CALL LSL_EXIT
	   GOTO 999
	ENDIF
C
C Write stuff to end the IFF file then close
C
	CALL WRITE_END
C
C And thats it.
C
999	RETURN
	END
