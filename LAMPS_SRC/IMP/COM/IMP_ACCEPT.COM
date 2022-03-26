$	ver_status=f$verify(0)
$!
$! IFF Map Processing package 'IMP' acceptance test command procedure.
$!
$!Author						ATT 11-Dec-1986
$!MOD1312	Generally improved			ST  25-Oct-1993
$!
$	on error then continue
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ws="write sys$output"
$	b_on = "[0m[1m" 	! bold on
$	b_of ="[0m"		! bold off
$ 	i_on ="[0m[7m"	! inverse video on
$ 	bell =""		! ding ding (round one..)
$!
$! If we have a non VT100 terminal then switch off bolding etc...
$!
$	if f$getdvi("TT:","TT_AVO") then goto lets_go
$	b_on = ""	 	! bold on
$	b_of = ""		! bold off
$ 	i_on = ""		! inverse video on
$ 	bell = ""		! no ding ding
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$lets_go:
$!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============           Laser-Scan Ltd.          ============"
$ ws "============    IFF Map Processing package IMP  ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$	date_time=f$time()
$ ws "============  Starting ''date_time'  ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$!
$! Tell user what he has got under IMP
$!
$	if f$getdvi("TT:","TT_AVO") then goto imp_init
$ ws "''i_on'"
$ WS "The IMP modules are:                                                            "
$ ws "                                                                                "
$ ws "ICHECK      ICUT             IDIFFERENCE      IFILTER      IFIXAREA      IFROMTEXT "
$ ws "                                                                                "
$ ws "IINFO       ILAYFC           IMEND            IMERGE       IPATCH        IRECODE   "
$ ws "                                                                                "
$ ws "IRENUMBER   IREPORT          ISELAC           ISELECT      ISORT         ISTART    "
$ ws "                                                                                "
$ ws "ITOTEXT     ITRANS           IWINDOW                                                             "
$ ws "                                                                                "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$! Set up the IMP symbols 
$ imp_init:
$ ws " "
$ ws "Defining the IMP symbols and setting up logical names. "
$ ws " "
$	set noverify
$!
$ ws " "
$!
$	@lsl$com:impini
$	Define sys$error nl:
$	Define sys$output nl:
$	Define LSL$FRT	LSL$PUBLIC_ROOT:[IMP.ACCEPT]	
$	Define LSL$IMP_ACCEPT  LSL$PUBLIC_ROOT:[IMP.ACCEPT]	
$!
$	deassign sys$output
$	deassign sys$error
$!
$	in_iff_file="LSL$IMP_ACCEPT:IMPTEST.IFF"
$	frt_file="LSL$IMP_ACCEPT:IMPTEST.FRT
$!
$	copied_iff_file="LSL$IF:IMPTEST.IFF"
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	if f$search(in_iff_file) .nes. "" then goto in_iff_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ in_iff_file_ok:
$	if f$search(frt_file) .nes. "" then goto feedback
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''frt_file'"
$	ws " "
$	goto tidy_exit
$!
$ feedback:
$!
$	ws "... Input test data files successfully found"
$	ws "... Input files were:
$	ws "          ''in_iff_file'"
$	ws " "
$	ws "... Input test lookup files successfully found"
$	ws "... Input file were:
$	ws "          ''frt_file'"
$	ws " "
$	ws "... Copying them to working LSL$IF and LSL$DTI directories"
$!
$! Create new ".IFF" files for manipulation during the tests
$!
$	copy/nolog/noconfirm 'in_iff_file' 'copied_iff_file'
$	if $status then goto check_copied_iff_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws "Output was to ''copied_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_ok:
$	iff_search_file=f$search(copied_iff_file)
$	if $status then goto iff_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_iff_file'"
$	ws " "
$	goto tidy_exit
$ iff_copied_file_ok:
$!
$	ws "... All copied data files successfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$	ws " "
$check_file:
$	chkd_file = f$parse(copied_iff_file,"lsl$if:iff.iff")
$	if f$search(chkd_file) .nes. "" then goto go_for_it
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Checks complete lets go !!!
$ go_for_it:
$!
$! The first item on our acceptance test IRENUMBER
$! Create a file ".REN" for output
$	device = f$parse("''chkd_file'",,,"DEVICE")
$	dirnam = f$parse("''chkd_file'",,,"DIRECTORY")
$	filenam = f$parse("''chkd_file'",,,"NAME")
$!
$	ren_file = device+dirnam+filenam+".REN"
$ ws " "
$ ws "''b_on'IRENUMBER "
$ ws "(To create unique Feature Serial Numbers (FSNs))"
$ ws " "
$ ws "The input file is  ''chkd_file' "
$ ws " "
$ ws "The output file is ''ren_file' "
$ ws " "
$ ws "The /LOG qualifier is selected to send supplementary information to the screen."
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	IRENUMBER/LOG 'chkd_file' 'ren_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now run ICHECK on the file to check for loops and correspondence with
$! the IMPTEST FRT
$!
$	chk_file = device+dirnam+filenam+".CHK"
$ ws " "
$ ws "''b_on'ICHECK"
$ ws "(to test for digitised loops)"
$ ws " "
$ ws "The input file is the renumbered IFF file ''ren_file'"
$ ws "There is no output file."
$ ws " "
$ ws "The /FRT qualifier is specified to check for correspondence with the "
$ ws "IMPTEST FRT. The /CROSS and /OUTPUT qualifiers are the default.''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ICHECK/LOG/FRT = IMPTEST 'ren_file' 
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now create a TEXT file with ITOTEXT 
$!
$	txt_file = device+dirnam+filenam+".TXT"
$ ws " "
$ ws "''b_on'ITOTEXT"
$ ws "(to create a text file from the IFF file)"
$ ws " "
$ ws "The input file is the renumbered IFF file ''ren_file'"
$ ws "The output text file is                   ''txt_file'"
$ ws " "
$ ws "Again the /LOG qualifier is specified to send supplementary messages to the"
$ ws "screen.''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ITOTEXT/LOG 'ren_file' 'txt_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now edit the text file
$ ws " "
$ ws "''b_on'It is now possible to edit the text file using EDT."
$ ws " "
$ ws "The text representations of the IFF entries can be modified, deleted,"
$ ws "or new features added."
$ ws " "
$ ws "Press <CTRL/Z> and type EXIT to exit from EDT. "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$ ass/user tt: sys$input
$	set verify
$	EDT 'txt_file'
$	set noverify
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now recreate the IFF file with IFROMTEXT
$	new_file = device+dirnam+filenam+".NEW"
$ ws " "
$ ws "''b_on'IFROMTEXT "
$ ws "(to create a new IFF file from the edited text file)."
$ ws " "
$ ws "The input text file is       ''txt_file' "
$ ws " "
$ ws "The output IFF file          ''new_file' "
$ ws " "
$ ws "Again the /LOG qualifier is specified to send supplementary messages to the"
$ ws "screen.''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	IFROMTEXT/LOG 'txt_file' 'new_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IPATCH to check the validity of the IFF file.
$ ws " "
$ ws "''b_on'IPATCH "
$ ws "(to check the validity of the IFF file created from the edited text file)."
$ ws " "
$ ws "The input IFF file ''new_file' (there is no output)"
$ ws " "
$ ws "Press <CTRL/Z> to exit from IPATCH."
$ ws "''b_of'"
$!
$	gosub go_on
$!
$ ass/user tt: sys$input
$	set verify
$	IPATCH 'new_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IDIFFERENCE to compare the two IFF files
$ ws " "
$ ws "''b_on'IDIFFERENCE "
$ ws "(to compare the two IFF files)."
$ ws " "
$ ws "The input IFF files are the renumbered file ''ren_file'"
$ ws "and file created by IFROMTEXT               ''new_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	IDIFFERENCE/LOG 'ren_file'  'new_file' 
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ISTART to create a 'new' type IFF file with HIstory entry etc..
$	strt_file = device+dirnam+filenam+".SRT"
$ ws " "
$ ws "''b_on'ISTART"
$ ws "(to create a 'new' type template IFF file)."
$ ws " "
$ ws "The output IFF file is ''strt_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the "
$ ws "terminal and /LEARNER to explain the additional information required. "
$ ws "The /SYMBOL qualifier is specified to output corner symbols instead of"
$ ws "corner ticks."
$ ws "''b_of'"
$!
$	gosub go_on
$!
$ ws " "
$!
$!!!!! 	ass/user tt: sys$input
$	set verify
$	ISTART/LOG/SYMBOL 'strt_file'
1250
0 500
0 0
500 0
500 500
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! IMERGE to merge the newly created file and the (modified) original 
$	mer_file = device+dirnam+filenam+".MER"
$ ws " "
$ ws "''b_on'IMERGE"
$ ws "(to merge the 'New' type file created by ISTART and the (modified) original)."
$ ws " "
$ ws "The input IFF files are the 'new' file ''strt_file'"
$ ws "and file created by IFROMTEXT          ''new_file' "
$ ws " "
$ ws "The output file will take its header information from the file specified first."
$ ws " "
$ ws "The output IFF file is                 ''mer_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	IMERGE/LOG 'strt_file','new_file' 'mer_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IINFO to check contents of file
$ ws " "
$ ws "''b_on'IINFO"
$ ws "(to check contents of the file)."
$ ws " "
$ ws "The input IFF file is the merged file ''mer_file'"
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	IINFO 'mer_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ISELECT to select feature(s) by feature code
$	sel_file = device+dirnam+filenam+".SEL"
$ ws " "
$ ws "''b_on'ISELECT"
$ ws "(to select features from the merged file by feature code)."
$ ws " "
$ ws "The input IFF file is the merged file ''mer_file'"
$ ws "The output IFF file is                ''sel_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "and the /FC qualifier is specified to select Feature Codes."
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ISELECT/LOG/FC=(1:10,200:210) 'mer_file' 'sel_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IREPORT to check contents of file
$ ws " "
$ ws "''b_on'IREPORT"
$ ws "(to check contents of the file)."
$ ws " "
$ ws "The input IFF file is the selected file ''sel_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "The /NF qualifier is specified to report on NF number (Feature Serial Number)."
$ ws "The /LAYER qualifier is specified to report on Layers as they are found."
$ ws "''b_of'"
$ ws " "
$!
$	gosub go_on
$!
$	set verify
$	IREPORT/LOG/NF/LAYER 'sel_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IRECODE to recode feature codes 
$	rec_file = device+dirnam+filenam+".REC"
$ ws " "
$ ws "''b_on'IRECODE"
$ ws "(to change feature codes)."
$ ws " "
$ ws "The input IFF file is the selected file ''sel_file'"
$ ws " "
$ ws "The output IFF file is                  ''rec_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "The /FC qualifier is specified to change Feature Codes."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$ 	ass/user tt: sys$input
$	set verify
$	IRECODE/LOG/FC=(3>6) 'sel_file' 'rec_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IINFO to check contents of file
$ ws " "
$ ws "''b_on'IINFO"
$ ws "(to check contents of the file)."
$ ws " "
$ ws "The input IFF file is the recoded file ''rec_file'"
$ ws " "
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	IINFO 'rec_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IWINDOW to clip the data
$	clip_file = device+dirnam+filenam+".CLP"
$ ws " "
$ ws "''b_on'IWINDOW"
$ ws "(to clip the data)."
$ ws " "
$ ws "The input IFF file is the recoded file ''rec_file'"
$ ws " "
$ ws "The output IFF file is                 ''clip_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen"
$ ws "and the /NORTH, /SOUTH, /EAST and /WEST qualifiers give the windowing"
$ ws "boundaries."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	IWINDOW/LOG/NORTH=350/SOUTH=0/WEST=0/EAST=500 'rec_file' 'clip_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ISORT to sort contents of file
$	sort_file = device+dirnam+filenam+".SOR"
$ ws " "
$ ws "''b_on'ISORT"
$ ws "(to sort the file on Feature Serial Number (FSN))."
$ ws " "
$ ws "The input IFF file is the windowed file ''clip_file'"
$ ws " "
$ ws "The output IFF file is                  ''sort_file'"
$ ws " "
$ ws "The /OUTPUT qualifier is specified to send supplementary messages to " 
$ ws "SYS$OUTPUT."
$ ws "''b_of'"
$ ws " "
$!
$	gosub go_on
$!
$	set verify
$	ISORT/OUTPUT 'clip_file' 'sort_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IFIXAREA to check aeral features
$	fix_file = device+dirnam+filenam+".FIX"
$ ws " "
$ ws "''b_on'IFIXAREA"
$ ws "(to check area features)."
$ ws " "
$ ws "The input IFF file is the sorted file file ''sort_file'"
$ ws " "
$ ws "The output IFF file is                     ''fix_file'"
$ ws " "
$ ws "The /OUTPUT qualifier is specified to send supplementary messages to "
$ ws "SYS$OUTPUT and the /LAYER qualifiers is used to limit the checking to "
$ ws "specific layers. The /CLOSE and /REVERSE qualifiers specify the checking "
$ ws "to take place."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	IFIXAREA/OUTPUT/LAYER=10/CLOSE/REVERSE 'sort_file' 'fix_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ISELAC to select AC's.
$!
$	selac_file = device+dirnam+filenam+".SAC"
$ ws " "
$ ws "''b_on'ISELAC"
$ ws "(to select on the basis of AC code)."
$ ws " "
$ ws "The input IFF file is the fixed file  ''fix_file'"
$ ws " "
$ ws "The output IFF file is                ''selac_file'"
$ ws " "
$ ws "Use the commands:               FROM  ''fix_file'"
$ ws "                                TO    ''selac_file'"
$ ws "                                GO"
$ ws " "
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$ 	ass/user tt: sys$input
$	set verify
$	ISELAC
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IREPORT to check contents of file
$ ws " "
$ ws "''b_on'IREPORT"
$ ws "(to check contents of the file)."
$ ws " "
$ ws "The input IFF file is the output from ISELAC ''selac_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "The /NF qualifier is specified to report on NF number (Feature Serial Number)."
$ ws "The /AC qualifier is specified to report on AC codes (Ancillary codes)."
$ ws "The /LAYER qualifier is specified to report on Layers as they are found."
$ ws "''b_of'"
$ ws " "
$!
$	gosub go_on
$!
$	set verify
$	IREPORT/LOG/NF/AC/LAYER 'selac_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ILAYFC to change feature codes in specified layers
$	lay_file = device+dirnam+filenam+".LAY"
$ ws " "
$ ws "''b_on'ILAYFC"
$ ws "(to change feature codes in specified layers)."
$ ws " "
$ ws "The input IFF file is the output from ISELAC ''selac_file'"
$ ws " "
$ ws "The output IFF file is                       ''lay_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the"
$ ws "terminal and the /CODES qualifier is used to specify the feature codes"
$ ws "to be changed in the specified  layers."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	ILAYFC/LOG/CODES=(7>201) 'selac_file' 'lay_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ITRANS to transform the data
$	tran_file = device+dirnam+filenam+".TRA"
$ ws " "
$ ws "''b_on'ITRANS"
$ ws "(to transform the data)."
$ ws " "
$ ws "The input IFF file is the output from ILAYFC ''lay_file'"
$ ws " "
$ ws "The output IFF file is                       ''tran_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen"
$ ws "and the /LEARNER qualifier gives additional help."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$ 	ass/user tt: sys$input
$	set verify
$	ITRANS/LOG/LEARNER 'lay_file' 'tran_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IFILTER to thin the data
$	thin_file = device+dirnam+filenam+".THN"
$ ws " "
$ ws "''b_on'IFILTER"
$ ws "(to filter the data)."
$ ws " "
$ ws "The input IFF file is the transformed file ''tran_file'"
$ ws " "
$ ws "The output IFF file is                     ''thin_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "The /DP qualifier causes the data to be filtered using the Douglas-Peucker "
$ ws "filter with the specified lateral tolerance. "
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	IFILTER/LOG/DP=LAT:0.15 'tran_file' 'thin_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now ICUT to trim the features
$	cut_file = device+dirnam+filenam+".CUT"
$ ws " "
$ ws "''b_on'ICUT"
$ ws "(to trim the data)."
$ ws " "
$ ws "The input IFF file is the thinned file ''thin_file'"
$ ws " "
$ ws "The output IFF file is                 ''cut_file'"
$ ws " "
$ ws "The /LOG qualifier is specified to send supplementary messages to the screen."
$ ws "The /NEWFC qualifier causes the data to be output in a global feature code."
$ ws "The /POINTS qualifier sets the maximum number of pointer per output feature."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	ICUT/LOG/POINTS=50/NEWFC=1 'thin_file' 'cut_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Now IINFO to check contents of file
$ ws " "
$ ws "''b_on'IINFO"
$ ws "(to check contents of the file)."
$ ws " "
$ ws "The input IFF file is the cut file ''cut_file'"
$ ws " "
$ ws "The /MAP_DESCRIPTOR qualifier is specified to give information about the MD"
$ ws "(Map Descriptor) entry and the /TIMINGS qualifier gives information about"
$ ws "elapsed and CPU times from the HI (HIstory) entry."
$ ws "''b_of'"
$!
$ 	gosub go_on
$!
$	set verify
$	IINFO/MAP_DESCRIPTOR/TIMINGS 'cut_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$ 	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! The end say what we have done.
$ ws " "
$ ws "''b_on'"
$ ws "This is the end of the formal ''customer' acceptance procedure."
$ ws "The following files have been created from the original IFF file :"
$ ws " ''chkd_file' "
$ ws " "
$ ws " IRENUMBER A renumbered file        ''ren_file' "
$ ws " ITOTEXT   A text file              ''txt_file' "
$ ws " IFROMTEXT A regenerated IFF file   ''new_file' "
$ ws " IMERGE    A merged file            ''mer_file' "
$ ws " ISELECT   A selected file          ''sel_file' "
$ ws " IRECODE   A recoded file           ''rec_file'"
$ ws " IWINDOW   A clipped file           ''clip_file'"
$ ws " IFIXAREA  A fixed file             ''fix_file'"
$ ws " ISELAC    A selected file          ''selac_file'"
$ ws " ILAYFC    A recoded file           ''lay_file'"
$ ws " ISORT     A sorted file            ''sort_file'"
$ ws " ITRANS    A transformed file       ''tran_file'"
$ ws " IFILTER   A thinned file           ''thin_file'"
$ ws " ICUT      A cut file               ''cut_file'"
$ ws " ISTART    A 'new' type IFF file    ''strt_file'"
$ ws " "
$ ws " ICHECK, IINFO, IPATCH and IREPORT have also been used to check the validity"
$ ws " of the various IMP modules and IDIFFERENCE to compare two files."
$ ws " "
$ ws " These files are available in the directory LSL$IF: for verification."
$ ws "''b_of'"
$!
$ 	ws " "
$	inquire/nopunc continue - 
	"Press ''b_on'<RETURN> ''b_of'to exit "
$!
$tidy_exit:
$	set control=y
$	if ver_status then set verify
$	exit
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Subroutine chk_status
$!
$ chk_status:
$	ws " "
$	ws "Return $STATUS was ''f$message(dcl_status)'"
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Subroutine go_on
$!
$ go_on:
$ 	ws " "
$	inquire/nopunc continue - 
	"Press ''b_on'<RETURN> ''b_of'to continue "
$ 	ws " "
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
