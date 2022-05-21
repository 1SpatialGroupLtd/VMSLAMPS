;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1983-11-15 15:30:10.000000000 +0000
; *
; * This program is free software: you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation, version 3.
; *
; * This program is distributed in the hope that it will be useful, but
; * WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; * General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program. If not, see http://www.gnu.org/licenses/.
;
.ASK ALL All
.IFF ALL .GOTO WASK
.SETT DDC
.SETT BS 
.SETT VG 
.SETT OD 
.SETT NL 
.SETT IP 
.SETT RF 
.SETT LC 
.SETT NEWL
.GOTO WMAC
.WASK: .ASK DDC TDDC02,TSCB02 & TKDDCG,DSUBST,DREPT
.ASK BS TKBS
.ASK IP TKIP
.ASK NL TKNL
.ASK OD TKOD
.ASK RF TKRF
.ASK VG TKVG
.ASK LC LSCH
.ASK NEWL New Library
.WMAC: .IFT NEWL .SETF REPM
.IFF NEWL .SETT REPM
.iff ddc .goto wmac1
adc tkddcg.ftn=tkddcg,drept,substt
f4p tkddcg=tkddcg
pvr tkddcg
pip tkddcg.ftn;*,adc.ide;*/de
mac tddc=tkhd02,thkpar,tkddcp,tkws02,tkvw02,tddc02
mac tscb=tkhd02,thkpar,tkddcp,tkws02,tkvw02,tscb02
mac dsubst=tkhd02,tkddcp,dsubst
mac lscb=tkhd02,tkws02,lscb02
.iff newl LBR pwosplib/RP=tkddcg,tddc,dsubst,tscb
.iff newl LBR pwosplib/-EP/RP=lscb
.wmac1: .ift bs mac tkbs=tkhd02,tkws02,tkvw02,tkbs02
.ift bs .ift repm LBR pwosplib/RP=tkbs
.ift vg mac tkvg=tkhd02,tkvw02,tkws02,tkvg02
.ift vg mac lcvg=lchd02,tkhd02,tkvw02,tkws02,tkvg02
.ift vg mac lcvg14=lc1402,lchd02,tkhd02,tkvw02,tkws02,tkvg02
.ift vg .ift repm LBR pwosplib/RP=tkvg
.ift vg .ift repm LBR pwosplib/-EP/RP=lcvg
.ift vg .ift repm LBR pwosplib/-EP/RP=lcvg14
.ift od mac tkod=tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkod02
.ift od mac lcod=lchd02,tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkod02
.ift od mac lcod14=lc1402,lchd02,tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkod02
.ift od .ift repm LBR pwosplib/RP=tkod
.ift od .ift repm LBR pwosplib/-EP/RP=lcod
.ift od .ift repm LBR pwosplib/-EP/RP=lcod14
.ift nl mac tknl=tkhd02,tknl02
.ift nl .ift repm LBR pwosplib/RP=tknl
.ift ip mac tkip=tkhd02,tkiw02,tkrw02,tkvw02,tkws02,tkip02
.ift ip .ift repm LBR pwosplib/RP=tkip
.ift rf mac tkrf=tkhd02,tkrw02,tkiw02,tkvw02,tkws02,tkrf02
.ift rf mac lcrf=lchd02,tkhd02,tkrw02,tkiw02,tkvw02,tkws02,tkrf02
.ift rf mac lcrf14=lc1402,lchd02,tkhd02,tkrw02,tkiw02,tkvw02,tkws02,tkrf02
.ift rf .ift repm LBR pwosplib/RP=tkrf
.ift rf .ift repm LBR pwosplib/-EP/RP=lcrf
.ift rf .ift repm LBR pwosplib/-EP/RP=lcrf14
.ift lc mac lsch=lchd02,tkhd02,lscw02,tkws02,lsch02
.ift lc .ift repm LBR pwosplib/-EP/RP=lsch
.ift repm .goto wlnk
LBR pwosplib/CR:20=tkddcg,tddc,dsubst,tscb,tkbs,tkip,tknl,tkod,tkrf,tkvg
LBR pwosplib/IN/-EP=lscb,lcvg,lcod,lcrf,lsch
LBR pwosplib/IN/-EP=lcvg14,lcod14,lcrf14
pip pwosplib.olb/pu
.wlnk:
