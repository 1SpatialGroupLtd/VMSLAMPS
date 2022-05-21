$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1997-03-03 13:32:58.000000000 +0000
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
$! command file to produce I2NTF
$!
$! Mod 1435 Use new frtshr		JB 28-Nov-1994
$!
$	set noverify
$	assign	'f$dir()  cmn
$	ws    := "write sys$output "
$	wsb   := "write sys$output "" """
$	debug :=
$	lbug  :=
$	swit  :=
$	do_sub:= "@dosub"
$       do_cld:= "@docld"
$!
$	wsb
$!
$	  MAIN = "t"
$	  CMD  = "t"
$	  PAD  = "t"
$	  CTF  = "t"
$	  CAC  = "t"
$	  CTG  = "t"
$	  CSE  = "t"
$	  CSR  = "t"
$	  CCA  = "t"
$	  CPO  = "t"
$	  CTX  = "t"
$	  CTR  = "t"
$	  CUN  = "t"
$	  CWL  = "t"
$	  CFA  = "t"
$	  CAN  = "t"
$	  COU  = "t"
$	  ANC  = "t"
$	  ADD  = "t"
$	  INL  = "t"
$	  NAM  = "t"
$	  INI  = "t"
$	  OBL  = "t"
$	  OBQ  = "t"
$	  ATT  = "t"
$	  RDC  = "t"
$	  OUT  = "t"
$	  VOL  = "t"
$	  DBS  = "t"
$	  DBH  = "t"
$	  FEC  = "t"
$	  RDF  = "t"
$	  ATD  = "t"
$	  SEC  = "t"
$	  SHD  = "t"
$	  RSH  = "t"
$	  RJN  = "t"
$	  ROU  = "t"
$	  GND  = "t"
$	  GTT  = "t"
$	  STG  = "t"
$	  FEA  = "t"
$	  TEX  = "t"
$	  TAC  = "t"
$	  TXR  = "t"
$	  POI  = "t"
$	  WLN  = "t"
$	  WND  = "t"
$	  CHP  = "t"
$	  GEO  = "t"
$	  CHA  = "t"
$	  TER  = "t"
$	  WST  = "t"
$	  END  = "t"
$	  COM  = "t"
$	  NEW  = "t"
$	  MD2  = "t"
$	  CHCK = "t"
$	  RDL  = "t"
$	  ALE  = "t"
$	  SLT  = "t"
$	  FCT  = "t"
$!
$	inquire CLD  "CLD modules "
$	inquire MES  "message file "
$	   wsb
$!
$	inquire cmp "compile "
$	   if cmp then wsb
$	   if .not. cmp then goto link
$!
$	inquire dbg "compile/link with debug "
$	   if dbg then debug = " /debug/noopt/check=all "
$	   if dbg then lbug  = " /debug"
$!
$	inquire all "compile all sources "
$!
$	   if all then wsb
$	   if all then goto link
$!
$	inquire MAIN "I2NTF		- i2ntf                      "
$	  wsb
$	inquire CMD  "CMDLIN		- command line decode        "
$	inquire OBQ  "OBEY_QUALS	- obey commands              "
$	inquire OBL  "OBEY_LINE	- obey commands from file    "
$	inquire CHCK "CHECK_DUP_PTS	- Check level 3 dup points   "
$	inquire CTF  "CITF_SETUP	- citf                       "
$	inquire CAC  "CITF_ACRDREC	- citf acrdrec               "
$	inquire CTG  "CITF_GEOMETRY	- citf geometry              "
$	inquire CSE  "CITF_SECHREC_EXTN	- citf sechrec extn          "
$	inquire CSR  "CITF_SECHREC_READ	- citf sechrec read          "
$	inquire CCA  "CITF_CHECK_ATTS	- citf attribs               "
$	inquire CPO  "CITF_POINT	- citf point or line record  "
$	inquire CTX  "CITF_TEXT		- citf text record           "
$	inquire CTR  "CITF_TEXTREC	- citf text record output    "
$	inquire CWL  "CITF_WRITE_LINE	- write citf geometry record "
$	inquire CFA  "CITF_FIELD_AC	- get citf feature values    "
$	inquire CAN  "CITF_ANCIL	- citf ancillary records     "
$	inquire CUN  "CLEAN_UP_NFC	- Cleans up NFC              "
$	inquire COU  "COUNT_NONDUPS	- counts non-duplicate pts   "
$	inquire ANC  "ANCIL		- ancillary records          "
$	inquire ADD  "ADD_FIELD		- add a field to a record    "
$	inquire ALE  "ADD_LUT_ENTRY	- add FC lookup table entry  "
$	inquire ATD  "ATTDESC		- attribute description      "
$	inquire CHA  "CHAIN		- chain records              "
$	inquire CHP  "CHECK_POINT	- look for a node            "
$	inquire DBS  "DBASE		- database                   "
$	inquire DBH  "DBHREC		- database header            "
$	inquire FCT  "FC_TRANS		- translate feature code     "
$	inquire FEC  "FEATCLASS		- feature classification     "
$	inquire FEA  "FEATURE		- features                   "
$	inquire GEO  "GEOMETRY		- geometry records           "
$	inquire GND  "GET_NODE		- node id                    "
$	inquire GTT  "GTTXTLNTH		- calc length of text string "
$	inquire INL  "INPUT_FILE	- read filenames from file   "
$	inquire NAM  "NAMEREC		- name record output	     "
$	inquire INI  "NTFINI		- read commands from file    "
$	inquire NEW  "NEWSTART		- text corner from DIGPOS    "
$	inquire OUT  "OUTPFIL		- log file open & write      "
$	inquire PAD  "PADINT		- pad variable width integer "
$	inquire POI  "POINT		- point or line record       "
$	inquire ATT  "RDATT		- read attribute definitions "
$	inquire RDL  "RDLOOKUP		- read FC lookup table       "
$	inquire RDC  "READ_COMMANDS	- same attribute file        "
$	inquire RDF  "READ_FEATURE	- same feature file          "
$	inquire RSH  "READ_SH		- sector header	             "
$	inquire RJN  "READ_JUNCT	- junction points            "
$	inquire ROU  "ROUND		- round output               "
$	inquire SEC  "SECTION		- section                    "
$	inquire SHD  "SECHREC		- section header             "
$	inquire SLT  "SORT_LUT		- sort FC lookup table + baggage"
$	inquire STG  "STORE_GEOM	- store id's                 "
$	inquire TEX  "TEXT		- text record                "
$	inquire TAC  "TEXT_AC		- text ac's                  "
$	inquire TXR  "TEXTREC		- text record output         "
$	inquire VOL  "VOLHDREC		- volume header              "
$	inquire TER  "VOLTERM		- volume termination record  "
$	inquire WLN  "WRITE_LINE	- write geometry record      "
$	inquire WND  "WRITE_NODES	- write node records         "
$	wsb
$	inquire WST  "WSTR		- write output string        "
$	inquire END  "END_TAPE		- flush buffer & end tape    "
$	inquire COM  "COMMENT		- write comment record       "
$	inquire MD2  "MD2DAT		- md2                        "
$!
$	wsb
$!
$ link:
$	inquire lnk "link "
$	if .not. lnk then goto comp
$!
$	inquire ldb "link with debug "
$	if ldb then lbug  = " /debug"
$!
$ comp:
$	wsb
$!
$	  if CLD
$	  then
$	     set verify
$	     do_cld I2NTF
$	     do_cld INLIST
$	     do_cld PARAM
$	     set noverify
$	  endif
$!
$	  if MES
$	  then
$	     set verify
$	     newmsg I2NTF.MES /par=fort/numb=1607/runoff/hl=2
$	     @i2ntf.temp_com
$	     purge i2ntfmsg.rno
$	     set noverify
$	  endif
$!
$ if .not. cmp then goto link_only
$!
$	  set verify
$	  if MAIN then do_sub I2NTF       	'debug
$	  if CMD  then do_sub CMDLIN      	'debug
$	  if OBL  then do_sub OBEY_LINE   	'debug
$	  if OBQ  then do_sub OBEY_QUALS  	'debug
$	  if CHCK then do_sub CHECK_DUP_PTS  	'debug
$	  if CTF  then do_sub CITF_SETUP  	'debug
$	  if CAC  then do_sub CITF_ACRDREC	 'debug
$	  if CTG  then do_sub CITF_GEOMETRY      'debug
$	  if CCA  then do_sub CITF_CHECK_ATTS    'debug
$	  if CSE  then do_sub CITF_SECHREC_EXTN  'debug
$	  if CSR  then do_sub CITF_SECHREC_READ  'debug
$	  if CPO  then do_sub CITF_POINT         'debug
$	  if CTX  then do_sub CITF_TEXT          'debug
$	  if CTR  then do_sub CITF_TEXTREC       'debug
$	  if CUN  then do_sub CLEAN_UP_NFC       'debug
$	  if CWL  then do_sub CITF_WRITE_LINE    'debug
$	  if CFA  then do_sub CITF_FIELD_AC      'debug
$	  if CAN  then do_sub CITF_ANCIL  'debug
$	  if COU  then do_sub COUNT_NONDUPS'debug
$	  if ANC  then do_sub ANCIL       'debug
$	  if ANC  then do_sub L1ANCIL     'debug
$	  if ADD  then do_sub ADD_FIELD   'debug
$	  if ALE  then do_sub ADD_LUT_ENTRY'debug
$	  if ATD  then do_sub ATTDESC     'debug
$	  if ATT  then do_sub RDATT       'debug
$	  if CHA  then do_sub CHAIN       'debug
$	  if CHP  then do_sub CHECK_POINT 'debug
$	  if COM  then do_sub COMMENT     'debug
$	  if DBS  then do_sub DBASE       'debug
$	  if DBH  then do_sub DBHREC      'debug
$	  if END  then do_sub END_TAPE    'debug
$	  if FCT  then do_sub FC_TRANS    'debug
$	  if FEC  then do_sub FEATCLASS   'debug
$	  if FEA  then do_sub FEATURE     'debug
$	  if GND  then do_sub GET_NODE    'debug
$	  if GEO  then do_sub GEOMETRY    'debug
$	  if GTT  then do_sub GTTXTLNTH   'debug
$	  if INL  then do_sub INPUT_FILE  'debug
$	  if NAM  then do_sub NAMEREC     'debug
$	  if INI  then do_sub NTFINI      'debug
$	  if NEW  then do_sub NEWSTART    'debug
$	  if OUT  then do_sub OUTPFIL     'debug
$	  if PAD  then do_sub PADINT      'debug
$	  if POI  then do_sub POINT       'debug
$	  if RDL
$	  then
$	     do_sub RDLOOKUP    'debug
$	     macro'mbug''list' lookupcmd
$	     append lookupcmd.obj rdlookup.obj
$	     purge rdlookup.obj
$	     delete/nocon lookupcmd.obj;*
$	  endif
$	  if RDC  then do_sub READ_COMMAND 'debug
$	  if RDF  then do_sub READ_FEATURE 'debug
$	  if RSH  then do_sub READ_SH     'debug
$	  if RJN  then do_sub READ_JUNCT  'debug
$	  if ROU  then do_sub ROUND       'debug
$	  if SEC  then do_sub SECTION     'debug
$	  if SHD  then do_sub SECHREC     'debug
$	  if SLT
$	  then
$	     do_sub SORT_LUT    'debug
$	     do_sub LUT_SWAP    'debug
$	     do_sub LUT_NTF_CF  'debug
$	     do_sub LUT_IFF_CF  'debug
$	  endif
$	  if STG  then do_sub STORE_GEOM  'debug
$	  if TAC  then do_sub TEXT_AC     'debug
$	  if TEX  then do_sub TEXT        'debug
$	  if TER  then do_sub VOLTERM     'debug
$	  if TXR  then do_sub TEXTREC     'debug
$	  if WND  then do_sub WRITE_NODES 'debug
$	  if WLN  then do_sub WRITE_LINE  'debug
$	  if WST  then do_sub WSTR        'debug
$	  if VOL  then do_sub VOLHDREC    'debug
$	  if MD2
$	  then
$	     set verify
$	     adc     md2dat=lsl$cmniff:md2dat
$	     fortran md2dat
$	     pvv     md2dat
$	     delete  adc.ide;*
$	     purge   md2dat.obj
$	     delete  md2dat.for;*
$	     set noverify
$	  endif
$!
$ link_only:
$	if .not. lnk then goto endit
$!
$	if lnk
$	then
$	  set verify
$	  link'lbug'/map/cross	i2ntf,i2ntf_cld,wstr,end_tape, -
			citf_setup,citf_acrdrec,citf_geometry,citf_check_atts,-
			citf_sechrec_extn,citf_sechrec_read, -
			citf_point,citf_text,citf_textrec, -
			citf_write_line,citf_ancil,citf_field_ac, -
			count_nondups,check_dup_pts, -
			obey_line,obey_quals,gttxtlnth,newstart, -
			cmdlin,comment,volhdrec,volterm, -
			section,dbase,featclass,read_feature,attdesc, -
			dbhrec,sechrec,read_sh,read_junct,round,get_node, -
			store_geom,md2dat,outpfil,input_file,add_field, -
			feature,ancil,l1ancil,padint,point,write_nodes, -
			check_point,write_line,text,text_ac,textrec, -
			geometry,chain,-
			rdlookup,add_lut_entry,sort_lut,lut_swap,lut_ntf_cf,-
			lut_iff_cf,fc_trans,clean_up_nfc,-
			inlist_cld,param_cld,namerec,-
			ntfini,rdatt,read_command,-
			i2ntf.promsg_obj, -
			lsl$library:osmhlib/lib, -
			lsl$library:frtshr/opt, -
			lsl$library:lslshr/opt,iffshr/opt
$	endif
$!
$	set noverify
$	wsb
$	ws "new I2NTF produced"
$	wsb
$	mapid i2ntf
$       purge i2ntf.*
$ endit:
$	set noverify
$	exit
$!
