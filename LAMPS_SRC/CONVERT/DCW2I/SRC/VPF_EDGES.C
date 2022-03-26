/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    S.Townrow, 26-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*                        V P F _ E D G E S                      	*/
/*									*/
/* Part of DCW2I which holds the edge lists which make up area features */
/*									*/
/************************************************************************/

#module	VPF_EDGES "21JL93"

/*----------------------------------------------------------------------*/
/*	Include definitions						*/
/*----------------------------------------------------------------------*/
#include <stat.h>
#include <stdio.h>
#include <string.h>
#include "mespar.h"
#include "vpf_table.h"
#include "vpf_edges.h"
#include "dcw2imsg.h"

extern coordinate_type orig;
coordinate_type first_pt;
edge_ptr edge_head = NULL;
edge_ptr edge_tail = NULL;
check_ptr check_head = NULL;
check_ptr check_tail = NULL;


/*----------------------------------------------------------------------*/
/* VOID store_edge_info							*/
/*......................................................................*/
/*									*/
/* Store information about an edge					*/
/*----------------------------------------------------------------------*/
void store_edge_info(coordinate_type *coordptr,
		     int num)
{
  edge_ptr edge_entry;

  edge_entry = (edge_ptr)vpfmalloc(sizeof(edge_element));
  edge_entry->st_ptr = coordptr;
  edge_entry->end_ptr = NULL;
  edge_entry->reverse = 0;
  edge_entry->npts = num;
  edge_entry->next = NULL;

  if (edge_tail!=NULL) {
    edge_tail->next = edge_entry;
    edge_tail = edge_entry;
  }
  if (edge_head==NULL) {
    edge_head = edge_entry;
    edge_tail = edge_entry;
  }
}



/*----------------------------------------------------------------------*/
/* VOID remove_last_edge_info						*/
/*......................................................................*/
/*									*/
/* Remove the last edge - it was a dangling line.			*/
/*----------------------------------------------------------------------*/
void remove_last_edge_info(void)
{
  edge_ptr tmp,prev;

  tmp = edge_head;
  prev = tmp;
  if (edge_head==NULL) return;
  if (edge_head==edge_tail) { /* one item in list */
    if (tmp->next!=NULL) free(tmp->next);
    if (tmp->st_ptr!=NULL) free(tmp->st_ptr);
    free(tmp);
    edge_head = NULL;
    edge_tail = NULL;
  }
  while (tmp!=edge_tail && tmp->next!=NULL) {
    prev = tmp;
    tmp = tmp->next;
  }
  if (prev!=NULL) {
    prev->next = NULL;
    edge_tail = prev;
    if (tmp->next!=NULL) free(tmp->next);
    if (tmp->st_ptr!=NULL) free(tmp->st_ptr);
    free(tmp);
  }
}



/*----------------------------------------------------------------------*/
/* void find_reverses							*/
/*......................................................................*/
/* Flag those edges which must be reversed when output.			*/
/*----------------------------------------------------------------------*/
void find_reverses(void)
{
  edge_ptr tmp;
  int coords_equal();
  coordinate_type *cptr;
  coordinate_type st1,end1;
  coordinate_type st2,end2;
  int i;

  tmp = edge_head;
  while (tmp!=NULL) {
    cptr = tmp->st_ptr;
    for (i=0;i<tmp->npts-1;i++) cptr++;
    tmp->end_ptr = cptr;
    tmp = tmp->next;
  }

  tmp = edge_head;
  st1  = *tmp->st_ptr;
  end1 = *tmp->end_ptr;
  st2  = *tmp->next->st_ptr;
  end2 = *tmp->next->end_ptr;
  /* used to be like this. Didn't cope with are in tile HYML21 */
  /*  if (coords_equal(st1,st2) || coords_equal(st1,end2)) {   */

  if (coords_equal(st1,st2) ||
     (coords_equal(st1,end2) && !coords_equal(st2,end1))) {
    tmp->reverse=1;
    st1  = *tmp->end_ptr;
    end1 = *tmp->st_ptr;
  }
  if (coords_equal(end2,end1)) tmp->next->reverse=1;

  tmp=tmp->next;
  while (tmp->next!=NULL) {
    if (tmp->reverse) {
      st1  = *tmp->end_ptr;
      end1 = *tmp->st_ptr;
    }
    else {
      st1  = *tmp->st_ptr;
      end1 = *tmp->end_ptr;
    }
    st2  = *tmp->next->st_ptr;
    end2 = *tmp->next->end_ptr;
    if (coords_equal(end2,end1)) tmp->next->reverse=1;
    tmp = tmp->next;
  }
}



/*----------------------------------------------------------------------*/
/* INT xcoords_equal							*/
/*......................................................................*/
/*									*/
/* Determine whether xcoords are equal					*/
/*----------------------------------------------------------------------*/
int xcoords_equal(coordinate_type a,
		  coordinate_type b)
{
  double dx;
  /* there is no 'abs' for floats in the VAX C RTL - so do it ourselves */
  dx = a.x-b.x;  dx = dx*dx;  dx = sqrt(dx);
  return (dx<0.000001);
}


/*----------------------------------------------------------------------*/
/* INT ycoords_equal							*/
/*......................................................................*/
/*									*/
/* Determine whether ycoords are equal					*/
/*----------------------------------------------------------------------*/
int ycoords_equal(coordinate_type a,
		  coordinate_type b)
{
  double dy;
  /* there is no 'abs' for floats in the VAX C RTL - so do it ourselves */
  dy = a.y-b.y;  dy = dy*dy;  dy = sqrt(dy);
  return (dy<0.000001);
}


/*----------------------------------------------------------------------*/
/* INT coords_equal							*/
/*......................................................................*/
/*									*/
/* Determine whether both x and y coords are equal			*/
/*----------------------------------------------------------------------*/
int coords_equal(coordinate_type a,
		 coordinate_type b)
{
  int xcoords_equal();
  int ycoords_equal();
  return (xcoords_equal(a,b) && ycoords_equal(a,b));
}



/*----------------------------------------------------------------------*/
/* VOID write_area_coords						*/
/*......................................................................*/
/*									*/
/* Write out all the edges making the perimeter or hole of the current	*/
/* area feature.							*/
/*----------------------------------------------------------------------*/
void write_area_coords(int num_edges,
		       int outer_ring)
{
  int j,k;
  short iends;
  short ptr;
  coordinate_type stbuf[200];
  coordinate_type start;
  void update_range();
  edge_ptr tmp;
  int xcoords_equal();
  int ycoords_equal();
  int coords_equal();
  coordinate_type *cptr;

  iends=0;
  tmp = edge_head;
  if (outer_ring) {
    if (tmp->reverse) {
      cptr = tmp->end_ptr;
    }
    else {
      cptr = tmp->st_ptr;
    }
    first_pt = *cptr;
    first_pt.x = first_pt.x - orig.x;
    first_pt.y = first_pt.y - orig.y;
    update_range(&first_pt);
  }
  ptr=0;
  for (k=0;k<num_edges;k++) {
    if (tmp->reverse) {
      cptr = tmp->end_ptr;
    }
    else {
      cptr = tmp->st_ptr;
    }
    for (j=0;j<tmp->npts;j++) {
      if (j>0 || k==0) {  /* don't store first point - it is same as the */
	                  /* one in the previous edge */
	stbuf[ptr] = *cptr;
	stbuf[ptr].x = stbuf[ptr].x - orig.x;
	stbuf[ptr].y = stbuf[ptr].y - orig.y;
	if (ptr>1) {
	  if ((xcoords_equal(stbuf[ptr-2],stbuf[ptr]) &&
	       xcoords_equal(stbuf[ptr-1],stbuf[ptr])) ||
	      (ycoords_equal(stbuf[ptr-2],stbuf[ptr]) &&
	       ycoords_equal(stbuf[ptr-1],stbuf[ptr]))) {
	    stbuf[ptr-1] = stbuf[ptr];		/* remove points in a */
	    					/* straight line */
	    update_range(&stbuf[ptr-1]);
	  }
	  else {
	    update_range(&stbuf[ptr]);
	    ptr++;
	  }
	}
	else {
	  update_range(&stbuf[ptr]);
	  ptr++;
	}
      }
      if (tmp->reverse) {
	cptr--;
      }
      else {
	cptr++;
      }
      if (ptr>0 && ((ptr % 200) == 0)) {	/* write a full ST entry */
	IFFST(&stbuf,&ptr,&iends);
	iends = 1;
	ptr = 0;
      }
    }
    if (!outer_ring && k==num_edges-1) {	/* consider a hole */
       IFFST(&stbuf,&ptr,&iends);
       stbuf[0]=first_pt;
       ptr = 1;
       iends = 0;
       IFFST(&stbuf,&ptr,&iends);
       ptr = 0;
     }
    tmp=tmp->next;
  }
  if (ptr>0 && ((ptr % 200) != 0)) {
    if (outer_ring) {
      IFFST(&stbuf,&ptr,&iends);
    }
    else {
      IFFST(&stbuf,&ptr,&iends);
      stbuf[0]=first_pt;
      ptr = 1;
      iends = 0;
      IFFST(&stbuf,&ptr,&iends);
    }
  }
}




/*----------------------------------------------------------------------*/
/* VOID show_edge_info							*/
/*......................................................................*/
/*									*/
/* Show information from edge list relating to one area feature		*/
/*----------------------------------------------------------------------*/
void show_edge_info(void)
{
  edge_ptr tmp;

  tmp = edge_head;

  while (tmp!=NULL) {
    printf("%d %d %d\n",tmp->st_ptr,
	                tmp->reverse,
	                tmp->npts);
    tmp = tmp->next;
  }
}



/*----------------------------------------------------------------------*/
/* INT num_area_points_ok						*/
/*......................................................................*/
/*									*/
/* Check the number of opint in the current edge list			*/
/*----------------------------------------------------------------------*/
int num_area_points_ok(int min_pts,
		       int max_pts)
{
  edge_ptr tmp;
  int n;

  n=0;
  tmp=edge_head;
  while (tmp!=NULL) {
    n = n + tmp->npts;
    tmp = tmp->next;
  }
  if (n<min_pts) {
    lsl_putmsg(&DCW2I__NUMPTS,&"few\0");
    return 0;
  }
  if (n>max_pts) {
    lsl_putmsg(&DCW2I__NUMPTS,&"many\0");
    return 0;
  }
  return 1;
}




/*----------------------------------------------------------------------*/
/* VOID free_edge_table							*/
/*......................................................................*/
/*									*/
/* Free all the entries in the table					*/
/*----------------------------------------------------------------------*/
void free_edge_table(void)
{
  edge_ptr tmp,n;

  tmp=edge_head;

  while (tmp!=NULL) {
    n = tmp->next;
    if (tmp->next!=NULL) free(tmp->next);
    free(tmp);
    tmp = n;
  }
  edge_head = NULL;
  edge_tail = NULL;
}




/*----------------------------------------------------------------------*/
/* VOID add_to_check_list						*/
/*......................................................................*/
/*									*/
/* Store each edge in the perimeter of an area feature so that can	*/
/* check if the edge is used again when doing the holes. 		*/
/*----------------------------------------------------------------------*/
void add_to_check_list(int edgenum)
{
  check_ptr check_entry;

  check_entry = (check_ptr)vpfmalloc(sizeof(check_element));
  check_entry->edge = edgenum;
  check_entry->next = NULL;

  if (check_tail!=NULL) {
    check_tail->next = check_entry;
    check_tail = check_entry;
  }
  if (check_head==NULL) {
    check_head = check_entry;
    check_tail = check_entry;
  }
}



/*----------------------------------------------------------------------*/
/* INT edge_in_check_list						*/
/*......................................................................*/
/*									*/
/* Search check list to see if it contains given edge			*/
/*----------------------------------------------------------------------*/
int edge_in_check_list(int edgenum)
{
  check_ptr tmp;

  tmp = check_head;

  while (tmp!=NULL) {
    if (tmp->edge==edgenum) return TRUE;
    tmp = tmp->next;
  }
  return FALSE;
}




/*----------------------------------------------------------------------*/
/* VOID show_check_list							*/
/*......................................................................*/
/*									*/
/* Show information from check list					*/
/*----------------------------------------------------------------------*/
void show_check_list(void)
{
  check_ptr tmp;

  tmp = check_head;

  while (tmp!=NULL) {
    printf("%d\n",tmp->edge);
    tmp = tmp->next;
  }
}




/*----------------------------------------------------------------------*/
/* void remove_edge_from_check_list					*/
/*......................................................................*/
/*									*/
/* Removes the given edge from the check list				*/
/*----------------------------------------------------------------------*/
void remove_edge_from_check_list(int edgenum)
{
  check_ptr tmp,prev,nxt;

  tmp = check_head;
  prev = tmp;

  if (check_head==NULL) return;
  if (check_head==check_tail) { /* one item in list */
    if (tmp->next!=NULL) free(tmp->next);
    free(tmp);
    check_head = NULL;
    check_tail = NULL;
  }
  while (tmp!=NULL) {
    if (tmp->edge==edgenum) {    /* found it, so remove it */
      if (tmp==check_head) {
	check_head=tmp->next;
	prev=check_head;
	nxt=tmp->next;
	if (tmp->next!=NULL) free(tmp->next);
	free(tmp);
	tmp=nxt;
      }
      else {
	if (tmp==check_tail) check_tail=prev;
	prev->next=tmp->next;
	if (tmp->next!=NULL) free(tmp->next);
	free(tmp);
      }
    }
    else {
      prev = tmp;
      tmp = tmp->next;
    }
  }
}




/*----------------------------------------------------------------------*/
/* VOID free_check_list							*/
/*......................................................................*/
/*									*/
/* Free all the entries in the check list				*/
/*----------------------------------------------------------------------*/
void free_check_list(void)
{
  check_ptr tmp,n;

  tmp=check_head;

  while (tmp!=NULL) {
    n = tmp->next;
    if (tmp->next!=NULL) free(tmp->next);
    free(tmp);
    tmp = n;
  }
  check_head = NULL;
  check_tail = NULL;
}
