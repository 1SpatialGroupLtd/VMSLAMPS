        SUBROUTINE REPORT
C
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Report on what we are doing
C
C Description
C
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Report on things we get straight from the command line
C
100	CALL WRITEF(' ')
	CALL WRITEF('Parameter file      : %S',PARFIL(1:PARLEN))
	IF (HAD_FRT)
     +	CALL WRITEF('FRT file            : %S',FRTFIL(1:FRTLEN))
	CALL WRITEF('IFF input  file     : %S',IFFFIL(1:IFFLEN))
	CALL WRITEF('SXF output file     : %S',SXFFIL(1:SXFLEN))
C
	IF (NUM_LAY .NE. 0) CALL WRITEF('Selecting by layer')
	IF (NUM_FC  .NE. 0) CALL WRITEF('Selecting by feature code')
	IF (HAD_LOG) THEN
	   CALL WRITEF('Outputting supplementary messages')
	   CALL WRITEF(' ')
	ENDIF
C
C Return
C
	RETURN
        END
