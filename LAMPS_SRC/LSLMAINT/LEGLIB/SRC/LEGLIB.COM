$	ver = 'f$verify(0)
$!
$! command file to build VAX versions of Leglib
$! NOTE that these are now called legVlib (multiple legenda version)
$!      and legVone (single legenda version) so that they may be
$!      distinguished from the compatability mode versions
$!
$	DBG   = ""
$	LSTSW = ""
$!
$	inquire CMP "Compile"
$	inquire BLD "Build library"
$!
$	inquire DBG "Debug"
$	if DBG then DBG = "/DEBUG"
$!
$	inquire LST "Listing"
$	if LST then LSTSW = "/LIST"
$!
$	inquire ONE "One legenda option"
$	if      ONE then NAME="LEGVONE"
$	if .not.ONE then NAME="LEGVLIB"
$!
$	on error then goto QUIET
$	if .not.CMP then goto TRYBLD
$!
$! set up truth file
$!
$	open/write O [LIB.LEGLIB]TR.SRC
$	write O "VAX = 1"
$	write O "TXTVSP = 0"
$	if      ONE then write O "ONELEG = 1"
$	if .not.ONE then write O "ONELEG =0"
$	CLOSE O
$	PIP TR.SRC/NM/PU
$!
$! compile
$!
$	set verify
$	adc 'NAME'=tr.src/TR,addleg,drlegs,fincod,finleg,legwrd
$	adc 'NAME'/AP=tr.src/TR,rdleg,rdlegs
$	fort/NOI4'DBG''LST' 'NAME'
$	pvv 'NAME'
$	delete ADC.IDE;*
$	v = 'f$verify(0)
$! build
$TRYBLD:if .not.BLD then goto QUIET
$	set verify
$	LIB 'NAME'/CRE 'NAME'
$	v = 'f$verify(0)
$	pip 'NAME'.OBJ;*/NM/DE
$	if DBG.eqs."" then pip 'NAME'.FOR;*/NM/DE
$	if DBG.nes."" then pip 'NAME'.FOR/NM/PU
$	pip 'NAME'.LIS/NM,'NAME'.OLB/NM/PU
$QUIET:	v = 'f$verify(0)
$	if VER then set verify
