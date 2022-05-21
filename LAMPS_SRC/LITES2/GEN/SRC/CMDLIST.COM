$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-12-03 16:16:42.000000000 +0000
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
$	open in HLP:LITES2.HLP
$	on control then goto done
$	copy GEN:CMDLIST.HDR .RNO
$	open/append out CMDLIST.RNO
$	oldchar=""
$	oldcommand=""
$	oldkey=""
$loop:
$	read/end=done in line
$	if line.eqs."" then goto loop
$	char=f$extract(0,1,line)
$	if char.lts."1" .or. char.gts."9" then goto loop
$	linlen=f$len(line)
$	if linlen.lt.3 then goto loop
$	key=f$edit(f$extract(2,linlen-2,line),"trim")+" "
$	if char.eqs."1" 
$	then
$	   command=key
$	else
$	   if char.gts.oldchar 
$	   then
$	      command=f$edit(command,"lowercase")+key
$	      oldstub=f$edit(oldkey,"lowercase")
$	   else
$	      if char.lts.oldchar 
$	      then
$	         command=command-oldstub-oldkey+key
$	      else
$	         command=command-oldkey+key
$	      endif
$	   endif
$	endif
$	command=f$edit(command,"compress")
$	string=command+"...................................................."
$	string=f$extract(0,40,string)+" "
$	level='char'-1
$indent:
$	if level.gt.0 
$	then 
$	   string=string+"- "
$	   level=level-1
$	   goto indent
$	endif
$	read/end=done in line
$	skip=0
$	if f$extract(0,20,line).eqs."The following LITES2" then skip=1
$	if skip
$	then
$	  write sys$output " "
$	  write     out    " "
$	  write     out    ".END LITERAL"
$	  write     out    ".TEST PAGE 6"
$	  write     out    ".LITERAL"
$	endif
$	write sys$output string,line
$	write     out    string,line
$	if skip
$	then
$	  write sys$output " "
$	  write     out    " "
$	endif
$	oldchar=char
$	oldcommand=command
$	oldkey=key
$	goto loop
$done:
$	close in
$	write     out    ".END LITERAL"
$	close out
$	exit
