$	SAVVER:='F$VERIFY(0)
$	CMDLINE=P1+P2+P3-"/CO"
$	OUT=F$ELEMENT(0,"=",CMDLINE)
$	IN=F$ELEMENT(1,"=",CMDLINE)
$	IF F$LOCATE(".",IN).EQ.F$LEN(IN) THEN IN=IN+".SRC"
$	IF F$LOCATE(".",OUT).EQ.F$LEN(OUT) THEN OUT=OUT+".FOR"
$	EDIT/EDT/OUT='OUT' 'IN'/COMMAND=SYS$INPUT:
DEL ALL '***'
EXIT
$	CREATE ADC.IDE
$	IF SAVVER THEN SET VERIFY