	SUBROUTINE USRANO(RTSTRL,RTSTR)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Description
C
C	LITES2 cartographic editor user command routines .
C
        IMPLICIT NONE
C
	INTEGER*4	RTSTRL		! input: maximum size of RTSTR
					! output: size of RTSTR
					! if 0 is returned no ANNOTATION
					! command is executed.
	CHARACTER*(*)	RTSTR		! secondary command (with
					! arguments) for the ANNOTATION
					! command
C
C all these arguments are writable.	
C
C in this version, don't do anything
C
	RETURN
	END
