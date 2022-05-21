/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-07-22 13:33:48.000000000 +0100
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    S.Townrow, 26-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*                  V P F _ R E A D _ T A B L E S                       */
/*									*/
/* Part of DCW (VPF) database interface library              		*/
/*									*/
/* All these routines have been written by ESRI who designed the VPF	*/
/* format. They are a mess but at least they work !			*/
/*									*/
/************************************************************************/

#module	VPF_READ_TABLE "22JL93"

/*----------------------------------------------------------------------*/
/*	Include definitions						*/
/*----------------------------------------------------------------------*/
#include <stat.h>
#include <stdio.h>
#include <string.h>
#include "mespar.h"
#include "vpf_table.h"
#include "vpf_edges.h"
#include "vpf_fc.h"
#include "vpf_ac.h"
#include "dcw2imsg.h"

#define HEAP_OVERHEAD 4			/* per heap block byte overhead */

int STORAGE_BYTE_ORDER = LEAST_SIGNIFICANT;  /* default */

vpf_table_type   areatable;
vpf_table_type   linetable;
vpf_table_type   pnttable;
vpf_table_type   texttable;
vpf_table_type   fcstable;
vpf_table_type   factable;
vpf_table_type   rngtable;
vpf_table_type   edgtable;
vpf_table_type   endtable;
vpf_table_type   txttable;

char *tab1[4]; 	/* subset of names and foreign keys from FCS */
char *key1[4];
char *tab2[4];
char *key2[4];
int verbose;
int fsn=0;
int fsn_times=0;
float ra[4];
float tgap;
coordinate_type orig;


/*----------------------------------------------------------------------*/
/* void init_values							*/
/*......................................................................*/
/*									*/
/* Initialise values
/*----------------------------------------------------------------------*/
extern void init_values(float *x_orig,
			float *y_orig,
			float *gap,
			int *verb)
{
  ra[0]=1.0e38;
  ra[1]=(-1.0e38);
  ra[2]=1.0e38;
  ra[3]=(-1.0e38);
  orig.x = *x_orig;
  orig.y = *y_orig;
  tgap = *gap;
  verbose = *verb;

  fsn=0;
  fsn_times=0;
}


/*----------------------------------------------------------------------*/
/* void get_range							*/
/*......................................................................*/
/*									*/

/*----------------------------------------------------------------------*/
extern void get_range(float *xmin,
		      float *xmax,
		      float *ymin,
		      float *ymax)
{
  if (fsn+fsn_times*32767==0) {
    *xmin = 0.0;
    *xmax = 0.0;
    *ymin = 0.0;
    *ymax = 0.0;
  }
  else {
    *xmin = ra[0];
    *xmax = ra[1];
    *ymin = ra[2];
    *ymax = ra[3];
  }
}




/*----------------------------------------------------------------------*/
/* int how_many_features						*/
/*......................................................................*/
/*									*/
/* Return the current FSN to determine if we should delete the file.	*/
/* fsn is set to zero anyway for the next file.				*/
/*----------------------------------------------------------------------*/
extern int how_many_features(void)
{
  free (tab1);
  free (tab2);
  free (key1);
  free (key2);
  return (fsn+fsn_times*32767);
}



/*----------------------------------------------------------------------*/
/* int read_area_table							*/
/*......................................................................*/
/*									*/
/* Read area table's header and data					*/
/*----------------------------------------------------------------------*/
int read_area_table(char *filename)
{
  vpf_table_type create_db_table();
  void display_table();

  areatable = create_db_table(filename);
  /*if (areatable.success) display_table(&areatable);*/
  return(areatable.success);
}


/*----------------------------------------------------------------------*/
/* INT read_line_table							*/
/*......................................................................*/
/*									*/
/* Read line table's header and data					*/
/*----------------------------------------------------------------------*/
int read_line_table(char *filename)
{
  vpf_table_type create_db_table();
  void display_table();

  linetable = create_db_table(filename);
  /*if (linetable.success) display_table(&linetable);*/
  return(linetable.success);
}



/*----------------------------------------------------------------------*/
/* INT read_point_table							*/
/*......................................................................*/
/*									*/
/* Read point table's header and data					*/
/*----------------------------------------------------------------------*/
int read_point_table(char *filename)
{
  vpf_table_type create_db_table();
  void display_table();

  pnttable = create_db_table(filename);
  /*if (pnttable.success) display_table(&pnttable); */
  return(pnttable.success);
}



/*----------------------------------------------------------------------*/
/* INT read_text_table							*/
/*......................................................................*/
/*									*/
/* Read text table's header and data					*/
/*----------------------------------------------------------------------*/
int read_text_table(char *filename)
{
  vpf_table_type create_db_table();
  void display_table();

  texttable = create_db_table(filename);
  /*if (texttable.success) display_table(&texttable);*/
  return(texttable.success);
}



/*----------------------------------------------------------------------*/
/* INT read_fcs_table							*/
/*......................................................................*/
/*									*/
/* Read FCS table's header and data					*/
/*----------------------------------------------------------------------*/
int read_fcs_table(char *filename)
{
  vpf_table_type create_db_table();
  void display_table();
  int  field_in_table();
  int  i,j,k;
  int  t1=(-1),t2=(-1),k1=(-1),k2=(-1);

  for (i=0;i<4;i++) {
    tab1[i]  = (char *)NULL;
    tab2[i]  = (char *)NULL;
    key1[i] = (char *)NULL;
    key2[i] = (char *)NULL;
  }

  fcstable = create_db_table(filename);
  if (fcstable.success) {
    /*display_table(&fcstable);*/

    t1 = field_in_table(fcstable,&"TABLE1");
    t2 = field_in_table(fcstable,&"TABLE2");
    k1   = field_in_table(fcstable,&"FOREIGN_KEY");
    k2   = field_in_table(fcstable,&"PRIMARY_KEY");

    if (t1==-1 || t1==-1 || k1==-1 || k2==-1) {
      lsl_putmsg(&DCW2I__INVFCS);
      fcstable.success = FAIL;
    }
    else {
      for (j=0;j<fcstable.nrows;j++) {
	i = -1;
	if (strstr(fcstable.row[j][t1].ptr,"FAC")!=NULL) i=0;
	if (strstr(fcstable.row[j][t1].ptr,"EDG")!=NULL) i=1;
	if (strstr(fcstable.row[j][t1].ptr,"END")!=NULL) i=2;
	if (strstr(fcstable.row[j][t1].ptr,"TXT")!=NULL) i=3;
	if (i!=-1) {
	  tab1[i]=(char *)vpfmalloc(strlen((char *)fcstable.row[j][t1].ptr));
	  strcpy(tab1[i],(char *)fcstable.row[j][t1].ptr);
	  tab2[i]=(char *)vpfmalloc(strlen((char *)fcstable.row[j][t2].ptr));
	  strcpy(tab2[i],(char *)fcstable.row[j][t2].ptr);
	  key1[i]=(char *)vpfmalloc(strlen((char *)fcstable.row[j][k1].ptr));
	  strcpy(key1[i],(char *)fcstable.row[j][k1].ptr);
	  key2[i]=(char *)vpfmalloc(strlen((char *)fcstable.row[j][k2].ptr));
	  strcpy(key2[i],(char *)fcstable.row[j][k2].ptr);
	  /* remove trailing spaces from all names */
	  for (k=0;k<strlen((char *)tab1[i]);k++)
	    if (tab1[i][k]<33 || tab1[i][k]>122) tab1[i][k]=0;
	  for (k=0;k<strlen((char *)tab2[i]);k++)
	    if (tab2[i][k]<33 || tab2[i][k]>122) tab2[i][k]=0;
	  for (k=0;k<strlen((char *)key1[i]);k++)
	    if (key1[i][k]<33 || key1[i][k]>122) key1[i][k]=0;
	  for (k=0;k<strlen((char *)key2[i]);k++)
	    if (key2[i][k]<33 || key2[i][k]>122) key2[i][k]=0;
	}
      }
    }
  }
  return(fcstable.success);
}



/*----------------------------------------------------------------------*/
/* INT field_in_table							*/
/*......................................................................*/
/*									*/
/* Find a field position in the header of a table			*/
/*----------------------------------------------------------------------*/
int field_in_table(vpf_table_type table,char *field)
{
  int i;

  for (i=0;i<table.nfields;i++)
    if (strstr(table.header[i].name,field)!=NULL) return i;

  return (-1);
}



/*----------------------------------------------------------------------*/
/* void free_feature_tables						*/
/*......................................................................*/
/*									*/
/* This function frees all the global tables				*/
/*----------------------------------------------------------------------*/
void free_feature_tables()
{
   void free_table();

   if (areatable.success && areatable.status) free_table(&areatable);
   if (linetable.success && linetable.status) free_table(&linetable);
   if (pnttable.success && pnttable.status) free_table(&pnttable);
   if (texttable.success && texttable.status) free_table(&texttable);
   if (fcstable.success && fcstable.status) free_table(&fcstable);
 }



/*----------------------------------------------------------------------*/
/* void free_primitive_tables						*/
/*......................................................................*/
/*									*/
/* This function frees all the global primitive tables			*/
/*----------------------------------------------------------------------*/
void free_primitive_tables()
{
   void free_table();

   if (factable.success && factable.status) free_table(&factable);
   if (rngtable.success && rngtable.status) free_table(&rngtable);
   if (edgtable.success && edgtable.status) free_table(&edgtable);
   if (endtable.success && endtable.status) free_table(&endtable);
   if (txttable.success && txttable.status) free_table(&txttable);
 }




/*----------------------------------------------------------------------*/
/* INT create_area_features						*/
/*......................................................................*/
/*									*/
/* Search tables to determine which features are selected for output 	*/
/* and write them to the IFF file.					*/
/* This involves reading the FAC, RNG and EDG primitive tables.		*/
/*----------------------------------------------------------------------*/
int create_area_features(char *tablename,char *pathname)
{
  vpf_table_type create_db_table();
  void display_table();
  int read_ring_edges();
  int field_in_table();
  int found;
  int patt_pos;
  int satt_pos;
  int pos_fac_key;
  int pos_ring_ptr;
  int pos_area_key;
  int i,j,k,startpos;
  int fackey,areakey;
  int face,ring_ptr;
  short get_feature_code();
  short fc;
  char *tmp;

  tmp = (char *)vpfmalloc(strlen(pathname));
  strcat(pathname,"FAC");
  factable = create_db_table(pathname);
  if (!factable.success) return FAIL;
  /*display_table(&factable);*/

  strcpy(pathname+strlen(pathname)-3,"RNG");
  rngtable = create_db_table(pathname);
  if (!rngtable.success) return FAIL;
  /*display_table(&rngtable);*/

  strcpy(pathname+strlen(pathname)-3,"EDG");
  edgtable = create_db_table(pathname);
  if (!edgtable.success) return FAIL;
  /*display_table(&edgtable);*/

  free(tmp);

  /* check that we have a FAC file for area features in the FCS */
  if (tab1[0]==NULL) return SUCCESS;

  /* find primary and foreign keys in tables */

  pos_fac_key = field_in_table(factable,key1[0]);
  pos_ring_ptr = field_in_table(factable,&"RING_PTR");
  pos_area_key = field_in_table(areatable,key2[0]);

  /* work out which fields are the attributes determining the feature code */

  patt_pos = (-1);
  satt_pos = (-1);
  for (k=0;k<areatable.nfields;k++) {
    found = find_att_name(tablename,areatable.header[k].name);
    if (found == 1) patt_pos = k;
    if (found == 2) satt_pos = k;
  }

  startpos = 0;
  for (i=0;i<factable.nrows;i++) {
    face = *(long *)factable.row[i][0].ptr;
    fackey = *(long *)factable.row[i][pos_fac_key].ptr;
    ring_ptr = *(long *)factable.row[i][pos_ring_ptr].ptr;
    for (j=startpos;j<areatable.nrows;j++) {
      areakey = *(long *)areatable.row[j][pos_area_key].ptr;
      if (areakey==fackey) {
	startpos = j+1;
	fc = get_feature_code(tablename,j,patt_pos,satt_pos,&areatable);
	if (fc!=-1) {
	  if (face!=1) {
	    read_ring_edges(j,fc,ring_ptr);
	    /*printf("FACid=%4d FC=%5d RING_PTR=%d FACE=%d\n",fackey,fc,ring_ptr,face);*/
	  }
	}
	break;
      }
    }
  }

  return(edgtable.success);
}




/*----------------------------------------------------------------------*/
/* INT is_dangle							*/
/*......................................................................*/
/*									*/
/* Given an edge and face the routine returns TRUE or FALSE if the edge	*/
/* has the face on both sides						*/
/*----------------------------------------------------------------------*/
int is_dangle(int edg,
	      int fac)
{
  id_triplet_type rface,lface;
  int pos_rface,pos_lface;

  pos_rface = field_in_table(edgtable,&"RIGHT_FACE");
  pos_lface = field_in_table(edgtable,&"LEFT_FACE");
  rface = *(id_triplet_type *)edgtable.row[edg-1][pos_rface].ptr;
  lface = *(id_triplet_type *)edgtable.row[edg-1][pos_lface].ptr;

  /* for debugging purposes */
  /* if (rface.id==fac && lface.id==fac) */
  /*   printf("Edge %d is a dangle with face %d on both sides\n",edg,fac); */

  return (rface.id==fac && lface.id==fac);
}




/*----------------------------------------------------------------------*/
/* long get_triplet_id							*/
/*......................................................................*/
/*									*/
/* Gets an edge or face triplet id from the EDG table given the edge	*/
/* number and the field (column) number					*/
/*----------------------------------------------------------------------*/
long get_triplet_id(int edg,
		    int field)
{
  id_triplet_type triple;
  triple = *(id_triplet_type *)edgtable.row[edg-1][field].ptr;
  return triple.id;
}



/*----------------------------------------------------------------------*/
/* long get_node							*/
/*......................................................................*/
/*									*/
/* Gets an node from the EDG table given the edge and the field (column)*/
/* number								*/
/*----------------------------------------------------------------------*/
long get_node(int edg,
	      int field)
{
  return *(long *)edgtable.row[edg-1][field].ptr;
}



/*----------------------------------------------------------------------*/
/* INT read_ring_edges							*/
/*......................................................................*/
/*									*/
/* Read all the edges from the ring table which constitute the face	*/
/* given as argument.							*/
/* 									*/
/* It does it's best to cope with dangles (edges with the same face on	*/
/* both sides. A single dangle often leads to a hole within the area	*/
/* feature and we can cope with this.					*/
/*									*/
/* If we have two dangles in a row, they are removed and normal		*/
/* (non-dangling) edges on the perimeter are taken instead and a	*/
/* warning is given for that area feature.			  	*/
/* 									*/
/* Each time an edge is stored, it is put into a linked list		*/
/* (routine add_to_check_list) so that when any subsequent edges are	*/
/* addded, they are not to be written again if already in the check	*/
/* list. This is to combat the problem in the DCW data where a hole is	*/
/* stored in the perimeter AND in the list of holes, which if traversed	*/
/* as is, would result in a polygon inside out.				*/
/* 									*/
/*----------------------------------------------------------------------*/
int read_ring_edges(int areaindex,
		     int fc,
		     int ringid)
{
  vpf_table_type create_db_table();
  void display_table();
  void write_area_coords();
  void write_last_invis();
  void write_acs();
  void store_edge_info();
  void show_edge_info();
  void remove_last_edge_info();
  void remove_edge_from_check_list();
  void free_edge_table();
  void find_reverses();
  void add_to_check_list();
  void show_check_list();
  void free_check_list();
  int edge_in_check_list();
  int field_in_table();
  int face,next_face;
  long rface,lface;
  long redge,ledge;
  long next,nextl,nextr;
  long nextlface,nextrface;
  long nextledge,nextredge;

  int pos_st_nod,pos_end_nod;
  int pos_rface,pos_lface;
  int pos_redge,pos_ledge;
  int pos_start_edge,pos_face_id;
  int pos_edg_id,pos_coord;
  int next_edge,dangle_edge;
  int start_nod,last_nod;
  int st_nod,end_nod,prev_st_nod,prev_end_nod;
  int try_st_nod,try_end_nod,next_nod;
  int i,j,k,startpos,num_edges;
  int start_edge,num;
  int feat_ok,perimeter,remove_dangle,tmpfsn;
  float xcoord,ycoord;
  coordinate_type coords,prev_coords,*cptr;
  short istat[4];

  istat[1]=0;
  istat[2]=0;
  istat[3]=0; 
  feat_ok = 0;

  pos_start_edge = field_in_table(rngtable,&"START_EDGE");
  pos_face_id = field_in_table(rngtable,&"FACE_ID");
  pos_edg_id = field_in_table(edgtable,&"ID");
  pos_st_nod = field_in_table(edgtable,&"START_NODE");
  pos_end_nod = field_in_table(edgtable,&"END_NODE");
  pos_rface = field_in_table(edgtable,&"RIGHT_FACE");
  pos_lface = field_in_table(edgtable,&"LEFT_FACE");
  pos_redge = field_in_table(edgtable,&"RIGHT_EDGE");
  pos_ledge = field_in_table(edgtable,&"LEFT_EDGE");
  pos_coord = field_in_table(edgtable,&"COORDINATES");

  face = *(long *)rngtable.row[ringid-1][pos_face_id].ptr;

  prev_coords.x = 0; prev_coords.y = 0;
  perimeter = TRUE;
  for (i=ringid;i<=rngtable.nrows;i++) {
    start_edge = *(long *)rngtable.row[i-1][pos_start_edge].ptr;
    next_face  = *(long *)rngtable.row[i-1][pos_face_id].ptr;
    start_nod = get_node(start_edge,pos_st_nod);
    last_nod  = get_node(start_edge,pos_end_nod);
    if (next_face!=face) break;
    num_edges = 0;
    next_edge = start_edge;
    /* for debugging purposes */
    /* printf("start edge num is %d\n",start_edge);*/
    prev_st_nod= -1;
    prev_end_nod= -1;
    lface = -1;
    if (i>ringid) perimeter = FALSE;

    /* for debugging purposes */
    /* if (i==ringid+1) show_check_list(); */

    if (edge_in_check_list(next_edge)) {
      /* for debugging purposes */
      /*printf("%d in perimeter list - it has been ignored\n",next_edge);*/
    }
    else {
      do {
	/* if (perimeter) add_to_check_list(next_edge);         */
	/* This is how it used to be - it only stored perimeter */
	/* edges to be checked. We should store every edge.     */

	add_to_check_list(next_edge);

	store_edge_info((coordinate_type *)
			edgtable.row[next_edge-1][pos_coord].ptr,
			edgtable.row[next_edge-1][pos_coord].count);
	num_edges++;
	if (num_edges>2000) {
	  tmpfsn=fsn+1;
	  lsl_putmsg(&DCW2I__TOOMANYEDGES,&2000,&tmpfsn);
	  free_check_list();
	  return FAIL;
	}
	rface = get_triplet_id(next_edge,pos_rface);
	lface = get_triplet_id(next_edge,pos_lface);
	redge = get_triplet_id(next_edge,pos_redge);
	ledge = get_triplet_id(next_edge,pos_ledge);
	st_nod = get_node(next_edge,pos_st_nod);
	end_nod = get_node(next_edge,pos_end_nod);

/*	this doesn't work on file HYML21 - some holes in large 	*/
/*	sea area (face 55) obliterate their islands		*/
/*								*/
/*	if ((redge==start_edge && ledge==start_edge) ||		*/
/*	    ((start_nod==end_nod) && (start_nod==st_nod) &&	*/
/*	     (last_nod==end_nod) && (last_nod==st_nod))) {	*/

/*	 if ((redge==start_edge && ledge==start_edge)) {       	*/
/*	 This alone didn't cope with every case so we tried to  */
/*	 stop when all the start and end nodes close. But that 	*/
/*	 didn't work either. Settle for this anyway...		*/

	if ((redge==start_edge && ledge==start_edge)) {
	  prev_st_nod = st_nod;
	  prev_end_nod = end_nod;
	  next_edge = start_edge;
	}
	else {

	  /* Check for DANGLE - edge with the same face on both sides */

	  if (is_dangle(next_edge,face)) {
	    if (st_nod==prev_st_nod || st_nod==prev_end_nod)
	      next_nod = end_nod;
	    else
	      next_nod = st_nod;

	    remove_dangle = FALSE;
	    dangle_edge = next_edge;

	    /* if the following edge is another dangle, take the other   */
	    /* if they are both dangles then... oh, dear - choose either */

	    nextl = get_triplet_id(next_edge,pos_ledge);
	    nextr = get_triplet_id(next_edge,pos_redge);
	    if (is_dangle(nextl,face) && !is_dangle(nextr,face))
	      {
		remove_edge_from_check_list(next_edge);
		remove_dangle = TRUE;
		next_edge = nextr;
	      }
	    if (is_dangle(nextr,face) && !is_dangle(nextl,face))
	      {
		remove_edge_from_check_list(next_edge);
		remove_dangle = TRUE;
		next_edge = nextl;
	      }

	    if (remove_dangle) {

	      /* get the coords of the dangle where they join the */
	      /* previous line segment by checking the nodes.     */

	      cptr = (coordinate_type *)
		     edgtable.row[dangle_edge-1][pos_coord].ptr;
	      num =  edgtable.row[dangle_edge-1][pos_coord].count;
	      if (st_nod!=prev_st_nod && st_nod!=prev_end_nod) {
		/* got to last point in edge */
		for (k=1;k<num;k++) cptr++;
	      }
	      coords = *cptr;
	      xcoord = coords.x;
	      ycoord = coords.y;
	      if (!coords_equal(prev_coords.x,coords.x) ||
		  !coords_equal(prev_coords.y,coords.y)) {/* report it once */
		tmpfsn=fsn+1;
		lsl_putmsg(&DCW2I__TWODANGLES,&tmpfsn);
		lsl_putmsg(&DCW2I__COORDS,&xcoord,&ycoord);
	      }
	      remove_last_edge_info();
	      num_edges--;
	      prev_coords.x = coords.x;
	      prev_coords.y = coords.y;
	    }
	    else
	      {

	      /* examine following edge to see if it is a singe dangle */
	      /* which could potentially be followed by a valid hole   */

	      next = get_triplet_id(next_edge,pos_redge);

	      /* check for single dangles going back to normal edge */

	      if (next==next_edge) {

		/* back up to avoid dangling lines */

		next = get_triplet_id(next_edge,pos_ledge);
		if (next_nod==end_nod)
		  next_nod = st_nod;
		else if (next_nod==st_nod)
		  next_nod = end_nod;
		st_nod = prev_st_nod;
		end_nod = prev_end_nod;
		remove_last_edge_info();
		remove_edge_from_check_list(next_edge);
		num_edges--;
	      }
	      try_st_nod  = get_node(next,pos_st_nod);
	      try_end_nod = get_node(next,pos_end_nod);
	      if (next_nod==try_st_nod || next_nod==try_end_nod) {
		prev_st_nod = st_nod;
		prev_end_nod = end_nod;
		next_edge = next;
	      }
	      else {
		next = get_triplet_id(next_edge,pos_ledge);
		prev_st_nod = st_nod;
		prev_end_nod = end_nod;
		next_edge = next;
	      }
	    }
	  }
	  else {   		/* follow normal progression around edges */
	    if (rface==face)
	      next = get_triplet_id(next_edge,pos_redge);
	    if (lface==face)
	      next = get_triplet_id(next_edge,pos_ledge);
	    prev_st_nod = st_nod;
	    prev_end_nod = end_nod;
	    next_edge = next;
	  }
	}
	/* for debugging purposes */
	/* printf("edge num is %d\n",next_edge); */
      }	while (start_edge!=next_edge);
      if (num_edges>1) find_reverses();
      /* for debugging purposes */
      /* show_edge_info();*/
      if (num_area_points_ok(4,MAXINT)) {
	feat_ok = 1;
	if (perimeter) {
	  fsn++;
	  if (fsn>32767) {   /* if we exceed the maximum FSN, go round again */
	    fsn=0;
	    fsn_times++;
	  }
	  IFFNF(&fsn,&fsn);
	  istat[0]=fc;
	  IFFFS(&istat);
	  write_acs(areaindex,fc,&areatable);
	  write_area_coords(num_edges,1);  /* write the outer ring, pen down */
	}
	else {
	  write_area_coords(num_edges,0);  /* write the holes, with pen up */
	}
      }
    }
    /* for debugging purposes                   */
    /* printf("Before freeing EDGE lsit...\n"); */
    /* lib$show_vm();                           */

    free_edge_table();

    /* for debugging purposes                   */
    /* printf("After freeing EDGE lsit...\n");  */
    /* lib$show_vm();                           */
  }
  if (feat_ok) IFFEF();
  free_check_list();

  return SUCCESS;
}




/*----------------------------------------------------------------------*/
/* INT create_line_features						*/
/*......................................................................*/
/*									*/
/* Search tables to determine which features are selected for output 	*/
/* and write them to the IFF file.					*/
/*----------------------------------------------------------------------*/
int create_line_features(char *tablename,char *pathname)
{
  vpf_table_type create_db_table();
  void display_table();
  void write_coords();
  void write_acs();
  int field_in_table();
  int found;
  int patt_pos;
  int satt_pos;
  int pos_edg_key;
  int pos_lin_key;
  int i,j,k,startpos;
  int edgkey,linkey;
  short get_feature_code();
  short fc;
  short istat[4];

  istat[1]=0;
  istat[2]=0;
  istat[3]=0; 
  if (edgtable.status != OPENED) {
    strcat(pathname,"EDG");
    edgtable = create_db_table(pathname);
    if (!edgtable.success) return FAIL;
    /*display_table(&edgtable);*/
  }

  /* check that we have an EDG file for line features and not just for areas */
  if (tab1[1]==NULL) return SUCCESS;

  /* find primary and foreign keys in tables */

  pos_edg_key = field_in_table(edgtable,key1[1]);
  pos_lin_key = field_in_table(linetable,key2[1]);

  /* work out which fields are the attributes determining the feature code */

  patt_pos = (-1);
  satt_pos = (-1);
  for (k=0;k<linetable.nfields;k++) {
    found = find_att_name(tablename,linetable.header[k].name);
    if (found == 1) patt_pos = k;
    if (found == 2) satt_pos = k;
  }

  startpos = 0;
  for (i=0;i<edgtable.nrows;i++) {
    edgkey = *(long *)edgtable.row[i][pos_edg_key].ptr;
    for (j=startpos;j<linetable.nrows;j++) {
      linkey = *(long *)linetable.row[j][pos_lin_key].ptr;
      if (linkey==edgkey) {
	startpos = j+1;
	fc = get_feature_code(tablename,j,patt_pos,satt_pos,&linetable);
	if (fc!=-1) {
	  if (num_points_ok(i,2,MAXINT,&edgtable)) {
	    fsn++;
	    if (fsn>32767) {
	      fsn=0;
	      fsn_times++;
	    }
	    IFFNF(&fsn,&fsn);
	    istat[0]=fc;
	    IFFFS(&istat);
	    write_acs(j,fc,&linetable);
	    write_coords(i,&edgtable);
	    /*printf("EDG id %4d matched LINE.LFT %4d and FC = %5d\n",edgkey,linkey,fc);*/
	    IFFEF();
	  }
	}
	break;
      }
    }
  }
  return(edgtable.success);
}




/*----------------------------------------------------------------------*/
/* INT create_point_features						*/
/*......................................................................*/
/*									*/
/* Search tables to determine which features are selected for output 	*/
/* and write them to the IFF file.					*/
/*----------------------------------------------------------------------*/
int create_point_features(char *tablename,char *pathname)
{
  vpf_table_type create_db_table();
  void display_table();
  void write_coords();
  void write_acs();
  int field_in_table();
  int found;
  int patt_pos;
  int satt_pos;
  int pos_end_key;
  int pos_pnt_key;
  int i,j,k,startpos;
  int endkey,pntkey;
  short get_feature_code();
  short fc;
  short istat[4];

  istat[1]=0;
  istat[2]=16384;   /* set bits 14-15 to 01 for point features */
  istat[3]=0; 
  if (endtable.status != OPENED) {
    strcat(pathname,"END");
    endtable = create_db_table(pathname);
    if (!endtable.success) return FAIL;
    /*display_table(&endtable);*/
  }

  /* check that we have an END file for point features in the FCS */
  if (tab1[2]==NULL) return SUCCESS;

  /* find primary and foreign keys in tables */

  pos_end_key = field_in_table(endtable,key1[2]);
  pos_pnt_key = field_in_table(pnttable,key2[2]);

  /* work out which fields are the attributes determining the feature code */

  patt_pos = (-1);
  satt_pos = (-1);
  for (k=0;k<pnttable.nfields;k++) {
    found = find_att_name(tablename,pnttable.header[k].name);
    if (found == 1) patt_pos = k;
    if (found == 2) satt_pos = k;
  }

  startpos = 0;
  for (i=0;i<endtable.nrows;i++) {
    endkey = *(long *)endtable.row[i][pos_end_key].ptr;
    for (j=startpos;j<pnttable.nrows;j++) {
      pntkey = *(long *)pnttable.row[j][pos_pnt_key].ptr;
      if (pntkey==endkey) {
	startpos = j+1;
	fc = get_feature_code(tablename,j,patt_pos,satt_pos,&pnttable);
	if (fc!=-1) {
	  if (num_points_ok(i,1,1,&endtable)) {
	    fsn++;
	    if (fsn>32767) {
	      fsn=0;
	      fsn_times++;
	    }
	    IFFNF(&fsn,&fsn);
	    istat[0]=fc;
	    IFFFS(&istat);
	    write_acs(j,fc,&pnttable);
	    write_coords(i,&endtable);
	    /* printf("END id %4d matched POINT.PFT %4d and FC = %5d\n",endkey,pntkey,fc); */
	    IFFEF();
	  }
	}
	break;
      }
    }
  }
  return(endtable.success);
}





/*----------------------------------------------------------------------*/
/* INT create_text_features						*/
/*......................................................................*/
/*									*/
/* Search tables to determine which features are selected for output 	*/
/* and write them to the IFF file.					*/
/*----------------------------------------------------------------------*/
int create_text_features(char *tablename,char *pathname)
{
  vpf_table_type create_db_table();
  void display_table();
  void write_txt_coord();
  void write_acs();
  int field_in_table();
  int patt_pos,satt_pos;
  int pos_txt_key,pos_txt_str;
  int pos_text_key,pos_text_ht;
  int pos_text_gap;
  int i,j,k,startpos,found;
  int txtkey,textkey,len;
  short get_feature_code();
  short fc,th;
  short istat[4];
  float gap;
  char *txt,*pos;

  istat[1]=0;
  istat[2]=(-32768);   /*set bits 14-15 to 02 for text features*/
  istat[3]=0; 
  if (txttable.status != OPENED) {
    strcat(pathname,"TXT");
    txttable = create_db_table(pathname);
    if (!txttable.success) return FAIL;
    /*display_table(&txttable);*/
  }

  /* check that we have an TXT file for text features in the FCS */
  if (tab1[3]==NULL) return SUCCESS;

  /* find primary and foreign keys in tables */

  pos_txt_str = field_in_table(txttable,&"STRING");
  pos_text_ht = field_in_table(texttable,&"HEIGHT");
  pos_text_gap = field_in_table(texttable,&"TEXTGAP");
  pos_txt_key = field_in_table(txttable,key1[3]);
  pos_text_key = field_in_table(texttable,key2[3]);

  /* work out which fields are the attributes determining the feature code */

  patt_pos = (-1);
  satt_pos = (-1);
  for (k=0;k<texttable.nfields;k++) {
    found = find_att_name(tablename,texttable.header[k].name);
    if (found == 1) patt_pos = k;
    if (found == 2) satt_pos = k;
  }

  startpos = 0;
  for (i=0;i<txttable.nrows;i++) {
    txtkey = *(long *)txttable.row[i][pos_txt_key].ptr;
    for (j=startpos;j<texttable.nrows;j++) {
      textkey = *(long *)texttable.row[j][pos_text_key].ptr;
      if (textkey==txtkey) {
	startpos = j+1;
	gap = *(float *)texttable.row[j][pos_text_gap].ptr;
	fc = get_feature_code(tablename,j,patt_pos,satt_pos,&texttable);
	if (fc!=-1) {
	  if (num_points_ok(i,1,MAXINT,&txttable)) {
	    fsn++;
	    if (fsn>32767) {
	      fsn=0;
	      fsn_times++;
	    }
	    IFFNF(&fsn,&fsn);
	    istat[0]=fc;
	    IFFFS(&istat);
	    write_acs(j,fc,&texttable);
	    if (pos_text_ht==-1) {
	      IFFTH(&0);
	    }
	    else {
	      th = (*(float *)texttable.row[j][pos_text_ht].ptr) * 2540;
	      IFFTH(&th);
	    }
	    write_txt_coord(i,&txttable);
	    len = strlen(txttable.row[i][pos_txt_str].ptr);
	    if (gap>tgap) {   /* insert a space between each character */
	      txt = (char *)vpfmalloc(2*len+1);
	      pos = (char *)txttable.row[i][pos_txt_str].ptr;
	      for (k=0;k<len;k++) {
		strncat(txt,pos,1);
		if (k<len-1) strcat(txt,&" ");
		pos++;
	      }
	      
	    }
	    else {
	      txt=(char *)vpfmalloc(len+1);
	      strcpy(txt,txttable.row[i][pos_txt_str].ptr);
	    }
	    /* printf("TXT id %4d matched TEXT.TFT %4d and FC = %5d, STRING = %s\n",txtkey,textkey,fc,txttable.row[i][pos_txt_str].ptr); */
	    len = strlen(txt);
	    char_check(&fsn,&len,txt);
	    IFFTX(txt);
	    free(txt);
	    IFFEF();
	  }
	}
	break;
      }
    }
  }
  return(txttable.success);
}






/*----------------------------------------------------------------------*/
/* SHORT get_feature_code						*/
/*......................................................................*/
/*									*/
/* Given a table and the attribute field positions, get the FC		*/
/*----------------------------------------------------------------------*/
short get_feature_code(char *tablename,
		       int r,
		       int patt_pos,
		       int satt_pos,
		       vpf_table_type *table)
{
  short get_fc();
  short fc;

  if (patt_pos==-1) {
    fc = get_fc(tablename,NULL,0,NULL,0);
  }
  else {
    if (satt_pos==-1) {
      fc = get_fc(tablename,table->header[patt_pos].name,
		  *(long *)table->row[r][patt_pos].ptr,
		  &" ",0);
    }
    else {
      fc = get_fc(tablename,table->header[patt_pos].name,
		  *(long *)table->row[r][patt_pos].ptr,
		  table->header[satt_pos].name,
		  *(long *)table->row[r][satt_pos].ptr);
    }
  }
  return fc;
}




/*----------------------------------------------------------------------*/
/* VOID write_acs							*/
/*......................................................................*/
/*									*/
/* Write all the attributes found to the IFF file			*/
/*----------------------------------------------------------------------*/
void write_acs(long r,
	       short fc,
	       vpf_table_type *table)
{
  int j,k,val,l;
  int tmpdate,day,mon,yr;
  short ac;
  char *tmpac;

  for (k=0;k<table->nfields;k++) {
    ac = get_ac(table->header[k].name,
		table->header[k].type,fc);
    if (ac!=-1) {
      switch (table->header[k].type) {
	 case 'T':
	    val = 0;
	    tmpac = (char *)vpfmalloc(strlen((char *)table->row[r][k].ptr));
	    strcpy(tmpac,(char *)table->row[r][k].ptr);
	    l=strlen(tmpac);
	    for (j=0;j<l;j++)
	      if (tmpac[l-j-1]>32 && tmpac[l-j-1]<123) {
		if (j<l-1) tmpac[l-j]=0;
		break;
	      }
	      else {
		tmpac[l-j-1]=0;
	      }
	    IFFAC(&ac,&val,tmpac);
	    free (tmpac);
	    break;
	 case 'I':
	    l = *(int *)table->row[r][k].ptr;
	    if (l!=L_UNDEFINED) IFFAC(&ac,&l);
	    break;
	 case 'S':
	    l = (int)*(short *)table->row[r][k].ptr;
	    if (l!=S_UNDEFINED) IFFAC(&ac,&l);
	    break;
	 case 'D':
	    sscanf((char *)table->row[r][k].ptr,"%4d%2d%2d",&yr,&mon,&day);
	    cvt_dmy_day(&tmpdate,&day,&mon,&yr);
	    IFFAC(&ac,&tmpdate);
	    free(tmpac);
	    break;
	  }
    }
  }
}




/*----------------------------------------------------------------------*/
/* VOID write_txt_coord							*/
/*......................................................................*/
/*									*/
/* Write coord of a text feature and calculate the angle between the	*/
/* first a last point of the shape-line if one exists.			*/
/*----------------------------------------------------------------------*/
void write_txt_coord(int r,
		     vpf_table_type *table)
{
  int k,coordpos;
  double rot;
  short iends;
  short npts;
  coordinate_type *cptr;
  coordinate_type t1,t2;
  void update_range();

  coordpos = -1;
  for (k=0;k<table->nfields;k++) {
    if (table->header[k].type=='C') {
      coordpos = k;
      break;
    }
  }

  if (coordpos!=-1) {
    iends=0;
    npts=table->row[r][coordpos].count;
    cptr=(coordinate_type *)table->row[r][coordpos].ptr;
    if (npts>1) {
      t1 = *cptr;
      for (k=0;k<npts-1;k++) cptr++;
      t2 = *cptr;
      if (coords_equal(t1,t2)) {
	rot=0.0;
      }
      else {
	rot = atan2(t2.y-t1.y,t2.x-t1.x);
	if (rot<0.0) rot = rot + TWOPI;
	/*printf("SHAPE LINE angle is %f8.4\n",rot);*/
      }
    }
    else {
      t1 = *cptr;
      rot = 0.0;
    }
    t1.x = t1.x - orig.x;
    t1.y = t1.y - orig.y;
    update_range(&t1);
    IFFST(&t1,&1,&iends);
    IFFRO(&rot);
  }
}





/*----------------------------------------------------------------------*/
/* VOID write_coords							*/
/*......................................................................*/
/*									*/
/* Write all the coords of one row to the IFF file			*/
/*----------------------------------------------------------------------*/
void write_coords(int r,
		  vpf_table_type *table)
{
  int k,coordpos;
  short iends;
  short npts;
  short ptr;
  int coords_equal();
  coordinate_type *cptr;
  coordinate_type stbuf[200];
  void update_range();

  coordpos = -1;
  for (k=0;k<table->nfields;k++) {
    if (table->header[k].type=='C') {
      coordpos = k;
      break;
    }
  }

  if (coordpos!=-1) {
    iends=0;
    npts=table->row[r][coordpos].count;
    cptr=(coordinate_type *)table->row[r][coordpos].ptr;
    ptr=0;
    for (k=0;k<npts;k++) {
      stbuf[ptr] = *cptr;
      stbuf[ptr].x = stbuf[ptr].x - orig.x;
      stbuf[ptr].y = stbuf[ptr].y - orig.y;
      if (ptr>1) {
	if ((xcoords_equal(stbuf[ptr-2],stbuf[ptr]) &&
	     xcoords_equal(stbuf[ptr-1],stbuf[ptr])) ||
	    (ycoords_equal(stbuf[ptr-2],stbuf[ptr]) &&
	     ycoords_equal(stbuf[ptr-1],stbuf[ptr]))) {
	  stbuf[ptr-1] = stbuf[ptr];
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
      cptr++;
      if (ptr>0 && ((ptr % 200) == 0)) {
	IFFST(&stbuf,&ptr,&iends);
	iends = 1;
	ptr = 0;
      }
    }
    if (ptr>0 && ((ptr % 200) != 0)) IFFST(&stbuf,&ptr,&iends);
  }
}




/*----------------------------------------------------------------------*/
/* VOID update_range							*/
/*......................................................................*/
/*									*/
/* Check each point against range					*/
/*----------------------------------------------------------------------*/
void update_range(coordinate_type *coord)
{
  if (coord->x > ra[1]) ra[1]=coord->x;
  if (coord->x < ra[0]) ra[0]=coord->x;
  if (coord->y > ra[3]) ra[3]=coord->y;
  if (coord->y < ra[2]) ra[2]=coord->y;
}





/*----------------------------------------------------------------------*/
/* INT num_points_ok							*/
/*......................................................................*/
/*									*/
/* Check the number of points in feature.				*/
/*----------------------------------------------------------------------*/
int num_points_ok(int r,
		  int min_pts,
		  int max_pts,
		  vpf_table_type *table)
{
  int k,n,coordpos;

  coordpos = -1;
  for (k=0;k<table->nfields;k++) {
    if (table->header[k].type=='C') {
      coordpos = k;
      break;
    }
  }

  if (coordpos==-1) {
    return 0;
  }
  else {
    n = table->row[r][coordpos].count;
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
}
