These GCF files contain small areas digitised araound a number of
selected Ground Control Features. Typically this would comprise a
crossroads as the GCF, with two or three contour steps surrounding it.

A height was then estimated for the target poiunt in the GCF (the GCP)
by using the program GET_SECTIONS to create section-lines through the
GCP in 4 directions, and then using SHOW_SECTIONS to view this sections
superimposed in elevation and to select a height for the GCP which
seemed to satisfy all of these sections most naturally

See user-guides for GET_SECTIONS and SHOW_SECTIONS for further details.

*** Note that the work done by GET_SECTIONS could now be done using
I3D, as the INTERSECT-mode within I3D does exactly this - intersects 2D
features with contours in order to generate 3D features. 
