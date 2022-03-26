	SUBROUTINE CLOSE_FILES
C
CDEC$	IDENT	'01OC92'
C
C	created 	SG	01-04-92
C
C	Copyright Laser-Scan Ltd, Cambridge, England.
C
C description
C	The function closes the input and output files
C	we are not concerned with its return value.
C	
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LUNS.PAR'
C
C Functions called
	INTEGER*4	FLRCLO			!close read-only text file
	INTEGER*4	FLWDEL			!close and delete text file
	INTEGER*4	FLWCLO			!close read/write text file
C
C local variables
	INTEGER*4	RETCOD
C
C ......................................................................
C
	CALL FLRCLO(IN_LUN,RETCOD)

	IF (WIPE_OUTPUT) THEN
	  CALL FLWDEL(OUT_LUN,RETCOD)
	  IF (LIST) CALL FLWDEL(LIST_LUN,RETCOD) 
	  IF (EXPLODE) CALL FLWDEL(EXPL_LUN,RETCOD) 
	ELSE
	  CALL FLWCLO(OUT_LUN,RETCOD)
	  IF (LIST) CALL FLWCLO(LIST_LUN,RETCOD) 
	  IF (EXPLODE) CALL FLWCLO(EXPL_LUN,RETCOD) 
	ENDIF
C
C ......................................................................
C
	RETURN
	END
