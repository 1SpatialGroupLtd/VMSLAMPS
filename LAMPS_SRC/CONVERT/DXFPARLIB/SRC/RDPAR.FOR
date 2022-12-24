C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1995-07-03 14:16:42.000000000 +0100
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
	LOGICAL FUNCTION RDPAR
C
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Paul Pan				21-Feb-1990 
C
CMOD1413 Add TEXT SIZE lookup to parameter file	     JB 20-Sep-1994
C
C	CONVERT I2DXF/DXF2I Utility - to read parameter file
C
C Description
C
C	This function reads the parameter file which relates 
C	DXF layers and entities with IFF feature codes,
C	and point sizes to millimetres.
C
	IMPLICIT NONE
C
C Included parameter files
	INCLUDE 'LSL$CMNDXFPAR:DXFPARMSG.PAR'	! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
C
C Local parameters
	BYTE		PLING			! comment delimiter
	PARAMETER	(PLING = '!')
C
C Common blocks
	INCLUDE 'LSL$CMNDXFPAR:LOOKUP.CMN'	! lookup tables common blocks
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
C
C Functions called
	INTEGER*4	FLROPN		! open file
	INTEGER*4	FLRCLO		! close file
	INTEGER*4	FLRLIN		! read in a line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDLAYER		! read layer entry
	LOGICAL		RDENTITY	! read entity entry
	LOGICAL		RDTEXT		! read text entry
C
C Local variables
	INTEGER		I
	LOGICAL		OK
	INTEGER*4	RESULT		! command read result
	INTEGER*4	RETCOD		! system error code
	BYTE		SINGCHAR	! character read
C
C External declaration
	INTEGER*4	DXFPAR_CMD_TABLE
	EXTERNAL	DXFPAR_CMD_TABLE
C
C---------------------------------------------------------------------
C Open PARAMETER file, read only
C
	RDPAR = FLROPN(PARLUN,PARFIL(1:PARLEN),RETCOD)
C
C If unsuccessful output message, and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(DXFPAR__ERROPNPAR,PARFIL(1:PARLEN))
	   GOTO 999
	ENDIF
C
C let them know what we are doing if that's what they'd like
C
	IF (HAD_LOG) CALL LSL_PUTMSG(DXFPAR__OPNPAR,PARFIL(1:PARLEN))
C
C Setup initial counters
C
	LINE 	   = 0
	TOTDXFLAY  = 0
	TOTDXFTEXT = 0
	CURRLAYIND = 0
	CURRENTIND = 0
	CURRSYMIND = 0
	CURRLININD = 0
	CURRTEXIND = 0
	CURREXPIND = 0			! no. of BLOCK expands
	CURTEXTIND = 0			! no. of TEXT SIZE entries
C
	DO 22 I = 1,MAXFONT
22	HAD_POINT_SIZES(I) = .FALSE.	! no TEXT SIZE entries yet
C
C Get a line
C
8000	CONTINUE
	LINE = LINE + 1
C
	RDPAR = FLRLIN(,,,RETCOD)
C
	IF (RDPAR.EQ.LSL__EOF) THEN
	   RDPAR = LSL__NORMAL		! not an error
	   GOTO 9998
	ENDIF
C
C If unsuccessful, output message, and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(DXFPAR__ERRRDPAR,LINE)
	   CALL LSL_ADDMSG(RDPAR)
	   GOTO 9998
	ENDIF
C
C Now reset the decoding pointer to the start of the line
C
	CALL BSLN
C
C Check for a comment delimiter - ignore an empty line
C
	IF (RDCHS(SINGCHAR)) GOTO 8000
C
	IF (SINGCHAR.EQ.PLING) THEN
	   GOTO 8000			! ignore line
	ELSE
	   CALL BSCH			! unread non-pling
	ENDIF
C
C Now, read the command from the line, turning off messages
C
	NOMESS = .TRUE.
	RESULT = RDCOMM(DXFPAR_CMD_TABLE)
C
C and check that there was one, if not, output message and read 
C next line
C
	IF (RESULT.EQ.0) THEN
	   CALL LSL_PUTMSG(DXFPAR__UNKPRICMD,LINE)
	   GOTO 8000
	ENDIF
C
C Despatch according to command
C
	GOTO (7000,7001,7002) RESULT
C
C IGNORE unknown command, output warning message, and continue
C
	CALL LSL_PUTMSG(DXFPAR__UNKPRICMD,LINE)
        GOTO 8000
C
C Reading LAYER
C
7000	CONTINUE
C
	OK = RDLAYER()
	IF (.NOT.OK) THEN
	   RDPAR = DXFPAR__PARFILERR
	   CALL LSL_PUTMSG(DXFPAR__PARFILERR)
	   GOTO 9998
	ENDIF
C
        GOTO 8000
C
C Reading ENTITY
C
7001	CONTINUE
C
	OK = RDENTITY()
	IF (.NOT.OK) THEN
	   RDPAR = DXFPAR__PARFILERR
	   CALL LSL_PUTMSG(DXFPAR__PARFILERR)
	   GOTO 9998
	ENDIF
C
        GOTO 8000
C
C Reading TEXT
C
7002	CONTINUE
C
	OK = RDTEXT()
	IF (.NOT.OK) THEN
	   RDPAR = DXFPAR__PARFILERR
	   CALL LSL_PUTMSG(DXFPAR__PARFILERR)
	   GOTO 9998
	ENDIF
C
        GOTO 8000
C
C Close the PARAMETER file
C
9998	CONTINUE
C
C report statistics
C
        IF (HAD_LOG) THEN
           CALL LSL_PUTMSG(DXFPAR__LAYERFND,CURRLAYIND)
           CALL LSL_PUTMSG(DXFPAR__ENTITYFND,CURRENTIND)
           CALL LSL_PUTMSG(DXFPAR__BLOCKFND,CURRSYMIND)
           CALL LSL_PUTMSG(DXFPAR__LTYPEFND,CURRLININD)
           CALL LSL_PUTMSG(DXFPAR__STYLEFND,CURRTEXIND)
        ENDIF
C
	CALL FLRCLO(PARLUN,RETCOD)
C
999	RETURN
	END
C

	LOGICAL FUNCTION RDLAYER
C
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Paul Pan				23-Feb-1990 
C
C CONVERT DXFPARLIB Utility - Read LAYER entry line in PARAMETER file
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNDXFPAR:DXFPARMSG.PAR' 	! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNDXFPAR:LOOKUP.CMN'	! lookup tables common blocks
C	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
C
C Functions called
C
	LOGICAL		READ_NAME		! read attribute name
	LOGICAL		RDINT			! read integer value
C
C Local Variables
C
	LOGICAL		ERRCOD			! OK?
	CHARACTER*30	NAME_BUF 		! an attribute name
	INTEGER*4	NAME_LEN		! its length
	INTEGER*2	LAY_BUF			! layer buffer
	INTEGER		J			! counter
C
C---------------------------------------------------------------------
C Assume that everything goes well
C
	RDLAYER = .TRUE.
C
C Read from PARAMETER file - new layer entry
C
	CURRLAYIND = CURRLAYIND + 1
C
	ERRCOD = READ_NAME(NAME_BUF,NAME_LEN)
	IF (.NOT.ERRCOD) GOTO 9001
C
	ERRCOD = RDINT(LAY_BUF)
	IF (ERRCOD .OR. LAY_BUF.LT.0) GOTO 9001
C
C Store data into lookup table
C
	DXFLAYNAM(CURRLAYIND) = NAME_BUF(1:NAME_LEN)
	DXFLAYLEN(CURRLAYIND) = NAME_LEN
        IFFOLAYNO(CURRLAYIND) = LAY_BUF
C
C test if this DXF layer is duplicated
C
	IF (CURRLAYIND.EQ.1) THEN
	   TOTDXFLAY = 1
	ELSE
           DO 2000 J = 1,CURRLAYIND - 1
              IF ( DXFLAYNAM(CURRLAYIND)(1:DXFLAYLEN(CURRLAYIND)).EQ.
     &			DXFLAYNAM(J)(1:DXFLAYLEN(J)) ) GOTO 9000
2000	   CONTINUE
           TOTDXFLAY = TOTDXFLAY + 1
        ENDIF
C
	GOTO 9000
C
C Set error code
C
9001	CONTINUE
	CALL LSL_PUTMSG(DXFPAR__ERRRDLAY,LINE)
	RDLAYER = .FALSE.
C
C Return
C
9000	RETURN
	END
C

	LOGICAL FUNCTION RDENTITY
C
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Paul Pan			22-Feb-1990 
C
C	CONVERT DXFPARLIB Utility - Read ENTITY entry
C	Reads an entity description table entry
C
C	Expects the secondary command number just read to be in 
C		SECMDN    in /CMDCOM/
C
CMOD1004	 Jon Barber			13-Jun-1991
C		 Introduce EXPAND entity to parameter to signal
C		 that the BLOCK should be expanded to the IFF file
C		 with the supplied x,y,z offsets and scalings
C
C		 Format:
C			ENTITY block_name x y z xscale yscale zscale
C
CMOD1247 Do not moan about negative colours	JB 1-Jul-1993
C
CMOD1413 Add optional font number to any ENTITY TEXT line in the
C	 parameter file:
C
C	ENTITY TEXT style col fc [font]
C
C
	IMPLICIT NONE
C
C Included parameter files
	INCLUDE 'LSL$CMNDXFPAR:DXFPARMSG.PAR' 	! message definitions
C
C Common blocks
	INCLUDE 'LSL$CMNDXFPAR:LOOKUP.CMN'	! lookup tables common blocks
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
C
C Functions called
	LOGICAL		READ_NAME		! read attribute name
	LOGICAL		RDREAL			! read real value
	LOGICAL		RDINT			! read integer value
	LOGICAL		RDCHS			! read char value
C
C Local variables
	LOGICAL		OK			! OK?
	LOGICAL		ERRCOD			! OK?
	CHARACTER*30	NAME_BUF		! an attribute name
	INTEGER*4	NAME_LEN		! its length
	INTEGER*2	COL_BUF			! colour buffer
	INTEGER*2	FC_BUF			! FC buffer
	INTEGER*2	FONT			! font number
	INTEGER		I			! local counter
	BYTE		CHAR			! character for rdchs
C
	REAL		X,Y,Z
	REAL		XSCALE,YSCALE,ZSCALE
C
C---------------------------------------------------------------------
C Assume that everything goes well
C
	RDENTITY = .TRUE.
C
C---------------------------------------------------------------------
C Test if the secondary command is valid or not
C
	IF (SECMDN.LT.1 .OR. SECMDN.GT.DXFNUMENT) THEN
	   CALL LSL_PUTMSG(DXFPAR__UNKSECCMD,LINE)
	   GOTO 9000
        ENDIF
C
C---------------------------------------------------------------------
C Despatch according to secondary command
C
	GOTO (6000,6008,6002,6003,6004,6005,6006,6007,6009,6001) 
     &	   SECMDN
C
C---------------------------------------------------------------------
C DXF POINT 
C
6001	CONTINUE                        ! point
	CURRENTIND = CURRENTIND + 1
	DXFENTTYP(CURRENTIND) = SECMDN
C
        ENTCOLOUR(CURRENTIND) = INTARG(1)
        IFFFCCODE(CURRENTIND) = INTARG(2)
	GOTO 9000
C
C---------------------------------------------------------------------
C DXF BLOCK INSERT
C
6007	CONTINUE                        ! insert
	CURRENTIND = CURRENTIND + 1
	DXFENTTYP(CURRENTIND) = SECMDN
C
	OK = READ_NAME(NAME_BUF,NAME_LEN)
	IF (.NOT.OK) GOTO 9001
C
	ERRCOD = RDINT(COL_BUF)
	IF (ERRCOD) GOTO 9001		! .OR. COL_BUF.LT.0
C
	ERRCOD = RDINT(FC_BUF)
	IF (ERRCOD .OR. FC_BUF.LT.0) GOTO 9001
C
	DXFENTNAM(CURRENTIND) = NAME_BUF
	DXFENTLEN(CURRENTIND) = NAME_LEN
        ENTCOLOUR(CURRENTIND) = COL_BUF
        IFFFCCODE(CURRENTIND) = FC_BUF
C
C test for the uniqueness of the current symbol type
C
	IF (CURRSYMIND.EQ.0) THEN
	   CURRSYMIND = CURRSYMIND + 1
	   DXFSYMBOL(CURRSYMIND) = CURRENTIND
	   GOTO 9000
C
	ELSE
	   DO 7000 I = 1,CURRSYMIND
              IF (DXFENTLEN(DXFSYMBOL(I)).EQ.NAME_LEN) THEN
                 IF (DXFENTNAM(DXFSYMBOL(I))(1:NAME_LEN).EQ.
     &			NAME_BUF(1:NAME_LEN)) GOTO 9000
	      ENDIF
7000	   CONTINUE
C
	   CURRSYMIND = CURRSYMIND + 1
	   DXFSYMBOL(CURRSYMIND) = CURRENTIND
	   GOTO 9000
	ENDIF
C
C---------------------------------------------------------------------
C DXF BLOCK EXPAND
C
6009	CONTINUE                        ! expand
C
	OK = READ_NAME(NAME_BUF,NAME_LEN)
	IF (.NOT.OK) GOTO 9001
C
	X = 0
	ERRCOD = RDREAL(X)
	IF (ERRCOD) GOTO 9001
C
	Y = 0
	ERRCOD = RDREAL(Y)
	IF (ERRCOD) GOTO 9001
C
	Z = 0
	ERRCOD = RDREAL(Z)
	IF (ERRCOD) GOTO 9001
C
	XSCALE = 1
	ERRCOD = RDREAL(XSCALE)
	IF (ERRCOD) GOTO 9001
	IF (XSCALE.LE.0) XSCALE = 1
C
	YSCALE = 1
	ERRCOD = RDREAL(YSCALE)
	IF (ERRCOD) GOTO 9001
	IF (YSCALE.LE.0) YSCALE = 1
C
	ZSCALE = 1
	ERRCOD = RDREAL(ZSCALE)
	IF (ERRCOD) GOTO 9001
	IF (ZSCALE.LE.0) ZSCALE = 1
C
C test for the uniqueness of the current symbol type
C
	IF (CURREXPIND.EQ.0) GOTO 7004		! first expand
C
	DO 7003 I = 1,CURREXPIND
           IF (EXPANDLEN(I).EQ.NAME_LEN) THEN
              IF (EXPANDNAM(I)(1:NAME_LEN) .EQ.
     &				NAME_BUF(1:NAME_LEN)) GOTO 9000
	   ENDIF
7003	CONTINUE
C
7004	CONTINUE
C
	CURREXPIND = CURREXPIND + 1
	EXPANDLEN(CURREXPIND) = NAME_LEN
	EXPANDNAM(CURREXPIND) = NAME_BUF(1:NAME_LEN)
        EXPAND_XOFF(CURREXPIND) = X
        EXPAND_YOFF(CURREXPIND) = Y
        EXPAND_ZOFF(CURREXPIND) = Z
        EXPAND_XSCL(CURREXPIND) = XSCALE
        EXPAND_YSCL(CURREXPIND) = YSCALE
        EXPAND_ZSCL(CURREXPIND) = ZSCALE
C
	GOTO 9000
C
C---------------------------------------------------------------------
C DXF LINE,CIRCLE,ARC,TRACE,SOLID and POLYLINE
C
6000	CONTINUE			! line
6002	CONTINUE                        ! circle
6003	CONTINUE                        ! arc
6004	CONTINUE			! trace
6005	CONTINUE                        ! solid
6008	CONTINUE                        ! polyline
C
	CURRENTIND = CURRENTIND + 1
	DXFENTTYP(CURRENTIND) = SECMDN
C
	OK = READ_NAME(NAME_BUF,NAME_LEN)
	IF (.NOT.OK) GOTO 9001
C
	ERRCOD = RDINT(COL_BUF)
	IF (ERRCOD) GOTO 9001		! .OR. COL_BUF.LT.0
C
	ERRCOD = RDINT(FC_BUF)
	IF (ERRCOD .OR. FC_BUF.LT.0) GOTO 9001
C
	DXFENTNAM(CURRENTIND) = NAME_BUF
	DXFENTLEN(CURRENTIND) = NAME_LEN
        ENTCOLOUR(CURRENTIND) = COL_BUF
        IFFFCCODE(CURRENTIND) = FC_BUF
C
C test for the uniqueness of the current line type
C
	IF (CURRLININD.EQ.0) THEN
	   CURRLININD = CURRLININD + 1
	   DXFLINTYP(CURRLININD) = CURRENTIND
	   GOTO 9000
C
	ELSE
	   DO 7001 I = 1,CURRLININD
              IF (DXFENTLEN(DXFLINTYP(I)).EQ.NAME_LEN) THEN
                 IF (DXFENTNAM(DXFLINTYP(I))(1:NAME_LEN).EQ.
     &			NAME_BUF(1:NAME_LEN)) GOTO 9000
	      ENDIF
7001	   CONTINUE
C
	   CURRLININD = CURRLININD + 1
	   DXFLINTYP(CURRLININD) = CURRENTIND
	   GOTO 9000
	ENDIF
C
C---------------------------------------------------------------------
C DXF TEXT
C
6006	CONTINUE           			! text
C
	CURRENTIND = CURRENTIND + 1
	DXFENTTYP(CURRENTIND) = SECMDN
C
	OK = READ_NAME(NAME_BUF,NAME_LEN)
	IF (.NOT.OK) GOTO 9001
C
	ERRCOD = RDINT(COL_BUF)
	IF (ERRCOD) GOTO 9001			! .OR. COL_BUF.LT.0
C
	ERRCOD = RDINT(FC_BUF)
	IF (ERRCOD .OR. FC_BUF.LT.0) GOTO 9001
C
C Try to read a char
C
	OK = RDCHS(CHAR)			! try to read a char
C
	IF (OK) THEN				! no char
	   GOTO 8001
C
	ELSE					! found a char
	  CALL BSCH				! unread it
	  ERRCOD = RDINT(FONT)			! get the font
C
	  IF (.NOT.ERRCOD) THEN			! got font number
	    FONTNUMBER(CURRENTIND) = FONT	! store in memory
C
	    IF (FONT.LE.0) THEN			! test it's useful
	      CALL LSL_PUTMSG(DXFPAR__ERRTEXTFONT,LINE)
	      GOTO 9001
	    ENDIF
C
	  ELSE					! not a number
	    CALL LSL_PUTMSG(DXFPAR__ERRTEXTFONT,LINE)
	    GOTO 9001
	  ENDIF
C
	ENDIF
C
8001	DXFENTNAM(CURRENTIND)  = NAME_BUF
	DXFENTLEN(CURRENTIND)  = NAME_LEN
        ENTCOLOUR(CURRENTIND)  = COL_BUF
        IFFFCCODE(CURRENTIND)  = FC_BUF
C
C test for the uniqueness of the current text style
C
	IF (CURRTEXIND.EQ.0) THEN
	   CURRTEXIND = CURRTEXIND + 1
	   DXFTEXSTY(CURRTEXIND) = CURRENTIND
	   GOTO 9000
C
	ELSE
	   DO 7002 I = 1,CURRTEXIND
              IF (DXFENTLEN(DXFTEXSTY(I)).EQ.NAME_LEN) THEN
                 IF (DXFENTNAM(DXFTEXSTY(I))(1:NAME_LEN).EQ.
     &			NAME_BUF(1:NAME_LEN)) GOTO 9000
	      ENDIF
7002	   CONTINUE
C
	   CURRTEXIND = CURRTEXIND + 1
	   DXFTEXSTY(CURRTEXIND) = CURRENTIND
	   GOTO 9000
	ENDIF
C
C---------------------------------------------------------------------
C Set error status
C
9001	CONTINUE
C
	CALL LSL_PUTMSG(DXFPAR__ERRRDENT,LINE)
	RDENTITY = .FALSE.
C
C---------------------------------------------------------------------
C Return
C
9000	RETURN
	END
C

	LOGICAL FUNCTION RDTEXT
C
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Jon Barber 				20-Sep-1994
C
CMOD1413 For optional TEXT SIZE entries in parameter file
C
C 	CONVERT DXFPARLIB Utility - Read TEXT SIZE entry line in
C	PARAMETER file
C
C
	IMPLICIT NONE
C
C Included parameter files
	INCLUDE 'LSL$CMNDXFPAR:DXFPARMSG.PAR' 	! message definitions
C
C Common blocks
	INCLUDE 'LSL$CMNDXFPAR:LOOKUP.CMN'	! lookup tables common blocks
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'		! command decoding
C
C Local variables
	INTEGER*2	FONT			! font number
	INTEGER*2	PT_SIZE			! point size
	REAL		MM_SIZE			! mm's size
C
C---------------------------------------------------------------------
C Assume that everything goes well
C
	RDTEXT = .TRUE.
C
C Despatch according to command, only SIZE at present
C
	IF (SECMDN.NE.1) THEN
	  CALL LSL_PUTMSG(DXFPAR__UNKTEXTCMD,LINE)
          GOTO 9001
	ENDIF
C
	CURTEXTIND = CURTEXTIND + 1
C
	GOTO (7000) SECMDN
C
C Reading SIZE variables
C
7000	CONTINUE
C
	FONT = INTARG(1)
	IF (FONT.LE.0 .OR. FONT.GT.MAXFONT) GOTO 9001
C
	PT_SIZE = INTARG(2)
	IF (PT_SIZE.LE.0 .OR. PT_SIZE.GT.MAXPOINT) GOTO 9001
C
	MM_SIZE = REALAR(1)
	IF (MM_SIZE.LE.0) GOTO 9001
C
C Store data in lookup table
C
	POINT_SIZES(PT_SIZE, FONT) = MM_SIZE
	HAD_POINT_SIZES(FONT) = .TRUE.
C
C Count TEXT SIZE entries
C
	IF (CURTEXTIND.EQ.1) THEN
	   TOTDXFTEXT = 1
	ELSE
           TOTDXFTEXT = TOTDXFTEXT + 1
        ENDIF
C
	GOTO 9000
C
C Set error code
C
9001	CONTINUE
C
	CALL LSL_PUTMSG(DXFPAR__ERRRDTEXT, LINE)
	RDTEXT = .FALSE.
C
C Return
C
9000	RETURN
	END
C
	LOGICAL FUNCTION READ_NAME(NAME_OUT,LEN_OUT)
C
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Paul Pan				22-Feb-1990 
C
C	CONVERT DXFPARLIB Utility - Read name from parameter file
C	Reads an attribute name from the parameter file
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'		! for string reading
C
C Arguments
C
	CHARACTER*(*)	NAME_OUT	! name to be returned
	INTEGER*4	LEN_OUT		! its lenghth
C
C Functions called
C
	INTEGER*4	READSTR		! reads a string
C
C Local Variables
C
	LOGICAL		RETVAL		! error return code
C
C---------------------------------------------------------------------
C Assume success
C
	READ_NAME = .TRUE.
C
C Initialise the string
C
	NAME_OUT = ' '
C
C Now read it in the attribute name
C
	LEN_OUT = READSTR(NAME_OUT,,ON_SPACE,,RETVAL)
C
C and check that was sucessful
C
	IF (LEN_OUT.EQ.0 .OR. .NOT.RETVAL) READ_NAME = .FALSE.
C
C Return
C
	RETURN
	END
C

	LOGICAL FUNCTION READ_FRT
C
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Paul Pan				   27-Feb-1990
C
CMOD1226	Get entity FC values for /SCAN		JB 14-Jun-1993
CMOD1343	Reduce severity of ERRFNDFC to warning  JB 22-Feb-1994
C
C	CONVERT DXFPARLIB Utility - Read FRT file
C
	IMPLICIT NONE
C
C Included Parameter Files
	INCLUDE 'LSL$CMNDXFPAR:DXFPARMSG.PAR' 	! message definitions
C
C Common Blocks
	INCLUDE 'LSL$CMNDXFPAR:LOOKUP.CMN'	! lookup tables common blocks
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'		! frt common block
C
C Functions called
	LOGICAL		FRTFND			! read each frt item
C
C Local Variables
	INTEGER		I			! local counter
	INTEGER		FC
C
C---------------------------------------------------------------------
C Assume success
C
	READ_FRT = DXFPAR__NORMAL
C
C read each FRT item in turn
C 
	DO 1000 I = 1,CURRENTIND
	   FC = IFFFCCODE(I)
           IF (FRTFND(FC, .FALSE.)) THEN	! turn off message
	      READ_FRT = DXFPAR__RDFRTERR
	      CALL LSL_PUTMSG(DXFPAR__ERRFNDFC, FC)
C
C	      GOTO 9000
C
	      GOTO 1000				! get next entry
	   ENDIF
C 
C store the return graphical type into the lookup table
C
	   FRTGTTYPE(I) = FRTGT
C
C now test if the FRT colours match those in the parameter file
C
	   IF (.NOT.HAD_QUIET) THEN
	      IF (ENTCOLOUR(I).NE.FRTCOL) CALL LSL_PUTMSG
     &			    (DXFPAR__COLNOTMAT, FC, ENTCOLOUR(I))
	   ENDIF
C
1000	CONTINUE
C
C Return
C
9000	RETURN
	END
C
