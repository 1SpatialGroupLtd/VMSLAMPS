$! command file to compile and link LITES2GEOMSHR
$!
$ ver_status = f$verify(0)
$ on control then goto exit
$ on error then goto exit
$!
$! check to see if initialisation has been carried out
$ if (f$logical("sys") .eqs. "" .or. f$logical("lsl$cmnlslgothic") .eqs "")
$ then
$   @lsl$com:lslgothiclibini
$ endif
$!
$! initialise
$!
$! compile?
$!
$!!! compile_cmd = "cc/include=(lsl$cmnlslgothic)/nowarnings"
$ compile_cmd = "cc/include=(lsl$cmnlslgothic)"
$ inquire compile "Compile?      "
$ dbg = "N"
$ map = "N"
$ if (compile) then inquire dbg "With Debug?   "
$ if (compile .and. dbg) then compile_cmd = "''compile_cmd'"+"/debug/noopt "
$!
$! link?
$!
$ link_cmd = "link/share/exe=lites2geomshr/nomap"
$ inquire lnk     "Link?         "
$ if (lnk) then inquire dbg     "With Debug?   "
$ if (lnk .and. dbg) then link_cmd = "''link_cmd'"+"/debug
$ if (lnk) then inquire map     "Link map?     "
$ if (lnk .and. map) then link_cmd = "''link_cmd'"+"/map = lites2geomshr
$!
$ if (compile)
$ then
$    set verify
$    'compile_cmd' lites2geom_routines
$    if .NOT. ver_status then set noverify
$ endif
$!
$ if (lnk)
$then
$    set verify = (noprocedure,image)
$   'link_cmd' lites2geom_routines,-
lsl$lslgothicshr/opt,sys$input:/opt

UNIVERSAL = shared_init,geom_message,clear_working_space
UNIVERSAL = start_geometry,add_points_to_geometry,complete_geometry
UNIVERSAL = get_geometry_type,get_pts_from_geometry,geometry_cancel
UNIVERSAL = geometry_add,geometry_buffer,geometry_combine
UNIVERSAL = test_geometry_intersect,test_geometry_intersect_vector
UNIVERSAL = test_point_in_geometry,get_point_from_geometry
UNIVERSAL = test_geometry_clear,geometry_copy,dev_test

psect_attr = geom_data, noshr

sys$library:vaxcrtl/share
$ endif
$ exit:
$ if .NOT. ver_status then set noverify
$ purge/log *.*
$ if ver_status then set verify
