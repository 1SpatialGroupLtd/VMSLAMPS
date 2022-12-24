$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-03-09 18:23:26.000000000 +0000
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
$! command file to test out operation of SLOPES
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mtg1
slope 1
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mtg2
slope 2
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mtg3
slope 3
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mtg4
slope 4
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mta
aspect
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mthd
height_d
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mtshd
shade
exit
$ show status
$ run slopesuis/nodeb
filein os44000800
fileo mtg1nb
enable null_border
slope 1
exit
$! now do the same using the old slopes
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mtg1_old
slope 1
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mtg2_old
slope 2
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mtg3_old
slope 3
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mtg4_old
slope 4
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mta_old
aspect
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mthd_old
hdiff
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mtshd_old
shade
exit
$ show status
$ run lsl$public_root:[tves.exe]slopesuis
file os44000800
win 1 1 401 401
plot dti mtg1nb_old
enable null_border
slope 1
exit
$!
$! now DTICOMBINE them to ensure they are the same
$ run lsl$public_root:[matrix.exe]dticombine
filea mtg1.slp
fileb mtg1_old.slp
fileout g1_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mtg2.slp
fileb mtg2_old.slp
fileout g2_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mtg3.slp
fileb mtg3_old.slp
fileout g3_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mtg4.slp
fileb mtg4_old.slp
fileout g4_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mta.slp
fileb mta_old.slp
fileout a_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mtshd.slp
fileb mtshd_old.slp
fileout shd_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mthd.slp
fileb mthd_old.slp
fileout hd_diff
word  = a-b
go
$ run lsl$public_root:[matrix.exe]dticombine
filea mtg1nb.slp
fileb mtg1nb_old.slp
fileout g1nb_diff
word  = a-b
go
