WireWrap
====

Wirewrap is a code generator for the 'Wirewrap machine' which we used
to automatically wire up the HRD and Fastrack backplanes. It was
pneumatically driven and positioned and activated a wire wrap gun. It
was driven by an EIA274 code, just like many of the paper and film
plotters of the day. The original programme ran on Titan/Atlas and
used a travelling salesman style algorithm. After I lost access to
Titan/Atlas we needed a version that ran on PDP's.

Peter W.


My involvement with wire wrap was writing WE, the Wirewrap Editor in
BCPL in 1976. It was the second major program I wrote at Laser-Scan
(after some diagnostics for Sweepnik to run on the PDP-15) and my
first on the new PDP-11/45. It provided a human interface for defining
the connectivity of the HRD-1 backplane, which had 10,000 pins, and
10,000 wires. It didn't do the scheduling - that was another program
written by Robin Fairbairns (recently deceased). I remember the
scheduling had various constraints on maximum number of wires on any
pin (three), and on maximum wire length for a single wire, so wasn't a
straightforward optimisation algorithm.

Later on we outsourced the backplane wrapping and its associated
scheduling, so I modified WE to output the data format for that
(company began with a V?).

I think I still have the sources of WE on paper tape in my loft, but
as it predated the VAX, it isn't in the current digital archive.

Paul Hardy (June 2022)
