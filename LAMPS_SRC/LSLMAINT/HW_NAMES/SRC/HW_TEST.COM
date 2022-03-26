$! Diddy procedure to test hardware names list.
$! Created					PGH	5-Dec-1994
$ WRITE SYS$OUTPUT "... Creating test program"
$ CREATE HW_NAMES_TEST.FOR
	CHARACTER*100 NAME
	INTEGER NAME_LENGTH
	INTEGER	NUMBER
10	TYPE *,'Input a model number (0 to exit)'
	ACCEPT *,NUMBER
	IF (NUMBER.LE.0) CALL EXIT
	CALL HW_MODEL_TO_NAME(NUMBER,NAME,NAME_LENGTH)
	TYPE *,'Model Name is "',NAME(1:NAME_LENGTH),'"'
	GOTO 10
	END
$!	
$ WRITE SYS$OUTPUT "... Compiling test program and generated routine"
$ FORT  HW_NAMES_TEST+HW_MODEL_TO_NAME.SRC
$ WRITE SYS$OUTPUT "... Linking test program with generated routine"
$ LINK HW_NAMES_TEST
$ WRITE SYS$OUTPUT "... Running test program"
$ DEFINE/USER DBG$INPUT SYS$COMMAND
$ DEFINE/USER SYS$INPUT SYS$COMMAND
$ RUN HW_NAMES_TEST
$ WRITE SYS$OUTPUT "... Test program complete"
$ EXIT
