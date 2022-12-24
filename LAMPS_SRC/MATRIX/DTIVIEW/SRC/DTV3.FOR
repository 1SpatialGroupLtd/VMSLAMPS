C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1999-11-08 18:33:08.000000000 +0000
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
	LOGICAL FUNCTION IN_MENU(X_TAB,Y_TAB,CMD)
	IMPLICIT NONE
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER		X_TAB,Y_TAB	! table coords
	INTEGER		CMD		! menu command number
	INTEGER		MX,MY		! MENU coords
	IF (.NOT.MENU_SET) THEN
	  IN_MENU = .FALSE.
	  GOTO 10
	END IF
	MX = TAB_MNU(1,1)*X_TAB + TAB_MNU(1,2)*Y_TAB + TAB_MNU(1,3)+1
	MY = TAB_MNU(2,1)*X_TAB + TAB_MNU(2,2)*Y_TAB + TAB_MNU(2,3)+1
	IN_MENU = MX.GE.1.AND.MX.LE.NX_MNU.AND.
     +            MY.GE.1.AND.MY.LE.NY_MNU
	IF (IN_MENU) THEN
	  CMD = BOXMAP((NY_MNU-MY)*NX_MNU + MX)
	  IN_MENU = CMD.GT.0	
	END IF
10	END

	SUBROUTINE SET_MENU
	IMPLICIT NONE
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	INTEGER		SW(2),NW(2),SE(2),NE(2)! map corner table coords
	REAL		X_EW,Y_EW	! east to west vector
	REAL		X_NS,Y_NS	! north to south vector
	REAL		L_EW 		! east to west length
	REAL		L_NS 		! north to south length
	REAL		MYCOS,MYSIN	! a cosine and a sine
	REAL		FX,FY		! X and Y scale factors
	LOGICAL		ERR		! error
	CHARACTER*6	BELL
	PARAMETER	(BELL 		= CHAR(7)//CHAR(7)//' ')
	LOGICAL		GET_TAB_COORDS	! get a point from the table
	MENU_SET = .FALSE.		! unset any previous menu
10	CALL WRITEF('%S',BELL)
	IF(.NOT.GET_TAB_COORDS(NW(1),NW(2),'Menu NW corner')) GOTO 20
	CALL WRITEF('%S',BELL)
 	IF(.NOT.GET_TAB_COORDS(SW(1),SW(2),'Menu SW corner')) GOTO 20
	CALL WRITEF('%S',BELL)
	IF(.NOT.GET_TAB_COORDS(SE(1),SE(2),'Menu SE corner')) GOTO 20
	CALL WRITEF('%S',BELL)
	IF(.NOT.GET_TAB_COORDS(NE(1),NE(2),'Menu NE corner')) GOTO 20
	X_EW = SE(1)-SW(1)
	Y_EW = SE(2)-SW(2)
	X_NS = NW(1)-SW(1)
	Y_NS = NW(2)-SW(2)
	L_EW = SQRT(X_EW**2+Y_EW**2)
	L_NS = SQRT(X_NS**2+Y_NS**2)
	IF (ABS(X_EW*Y_NS-Y_EW*X_NS).LT.
     +	    L_EW*L_NS*SIN(82*2*3.1459265/360)) THEN
	  CALL WRITEF('%S %S',BELL,BELL)
	  CALL WRITEF('*** ERROR *** Setting up MENU')
	  CALL WRITEF('Badly digitised corner points; try again')
	  GOTO 10
	END IF
	MYCOS = X_EW/L_EW
	MYSIN = -Y_EW/L_EW
	FX = NX_MNU/L_EW
	FY = NY_MNU/L_NS
	TAB_MNU(1,1) = FX*MYCOS
	TAB_MNU(1,2) = -FX*MYSIN
	TAB_MNU(1,3) = FX*(-SW(1)*MYCOS+SW(2)*MYSIN)
	TAB_MNU(2,1) = FY*MYSIN
	TAB_MNU(2,2) = FY*MYCOS
	TAB_MNU(2,3) = FY*(-SW(1)*MYSIN-SW(2)*MYCOS)
	TAB_MNU(3,1) = 0
	TAB_MNU(3,2) = 0
	TAB_MNU(3,3) = 1
	MENU_SET = .TRUE.
20	RETURN
	END

	SUBROUTINE SET_MAP
	IMPLICIT NONE
	INTEGER*4	MAX_DTI			
	PARAMETER	(MAX_DTI=9)
	LOGICAL		DTILUN_INUSE(MAX_DTI)	!.true. if in use
	LOGICAL		READ_ONLY(MAX_DTI) !.true. if read only access
	INTEGER*4	SEC_ADDR(MAX_DTI) !addr. of start of mapped file
	INTEGER*4	SEC_SIZE(MAX_DTI) !size of mapped file(in bytes)
	CHARACTER*128	DTI_NAME(MAX_DTI)	!filename
	INTEGER*4	DTI_NAME_LENGTH(MAX_DTI)!length of filename
	INTEGER*4	HEADER_TYPE(MAX_DTI)	!1 for MIKE, 2 for UHL1,
	INTEGER*4 	DATA_OFFSET(MAX_DTI)	!data offset (in bytes)
	INTEGER*4	DATA_TYPE(MAX_DTI)	!1 for BYTE, 2 for WORD,
	INTEGER*4	X_EXTENT(MAX_DTI) !matrix x size (no. of cols)
	INTEGER*4	Y_EXTENT(MAX_DTI) !matrix y size (no. of rows)
	REAL		X_GRID(MAX_DTI)		!x grid interval
	REAL		Y_GRID (MAX_DTI)	!y grid interval
	REAL		MIN_RVALUE(MAX_DTI)	!min real data value
	REAL		MAX_RVALUE(MAX_DTI)	!max real data value
	INTEGER*4	MIN_LVALUE(MAX_DTI)	!min longword data val
	INTEGER*4	MAX_LVALUE(MAX_DTI)	!max longword data val
	INTEGER*2	MIN_WVALUE(MAX_DTI)	!min byte/word data val
	INTEGER*2	MAX_WVALUE(MAX_DTI)	!max byte/word data val
	LOGICAL		HAD_PROJ_RECORD(MAX_DTI)
	INTEGER*4	LATREC(4,MAX_DTI)	!latitude and longitude 
	INTEGER*4	LONREC(4,MAX_DTI)	!values of the 4 corners
	INTEGER*4	LATORI(MAX_DTI)		!latitude origin 
	INTEGER*4	LONORI(MAX_DTI)		!longitude origin 
	INTEGER*4	LATINT(MAX_DTI)		!latitude grid interval 
	INTEGER*4	LONINT(MAX_DTI)		!longitude grid interval
	REAL		X_OFFSET(MAX_DTI)	!absolute position of
	REAL		Y_OFFSET(MAX_DTI)	!column 1, row 1
	INTEGER*4	DTI_WINDOW_SWX(MAX_DTI)!current area of interest
	INTEGER*4	DTI_WINDOW_SWY(MAX_DTI) !in the DTI file, 
	INTEGER*4	DTI_WINDOW_NEX(MAX_DTI) !specified
	INTEGER*4	DTI_WINDOW_NEY(MAX_DTI)	!in matrix units
	INTEGER*4	DTI_ORDER_CORNER(MAX_DTI)
	INTEGER*4	DTI_ORDER_DIRECTION(MAX_DTI)	
	COMMON/DTIHDR/	X_GRID,Y_GRID,MIN_RVALUE,MAX_RVALUE,
     &			MIN_LVALUE,MAX_LVALUE,X_EXTENT,Y_EXTENT,
     &			LATREC,LONREC,LATORI,LONORI,LATINT,LONINT,
     &			SEC_ADDR,SEC_SIZE,DATA_OFFSET,
     &			MIN_WVALUE,MAX_WVALUE,
     &			HEADER_TYPE,DATA_TYPE,DTI_NAME,DTI_NAME_LENGTH,
     &			DTILUN_INUSE,X_OFFSET,Y_OFFSET,
     &			DTI_WINDOW_SWX,DTI_WINDOW_SWY,
     &			DTI_WINDOW_NEX,DTI_WINDOW_NEY,
     &                  READ_ONLY,HAD_PROJ_RECORD,
     &                  DTI_ORDER_CORNER,DTI_ORDER_DIRECTION
	INTEGER*4	BOXMAP(8*13)	! maps Imenu -> Icommand
	INTEGER*4	NX_MNU,NY_MNU	! num of menu cols and rows
	LOGICAL*1	MENU_SET	! menu located?
	LOGICAL*1	MAP_SET		! map located?
	LOGICAL*1	CMDFIL		! input from command file?
	LOGICAL*1	CTRLC		! had a CTRL/C?
	COMMON/DTICMN/	BOXMAP,NX_MNU,NY_MNU,
     &			MENU_SET,MAP_SET,CMDFIL,CTRLC
	COMMON/TRANS/	TAB_DTI,TAB_MNU,IFF_DTI
	REAL		TAB_DTI(3,3)	! transf TABLE to DTI  coords
	REAL		TAB_MNU(3,3)	! transf TABLE to MENU coords
	REAL		IFF_DTI(3,3)	! transf IFF   to DTI  coords
	INTEGER		SW(2),NW(2),SE(2),NE(2)! map corner table coords
	REAL		X_EW,Y_EW	! east to west vector
	REAL		X_NS,Y_NS	! north to south vector
	REAL		L_EW 		! east to west length
	REAL		L_NS 		! north to south length
	REAL		MYCOS,MYSIN	! a cosine and a sine
	REAL		FX,FY		! X and Y scale factors
	CHARACTER*6	BELL
	PARAMETER	(BELL 		= CHAR(7)//' ')
	LOGICAL		GET_TAB_COORDS	! get a point in table coords
	MAP_SET = .FALSE.		! unset any previous map
10	CALL WRITEF('%S',BELL)
	IF(.NOT.GET_TAB_COORDS(NW(1),NW(2),'Map NW corner')) GOTO 20
	CALL WRITEF('%S',BELL)
 	IF(.NOT.GET_TAB_COORDS(SW(1),SW(2),'Map SW corner')) GOTO 20
	CALL WRITEF('%S',BELL)
	IF(.NOT.GET_TAB_COORDS(SE(1),SE(2),'Map SE corner')) GOTO 20
	CALL WRITEF('%S',BELL)
	IF(.NOT.GET_TAB_COORDS(NE(1),NE(2),'Map NE corner')) GOTO 20
	X_EW = SE(1)-SW(1)
	Y_EW = SE(2)-SW(2)
	X_NS = NW(1)-SW(1)
	Y_NS = NW(2)-SW(2)
	IF ((X_EW .LT. 0.00001).OR. (Y_NS .LT. 0.00001)) THEN
	  CALL WRITEF('%S digitising corners',BELL)
	  CALL WRITEF('Two Points are coincident')
	  GOTO 10
	ENDIF  	   
	L_EW = SQRT(X_EW**2+Y_EW**2)
	L_NS = SQRT(X_NS**2+Y_NS**2)
	IF (ABS(X_EW*Y_NS-Y_EW*X_NS).LT.
     +	    L_EW*L_NS*SIN(88*2*3.1459265/360)) THEN
	  CALL WRITEF('%S %S',BELL,BELL)
	  CALL WRITEF('*** ERROR *** Setting up MAP')
	  CALL WRITEF('Badly digitised corner points; try again')
	  GOTO 10
	END IF
	MYCOS = X_EW/L_EW
	MYSIN = -Y_EW/L_EW
	FX = X_EXTENT(1)/L_EW
	FY = Y_EXTENT(1)/L_NS
	TAB_DTI(1,1) = FX*MYCOS
	TAB_DTI(1,2) = -FX*MYSIN
	TAB_DTI(1,3) = FX*(-SW(1)*MYCOS+SW(2)*MYSIN)+1
	TAB_DTI(2,1) = FY*MYSIN
	TAB_DTI(2,2) = FY*MYCOS
	TAB_DTI(2,3) = FY*(-SW(1)*MYSIN-SW(2)*MYCOS)+1
	TAB_DTI(3,1) = 0
	TAB_DTI(3,2) = 0
	TAB_DTI(3,3) = 1
	MAP_SET = .TRUE.		! map set successfully
20	RETURN
	END

	SUBROUTINE OPEN_COMMAND_FILE
	IMPLICIT NONE
	INTEGER*4	NLINES		! number of lines in model
	INTEGER*4	NPTS		! number of columns in model
	INTEGER*4	DTMSWX		! model SW x value
	INTEGER*4	DTMSWY		! model SW y value
	INTEGER*4	DTMNEX		! model NE x value
	INTEGER*4	DTMNEY		! model NE y value
	INTEGER*4	DTMOFX		! model x offset from DEM origin
	INTEGER*4	DTMOFY		! model y offset from DEM origin
	INTEGER*2	MODMIN		! model minimum height value
	INTEGER*2	MODMAX		! model maximum height value
	INTEGER*4	UNITS		! current units of measurement
	INTEGER*4	X_SAMPLE	! sampling interval along cols
	INTEGER*4	Y_SAMPLE	! sampling interval along rows
	LOGICAL*4	FISHNET		! fishnet representation?
	LOGICAL*4	HAD_ABSOLUTE	! absolute coords? 
	LOGICAL*4	GEOGRAPHICALS_OK ! geographical units allowed
	CHARACTER*16	ERROR_BELL	! for noisy ERROR message
	PARAMETER      (ERROR_BELL= CHAR(7)//CHAR(7)//'*** ERROR ***')
	CHARACTER*18	WARN_BELL	! for noisy WARNING message
	PARAMETER      (WARN_BELL= CHAR(7)//CHAR(7)//'*** WARNING ***')
	COMMON /MODEL/  NLINES,NPTS,DTMSWX,DTMSWY,DTMNEX,DTMNEY,
     &			DTMOFX,DTMOFY,
     &			MODMIN,MODMAX,
     &			UNITS,X_SAMPLE,Y_SAMPLE,FISHNET,HAD_ABSOLUTE,
     &  		GEOGRAPHICALS_OK
	COMMON/	DTEQIO/ISB,IN_CHAN,OUT_CHAN,TERM,TTOPRO,TTIDON,TTODON,
     &			HADQIO,TTOBEL,HAD_INDIRECT_FILE
	INTEGER*2 ISB(4)	! input status block
	INTEGER*2 ISB_STATUS	! status
	INTEGER*2 ISB_TOFF	! offset to terminator
	INTEGER*2 ISB_TSIZ	! terminator size
	INTEGER*2 ISB_TRM	! the terminator itself
	EQUIVALENCE(ISB(1),ISB_STATUS)
	EQUIVALENCE(ISB(2),ISB_TOFF)
	EQUIVALENCE(ISB(3),ISB_TRM)
	EQUIVALENCE(ISB(4),ISB_TSIZ)
	INTEGER		IN_CHAN	! input channel number
	INTEGER		OUT_CHAN! output channel number
	LOGICAL*1	TERM	! output is a terminal
	LOGICAL*1	TTOPRO	! next output is a prompt
	LOGICAL*1	TTOBEL	! output with no carriage controls
	LOGICAL*1	TTIDON	! had input since last prompt
	LOGICAL*1	TTODON	! had output since last prompt
	LOGICAL*1	HADQIO	! QIO outstanding
	LOGICAL*1	HAD_INDIRECT_FILE	! input from indirect file
	CHARACTER*128	FILENAME	! file name
	INTEGER*4	FILENAME_LEN	! length of filename
	BYTE		CH		! single character
	INTEGER*4	RETVAL		! function return
	INTEGER*4	ERROR 		! system error return
	INTEGER*4	GETFILNAM	! parse filename
	LOGICAL		RDCHS		! read character
	INTEGER*4 	FLROPN		! open the indirect command file
	IF(HAD_INDIRECT_FILE)THEN
	  CALL WRITEF('%S Specifying command @',ERROR_BELL)
	  CALL WRITEF('Nested command files not supported')
	  GOTO 999
	ENDIF
	IF(RDCHS(CH))THEN
	  CALL WRITEF('%S Specifying command @',ERROR_BELL)
	  CALL WRITEF('Command file specification is missing')
	  GOTO 999
	ENDIF
	CALL BSCH
	RETVAL = GETFILNAM(FILENAME,FILENAME_LEN,
     &                     'SYS$DISK:[].COM;0',.TRUE.,%REF('!'))
	IF (.NOT.RETVAL) THEN
	  CALL LSL_PUTMSG(RETVAL)
	  GOTO 999
	ENDIF
	RETVAL = FLROPN(9,FILENAME,ERROR,)
	IF(.NOT. RETVAL)THEN
	   CALL WRITEF
     &     ('%S Unable to open indirect command file %S',
     &     ERROR_BELL,FILENAME(1:FILENAME_LEN))
	   CALL LSL_PUTMSG(RETVAL)
	   GOTO 999
	ENDIF
	HAD_INDIRECT_FILE=.TRUE.
999	RETURN
	END
