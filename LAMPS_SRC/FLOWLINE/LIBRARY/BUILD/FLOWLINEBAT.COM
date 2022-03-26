$ 	set noverify
$	on control_y then goto flowlineex
$	if "''f$logical("lsl$flowline_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$flowline_building "in_progress"
$	assign lsl$source_root:[flowline.library] lsl$cmnflowline
$   rfort:=$sys$system:rdbpre/fortran
$	sd:=$lsl$exe:sd
$	sd lsl$cmnflowline
$	define lsl$fln_database lsl$source_root:[flowline.com]
$	set noon
$	emsg=""
$	library/create  flowline
$	libr = "library/insert/log  flowline"
$ 	set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 	set verify
$	newmsg/number=1711/name=fln/prefix=fln__ /parameter=for flowline.mes /runoff
$ @flowline.temp_com
$ if $status then libr flowline.promsg_obj
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_ADD_STRING=FLN_ADD_STRING
$	fort FLN_ADD_STRING
$ 	ok=$status
$ 	if ok then pvv FLN_ADD_STRING
$ 	purge/nolog FLN_ADD_STRING.obj
$ 	delete/nolog FLN_ADD_STRING.for;*
$	if .not.ok then emsg=emsg+" FLN_ADD_STRING"
$ 	delete adc.ide;*
$	if ok then libr FLN_ADD_STRING
$ 	delete FLN_ADD_STRING.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_ARCHIVE_JOB.rfo=FLN_ARCHIVE_JOB
$	rfort FLN_ARCHIVE_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_ARCHIVE_JOB
$ 	purge/nolog FLN_ARCHIVE_JOB.obj
$ 	delete/nolog FLN_ARCHIVE_JOB.for;*
$ 	delete/nolog FLN_ARCHIVE_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_ARCHIVE_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_ARCHIVE_JOB
$ 	delete FLN_ARCHIVE_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_ARCHIVE_SESSION.rfo=FLN_ARCHIVE_SESSION
$	rfort FLN_ARCHIVE_SESSION
$ 	ok=$status
$ 	if ok then pvv FLN_ARCHIVE_SESSION
$ 	purge/nolog FLN_ARCHIVE_SESSION.obj
$ 	delete/nolog FLN_ARCHIVE_SESSION.for;*
$ 	delete/nolog FLN_ARCHIVE_SESSION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_ARCHIVE_SESSION"
$ 	delete adc.ide;*
$	if ok then libr FLN_ARCHIVE_SESSION
$ 	delete FLN_ARCHIVE_SESSION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_ARCHIVE_TASK.rfo=FLN_ARCHIVE_TASK
$	rfort FLN_ARCHIVE_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_ARCHIVE_TASK
$ 	purge/nolog FLN_ARCHIVE_TASK.obj
$ 	delete/nolog FLN_ARCHIVE_TASK.for;*
$ 	delete/nolog FLN_ARCHIVE_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_ARCHIVE_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_ARCHIVE_TASK
$ 	delete FLN_ARCHIVE_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_AUTHORISE_OPERATOR=FLN_AUTHORISE_OPERATOR
$	fort FLN_AUTHORISE_OPERATOR
$ 	ok=$status
$ 	if ok then pvv FLN_AUTHORISE_OPERATOR
$ 	purge/nolog FLN_AUTHORISE_OPERATOR.obj
$ 	delete/nolog FLN_AUTHORISE_OPERATOR.for;*
$	if .not.ok then emsg=emsg+" FLN_AUTHORISE_OPERATOR"
$ 	delete adc.ide;*
$	if ok then libr FLN_AUTHORISE_OPERATOR
$ 	delete FLN_AUTHORISE_OPERATOR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_AUTHORISE_WORKSTATION=FLN_AUTHORISE_WORKSTATION
$	fort FLN_AUTHORISE_WORKSTATION
$ 	ok=$status
$ 	if ok then pvv FLN_AUTHORISE_WORKSTATION
$ 	purge/nolog FLN_AUTHORISE_WORKSTATION.obj
$ 	delete/nolog FLN_AUTHORISE_WORKSTATION.for;*
$	if .not.ok then emsg=emsg+" FLN_AUTHORISE_WORKSTATION"
$ 	delete adc.ide;*
$	if ok then libr FLN_AUTHORISE_WORKSTATION
$ 	delete FLN_AUTHORISE_WORKSTATION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_BEGIN_TASK.rfo=FLN_BEGIN_TASK
$	rfort FLN_BEGIN_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_BEGIN_TASK
$ 	purge/nolog FLN_BEGIN_TASK.obj
$ 	delete/nolog FLN_BEGIN_TASK.for;*
$ 	delete/nolog FLN_BEGIN_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_BEGIN_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_BEGIN_TASK
$ 	delete FLN_BEGIN_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHANGE_PAR.rfo=FLN_CHANGE_PAR
$	rfort FLN_CHANGE_PAR
$ 	ok=$status
$ 	if ok then pvv FLN_CHANGE_PAR
$ 	purge/nolog FLN_CHANGE_PAR.obj
$ 	delete/nolog FLN_CHANGE_PAR.for;*
$ 	delete/nolog FLN_CHANGE_PAR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHANGE_PAR"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHANGE_PAR
$ 	delete FLN_CHANGE_PAR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHANGE_PROJ_PRI.rfo=FLN_CHANGE_PROJ_PRI
$	rfort FLN_CHANGE_PROJ_PRI
$ 	ok=$status
$ 	if ok then pvv FLN_CHANGE_PROJ_PRI
$ 	purge/nolog FLN_CHANGE_PROJ_PRI.obj
$ 	delete/nolog FLN_CHANGE_PROJ_PRI.for;*
$ 	delete/nolog FLN_CHANGE_PROJ_PRI.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHANGE_PROJ_PRI"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHANGE_PROJ_PRI
$ 	delete FLN_CHANGE_PROJ_PRI.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHANGE_JOB_NAME.rfo=FLN_CHANGE_JOB_NAME
$	rfort FLN_CHANGE_JOB_NAME
$ 	ok=$status
$ 	if ok then pvv FLN_CHANGE_JOB_NAME
$ 	purge/nolog FLN_CHANGE_JOB_NAME.obj
$ 	delete/nolog FLN_CHANGE_JOB_NAME.for;*
$ 	delete/nolog FLN_CHANGE_JOB_NAME.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHANGE_JOB_NAME"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHANGE_JOB_NAME
$ 	delete FLN_CHANGE_JOB_NAME.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHANGE_JOB_HIST_NAME.rfo=FLN_CHANGE_JOB_HIST_NAME
$	rfort FLN_CHANGE_JOB_HIST_NAME
$ 	ok=$status
$ 	if ok then pvv FLN_CHANGE_JOB_HIST_NAME
$ 	purge/nolog FLN_CHANGE_JOB_HIST_NAME.obj
$ 	delete/nolog FLN_CHANGE_JOB_HIST_NAME.for;*
$ 	delete/nolog FLN_CHANGE_JOB_HIST_NAME.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHANGE_JOB_HIST_NAME"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHANGE_JOB_HIST_NAME
$ 	delete FLN_CHANGE_JOB_HIST_NAME.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHANGE_JOB_PRI.rfo=FLN_CHANGE_JOB_PRI
$	rfort FLN_CHANGE_JOB_PRI
$ 	ok=$status
$ 	if ok then pvv FLN_CHANGE_JOB_PRI
$ 	purge/nolog FLN_CHANGE_JOB_PRI.obj
$ 	delete/nolog FLN_CHANGE_JOB_PRI.for;*
$ 	delete/nolog FLN_CHANGE_JOB_PRI.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHANGE_JOB_PRI"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHANGE_JOB_PRI
$ 	delete FLN_CHANGE_JOB_PRI.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_ELEMENT.rfo=FLN_CHECK_ELEMENT
$	rfort FLN_CHECK_ELEMENT
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_ELEMENT
$ 	purge/nolog FLN_CHECK_ELEMENT.obj
$ 	delete/nolog FLN_CHECK_ELEMENT.for;*
$ 	delete/nolog FLN_CHECK_ELEMENT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_ELEMENT"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_ELEMENT
$ 	delete FLN_CHECK_ELEMENT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_ELEMENT_FLOW.rfo=FLN_CHECK_ELEMENT_FLOW
$	rfort FLN_CHECK_ELEMENT_FLOW
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_ELEMENT_FLOW
$ 	purge/nolog FLN_CHECK_ELEMENT_FLOW.obj
$ 	delete/nolog FLN_CHECK_ELEMENT_FLOW.for;*
$ 	delete/nolog FLN_CHECK_ELEMENT_FLOW.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_ELEMENT_FLOW"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_ELEMENT_FLOW
$ 	delete FLN_CHECK_ELEMENT_FLOW.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_FLOWLINE.rfo=FLN_CHECK_FLOWLINE
$	rfort FLN_CHECK_FLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_FLOWLINE
$ 	purge/nolog FLN_CHECK_FLOWLINE.obj
$ 	delete/nolog FLN_CHECK_FLOWLINE.for;*
$ 	delete/nolog FLN_CHECK_FLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_FLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_FLOWLINE
$ 	delete FLN_CHECK_FLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_JOB.rfo=FLN_CHECK_JOB
$	rfort FLN_CHECK_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_JOB
$ 	purge/nolog FLN_CHECK_JOB.obj
$ 	delete/nolog FLN_CHECK_JOB.for;*
$ 	delete/nolog FLN_CHECK_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_JOB
$ 	delete FLN_CHECK_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_LAMPSAUTH=FLN_CHECK_LAMPSAUTH
$	fort FLN_CHECK_LAMPSAUTH
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_LAMPSAUTH
$ 	purge/nolog FLN_CHECK_LAMPSAUTH.obj
$ 	delete/nolog FLN_CHECK_LAMPSAUTH.for;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_LAMPSAUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_LAMPSAUTH
$ 	delete FLN_CHECK_LAMPSAUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_OFFLINE.rfo=FLN_CHECK_OFFLINE
$	rfort FLN_CHECK_OFFLINE
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_OFFLINE
$ 	purge/nolog FLN_CHECK_OFFLINE.obj
$ 	delete/nolog FLN_CHECK_OFFLINE.for;*
$ 	delete/nolog FLN_CHECK_OFFLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_OFFLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_OFFLINE
$ 	delete FLN_CHECK_OFFLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_OPERATOR.rfo=FLN_CHECK_OPERATOR
$	rfort FLN_CHECK_OPERATOR
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_OPERATOR
$ 	purge/nolog FLN_CHECK_OPERATOR.obj
$ 	delete/nolog FLN_CHECK_OPERATOR.for;*
$ 	delete/nolog FLN_CHECK_OPERATOR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_OPERATOR"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_OPERATOR
$ 	delete FLN_CHECK_OPERATOR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_PROCEDURE.rfo=FLN_CHECK_PROCEDURE
$	rfort FLN_CHECK_PROCEDURE
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_PROCEDURE
$ 	purge/nolog FLN_CHECK_PROCEDURE.obj
$ 	delete/nolog FLN_CHECK_PROCEDURE.for;*
$ 	delete/nolog FLN_CHECK_PROCEDURE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_PROCEDURE"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_PROCEDURE
$ 	delete FLN_CHECK_PROCEDURE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_PROJECT.rfo=FLN_CHECK_PROJECT
$	rfort FLN_CHECK_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_PROJECT
$ 	purge/nolog FLN_CHECK_PROJECT.obj
$ 	delete/nolog FLN_CHECK_PROJECT.for;*
$ 	delete/nolog FLN_CHECK_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_PROJECT
$ 	delete FLN_CHECK_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_OPERATOR_AUTH.rfo=FLN_CHECK_OPERATOR_AUTH
$	rfort FLN_CHECK_OPERATOR_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_OPERATOR_AUTH
$ 	purge/nolog FLN_CHECK_OPERATOR_AUTH.obj
$ 	delete/nolog FLN_CHECK_OPERATOR_AUTH.for;*
$ 	delete/nolog FLN_CHECK_OPERATOR_AUTH.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_OPERATOR_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_OPERATOR_AUTH
$ 	delete FLN_CHECK_OPERATOR_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_WORKSTATION.rfo=FLN_CHECK_WORKSTATION
$	rfort FLN_CHECK_WORKSTATION
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_WORKSTATION
$ 	purge/nolog FLN_CHECK_WORKSTATION.obj
$ 	delete/nolog FLN_CHECK_WORKSTATION.for;*
$ 	delete/nolog FLN_CHECK_WORKSTATION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_WORKSTATION"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_WORKSTATION
$ 	delete FLN_CHECK_WORKSTATION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CHECK_WORKSTATION_AUTH.rfo=FLN_CHECK_WORKSTATION_AUTH
$	rfort FLN_CHECK_WORKSTATION_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_CHECK_WORKSTATION_AUTH
$ 	purge/nolog FLN_CHECK_WORKSTATION_AUTH.obj
$ 	delete/nolog FLN_CHECK_WORKSTATION_AUTH.for;*
$ 	delete/nolog FLN_CHECK_WORKSTATION_AUTH.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CHECK_WORKSTATION_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_CHECK_WORKSTATION_AUTH
$ 	delete FLN_CHECK_WORKSTATION_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_COMPLETE_TASK=FLN_COMPLETE_TASK
$	fort FLN_COMPLETE_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_COMPLETE_TASK
$ 	purge/nolog FLN_COMPLETE_TASK.obj
$ 	delete/nolog FLN_COMPLETE_TASK.for;*
$	if .not.ok then emsg=emsg+" FLN_COMPLETE_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_COMPLETE_TASK
$ 	delete FLN_COMPLETE_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_COMPLETE_UPDATE.rfo=FLN_COMPLETE_UPDATE
$	rfort FLN_COMPLETE_UPDATE
$ 	ok=$status
$ 	if ok then pvv FLN_COMPLETE_UPDATE
$ 	purge/nolog FLN_COMPLETE_UPDATE.obj
$ 	delete/nolog FLN_COMPLETE_UPDATE.for;*
$ 	delete/nolog FLN_COMPLETE_UPDATE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_COMPLETE_UPDATE"
$ 	delete adc.ide;*
$	if ok then libr FLN_COMPLETE_UPDATE
$ 	delete FLN_COMPLETE_UPDATE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CONDITIONS_SYNTAX=FLN_CONDITIONS_SYNTAX
$	fort FLN_CONDITIONS_SYNTAX
$ 	ok=$status
$ 	if ok then pvv FLN_CONDITIONS_SYNTAX
$ 	purge/nolog FLN_CONDITIONS_SYNTAX.obj
$ 	delete/nolog FLN_CONDITIONS_SYNTAX.for;*
$	if .not.ok then emsg=emsg+" FLN_CONDITIONS_SYNTAX"
$ 	delete adc.ide;*
$	if ok then libr FLN_CONDITIONS_SYNTAX
$ 	delete FLN_CONDITIONS_SYNTAX.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CREATE_JOB.rfo=FLN_CREATE_JOB
$	rfort FLN_CREATE_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_CREATE_JOB
$ 	purge/nolog FLN_CREATE_JOB.obj
$ 	delete/nolog FLN_CREATE_JOB.for;*
$ 	delete/nolog FLN_CREATE_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CREATE_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_CREATE_JOB
$ 	delete FLN_CREATE_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CREATE_PROJECT.rfo=FLN_CREATE_PROJECT
$	rfort FLN_CREATE_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_CREATE_PROJECT
$ 	purge/nolog FLN_CREATE_PROJECT.obj
$ 	delete/nolog FLN_CREATE_PROJECT.for;*
$ 	delete/nolog FLN_CREATE_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CREATE_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_CREATE_PROJECT
$ 	delete FLN_CREATE_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CREATE_OPERATOR.rfo=FLN_CREATE_OPERATOR
$	rfort FLN_CREATE_OPERATOR
$ 	ok=$status
$ 	if ok then pvv FLN_CREATE_OPERATOR
$ 	purge/nolog FLN_CREATE_OPERATOR.obj
$ 	delete/nolog FLN_CREATE_OPERATOR.for;*
$ 	delete/nolog FLN_CREATE_OPERATOR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CREATE_OPERATOR"
$ 	delete adc.ide;*
$	if ok then libr FLN_CREATE_OPERATOR
$ 	delete FLN_CREATE_OPERATOR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_CREATE_WORKSTATION.rfo=FLN_CREATE_WORKSTATION
$	rfort FLN_CREATE_WORKSTATION
$ 	ok=$status
$ 	if ok then pvv FLN_CREATE_WORKSTATION
$ 	purge/nolog FLN_CREATE_WORKSTATION.obj
$ 	delete/nolog FLN_CREATE_WORKSTATION.for;*
$ 	delete/nolog FLN_CREATE_WORKSTATION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_CREATE_WORKSTATION"
$ 	delete adc.ide;*
$	if ok then libr FLN_CREATE_WORKSTATION
$ 	delete FLN_CREATE_WORKSTATION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DEFINE_ELEMENT.rfo=FLN_DEFINE_ELEMENT
$	rfort FLN_DEFINE_ELEMENT
$ 	ok=$status
$ 	if ok then pvv FLN_DEFINE_ELEMENT
$ 	purge/nolog FLN_DEFINE_ELEMENT.obj
$ 	delete/nolog FLN_DEFINE_ELEMENT.for;*
$ 	delete/nolog FLN_DEFINE_ELEMENT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DEFINE_ELEMENT"
$ 	delete adc.ide;*
$	if ok then libr FLN_DEFINE_ELEMENT
$ 	delete FLN_DEFINE_ELEMENT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DEFINE_FLOWLINE.rfo=FLN_DEFINE_FLOWLINE
$	rfort FLN_DEFINE_FLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_DEFINE_FLOWLINE
$ 	purge/nolog FLN_DEFINE_FLOWLINE.obj
$ 	delete/nolog FLN_DEFINE_FLOWLINE.for;*
$ 	delete/nolog FLN_DEFINE_FLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DEFINE_FLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_DEFINE_FLOWLINE
$ 	delete FLN_DEFINE_FLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DEFINE_PROCEDURE.rfo=FLN_DEFINE_PROCEDURE
$	rfort FLN_DEFINE_PROCEDURE
$ 	ok=$status
$ 	if ok then pvv FLN_DEFINE_PROCEDURE
$ 	purge/nolog FLN_DEFINE_PROCEDURE.obj
$ 	delete/nolog FLN_DEFINE_PROCEDURE.for;*
$ 	delete/nolog FLN_DEFINE_PROCEDURE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DEFINE_PROCEDURE"
$ 	delete adc.ide;*
$	if ok then libr FLN_DEFINE_PROCEDURE
$ 	delete FLN_DEFINE_PROCEDURE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DEFINE_SYSTEM.rfo=FLN_DEFINE_SYSTEM
$	rfort FLN_DEFINE_SYSTEM
$ 	ok=$status
$ 	if ok then pvv FLN_DEFINE_SYSTEM
$ 	purge/nolog FLN_DEFINE_SYSTEM.obj
$ 	delete/nolog FLN_DEFINE_SYSTEM.for;*
$ 	delete/nolog FLN_DEFINE_SYSTEM.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DEFINE_SYSTEM"
$ 	delete adc.ide;*
$	if ok then libr FLN_DEFINE_SYSTEM
$ 	delete FLN_DEFINE_SYSTEM.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DEFINE_WIRE.rfo=FLN_DEFINE_WIRE
$	rfort FLN_DEFINE_WIRE
$ 	ok=$status
$ 	if ok then pvv FLN_DEFINE_WIRE
$ 	purge/nolog FLN_DEFINE_WIRE.obj
$ 	delete/nolog FLN_DEFINE_WIRE.for;*
$ 	delete/nolog FLN_DEFINE_WIRE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DEFINE_WIRE"
$ 	delete adc.ide;*
$	if ok then libr FLN_DEFINE_WIRE
$ 	delete FLN_DEFINE_WIRE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DELETE_JOB.rfo=FLN_DELETE_JOB
$	rfort FLN_DELETE_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_DELETE_JOB
$ 	purge/nolog FLN_DELETE_JOB.obj
$ 	delete/nolog FLN_DELETE_JOB.for;*
$ 	delete/nolog FLN_DELETE_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DELETE_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_DELETE_JOB
$ 	delete FLN_DELETE_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DELETE_LOCALS.rfo=FLN_DELETE_LOCALS
$	rfort FLN_DELETE_LOCALS
$ 	ok=$status
$ 	if ok then pvv FLN_DELETE_LOCALS
$ 	purge/nolog FLN_DELETE_LOCALS.obj
$ 	delete/nolog FLN_DELETE_LOCALS.for;*
$ 	delete/nolog FLN_DELETE_LOCALS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DELETE_LOCALS"
$ 	delete adc.ide;*
$	if ok then libr FLN_DELETE_LOCALS
$ 	delete FLN_DELETE_LOCALS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DELETE_OPERATOR.rfo=FLN_DELETE_OPERATOR
$	rfort FLN_DELETE_OPERATOR
$ 	ok=$status
$ 	if ok then pvv FLN_DELETE_OPERATOR
$ 	purge/nolog FLN_DELETE_OPERATOR.obj
$ 	delete/nolog FLN_DELETE_OPERATOR.for;*
$ 	delete/nolog FLN_DELETE_OPERATOR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DELETE_OPERATOR"
$ 	delete adc.ide;*
$	if ok then libr FLN_DELETE_OPERATOR
$ 	delete FLN_DELETE_OPERATOR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DELETE_PROJECT.rfo=FLN_DELETE_PROJECT
$	rfort FLN_DELETE_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_DELETE_PROJECT
$ 	purge/nolog FLN_DELETE_PROJECT.obj
$ 	delete/nolog FLN_DELETE_PROJECT.for;*
$ 	delete/nolog FLN_DELETE_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DELETE_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_DELETE_PROJECT
$ 	delete FLN_DELETE_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_DELETE_WORKSTATION.rfo=FLN_DELETE_WORKSTATION
$	rfort FLN_DELETE_WORKSTATION
$ 	ok=$status
$ 	if ok then pvv FLN_DELETE_WORKSTATION
$ 	purge/nolog FLN_DELETE_WORKSTATION.obj
$ 	delete/nolog FLN_DELETE_WORKSTATION.for;*
$ 	delete/nolog FLN_DELETE_WORKSTATION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_DELETE_WORKSTATION"
$ 	delete adc.ide;*
$	if ok then libr FLN_DELETE_WORKSTATION
$ 	delete FLN_DELETE_WORKSTATION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_END_FLOWLINE.rfo=FLN_END_FLOWLINE
$	rfort FLN_END_FLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_END_FLOWLINE
$ 	purge/nolog FLN_END_FLOWLINE.obj
$ 	delete/nolog FLN_END_FLOWLINE.for;*
$ 	delete/nolog FLN_END_FLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_END_FLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_END_FLOWLINE
$ 	delete FLN_END_FLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_END_SESSION.rfo=FLN_END_SESSION
$	rfort FLN_END_SESSION
$ 	ok=$status
$ 	if ok then pvv FLN_END_SESSION
$ 	purge/nolog FLN_END_SESSION.obj
$ 	delete/nolog FLN_END_SESSION.for;*
$ 	delete/nolog FLN_END_SESSION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_END_SESSION"
$ 	delete adc.ide;*
$	if ok then libr FLN_END_SESSION
$ 	delete FLN_END_SESSION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_END_SUB_JOB.rfo=FLN_END_SUB_JOB
$	rfort FLN_END_SUB_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_END_SUB_JOB
$ 	purge/nolog FLN_END_SUB_JOB.obj
$ 	delete/nolog FLN_END_SUB_JOB.for;*
$ 	delete/nolog FLN_END_SUB_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_END_SUB_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_END_SUB_JOB
$ 	delete FLN_END_SUB_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_EVAL=FLN_EVAL
$	fort FLN_EVAL
$ 	ok=$status
$ 	if ok then pvv FLN_EVAL
$ 	purge/nolog FLN_EVAL.obj
$ 	delete/nolog FLN_EVAL.for;*
$	if .not.ok then emsg=emsg+" FLN_EVAL"
$ 	delete adc.ide;*
$	if ok then libr FLN_EVAL
$ 	delete FLN_EVAL.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_ALL_WIRES.rfo=FLN_GET_ALL_WIRES
$	rfort FLN_GET_ALL_WIRES
$ 	ok=$status
$ 	if ok then pvv FLN_GET_ALL_WIRES
$ 	purge/nolog FLN_GET_ALL_WIRES.obj
$ 	delete/nolog FLN_GET_ALL_WIRES.for;*
$ 	delete/nolog FLN_GET_ALL_WIRES.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_ALL_WIRES"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_ALL_WIRES
$ 	delete FLN_GET_ALL_WIRES.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_COMPROC.rfo=FLN_GET_COMPROC
$	rfort FLN_GET_COMPROC
$ 	ok=$status
$ 	if ok then pvv FLN_GET_COMPROC
$ 	purge/nolog FLN_GET_COMPROC.obj
$ 	delete/nolog FLN_GET_COMPROC.for;*
$ 	delete/nolog FLN_GET_COMPROC.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_COMPROC"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_COMPROC
$ 	delete FLN_GET_COMPROC.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_DAY_TIME.rfo=FLN_GET_DAY_TIME
$	rfort FLN_GET_DAY_TIME
$ 	ok=$status
$ 	if ok then pvv FLN_GET_DAY_TIME
$ 	purge/nolog FLN_GET_DAY_TIME.obj
$ 	delete/nolog FLN_GET_DAY_TIME.for;*
$ 	delete/nolog FLN_GET_DAY_TIME.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_DAY_TIME"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_DAY_TIME
$ 	delete FLN_GET_DAY_TIME.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_EXTERNALS.rfo=FLN_GET_EXTERNALS
$	rfort FLN_GET_EXTERNALS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_EXTERNALS
$ 	purge/nolog FLN_GET_EXTERNALS.obj
$ 	delete/nolog FLN_GET_EXTERNALS.for;*
$ 	delete/nolog FLN_GET_EXTERNALS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_EXTERNALS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_EXTERNALS
$ 	delete FLN_GET_EXTERNALS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_FLOWLN.rfo=FLN_GET_FLOWLN
$	rfort FLN_GET_FLOWLN
$ 	ok=$status
$ 	if ok then pvv FLN_GET_FLOWLN
$ 	purge/nolog FLN_GET_FLOWLN.obj
$ 	delete/nolog FLN_GET_FLOWLN.for;*
$ 	delete/nolog FLN_GET_FLOWLN.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_FLOWLN"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_FLOWLN
$ 	delete FLN_GET_FLOWLN.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_READYS.rfo=FLN_GET_READYS
$	rfort FLN_GET_READYS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_READYS
$ 	purge/nolog FLN_GET_READYS.obj
$ 	delete/nolog FLN_GET_READYS.for;*
$ 	delete/nolog FLN_GET_READYS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_READYS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_READYS
$ 	delete FLN_GET_READYS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_INPUT_PAR.rfo=FLN_GET_INPUT_PAR
$	rfort FLN_GET_INPUT_PAR
$ 	ok=$status
$ 	if ok then pvv FLN_GET_INPUT_PAR
$ 	purge/nolog FLN_GET_INPUT_PAR.obj
$ 	delete/nolog FLN_GET_INPUT_PAR.for;*
$ 	delete/nolog FLN_GET_INPUT_PAR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_INPUT_PAR"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_INPUT_PAR
$ 	delete FLN_GET_INPUT_PAR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_LOCALS.rfo=FLN_GET_LOCALS
$	rfort FLN_GET_LOCALS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_LOCALS
$ 	purge/nolog FLN_GET_LOCALS.obj
$ 	delete/nolog FLN_GET_LOCALS.for;*
$ 	delete/nolog FLN_GET_LOCALS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_LOCALS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_LOCALS
$ 	delete FLN_GET_LOCALS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_JOB.rfo=FLN_GET_JOB
$	rfort FLN_GET_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_GET_JOB
$ 	purge/nolog FLN_GET_JOB.obj
$ 	delete/nolog FLN_GET_JOB.for;*
$ 	delete/nolog FLN_GET_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_JOB
$ 	delete FLN_GET_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_JOB_ID.rfo=FLN_GET_JOB_ID
$	rfort FLN_GET_JOB_ID
$ 	ok=$status
$ 	if ok then pvv FLN_GET_JOB_ID
$ 	purge/nolog FLN_GET_JOB_ID.obj
$ 	delete/nolog FLN_GET_JOB_ID.for;*
$ 	delete/nolog FLN_GET_JOB_ID.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_JOB_ID"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_JOB_ID
$ 	delete FLN_GET_JOB_ID.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_PARAMETER_ID.rfo=FLN_GET_PARAMETER_ID
$	rfort FLN_GET_PARAMETER_ID
$ 	ok=$status
$ 	if ok then pvv FLN_GET_PARAMETER_ID
$ 	purge/nolog FLN_GET_PARAMETER_ID.obj
$ 	delete/nolog FLN_GET_PARAMETER_ID.for;*
$ 	delete/nolog FLN_GET_PARAMETER_ID.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_PARAMETER_ID"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_PARAMETER_ID
$ 	delete FLN_GET_PARAMETER_ID.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_SESSION_ID.rfo=FLN_GET_SESSION_ID
$	rfort FLN_GET_SESSION_ID
$ 	ok=$status
$ 	if ok then pvv FLN_GET_SESSION_ID
$ 	purge/nolog FLN_GET_SESSION_ID.obj
$ 	delete/nolog FLN_GET_SESSION_ID.for;*
$ 	delete/nolog FLN_GET_SESSION_ID.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_SESSION_ID"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_SESSION_ID
$ 	delete FLN_GET_SESSION_ID.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_SUB_JOBS.rfo=FLN_GET_SUB_JOBS
$	rfort FLN_GET_SUB_JOBS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_SUB_JOBS
$ 	purge/nolog FLN_GET_SUB_JOBS.obj
$ 	delete/nolog FLN_GET_SUB_JOBS.for;*
$ 	delete/nolog FLN_GET_SUB_JOBS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_SUB_JOBS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_SUB_JOBS
$ 	delete FLN_GET_SUB_JOBS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_TASKS.rfo=FLN_GET_TASKS
$	rfort FLN_GET_TASKS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_TASKS
$ 	purge/nolog FLN_GET_TASKS.obj
$ 	delete/nolog FLN_GET_TASKS.for;*
$ 	delete/nolog FLN_GET_TASKS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_TASKS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_TASKS
$ 	delete FLN_GET_TASKS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_TASKS_JOB.rfo=FLN_GET_TASKS_JOB
$	rfort FLN_GET_TASKS_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_GET_TASKS_JOB
$ 	purge/nolog FLN_GET_TASKS_JOB.obj
$ 	delete/nolog FLN_GET_TASKS_JOB.for;*
$ 	delete/nolog FLN_GET_TASKS_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_TASKS_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_TASKS_JOB
$ 	delete FLN_GET_TASKS_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_TASK_ID.rfo=FLN_GET_TASK_ID
$	rfort FLN_GET_TASK_ID
$ 	ok=$status
$ 	if ok then pvv FLN_GET_TASK_ID
$ 	purge/nolog FLN_GET_TASK_ID.obj
$ 	delete/nolog FLN_GET_TASK_ID.for;*
$ 	delete/nolog FLN_GET_TASK_ID.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_TASK_ID"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_TASK_ID
$ 	delete FLN_GET_TASK_ID.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_TASK_SESSION.rfo=FLN_GET_TASK_SESSION
$	rfort FLN_GET_TASK_SESSION
$ 	ok=$status
$ 	if ok then pvv FLN_GET_TASK_SESSION
$ 	purge/nolog FLN_GET_TASK_SESSION.obj
$ 	delete/nolog FLN_GET_TASK_SESSION.for;*
$ 	delete/nolog FLN_GET_TASK_SESSION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_TASK_SESSION"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_TASK_SESSION
$ 	delete FLN_GET_TASK_SESSION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_TASK_INFO.rfo=FLN_GET_TASK_INFO
$	rfort FLN_GET_TASK_INFO
$ 	ok=$status
$ 	if ok then pvv FLN_GET_TASK_INFO
$ 	purge/nolog FLN_GET_TASK_INFO.obj
$ 	delete/nolog FLN_GET_TASK_INFO.for;*
$ 	delete/nolog FLN_GET_TASK_INFO.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_TASK_INFO"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_TASK_INFO
$ 	delete FLN_GET_TASK_INFO.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_WIRE_ENDS.rfo=FLN_GET_WIRE_ENDS
$	rfort FLN_GET_WIRE_ENDS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_WIRE_ENDS
$ 	purge/nolog FLN_GET_WIRE_ENDS.obj
$ 	delete/nolog FLN_GET_WIRE_ENDS.for;*
$ 	delete/nolog FLN_GET_WIRE_ENDS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_WIRE_ENDS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_WIRE_ENDS
$ 	delete FLN_GET_WIRE_ENDS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_WIRES.rfo=FLN_GET_WIRES
$	rfort FLN_GET_WIRES
$ 	ok=$status
$ 	if ok then pvv FLN_GET_WIRES
$ 	purge/nolog FLN_GET_WIRES.obj
$ 	delete/nolog FLN_GET_WIRES.for;*
$ 	delete/nolog FLN_GET_WIRES.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_WIRES"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_WIRES
$ 	delete FLN_GET_WIRES.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_GET_WIRE_STATUS.rfo=FLN_GET_WIRE_STATUS
$	rfort FLN_GET_WIRE_STATUS
$ 	ok=$status
$ 	if ok then pvv FLN_GET_WIRE_STATUS
$ 	purge/nolog FLN_GET_WIRE_STATUS.obj
$ 	delete/nolog FLN_GET_WIRE_STATUS.for;*
$ 	delete/nolog FLN_GET_WIRE_STATUS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_GET_WIRE_STATUS"
$ 	delete adc.ide;*
$	if ok then libr FLN_GET_WIRE_STATUS
$ 	delete FLN_GET_WIRE_STATUS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_HAD_TASK.rfo=FLN_HAD_TASK
$	rfort FLN_HAD_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_HAD_TASK
$ 	purge/nolog FLN_HAD_TASK.obj
$ 	delete/nolog FLN_HAD_TASK.for;*
$ 	delete/nolog FLN_HAD_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_HAD_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_HAD_TASK
$ 	delete FLN_HAD_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_HOLD_JOB=FLN_HOLD_JOB
$	fort FLN_HOLD_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_HOLD_JOB
$ 	purge/nolog FLN_HOLD_JOB.obj
$ 	delete/nolog FLN_HOLD_JOB.for;*
$	if .not.ok then emsg=emsg+" FLN_HOLD_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_HOLD_JOB
$ 	delete FLN_HOLD_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_HOLD_PROJECT=FLN_HOLD_PROJECT
$	fort FLN_HOLD_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_HOLD_PROJECT
$ 	purge/nolog FLN_HOLD_PROJECT.obj
$ 	delete/nolog FLN_HOLD_PROJECT.for;*
$	if .not.ok then emsg=emsg+" FLN_HOLD_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_HOLD_PROJECT
$ 	delete FLN_HOLD_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_HOLD_TASK.rfo=FLN_HOLD_TASK
$	rfort FLN_HOLD_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_HOLD_TASK
$ 	purge/nolog FLN_HOLD_TASK.obj
$ 	delete/nolog FLN_HOLD_TASK.for;*
$ 	delete/nolog FLN_HOLD_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_HOLD_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_HOLD_TASK
$ 	delete FLN_HOLD_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_INIT=FLN_INIT
$	fort FLN_INIT
$ 	ok=$status
$ 	if ok then pvv FLN_INIT
$ 	purge/nolog FLN_INIT.obj
$ 	delete/nolog FLN_INIT.for;*
$	if .not.ok then emsg=emsg+" FLN_INIT"
$ 	delete adc.ide;*
$	if ok then libr FLN_INIT
$ 	delete FLN_INIT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_IS_READY.rfo=FLN_IS_READY
$	rfort FLN_IS_READY
$ 	ok=$status
$ 	if ok then pvv FLN_IS_READY
$ 	purge/nolog FLN_IS_READY.obj
$ 	delete/nolog FLN_IS_READY.for;*
$ 	delete/nolog FLN_IS_READY.rfo;*
$	if .not.ok then emsg=emsg+" FLN_IS_READY"
$ 	delete adc.ide;*
$	if ok then libr FLN_IS_READY
$ 	delete FLN_IS_READY.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_JOBSTART_UPDATE.rfo=FLN_JOBSTART_UPDATE
$	rfort FLN_JOBSTART_UPDATE
$ 	ok=$status
$ 	if ok then pvv FLN_JOBSTART_UPDATE
$ 	purge/nolog FLN_JOBSTART_UPDATE.obj
$ 	delete/nolog FLN_JOBSTART_UPDATE.for;*
$ 	delete/nolog FLN_JOBSTART_UPDATE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_JOBSTART_UPDATE"
$ 	delete adc.ide;*
$	if ok then libr FLN_JOBSTART_UPDATE
$ 	delete FLN_JOBSTART_UPDATE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_OP_AUTH=FLN_LIST_OP_AUTH
$	fort FLN_LIST_OP_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_OP_AUTH
$ 	purge/nolog FLN_LIST_OP_AUTH.obj
$ 	delete/nolog FLN_LIST_OP_AUTH.for;*
$	if .not.ok then emsg=emsg+" FLN_LIST_OP_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_OP_AUTH
$ 	delete FLN_LIST_OP_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_AUTHORISED_TASKS=FLN_LIST_AUTHORISED_TASKS
$	fort FLN_LIST_AUTHORISED_TASKS
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_AUTHORISED_TASKS
$ 	purge/nolog FLN_LIST_AUTHORISED_TASKS.obj
$ 	delete/nolog FLN_LIST_AUTHORISED_TASKS.for;*
$	if .not.ok then emsg=emsg+" FLN_LIST_AUTHORISED_TASKS"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_AUTHORISED_TASKS
$ 	delete FLN_LIST_AUTHORISED_TASKS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_JOB.rfo=FLN_LIST_JOB
$	rfort FLN_LIST_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_JOB
$ 	purge/nolog FLN_LIST_JOB.obj
$ 	delete/nolog FLN_LIST_JOB.for;*
$ 	delete/nolog FLN_LIST_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_LIST_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_JOB
$ 	delete FLN_LIST_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_TASK.rfo=FLN_LIST_TASK
$	rfort FLN_LIST_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_TASK
$ 	purge/nolog FLN_LIST_TASK.obj
$ 	delete/nolog FLN_LIST_TASK.for;*
$ 	delete/nolog FLN_LIST_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_LIST_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_TASK
$ 	delete FLN_LIST_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_SESSION.rfo=FLN_LIST_SESSION
$	rfort FLN_LIST_SESSION
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_SESSION
$ 	purge/nolog FLN_LIST_SESSION.obj
$ 	delete/nolog FLN_LIST_SESSION.for;*
$ 	delete/nolog FLN_LIST_SESSION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_LIST_SESSION"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_SESSION
$ 	delete FLN_LIST_SESSION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_JOB_HIS.rfo=FLN_LIST_JOB_HIS
$	rfort FLN_LIST_JOB_HIS
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_JOB_HIS
$ 	purge/nolog FLN_LIST_JOB_HIS.obj
$ 	delete/nolog FLN_LIST_JOB_HIS.for;*
$ 	delete/nolog FLN_LIST_JOB_HIS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_LIST_JOB_HIS"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_JOB_HIS
$ 	delete FLN_LIST_JOB_HIS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_TASK_HIS.rfo=FLN_LIST_TASK_HIS
$	rfort FLN_LIST_TASK_HIS
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_TASK_HIS
$ 	purge/nolog FLN_LIST_TASK_HIS.obj
$ 	delete/nolog FLN_LIST_TASK_HIS.for;*
$ 	delete/nolog FLN_LIST_TASK_HIS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_LIST_TASK_HIS"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_TASK_HIS
$ 	delete FLN_LIST_TASK_HIS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_LIST_SESSION_HIS.rfo=FLN_LIST_SESSION_HIS
$	rfort FLN_LIST_SESSION_HIS
$ 	ok=$status
$ 	if ok then pvv FLN_LIST_SESSION_HIS
$ 	purge/nolog FLN_LIST_SESSION_HIS.obj
$ 	delete/nolog FLN_LIST_SESSION_HIS.for;*
$ 	delete/nolog FLN_LIST_SESSION_HIS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_LIST_SESSION_HIS"
$ 	delete adc.ide;*
$	if ok then libr FLN_LIST_SESSION_HIS
$ 	delete FLN_LIST_SESSION_HIS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_PROCESS_OUTCOME=FLN_PROCESS_OUTCOME
$	fort FLN_PROCESS_OUTCOME
$ 	ok=$status
$ 	if ok then pvv FLN_PROCESS_OUTCOME
$ 	purge/nolog FLN_PROCESS_OUTCOME.obj
$ 	delete/nolog FLN_PROCESS_OUTCOME.for;*
$	if .not.ok then emsg=emsg+" FLN_PROCESS_OUTCOME"
$ 	delete adc.ide;*
$	if ok then libr FLN_PROCESS_OUTCOME
$ 	delete FLN_PROCESS_OUTCOME.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RELEASE_JOB=FLN_RELEASE_JOB
$	fort FLN_RELEASE_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_RELEASE_JOB
$ 	purge/nolog FLN_RELEASE_JOB.obj
$ 	delete/nolog FLN_RELEASE_JOB.for;*
$	if .not.ok then emsg=emsg+" FLN_RELEASE_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_RELEASE_JOB
$ 	delete FLN_RELEASE_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RELEASE_PROJECT=FLN_RELEASE_PROJECT
$	fort FLN_RELEASE_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_RELEASE_PROJECT
$ 	purge/nolog FLN_RELEASE_PROJECT.obj
$ 	delete/nolog FLN_RELEASE_PROJECT.for;*
$	if .not.ok then emsg=emsg+" FLN_RELEASE_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_RELEASE_PROJECT
$ 	delete FLN_RELEASE_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RELEASE_TASK.rfo=FLN_RELEASE_TASK
$	rfort FLN_RELEASE_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_RELEASE_TASK
$ 	purge/nolog FLN_RELEASE_TASK.obj
$ 	delete/nolog FLN_RELEASE_TASK.for;*
$ 	delete/nolog FLN_RELEASE_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RELEASE_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_RELEASE_TASK
$ 	delete FLN_RELEASE_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_REMOVE_SPACES=FLN_REMOVE_SPACES
$	fort FLN_REMOVE_SPACES
$ 	ok=$status
$ 	if ok then pvv FLN_REMOVE_SPACES
$ 	purge/nolog FLN_REMOVE_SPACES.obj
$ 	delete/nolog FLN_REMOVE_SPACES.for;*
$	if .not.ok then emsg=emsg+" FLN_REMOVE_SPACES"
$ 	delete adc.ide;*
$	if ok then libr FLN_REMOVE_SPACES
$ 	delete FLN_REMOVE_SPACES.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RESET_JOB=FLN_RESET_JOB
$	fort FLN_RESET_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_RESET_JOB
$ 	purge/nolog FLN_RESET_JOB.obj
$ 	delete/nolog FLN_RESET_JOB.for;*
$	if .not.ok then emsg=emsg+" FLN_RESET_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_RESET_JOB
$ 	delete FLN_RESET_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RESET_JOB_INT=FLN_RESET_JOB_INT
$	fort FLN_RESET_JOB_INT
$ 	ok=$status
$ 	if ok then pvv FLN_RESET_JOB_INT
$ 	purge/nolog FLN_RESET_JOB_INT.obj
$ 	delete/nolog FLN_RESET_JOB_INT.for;*
$	if .not.ok then emsg=emsg+" FLN_RESET_JOB_INT"
$ 	delete adc.ide;*
$	if ok then libr FLN_RESET_JOB_INT
$ 	delete FLN_RESET_JOB_INT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RESET_OP_AUTH.rfo=FLN_RESET_OP_AUTH
$	rfort FLN_RESET_OP_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_RESET_OP_AUTH
$ 	purge/nolog FLN_RESET_OP_AUTH.obj
$ 	delete/nolog FLN_RESET_OP_AUTH.for;*
$ 	delete/nolog FLN_RESET_OP_AUTH.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RESET_OP_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_RESET_OP_AUTH
$ 	delete FLN_RESET_OP_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RESET_UPDATE.rfo=FLN_RESET_UPDATE
$	rfort FLN_RESET_UPDATE
$ 	ok=$status
$ 	if ok then pvv FLN_RESET_UPDATE
$ 	purge/nolog FLN_RESET_UPDATE.obj
$ 	delete/nolog FLN_RESET_UPDATE.for;*
$ 	delete/nolog FLN_RESET_UPDATE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RESET_UPDATE"
$ 	delete adc.ide;*
$	if ok then libr FLN_RESET_UPDATE
$ 	delete FLN_RESET_UPDATE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RESET_WORK_AUTH.rfo=FLN_RESET_WORK_AUTH
$	rfort FLN_RESET_WORK_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_RESET_WORK_AUTH
$ 	purge/nolog FLN_RESET_WORK_AUTH.obj
$ 	delete/nolog FLN_RESET_WORK_AUTH.for;*
$ 	delete/nolog FLN_RESET_WORK_AUTH.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RESET_WORK_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_RESET_WORK_AUTH
$ 	delete FLN_RESET_WORK_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ACTIVE_SESSIONS.rfo=FLN_RETRIEVE_ACTIVE_SESSIONS
$	rfort FLN_RETRIEVE_ACTIVE_SESSIONS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ACTIVE_SESSIONS
$ 	purge/nolog FLN_RETRIEVE_ACTIVE_SESSIONS.obj
$ 	delete/nolog FLN_RETRIEVE_ACTIVE_SESSIONS.for;*
$ 	delete/nolog FLN_RETRIEVE_ACTIVE_SESSIONS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ACTIVE_SESSIONS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ACTIVE_SESSIONS
$ 	delete FLN_RETRIEVE_ACTIVE_SESSIONS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_WIRES_FLOWLINE.rfo=FLN_RETRIEVE_WIRES_FLOWLINE
$	rfort FLN_RETRIEVE_WIRES_FLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_WIRES_FLOWLINE
$ 	purge/nolog FLN_RETRIEVE_WIRES_FLOWLINE.obj
$ 	delete/nolog FLN_RETRIEVE_WIRES_FLOWLINE.for;*
$ 	delete/nolog FLN_RETRIEVE_WIRES_FLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_WIRES_FLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_WIRES_FLOWLINE
$ 	delete FLN_RETRIEVE_WIRES_FLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ELEMENTS_FLOWLINE.rfo=FLN_RETRIEVE_ELEMENTS_FLOWLINE
$	rfort FLN_RETRIEVE_ELEMENTS_FLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ELEMENTS_FLOWLINE
$ 	purge/nolog FLN_RETRIEVE_ELEMENTS_FLOWLINE.obj
$ 	delete/nolog FLN_RETRIEVE_ELEMENTS_FLOWLINE.for;*
$ 	delete/nolog FLN_RETRIEVE_ELEMENTS_FLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ELEMENTS_FLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ELEMENTS_FLOWLINE
$ 	delete FLN_RETRIEVE_ELEMENTS_FLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ELEM_IDS_FLOWLINE.rfo=FLN_RETRIEVE_ELEM_IDS_FLOWLINE
$	rfort FLN_RETRIEVE_ELEM_IDS_FLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ELEM_IDS_FLOWLINE
$ 	purge/nolog FLN_RETRIEVE_ELEM_IDS_FLOWLINE.obj
$ 	delete/nolog FLN_RETRIEVE_ELEM_IDS_FLOWLINE.for;*
$ 	delete/nolog FLN_RETRIEVE_ELEM_IDS_FLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ELEM_IDS_FLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ELEM_IDS_FLOWLINE
$ 	delete FLN_RETRIEVE_ELEM_IDS_FLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_PROCEDURES.rfo=FLN_RETRIEVE_ALL_PROCEDURES
$	rfort FLN_RETRIEVE_ALL_PROCEDURES
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_PROCEDURES
$ 	purge/nolog FLN_RETRIEVE_ALL_PROCEDURES.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_PROCEDURES.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_PROCEDURES.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_PROCEDURES"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_PROCEDURES
$ 	delete FLN_RETRIEVE_ALL_PROCEDURES.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_FLOWLINES.rfo=FLN_RETRIEVE_ALL_FLOWLINES
$	rfort FLN_RETRIEVE_ALL_FLOWLINES
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_FLOWLINES
$ 	purge/nolog FLN_RETRIEVE_ALL_FLOWLINES.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_FLOWLINES.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_FLOWLINES.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_FLOWLINES"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_FLOWLINES
$ 	delete FLN_RETRIEVE_ALL_FLOWLINES.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_FLOWLINE_IDS.rfo=FLN_RETRIEVE_ALL_FLOWLINE_IDS
$	rfort FLN_RETRIEVE_ALL_FLOWLINE_IDS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_FLOWLINE_IDS
$ 	purge/nolog FLN_RETRIEVE_ALL_FLOWLINE_IDS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_FLOWLINE_IDS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_FLOWLINE_IDS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_FLOWLINE_IDS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_FLOWLINE_IDS
$ 	delete FLN_RETRIEVE_ALL_FLOWLINE_IDS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_JOBS.rfo=FLN_RETRIEVE_ALL_JOBS
$	rfort FLN_RETRIEVE_ALL_JOBS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_JOBS
$ 	purge/nolog FLN_RETRIEVE_ALL_JOBS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_JOBS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_JOBS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_JOBS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_JOBS
$ 	delete FLN_RETRIEVE_ALL_JOBS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_OPERATORS.rfo=FLN_RETRIEVE_ALL_OPERATORS
$	rfort FLN_RETRIEVE_ALL_OPERATORS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_OPERATORS
$ 	purge/nolog FLN_RETRIEVE_ALL_OPERATORS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_OPERATORS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_OPERATORS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_OPERATORS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_OPERATORS
$ 	delete FLN_RETRIEVE_ALL_OPERATORS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_OPER_IDS.rfo=FLN_RETRIEVE_ALL_OPER_IDS
$	rfort FLN_RETRIEVE_ALL_OPER_IDS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_OPER_IDS
$ 	purge/nolog FLN_RETRIEVE_ALL_OPER_IDS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_OPER_IDS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_OPER_IDS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_OPER_IDS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_OPER_IDS
$ 	delete FLN_RETRIEVE_ALL_OPER_IDS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_PROJECTS.rfo=FLN_RETRIEVE_ALL_PROJECTS
$	rfort FLN_RETRIEVE_ALL_PROJECTS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_PROJECTS
$ 	purge/nolog FLN_RETRIEVE_ALL_PROJECTS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_PROJECTS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_PROJECTS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_PROJECTS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_PROJECTS
$ 	delete FLN_RETRIEVE_ALL_PROJECTS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_SESSIONS.rfo=FLN_RETRIEVE_ALL_SESSIONS
$	rfort FLN_RETRIEVE_ALL_SESSIONS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_SESSIONS
$ 	purge/nolog FLN_RETRIEVE_ALL_SESSIONS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_SESSIONS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_SESSIONS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_SESSIONS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_SESSIONS
$ 	delete FLN_RETRIEVE_ALL_SESSIONS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_TASKS.rfo=FLN_RETRIEVE_ALL_TASKS
$	rfort FLN_RETRIEVE_ALL_TASKS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_TASKS
$ 	purge/nolog FLN_RETRIEVE_ALL_TASKS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_TASKS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_TASKS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_TASKS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_TASKS
$ 	delete FLN_RETRIEVE_ALL_TASKS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_WORKSTATIONS.rfo=FLN_RETRIEVE_ALL_WORKSTATIONS
$	rfort FLN_RETRIEVE_ALL_WORKSTATIONS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_WORKSTATIONS
$ 	purge/nolog FLN_RETRIEVE_ALL_WORKSTATIONS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_WORKSTATIONS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_WORKSTATIONS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_WORKSTATIONS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_WORKSTATIONS
$ 	delete FLN_RETRIEVE_ALL_WORKSTATIONS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ALL_WORK_IDS.rfo=FLN_RETRIEVE_ALL_WORK_IDS
$	rfort FLN_RETRIEVE_ALL_WORK_IDS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ALL_WORK_IDS
$ 	purge/nolog FLN_RETRIEVE_ALL_WORK_IDS.obj
$ 	delete/nolog FLN_RETRIEVE_ALL_WORK_IDS.for;*
$ 	delete/nolog FLN_RETRIEVE_ALL_WORK_IDS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ALL_WORK_IDS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ALL_WORK_IDS
$ 	delete FLN_RETRIEVE_ALL_WORK_IDS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_CREATED_JOBS.rfo=FLN_RETRIEVE_CREATED_JOBS
$	rfort FLN_RETRIEVE_CREATED_JOBS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_CREATED_JOBS
$ 	purge/nolog FLN_RETRIEVE_CREATED_JOBS.obj
$ 	delete/nolog FLN_RETRIEVE_CREATED_JOBS.for;*
$ 	delete/nolog FLN_RETRIEVE_CREATED_JOBS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_CREATED_JOBS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_CREATED_JOBS
$ 	delete FLN_RETRIEVE_CREATED_JOBS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_CREATED_PROJECTS.rfo=FLN_RETRIEVE_CREATED_PROJECTS
$	rfort FLN_RETRIEVE_CREATED_PROJECTS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_CREATED_PROJECTS
$ 	purge/nolog FLN_RETRIEVE_CREATED_PROJECTS.obj
$ 	delete/nolog FLN_RETRIEVE_CREATED_PROJECTS.for;*
$ 	delete/nolog FLN_RETRIEVE_CREATED_PROJECTS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_CREATED_PROJECTS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_CREATED_PROJECTS
$ 	delete FLN_RETRIEVE_CREATED_PROJECTS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_CURRENT.rfo=FLN_RETRIEVE_CURRENT
$	rfort FLN_RETRIEVE_CURRENT
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_CURRENT
$ 	purge/nolog FLN_RETRIEVE_CURRENT.obj
$ 	delete/nolog FLN_RETRIEVE_CURRENT.for;*
$ 	delete/nolog FLN_RETRIEVE_CURRENT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_CURRENT"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_CURRENT
$ 	delete FLN_RETRIEVE_CURRENT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_CURRENT_JOB.rfo=FLN_RETRIEVE_CURRENT_JOB
$	rfort FLN_RETRIEVE_CURRENT_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_CURRENT_JOB
$ 	purge/nolog FLN_RETRIEVE_CURRENT_JOB.obj
$ 	delete/nolog FLN_RETRIEVE_CURRENT_JOB.for;*
$ 	delete/nolog FLN_RETRIEVE_CURRENT_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_CURRENT_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_CURRENT_JOB
$ 	delete FLN_RETRIEVE_CURRENT_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_OPERATOR_AUTH.rfo=FLN_RETRIEVE_OPERATOR_AUTH
$	rfort FLN_RETRIEVE_OPERATOR_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_OPERATOR_AUTH
$ 	purge/nolog FLN_RETRIEVE_OPERATOR_AUTH.obj
$ 	delete/nolog FLN_RETRIEVE_OPERATOR_AUTH.for;*
$ 	delete/nolog FLN_RETRIEVE_OPERATOR_AUTH.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_OPERATOR_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_OPERATOR_AUTH
$ 	delete FLN_RETRIEVE_OPERATOR_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_WORKSTATION_AUTH.rfo=FLN_RETRIEVE_WORKSTATION_AUTH
$	rfort FLN_RETRIEVE_WORKSTATION_AUTH
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_WORKSTATION_AUTH
$ 	purge/nolog FLN_RETRIEVE_WORKSTATION_AUTH.obj
$ 	delete/nolog FLN_RETRIEVE_WORKSTATION_AUTH.for;*
$ 	delete/nolog FLN_RETRIEVE_WORKSTATION_AUTH.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_WORKSTATION_AUTH"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_WORKSTATION_AUTH
$ 	delete FLN_RETRIEVE_WORKSTATION_AUTH.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_CURRENT_PROJECT.rfo=FLN_RETRIEVE_CURRENT_PROJECT
$	rfort FLN_RETRIEVE_CURRENT_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_CURRENT_PROJECT
$ 	purge/nolog FLN_RETRIEVE_CURRENT_PROJECT.obj
$ 	delete/nolog FLN_RETRIEVE_CURRENT_PROJECT.for;*
$ 	delete/nolog FLN_RETRIEVE_CURRENT_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_CURRENT_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_CURRENT_PROJECT
$ 	delete FLN_RETRIEVE_CURRENT_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_CURRENT_TASK.rfo=FLN_RETRIEVE_CURRENT_TASK
$	rfort FLN_RETRIEVE_CURRENT_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_CURRENT_TASK
$ 	purge/nolog FLN_RETRIEVE_CURRENT_TASK.obj
$ 	delete/nolog FLN_RETRIEVE_CURRENT_TASK.for;*
$ 	delete/nolog FLN_RETRIEVE_CURRENT_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_CURRENT_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_CURRENT_TASK
$ 	delete FLN_RETRIEVE_CURRENT_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ELEMENT_DEF.rfo=FLN_RETRIEVE_ELEMENT_DEF
$	rfort FLN_RETRIEVE_ELEMENT_DEF
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ELEMENT_DEF
$ 	purge/nolog FLN_RETRIEVE_ELEMENT_DEF.obj
$ 	delete/nolog FLN_RETRIEVE_ELEMENT_DEF.for;*
$ 	delete/nolog FLN_RETRIEVE_ELEMENT_DEF.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ELEMENT_DEF"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ELEMENT_DEF
$ 	delete FLN_RETRIEVE_ELEMENT_DEF.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_FLOWLINE_DEF.rfo=FLN_RETRIEVE_FLOWLINE_DEF
$	rfort FLN_RETRIEVE_FLOWLINE_DEF
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_FLOWLINE_DEF
$ 	purge/nolog FLN_RETRIEVE_FLOWLINE_DEF.obj
$ 	delete/nolog FLN_RETRIEVE_FLOWLINE_DEF.for;*
$ 	delete/nolog FLN_RETRIEVE_FLOWLINE_DEF.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_FLOWLINE_DEF"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_FLOWLINE_DEF
$ 	delete FLN_RETRIEVE_FLOWLINE_DEF.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_INFO_JOB_ID.rfo=FLN_RETRIEVE_INFO_JOB_ID
$	rfort FLN_RETRIEVE_INFO_JOB_ID
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_INFO_JOB_ID
$ 	purge/nolog FLN_RETRIEVE_INFO_JOB_ID.obj
$ 	delete/nolog FLN_RETRIEVE_INFO_JOB_ID.for;*
$ 	delete/nolog FLN_RETRIEVE_INFO_JOB_ID.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_INFO_JOB_ID"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_INFO_JOB_ID
$ 	delete FLN_RETRIEVE_INFO_JOB_ID.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_OUTER_INFO_JOB_ID.rfo=FLN_RETRIEVE_OUTER_INFO_JOB_ID
$	rfort FLN_RETRIEVE_OUTER_INFO_JOB_ID
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_OUTER_INFO_JOB_ID
$ 	purge/nolog FLN_RETRIEVE_OUTER_INFO_JOB_ID.obj
$ 	delete/nolog FLN_RETRIEVE_OUTER_INFO_JOB_ID.for;*
$ 	delete/nolog FLN_RETRIEVE_OUTER_INFO_JOB_ID.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_OUTER_INFO_JOB_ID"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_OUTER_INFO_JOB_ID
$ 	delete FLN_RETRIEVE_OUTER_INFO_JOB_ID.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_PROCEDURE_DEF.rfo=FLN_RETRIEVE_PROCEDURE_DEF
$	rfort FLN_RETRIEVE_PROCEDURE_DEF
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_PROCEDURE_DEF
$ 	purge/nolog FLN_RETRIEVE_PROCEDURE_DEF.obj
$ 	delete/nolog FLN_RETRIEVE_PROCEDURE_DEF.for;*
$ 	delete/nolog FLN_RETRIEVE_PROCEDURE_DEF.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_PROCEDURE_DEF"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_PROCEDURE_DEF
$ 	delete FLN_RETRIEVE_PROCEDURE_DEF.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_WIRE_DEF.rfo=FLN_RETRIEVE_WIRE_DEF
$	rfort FLN_RETRIEVE_WIRE_DEF
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_WIRE_DEF
$ 	purge/nolog FLN_RETRIEVE_WIRE_DEF.obj
$ 	delete/nolog FLN_RETRIEVE_WIRE_DEF.for;*
$ 	delete/nolog FLN_RETRIEVE_WIRE_DEF.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_WIRE_DEF"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_WIRE_DEF
$ 	delete FLN_RETRIEVE_WIRE_DEF.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_SYSTEM_DEF.rfo=FLN_RETRIEVE_SYSTEM_DEF
$	rfort FLN_RETRIEVE_SYSTEM_DEF
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_SYSTEM_DEF
$ 	purge/nolog FLN_RETRIEVE_SYSTEM_DEF.obj
$ 	delete/nolog FLN_RETRIEVE_SYSTEM_DEF.for;*
$ 	delete/nolog FLN_RETRIEVE_SYSTEM_DEF.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_SYSTEM_DEF"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_SYSTEM_DEF
$ 	delete FLN_RETRIEVE_SYSTEM_DEF.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_JOB_TASK.rfo=FLN_RETRIEVE_JOB_TASK
$	rfort FLN_RETRIEVE_JOB_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_JOB_TASK
$ 	purge/nolog FLN_RETRIEVE_JOB_TASK.obj
$ 	delete/nolog FLN_RETRIEVE_JOB_TASK.for;*
$ 	delete/nolog FLN_RETRIEVE_JOB_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_JOB_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_JOB_TASK
$ 	delete FLN_RETRIEVE_JOB_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_JOBS.rfo=FLN_RETRIEVE_JOBS
$	rfort FLN_RETRIEVE_JOBS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_JOBS
$ 	purge/nolog FLN_RETRIEVE_JOBS.obj
$ 	delete/nolog FLN_RETRIEVE_JOBS.for;*
$ 	delete/nolog FLN_RETRIEVE_JOBS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_JOBS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_JOBS
$ 	delete FLN_RETRIEVE_JOBS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_JOB_HIST_PROJECT.rfo=FLN_RETRIEVE_JOB_HIST_PROJECT
$	rfort FLN_RETRIEVE_JOB_HIST_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_JOB_HIST_PROJECT
$ 	purge/nolog FLN_RETRIEVE_JOB_HIST_PROJECT.obj
$ 	delete/nolog FLN_RETRIEVE_JOB_HIST_PROJECT.for;*
$ 	delete/nolog FLN_RETRIEVE_JOB_HIST_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_JOB_HIST_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_JOB_HIST_PROJECT
$ 	delete FLN_RETRIEVE_JOB_HIST_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_JOBS_PROJECT.rfo=FLN_RETRIEVE_JOBS_PROJECT
$	rfort FLN_RETRIEVE_JOBS_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_JOBS_PROJECT
$ 	purge/nolog FLN_RETRIEVE_JOBS_PROJECT.obj
$ 	delete/nolog FLN_RETRIEVE_JOBS_PROJECT.for;*
$ 	delete/nolog FLN_RETRIEVE_JOBS_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_JOBS_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_JOBS_PROJECT
$ 	delete FLN_RETRIEVE_JOBS_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_PROJECTS.rfo=FLN_RETRIEVE_PROJECTS
$	rfort FLN_RETRIEVE_PROJECTS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_PROJECTS
$ 	purge/nolog FLN_RETRIEVE_PROJECTS.obj
$ 	delete/nolog FLN_RETRIEVE_PROJECTS.for;*
$ 	delete/nolog FLN_RETRIEVE_PROJECTS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_PROJECTS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_PROJECTS
$ 	delete FLN_RETRIEVE_PROJECTS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ELEMENT_TIMINGS.rfo=FLN_RETRIEVE_ELEMENT_TIMINGS
$	rfort FLN_RETRIEVE_ELEMENT_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ELEMENT_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_ELEMENT_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_ELEMENT_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_ELEMENT_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ELEMENT_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ELEMENT_TIMINGS
$ 	delete FLN_RETRIEVE_ELEMENT_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_OPER_WORK_TIMINGS.rfo=FLN_RETRIEVE_OPER_WORK_TIMINGS
$	rfort FLN_RETRIEVE_OPER_WORK_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_OPER_WORK_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_OPER_WORK_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_OPER_WORK_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_OPER_WORK_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_OPER_WORK_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_OPER_WORK_TIMINGS
$ 	delete FLN_RETRIEVE_OPER_WORK_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_WORK_OPER_TIMINGS.rfo=FLN_RETRIEVE_WORK_OPER_TIMINGS
$	rfort FLN_RETRIEVE_WORK_OPER_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_WORK_OPER_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_WORK_OPER_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_WORK_OPER_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_WORK_OPER_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_WORK_OPER_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_WORK_OPER_TIMINGS
$ 	delete FLN_RETRIEVE_WORK_OPER_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_OPER_ELEM_TIMINGS.rfo=FLN_RETRIEVE_OPER_ELEM_TIMINGS
$	rfort FLN_RETRIEVE_OPER_ELEM_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_OPER_ELEM_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_OPER_ELEM_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_OPER_ELEM_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_OPER_ELEM_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_OPER_ELEM_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_OPER_ELEM_TIMINGS
$ 	delete FLN_RETRIEVE_OPER_ELEM_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_WORK_ELEM_TIMINGS.rfo=FLN_RETRIEVE_WORK_ELEM_TIMINGS
$	rfort FLN_RETRIEVE_WORK_ELEM_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_WORK_ELEM_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_WORK_ELEM_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_WORK_ELEM_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_WORK_ELEM_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_WORK_ELEM_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_WORK_ELEM_TIMINGS
$ 	delete FLN_RETRIEVE_WORK_ELEM_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ELEM_OPER_TIMINGS.rfo=FLN_RETRIEVE_ELEM_OPER_TIMINGS
$	rfort FLN_RETRIEVE_ELEM_OPER_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ELEM_OPER_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_ELEM_OPER_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_ELEM_OPER_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_ELEM_OPER_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ELEM_OPER_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ELEM_OPER_TIMINGS
$ 	delete FLN_RETRIEVE_ELEM_OPER_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_ELEM_WORK_TIMINGS.rfo=FLN_RETRIEVE_ELEM_WORK_TIMINGS
$	rfort FLN_RETRIEVE_ELEM_WORK_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_ELEM_WORK_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_ELEM_WORK_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_ELEM_WORK_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_ELEM_WORK_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_ELEM_WORK_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_ELEM_WORK_TIMINGS
$ 	delete FLN_RETRIEVE_ELEM_WORK_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_WORK_TOTAL_TIMINGS.rfo=FLN_RETRIEVE_WORK_TOTAL_TIMINGS
$	rfort FLN_RETRIEVE_WORK_TOTAL_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_WORK_TOTAL_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_WORK_TOTAL_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_WORK_TOTAL_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_WORK_TOTAL_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_WORK_TOTAL_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_WORK_TOTAL_TIMINGS
$ 	delete FLN_RETRIEVE_WORK_TOTAL_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_OPER_TOTAL_TIMINGS.rfo=FLN_RETRIEVE_OPER_TOTAL_TIMINGS
$	rfort FLN_RETRIEVE_OPER_TOTAL_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_OPER_TOTAL_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_OPER_TOTAL_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_OPER_TOTAL_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_OPER_TOTAL_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_OPER_TOTAL_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_OPER_TOTAL_TIMINGS
$ 	delete FLN_RETRIEVE_OPER_TOTAL_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_FLOWLINE_TIMINGS.rfo=FLN_RETRIEVE_FLOWLINE_TIMINGS
$	rfort FLN_RETRIEVE_FLOWLINE_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_FLOWLINE_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_FLOWLINE_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_FLOWLINE_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_FLOWLINE_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_FLOWLINE_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_FLOWLINE_TIMINGS
$ 	delete FLN_RETRIEVE_FLOWLINE_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_PROJECT_TIMINGS.rfo=FLN_RETRIEVE_PROJECT_TIMINGS
$	rfort FLN_RETRIEVE_PROJECT_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_PROJECT_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_PROJECT_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_PROJECT_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_PROJECT_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_PROJECT_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_PROJECT_TIMINGS
$ 	delete FLN_RETRIEVE_PROJECT_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_JOB_TIMINGS.rfo=FLN_RETRIEVE_JOB_TIMINGS
$	rfort FLN_RETRIEVE_JOB_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_JOB_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_JOB_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_JOB_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_JOB_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_JOB_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_JOB_TIMINGS
$ 	delete FLN_RETRIEVE_JOB_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_SESSION_TIMINGS.rfo=FLN_RETRIEVE_SESSION_TIMINGS
$	rfort FLN_RETRIEVE_SESSION_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_SESSION_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_SESSION_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_SESSION_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_SESSION_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_SESSION_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_SESSION_TIMINGS
$ 	delete FLN_RETRIEVE_SESSION_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_TASK_TIMINGS.rfo=FLN_RETRIEVE_TASK_TIMINGS
$	rfort FLN_RETRIEVE_TASK_TIMINGS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_TASK_TIMINGS
$ 	purge/nolog FLN_RETRIEVE_TASK_TIMINGS.obj
$ 	delete/nolog FLN_RETRIEVE_TASK_TIMINGS.for;*
$ 	delete/nolog FLN_RETRIEVE_TASK_TIMINGS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_TASK_TIMINGS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_TASK_TIMINGS
$ 	delete FLN_RETRIEVE_TASK_TIMINGS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_RESETS.rfo=FLN_RETRIEVE_RESETS
$	rfort FLN_RETRIEVE_RESETS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_RESETS
$ 	purge/nolog FLN_RETRIEVE_RESETS.obj
$ 	delete/nolog FLN_RETRIEVE_RESETS.for;*
$ 	delete/nolog FLN_RETRIEVE_RESETS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_RESETS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_RESETS
$ 	delete FLN_RETRIEVE_RESETS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_SESSION_PJE.rfo=FLN_RETRIEVE_SESSION_PJE
$	rfort FLN_RETRIEVE_SESSION_PJE
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_SESSION_PJE
$ 	purge/nolog FLN_RETRIEVE_SESSION_PJE.obj
$ 	delete/nolog FLN_RETRIEVE_SESSION_PJE.for;*
$ 	delete/nolog FLN_RETRIEVE_SESSION_PJE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_SESSION_PJE"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_SESSION_PJE
$ 	delete FLN_RETRIEVE_SESSION_PJE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_TASKS.rfo=FLN_RETRIEVE_TASKS
$	rfort FLN_RETRIEVE_TASKS
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_TASKS
$ 	purge/nolog FLN_RETRIEVE_TASKS.obj
$ 	delete/nolog FLN_RETRIEVE_TASKS.for;*
$ 	delete/nolog FLN_RETRIEVE_TASKS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_TASKS"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_TASKS
$ 	delete FLN_RETRIEVE_TASKS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_TASKS_JOB.rfo=FLN_RETRIEVE_TASKS_JOB
$	rfort FLN_RETRIEVE_TASKS_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_TASKS_JOB
$ 	purge/nolog FLN_RETRIEVE_TASKS_JOB.obj
$ 	delete/nolog FLN_RETRIEVE_TASKS_JOB.for;*
$ 	delete/nolog FLN_RETRIEVE_TASKS_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_TASKS_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_TASKS_JOB
$ 	delete FLN_RETRIEVE_TASKS_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_RETRIEVE_TASK_HIST_JOB.rfo=FLN_RETRIEVE_TASK_HIST_JOB
$	rfort FLN_RETRIEVE_TASK_HIST_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_RETRIEVE_TASK_HIST_JOB
$ 	purge/nolog FLN_RETRIEVE_TASK_HIST_JOB.obj
$ 	delete/nolog FLN_RETRIEVE_TASK_HIST_JOB.for;*
$ 	delete/nolog FLN_RETRIEVE_TASK_HIST_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_RETRIEVE_TASK_HIST_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_RETRIEVE_TASK_HIST_JOB
$ 	delete FLN_RETRIEVE_TASK_HIST_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SESS_COMPLETE.rfo=FLN_SESS_COMPLETE
$	rfort FLN_SESS_COMPLETE
$ 	ok=$status
$ 	if ok then pvv FLN_SESS_COMPLETE
$ 	purge/nolog FLN_SESS_COMPLETE.obj
$ 	delete/nolog FLN_SESS_COMPLETE.for;*
$ 	delete/nolog FLN_SESS_COMPLETE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SESS_COMPLETE"
$ 	delete adc.ide;*
$	if ok then libr FLN_SESS_COMPLETE
$ 	delete FLN_SESS_COMPLETE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SESS_CONTINUE.rfo=FLN_SESS_CONTINUE
$	rfort FLN_SESS_CONTINUE
$ 	ok=$status
$ 	if ok then pvv FLN_SESS_CONTINUE
$ 	purge/nolog FLN_SESS_CONTINUE.obj
$ 	delete/nolog FLN_SESS_CONTINUE.for;*
$ 	delete/nolog FLN_SESS_CONTINUE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SESS_CONTINUE"
$ 	delete adc.ide;*
$	if ok then libr FLN_SESS_CONTINUE
$ 	delete FLN_SESS_CONTINUE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SESS_ERROR.rfo=FLN_SESS_ERROR
$	rfort FLN_SESS_ERROR
$ 	ok=$status
$ 	if ok then pvv FLN_SESS_ERROR
$ 	purge/nolog FLN_SESS_ERROR.obj
$ 	delete/nolog FLN_SESS_ERROR.for;*
$ 	delete/nolog FLN_SESS_ERROR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SESS_ERROR"
$ 	delete adc.ide;*
$	if ok then libr FLN_SESS_ERROR
$ 	delete FLN_SESS_ERROR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SESS_OFFLINE.rfo=FLN_SESS_OFFLINE
$	rfort FLN_SESS_OFFLINE
$ 	ok=$status
$ 	if ok then pvv FLN_SESS_OFFLINE
$ 	purge/nolog FLN_SESS_OFFLINE.obj
$ 	delete/nolog FLN_SESS_OFFLINE.for;*
$ 	delete/nolog FLN_SESS_OFFLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SESS_OFFLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_SESS_OFFLINE
$ 	delete FLN_SESS_OFFLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SESS_RESTART.rfo=FLN_SESS_RESTART
$	rfort FLN_SESS_RESTART
$ 	ok=$status
$ 	if ok then pvv FLN_SESS_RESTART
$ 	purge/nolog FLN_SESS_RESTART.obj
$ 	delete/nolog FLN_SESS_RESTART.for;*
$ 	delete/nolog FLN_SESS_RESTART.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SESS_RESTART"
$ 	delete adc.ide;*
$	if ok then libr FLN_SESS_RESTART
$ 	delete FLN_SESS_RESTART.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SESS_SUBFLOWLINE.rfo=FLN_SESS_SUBFLOWLINE
$	rfort FLN_SESS_SUBFLOWLINE
$ 	ok=$status
$ 	if ok then pvv FLN_SESS_SUBFLOWLINE
$ 	purge/nolog FLN_SESS_SUBFLOWLINE.obj
$ 	delete/nolog FLN_SESS_SUBFLOWLINE.for;*
$ 	delete/nolog FLN_SESS_SUBFLOWLINE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SESS_SUBFLOWLINE"
$ 	delete adc.ide;*
$	if ok then libr FLN_SESS_SUBFLOWLINE
$ 	delete FLN_SESS_SUBFLOWLINE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_CURRENT.rfo=FLN_SET_CURRENT
$	rfort FLN_SET_CURRENT
$ 	ok=$status
$ 	if ok then pvv FLN_SET_CURRENT
$ 	purge/nolog FLN_SET_CURRENT.obj
$ 	delete/nolog FLN_SET_CURRENT.for;*
$ 	delete/nolog FLN_SET_CURRENT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_CURRENT"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_CURRENT
$ 	delete FLN_SET_CURRENT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_CURRENT_PJE.rfo=FLN_SET_CURRENT_PJE
$	rfort FLN_SET_CURRENT_PJE
$ 	ok=$status
$ 	if ok then pvv FLN_SET_CURRENT_PJE
$ 	purge/nolog FLN_SET_CURRENT_PJE.obj
$ 	delete/nolog FLN_SET_CURRENT_PJE.for;*
$ 	delete/nolog FLN_SET_CURRENT_PJE.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_CURRENT_PJE"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_CURRENT_PJE
$ 	delete FLN_SET_CURRENT_PJE.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_CURRENT_JOB.rfo=FLN_SET_CURRENT_JOB
$	rfort FLN_SET_CURRENT_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_SET_CURRENT_JOB
$ 	purge/nolog FLN_SET_CURRENT_JOB.obj
$ 	delete/nolog FLN_SET_CURRENT_JOB.for;*
$ 	delete/nolog FLN_SET_CURRENT_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_CURRENT_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_CURRENT_JOB
$ 	delete FLN_SET_CURRENT_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_CURRENT_PROJECT.rfo=FLN_SET_CURRENT_PROJECT
$	rfort FLN_SET_CURRENT_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_SET_CURRENT_PROJECT
$ 	purge/nolog FLN_SET_CURRENT_PROJECT.obj
$ 	delete/nolog FLN_SET_CURRENT_PROJECT.for;*
$ 	delete/nolog FLN_SET_CURRENT_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_CURRENT_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_CURRENT_PROJECT
$ 	delete FLN_SET_CURRENT_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_CURRENT_TASK.rfo=FLN_SET_CURRENT_TASK
$	rfort FLN_SET_CURRENT_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_SET_CURRENT_TASK
$ 	purge/nolog FLN_SET_CURRENT_TASK.obj
$ 	delete/nolog FLN_SET_CURRENT_TASK.for;*
$ 	delete/nolog FLN_SET_CURRENT_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_CURRENT_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_CURRENT_TASK
$ 	delete FLN_SET_CURRENT_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_GLOBALS.rfo=FLN_SET_GLOBALS
$	rfort FLN_SET_GLOBALS
$ 	ok=$status
$ 	if ok then pvv FLN_SET_GLOBALS
$ 	purge/nolog FLN_SET_GLOBALS.obj
$ 	delete/nolog FLN_SET_GLOBALS.for;*
$ 	delete/nolog FLN_SET_GLOBALS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_GLOBALS"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_GLOBALS
$ 	delete FLN_SET_GLOBALS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_WIRES.rfo=FLN_SET_WIRES
$	rfort FLN_SET_WIRES
$ 	ok=$status
$ 	if ok then pvv FLN_SET_WIRES
$ 	purge/nolog FLN_SET_WIRES.obj
$ 	delete/nolog FLN_SET_WIRES.for;*
$ 	delete/nolog FLN_SET_WIRES.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_WIRES"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_WIRES
$ 	delete FLN_SET_WIRES.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SETUP_TASKS.rfo=FLN_SETUP_TASKS
$	rfort FLN_SETUP_TASKS
$ 	ok=$status
$ 	if ok then pvv FLN_SETUP_TASKS
$ 	purge/nolog FLN_SETUP_TASKS.obj
$ 	delete/nolog FLN_SETUP_TASKS.for;*
$ 	delete/nolog FLN_SETUP_TASKS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SETUP_TASKS"
$ 	delete adc.ide;*
$	if ok then libr FLN_SETUP_TASKS
$ 	delete FLN_SETUP_TASKS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_JOB.rfo=FLN_SET_JOB
$	rfort FLN_SET_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_SET_JOB
$ 	purge/nolog FLN_SET_JOB.obj
$ 	delete/nolog FLN_SET_JOB.for;*
$ 	delete/nolog FLN_SET_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_JOB
$ 	delete FLN_SET_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_LOCALS.rfo=FLN_SET_LOCALS
$	rfort FLN_SET_LOCALS
$ 	ok=$status
$ 	if ok then pvv FLN_SET_LOCALS
$ 	purge/nolog FLN_SET_LOCALS.obj
$ 	delete/nolog FLN_SET_LOCALS.for;*
$ 	delete/nolog FLN_SET_LOCALS.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_LOCALS"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_LOCALS
$ 	delete FLN_SET_LOCALS.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_LOCALS_TR.rfo=FLN_SET_LOCALS_TR
$	rfort FLN_SET_LOCALS_TR
$ 	ok=$status
$ 	if ok then pvv FLN_SET_LOCALS_TR
$ 	purge/nolog FLN_SET_LOCALS_TR.obj
$ 	delete/nolog FLN_SET_LOCALS_TR.for;*
$ 	delete/nolog FLN_SET_LOCALS_TR.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_LOCALS_TR"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_LOCALS_TR
$ 	delete FLN_SET_LOCALS_TR.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_PROJECT.rfo=FLN_SET_PROJECT
$	rfort FLN_SET_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_SET_PROJECT
$ 	purge/nolog FLN_SET_PROJECT.obj
$ 	delete/nolog FLN_SET_PROJECT.for;*
$ 	delete/nolog FLN_SET_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_PROJECT
$ 	delete FLN_SET_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SET_TASK.rfo=FLN_SET_TASK
$	rfort FLN_SET_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_SET_TASK
$ 	purge/nolog FLN_SET_TASK.obj
$ 	delete/nolog FLN_SET_TASK.for;*
$ 	delete/nolog FLN_SET_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SET_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_SET_TASK
$ 	delete FLN_SET_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_SKIP_TASK.rfo=FLN_SKIP_TASK
$	rfort FLN_SKIP_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_SKIP_TASK
$ 	purge/nolog FLN_SKIP_TASK.obj
$ 	delete/nolog FLN_SKIP_TASK.for;*
$ 	delete/nolog FLN_SKIP_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_SKIP_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_SKIP_TASK
$ 	delete FLN_SKIP_TASK.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_START_JOB.rfo=FLN_START_JOB
$	rfort FLN_START_JOB
$ 	ok=$status
$ 	if ok then pvv FLN_START_JOB
$ 	purge/nolog FLN_START_JOB.obj
$ 	delete/nolog FLN_START_JOB.for;*
$ 	delete/nolog FLN_START_JOB.rfo;*
$	if .not.ok then emsg=emsg+" FLN_START_JOB"
$ 	delete adc.ide;*
$	if ok then libr FLN_START_JOB
$ 	delete FLN_START_JOB.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_START_PROJECT.rfo=FLN_START_PROJECT
$	rfort FLN_START_PROJECT
$ 	ok=$status
$ 	if ok then pvv FLN_START_PROJECT
$ 	purge/nolog FLN_START_PROJECT.obj
$ 	delete/nolog FLN_START_PROJECT.for;*
$ 	delete/nolog FLN_START_PROJECT.rfo;*
$	if .not.ok then emsg=emsg+" FLN_START_PROJECT"
$ 	delete adc.ide;*
$	if ok then libr FLN_START_PROJECT
$ 	delete FLN_START_PROJECT.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_START_SESSION.rfo=FLN_START_SESSION
$	rfort FLN_START_SESSION
$ 	ok=$status
$ 	if ok then pvv FLN_START_SESSION
$ 	purge/nolog FLN_START_SESSION.obj
$ 	delete/nolog FLN_START_SESSION.for;*
$ 	delete/nolog FLN_START_SESSION.rfo;*
$	if .not.ok then emsg=emsg+" FLN_START_SESSION"
$ 	delete adc.ide;*
$	if ok then libr FLN_START_SESSION
$ 	delete FLN_START_SESSION.obj;*
$	set noverify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_START_TASK.rfo=FLN_START_TASK
$	rfort FLN_START_TASK
$ 	ok=$status
$ 	if ok then pvv FLN_START_TASK
$ 	purge/nolog FLN_START_TASK.obj
$ 	delete/nolog FLN_START_TASK.for;*
$ 	delete/nolog FLN_START_TASK.rfo;*
$	if .not.ok then emsg=emsg+" FLN_START_TASK"
$ 	delete adc.ide;*
$	if ok then libr FLN_START_TASK
$ 	delete FLN_START_TASK.obj;*
$	set noverify
$	set noverify
$	if emsg.eqs."" then goto noerr
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	write sys$output "Compilation errors in:"
$	write sys$output emsg
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	noerr:
$ 	flowlineex:
$ 	deass/group lsl$flowline_building
$ 	set nover
