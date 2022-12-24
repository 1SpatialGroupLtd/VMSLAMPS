$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-02-24 12:02:42.000000000 +0000
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
$!
$! OS111LINK.COM - command file for structuring the OS sheet 111
$! digitised data.
$!
$! Note that before this command file is run, a file HERE:ILINKSTAT.DAT
$! should be written, telling ILINK how many points and features it is
$! going to have to contend with.
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!  #	O.S. Layer Specifications
$!==================================
$!  0.	Map corner points
$!  1.	Admin area boundaries
$!  2.	Wood boundaries
$!  3.	Urban boundaries
$!  4.	Seed points
$!  5.	Water features
$!  6.	Roads
$!  7.	Railways
$!  8.	Map symbols
$!  9.	Point features
$! 10.	Electricity transmision lines
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	SAVVER=F$VERIFY(0)
$	ILINK=="$LSL$DISK:[MCE.ILINK.EXE]ILINK"
$	RELHT=="$HERE:RELHT"
$	SD HERE:
$	SI HERE:
$	IF "''F$TRNLNM(""LSL$LITES2CMD"")'".EQS."" THEN LITES2INI
$	IF "''F$TRNLNM(""LSL$RELHT_PRIO"")'".EQS."" THEN -
		DEFINE LSL$RELHT_PRIO HERE:RELHT.PRIO
$	IF P1.EQS."" THEN P1="OS111"
$	IF P2.EQS."RELHT" THEN GOTO RELHT
$	IF P2.EQS."LLJOIN" THEN GOTO LLJOIN
$	IF P2.EQS."LPJOIN" THEN GOTO LPJOIN
$	IF P2.EQS."BREAK" THEN GOTO BREAK
$	IF P2.EQS."PPJOIN" THEN GOTO PPJOIN
$	SET VERIFY
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Join features to feature-ends, viz. join between all physical
$! features except except water features and electricity lines, and
$! boundaries (admin, wood or urban), and seed-points.
$!
$	ILINK 'P1' 'P1'A/LPJOIN/JNTOL=20/EXT=20/VERTEX/BREAK/LAYER=(6,7)/MONITOR
$	XX=f$VERIFY(0)
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Align physical features (except electricity lines and seed-points)
$! with boundaries, merging all shared sections.
$!
$LLJOIN:
$	SET VERIFY
$	ILINK 'P1'A 'P1'B/LLJOIN/JNTOL=20/BREAK/FCP=HERE:OS111/LAYER=(1:3,6:9)/MONITOR/BPF=2
$	XX=f$VERIFY(0)
$	SHOW PROCESS/ACC
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Join all feature-ends to features - except electricity lines and
$! seed-points.
$!
$LPJOIN:
$	SET VERIFY
$	ILINK 'P1'B 'P1'C/LPJOIN/JNTOL=15/EXT=15/VERTEX/BREAK/LAYER=(1:3,5:9)/MONITOR
$	XX=f$VERIFY(0)
$	SHOW PROCESS/ACC
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Break features (except electricity lines) into separate features
$! where they eachother (but not where they cross seed-points).
$!
$BREAK:
$	SET VERIFY
$	ILINK 'P1'C 'P1'D/BREAK/LAYER=(1:3,5:9)/MONITOR
$	XX=f$VERIFY(0)
$	SHOW PROCESS/ACC
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Join all feature-ends & point features which are very close (except
$! electricity lines and seed-points).
$!
$PPJOIN:
$	SET VERIFY
$	ILINK 'P1'D 'P1'E/PPJOIN/JNTOL=10/STRUCTURE/LAYER=(1:3,5:9)/MONITOR
$	XX=f$VERIFY(0)
$	SHOW PROCESS/ACC
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Set relative-height AC information as required by OS
$!
$RELHT:
$	SET VERIFY
$	RELHT 'P1'E 'P1'H/NODE/LOG/LITES
$!
$	PURGE/LOG 'P1'%.IFF,'P1'%.LIS,LSL$LITES2CMD:'P1'%.LCM
$	SET NOVERIFY
$	COST
$	IF SAVVER THEN SET VERIFY
