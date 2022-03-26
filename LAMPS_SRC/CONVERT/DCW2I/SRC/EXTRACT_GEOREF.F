	LOGICAL FUNCTION EXTRACT_GEOREF(GEOSEL,GEO_NAME,GEO_LEN,
     &	                                GEO_PATH,GEO_PATHLEN)
C
CDEC$	IDENT	'16JL93'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 						ST  21-May-1992
CMOD    New message, NODIR output when tile is missing.		ST  16-Jul-1993
C       (Mod 1254).
C
C Description:
C
C       Routine to start extracting tables once at the GEOREF level
C       Incoming filename is of the form "device:[DCW.SASAUS.CL.X.E."
C       which has been tested for existance
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C Common blocks
C
	INCLUDE 'TABLES.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
C
C Arguments
C
	INTEGER*4	GEOSEL			! index no. of GEOREF selected
	CHARACTER*(*)	GEO_PATH		! working path name
	INTEGER*4	GEO_PATHLEN		! length of the above
	CHARACTER*4	GEO_NAME		! GEOREF name
	INTEGER*4	GEO_LEN			! length of the above
C       
C Functions
C
	LOGICAL		FILE_EXISTS		! check for files
	LOGICAL		EXTRACT_TILE		! extract each tile
C       
C Local workspace
C
	INTEGER*4	J,K		     	! loopy
	INTEGER*4	OK		     	! status
	CHARACTER*7	TILENAME		! working tile name
	CHARACTER*2	TILE			! working tile name
	CHARACTER*255	PATH			! working path name
	INTEGER*4	PATHLEN	     		! length of the above
C
C ......................................................................
C
	EXTRACT_GEOREF = .TRUE.		! assume success
C
	DO 200 J = 1,9
	   IF (GEO_TILE_SEL(GEOSEL,J)(1:2).NE.'  ') THEN
	      TILE(1:2) = GEO_TILE_SEL(GEOSEL,J)(1:2)
	      TILESEL(1:2) = TILE(1:2)
C
C Check of tile exists
C
	      PATHLEN = GEO_PATHLEN -1 + 1 + 2 + 4
	      PATH(1:PATHLEN) = GEO_PATH(1:GEO_PATHLEN-1)//']'//
     &		                TILE(1:2)//'.DIR'
	      IF (FILE_EXISTS(PATH(1:PATHLEN))) THEN
		 PATHLEN = GEO_PATHLEN + 3
		 PATH(1:PATHLEN) = GEO_PATH(1:GEO_PATHLEN)//
     &		                   TILE(1:2)//']'
		 TILENAME(1:GEO_LEN+2) = GEO_NAME(1:GEO_LEN)//
     &		                     TILE(1:2)
		 OK = EXTRACT_TILE(TILENAME,GEO_LEN+2,PATH,PATHLEN)
		 IF (.NOT.OK) THEN
		    CALL LSL_ADDMSG(DCW2I__SKIPTILE,TILENAME)
		    CALL WRITEF
		 ENDIF
	      ELSE
		 CALL WRITEF
		 CALL LSL_PUTMSG(DCW2I__NODIR,
     &		              GEO_PATH(1:GEO_PATHLEN-1)//'.'//TILE(1:1)//'.'//
     &			      TILE(2:2)//']',
     &		              GEO_NAME(1:GEO_LEN)//TILE(1:2))
	      ENDIF
	   ENDIF
200	CONTINUE
C
	GOTO 1000
C
C ......................................................................
C
999	EXTRACT_GEOREF = .FALSE.
1000	RETURN
	END
