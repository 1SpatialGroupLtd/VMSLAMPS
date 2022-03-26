$	if p1.eqs."" then exit
$	define/user sys$input sys$command
$	nv 'p1'.src
$	@comp 'p1' 'p2'
$	@link
