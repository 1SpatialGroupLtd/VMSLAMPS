$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-10-11 15:14:50.000000000 +0100
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
$!
$! Create: Build GCTPLIB common modules for Unix (WI/CC 1514)	TJM 1-Nov-1995
$! This file is probably completely pointless.			CCB 11-Oct-1996
$! It attempts to create source files like those on UNIX,
$! howver the results are still different, so why bother?
$!
$create projection.f
$append pj01$0.src,pj01$1.src,pj02$0.src,pj02$1.src projection.f
$append pj03$0.src,pj03$1.src,pj04$0.src,pj04$1.src projection.f
$append pj05$0.src,pj05$1.src,pj06$0.src,pj06$1.src projection.f
$append pj07$0.src,pj07$1.src,pj08$0.src,pj08$1.src projection.f
$append pj09$0.src,pj09$1.src,pj10$0.src,pj10$1.src projection.f
$append pj11$0.src,pj11$1.src,pj12$0.src,pj12$1.src projection.f
$append pj13$0.src,pj13$1.src,pj14$0.src,pj14$1.src projection.f
$append pj15$0.src,pj15$1.src,pj16$0.src,pj16$1.src projection.f
$append pj17$0.src,pj17$1.src,pj18$0.src,pj18$1.src projection.f
$append pj19$0.src,pj19$1.src,pj20$0.src,pj20$1.src projection.f
$append pj21$0.src,pj21$1.src,pj22$0.src,pj22$1.src projection.f
$append pj23$0.src,pj23$1.src,pj24$0.src,pj24$1.src projection.f
$append pj25$0.src,pj25$1.src,pj26$0.src,pj26$1.src projection.f
$append pj27$0.src,pj27$1.src,pj28$0.src,pj28$1.src projection.f
$append pj29$0.src,pj29$1.src,pj30$0.src,pj30$1.src projection.f
$append pj31$0.src,pj31$1.src                     projection.f
$append al01$0.src,al29$0.src                       projection.f
$append pj1a$0.src,pj1a$1.src                     projection.f
$!
$create proj_util.f
$append adjl$0.src,congeog.src,darsincos.src,dmsp$0.src  proj_util.f
$append e0fn$0.src,e1fn$0.src,e2fn$0.src,e3fn$0.src     proj_util.f
$append geogcon.src                              proj_util.f
$append mlfn$0.src,msfn$0.src,nu.src                proj_util.f
$append pakd$0.src,pakr$0.src,paks$0.src              proj_util.f
$append phi1$0.src,phi2$0.src,phi3$0.src,phi4$0.src     proj_util.f
$append qsfn$0.src,radd$0.src,rho.src               proj_util.f
$append tsfn$0.src,untf$0.src                       proj_util.f
$!
$create gtpblk.f
$append gtpblk.src                              gtpblk.f
$!
$create newt2d.f
$append newton2d.src                              newt2d.f
$!
