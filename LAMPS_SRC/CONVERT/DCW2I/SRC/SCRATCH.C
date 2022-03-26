
#ifdef TRACE
/*************************************************************************
 *
 *N  trace_polygon_loop
 *
 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 *
 *   Purpose:
 *P
 *     This function traces a loop (or ring) of a polygon by chaining
 *     through the right and/or left edges of the edge table, including
 *     tracing through all dangles.  This is winged-edge topology in action.
 *E
 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 *
 *   Parameters:
 *A
 *     face_id    <input>==(long int) row id of the specified face.
 *     start_edge <input>==(long int) row id of the edge that starts the
 *                         loop.
 *     edgetable  <input>==(vpf_table_type) VPF edge primitive table.
 *E
 *::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 *
 *   History:
 *H
 *    Barry Michaels   May 1991                           DOS Turbo C
 *E
 *************************************************************************/
void trace_polygon_loop(long int face_id,
			long int start_edge,
			vpf_table_type edgetable )
{
  edge_rec_type edge_rec;
  long int next, prevnode;
  boolean done=FALSE;
  IPoint make_ipoint();

  edge_rec = read_edge( start_edge, edgetable );

#ifdef WATCH
   gotoxy(1,17);
   printf("edge: %5ld  left: %5ld  edge:%5ld  right: %5ld  edge: %5ld",
	  edge_rec.id,edge_rec.left,edge_rec.leftfwd,edge_rec.right,
	  edge_rec.rightfwd);
#endif
#ifdef STEP
   getch();
#endif

  edge_rec.dir = '+';

  prevnode = edge_rec.start;

  if (edge_rec.start != edge_rec.end) {

     if ( (edge_rec.right == face_id) && (edge_rec.left == face_id) ) {
	/* Dangle */
	if (prevnode == edge_rec.start) {
	   edge_rec.dir = '+';
	   next = edge_rec.rightfwd;
	   prevnode = edge_rec.end;
	} else if (prevnode == edge_rec.end) {
	   edge_rec.dir = '-';
	   next = edge_rec.leftfwd;
	   prevnode = edge_rec.start;
	} else next = -1;
     } else if (edge_rec.right == face_id) {
	next = edge_rec.rightfwd;
	edge_rec.dir = '+';
	prevnode = edge_rec.end;
     } else if (edge_rec.left == face_id) {
	next = edge_rec.leftfwd;
	edge_rec.dir = '-';
	prevnode = edge_rec.start;
     } else next = -1;

  } else {

     done = TRUE;

  }

  draw_polygon_edge( edge_rec );

  if (edge_rec.coord) free(edge_rec.coord);

  while (!done) {

     if (next < 0) {
#ifdef WATCH
	gotoxy(1,18);
	printf(" Aaargh(r)! Edge: %ld   face: %ld   left: %ld   right: %ld",
		edge_rec.id,face_id,edge_rec.left,edge_rec.right);
	getch();
	gotoxy(1,18);
	printf("                                                                                ");
#endif
	done = TRUE;
     }

     if (next==0) {
#ifdef WATCH
	gotoxy(1,19);
	printf("Next edge(%d) = 0  ",edge_rec.id);
#endif
	done = TRUE;
     }

     if (next == start_edge) done = TRUE;

     if (!done) {

	edge_rec = read_edge( next, edgetable );

#ifdef WATCH
	gotoxy(1,17);
	printf("edge: %5ld  left: %5ld  edge:%5ld  right: %5ld  edge: %5ld",
	       next,edge_rec.left,edge_rec.leftfwd,edge_rec.right,
	       edge_rec.rightfwd);
	gotoxy(1,18);
	printf("node: %5ld  start: %5ld  end: %5ld",
	prevnode,edge_rec.start,edge_rec.end);
#endif
#ifdef STEP
	getch();
#endif

	if ( (edge_rec.right == face_id) && (edge_rec.left == face_id) ) {
	   /* Dangle */
	   if (prevnode == edge_rec.start) {
	      edge_rec.dir = '+';
	      next = edge_rec.rightfwd;
	      prevnode = edge_rec.end;
	   } else if (prevnode == edge_rec.end) {
	      edge_rec.dir = '-';
	      next = edge_rec.leftfwd;
	      prevnode = edge_rec.start;
	   } else next = -1;
	} else if (edge_rec.right == face_id) {
	   edge_rec.dir = '+';
	   next = edge_rec.rightfwd;
	   prevnode = edge_rec.end;
	} else if (edge_rec.left == face_id) {
	   edge_rec.dir = '-';
	   next = edge_rec.leftfwd;
	   prevnode = edge_rec.start;
	} else next = -1;

	draw_polygon_edge( edge_rec );
	if (edge_rec.coord) free(edge_rec.coord);

     }
  }

}
#endif
