! add indexes to flowline database
! these are in the public root RDO file, but maybe not in the database
!
create index WIRE_END_INDEX on WIRE (WIRE_END);
create index JB_PR_INDEX on JOB (PROJECT_ID);
create index JB_FL_INDEX on JOB (FLOWLINE_ID);
create index JH_PR_INDEX on JOB_HISTORY (PROJECT_ID);
create index JH_FL_INDEX on JOB_HISTORY (FLOWLINE_ID);
create index EL_FL_INDEX on ELEMENT (FLOWLINE_ID);
create index EL_EL_INDEX on ELEMENT (ELEMENT_ID);
create index TA_JB_INDEX on TASK (JOB_ID);
create index TA_EL_INDEX on TASK (ELEMENT_ID);
create index TH_JB_INDEX on TASK_HISTORY (JOB_ID);
create index TH_EL_INDEX on TASK_HISTORY (ELEMENT_ID);
create index SE_TA_INDEX on SESSION (TASK_ID);
create index SH_TA_INDEX on SESSION_HISTORY (TASK_ID);
create index SH_WO_INDEX on SESSION_HISTORY (WORKSTATION_ID);
create index SH_OP_INDEX on SESSION_HISTORY (OPERATOR_ID);
