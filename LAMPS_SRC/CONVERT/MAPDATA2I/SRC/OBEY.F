C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-06 14:37:32.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	INTEGER FUNCTION OBEY
C
CDEC$	IDENT	'06OC94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created						13-Nov-1989	APB
C
C	Add /LOG and /MULTIPLY 				5-Apr-1993	JDB
C
C       Now part of MAPDATA2I. New qualifiers	 	01-Sep-1994	ST
C       added. Mod 1400.
C       
C Description:
C
C	Decodes the DCL command line and sets control variables. Command line
C	qualifier values override any corresponding keyword values specified
C	in the parameter file, although the command line is interpreted first.
C
C	This routine requires a special version of DCL_QUAL, in which the
C	third and fourth return arguments are replaced, as follows:
C
C	ok = OBEY_QUAL( qualifier, had_qual, defaulted, negated, report )
C
C       out - long	ok		return status (as for LSLLIB version)
C        in - char	qualifier	qualifier name (as for LSLLIB version)
C       out - logical	had_qual	true if qualifier present, or present
C					by default (as for LSLLIB version)
C       out - logical	defaulted	true if qualifier present by default
C       out - logical	negated		true if qualifier negated (/NOxxx)
C        in - logical	report		true for local error reporting (as for
C					LSLLIB version)
C
	IMPLICIT	NONE
C
C Parameter files
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'CMN:TOLERANCES.CMN'   		! 
	INCLUDE	'CMN:FILE.CMN'      		! 
	INCLUDE	'CMN:IFF.CMN'      		! 
C
C External functions
C
	EXTERNAL	MAPDATA2I_CLD		! Command language definition
C
C Functions
C
	LOGICAL		CHECK_FC		! check FC is valid
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
	LOGICAL		DCL_INT			! Get an integer
	LOGICAL		DCL_REAL		! Get a real
	LOGICAL		DCL_STR			! Get a string
	LOGICAL		DCL_DBL			! Get a double
C
	INTEGER		FLROPN			! Open MAPDATA file
	INTEGER		IFFCREATE		! Start IFF
	LOGICAL		RDPAR			! Read PAR file
C
	INTEGER*4	OBEY_QUAL		! look for a qualifier
	INTEGER*4	CHECK_AC_CODE		! check AC code is valid
	INTEGER*4	SET_AC_DETAILS		! set up AC codes and names
C
C Local Variables
C
	INTEGER*4	OK		! status return code
C
	LOGICAL*4	ABSENT		! set if file parameter not found
	LOGICAL*4	IS_DEF		! set if qualifier present by default
	LOGICAL*4	IS_NEG		! set if qualifier negated
        LOGICAL*4	WHINGE		! set local error reporting
C
	LOGICAL*4	GOT_NAME	! got NAME keyword ?
	LOGICAL*4	GOT_CODE	! got CODE keyword ?
C
C------------------------------------------------------------------------------
C Initialisation
C
	WHINGE   = .TRUE.		! report errors locally
C
	GOT_NAME = .FALSE.
	GOT_CODE = .FALSE.
	HAD_LOG  = .FALSE.
	HAD_MULT = .FALSE.
	HAD_PAR  = .FALSE.
	HAD_FRT  = .FALSE.
	CURVE_AC_CODE = -1
        PRIO_AC_CODE  = -1
        TEXT_AC_CODE  = -1
C
C------------------------------------------------------------------------------
C Read and parse the command line
C
	OK = DCL_STARTUP( 'MAPDATA2I',.FALSE.,MAPDATA2I_CLD, WHINGE )
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C Get the MAPDATA input filename (P1) 
C
	OK = DCL_FILE( 'MAPDATA_FILESPEC','MAPDATA.MAP',
     &					ABSENT,.FALSE.,WHINGE )
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C Store MAPDATA file length and name
C
	MAPDATALEN  = FIL_LEN(1)
	MAPDATAFILE = FILARY(1)(1:MAPDATALEN)
C
C Get the IFF output filename (P2)
C
	OK = DCL_FILE( 'IFF_FILESPEC','LSL$IF:IFF.IFF',
     &					ABSENT,.FALSE.,WHINGE )
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C Store IFF file length and name
C
	IFFLEN  = FIL_LEN(1)
	IFFFILE = FILARY(1)(1:IFFLEN)
C
C------------------------------------------------------------------------------
C Get FRT file
C
	OK = OBEY_QUAL('FRT', HAD_FRT, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_FRT) THEN
	   OK = DCL_FILE('FRT','LSL$FRT:MAPDATA.FRT',
     &					ABSENT,.FALSE.,WHINGE)
	   IF (.NOT.OK) GOTO 999
C
C Save the FRT filename and its length, if present
C
	   IF (.NOT. ABSENT) THEN
	      FRTLEN  = FIL_LEN(1)
	      FRTFILE = FILARY(1)(1:FRTLEN)
	   ENDIF
	ENDIF
C
C------------------------------------------------------------------------------
C Get PAR file
C
	OK = OBEY_QUAL('PARAMETER_FILE', HAD_PAR, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_PAR) THEN
	   OK = DCL_FILE('PARAMETER_FILE','MAPDATA.PAR',
     &					ABSENT,.FALSE.,WHINGE)
	   IF (.NOT.OK) GOTO 999
C
	   PARLEN  = FIL_LEN(1)
	   PARFILE = FILARY(1)(1:PARLEN)
	ENDIF
C
C------------------------------------------------------------------------------
C Get /CURVE_AC qualifier
C
	OK = OBEY_QUAL( 'CURVE_AC', HAD_CURVE_AC, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the keywords if the qualifier is present
C
	IF (HAD_CURVE_AC) THEN
C
C /CURVE_AC NAME keyword
C
	   OK = OBEY_QUAL( 'CURVE_AC.NAME', GOT_NAME, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC name if the keyword is present
C
	   IF (GOT_NAME) THEN
	      OK = DCL_STR( 'CURVE_AC.NAME', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The name is REQUIRED, so assume there is a value
C
	      CURVE_AC_NAME = CARRAY(1)(1:STR_LEN(1))
	      CURVE_AC_LEN  = MIN(STR_LEN(1),NAME_MAX)
	   ENDIF
C
C /CURVE_AC CODE keyword
C
	   OK = OBEY_QUAL( 'CURVE_AC.CODE', GOT_CODE, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC code if the keyword is present
C
	   IF (GOT_CODE) THEN
	      OK = DCL_INT( 'CURVE_AC.CODE', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The code is REQUIRED, so assume there is a value
C
	      CURVE_AC_CODE = IARRAY(1)
C
C Check that the AC code is valid
C
	      OK = CHECK_AC_CODE(CURVE_AC_CODE)
	      IF (.NOT. OK) GOTO 999
	   ENDIF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_CURVE_AC = IS_NEG
	ENDIF
C
C------------------------------------------------------------------------------
C Get /PRIORITY_AC qualifier
C
	OK = OBEY_QUAL( 'PRIORITY_AC', HAD_PRIO_AC, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the keywords if the qualifier is present
C
	IF (HAD_PRIO_AC) THEN
C
C /PRIORITY_AC NAME keyword
C
	   OK = OBEY_QUAL('PRIORITY_AC.NAME', GOT_NAME, IS_DEF, IS_NEG, WHINGE)
	   IF (.NOT. OK) GOTO 999
C
C Get the AC name if the keyword is present
C
	   IF (GOT_NAME) THEN
	      OK = DCL_STR( 'PRIORITY_AC.NAME', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The name is REQUIRED, so assume there is a value
C
	      PRIO_AC_NAME = CARRAY(1)(1:STR_LEN(1))
	      PRIO_AC_LEN  = MIN(STR_LEN(1),NAME_MAX)
	   ENDIF
C
C /PRIORITY_AC CODE keyword
C
	   OK = OBEY_QUAL( 'PRIORITY_AC.CODE', GOT_CODE, IS_DEF, IS_NEG,WHINGE)
	   IF (.NOT. OK) GOTO 999
C
C Get the AC code if the keyword is present
C
	   IF (GOT_CODE) THEN
	      OK = DCL_INT( 'PRIORITY_AC.CODE', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The code is REQUIRED, so assume there is a value
C
	      PRIO_AC_CODE = IARRAY(1)
C
C Check that the AC code is valid
C
	      OK = CHECK_AC_CODE(PRIO_AC_CODE)
	      IF (.NOT. OK) GOTO 999
	   ENDIF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_PRIO_AC = IS_NEG
	ENDIF
C
C------------------------------------------------------------------------------
C Get /TEXT_AC qualifier
C
	OK = OBEY_QUAL( 'TEXT_AC', HAD_TEXT_AC, IS_DEF, IS_NEG, WHINGE )
	IF (.NOT. OK) GOTO 999
C
C Get the keywords if the qualifier is present
C
	IF (HAD_TEXT_AC) THEN
C
C /TEXT_AC NAME keyword
C
	   OK = OBEY_QUAL( 'TEXT_AC.NAME', GOT_NAME, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC name if the keyword is present
C
	   IF (GOT_NAME) THEN
	      OK = DCL_STR( 'TEXT_AC.NAME', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The name is REQUIRED, so assume there is a value
C
	      TEXT_AC_NAME = CARRAY(1)(1:STR_LEN(1))
	      TEXT_AC_LEN  = MIN(STR_LEN(1),NAME_MAX)
	   ENDIF
C
C /TEXT_AC CODE keyword
C
	   OK = OBEY_QUAL( 'TEXT_AC.CODE', GOT_CODE, IS_DEF, IS_NEG, WHINGE )
	   IF (.NOT. OK) GOTO 999
C
C Get the AC code if the keyword is present
C
	   IF (GOT_CODE) THEN
	      OK = DCL_INT( 'TEXT_AC.CODE', WHINGE )
              IF (.NOT. OK) GOTO 999
C
C The code is REQUIRED, so assume there is a value
C
	      TEXT_AC_CODE = IARRAY(1)
C
C Check that the AC code is valid
C
	      OK = CHECK_AC_CODE(TEXT_AC_CODE)
	      IF (.NOT. OK) GOTO 999
	   ENDIF
C
C Save flag if the qualifier is present in negated form
C
	ELSE
	   NEG_TEXT_AC = IS_NEG
	ENDIF
C
C------------------------------------------------------------------------------
C Get LOG
C
	OK = OBEY_QUAL('LOG', HAD_LOG, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
C------------------------------------------------------------------------------
C Get CURVE_SEPARATION Distance
C
	CURVE_SEP = 0.0
C
	OK = OBEY_QUAL('CURVE_SEPARATION', HAD_CURVE_SEP, IS_DEF,
     &			   IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_CURVE_SEP) THEN
	   OK= DCL_REAL ('CURVE_SEPARATION', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   IF (RARRAY(1).LT.0.0) THEN
	      CALL LSL_PUTMSG(MD2I__BADVALUE,'/CURVE_SEPARATION')
	      OK = .FALSE.
	      GOTO 999
	   ELSE
	      CURVE_SEP = RARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get CURVE_CHORD Distance
C
	CURVE_ARC = 0.0
C
	OK = OBEY_QUAL('CURVE_CHORD', HAD_CURVE_ARC, IS_DEF,
     &			   IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_CURVE_ARC) THEN
	   OK= DCL_REAL ('CURVE_CHORD', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   IF (RARRAY(1).LT.0.0) THEN
	      CALL LSL_PUTMSG(MD2I__BADVALUE,'/CURVE_CHORD')
	      OK = .FALSE.
	      GOTO 999
	   ELSE
	      CURVE_ARC = RARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get CURVE_DEVIATION Distance
C
	CURVE_ANG = 0.0
C
	OK = OBEY_QUAL('CURVE_DEVIATION', HAD_CURVE_ANG, IS_DEF,
     &			   IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_CURVE_ANG) THEN
	   OK= DCL_REAL ('CURVE_DEVIATION', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   IF (RARRAY(1).LT.0.0) THEN
	      CALL LSL_PUTMSG(MD2I__BADVALUE,'/CURVE_DEVIATION')
	      OK = .FALSE.
	      GOTO 999
	   ELSE
	      CURVE_ANG = RARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get Corner Point Separation Distance
C
	SEPARATION_DIST = 1.0
C
	OK = OBEY_QUAL('CORNER_POINT_SEPARATION', HAD_CORNER_SEP, IS_DEF,
     &			   IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_CORNER_SEP) THEN
	   OK= DCL_REAL ('CORNER_POINT_SEPARATION', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   IF (RARRAY(1).LT.0.0) THEN
	      CALL LSL_PUTMSG(MD2I__BADVALUE,'/CORNER_POINT_SEPARATION')
	      OK = .FALSE.
	      GOTO 999
	   ELSE
	      SEPARATION_DIST = RARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get MULTIPLY qualifier
C
	SCALE_FACTOR = 1.0
C
	OK = OBEY_QUAL('MULTIPLY', HAD_MULT, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_MULT) THEN
	   OK= DCL_REAL('MULTIPLY', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   IF (RARRAY(1).EQ.0.0) THEN
	      CALL LSL_PUTMSG(MD2I__BADVALUE,'/MULTIPLY')
	      OK = .FALSE.
	      GOTO 999
	   ELSE
	      SCALE_FACTOR = RARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get SCALE
C
	SCALE = 1.0
C
	OK = OBEY_QUAL('SCALE', HAD_SCALE, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_SCALE) THEN
	   OK= DCL_REAL('SCALE', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   IF (RARRAY(1).LT.0.0) THEN
	      CALL LSL_PUTMSG(MD2I__BADVALUE,'/SCALE')
	      OK = .FALSE.
	      GOTO 999
	   ELSE
	      SCALE = RARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get OFFSET qualifier
C
 	OK=OBEY_QUAL('OFFSET'		! qual. name
     &	     	     ,HAD_OFFSET	! returned .T. if qual. found
     &	     	     ,IS_DEF		! set if qual local to param
     &	             ,IS_NEG		! set if qual. negated locally
     &		     ,WHINGE)		! set-local error reporting
 	IF(.NOT.OK) GOTO 999
C
C Check for the keywords
C
 	IF (HAD_OFFSET) THEN
C
C Get X & Y coords
C
	   OK=DCL_DBL('OFFSET'		! qual. name
     &		          ,WHINGE)		! set-local error reporting
	   IF(.NOT.OK) GOTO 999
C
C Check number of args to qualifier
C
	   IF (NUMDBL.NE.2) THEN
	      CALL LSL_PUTMSG(MD2I__TWOVALUES)
	      OK = .FALSE.
	      GOTO 999
	   ENDIF
C
C Check for sensible values and store them
C
	   XOFF = DBLRAY(1)
	   YOFF = DBLRAY(2)
	ELSE
	   XOFF = 0.0
	   YOFF = 0.0
	ENDIF
C
C------------------------------------------------------------------------------
C Get DEFAULT_LINE_FC
C
	DEF_LINE_FC = 0
C
	OK = OBEY_QUAL('DEFAULT_LINE_FC', HAD_DEF_LINE, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_DEF_LINE) THEN
	   OK= DCL_INT('DEFAULT_LINE_FC', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   OK = CHECK_FC(IARRAY(1))
           IF (.NOT.OK) THEN
	      GOTO 999
	   ELSE
	      DEF_LINE_FC = IARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C Get DEFAULT_SYMBOL_FC
C
	DEF_SYM_FC = 0
C
	OK = OBEY_QUAL('DEFAULT_SYMBOL_FC',HAD_DEF_SYM, IS_DEF, IS_NEG, WHINGE)
	IF (.NOT.OK) GOTO 999
C
	IF (HAD_DEF_SYM) THEN
	   OK= DCL_INT('DEFAULT_SYMBOL_FC', WHINGE)
           IF (.NOT.OK) GOTO 999
C
C Check for sensible value
C
	   OK = CHECK_FC(IARRAY(1))
           IF (.NOT.OK) THEN
	      GOTO 999
	   ELSE
	      DEF_SYM_FC = IARRAY(1)
	   ENDIF
        ENDIF
C
C------------------------------------------------------------------------------
C
C Open input MAPDATA file
C
	OK = FLROPN(MAPDATALUN,MAPDATAFILE(1:MAPDATALEN))
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(MD2I__UNAOPN,MAPDATAFILE(1:MAPDATALEN))
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C Open, read and close PAR file and FRT file (required for PAR file)
C
	IF (HAD_PAR) THEN
	   OK = RDPAR()
	   IF (.NOT.OK) GOTO 999
	ELSE
	   OK = SET_AC_DETAILS()
	   IF (.NOT.OK) GOTO 999
	ENDIF
C
C Check  tolerances
C
	IF (SMOOTH_TOL(1).EQ.0.0 .AND.
     &	    SMOOTH_TOL(2).EQ.0.0 .AND.
     &	    SMOOTH_TOL(3).EQ.0.0) THEN
	   CALL LSL_PUTMSG(MD2I__BADTOLS)
	   OK = .FALSE.
	   GOTO 999
	ENDIF

C
C Set up smoothing tolerances
C
	CALL INTRPL_INIT(SMOOTH_TOL,1.0,.FALSE.)
C
C Open IFF file
C
	CALL IFFORV(1)
	OK = IFFCREATE(IFFLUN,IFFFILE(1:IFFLEN))
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(MD2I__UNACREIFF,IFFFILE(1:IFFLEN))
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ELSE
	   IF (HAD_LOG) THEN
	      CALL LSL_PUTMSG(MD2I__IFFOPN,IFFFILE(1:IFFLEN))
	   ENDIF
	ENDIF
C
C All done
C
999	OBEY = OK				! Return status to caller
C
	RETURN
	END
C
