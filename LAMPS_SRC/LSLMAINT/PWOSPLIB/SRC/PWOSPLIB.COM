$	INQUIRE ALL "All"
$	IF .NOT. ALL THEN GOTO W_ASK
$	DDC = 1
$	BS  = 1
$	VG  = 1
$	OD  = 1
$	NL  = 1
$	IP  = 1
$	RF  = 1
$	LC  = 1
$	NEWL = 1
$	GOTO W_MAC
$!
$ W_ASK: INQUIRE DDC "TDDC02,TSCB02 & TKDDCG,DSUBST,DREPT"
$	INQUIRE BS  TKBS
$	INQUIRE IP  TKIP
$	INQUIRE NL  TKNL
$	INQUIRE OD  TKOD
$	INQUIRE RF  TKRF
$	INQUIRE VG  TKVG
$	INQUIRE LC  LSCH
$	INQUIRE NEWL "New Library"
$!
$ W_MAC: ON CONTROL_Y THEN EXIT
$	REPM = .NOT. NEWL
$	SET NOON
$	SET VER
$	if .not. ddc then goto w_mac1
$	adc tkddcg.ftn=tkddcg,drept,substt
$	f4p tkddcg=tkddcg
$	pvr tkddcg
$	del tkddcg.ftn;*,adc.ide;*
$	mcr mac tddc=tkhd02,thkpar,tkddcp,tkws02,tkvw02,tddc02
$	mcr mac tscb=tkhd02,thkpar,tkddcp,tkws02,tkvw02,tscb02
$	mcr mac dsubst=tkhd02,tkddcp,dsubst
$	mcr mac lscb=tkhd02,tkws02,lscb02
$	if .not. newl then mcr LBR pwosplib/RP=tkddcg,tddc,dsubst,tscb
$	if .not. newl then mcr LBR pwosplib/-EP/RP=lscb
$ w_mac1: if bs then mcr mac tkbs=tkhd02,tkws02,tkvw02,tkbs02
$	if bs .and. repm then mcr LBR pwosplib/RP=tkbs
$	if vg then mcr mac tkvg=tkhd02,tkvw02,tkws02,tkvg02
$	if vg then mcr mac lcvg=lchd02,tkhd02,tkvw02,tkws02,tkvg02
$	if vg then mcr mac lcvg14=-
lc1402,lchd02,tkhd02,tkvw02,tkws02,tkvg02
$	if vg .and. repm then mcr LBR pwosplib/RP=tkvg
$	if vg .and. repm then mcr LBR pwosplib/-EP/RP=lcvg
$	if vg .and. repm then mcr LBR pwosplib/-EP/RP=lcvg14
$	if od then mcr mac tkod=-
tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkod02
$	if od then mcr mac lcod=-
lchd02,tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkod02
$	if od then mcr mac lcod14=-
lc1402,lchd02,tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkod02
$	if od .and. repm then mcr LBR pwosplib/RP=tkod
$	if od .and. repm then mcr LBR pwosplib/-EP/RP=lcod
$	if od .and. repm then mcr LBR pwosplib/-EP/RP=lcod14
$	if nl then mcr mac tknl=tkhd02,tknl02
$	if nl .and. repm then mcr LBR pwosplib/RP=tknl
$	if ip then mcr mac tkip=-
tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkip02
$	if ip .and. repm then mcr LBR pwosplib/RP=tkip
$	if rf then mcr mac tkrf=-
tkhd02,tkrw02,tkiw02,tkvw02,tkws02,tkrf02
$	if rf .and. repm then mcr LBR pwosplib/RP=tkrf
$	if lc then mcr mac lsch=-
lchd02,tkhd02,lscw02,tkws02,lsch02
$	if lc .and. repm then mcr LBR pwosplib/-EP/RP=lsch
$!
$	if repm then goto w_lnk
$	mcr LBR pwosplib/CR:20=tkddcg,tddc,dsubst,tscb,tkbs,tkip,tknl,tkod,tkrf,tkvg
$	mcr LBR pwosplib/IN/-EP=lscb,lcvg,lcod,lsch
$	mcr LBR pwosplib/IN/-EP=lcvg14,lcod14
$	pl pwosplib.olb
$!
$w_lnk:	set nover
$!