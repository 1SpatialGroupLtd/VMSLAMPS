	SUBROUTINE ADD_NAME(NAME, TREE_PTR)
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		11-06-92
C
	IMPLICIT NONE
C
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
	INCLUDE 'HERE:LCM.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Arguments
	CHARACTER*(*)	NAME
	INTEGER*4	TREE_PTR	
C
C workspace
	INTEGER		PTR
	INTEGER		RETVAL
C
C Functions
	INTEGER		fortran_tree_add_item		!C FUNCTION
	INTEGER		NAME_END			!end of alphabetic word
C
C..............................................................................
C
	PTR = NAME_END(NAME,1)				!trim to proper name

	IF (PTR.EQ.0) THEN				!unrecognised character
	  IF (NAME(1:1).NE.'$') THEN			!system var
	    CALL LCMWARN('Bad char '''//NAME(1:1)//''' in: '//NAME)
	  ENDIF
	ELSE
C
C	  ......................................................................
C	  add to tree. If unsuccessful, name was allready in tree.
C
	  RETVAL = fortran_tree_add_item(TREE_PTR, NAME(1:PTR)) !C function
C
	  IF (RETVAL.EQ.0) THEN 
	    CALL LCMWARN('Name already declared: "'//NAME(1:PTR)//'"')
	  ENDIF
	ENDIF
C
C..............................................................................
C
	RETURN
	END
