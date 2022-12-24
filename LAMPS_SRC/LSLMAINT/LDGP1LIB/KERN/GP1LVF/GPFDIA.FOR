C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-02-17 11:14:44.000000000 +0000
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
C[0z[1w[10m[9;188s

C=====================================================================
C 718.300.0700   GP1LIB -- GP1 FORTRAN LIBRARY
C
C GPFDIA.FOR -- GP1 dialogue program 
C=====================================================================

	PROGRAM GPFDIA

	IMPLICIT NONE
	INCLUDE 'GP1LVF.GLO'

C... variables:

	LOGICAL*1   ERR
	CHARACTER*(80) STRING
        CHARACTER*(15) FILNAM
	CHARACTER   LANG,ANSWER
	INTEGER*2   ISTRING (40)
	INTEGER*2   PSTAT,OUT
	INTEGER*2   LENGTH,ANGLE,GOI
	INTEGER*2   BIT (8)
	INTEGER*2   IN,IPEN,IFLAG,ILOC,NSYMB
	INTEGER*2   ITYP,NUMPEN,NUMLIN,NSLIN
	INTEGER*2   IVELOC,FNUM,IROUND,NUMSYM
	INTEGER*2   NUMB,ICHDI,IFONT
	REAL*8      FUNC (2)
        REAL*4      COORD_OR_WIND(6)
        REAL*4      XEND,YEND,XSCL,YSCL,XYSCAL
        REAL*4      XSTART,YSTART,XMID,YMID
        REAL*4      SSYMB,RSYMB,SSTR,RSTR,SLSTR
        REAL*4      SLIN,RLIN,SYROLI,XREF,YREF
        REAL*4      XLEFT,XRIGHT,YUPPER,YLOWER
        REAL*4      DELX,DELY,PHI,HIGHT



C... initialization
	OUT    = 5
	IN     = 5
        LANG   = 'E'
	LENGTH = 'mm'
	ANGLE  = 'd '

C... Is the GP1 ready ?
        CALL GPINIT (1,'DK:GP1DIA.DAT',20,ERR)
        GOTO 330

C-----------------------------------------------------------------------
C... goto the desired function (loop)

2	WRITE (OUT,9991)
3	CALL GOFCT (GOI)
	WRITE (OUT,9991)
	GOTO (10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,
	1     160,170,180,190,200,210,220,230,240,250,260,270,280,
	2     290,300,310,320,330,340,350,360,370,380,390,400,410,
	3     420,430,440,450,460,470,480,490,500), GOI
C-----------------------------------------------------------------------

C... 1. Function: VECTOR
C
10	WRITE (OUT,9010)
	READ (IN,9011,ERR=10) PSTAT
	IPEN = 99
	IF (PSTAT.EQ.'D ' .OR. PSTAT .EQ. 'DO') IPEN = 2
	IF (PSTAT.EQ.'U ' .OR. PSTAT .EQ. 'UP') IPEN = 3
	IF (PSTAT.EQ.'C ' .OR. PSTAT .EQ. 'CO') IPEN = 4
11	WRITE (OUT,9012) LENGTH
	READ (IN,*,ERR=11) XEND
12	WRITE (OUT,9014) LENGTH
	READ (IN,*,ERR=12) YEND
	CALL VECTOR (XEND,YEND,IPEN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 10
C
C... 2. Function: SCALE
C
20	WRITE (OUT,9020)
	READ (IN,*,ERR=20) XSCL
21	WRITE (OUT,9022)
	READ (IN,*,ERR=21) YSCL
	CALL SCALE (XSCL,YSCL)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 20
C
C... 3. Function: CIRCLE
C
30	WRITE (OUT,9030) LENGTH
	READ (IN,*,ERR=30) XSTART
31	WRITE (OUT,9032) LENGTH
	READ (IN,*,ERR=31) YSTART
32	WRITE (OUT,9033) LENGTH
	READ (IN,*,ERR=32) XEND
33	WRITE (OUT,9034) LENGTH
	READ (IN,*,ERR=33) YEND
34	WRITE (OUT,9035) LENGTH
	READ (IN,*,ERR=34) XMID
35	WRITE (OUT,9036) LENGTH
	READ (IN,*,ERR=35) YMID
36	WRITE (OUT,9037)
	READ (IN,9011,ERR=36) PSTAT
	IFLAG = 99
	IF (PSTAT.EQ.'N ' .OR. PSTAT .EQ. 'NE') IFLAG = -1
	IF (PSTAT.EQ.'P ' .OR. PSTAT .EQ. 'PO') IFLAG = 1
	CALL CIRCLE (XSTART,YSTART,XEND,YEND,XMID,YMID,IFLAG)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 30
C
C... 4. Function: SPLINE
C
40	WRITE (OUT,9040)
	READ (IN,9011,ERR=40) PSTAT
	ILOC = 99
	IF (PSTAT.EQ.'S ' .OR. PSTAT .EQ. 'ST') ILOC = 2
	IF (PSTAT.EQ.'C ' .OR. PSTAT .EQ. 'CO') ILOC = 0
	IF (PSTAT.EQ.'T ' .OR. PSTAT .EQ. 'TE') ILOC = 1
	IF (ILOC .EQ. 99) GOTO 40
41	WRITE (OUT,9042) LENGTH
	READ (IN,*,ERR=41) XEND
42	WRITE (OUT,9044) LENGTH
	READ (IN,*,ERR=42) YEND
	CALL SPLINE (ILOC,XEND,YEND)
	IF (.NOT. GP1ERR) GOTO 43
	CALL ERRMES
43	IF (ILOC .EQ. 1) GOTO 2
	GOTO 40
C
C... 5. Function: SYSET
C
50	WRITE (OUT,9050)
	READ (IN,*,ERR=50) NSYMB
	CALL SYSET (NSYMB)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 50
C
C... 6. Function: SYSCAL
C
60	WRITE (OUT,9060) LENGTH
	READ (IN,*,ERR=60) SSYMB
	CALL SYSCAL (SSYMB)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 60
C
C... 7. Function: SYROTA
C
70	WRITE (OUT,9070) ANGLE
	READ (IN,*,ERR=70) RSYMB
	CALL SYROTA (RSYMB)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 70
C
C... 8. Function: CHAR
C
80	WRITE (OUT,9080)
	READ (IN,9011,ERR=80) PSTAT
	ITYP = 99
	IF (PSTAT.EQ.'E ' .OR. PSTAT .EQ. 'EV') ITYP = 0
	IF (PSTAT.EQ.'U ' .OR. PSTAT .EQ. 'UN') ITYP = 1
	CALL CHAR (ITYP)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 80
C
C... 9. Function: STRSET
C
90	WRITE (OUT,9090)
	READ (IN,9091) STRING
	CALL STRSET (STRING)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 90
C
C... 10. Function: STRSCL
C
100	WRITE (OUT,9100) LENGTH
	READ (IN,*,ERR=100) SSTR
	CALL STRSCL (SSTR)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 100
C
C... 11. Function: STROT
C
110	WRITE (OUT,9110) ANGLE
	READ (IN,*,ERR=110) RSTR
	CALL STROT (RSTR)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 110
C
C... 12. Function: STRSLN
C
120	WRITE (OUT,9120) ANGLE
	READ (IN,*,ERR=120) SLSTR
	CALL STRSLN (SLSTR)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 120
C
C... 13. Function: PENCHA
C
130	WRITE (OUT,9130)
	READ (IN,*,ERR=130) NUMPEN
	CALL PENCHA (NUMPEN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 130
C
C... 14. Function: LINSET
C
140	WRITE (OUT,9140)
	READ (IN,*,ERR=140) NUMLIN
	CALL LINSET (NUMLIN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 140
C
C... 15. Function: LINSCL
C
150	WRITE (OUT,9150) LENGTH
	READ (IN,*,ERR=150) SLIN
	CALL LINSCL (SLIN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 150
C
C... 16. Function: LINRAT
C
160	WRITE (OUT,9160)
	READ (IN,*,ERR=160) RLIN
	CALL LINRAT (RLIN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 160
C
C... 17. Function: LINSYM
C
170	WRITE (OUT,9170)
	READ (IN,*,ERR=170) NSLIN
	CALL LINSYM (NSLIN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 170
C
C... 18. Function: LINSRO
C
180	WRITE (OUT,9180) ANGLE
	READ (IN,*,ERR=180) SYROLI
	CALL LINSRO (SYROLI)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 180
C
C... 19. Function: NEWORG
C
190	WRITE (OUT,9190) LENGTH
	READ (IN,*,ERR=190) XREF
191	WRITE (OUT,9192) LENGTH
	READ (IN,*,ERR=191) YREF
	CALL NEWORG (XREF,YREF)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 190
C
C... 20. Function: NEWIND
C
200	WRITE (OUT,9200) LENGTH
	READ (IN,*,ERR=200) XLEFT
201	WRITE (OUT,9202) LENGTH
	READ (IN,*,ERR=201) YLOWER
202	WRITE (OUT,9203) LENGTH
	READ (IN,*,ERR=202) XRIGHT
203	WRITE (OUT,9204) LENGTH
	READ (IN,*,ERR=203) YUPPER
	CALL NEWIND (XLEFT,YLOWER,XRIGHT,YUPPER)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 200
C
C... 21. Function: CLRWIN
C
210	WRITE (OUT,9210)
	CALL CLRWIN
	GOTO 2
C
C... 22. Function: SPEED
C
220	WRITE (OUT,9220)
	READ (IN,*,ERR=220) IVELOC
	CALL SPEED (IVELOC)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 220
C
C... 23. Function: SETORG
C
230	WRITE (OUT,9230)
	CALL SETORG
	GOTO 2
C
C... 24. Function: PLTEND
C
240	CALL PLTEND
	STOP
C
C... 25. Function: NUMBER
C
250	WRITE (OUT,9250)
	READ (IN,*,ERR=250) FNUM
251	WRITE (OUT,9251)
	READ (IN,*,ERR=251) IROUND
252	WRITE (OUT,9252) LENGTH
	READ (IN,*,ERR=252) HIGHT
253	WRITE (OUT,9253) ANGLE
	READ (IN,*,ERR=253) PHI
254	WRITE (OUT,9254) LENGTH
	READ (IN,*,ERR=254) XEND
255	WRITE (OUT,9255) LENGTH
	READ (IN,*,ERR=255) YEND
	CALL NUMBER (XEND,YEND,HIGHT,FNUM,PHI,IROUND)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 250
C
C... 26. Function: SYMBOL (Symbol)
C
260	WRITE (OUT,9260)
	READ (IN,*,ERR=260) NUMSYM
261	WRITE (OUT,9060) LENGTH
	READ (IN,*,ERR=261) SSYMB
262	WRITE (OUT,9070) ANGLE
	READ (IN,*,ERR=262) RSYMB
263	WRITE (OUT,9254) LENGTH
	READ (IN,*,ERR=263) XEND
264	WRITE (OUT,9255) LENGTH
	READ (IN,*,ERR=264) YEND
265	WRITE (OUT,9261)
	READ (IN,9011,ERR=265) PSTAT
	IPEN = 99
	IF (PSTAT.EQ.'U ' .OR. PSTAT .EQ. 'UP') IPEN = -1
	IF (PSTAT.EQ.'D ' .OR. PSTAT .EQ. 'DO') IPEN = -2
	CALL SYMBOL (XEND,YEND,SSYMB,NUMSYM,RSYMB,IPEN)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 260
C
C... 27. Function: SYMBOL (String)
C
270	WRITE (OUT,9090)
	READ (IN,9271) ISTRING
271	WRITE (OUT,9100) LENGTH
	READ (IN,*,ERR=271) SSTR
272	WRITE (OUT,9110) ANGLE
	READ (IN,*,ERR=272) RSTR
273	WRITE (OUT,9270)
	READ (IN,*,ERR=273) NUMB
274	WRITE (OUT,9254) LENGTH
	READ (IN,*,ERR=274) XEND
275	WRITE (OUT,9255) LENGTH
	READ (IN,*,ERR=275) YEND
	CALL SYMBOL (XEND,YEND,SSTR,ISTRING,RSTR,NUMB)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 270
C
C... 28. Function: FACTOR
C
280	WRITE (OUT,9280)
	READ (IN,*,ERR=280) XYSCAL
	CALL FACTOR (XYSCAL)
	GOTO 2
C
C... 29. Function: GP1 RESET
C
290	WRITE (OUT,9290)
	READ (IN,9291) ANSWER
        IF (ANSWER .NE. 'Y' .AND. ANSWER .NE. 'y') GOTO 2
	CALL RESET
	GOTO 2
C
C... 30. Function: GRID
C
300	WRITE (OUT,9200) LENGTH
	READ (IN,*,ERR=300) XLEFT
301	WRITE (OUT,9202) LENGTH
	READ (IN,*,ERR=301) YLOWER
302	WRITE (OUT,9203) LENGTH
	READ (IN,*,ERR=302) XRIGHT
303	WRITE (OUT,9204) LENGTH
	READ (IN,*,ERR=303) YUPPER
304	WRITE (OUT,9300) LENGTH
	READ (IN,*,ERR=304) DELX
	IF (DELX.LE.0.0) GOTO 304
305	WRITE (OUT,9301) LENGTH
	READ (IN,*,ERR=305) DELY
	IF (DELY.LE.0.0) GOTO 305
306	WRITE (OUT,9302) ANGLE
	READ (IN,*,ERR=306) PHI
	CALL GRID (XLEFT,YLOWER,XRIGHT,YUPPER,DELX,DELY,PHI)
	GOTO 2
C
C... 31. Function: WHERE
C
310	CALL WHERE (XEND,YEND)
	WRITE (5,9310) XEND,YEND,LENGTH
	GOTO 2
C
C... 32. Function: SET UNITS
C
320	LENGTH = '  '
	ANGLE  = '  '
	WRITE (OUT,9320)
	READ (IN,9321,ERR=320) LENGTH
	IF (LENGTH .EQ. 'MM') LEUNIT = 0
	IF (LENGTH .EQ. 'MM') LENGTH = 'mm'
	IF (LENGTH .EQ. 'CM') LEUNIT = 1
	IF (LENGTH .EQ. 'CM') LENGTH = 'cm'
	IF (LENGTH .EQ. 'IN') LEUNIT = 2
	IF (LENGTH .EQ. 'IN') LENGTH = 'in'
	IF (LENGTH .EQ. '  ') GOTO 320
321	WRITE (OUT,9322)
	READ (IN,9321,ERR=321) ANGLE
	IF (ANGLE .EQ. 'D ') ANUNIT = 0
	IF (ANGLE .EQ. 'D ') ANGLE  = 'd '
	IF (ANGLE .EQ. 'G ') ANUNIT = 1
	IF (ANGLE .EQ. 'G ') ANGLE  = 'g '
	IF (ANGLE .EQ. 'R ') ANUNIT = 2
	IF (ANGLE .EQ. 'R ') ANGLE  = 'r '
	IF (ANGLE .EQ. '  ') GOTO 321
	CALL SETPAR (LEUNIT,ANUNIT)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 320
C
C... 33. Function: HELP
C
330	CALL MESSAG (16)
	IF (LANG .EQ. 'E') WRITE (OUT,9330)
	IF (LANG .EQ. 'D') WRITE (OUT,9331)
	GOTO 3
C
C... 34. Function: HELP SYMBOL
C
340	WRITE (OUT,9340)
	WRITE (OUT,9341)
	GOTO 2
C
C... 35. Function: HELP LINE
C
350	WRITE (OUT,9350)
	WRITE (OUT,9351)
	GOTO 2
C
C... 36. Function: 
C
360	CALL PENMOV
	GOTO 2
C
C... 37. Function: GET GP1 STATUS
C
370	CALL GPSTAT (BIT)
	IF (.NOT. GP1ERR) GOTO 371
	CALL ERRMES
	GOTO 370
C
371	WRITE (OUT,9370)BIT
	GOTO 2
C
C... 38. Function: CHARACTER DISTANCE
C
380	WRITE (OUT,9380)
	READ (IN,*,ERR=380) ICHDI
	CALL CHDIS (ICHDI)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 380
C
C... 39. Function: TEXT TYPE (FONT)
C
390	WRITE (OUT,9390)
	READ (IN,*,ERR=390) IFONT
	CALL TXTYP (IFONT)
	IF (.NOT. GP1ERR) GOTO 2
	CALL ERRMES
	GOTO 390
C
C... 40. Function: PARAMETER
C
400	WRITE (OUT,9990)
	GOTO 2
C
C... 41. Function: 
C
410	CALL ORIWIN (COORD_OR_WIND)
	WRITE (5,9410) COORD_OR_WIND(1),COORD_OR_WIND(2),LENGTH,
     +                 COORD_OR_WIND(3),COORD_OR_WIND(4),LENGTH,
     +                 COORD_OR_WIND(5),COORD_OR_WIND(6),LENGTH
	GOTO 2
C
C... 42. Function: 
C
420	WRITE (OUT,9990)
	GOTO 2
C
C... 43. Function: OPEN FILE FOR OUTPUT
C

430   IF (IMODE .EQ. 2) GOTO 431
      ICHANL = 1
      IMODE  = 2
      FILNAM = 'GPFDIA.DAT'
      OPEN (UNIT   = ICHANL,
     +      FILE   = FILNAM,
     +      ORGANIZATION = 'SEQUENTIAL',
     +      ACCESS       = 'SEQUENTIAL',
     +      RECORDTYPE   = 'VARIABLE',
     +      FORM   = 'FORMATTED',
     +      STATUS = 'NEW')
	WRITE (OUT,9430)
	GOTO 2
C
431     WRITE (OUT,9431)
	GOTO 2
C
C... 44. Function: CLOSE PLOT FILE
C
440     CLOSE (UNIT = ICHANL)
        IMODE  = 1
	WRITE (OUT,9440)
        GOTO 2
C
C... 45. Function: 
C
450	WRITE (OUT,9990)
	GOTO 2
C
C... 46. Function: DEUTSCH
C
460	LANG = 'D'
	GOTO 330
C
C... 47. Function: TANGENTIAL DRIVE CIRCLE
C
470	WRITE (OUT,9470)
	GOTO 2
C
C... 48. Function: 
C
480	WRITE (OUT,9990)
	GOTO 2
C
C... 49. Function: 
C
490	WRITE (OUT,9990)
	GOTO 2
C
C... 50. Function: 
C
500	LANG = 'E'
	GOTO 330

C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C... F O R M A T E
C
C... 1. Function: VECTOR
C
9010	FORMAT (1X, 'Pen U p, D own, S mooth           : ',$)
9011	FORMAT (A2)
9012	FORMAT (1X, 'x coordinate of target point [',A2,'] : ',$)
9014	FORMAT (1X, 'y coordinate of target point [',A2,'] : ',$)
C
C... 2. Function: SCALE
C
9020	FORMAT (1X, 'x scale factor : ',$)
9022	FORMAT (1X, 'y scale factor : ',$)
C
C... 3. Function: CIRCLE
C
9030	FORMAT (1X,'Circle',/,
     +          1X,'Starting point x coordinate [',A2,'] : ',$)
9032	FORMAT (1X,'Starting point y coordinate [',A2,'] : ',$)
9033	FORMAT (1X,'End point x coordinate [',A2,']      : ',$)
9034	FORMAT (1X,'End point y coordinate [',A2,']      : ',$)
9035	FORMAT (1X,'Centre x coordinate [',A2,']         : ',$)
9036	FORMAT (1X,'Centre y coordinate [',A2,']         : ',$)
9037	FORMAT (1X,'Rotation, clockwise: N egative,',
     +          ' counterclockwise: P ositive : ',$)
C
C... 4. Function: SPLINE
C
9040	FORMAT (1X,'Spline interpolation',//,1X,
     +          'S tart, C ontinue, T erminate     : ',$)
9042	FORMAT (1X, 'x coordinate of target point [',A2,'] : ',$)
9044	FORMAT (1X, 'y coordinate of target point [',A2,'] : ',$)
C
C... 5. Function: SYSET
C
9050	FORMAT (1X,'Symbol number [0...57] : ',$)
C
C... 6. Function: SYSCAL
C
9060	FORMAT (1X,'Size of symbol [',A2,']',21X,': ',$)
C
C... 7. Function: SYROTA
C
9070	FORMAT (1X,'Angle for symbol rotation [',A1,']',11X,': ',$)
C
C... 8. Function: CHAR
C
9080	FORMAT (1X,'Type of text, even cell: (E)'
     +          ' uneven cell: (U) : ',$)
C
C... 9. Function: STRSET
C
9090	FORMAT (1X,'Input of a line of text [1..80 characters] :',/
     +          1X,'*',$)
9091	FORMAT (A80)
C
C... 10. Function: STRSCL
C
9100	FORMAT (1X,'Size of characters [',A2,']',17X,': ',$)
C
C... 11. Function: STROT
C
9110	FORMAT (1X,'Angle for text line rotation [',A1,']',8X,': ',$)
C
C... 12. Function: STRSLN
C
9120	FORMAT (1X,'Angle for text slant',
     +          ' (90deg is vertical) [',A1,'] : '$)
C
C... 13. Function: PENCHA
C
9130	FORMAT (1X,'Pen number [1...5] : ',$)
C
C... 14. Function: LINSET
C
9140	FORMAT (1X,'Line type [1...7] : ',$)
C
C... 15. Function: LINSCL
C
9150	FORMAT (1X,'Length of a gap in a line [',A2,'] : ',$)
C
C... 16. Function: LINRAT
C
9160	FORMAT (1X,'Ratio of drawn part to a gap : ',$)
C
C... 17. Function: LINSYM
C
9170	FORMAT (1X,'Line symbol number [0...57] : ',$)
C
C... 18. Function: LINSRO
C
9180	FORMAT (1X,'Angle of rotation for line symbol [',A1,'] : ',$)
C
C... 19. Function: NEWORG
C
9190	FORMAT (1X,'New origin relative to the absolute origin',
     +          //1X,'x coordinate [',A2,'] : ',$)
9192	FORMAT ( 1X,'y coordinate [',A2,'] : ',$)
C
C... 20. Function: NEWIND
C
9200	FORMAT (1X, 'Left lower corner, x coordinate [',A2,']    : ',$)
9202	FORMAT (1X, 'Left lower corner, y coordinate [',A2,']    : ',$)
9203	FORMAT (1X, 'Right upper corner, x coordinate [',A2,']   : ',$)
9204	FORMAT (1X, 'Right upper corner, y coordinate [',A2,']   : ',$)
C
C... 21. Function: CLRWIN
C
9210	FORMAT (1X,'Maximum window is now active')
C
C... 22. Function: SPEED
C
9220	FORMAT (1X,'Speed [1...9] : ',$)
C
C... 23. Function: SETORG
C
9230	FORMAT (1X,'The actual point is now the origin')
C
C... 25. Function: NUMBER
C
9250	FORMAT (1X, 'Number',34X,': ',$)
9251	FORMAT (1X, 'Number of digits to round the number to : ',$)
9252	FORMAT (1X, 'Height of the number [',A2,']',15X,': ',$)
9253	FORMAT (1X, 'Angle of rotation [',A1,']',19X,': ',$)
9254	FORMAT (1X, 'x coordinate of target point [',A2,']       : ',$)
9255	FORMAT (1X, 'y coordinate of target point [',A2,']       : ',$)
C
C... 26. Function: SYMBOL (Symbol)
C
9260	FORMAT (1X,'Symbol number [0...14]',18X,': ',$)
9261	FORMAT (1X,'Pen U p, D own',26X,': ',$)
C
C... 27. Function: SYMBOL (String)
C
9270	FORMAT (1X,'Number of characters to plot',12X,': ',$)
9271	FORMAT (40A2)
C
C... 28. Function: FACTOR (Calcomp)
C
9280	FORMAT (1X,'Scale factor : ',$)
C
C... 29. Function: GP1 RESET
C
9290	FORMAT (1X, 'GP1 parameter reset. Are you sure ? [Y/N] : ',$)
9291	FORMAT (A1)
C
C... 30. Function: GRID
C
9300	FORMAT (1X,'Increment in x direction [',A2,']           : ',$)
9301	FORMAT (1X,'Increment in y direction [',A2,']           : ',$)
9302	FORMAT (1X,'Angle of rotation around the origin [',A1,'] : ',$)
C
C... 31. Function: WHERE
C
9310	FORMAT (1X,'The GP1 is at the point ',
	1       F8.2,' / ',F8.2,' [',A2,']')
C
C... 32. Function: SET UNITS
C
9320	FORMAT (1X,'Unit of length [MM, CM, IN] : ',$)
9321	FORMAT (A2)
9322	FORMAT (1X,'Unit of angle [D, G, R]     : ',$)
C
C... 33. Function: HELP
C
9330	FORMAT (1X,'GPFDIA - DIALOGUE PROGRAM',/,
     +     ' SL: straight line      SI: spline interpolation   ',
     +     'US: user defined symbol',/
     +     ' SY: symbol             SS: symbol scale           ',
     +     'GR: simple grid',/
     +     ' SR: symbol rotation    TE: text                   ',
     +     'OP: open plot file',/
     +     ' TS: text scale         TR: text rotation          ',
     +     'CP: close plot file',/
     +     ' TL: text slant         LT: line type              ',
     +     'GP: GP1 int. status',/
     +     ' LC: line scale         LR: line ratio             ',
     +     'SU: set units',/
     +     ' LS: line symbol        LO: line symbol rotation   ',
     +     'SP: speed',/
     +     ' MP: move pen up/down   TT: text typ               ',
     +     'CI: circle',/
     +     ' PN: pen number         SO: set origin             ',
     +     'XY: xy scale',/
     +     ' NO: new origin         NW: new window             ',
     +     'CW: clear window',/
     +     ' DI: digitize           CH: character spacing      ',
     +     'RE: reset GP1',/
     +     ' PE: plot end           PA: actual parameters      ',
     +     'DT: Deutsch',/
     +     ' ST: program status     OW: get origin/window      ',
     +     'TK: Tangentialdrive circle',/
     +     ' CD: character distance HL: help linetypes         ',
     +     'HS: help symbols',/
     +     ' CS: calcomp symbol     CR: calcomp string         ',
     +     'CN: calcomp number'/
     +     ' CF: calcomp factor')
C
9331	FORMAT (1X,'GPFDIA - DIALOG PROGRAMM',/,
     +     ' SL: Gerade Linie       SI: Spline Kurve           ',
     +     'US: Benutzersymbol',/
     +     ' SY: Symbol             SS: Symbol Groesse         ',
     +     'GR: Einfaches Gitter',/
     +     ' SR: Symbol Drehung     TE: Text                   ',
     +     'OP: Plotfile eroeffnen',/
     +     ' TS: Text Groesse       TR: Textlinie Drehung      ',
     +     'CP: Plotfile schliessen',/
     +     ' TL: Text schraegstellen  LT: Linientyp            ',
     +     'GP: GP1 Status',/
     +     ' LC: Linienluecke       LR: Linienverhaeltnis      ',
     +     'SU: Einheiten waehlen',/
     +     ' LS: Liniensymbol       LO: Liniensymbol Drehung   ',
     +     'SP: Zeichengeschwindigkeit',/
     +     ' MP: Pen ab/auf         TT: Texttyp                ',
     +     'CI: Kreis',/
     +     ' PN: Pen-Nummer         SO: Setze Nullpunkt        ',
     +     'XY: XY Skalierung',/
     +     ' NO: Neuer Nullpunkt    NW: Neues Fenster          ',
     +     'CW: Fenster loeschen',/
     +     ' DI: Digitalisieren     CH: Character-Abstand      ',
     +     'RE: GP1 reset',/
     +     ' PE: Programmende       PA: Aktuelle Parameter     ',
     +     'EN: English',/
     +     ' ST: Program status     OW: Frage Nullpkt./Fenster ',
     +     'TK: Kreis mit Tang.steuerung',/
     +     ' CD: Character distanz  HL: HILFE Linientypen      ',
     +     'HS: HILFE Symbole',/
     +     ' CS: Calcomp Symbol     CR: Calcomp String         ',
     +     'CN: Calcomp Nummer'/
     +     ' CF: Calcomp Faktor')
C
C... 34. Function: HELP SYMBOL
C
9340	FORMAT (//1X,'The following symbols are available :',
	1 //7X,'number',5X,'symbol') 
9341	FORMAT (/10X,'0',10X,'no symbol',/10X,'1',10X,'circle',
	1 /10X,'2',10X,'cross',/10X,'3',10X,'triangle',/10X,'4',10X,
	2 'square',/10X,'5',10X,'dot',/10X,'6',10X,'equal sign',
	3 /10X,'7',10X,'tree',/10X,'8',10X,'apostroph',/10X,'9',10X,
	4 'vertical straight line',/9X,'10',10X,'circumflex',
	5 /6X,'11-25',10X,'CALCOMP symbols',/6X,'26-57',10X,
	6 'user defined symbols')
C
C... 35. Function: HELP LINE
C
9350	FORMAT (//1X,'The following line types are available :',
	1 //1X,'* A symbol may be incorporated into the line types ',
	2 'with a (S)'//7X,'number',5X,'line type')
9351	FORMAT (/10X,'1',10X,'normal smooth line',/10X,'2',10X,
	1 'symbol (S) on top of the line',/10X,'3',10X,
	2 'symbol (S) interrupting the line',/10X,
	3 '4',10X,'line interrupted by a dot',/10X,'5',
	4 10X,'line interrupted by two dots',/10X,'6',10X,'tree line',
	5 /10X,'7',10X,'a line containing only symbols (S)')
C
C... 36. Function: PEN UP/DOWN
C
9360	FORMAT (1X,'Move pen up or down')
C
C... 37. Function: GET GP1 STATUS
C
9370	FORMAT (1X, 'GP1 status byte',//,1X, 'Bit 0 =',I2,/,
     +          5X,'1 =',I2,/,5X,'2 =',I2,/,5X,'3 =',I2,/,
     +          5X,'4 =',I2,/,5X,'5 =',I2,/,5X,'6 =',I2,/,5X,'7 =',I2)
C
C... 38. Function: CHARACTER DISTANCE
C
9380	FORMAT (1X,'Character distance [-20..+20] : ',$)
C
C... 39. Function: TEXT TYPE (FONT)
C
9390	FORMAT (1X,'1     = Standard text font',
     +          /1X,'2..10 = User defined',
     +          /1X,'Number [1..10] : ',$)
C
C... 40. Function: 
C
9400	FORMAT (1X,'X')
C
C... 41. Function: 
C
9410	FORMAT (1X,'The GP1 origin          ',
     +          F8.2,' / ',F8.2,' [',A2,']',/,
     +          1X,'The GP1 window minimum  ',
     +          F8.2,' / ',F8.2,' [',A2,']',/,
     +          1X,'The GP1 window maximum  ',
     +          F8.2,' / ',F8.2,' [',A2,']')
C
C... 42. Function: 
C
9420	FORMAT (1X,'X')
C
C... 43. Function: 
C
9430	FORMAT (1X,'The plotfile "GPFDIA.DAT" is open')
9431	FORMAT (1X,'"GPFDIA.DAT" is still open ??')
C
C... 44. Function: 
C
9440	FORMAT (1X,'The plotfile "GPFDIA.DAT" is closed')
C
C... 45. Function: 
C
9450	FORMAT (1X,'X')
C
C... 47. Function: TANGENTIAL DRIVE CIRCLE
C
9470	FORMAT (1X,'Circle with the tangential drive')
C
C... 48. Function: 
C
9480	FORMAT (1X,'X')
C
C... 49. Function: 
C
9490	FORMAT (1X,'X')
C
C
9990	FORMAT (1X,'The function is not implemented yet')
9991	FORMAT (1X)
C
	E N D

	SUBROUTINE ERRMES
C
C=======================================================================
C Error message to the terminal
C=======================================================================
C
	OUT = 5
C
	WRITE (OUT,9000)
	RETURN
C
9000	FORMAT (1X,'-> Try again !',/)
C
	END
C
C
C
	SUBROUTINE GRID (XLEFT,YLOWER,XRIGHT,YUPPER,DELX,DELY,PHI)
C
C=======================================================================
C Plotting of a rectangular grid
C=======================================================================
C
C... test, if parameter are in the range
C
	IF (XLEFT .GE. XRIGHT .OR. YLOWER .GE. YUPPER) GOTO 40
	IF (DELX .LE. 0.0 .OR. DELY .LE. 0.0) GOTO 40
C
C... plotting of the border
C
	CALL ROTA (XLEFT,YLOWER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,3)
	CALL ROTA (XLEFT,YUPPER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	CALL ROTA (XRIGHT,YUPPER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	CALL ROTA (XRIGHT,YLOWER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	CALL ROTA (XLEFT,YLOWER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
C
C... plotting of vertical lines
C
	X = XLEFT + DELX
10	IF (X .GE. XRIGHT) GOTO 20
	CALL ROTA (X,YLOWER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,3)
	CALL ROTA (X,YUPPER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	X = X + DELX
	IF (X .GE. XRIGHT) GOTO 20
	CALL ROTA (X,YUPPER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,3)
	CALL ROTA (X,YLOWER,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	X = X + DELX
	GOTO 10
C
C... plotting of horizontal lines
C
20	Y = YLOWER + DELY
30	IF (Y .GE. YUPPER) GOTO 40
	CALL ROTA (XLEFT,Y,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,3)
	CALL ROTA (XRIGHT,Y,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	Y = Y + DELY
	IF (Y .GE. YUPPER) GOTO 40
	CALL ROTA (XRIGHT,Y,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,3)
	CALL ROTA (XLEFT,Y,XEND,YEND,PHI)
	CALL VECTOR (XEND,YEND,2)
	Y = Y + DELY
	GOTO 30
C
40	CALL VECTOR (0.0,0.0,3)
C
	RETURN
C
C
	E N D

	SUBROUTINE ROTA (XIN,YIN,XOUT,YOUT,PHI)
C
C=======================================================================
C Rotation around the origin
C=======================================================================
C
	RX = XIN
	RY = YIN
	ALFA = PHI * 0.01745329
C
	XOUT = RX * COS (ALFA) - RY * SIN (ALFA)
	YOUT = RX * SIN (ALFA) + RY * COS (ALFA)
C
	RETURN
C
C
	E N D

	SUBROUTINE GOFCT (NUMFCT)
C
C=======================================================================
C Find the desired function number
C=======================================================================
C
C
	LOGICAL*1     ERR
	CHARACTER*(2) CODE
C
C
	OUT = 5
	IN  = 5
C
10	WRITE (OUT,9000)
	READ  (IN,9001,ERR=10) CODE
        IF ( ICHAR (CODE(1:1)) .GT. 95 ) 
     +      CODE (1:1) = CHAR ( ICHAR (CODE(1:1)) - 32 )
        IF ( ICHAR (CODE(2:2)) .GT. 95 ) 
     +      CODE (2:2) = CHAR ( ICHAR (CODE(2:2)) - 32 )
C
20	NUMFCT = 0
	IF (CODE .EQ. 'SL') NUMFCT = 1
	IF (CODE .EQ. 'SY') NUMFCT = 5
	IF (CODE .EQ. 'SR') NUMFCT = 7
	IF (CODE .EQ. 'TS') NUMFCT = 10
	IF (CODE .EQ. 'TL') NUMFCT = 12
	IF (CODE .EQ. 'LC') NUMFCT = 15
	IF (CODE .EQ. 'LS') NUMFCT = 17
	IF (CODE .EQ. 'MP') NUMFCT = 36
	IF (CODE .EQ. 'PN') NUMFCT = 13
	IF (CODE .EQ. 'NO') NUMFCT = 19
	IF (CODE .EQ. 'DI') NUMFCT = 31
	IF (CODE .EQ. 'PE') NUMFCT = 24
	IF (CODE .EQ. 'ST') NUMFCT = 37
	IF (CODE .EQ. 'CD') NUMFCT = 38
	IF (CODE .EQ. 'SI') NUMFCT = 4
	IF (CODE .EQ. 'SS') NUMFCT = 6
	IF (CODE .EQ. 'TE') NUMFCT = 9
	IF (CODE .EQ. 'TR') NUMFCT = 11
	IF (CODE .EQ. 'LT') NUMFCT = 14
	IF (CODE .EQ. 'LR') NUMFCT = 16
	IF (CODE .EQ. 'LO') NUMFCT = 18
	IF (CODE .EQ. 'TT') NUMFCT = 39
	IF (CODE .EQ. 'SO') NUMFCT = 23
	IF (CODE .EQ. 'NW') NUMFCT = 20
	IF (CODE .EQ. 'CH') NUMFCT = 8
	IF (CODE .EQ. 'PA') NUMFCT = 40
	IF (CODE .EQ. 'OW') NUMFCT = 41
	IF (CODE .EQ. 'US') NUMFCT = 42
	IF (CODE .EQ. 'GR') NUMFCT = 30
	IF (CODE .EQ. 'OP') NUMFCT = 43
	IF (CODE .EQ. 'CP') NUMFCT = 44
	IF (CODE .EQ. 'GP') NUMFCT = 45
	IF (CODE .EQ. 'HS') NUMFCT = 34
	IF (CODE .EQ. 'HL') NUMFCT = 35
	IF (CODE .EQ. 'SP') NUMFCT = 22
	IF (CODE .EQ. 'CI') NUMFCT = 3
	IF (CODE .EQ. 'XY') NUMFCT = 2
	IF (CODE .EQ. 'EN') NUMFCT = 50
	IF (CODE .EQ. 'DT') NUMFCT = 46
	IF (CODE .EQ. 'CW') NUMFCT = 21
	IF (CODE .EQ. 'TK') NUMFCT = 47
	IF (CODE .EQ. 'SU') NUMFCT = 32
	IF (CODE .EQ. 'RE') NUMFCT = 29
	IF (CODE .EQ. 'CN') NUMFCT = 25
	IF (CODE .EQ. 'CS') NUMFCT = 26
	IF (CODE .EQ. 'CR') NUMFCT = 27
	IF (CODE .EQ. 'CF') NUMFCT = 28
	IF (NUMFCT .EQ. 0)  NUMFCT = 33
C
	RETURN
C
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
9000	FORMAT (/1X,'Enter plot function (2 Char.) : ',$)
9001	FORMAT (A2)
C
C
	E N D

