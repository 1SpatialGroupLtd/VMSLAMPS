$! LSLDAEMON.COM - command procedure to start LSL idle process daemon (detached)
$! Note that LSLDAEMON expects a configuration file SYS$MANAGER:LSLDAEMON.CONFIG
$! containing time interval and number of warnings (default 20 mins,2 warnings).
$!
$ Run lsl$exe:LSLDAEMON -
/input=nl: /output=nl: /error=sys$manager:LSLDAEMON_error.log -
/maximum_working_set=256 /working_set=100 -
/privileges=(nosame,sysprv,world,oper,tmpmbx) -
/process_name="LSLDAEMON" /uic=[1,4] 
$ Exit
