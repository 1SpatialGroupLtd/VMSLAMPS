GET "LIBHDR"

GLOBAL $(
CH		: 200
INFILE		: 201
LINO		: 202
PAGNO		: 204
POSP		: 205
POSL		: 206
TCH		: 207
NEGL		: 208
NEGW		: 209
LIST		: 210
FORMFEED	: 212
ENDUP		: 213
NOPAGETHROWS	: 214
HEADINGS	: 215
SUPPRESS	: 216
ENDFL		: 218
NPPENDING	: 219
STIME		: 220	// string holding time of listing
INFL		: 221
SDATE		: 222	// string holding date of listing
OUTF		: 223
LENGTH		: 224
WIDTH		: 225
TAB1		: 226
TAB2		: 227
TITLE		: 228
TLEN		: 229
COPYFILE	: 230
WHEADER		: 231
SPACE		: 232
READFILENAME	: 233
RCH		: 234
OUTFILE		: 240
COMMLINE	: 241	// unpacked command line
COMMPTR		: 242	// pointer on command line

QUIT		: 249

OUTTOSPOOL	: 250	// whether or no to spool output
DONTSPOOL	: 251	// suppress spooling (temporary, for benefit of SHAPE)

BURBLE		: 252	// reflect title of LP: output file (/B switch)
$)

MANIFEST $(
TITLEN		= 150	//  permitted length of file title, title label
$)

LET WHEADER() BE
$(  WRITES(SDATE);WRITES("  ");WRITES(STIME);SPACE(TAB1)
    WRITES(INFILE);WRITES(TLEN=0->"   "," - ")
    WRITES(TITLE);SPACE(TAB2)
    WRITEF("Page%I4*N*N",PAGNO)
    PAGNO:=PAGNO+1
		$)

AND SPACE(N) BE FOR I=1 TO N DO WRCH('*S')

AND READFILENAME(FN)=VALOF
$(  LET V=VEC TITLEN AND I,ONOFF,NOTUIC=0,TRUE,TRUE
    RCH() REPEATWHILE TCH='*S' \/ TCH='*T' \/ TCH='*N'
    UNTIL TCH='*N'\/TCH='/'\/(TCH=','/\NOTUIC) \/ TCH=ENDSTREAMCH DO
    $(	IF TCH='[' \/ TCH='<' NOTUIC:=FALSE
	IF TCH=']' \/ TCH='>' NOTUIC:=TRUE
	IF TCH='*S' $(	RCH();LOOP  $)
	UNLESS 'A'<=TCH<='Z' \/ '0'<=TCH<='9' \/ TCH='.' \/ TCH=';' \/
		TCH='<' \/ TCH='>' \/ TCH='$' \/ TCH='_' \/ TCH='-' \/
		TCH=':' \/ TCH='[' \/ TCH=']' \/ TCH=',' DO
	$(  LET X=VEC 100
	    V!0:=I;PACKSTRING(V,X);WRITES(X)
	    WRCH(' ');WRITEF(": duff character '%C'(%N)", TCH, TCH); NEWLINE()
	    RESTART()	$)
	TEST I<TITLEN
	THEN $( I:=I+1; V!I:=TCH $)
	ELSE $( WRITES("File title too long*N"); RESTART() $)
	RCH()
	$)
    V!0:=I;PACKSTRING(V,FN)
    UNTIL TCH='*N'\/TCH=',' DO
    $(	TEST TCH='-' THEN $( ONOFF:=FALSE;RCH() $)
			OR ONOFF:=TRUE
	SWITCHON TCH INTO
	$(		// line nos on/off
	    CASE 'L':	LIST:=ONOFF;ENDCASE
			// formfeed ignore switch
	    CASE 'F':	FORMFEED:=ONOFF;ENDCASE
			// width of page
	    CASE 'W':	WIDTH:=READNFROMCMD()
			LOOP
			// source lines per page
	    CASE 'P':	LENGTH:=READNFROMCMD()
			LOOP
			// title to append to file name
	    CASE 'T':	$(  LET PROTOTITLE=VEC TITLEN AND INSTRING=FALSE
			TLEN:=0;RCH()
			IF TCH='"' DO $( INSTRING:=TRUE; RCH() $)
			UNTIL TCH='*N' \/ (TCH=',' /\ \INSTRING) \/
			      (TCH='"' /\ INSTRING) \/
			      TCH=ENDSTREAMCH DO
			$(  UNLESS TLEN>=TITLEN DO
			    $(	TLEN:=TLEN+1
				PROTOTITLE!TLEN:=TCH
					$)
				RCH()	$)
			PROTOTITLE!0:=TLEN
			PACKSTRING(PROTOTITLE,TITLE)
			BREAK	$)
			// non-default output stream
	    CASE 'O':	IF READFILENAME(OUTFILE)=0 INIT(OUTFILE)
			OUTF:=FINDOUTPUT(OUTFILE)
			OUTTOSPOOL:=TRUE // assume he's given a real file
			IF OUTF<0 DO
			    WRITEF("Output %S not available*N",OUTFILE)
			NPPENDING:=FALSE
			BREAK
			// headings
	    CASE 'H':	HEADINGS:=ONOFF
			ENDCASE
			// formfeeds - output
	    CASE 'N':	NOPAGETHROWS:=ONOFF
			ENDCASE
			// formfeeds - source
	    CASE 'S':	SUPPRESS:=ONOFF
			ENDCASE
	    CASE ENDSTREAMCH:
			ENDUP:=TRUE
	    CASE '*N':
	    CASE ',':	BREAK
			// Burble - output LP: output file
	    CASE 'B':	BURBLE:=ONOFF
			// null switch
	    CASE '/':	ENDCASE
	    CASE '#':	UNTIL TCH='*N' \/ TCH=',' \/ TCH=ENDSTREAMCH DO RCH()
			BREAK
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
$(  LET V1=VEC TITLEN/2
    AND V=VEC TITLEN/2 AND VD = VEC 6 AND VT = VEC 6
    AND V2=VEC TITLEN/2
    AND V3=VEC 256	// for the unpacked command line, etc
    AND INF=0
    AND COMMF=0

    SDATE := VD
    STIME := VT
    TITLE := V
    TLEN,TITLE!0:=0,0	//Set null title
    DATE(SDATE)
    UNPACKSTRING(SDATE, V3)
    V3!5 := V3!5+32; V3!6 := V3!6+32
    PACKSTRING(V3, SDATE)
    ENDUP,NOPAGETHROWS,NPPENDING:=FALSE,FALSE,FALSE
    WIDTH,LENGTH:=112,60
    LIST,FORMFEED:=TRUE,TRUE
    SUPPRESS:=FALSE
    BURBLE:=FALSE
    QUIT:=FALSE
    HEADINGS:=TRUE
    OUTFILE:=V1
    INFILE:=V2
    DONTSPOOL:=FALSE
    COMMF:=GETCOMMAND("File to list : ")
//  WRITEF('Command string %S*N', COMMF)
    COMMLINE := V3
    UNPACKSTRING(COMMF, COMMLINE)
    COMMPTR:=0
    OUTF:=-1
    ENDUP:=FALSE

    $(	SELECTOUTPUT(SYSOUT);SELECTINPUT(COMMF)
	INFL:=READFILENAME(INFILE)
	UNLESS INFL=0 DO
	$(  INF:=FINDINPUT(INFILE)
	    IF INF<=0 DO $( WRITEF("File %S not available*N",INFILE)
			    FINISH
			    $)
	IF OUTF<0 DO // no outfile specified - use default spooled printer
	$(  INITLP(OUTFILE)
	    OUTF:=FINDOUTPUT(OUTFILE)
	    IF OUTF<=0 DO
	    $(	WRITES("Printer output not available")
		ENDREAD()
		FINISH
		$)
	    $)
	SELECTINPUT(INF);SELECTOUTPUT(OUTF)
	TOD(STIME); STIME!0:=STIME!0-3
	NEGL,NEGW:=-LENGTH,-WIDTH
	TAB2:=WIDTH-INFL-TLEN-27
	TAB1:=TAB2/2
	TAB2:=TAB2-TAB1
	COPYFILE()
	ENDWRITE();	// *** change from RSX version
	DONTSPOOL:=FALSE
	OUTF:=-1
	SELECTOUTPUT(SYSOUT)
	ENDREAD()
	SELECTINPUT(SYSIN)
	$)
    IF QUIT THEN
    $(	QUIT:=FALSE
	UNLESS COMMF=SYSIN RESTART()
	$)
    IF ENDUP FINISH

    $) REPEATWHILE TCH=','
$)

AND RESTART() BE
$(  UNLESS OUTPUT()=SYSOUT DO
    $(	ENDWRITE();OUTF:=-1
	NPPENDING:=TRUE $)
    SELECTINPUT(SYSIN)
    FINISH
		$)

AND INIT(S) BE // initialise to default output file (/O)

$(  FOR I=0 TO 7 DO S!I:="LLISTFILE.TMP"!I
    DONTSPOOL:=TRUE
    $)

AND INITLP(S) BE // default initialise to spooled printer file

$(  LET LPFVEC = VEC TITLEN
    AND INPFVEC = VEC TITLEN
    AND LPPTR = ? AND INDIR = FALSE
    LET LSTTAB = TABLE '.','L','S','T'

    UNPACKSTRING("LP:", LPFVEC)
    UNPACKSTRING(INFILE, INPFVEC)
    LPPTR:=LPFVEC!0

    FOR I=1 TO INPFVEC!0 DO
    $(	LET CH=INPFVEC!I
	IF (CH='.' & \INDIR) \/ CH=';' BREAK
	LPPTR:=LPPTR+1; LPFVEC!LPPTR:=CH
	IF CH='[' \/ CH='<' THEN INDIR:=TRUE
	IF CH=']' \/ CH='>' THEN INDIR:=FALSE
	IF CH=':' \/ CH=']' \/ CH='>' DO
	    LPPTR:=LPFVEC!0 // fold back at end of input device or directory
	$)

    FOR I=0 TO 3 DO // append extension .LST
    $(	LPPTR:=LPPTR+1
	LPFVEC!LPPTR:=LSTTAB!I
	$)

    LPFVEC!0:=LPPTR
    PACKSTRING(LPFVEC, S) // return output

    IF BURBLE DO WRITEF("Output to %S*N", S)

    OUTTOSPOOL:=FALSE

    $)

AND COPYFILE() BE
$(  LET REPLN=FALSE
    POSP,POSL:=NEGL,NEGW
    LINO,PAGNO:=1,1
    IF NPPENDING $(  WRCH('*P');NPPENDING:=FALSE  $)

    CH:=RDCH()

    $(P
	UNLESS CH=ENDSTREAMCH \/ NOPAGETHROWS \/ NOT HEADINGS DO
	$(  WHEADER();POSP:=POSP+2  $)

	$(N IF CH=ENDSTREAMCH RETURN
	    IF LIST DO
	    $(	IF REPLN LINO:=LINO-1
		WRITED(LINO,5); WRCH(REPLN->'+','*S')
		REPLN:=FALSE
		SPACE(2)
		LINO:=LINO+1
		$)

	    $(S TEST CH<#40 THEN
		SWITCHON CH INTO
		$(  CASE #16:	// set 'bold' (Centronics printer)
		    CASE #22:	// switch density (Centronics printer)
				POSL:=0
				GOTO REPEATIT

		    CASE '*T':	$(  LET SPOSL=POSL+1
				    POSL:=POSL+8-(POSL+WIDTH) REM 8
				    CH := #40
				    WHILE SPOSL<POSL DO
				    $(	WRCH(CH)
					SPOSL:=SPOSL+1
					$)
				    $)
		    REPEATIT:	WRCH(CH)
		    DEFAULT:	CH:=RDCH()
				ENDCASE

		    CASE '*N':	CH:=RDCH()
		    NLBIT:	WRCH('*N')
				POSP,POSL:=POSP+1,NEGW
				IF POSP>=0 DO
				$(  POSP:=NEGL
				    UNLESS NOPAGETHROWS DO
				    $(	WRCH('*P')
					GOTO OUTERMOST	$)
						$)
				BREAK

		    FFBIT:
		    CASE '*P':	CH:=RDCH(); REPLN:=\FORMFEED
				IF SUPPRESS GOTO NLBIT
				/* UNLESS POSL=NEGW DO */ WRCH('*N')
				WRCH('*P')
				POSP,POSL:=NEGL,NEGW
				GOTO OUTERMOST

		    EOFBIT:
		    CASE ENDSTREAMCH:
				UNLESS POSL=NEGW DO
				$(  WRCH('*N');POSP:=POSP+1  $)
				UNLESS POSP=NEGL DO
				    NPPENDING:=TRUE
				RETURN

		    CRBIT:
		    CASE #15:	CH:=RDCH()
				WRCH(#15)	//CR
				$(  LET GAP=LIST->FORMFEED->16,8,0
				    POSL:=NEGW+GAP;SPACE(GAP)  $)
				ENDCASE

		    CASE #13:	CH:=RDCH;BREAK
			$)

		OR $(
		IF POSL>=0 DO
		$(  WRCH('*N')
		    POSP,POSL:=POSP+1,NEGW
		    IF POSP>=0 DO
		    $(	POSP:=NEGL
			UNLESS NOPAGETHROWS DO
			$(  WRCH('*P')
			    IF HEADINGS $( WHEADER()
					POSP:=POSP+2  $)  $)
				$)
			$)
		WRCH(CH);POSL:=POSL+1
		CH:=RDCH()
		$)

		  $)S REPEAT  //TO SWITCHON

	      $)N REPEAT  //NEWLINE

OUTERMOST:	$)P REPEAT  //NEW PAGE

		$)

.
