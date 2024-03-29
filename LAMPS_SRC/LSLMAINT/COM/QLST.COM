$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-01-04 14:22:56.000000000 +0000
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
$	v:='f$verify(0)'
$!set verify
$	if p1 .eqs. "" then inquire p1 "File "
$	if p1 .eqs. "" then goto reset_verify
$!
$! try collapsing arguments: link args <n> and <n+1> up if
$!				a) arg <n> ends with ","
$!				b) arg <n+1> starts with ","
$try_collapse_arg: if p2 .eqs. "" then goto args_not_collapsed
$	if f$extract(f$length(p1)-1,1,p1) .eqs. "," then goto strip_p1
$	if f$extract(0,1,p2) .nes. "," then goto args_not_collapsed
$	goto strip_p2
$strip_p1: p1=f$edit(f$extract(0,f$length(p1)-1,p1),"TRIM")
$	if f$extract(0,1,p2) .nes. "," then goto collapse_arg
$strip_p2: p2=f$edit(f$extract(1,f$length(p2)-1,p2),"TRIM")
$collapse_arg: p1=p1+","+p2
$	p2=p3
$	p3=p4
$	p4=p5
$	p5=p6
$	p6=p7
$	goto try_collapse_arg
$!
$! evaluate where the queue lives
$args_not_collapsed: qdir=f$logical("listq")
$	if qdir .eqs. "" then qdir=f$logical("sys$scratch")
$	if f$extract(0,1,qdir).eqs."_" then qdir=qdir-"_"
$	if f$extract(0,1,qdir).eqs."_" then qdir=qdir-"_"
$!	ss p1
$!
$! safety net
$	intlkd=0			! mark 'not got interlock yet'
$	on control then goto reset_verify
$!
$! despatch
$re_dispatch: fc_p1=f$extract(0,1,p1)
$	if fc_p1 .eqs. "*" .or. fc_p1 .eqs. "&" then goto print_it_all
$! rejoins here if file title '*<anythingbutanumber>', assuming that
$!		the <anything...> is not a count restricting a '*' command
$not_pr_ct: if fc_p1 .eqs. "?" then goto show_queue
$	if fc_p1 .eqs. "-" then goto remove_queue
$	if fc_p1 .eqs. "#" then goto unlock_queue
$	lister="LST"
$	if p2.eqs."M" .or. p2.eqs."MUL" then lister="MUL"
$	intlkd=0			! mark 'not got interlock yet'
$	pf:=""				! no previous file
$!
$! loop to here for next file
$comma_loop: af:='p1'
$	f_cnt=0
$	len_p1=f$len(p1)
$	comma=f$locate(",",p1)
$	if comma .ge. len_p1 then goto srch_f_f
$	p1=f$extract(0,comma,p1)
$	f_cnt=f_cnt+1
$!
$! search for one file
$srch_f_f: p=f$parse(p1,pf)
$	p=f$extract(0,f$locate(";",p),p)
$	if p .eqs. "" then write sys$output "Syntax error in ",p1
$	if p .eqs. "" .and. .not.intlkd then goto reset_verify
$	if p .eqs. "" .and. intlkd then goto tidy_exit
$	if f$extract(0,1,p).eqs."_" then p=p-"_"
$	if f$extract(0,1,p).eqs."_" then p=p-"_"
$	if f$extract(f$length(p)-1,1,p) .eqs. "." then -
				p=f$extract(0,f$length(p)-1,p)
$	pf:='p'
$	p_len=f$length(p)
$	ast_pos=f$locate("*",p)
$	prc_pos=f$locate("%",p)
$	is_wild=0
$	q_file_open=0
$	if ast_pos .lt. p_len .or. prc_pos .lt. p_len then -
					goto get_wild
$	f:='f$search(p,1)'
$	if f .eqs. "" then write sys$output -
			"File ",p," not found"
$	if f .eqs. "" .and. .not.intlkd then goto reset_verify
$	if f .eqs. "" .and. intlkd then goto tidy_exit
$	goto get_intlk
$!
$! find next of wild card sequence
$get_wild: is_wild=1
$next_wild: p:='f$search(pf,1)'
$	if p .nes. "" then goto got_a_wild
$	if is_wild then goto end_wild_sequence
$	write sys$output "No such file as ",pf
$	if .not.intlkd then goto reset_verify
$	if intlkd then goto tidy_exit
$!
$! end of wild card sequence
$end_wild_sequence: if q_file_open then close qf
$	goto find_next_file
$!
$! got a wild file
$got_a_wild: p=f$extract(0,f$locate(";",p),p)
$	if f$extract(0,1,p).eqs."_" then p=p-"_"
$	if f$extract(0,1,p).eqs."_" then p=p-"_"
$!
$! check no clash with other users
$get_intlk: if intlkd then goto got_intlk

$	intlkd=1
$loop_intlk0:
$	intlk=f$logical("QL_''qdir'")
$	if intlk .eqs. "" then goto q_ahead
$	if intlk .eqs. "1" then write sys$output -
		"Queue in ",qdir," is being printed"
$	if intlk .eqs. "1" then goto reset_verify
$	if intlk .nes. "0" then write sys$output -
		"Queue interlock for ",qdir," is corrupt"
$	if intlk .nes. "0" then goto reset_verify
$	wait 00:00:05.00
$	goto loop_intlk0
$!
$! not interlocked
$q_ahead: on control then goto tidy_exit
$	assign/group 0 ql_'qdir'
$!
$! interlock now got - process <>s out of file title
$got_intlk: p_len=f$length(p)
$	p_c_pos=f$locate(":",p)
$	if p_c_pos.ge.p_len then goto find_oang
$	p=f$getdvi(f$extract(0,p_c_pos,p),"devnam")-"_"+ -
		   f$extract(p_c_pos+1,p_len-p_c_pos,p)
$find_oang: p_len=f$length(p)
$	p_ang=f$locate("<",p)
$	if p_ang .ge. p_len then goto find_cang0
$	first_bit=p_ang
$	last_bit=p_len-p_ang-1
$	p_ang=p_ang+1
$	p=f$extract(0,first_bit,p)+"["+f$extract(p_ang,last_bit,p)
$	goto got_intlk
$!
$find_cang0: p_ang=f$locate(">",p)
$	if p_ang .ge. p_len then goto no_ang0
$	first_bit=p_ang
$	last_bit=p_len-p_ang-1
$	p_ang=p_ang+1
$	p=f$extract(0,first_bit,p)+"]"+f$extract(p_ang,last_bit,p)
$	goto find_cang0
$!
$! removed all angle brackets - now look for queue file
$no_ang0: pad=""
$	padlen=50-f$length(p)
$	if padlen.gt.0 then pad=f$extract(0,padlen,-
			"                                                 ")
$	if q_file_open then goto write_to_queue
$	q=f$search("''qdir'listqueue.com",2)
$	if q .eqs. "" then goto new_q_file
$!
$! add to an existing queue file
$	open/append qf 'qdir'listqueue.com
$	if is_wild then q_file_open=1
$	write qf lister," ",p,pad
$	if .not.is_wild then close qf
$	goto queued_file
$!
$! create a new queue file
$new_q_file: open/write qf 'qdir'listqueue.com
$	if is_wild then q_file_open=1
$write_to_queue: write qf lister," ",p,pad
$	if .not.is_wild then close qf
$!
$! reassure him that we've done something
$queued_file: if lister.nes."NOT" then -
			write sys$output "File ",p," queued for listing"
$	p=p-"!"
$	if lister.eqs."NOT" then write sys$output -
			"Files whose names contain """, p, """ suppressed"

$!
$! loop back for wild cards
$	if is_wild then goto next_wild
$!
$! look for next file in P1
$find_next_file: if lister .eqs. "NOT" then goto tidy_exit
$	if comma .ge. len_p1 then goto tidy_exit
$!
$! remove one comma
$	comma=comma+1
$	len_p1=len_p1-comma
$	if len_p1 .le. 0 then goto tidy_exit
$	p1=f$extract(comma,len_p1,af)
$	goto comma_loop
$!
$! list out the files in the queue
$print_it_all: on error then goto not_pr_ct
$	stripped_p1=p1-fc_p1
$	p1_ct=-1
$! is this switches for output?
$	if f$extract(0,1,stripped_p1).eqs."/" then goto define_switches
$! so no switches
$	listing_extra_switches=""
$! is it anything?
$	if stripped_p1.eqs."" then goto what_about_a_queue
$! try and make a count out of what's left, otherwise
$! f$integer doesn't (as it apparently should) return an error if
$!  its argument isn't an integer-specifying string. It's because of
$!  this unfortunate property that the following test is included:
$	if f$locate(f$extract(0,1,stripped_p1),"123456789").ge.9 then -
								goto not_pr_ct
$	p1_ct=f$integer(stripped_p1)
$	goto what_about_a_queue
$! QLST */<switches for LST or MUL> (or QLST &/....)
$define_switches: listing_extra_switches=stripped_p1
$! now look for a queue to print
$what_about_a_queue: q=f$search("''qdir'listqueue.com",2)
$	if q .eqs. "" then write sys$output "No queue file in ",qdir
$	if q .eqs. "" then goto reset_verify
$!
$! check no clash with other users
$loop_intlk1:
$	intlk=f$logical("QL_''qdir'")
$	if intlk .eqs. "" then goto s_ahead
$	if intlk .eqs. "1" then write sys$output -
		"Queue in ",qdir," is already being printed"
$	if intlk .eqs. "1" then goto reset_verify
$	if intlk .nes. "0" then write sys$output -
		"Queue interlock for ",qdir," is corrupt"
$	if intlk .nes. "0" then goto reset_verify
$	wait 00:00:05.00
$	goto loop_intlk1
$!
$! go ahead and sort, and then print, the queue
$s_ahead: on control then goto tidy_exit
$	assign/group 1 ql_'qdir'
$	q_rvn=f$file("''qdir'listqueue.com","rvn")
$	am_i="S"
$	if q_rvn.eq.1 then am_i="Not s"
$	write sys$output "*** ",am_i,"orting list queue"
$	if q_rvn.eq.1 then copy/nolog	'qdir'listqueue.com -
					sys$scratch:sortedq.com
$	if q_rvn.eq.1 then goto s_done_sort
$	sort/key=(char,pos:5,size:50)/noduplicate -
			'qdir'listqueue.com -
			sys$scratch:sortedq.com
$s_done_sort: got_a_queue=0
$	on control then goto recover_exit
$	delete/noconfirm 'qdir'listqueue.com;*
$	title=0
$	if fc_p1 .eqs. "&" then title=1
$	open/read qf sys$scratch:sortedq.com
$	suppressed_ct=0
$next_record:
$	read/end=end_queue qf rec
$	orig_rec=rec
$	f=f$edit(f$extract(4,f$length(rec)-4,rec),"TRIM")
$	if f$extract(0,3,rec).eqs."NOT" then goto suppress_files
$	rec=f$extract(0,4,rec)+f
$	sf=f$search(f,1)
$	if sf .eqs. "" then write sys$output "***  File ",f,-
		" has been deleted since it was queued"
$	if sf .eqs. "" then goto next_record
$	if p1_ct.eq.0 then goto make_new_queue
$	if p2.eqs."" then goto no_selection
$	l=f$length(f)
$	if f$locate(p2,f).lt.l then goto no_selection
$	if p3.eqs."" then goto make_new_queue
$	if f$locate(p3,f).lt.l then goto no_selection
$	if p4.eqs."" then goto make_new_queue
$	if f$locate(p4,f).lt.l then goto no_selection
$	if p5.eqs."" then goto make_new_queue
$	if f$locate(p5,f).lt.l then goto no_selection
$	if p6.eqs."" then goto make_new_queue
$	if f$locate(p6,f).lt.l then goto no_selection
$	if p7.eqs."" then goto make_new_queue
$	if f$locate(p7,f).lt.l then goto no_selection
$	goto make_new_queue
$!
$! NOT <file_description> - make a suppression 'entry'
$suppress_files: f=f-"!"
$	if suppressed_ct.ge.5 then write sys$output -
		"***  Too many suppressions - """, f, """ lost"
$	suppressed_ct=suppressed_ct+1
$	supp_file_'suppressed_ct'=f
$	goto next_record
$!
$! file not selected out - do we suppress it?
$no_selection: if suppressed_ct.eq.0 then goto no_suppression
$	if f$locate(supp_file_1,f).lt.f$length(f) then goto suppress_it
$	if suppressed_ct.lt.2 then goto no_suppression
$	if f$locate(supp_file_2,f).lt.f$length(f) then goto suppress_it
$	if suppressed_ct.lt.3 then goto no_suppression
$	if f$locate(supp_file_3,f).lt.f$length(f) then goto suppress_it
$	if suppressed_ct.lt.4 then goto no_suppression
$	if f$locate(supp_file_4,f).lt.f$length(f) then goto suppress_it
$	if suppressed_ct.lt.5 then goto no_suppression
$	if f$locate(supp_file_5,f).ge.f$length(f) then goto no_suppression
$suppress_it: write sys$output "***  Suppressing listing of file ", f
$	goto next_record
$no_suppression: tsw=""
$	if .not.title then goto go_list_it
$	cdt:=.'f$file(f,"CDT")'
$	tsw=f$edit(f$extract(1,4,cdt),"TRIM")
$	tsw="/T""''tsw'"
$	tsw=tsw+ -
	    f$edit(f$extract(5,2,cdt),"LOWERCASE")+ -
	    f$extract(7,f$length(cdt)-13,cdt)
$go_list_it: set verify
$	'rec''listing_extra_switches''osw''tsw'
$	xxx:='f$verify(0)'
$	p1_ct=p1_ct-1
$	goto next_record
$!
$! printed all he wants for the time being
$make_new_queue: if got_a_queue then goto enter_new_queue
$	open/write new_q 'qdir'listqueue.com
$	got_a_queue=1
$enter_new_queue: write new_q orig_rec
$	goto next_record
$!
$! read whole queue file
$end_queue: close qf
$	if got_a_queue then close new_q
$	got_a_queue=0
$	delete/noconfirm sys$scratch:sortedq.com;*
$	write sys$output "*** Done"
$	goto tidy_exit
$!
$! show the current contents of the queue
$show_queue: q=f$search("''qdir'listqueue.com",2)
$	if q .eqs. "" then write sys$output "No queue file in ",qdir
$	if q .eqs. "" then goto reset_verify
$!
$! check no clash with other users
$loop_intlk2:
$	intlk=f$logical("QL_''qdir'")
$	if intlk .eqs. "" then goto s_ahead_1
$	if intlk .eqs. "1" then write sys$output -
		"Queue in ",qdir," is being printed"
$	if intlk .eqs. "1" then goto reset_verify
$	if intlk .nes. "0" then write sys$output -
		"Queue interlock for ",qdir," is corrupt"
$	if intlk .nes. "0" then goto reset_verify
$	wait 00:00:05.00
$	goto loop_intlk2
$!
$! go ahead and sort, and then print, the queue
$s_ahead_1: assign/group 0 ql_'qdir'
$	q_rvn=f$file("''qdir'listqueue.com","rvn")
$	am_i="S"
$	if q_rvn.eq.1 then am_i="Not s"
$	write sys$output "*** ",am_i,"orting list queue"
$	if q_rvn.eq.1 then copy/nolog	'qdir'listqueue.com -
					sys$scratch:sortedq.com
$	if q_rvn.eq.1 then goto s_done_sort_1
$	sort/key=(pos=5,size=50)/noduplicate -
			'qdir'listqueue.com -
			sys$scratch:sortedq.com
$s_done_sort_1: open/read qf sys$scratch:sortedq.com
$	output_line=0
$	totsiz=0
$	write sys$output "Contents of queue ",qdir,"LISTQUEUE.COM"
$	write sys$output ""
$next_record_1:
$	read/end=end_queue_1 qf rec
$	if f$extract(0,3,rec) .eqs. "NOT" then goto next_record_1
$	f=f$edit(f$extract(4,f$length(rec)-4,rec),"TRIM")
$	cdt:=.'f$file(f,"CDT")'
$	cdt=f$edit(f$extract(1,4,cdt),"TRIM") + -
	    f$edit(f$extract(5,2,cdt),"LOWERCASE") + -
	    f$extract(7,f$length(cdt)-13,cdt)
$	fsz=f$file(f,"EOF")
$	totsiz=totsiz+fsz
$	write sys$output f,"    (",cdt,", size=",fsz,")"
$	output_line=1
$	goto next_record_1
$!
$! read whole queue file
$end_queue_1: close qf
$	if .not.output_line then write sys$output "No files in queue!"
$	if totsiz.gt.0 then write sys$output ""
$	if totsiz.gt.0 then write sys$output "Total of ",totsiz, -
						" blocks to print"
$	delete/noconfirm sys$scratch:sortedq.com;*
$	goto tidy_exit
$!
$! remove an entry from the queue
$remove_queue: len_p1=f$len(p1)-1
$	if len_p1 .le. 0 then write sys$output "Remove WHAT from the queue?"
$	if len_p1 .le. 0 then goto reset_verify
$	lister="NOT"
$	p="!"+f$extract(1,len_p1,p1)
$	is_wild=0
$	q_file_open=0
$	goto got_a_wild
$!
$! # - unlock, and (if anything else given) decode rest of line
$unlock_queue: deassign/group ql_'qdir'
$	if fc_p1.nes."#" then goto reset_verify
$	p1=p1-"#"-"#"-"#"
$	if p1 .nes. "" then goto re_dispatch
$	goto reset_verify
$!
$! exit tidily
$recover_exit: xxx:='f$verify(0)'
$	close qf
$	if got_a_queue then close new_q
$	type sys$input
***  Renaming sorted queue file as original queue file: you should
***  suppress (using 'QLST -<file>') those entries whose listing is
***  complete. You may also need to purge your list queue.
$	rename/log sys$scratch:sortedq.com 'qdir'listqueue.com
$tidy_exit: xxx:='f$verify(0)'
$	deassign/group ql_'qdir'
$reset_verify: xxx:='f$verify(0)'
$	if v then set verify
