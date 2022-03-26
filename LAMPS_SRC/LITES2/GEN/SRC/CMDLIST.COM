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
