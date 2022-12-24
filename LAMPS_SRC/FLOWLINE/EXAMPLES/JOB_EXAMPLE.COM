$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-07 09:57:46.000000000 +0100
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
$!                   Job command file
$!                   ~~~~~~~~~~~~~~~~
$!
$!
$!      created by MARTINR on  7-OCT-1988 09:56
$!      for job EXAMPLE
$!
$ dfad_file == "RES_EXAMPLE"
$ fln_map_scale == "50000"
$ fln_zone == "37"
$!
$! ........................................................
$!
$ assign /nolog lsl$data_root:[flowline.dfad.cmd],lsl$site_root:[lites2.cmd] lsl$lites2cmd
$!
$! ........................................................
$!
$!
$ assign /nolog lsl$site_root:[flowline.general.work] LSL$FLN_WORK
$!
$! ........................................................
$!
$ assign /nolog lsl$data_root:[flowline.dfad.fadt] lsl$fadt
$! ........................................................
$!
$ assign /nolog lsl$data_root:[flowline.dfad.iff] lsl$if
$! ........................................................
$!
$ assign /nolog lsl$data_root:[flowline.dfad.patch] lsl$lk
$! ........................................................
$ skip:
$!
$ dfad_frt == "LSL$FRT:DFAD.FRT"
$ dfadfid_frt == "LSL$FRT:DFADFID.FRT"
$ dfad_lpatch == "LSL$LK:DFAD_LINE.PATCH"
$ dfad_apatch == "LSL$LK:DFAD_AREA.PATCH"
$ dfad_sri == "LSL$FRT:DFAD.SRI"
$ dfad_tri == "LSL$FRT:DFAD.TRI"
$ dfad_fcp == "LSL$IF:DFAD.FCP"
$ dfad_lcp == "LSL$IF:DFAD.LCP"
$ dfad_lites2cmd == "LSL$LITES2CMD:DFAD.LCM"
$ dfad_blind_lites2cmd == "LSL$LITES2CMD:BLIND_DFAD.LCM"
$ dfad_rule  == "LSL$DFAD_RULE:VALTAB.RULE"
$!
$! set up the rest explicitly for now
$!
$ plotter == "lsl$benson"
$!
$ orig_la == 1080000
$ orig_lo == 1440000
$ sw_la  == 1116000
$ sw_lo  == 1476000
$ ext_la  == 36000
$ ext_lo  == 36000
$!
$ fln_nw_control_x == "0"
$ fln_nw_control_y == "500"
$ fln_sw_control_x == "0"
$ fln_sw_control_y == "0"
$ fln_se_control_x == "500"
$ fln_se_control_y == "0"
$ fln_ne_control_x == "500"
$ fln_ne_control_y == "500"
$ TAPE_DEV="MSA0:"
$!
$! Prefix for all DFAD filenames
$!
$	DFAD_PREFIX == "DFAD_"
$!
$! Prefixes and suffixes for point, line, area and combined IFF files
$!
$	DF_RAW_PLA_SUFFIX == "_RAW"
$!
$	DF_AREA_PREFIX == "LSL$IF:"
$	DF_AREA_SUFFIX == ".AREA"
$!
$	DF_LINE_PREFIX == "LSL$IF:"
$	DF_LINE_SUFFIX == ".LINE"
$!
$	DF_POINT_PREFIX == "LSL$IF:"
$	DF_POINT_SUFFIX == ".POINT"
$!
$	DF_PLA_PREFIX =="LSL$IF:"
$	DF_PLA_SUFFIX == ".PLA"
$!
$	DF_PLA_EDIT_PREFIX =="LSL$IF:"
$	DF_PLA_EDIT_SUFFIX == "_PLA.EDIT"
$!
$! Prefix, suffix for checked combined IFF file
$!
$	DF_CHECK_PREFIX == "LSL$IF:"
$	DF_CHECK_SUFFIX == ".CHECK"
$!
$! Infix for processed IFF files (LAPROCESS,MERGE etc)
$!
$	DFAD_PROC == "_PROC"
$!
$! Suffix for the LITES2 command file produced by ICHECK
$!
$	DF_LCM_PREFIX == "LSL$LITES2CMD:"
$	DF_LCM_SUFFIX == ".LCM"
$	DFAD_ICHECK_LCM_SUFFIX == "_ICHECK.LCM"
$!
$! Prefix, suffix for edited combined IFF file
$!
$	DF_EDIT_PREFIX == "LSL$IF:"
$	DF_EDIT_SUFFIX == ".EDIT"
$!
$! Finished geometry file
$!
$	DF_GEOMETRY_PREFIX == "LSL$IF:"
$	DF_GEOMETRY_SUFFIX == ".GEO"
$!
$! Prefix, suffix for FADT file and associated list file
$!
$	DF_FADT_PREFIX == "LSL$FADT:"
$	DF_FADT_SUFFIX == ".FADT"
$!
$	DF_FADT_NEW_SUFFIX == "_NEW.FADT"
$	DF_FADT_EDIT_SUFFIX == "_EDIT.FADT"
$!
$	DF_FADT_LIST_PREFIX == "LSL$FLN_WORK:"
$	DF_FADT_LIST_SUFFIX == "_FADT.LIS"
$!
$! Prefix, suffix for merged FADT/IFF file i.e. DFAD IFF file
$!
$	DF_MERGE_PREFIX == "LSL$IF:"
$	DF_MERGE_SUFFIX == ".MERGE"
$!
$	DF_MERGE_LIST_PREFIX == "LSL$FLN_WORK:"
$	DF_MERGE_LIST_SUFFIX == "_MERGE.LIS"
$!
$! Prefix, suffix for DFAD/IFF (+ list and lcm) after first validation
$!
$	DF_VAL_PREFIX == "LSL$IF:"
$	DF_VAL_SUFFIX == ".VAL"
$!
$	DF_VAL_LCM_PREFIX == "LSL$LITES2CMD:"
$	DF_VAL_LCM_SUFFIX == "_VAL.LCM"
$!
$	DF_VAL_LIST_PREFIX == "LSL$FLN_WORK:"
$	DF_VAL_LIST_SUFFIX == "_VAL.LIS"
$!
$! Suffix for Lites2 command file from IWINDOW
$!
$	DF_IWINDOW_LCM_SUFFIX == "_IWINDOW.LCM"
$!
$! Prefix, suffix for DFAD/IFF after clipping
$!
$	DF_CLIP_PREFIX == "LSL$IF:"
$	DF_CLIP_SUFFIX == ".CLIP"
$!
$! Prefix, suffix for DFAD/IFF after addition of hierarchy & acc regions
$!
$	DF_ACCREG_PREFIX == "LSL$IF:"
$	DF_ACCREG_SUFFIX == ".ACCREG"
$!
$! Prefix, suffix for DFAD/IFF after final sort
$!
$	DF_SORT_PREFIX == "LSL$IF:"
$	DF_SORT_SUFFIX == "_FIN.SORT"
$!
$! Prefix, suffix for DFAD/IFF after tidying
$!
$	DF_TIDY_PREFIX == "LSL$IF:"
$	DF_TIDY_SUFFIX == ".TIDY"
$!
$! Prefix, suffix for IFF file during and after final element
$!
$	DF_FIN_EDIT_PREFIX == "LSL$IF:"
$	DF_FIN_EDIT_SUFFIX == "_FINAL.EDIT"
$!
$! Prefix, suffix for DFAD/IFF (+ list and lcm) after final validation
$!
$	DF_FINAL_PREFIX == "LSL$IF:"
$	DF_FINAL_SUFFIX == ".FINAL"
$!
$	DF_FINAL_LIST_PREFIX == "LSL$FLN_WORK:"
$	DF_FINAL_LIST_SUFFIX == "_FINAL.LIS"
$!
$	DF_WORK_PREFIX == "LSL$FLN_WORK:"
$!
$	DF_FINAL_LCM_PREFIX == "LSL$LITES2CMD:"
$	DF_FINAL_LCM_SUFFIX == "_FINAL.LCM"
$!
$! Prefix, suffix for verification DFAD/IFF read back from tape
$!
$	DF_VER_PREFIX == "LSL$IF:"  
$	DF_VER_SUFFIX == "_VER"
$!
$! Prefix, suffix for validation rule file
$!
$	DF_RULE_PREFIX == "LSL$DFAD_RULE:"
$	DF_RULE_SUFFIX == ".RULE"
$!
$! Prefix, suffix for FRT file used in Lites2 editing
$!
$	DF_FRT_PREFIX == "LSL$FRT:"
$	DF_FRT_SUFFIX == ".FRT"
$!
$! Backup list pre / suf 
$!
$ 	DF_LIST_PREFIX == "lsl$fln_work:"
$	DF_backup_LIST_SUFFIX == "_back.list"
$!
$	DF_JOB_PREFIX == "lsl$fln_dfad_job:"
$	DF_JOB_SUFFIX == "_job.com"
$!
$! Finally set up the pointers to where files should be deleted 
$! from at the end of each job
$!
$	DELETE_PREFIX1 == "LSL$LITES2CMD:"
$	DELETE_PREFIX2 == "LSL$FADT:"
$	DELETE_PREFIX3 == "LSL$IF:"
$	NUM_DEL == 3
$!
