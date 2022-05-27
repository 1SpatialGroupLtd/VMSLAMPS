$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-05-14 17:57:46.000000000 +0100
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
$! find out which version he wants to play with$ SET NOON$ SAVP1:='P1'$GETP1:$ IF P1.EQS."" THEN INQUIRE P1 "Who for [OS or MCE] ? "$ IF P1.EQS."" THEN EXIT$ IF P1.EQS."MCE" THEN GOTO GOTP1$ IF P1.EQS."OS"  THEN GOTO GOTP1$ WRITE SYS$OUTPUT "Unknown customer ",P1$ P1:=$ GOTO GETP1$GOTP1: $ IF SAVP1.EQS."" THEN GOTO ASKP2$GETP2:$ IF P2.EQS."" THEN P2:=LITE$ IF P2.EQS."LITES" .OR. P2.EQS."LIT" THEN P2:=LITE$ IF P2.EQS."LITE" THEN GOTO GOTP2$ IF P2.EQS."SOL" THEN GOTO GOTP2$ WRITE SYS$OUTPUT "Unknown editor type ",P2$ASKP2:$ INQUIRE P2 " SOL or LITES ? "$ GOTO GETP2$GOTP2:$ VERS:='P2$ IF VERS.EQS."LITE" THEN VERS:=LITES$ WRITE SYS$OUTPUT "***   Version is ",VERS," for ",P1,"   ***"$ WHAT:='P1''P2'$ IF P2.EQS."LITE" THEN WHAT:='P1'IGE$ DISC=F$LOGICAL("DEVT$DISK")-"_"-"_"$ IF DISC .EQS. "" THEN DISC=F$LOGICAL("LSL$DISK")$ XXX:='F$LOGICAL("SOLSOL")'$ IF XXX.EQS."" THEN ASSIGN 'DISC'<SOL.SOL> SOLSOL$ XXX:='F$LOGICAL("LISTQ")'$ IF XXX.EQS."" THEN ASSIGN 'DISC'<SOL.SOL> LISTQ$ XXX:='F$LOGICAL("SRC")'$ IF XXX.EQS."" THEN ASSIGN 'DISC'<SOL.SOURCE> SRC$ XXX:='F$LOGICAL("CMN")'$ IF XXX.EQS."" THEN ASSIGN 'DISC'<SOL.COMMON> CMN$ XXX:='F$LOGICAL("MAR")'$ IF XXX.EQS."" THEN ASSIGN 'DISC'<SOL.MACRO> MAR$ XXX:='F$LOGICAL("OBJ")'$ IF XXX.NES."" THEN DEASSIGN OBJ$ ASSIGN 'DISC'<SOL.'WHAT'OBJ> OBJ$ XXX:='F$LOGICAL("EXE")'$ IF XXX.NES."" THEN DEASSIGN EXE$ ASSIGN 'DISC'<SOL.'WHAT'EXE> EXE$ XXX:='SOLINI'$ IF XXX.NES."" THEN SOLINI$ SI 'P1'.IFF$ GSOL:==@SOLSOL:GSOL$ MSOL:==@SOLSOL:MSOL