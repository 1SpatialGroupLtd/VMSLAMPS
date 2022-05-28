$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-01-03 18:13:44.000000000 +0000
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
	SET LANG MACRO
!	DEP/INS CHAIN+2   ="RET"
	DEP/INS CHARC+2   ="RET"
	DEP/INS CHARS+2   ="RET"
	DEP/INS CHARZ+2   ="RET"
	DEP/INS CHFONT+2  ="RET"
	DEP/INS CHSIZE+2  ="RET"
!	DEP/INS CIRCLE+2  ="RET"
	DEP/INS CSAJST+2  ="RET"
	DEP/INS CSRD+2    ="RET"
	DEP/INS CSWT+2    ="RET"
	DEP/INS CURSOR+2  ="RET"
!	DEP/INS DASHED+2  ="RET"
	DEP/INS DIFRAM+2  ="RET"
	DEP/INS DISMOD+2  ="RET"
!	DEP/INS DOTTED+2  ="RET"
	DEP/INS DRAWBY+2  ="RET"
	DEP/INS DRAWTO+2  ="RET"
!	DEP/INS DREPT+2   ="RET"
!	DEP/INS DSUBST+2  ="RET"
!	DEP/INS ENDPIC+2  ="RET"
	DEP/INS FBRD+2    ="CLRW @B^4(AP)"
	DEP/INS FBRD+5    ="RET"
	DEP/INS FBRD16+2  ="RET"
	DEP/INS FBWT+2    ="RET"
	DEP/INS FBWT16+2  ="RET"
	DEP/INS FLEVEL+2  ="RET"
	DEP/INS HRDMOD+2  ="RET"
!	DEP/INS ILINE+2   ="RET"
!	DEP/INS ILINEP+2  ="RET"
	DEP/INS INTENS+2  ="RET"
!	DEP/INS KBRD+2    ="RET"
!	DEP/INS KBSHFT+2  ="RET"
	DEP/INS LDCMPL+2  ="RET"
!	DEP/INS LDCTRL+2  ="RET"
!	DEP/INS LDETIN+2  ="RET"
!	DEP/INS LDETRF+2  ="RET"
	DEP/INS LDFLSH+2  ="RET"
	DEP/INS LDFPPM+2  ="RET"
	DEP/INS LDINIT+2  ="RET"
	DEP/INS LDINPM+2  ="RET"
!	DEP/INS LDPUTA+2  ="RET"
!	DEP/INS LDPUTB+2  ="RET"
!	DEP/INS LDPUTL+2  ="RET"
!	DEP/INS LDPUTX+2  ="RET"
!	DEP/INS LDPUTY+2  ="RET"
!	DEP/INS LDPUTZ+2  ="RET"
!	DEP/INS LDRDRG+2  ="RET"
!	DEP/INS LDTRIG+2  ="RET"
	DEP/INS LDWAIT+2  ="RET"
!	DEP/INS LDWTRG+2  ="RET"
	DEP/INS LINBY+2   ="RET"
!	DEP/INS LINE+2    ="RET"
	DEP/INS LINEBY+2  ="RET"
!	DEP/INS LINEP+2   ="RET"
	DEP/INS LINETO+2  ="RET"
	DEP/INS LINTO+2   ="RET"
	DEP/INS LINTOC+2  ="RET"
	DEP/INS LTHF+2    ="RET"
	DEP/INS MOVB00+2  ="RET"
	DEP/INS MOVBY+2   ="RET"
	DEP/INS MOVBY_00+2="RET"
	DEP/INS MOVEBY+2  ="RET"
	DEP/INS MOVETO+2  ="RET"
	DEP/INS MOVT00+2  ="RET"
	DEP/INS MOVTO+2   ="RET"
	DEP/INS MOVTOC+2  ="RET"
	DEP/INS MOVTO_00+2="RET"
	DEP/INS NEGET+2   ="CLRL R0"
	DEP/INS NEGET+4   ="RET"
	DEP/INS ORIGIN+2  ="RET"
	DEP/INS PCFRAM+2  ="RET"
	DEP/INS PCRWND+2  ="RET"
	DEP/INS PLTCHR+2  ="RET"
	DEP/INS PRTCHR+2  ="RET"
	DEP/INS REFRSH+2  ="RET"
	DEP/INS RFAJST+2  ="RET"
	DEP/INS RFIDEL+2  ="RET"
	DEP/INS RFMARK+2  ="RET"
	DEP/INS RFSTOP+2  ="RET"
	DEP/INS RFTRNC+2  ="RET"
	DEP/INS SCANBY+2  ="RET"
	DEP/INS SCBUF+2   ="RET"
!	DEP/INS SCRUB+2   ="RET"
	DEP/INS SCSET+2   ="RET"
	DEP/INS THICK+2   ="RET"
	DEP/INS TRSET+2   ="RET"
	DEP/INS UNITS+2   ="RET"
	SET LANG FORTRAN
