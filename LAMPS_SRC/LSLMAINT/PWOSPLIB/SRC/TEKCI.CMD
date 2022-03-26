.ask TEK TEKCI
.ask PIC picl,cspeed,chtest
.ask CUR curve
.ask TCI Build TEKCI
.ask LCI Build LTEKCI
.ask L14CI Build L14CI
.iff TEK .goto NOTEK
adc tekci.ftn=tekci
f4p tekci=tekci
pvr tekci
pip tekci.ftn;*,adc.ide;*/de
.NOTEK: .iff PIC .goto NOPIC
adc picl.ftn=picl,cspeed,chtest
f4p picl=picl
pvr picl
pip picl.ftn;*,adc.ide;*/de
.NOPIC: .iff CUR .goto NOCUR
mac curve=tkhd02,curve
.NOCUR: .iff TCI .goto notci
TKB @tekci.tkb
pip tekci.*/pu
.NOTCI: .iff LCI .goto nolci
TKB @ltekci.tkb
pip ltekci.*/pu
.NOLCI: .iff L14CI .goto nolnk
TKB @l14ci.tkb
pip l14ci.*/pu
.NOLNK: pip *.obj/pu
