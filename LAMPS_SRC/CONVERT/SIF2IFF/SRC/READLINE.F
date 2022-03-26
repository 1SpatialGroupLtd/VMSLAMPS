	INTEGER*4 FUNCTION READLINE(RETCOD)
C
CDEC$	IDENT	'02FE90'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jan-1990	J.M.Cadogan
C
C Description:
C
C	CONVERT SIF2IFF UTILITY - read a line from magtape or a file
C
	IMPLICIT	NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'CMN:LUN.PAR'		    ! logical unit numbers
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FILES.CMN'	! files
	INCLUDE 'CMN:FLAGS.CMN'	! flags
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'	! 
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions
C
	INTEGER		FLRLIN			! read a line
	INTEGER		MTIRDB			! read from tape
C
C Arguements
C
	INTEGER*4	RETCOD			! system error code
	INTEGER*4	I,J			! loop counter
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	READLINE = 1
C
C if reading from magtape, then read then next block if the maximum
C number of records per block has been reached, then the 1st
C record of the block to TXTBUF. Otherwise copy the next record
C windowed in MTBUF into TXTBUF.
C
	IF (MAGTAPE) THEN
	   IF (REC_COUNT.EQ.MAX_RECS.OR.REC_COUNT.EQ.0)THEN
	      READLINE = MTIRDB( MTBUF,BLKSIZ,MTBYTES )
	      REC_COUNT = 1
	      MTPTR = 1
	   ELSE
	      REC_COUNT = REC_COUNT + 1
	   ENDIF
	   J = 0
	   DO 100 I = MTPTR,MTPTR+(RECSIZ-1)
	      J = J + 1
	      TXTBUF(J) = MTBUF(I)
100	   CONTINUE
	   MTPTR = MTPTR + RECSIZ
	   TXTPTR = RECSIZ
	   CALL SET_TXTLIM(RECSIZ)
	ELSE
	   CALL SET_TXTLIM(80)
	   READLINE = FLRLIN(,,,RETCOD)
	ENDIF
C
	IF (HAD_DEBUG) THEN
	  CALL WRITEF
	  CALL TTWLIN(TXTBUF,80,)
	ENDIF
C	
	CALL BSLN
C
	RETURN
	END
