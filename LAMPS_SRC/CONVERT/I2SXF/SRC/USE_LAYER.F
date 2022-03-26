        LOGICAL*4 FUNCTION USE_LAYER(LAYER)
C
CDEC$	IDENT	'10JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Check if LAYER at hand is to be used
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
	INTEGER*2	LAYER			! current layer
	INTEGER*2	LOOP			! loop counter
C
	USE_LAYER = .TRUE.
C
      	IF (NUM_LAY .NE. 0) THEN   		! if we have a layer list
C
C Check if current layer is in the list
C
	    DO LOOP = 1,NUM_LAY
		IF ( LAY_LIST(LOOP) .EQ. LAYER) GO TO 999	! layer found
	    ENDDO
C
C No current layer is not in the list, set return to FALSE
C
	    USE_LAYER = .FALSE.
C
	ENDIF
C
C
C Return
C
  999	CONTINUE
	RETURN
C
        END
