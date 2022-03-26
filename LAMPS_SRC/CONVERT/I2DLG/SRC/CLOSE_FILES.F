	SUBROUTINE CLOSE_FILES
C
CDEC$	IDENT	'06OC89'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C	Created 					FJB 14-Aug-1989
C
C closes any open files
C
	IMPLICIT NONE
C                                                                  
C
C Parameters:
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C Common:
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
C
C Functions
C
C Workspace:
	INTEGER*4	OK,IERR		! error codes
C
C
C ......................................................................
C
C Close input
C
	IF (IFF_IS_OPEN) CALL IFFCLO(IFFLUN)	! IFF input file
C
C ......................................................................
C
C
	RETURN         
	END
 
                  
