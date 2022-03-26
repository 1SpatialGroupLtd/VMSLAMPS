        INTEGER*4 FUNCTION GET_SXF_CODE(FC)
C
CDEC$	IDENT	'20JN90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Find SXF code for FC at hand
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
	INCLUDE 'LSL$CMNI2SXF:TABLE.CMN'	! feature description table
C                                               
C Local variables
C
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	LOOP			! local loop counter
C
C Assume failure
C
	GET_SXF_CODE = -1
C
C
	DO LOOP=1,TABLE_LEN
	   IF(FC_TABLE(LOOP) .EQ. FC) GO TO 100
	ENDDO
C
	GO TO 200  				! feature not found
C
  100	CONTINUE				! feature found
C
	GET_SXF_CODE = SXF_TABLE(LOOP)
C
  200	CONTINUE
C
C Return
C
	RETURN
        END
