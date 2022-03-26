        LOGICAL*4 FUNCTION USE_FC(FC)
C
CDEC$	IDENT	'10JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Check if FC at hand is to be used
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
C Local variables
C
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	LOOP			! loop counter
C
	USE_FC = .TRUE.
C
C
C
      	IF (NUM_FC .NE. 0) THEN   		! if we have a FC list
C
C Check if current FC is in the list
C
	    DO LOOP = 1,NUM_FC
		IF ( FC_LIST(LOOP) .EQ. FC) GO TO 999	! FC found
	    ENDDO
C
C No current FC is not in the list, set return to FALSE
C
	    USE_FC = .FALSE.
C
	ENDIF
C
C
C Return
C
  999 	CONTINUE
	RETURN
C
        END
