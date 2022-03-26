$ link/share/exe=lites2viewshr/map=lites2viewshr/full -
	sys$input:/opt, -
	lsl$library:lslshr/opt
obj:lites2/include=(packer,visa_init,visa_read_dti_column,visa_get_triangle)
	LSL$SOURCE_ROOT:[visualise.visalib]visalib/lib
	LSL$SOURCE_ROOT:[visualise.vislib]vislib/LIB
	lsl$source_root:[visualise.visalib]visalib/lib
!
! Create cluster for VAX C run time library
 CLUSTER=VAXCRTL,,,-
	SYS$LIBRARY:VAXCRTL/SHARE
!
! obscure link option to allow demand-zero compression in
! shareable image. According to VMS microfiches, there may be a
! bug in the image activator causing the image not to work if
! this is done, but seems to work, and without it the image
! is enormous
unsupported=1
!
UNIVERSAL = VISA_CLEAR_LEVEL
UNIVERSAL = VISA_CLEAR_VIEW
UNIVERSAL = VISA_DELETE_VIEW
UNIVERSAL = VISA_INIT
UNIVERSAL = VISA_READ_PIXEL
UNIVERSAL = VISA_RENDER_AREA
UNIVERSAL = VISA_RENDER_DTI_GRID
UNIVERSAL = VISA_RENDER_LINE
UNIVERSAL = VISA_SETUP_COLOUR_VALUES
UNIVERSAL = VISA_SETUP_FOG
UNIVERSAL = VISA_SETUP_DTI_VALUES
UNIVERSAL = VISA_SETUP_VIEW
UNIVERSAL = VISA_TRANSFORM_POINT
UNIVERSAL = VISA_SETUP_LIGHT_SOURCE
UNIVERSAL = VISA_SET_OVERLAY_IMAGE
UNIVERSAL = VISA_SETUP_CLASS_SCHEME
UNIVERSAL = VISA_SETUP_PALETTE
UNIVERSAL = VISA_GENERATE_PICTURE
UNIVERSAL = VISA_SETUP_BASIC_COLOURS
UNIVERSAL = VISA_SETUP_AMBIENT_LIGHT
UNIVERSAL = VISA_SET_BASE_IMAGE
UNIVERSAL = VISA_ILLUMINATION_SWITCH
UNIVERSAL = VISA_RENDER_SOLID_OBJECT
UNIVERSAL = VISA_RESET_BASE_IMAGE
UNIVERSAL = VISA_RESET_LIGHT_SOURCE
UNIVERSAL = VISA_RESET_OVERLAY_IMAGE
UNIVERSAL = VISA_GENERATE_PALETTE
UNIVERSAL = VISA_GET_PALETTE_RGB
!
psect_attr=VISA_DATA,noshr
psect_attr=VISALIB,noshr
psect_attr=visabuf,noshr
psect_attr=colour_table,noshr
psect_attr=max_view_id,noshr
psect_attr=next_view_id,noshr
psect_attr=view_list,noshr
psect_attr=vism_print_polygon,noshr
psect_attr=vism_test_back_pixel,noshr
$ purge lites2viewshr.map,lites2viewshr.exe
