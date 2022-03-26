	SUBROUTINE CHECK_NAME(NAME, TREE_PTR)
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
	INTEGER		FOUND,ADDED
C
C Functions
	INTEGER*4	fortran_tree_search			!C FUNCTION
	INTEGER*4	fortran_tree_add_item			!C FUNCTION
	INTEGER		NAME_END
C
C..............................................................................
C
	PTR = NAME_END(NAME,1)				!truncate to proper name
	IF (PTR.EQ.0) THEN				!unrecognised character
	  IF (NAME(1:1).NE.'$') THEN			!system var
	    CALL LCMWARN('Bad char '''//NAME(1:1)//''' in: '//NAME)
	  ENDIF
	ELSE
C
C	   ....................................................................
C	   check that the name has been declared
C
	   FOUND = fortran_tree_search(TREE_PTR, NAME(1:PTR))	!C function
C
C	   ....................................................................
C	   if name was not declared then add it to the BAD_NAME tree.
C	   if the name couldn't be added, then it was seen before
C
	   IF (FOUND.EQ.0) THEN 
	     ADDED = fortran_tree_add_item(BAD_TREE_PTR, NAME(1:PTR))
	     IF (ADDED.EQ.1) THEN 
	       CALL LCMWARN('Name not declared: '//NAME(1:PTR) )
	     ENDIF
	   ENDIF
	ENDIF
C
C..............................................................................
C
	RETURN
	END
