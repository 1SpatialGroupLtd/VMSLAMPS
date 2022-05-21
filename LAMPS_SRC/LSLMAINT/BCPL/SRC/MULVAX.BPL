 //*
 //* This file is part of the LAMPS distribution, released as a software
 //* preservation project to archive digital history for future historians.
 //* Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 //*
 //* Timestamp of this file for the 2002 release was: 1985-09-06 12:36:34.000000000 +0100
 //*
 //* This program is free software: you can redistribute it and/or modify
 //* it under the terms of the GNU General Public License as published by
 //* the Free Software Foundation, version 3.
 //*
 //* This program is distributed in the hope that it will be useful, but
 //* WITHOUT ANY WARRANTY; without even the implied warranty of
 //* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 //* General Public License for more details.
 //*
 //* You should have received a copy of the GNU General Public License
 //* along with this program. If not, see http://www.gnu.org/licenses/.
 //*
GET "MULVAX"
GET "LIBHDR"

LET LMC(V,N) BE
$(  LET NOTYETDONE=0
    FREEB,FREET,FREELEN:=V,V+N,N
    PEND,NEXT:=FREEB,FREEB
    PAGNO:=1
    INTERRUPTED:=FALSE
    CH:=RDCH();TERM:=TRUE
    NOTYETDONE:=TRUE
    TEST AUTO
    THEN $( IF PEND<=NEXT WRAP:=FALSE
	NOTYETDONE:=RAUTO()
	IF NOTYETDONE<0 RETURN
	IF WRAP & NEXT>!PTRVEC DO OVERFLOW()
	NLSPENDING:=0;PPAGE()  $) REPEATWHILE NOTYETDONE=0
    OR   $( IF PEND<=NEXT WRAP:=FALSE
	NOTYETDONE:=RMAN()
	IF NOTYETDONE<0 RETURN
	IF WRAP & NEXT>!PTRVEC DO OVERFLOW()
	NLSPENDING:=0;PPAGE()  $) REPEATWHILE NOTYETDONE=0
			$)

AND OVERFLOW() BE
$(  SELECTOUTPUT(SYSOUT)
    WRITES("Buffer overflow - reduce page size*N")
    FINISH
    $)

AND RAUTO() = VALOF
$(A LET CURWID=0
    IF CH=ENDSTREAMCH & PEND=NEXT RESULTIS -1
    CWIDTH,COLSTHISPAGE,ALLOWEDWID:=WIDTH,0,WIDTH
    IF PEND=NEXT \/ INTERRUPTED DO RCOL()
    $(	IF CURWID+MAXWID>WIDTH RESULTIS 0
	CURWID:=CURWID+MAXWID+GAP
	PTRVEC!COLSTHISPAGE,WIDVEC!COLSTHISPAGE:=PEND,MAXWID+GAP
	PEND,COLSTHISPAGE:=NEXT,COLSTHISPAGE+1
	IF CH=ENDSTREAMCH RESULTIS 1
	ALLOWEDWID:=WIDTH-CURWID
	RCOL()		$) REPEAT
		$)A

AND RMAN() = VALOF
$(M IF CH=ENDSTREAMCH RESULTIS -1
	COLSTHISPAGE:=0
	ALLOWEDWID:=CWIDTH
  $(	RCOL()
	PTRVEC!COLSTHISPAGE,WIDVEC!COLSTHISPAGE:=PEND,CWIDTH+GAP
	PEND,COLSTHISPAGE:=NEXT,COLSTHISPAGE+1
	IF CH=ENDSTREAMCH RESULTIS 1
			$) REPEATUNTIL COLSTHISPAGE=NCOLS
    RESULTIS 0
    $)M

AND RCOL() BE
$(  LET I=0
    TEST INTERRUPTED THEN I:=LINSAV
	OR $( I:=HEADERS->3,1;MAXWID:=0 $)
    $(	TEST INTERRUPTED THEN INTERRUPTED:=FALSE
	OR W:=RSTRING(NEXT)
	$(  IF W=0 RETURN
	    IF !NEXT > MAXWID DO MAXWID:=!NEXT
	    IF MAXWID>ALLOWEDWID DO
	    $(	LINSAV,INTERRUPTED:=I,TRUE
		RETURN  $)
	    UNLESS CRFLAG BREAK
	    UNLESS NEXT!0=0 DO
	    $(	NEXT!0:=-NEXT!0
		NEXT:=NEXT+W  $)
	    W:=RSTRING(NEXT)
				$) REPEAT
	NEXT:=NEXT+W
	IF PAGEFLAG
	$(  FOR J=I+1 TO LENGTH DO $( !NEXT:=0;NEXT:=STEP(NEXT) $)
	    RETURN  $)
	I:=I+1
			$) REPEATUNTIL I>LENGTH
		$)

AND RSTRING(S)=VALOF
$(  LET I=0 AND V=VEC 200
    IF NUMBERING /\ TERM DO
	$(  INCR();FOR I=1 TO 8 DO V!I:=STATNO!(I-1);I:=8  $)

    CRFLAG,PAGEFLAG,TERM:=FALSE,FALSE,FALSE
    IF CH=ENDSTREAMCH RESULTIS 0
$(  SWITCHON CH INTO
    $(	CASE 13:	CRFLAG:=TRUE;TERM:=TRUE;BREAK
	CASE ENDSTREAMCH:
	CASE '*P':	PAGEFLAG:=TRUE
	CASE '*N':	TERM:=TRUE;BREAK
	CASE '*T':	IF I>=CWIDTH BREAK
			CH:=RDCH()
			$(  I:=I+1;V!I:='*S' $)
			  REPEATUNTIL I REM 8=0 \/ I>=CWIDTH
			TEST I>=CWIDTH THEN BREAK OR ENDCASE
	CASE 127:
	CONTROL:	CH:=RDCH();ENDCASE

	DEFAULT:	IF CH<'*S' GOTO CONTROL
			IF I>=CWIDTH BREAK
			I:=I+1;V!I:=CH
			CH:=RDCH()
				$)  $) REPEAT

    IF TERM CH:=RDCH()
    V!0:=I;RESULTIS PACK(V,S)
			$)

AND PACK(V,S)=VALOF
$(  LET I,N=STEP(S),V!0
    S!0:=N
    WHILE N>0 DO
    $(	LET WORD=0
	FOR I=1 TO BYTESPERWORD DO
	    WORD:=(WORD<<8)+(N-I<0->0,V!I)
	!I:=WORD
	I,V,N:=STEP(I),V+BYTESPERWORD,N-BYTESPERWORD
			$)
    RESULTIS I-S  $)

AND INCR() BE
$(  LET I=4
    $(	LET DIG=STATNO!I
	IF DIG='*S' DO DIG:='0'
	DIG:=DIG+1
	UNLESS DIG>'9' $(  STATNO!I:=DIG;RETURN  $)
	STATNO!I,I:='0',I-1
			$) REPEATWHILE I>=0
		$)

AND PPAGE() BE
$(  LET I=0
    IF NPPENDING WRCH('*P');NTAB:=0
    IF HEADERS $( WHEADER();I:=2 $)
    UNTIL I=LENGTH \/ COLSTHISPAGE=0 DO
    $(	PLINE();I:=I+1  $)
    NPPENDING:=TRUE
		$)

AND PLINE() BE
$(  $(	LET J=COLSTHISPAGE-1
	FOR I=0 TO J DO
	$(  UNLESS !(PTRVEC!I)=0 GOTO NOTEMPTY  $)
	FOR I=0 TO J DO PTRVEC!I:=STEP(PTRVEC!I)
	IF PTRVEC!J=PEND DO COLSTHISPAGE:=COLSTHISPAGE-1
	NLSPENDING:=NLSPENDING+1;RETURN
NOTEMPTY:
	FOR I=1 TO NLSPENDING DO ELINE('*N')
	NLSPENDING:=0
	CRFLAG:=FALSE
	FOR I=0 TO J DO
	    IF !(PTRVEC!I)<0 DO $( CRFLAG:=TRUE;BREAK $)
	UNLESS CRFLAG BREAK
	FOR I=0 TO J DO
	$(  LET W=!(PTRVEC!I)<0->WSTRING(PTRVEC+I),0
	    TAB(WIDVEC!I-W)
			$)
	ELINE(13)
	IF PTRVEC!J=PEND THEN COLSTHISPAGE:=COLSTHISPAGE-1
			$) REPEATWHILE CRFLAG
    FOR I=0 TO COLSTHISPAGE-1 DO
	TAB(WIDVEC!I-WSTRING(PTRVEC+I))
    UNLESS COLSTHISPAGE=0 DO
	IF PTRVEC!(COLSTHISPAGE-1)=NEXT DO
	    COLSTHISPAGE:=COLSTHISPAGE-1
    ELINE('*N')
		$)

AND TAB(N) BE NTAB:=NTAB+N

AND ELINE(CH) BE $( NTAB:=0;WRCH(CH) $)

AND WSTRING(PTR)=VALOF
$(  LET N=!!PTR LET NS=N<0->-N,N
    N:=NS
    !PTR:=STEP(!PTR)
    UNLESS N=0 DO $( SPACE(NTAB);NTAB:=0 $)
    UNTIL N<=0 DO
    $(	LET CHS=!!PTR
	!PTR:=STEP(!PTR)
	FOR I=BYTESPERWORD-1 TO 0 BY -1 DO
	$(  IF N+I<BYTESPERWORD RESULTIS NS
	    WRCH((CHS>>(I*8))&255)
			$)
	N:=N-BYTESPERWORD	    $)
    RESULTIS NS
		$)
AND STEP(P)=VALOF
$(  P:=P+1;IF P>=FREET DO $( WRAP:=TRUE;P:=P-FREELEN $)
    RESULTIS P	$)


AND WHEADER() BE
$(  WRITES(SDATE);WRITES("  ");WRITES(STIME);SPACE(TAB1)
    WRITES(INFILE);WRITES(TLEN=0->"   "," - ")
    WRITES(TITLE);SPACE(TAB2)
    WRITEF("Page%I4*N*N",PAGNO)
    PAGNO:=PAGNO+1
                $)

AND SPACE(N) BE FOR I=1 TO N DO WRCH('*S')

.

GET "MULVAX"
GET "LIBHDR"

LET READFILENAME(FN)=VALOF
$(  LET V=VEC TITLEN AND I,ONOFF,NOTUIC=0,TRUE,TRUE
    RCH() REPEATWHILE TCH='*S' \/ TCH='*T' \/ TCH='*N'
    UNTIL TCH='*N'\/TCH='/'\/(TCH=','/\NOTUIC) \/ TCH=ENDSTREAMCH DO
    $(	IF TCH='[' \/ TCH='<' NOTUIC:=FALSE
	IF TCH=']' \/ TCH='>' NOTUIC:=TRUE
	IF TCH='*S' \/ TCH='=' $(  RCH();LOOP  $)
	UNLESS 'A'<=TCH<='Z' \/ '0'<=TCH<='9' \/ TCH='.' \/
		TCH='<' \/ TCH='>' \/ TCH='$' \/ TCH=';' \/
		TCH=':' \/ TCH='[' \/ TCH=']' \/ TCH=',' \/
		TCH='_' DO
	$(  LET X=VEC (TITLEN+1)/2
	    V!0:=I;PACKSTRING(V,X)
	    WRITEF("Unexpected character after %S*N", X)
	    FINISH
	    $)
	UNLESS I>=TITLEN DO $( I:=I+1;V!I:=TCH $) ;RCH()  $)
    V!0:=I;PACKSTRING(V,FN)
    UNTIL TCH='*N'\/TCH=',' DO
    $(	TEST TCH='-' THEN $( ONOFF:=FALSE;RCH() $)
			OR ONOFF:=TRUE
	SWITCHON TCH INTO
        $(  CASE 'L':   NUMBERING:=ONOFF;ENDCASE
	    CASE 'H':	HEADERS:=ONOFF;ENDCASE
	    CASE 'W':	WIDTH:=READNFROMCMD()
			LOOP
	    CASE 'P':	LENGTH:=READNFROMCMD()
			LOOP
	    CASE 'G':	GAP:=READNFROMCMD()
			LOOP
	    CASE 'T':	$(  LET PROTOTITLE=VEC TITLEN AND INSTRING=FALSE
			TLEN:=0;RCH()
			IF TCH='"' DO $( INSTRING:=TRUE; RCH() $)
			UNTIL TCH='*N' \/ 
			     (TCH=',' /\ INSTRING) \/
			     (TCH="'" /\ \INSTRING) \/
			      TCH=ENDSTREAMCH DO
			$(  UNLESS TLEN>=TITLEN DO
			    $(	TLEN:=TLEN+1
				PROTOTITLE!TLEN:=TCH
					$)
				RCH()	$)
			PROTOTITLE!0:=TLEN
			PACKSTRING(PROTOTITLE,TITLE)
			BREAK	$)
	    CASE 'O':	IF READFILENAME(OUTFILE)=0 INIT(OUTFILE) 
			OUTF:=FINDOUTPUT(OUTFILE)
			IF OUTF<0 DO
			$(  WRITEF("Output %S not available*N",OUTFILE)
			    $)
			NPPENDING:=FALSE
			BREAK

	    CASE ENDSTREAMCH:
			ENDUP:=TRUE
			BREAK

	    CASE 'Q':	QUIT:=TRUE
			ENDCASE
	    CASE '#':	UNTIL TCH='*N' \/ TCH=',' \/ TCH=ENDSTREAMCH DO RCH()
			BREAK
	    CASE 'E':	ENDUP:=TRUE
			ENDCASE
	    CASE 'M':	TEST ONOFF THEN
			$(  NCOLS:=READNFROMCMD()
			    AUTO:=NCOLS<=0  $)
			OR AUTO:=TRUE
			LOOP
                        $)
        RCH()
		$)	//End of loop
    RESULTIS I
                $)

AND RCH() BE
$(  TEST COMMPTR>=COMMLINE!0 THEN TCH := '*N'
    OR $(  COMMPTR := COMMPTR+1
	   TCH := COMMLINE!COMMPTR
	   $)
    $)

AND READNFROMCMD() = VALOF

$(  LET RES=0

    RCH() REPEATWHILE TCH='=' \/ TCH=':' \/ TCH='*S'

    WHILE TCH>='0' & TCH<='9' DO
    $(  RES:=RES*10+TCH-'0'
	RCH()
	$)

    RESULTIS RES

    $)

AND START() BE
$(  LET V1=VEC (TITLEN+1)/2
    AND V=VEC 38
    AND V2=VEC (TITLEN+1)/2
    AND V3=VEC 100	// for the unpacked command line
    AND COMMF=0		// for the command line itself

    SDATE,STIME,TITLE:=V,V+6,V+12
    TLEN,TITLE!0:=0,0	//Set null title
    DATE(SDATE)
    UNPACKSTRING(SDATE, V3)
    V3!5 := V3!5+32; V3!6 := V3!6+32
    PACKSTRING(V3, SDATE)
    ENDUP,NPPENDING:=FALSE,FALSE
    WIDTH,LENGTH,GAP:=112,60,4
    NUMBERING,AUTO:=FALSE,TRUE
    HEADERS:=TRUE
    QUIT:=FALSE
    TCH:=0
    OUTFILE:=V1
    INFILE:=V2
    COMMF:=GETCOMMAND("File to list : ")
    COMMLINE := V3
    UNPACKSTRING(COMMF, COMMLINE)
    COMMPTR:=0
    INF:=-1
    OUTF:=-1
    ENDUP:=FALSE

    $(	LET FORCEAUTO(STR) BE
	$(  WRITEF("%S - auto forced*N", STR)
	    AUTO:=TRUE
	    $)

	SELECTOUTPUT(SYSOUT)
	INFL:=READFILENAME(INFILE)
	UNLESS INFL=0 DO
	$(  INF:=FINDINPUT(INFILE)
	    IF INF<=0 DO $( WRITEF("File %S not available*N",INFILE)
			    UNTIL TCH='*N' DO RCH()
			    FINISH
			    $)

		IF OUTF<0 DO 	// find default output file
		$(  INITLP(OUTFILE) // get a title for it
		    OUTF:=FINDOUTPUT(OUTFILE) // and create it
		    IF OUTF<0 DO OUTF:=SYSOUT // fallback situation!
		    $)

		TOD(STIME); STIME!0:=STIME!0-3
		TAB2:=WIDTH-INFL-TLEN-27
		TAB1:=TAB2/2
		TAB2:=TAB2-TAB1
    IF WIDTH>150 $( WIDTH:=150;WRITES("Width too great - 150 assumed*N") $)
    UNLESS AUTO \/ NCOLS<=20 FORCEAUTO("Too many columns")
    UNLESS AUTO DO
    $(	CWIDTH:=(WIDTH+GAP)/NCOLS-GAP
	IF CWIDTH<=(NUMBERING->8,0) FORCEAUTO("Columns too narrow")
	$)

    SELECTINPUT(INF);SELECTOUTPUT(OUTF)

    $(	LET V=VEC 7
	FOR I=0 TO 7 DO V!I:='*S'
	STATNO:=V
    $(	LET V1=VEC 20 AND V2=VEC 20
	PTRVEC,WIDVEC:=V1,V2

	APTOVEC(LMC,10000)	// do multi-columning
	ENDWRITE()		// terminate output (poss to printer)

	OUTF:=-1
		$)  $)
		$)
	IF ENDUP FINISH
                    $) REPEATWHILE TCH=','
                $)

AND APPEND(S1,S2) BE
$(  LET V1=VEC 25 AND V2=VEC 25
    AND I=0
    UNPACKSTRING(S1,V1)
    UNPACKSTRING(S2,V2)
    I:=V1!0
    FOR J=1 TO V2!0 DO
    $(	I:=I+1;V1!I:=V2!J	$)
    V1!0:=I
    PACKSTRING(V1,S1)
		$)

AND INIT(S) BE // init output to 'default' file (/O on its own)

$(  FOR I=0 TO 7 DO S!I:="MCOUTPUTF.TMP"!I
    $)

AND INITLP(S) BE // init output to printer

$(  LET LPFVEC=VEC TITLEN
    AND INPFVEC=VEC TITLEN
    AND LPPTR=0 AND INDIR=FALSE

    LET MULTAB=TABLE '.', 'M', 'U', 'L'

    // initial part of output title is printer device name
    UNPACKSTRING("LP:", LPFVEC)
    UNPACKSTRING(INFILE, INPFVEC)
    LPPTR:=LPFVEC!0

    // append filename part of INPFVEC
    FOR I=1 TO INPFVEC!0 DO
    $(	LET CH=INPFVEC!I
	IF (CH='.' /\ \INDIR) \/ CH=';' BREAK
	LPPTR:=LPPTR+1; LPFVEC!LPPTR:=CH

	IF CH='[' \/ CH='<' THEN INDIR:=TRUE
	IF CH=']' \/ CH='>' THEN INDIR:=FALSE
	IF CH=':' \/ CH=']' \/ CH='>' DO
	    LPPTR:=LPFVEC!0	// fold back at end of input device/directory
	$)

    // append extension .MUL
    FOR I=0 TO 3 DO
    $(	LPPTR:=LPPTR+1
	LPFVEC!LPPTR:=MULTAB!I
	$)

    LPFVEC!0:=LPPTR
    PACKSTRING(LPFVEC, S)  // return output

//  SELECTOUTPUT(SYSOUT)
//  WRITES(S); NEWLINE()
//  SELECTOUTPUT(O)

    $)

.
