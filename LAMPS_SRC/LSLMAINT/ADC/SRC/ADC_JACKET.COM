$	ver=f$verify(0)
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! ADC_JACKET.COM			Author:	Steve Townrow	25-Jan-1995
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Command file necessary because the command line of the old ADC
$! (written in BCPL) is different to the new ADC (re-written as ADCC)
$!
$! In order for existing LAMPS utilites to use ADC with out having to
$! alter the format of the ADC command line, this DCL procedure will alter
$! the command line and call ADCC in the correct way. When compiling on the
$! VAX, the original ADC program will be used.
$!
$! The format of the old ADC is :
$!
$!	ADC RDPAR/CO = TRUTH.TR/TR,RDPAR,RDLAYER,RDENTITY,RDTEXT
$!
$! which must be turned into:
$!
$!	ADCC/COMMENT=ALL/TRUTH=TRUTH.TR RDPAR,RDLAYER,RDENTITY,RDTEXT  RDPAR
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Check the system architecture for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$!
$! Append all the parameters together in case the arguments were
$! separated by spaces
$!
$	CLINE = P1+P2+P3+P4+P5+P6+P7+P8
$	IF F$LENGTH(CLINE).EQ.0
$	THEN
$	   IF VER THEN WRITE SYS$OUTPUT "No arguments given to ADC"
$	   GOTO the_end
$	ENDIF
$!
$! First, lets find the '=' and split up the line
$!
$	POS = F$LOCATE("=",CLINE)
$	IF POS.EQ.F$LENGTH(CLINE)
$	THEN
$	   IF VER THEN WRITE SYS$OUTPUT "No equals (=) on ADC command line"
$	   GOTO the_end
$	ENDIF
$	LEFTSTR = F$EXTRACT(0,POS,CLINE)
$	RGHTSTR = F$EXTRACT(POS+1,F$LENGTH(CLINE),CLINE)
$!
$! Now work on the left string to get the output filename
$!
$	POS = F$LOCATE("/",LEFTSTR)
$	OUTFILE = F$EXTRACT(0,POS,LEFTSTR)
$!
$! Now look for any qualifiers
$!
$	QUALLINE = F$EXTRACT(POS+1,F$LENGTH(LEFTSTR),LEFTSTR)
$!
$! Put slash ('/') on end to find last qualifier
$!
$	QUALLINE = QUALLINE + "/"
$	OUTQ = ""
$!
$again:
$	POS = F$LOCATE("/",QUALLINE)
$	IF POS.LT.F$LENGTH(QUALLINE)
$	THEN
$	   QUAL = F$EXTRACT(0,POS,QUALLINE)
$	   IF F$EXTRACT(0,2,QUAL).EQS."SP" THEN OUTQ = OUTQ + "/PRINT"
$	   IF F$EXTRACT(0,2,QUAL).EQS."AP" THEN OUTQ = OUTQ + "/APPEND"
$	   IF F$EXTRACT(0,2,QUAL).EQS."TH" THEN OUTQ = OUTQ + "/THREAD"
$	   IF F$EXTRACT(0,2,QUAL).EQS."LN" THEN OUTQ = OUTQ + "/LN"
$	   IF F$EXTRACT(0,2,QUAL).EQS."CO" THEN OUTQ = OUTQ + "/COMMENT=ALL"
$	   IF F$EXTRACT(0,2,QUAL).EQS."LI" THEN OUTQ = OUTQ + "/COMMENT=OUTER"
$	   IF F$EXTRACT(0,2,QUAL).EQS."DE" THEN OUTQ = OUTQ + "/DEBUG"
$	   IF F$EXTRACT(0,2,QUAL).EQS."CD" THEN OUTQ = OUTQ + "/CD"
$	   IF F$EXTRACT(0,2,QUAL).EQS."LL" THEN OUTQ = OUTQ + "/"+QUAL
$	   IF F$EXTRACT(0,2,QUAL).EQS."IN" THEN OUTQ = OUTQ + "/IN"
$	   QUALLINE = F$EXTRACT(POS+1,F$LENGTH(QUALLINE),QUALLINE)
$	   GOTO again
$	ENDIF
$!
$! Now look for a truth file at the start of the right string
$!
$	POS = F$LOCATE("/TR,",RGHTSTR)
$	IF POS.LT.F$LENGTH(RGHTSTR)
$	THEN
$	   OUTQ = OUTQ + "/TR=" + F$EXTRACT(0,POS,RGHTSTR)
$	   RGHTSTR = F$EXTRACT(POS+4,F$LENGTH(RGHTSTR),RGHTSTR)
$	ENDIF
$!
$! Run appropriate version of ADC
$!
$	IF ARCH_NAME.EQS."VAX"
$	THEN
$	   ADCPROG == "$LSL$EXE:ADC.EXE"
$	   IF VER THEN WRITE SYS$OUTPUT "$ ADC "+CLINE
$	ENDIF
$!
$	IF ARCH_NAME.EQS."Alpha"
$	THEN
$	   ADCPROG == "$LSL$EXE:ADCC_TV.EXE"
$	   CLINE = OUTQ+" "+RGHTSTR+" "+OUTFILE
$	   IF VER THEN WRITE SYS$OUTPUT "$ ADCC "+CLINE
$	ENDIF
$!
$! Execute it.
$!
$	ADCPROG 'CLINE
$!
$the_end:
$	IF VER THEN SET VERIFY
