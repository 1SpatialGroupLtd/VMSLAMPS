	PROGRAM I2DLG
C                                        
CDEC$	IDENT	'06OC89'
C
C    Copyright Laser-Scan Ltd., Cambridge, England, U.K.
C
C
C    Created 			      FJB	10-August-1988
C
C Program I2DLG converts data in IFF disc files into 
C US DLG3 format, in ASCII code, on mag tape
C
C----------------------------------------------------------------------
C
C The output file is written in the format described in the various 
C documents describing the 
C 
C----------------------------------------------------------------------
C
	IMPLICIT NONE
C
C Parameters:
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C Common:
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
 	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
C
C Functions:
	LOGICAL		GET_COMMAND	! gets/does parse on cmd line
	LOGICAL		OPEN_FILES	! open input files and output device
	LOGICAL		IFF_SCAN	! does the conversion work
C
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C .....................................................................
C                                    
C Init. LSLLIB
	CALL LSL_INIT
C                       
C Get and decode command line
	LSL_STATUS=GET_COMMAND()
	IF (LSL_STATUS) THEN
C
C Open necessary files: IFF input, initialisation data, and ouput device	
	   LSL_STATUS=OPEN_FILES()
	   IF (LSL_STATUS) THEN
C
C Do the actual formatting work.
	      LSL_STATUS=IFF_SCAN()
C
	   ENDIF
	ENDIF
C
C Close down files
C
	CALL CLOSE_FILES
C
C Force LSL_STATUS to SS$_NORMAL if all is well
	IF (LSL_STATUS) LSL_STATUS=%LOC(SS$_NORMAL)
C
C And exit setting $STATUS as we go
C
	CALL LSL_EXIT
	END
                                     
