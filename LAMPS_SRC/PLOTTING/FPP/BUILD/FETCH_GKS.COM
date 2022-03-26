$! fetch the FPP things required to build a GKS shareable from CMS
$! P1 = name of GKS version e.g. POSTSCRIPT
$ sd lsl$fpp_root:[000000]
$ CMS
fetch/nolog gksshr.com /output=[com] ""
fetch/nolog gksshr.opt /output=[dev] ""
fetch/nolog gksvec.mar /output=[mar] ""
fetch/nolog gksdum.src /output=[src] ""
fetch/nolog fpp.com /output=[com] ""
$ CMS fetch/nolog fpp'p1'.opt,'p1'blk.src/output=[dev] ""
$ exit
