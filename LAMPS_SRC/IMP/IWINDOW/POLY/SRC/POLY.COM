$	set noverify            
$	on control_y then goto end
$	on error     then goto end
$!
$! command file: POLY - a command file to compile the polygon clipping 
$!			routines
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England
$!
$! Author R J Hulme, 21 June 1988
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$!
$	inquire CRELIB "Create a new library               "
$!
$  	inquire DEBUG  "Compile with debug                 "
$	if DEBUG.eqs."" then P1 = "N"
$!
$	wsb
$	inquire COR "Read in clipping polygon           "
$	inquire STA "Start an area                      "
$	inquire FIN "Find intersections                 "
$	inquire GET "Get features                       "
$	inquire LIS "Linked list manipulation           "
$	wsb
$!
$	if      CRELIB then libc = "library/insert  POLY"
$	if .not.CRELIB then libc = "library/replace POLY"
$!
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if DEBUG then dbg = "/debug/noopt"
$	if DEBUG then pd  = "purge"
$	if DEBUG then ver = ""
$!
$	if CRELIB then library/create POLY
$!
$	set verify
$	if .not.COR then goto noCOR
$	   adc SET_CORNERS/co = SET_CORNERS,CALC_AREA
$	   fort/extend'dbg' SET_CORNERS
$	   pvv SET_CORNERS
$	   purge SET_CORNERS.obj
$	   delete adc.ide;*
$	   'pd' SET_CORNERS.for'ver'
$	   'libc' SET_CORNERS
$!
$noCOR:	if .not.STA then goto noSTA
$	   adc START_AREA/co = START_AREA
$	   fort/extend'dbg' START_AREA
$	   pvv START_AREA
$	   purge START_AREA.obj
$	   delete adc.ide;*
$	   'pd' START_AREA.for'ver'
$	   'libc' START_AREA
$!
$noSTA:	if .not.FIN then goto noFIN
$	   adc FIND_INTER/co = FIND_INTER,CALC_INTER,ADD_INTER,FIND_PTR
$	   adc FIND_INTER/co/ap = CALC_ANGLE,PNTPOL,INTSCT
$	   fort/extend'dbg' FIND_INTER
$	   pvv FIND_INTER
$	   purge FIND_INTER.obj
$	   delete adc.ide;*
$	   'pd' FIND_INTER.for'ver'
$	   'libc' FIND_INTER
$!
$noFIN:	if .not.GET then goto noGET
$	   adc GET_FEATURE/co = GET_FEATURE
$	   fort/extend'dbg' GET_FEATURE
$	   pvv GET_FEATURE
$	   purge GET_FEATURE.obj
$	   delete adc.ide;*
$	   'pd' GET_FEATURE.for'ver'
$	   'libc' GET_FEATURE
$!
$noGET:	if .not.LIS then goto noLIS
$	   adc PUT_LINK/co = PUT_LINK,GET_LINK,SET_PTR
$	   fort/extend'dbg' PUT_LINK
$	   pvv PUT_LINK
$	   purge PUT_LINK.obj
$	   delete adc.ide;*
$	   'pd' PUT_LINK.for'ver'
$	   'libc' PUT_LINK
$!
$noLIS:
$end:
$	set noverify
