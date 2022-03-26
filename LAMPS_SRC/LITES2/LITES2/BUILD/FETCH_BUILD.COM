$! fetch enough LITES2 sources from the CMS to link an image,
$! assuming that you already have the .OLBs
$ CMS
fetch llites2.com/output=com: ""
fetch lites2tr.mar/output=exe: ""
fetch lites2motif.lnk/output=com: ""
exit
$!
