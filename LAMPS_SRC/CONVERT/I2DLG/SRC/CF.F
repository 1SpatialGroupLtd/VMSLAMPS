	INTEGER*4 FUNCTION CF( NODE_POS, INDEX1, INDEX2)
C
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C Created.					  FJB  25-Sept-1989
C
C Comparison function for sorting array of node positions
C
	IMPLICIT NONE
C
C Parameters:                                          
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C
C Workspace:
	INTEGER*2	INDEX1
	INTEGER*2	INDEX2
	INTEGER*4	NODE_POS(MAX_NODES,2)
C
	CF = 0
	IF ( NODE_POS(INDEX1,1) .LT. NODE_POS(INDEX2,1) ) THEN
	   CF = -1
	ELSEIF ( NODE_POS(INDEX1,1) .GT. NODE_POS(INDEX2,1) ) THEN
	   CF = 1
C
C If node addresses are equal then look at the offsets
	ELSE
	   IF ( NODE_POS(INDEX1,2) .LT. NODE_POS(INDEX2,2) ) THEN
	      CF = -1
	   ELSEIF ( NODE_POS(INDEX1,2) .GT. NODE_POS(INDEX2,2) ) THEN
	      CF = 1
	   ENDIF
	ENDIF
C
	RETURN
	END
