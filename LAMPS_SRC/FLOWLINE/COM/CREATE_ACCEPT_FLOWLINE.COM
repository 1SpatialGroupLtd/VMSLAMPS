$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-07-23 11:49:30.000000000 +0100
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
!
! file to create Acceptance test database flowline and load data
! created	MWSR		28-May-1988
! modified	CCB		23-July-1991
$ SET VERIFY
$ ASSIGN LSL$SITE_ROOT:[FLOWLINE.ACCEPT] LSL$FLN_DATABASE
$ @lsl$com:flowline_db_create
$ SET VERIFY
$ run sys$system:rdo
SET VERIFY
DATA FILE LSL$FLN_DATABASE:FLOWLINE
START_TRANSACTION READ_WRITE
!
! flowlines
STORE F IN FLOWLINE USING
   F.FLOWLINE_ID = "ACCEPT";
   F.START_ELEMENT = "START_ACCEPT";
   F.COMMAND_PROC  = "LSL$COM:ACCEPT_FLOWLINE.COM";
   F.END_ELEMENT   = "END_ACCEPT";
   F.PRIORITY = 4;
END_STORE
!
! elements for ACCEPT
STORE E IN ELEMENT USING
   E.ELEMENT_ID = "START_ACCEPT";
   E.FLOWLINE_ID = "ACCEPT";
   E.PRIORITY = 4;
   E.PROCEDURE_ID = "NO_PROCEDURE";
END_STORE
STORE E IN ELEMENT USING
   E.ELEMENT_ID = "PROCESS_1";
   E.FLOWLINE_ID = "ACCEPT";
   E.COMMAND_PROC = "LSL$COM:PROCESS_1.COM";
   E.CONDITIONS= "1";
   E.PRIORITY = 4;
   E.PROCEDURE_ID = "NO_PROCEDURE";
END_STORE
STORE E IN ELEMENT USING
   E.ELEMENT_ID = "PROCESS_2";
   E.FLOWLINE_ID = "ACCEPT";
   E.COMMAND_PROC = "LSL$COM:PROCESS_2.COM";
   E.CONDITIONS= "2";
   E.PRIORITY = 4;
   E.PROCEDURE_ID = "NO_PROCEDURE";
END_STORE
STORE E IN ELEMENT USING
   E.ELEMENT_ID = "PROCESS_3";
   E.FLOWLINE_ID = "ACCEPT";
   E.COMMAND_PROC = "LSL$COM:PROCESS_3.COM";
   E.CONDITIONS= "(3 AND 4) OR 6";
   E.PRIORITY = 4;
   E.PROCEDURE_ID = "NO_PROCEDURE";
END_STORE
STORE E IN ELEMENT USING
   E.ELEMENT_ID = "PROCESS_4";
   E.FLOWLINE_ID = "ACCEPT";
   E.COMMAND_PROC = "LSL$COM:PROCESS_4.COM";
   E.CONDITIONS= "1";
   E.PRIORITY = 4;
   E.PROCEDURE_ID = "NO_PROCEDURE";
END_STORE
STORE E IN ELEMENT USING
   E.ELEMENT_ID = "END_ACCEPT";
   E.FLOWLINE_ID = "ACCEPT";
   E.CONDITIONS= "7";
   E.PRIORITY = 4;
   E.PROCEDURE_ID = "NO_PROCEDURE";
END_STORE
!
! wires
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "1";
   W.WIRE_END = "PROCESS_1";
END_STORE
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "2";
   W.WIRE_END = "PROCESS_2";
END_STORE
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "3";
   W.WIRE_END = "PROCESS_3";
END_STORE
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "4";
   W.WIRE_END = "PROCESS_3";
END_STORE
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "5";
   W.WIRE_END = "PROCESS_4";
END_STORE
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "6";
   W.WIRE_END = "PROCESS_3";
END_STORE
STORE W IN WIRE USING
   W.FLOWLINE_ID = "ACCEPT";
   W.WIRE_ID = "7";
   W.WIRE_END = "END_ACCEPT";
END_STORE
!
! Outcome
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "START_ACCEPT";
   O.OUTCOME_VALUE = 1;
   O.WIRE_ID = "1";
END_STORE
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "START_ACCEPT";
   O.OUTCOME_VALUE = 1;
   O.WIRE_ID = "2";
END_STORE
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "PROCESS_1";
   O.OUTCOME_VALUE = 1;
   O.WIRE_ID = "3";
END_STORE
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "PROCESS_2";
   O.OUTCOME_VALUE = 1;
   O.WIRE_ID = "4";
END_STORE
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "PROCESS_3";
   O.OUTCOME_VALUE = 1;
   O.WIRE_ID = "5";
END_STORE
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "PROCESS_4";
   O.OUTCOME_VALUE = 1;
   O.WIRE_ID = "7";
END_STORE
STORE O IN OUTCOME USING
   O.FLOWLINE_ID = "ACCEPT";
   O.ELEMENT_ID = "PROCESS_4";
   O.OUTCOME_VALUE = 2;
   O.WIRE_ID = "6";
END_STORE
!
STORE P IN PROJECT USING 
   P.PROJECT_ID = "PROJECT_ACCEPT";
   P.COMMAND_PROC = "LSL$COM:PROJECT_ACCEPT.COM";
   P.PRIORITY = 4;
   P.INITIATOR_ID = "LSLSOFT";
   P.START_TIME = 4201965;
   P.START_DATE = 47300;
   P.PROJECT_STATUS = "Active";	
END_STORE
STORE P IN PROJECT USING 
   P.PROJECT_ID = "SOUTH_WALES";
   P.COMMAND_PROC = "LSL$COM:SOUTH_WALES.COM";
   P.PRIORITY = 4;
   P.INITIATOR_ID = "LSLSOFT";
   P.START_TIME = 4201965;
   P.START_DATE = 47300;
   P.PROJECT_STATUS = "Active";	
END_STORE
STORE P IN PROJECT USING 
   P.PROJECT_ID = "SHETLAND";
   P.COMMAND_PROC = "LSL$COM:SHETLAND.COM";
   P.PRIORITY = 4;
   P.INITIATOR_ID = "LSLSOFT";
   P.START_TIME = 4201300;
   P.START_DATE = 47303;
   P.PROJECT_STATUS = "Active";	
END_STORE
STORE J IN JOB USING 
   J.PROJECT_ID = "PROJECT_ACCEPT";
   J.FLOWLINE_ID = "ACCEPT";
   J.JOB_ID =   100000;
   J.JOB_NAME = "LONDON";
   J.START_TIME = 4301965; 
   J.START_DATE = 47300;
   J.JOB_STATUS = "Active";
   J.COMMAND_PROC = "LSL$COM:LONDON_JOB.COM";
   J.OUTER_TASK_ID = 0;
   J.PRIORITY = 4;
   J.INITIATOR_ID ="LSLSOFT";
END_STORE
STORE J IN JOB USING 
   J.PROJECT_ID = "SHETLAND";
   J.FLOWLINE_ID = "ACCEPT";
   J.JOB_ID =   100001;
   J.JOB_NAME = "SULLOM_VOE";
   J.START_TIME = 4301993; 
   J.START_DATE = 47301;
   J.JOB_STATUS = "Held";
   J.COMMAND_PROC = "LSL$COM:SULLOM_VOE.COM";
   J.OUTER_TASK_ID = 0;
   J.PRIORITY = 4;
   J.INITIATOR_ID ="LSLSOFT";
END_STORE
STORE T IN TASK USING
   T.TASK_ID = 100000;
   T.JOB_ID = 100001;
   T.ELEMENT_ID = "PROCESS_3";
   T.PROGRESS_STATUS = "Not Started";
   T.TASK_STATUS = "Inactive";
END_STORE
COMMIT
EXIT
$ SET NOVERIFY
