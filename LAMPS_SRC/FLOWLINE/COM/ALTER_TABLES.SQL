! amend a flowline database to agree with lastest definition
! once this is done, the new LAMPSCONTROL must be used
!
! the new LAMPSCONTROL will not mind this not being done, but
! might be less efficient
!
! this column was never used
alter table TASK_HISTORY drop column PRIORITY;
!
! this column was never used
alter table TASK drop column OUTCOME_VALUE;
!
! get rid of WIRE_ACTIVE_INDEX while we alter the table
drop index WIRE_ACTIVE_INDEX;
!
! drop FLOWLINE_ID column - this was used before, but was not needed
alter table WIRE_ACTIVE drop column FLOWLINE_ID;
!
! rebuild the index without the column (worked better without it
! even when the column was present)
create unique index WIRE_ACTIVE_INDEX on WIRE_ACTIVE (JOB_ID,WIRE_ID);
!
