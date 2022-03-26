$	inquire TEK "TEKCI"
$	inquire PIC "picl,cspeed,chtest"
$	inquire CUR "curve"
$	inquire TCI "Build TEKCI"
$	inquire LCI "Build LTEKCI"
$	inquire L14CI "Build L14CI"
$	set ver
$	if .not. TEK then goto NOTEK
$	adc tekci.ftn=tekci
$	f4p tekci=tekci
$	pvr tekci
$	del tekci.ftn;*,adc.ide;*
$ NOTEK: if .not. PIC then goto NOPIC
$	adc picl.ftn=picl,cspeed,chtest
$	f4p picl=picl
$	pvr picl
$	del picl.ftn;*,adc.ide;*
$ NOPIC: if .not. CUR then goto NOCUR
$	mcr mac curve=tkhd02,curve
$ NOCUR: if .not. TCI then goto notci
$	mcr TKB @tekci.tkb
$	pl tekci.*
$ NOTCI: if .not. LCI then goto nolci
$	mcr TKB @ltekci.tkb
$	pl ltekci.*
$ NOLCI: if .not. L14CI then goto nolnk
$	mcr TKB @l14ci.tkb
$	pl l14ci.*
$ NOLNK: pl *.obj
$	set nover
