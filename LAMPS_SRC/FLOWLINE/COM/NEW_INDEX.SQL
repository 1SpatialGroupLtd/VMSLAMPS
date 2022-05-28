! some new indexes to speed things up
!
! get rid of WIRE_ACTIVE_INDEX, which used to include FLOWLINE_ID
drop index WIRE_ACTIVE_INDEX;
!
! rebuild the index without FLOWLINE_ID
create unique index WIRE_ACTIVE_INDEX on WIRE_ACTIVE (JOB_ID,WIRE_ID);
!
! add index for OUTCOME (not unique) - could possibly add OUTCOME_VALUE
! to the key also
create index OUTCOME_INDEX on OUTCOME (FLOWLINE_ID,ELEMENT_ID);
!
! add index for PARAMETER (not unique)
create index PARAMETER_INDEX on PARAMETER (PARAMETER_ID);
!
! add index for GLOBAL_PARAMETER (not unique)
create index GLOBAL_PARAMETER_INDEX on GLOBAL_PARAMETER (JOB_ID);
!
! add indexes for JOB and JOB_HISTORY to speed finding sub-jobs
create index JB_OT_INDEX on JOB (OUTER_TASK_ID);
create index JH_OT_INDEX on JOB_HISTORY (OUTER_TASK_ID);
!
