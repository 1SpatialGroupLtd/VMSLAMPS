/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-06-21 10:04:20.000000000 +0100
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
#module POLY "21JN90"
/************************************************************************/
/*									*/
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England   */
/*  Author    A.Verrill					    18-Jun-1989 */
/*									*/
/* I2GDB polygon handling functions    					*/
/*									*/
/************************************************************************/
#include <stdio.h>
#include <string.h>
#include "here:iff.h"	/* pick up typedefs */

/*----------------------------------------------------------------------*/
/*  area								*/
/*......................................................................*/
/*									*/
/*  Returns (+/-)area of polygon defined by nvert vertices		*/
/*----------------------------------------------------------------------*/
float area( VERTEX3 vertex[], int nvert )
{
   int i;		/* loop count */
   float accum = 0.0; 	/* accumulated contributions from edges */

   for ( i=0; i < nvert-1; i++ )
   {
      accum += ( vertex[i+1].x - vertex[i].x )*( vertex[i+1].y + vertex[i].y );
   }
   accum += (vertex[0].x - vertex[nvert-1].x)*(vertex[0].y + vertex[nvert-1].y);
   return (accum / 2);
}

/*----------------------------------------------------------------------*/
int cross_halfspace(float xp, float yp, 
		    float x1, float y1, float x2, float y2 )
/*----------------------------------------------------------------------*/
{
/* returns +1 if line (x1,y1) to (x2,y2) crosses line (y = yp) in 	*/
/* half-space x > xp;							*/
/* returns 0 if not;							*/
/* returns -1 in pathological cases;					*/

   float x_cross; 	/* x coord of intersection */

/* pathological case : (y=yp) passes through vertex */
   if ( (yp == y1) || (yp == y2) ) return -1;

/* (x1,y1) to (x2,y2) doesn't cross (y=yp) */
   if ( (y2 > yp) && (y1 > yp ) ) return 0;
   if ( (y2 < yp) && (y1 < yp ) ) return 0;
   
/* pathological case : (y=yp) passes along edge */
   if ( y1 == y2 ) return -1;

   x_cross = ((x2 - x1)/(y2 - y1))*(yp - y1) + x1;

/* pathological case :  (xp,yp) on egde */
   if ( x_cross == xp ) return -1;

/* return half-space test */
   return ( x_cross > xp );
}

/*----------------------------------------------------------------------*/
int inside( float xp, float yp, VERTEX3 vertex[], int nvert )
/*----------------------------------------------------------------------*/
{
   int 	i; 		/* loop count */
   int	ret;		/* catch return from cross_halfspace() */
   int	n_cross = 0;	/* number of times polygon cuts (y=yp) in halfspace 
			   ( x > xp ) */

/* if n_cross even then point (xp,yp) is inside polygon    		*/

   for ( i= 0; i < nvert - 1; i++ )
   {
      if (( ret = cross_halfspace(xp, yp, 
				  vertex[(i+1)].x, 
				  vertex[(i+1)].y, 
				  vertex[i].x, 
				  vertex[i].y)) < 0 )
      {
	 return -1;
      }
      n_cross += ret;
   }
   return (n_cross % 2);
}


/*----------------------------------------------------------------------*/
/*  seed_point								*/
/*......................................................................*/
/*									*/
/*  Returns a seed point in a closed polygon				*/
/*  Seed->(x,y) set to coords of seed point for polygon vertex		*/
/*  Function returns 	+1 if seed point found OK			*/
/*  			 0 if seed point not found			*/
/*									*/
/*  Assumptions : vertex[nvert] == vertex[0]				*/
/*----------------------------------------------------------------------*/
int seed_point( VERTEX3 *seed, VERTEX3 vertex[], int nvert )
{
   float tx, ty;	/* trial point */
   int n;		/* counter, number of points to use in calculation */
   int i, j;		/* loop counts */
   int in = -1;		/* catch result of inside() */

/* Try centre of gravity of n points from polygon, starting at point 0.	*/
/* Then try n from point 1 and so on.					*/
/* Begin with all vertices, decrease by 1.				*/
/* Guaranteed to succeed for n = 3 since there must be at least one convex*/
/* set of vertices.							*/
   
   for ( n = nvert-1; (n >= 3) && (in <= 0); n-- ) /* begin with all vertices */
   {
      for ( i = 0; (i < nvert-1) && (in <= 0); i++ ) /* start at vertex[0] */
      {
	 tx = ty = 0.0;
	 for ( j = 0; (j < n) && (in <= 0); j++ )  /* add contribution from */
	 {					   /* n points */
	    
	    tx += vertex[(i+j) % nvert].x;
	    ty += vertex[(i+j) % nvert].y;
	 }
	 tx /= n;
	 ty /= n;

	 in = inside( tx, ty, vertex, nvert );
      }
   }

   if (in <= 0) return 0;
   else
   {
      seed->x = tx;
      seed->y = ty;
      return 1;
   }
}
