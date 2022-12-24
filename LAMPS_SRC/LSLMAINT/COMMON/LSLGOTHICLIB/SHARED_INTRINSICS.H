/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-06-10 12:02:46.000000000 +0100
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

/*>>> EXTERN functions from SHARED_INITIALISE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN shared_initialise						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS shared_initialise();
/*----------------------------------------------------------------------*/
/* EXTERN lsr_init                                                      */
/*......................................................................*/
/*                                                                      */
/* Initialise file handler and status code handler                      */
/* Load intrinsic raster transformations                                */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_init();
/*----------------------------------------------------------------------*/
/* EXTERN lsr_print_message                                             */
/*......................................................................*/
/*                                                                      */
/* Print the message associated with an error                           */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_print_message(GOTH_STATUS in_status);
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_data_transform                                   */
/*......................................................................*/
/*                                                                      */
/* Register LSR data processing functions                               */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/*                                                                      */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_data_transform(GOTH_STRING      funcname,
                                                GOTH_INTEGER     func_address,
                                                GOTH_INTEGER     nargs,
                                                GOTH_DATATYPE    argtypes[]) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_raster_transform                                 */
/*......................................................................*/
/*                                                                      */
/* Register LSR raster processing functions                             */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/* scaleable -in- TRUE if transformation is scaleable                   */
/*                                                                      */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_raster_transform(GOTH_STRING   funcname,
                                                  GOTH_INTEGER  func_address,
                                                  GOTH_INTEGER  nargs,
                                                  GOTH_DATATYPE argtypes[],
                                                  GOTH_BOOLEAN  scaleable) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_extern_transform                                 */
/*......................................................................*/
/*                                                                      */
/* Register LSR layer functions                                         */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_extern_transform(GOTH_STRING   funcname,
                                                GOTH_INTEGER  func_address,
                                                GOTH_INTEGER  nargs,
                                                GOTH_DATATYPE argtypes[]) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_layer_transform                                  */
/*......................................................................*/
/*                                                                      */
/* Register LSR layer functions                                         */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_layer_transform(GOTH_STRING   funcname,
                                                GOTH_INTEGER  func_address,
                                                GOTH_INTEGER  nargs,
                                                GOTH_DATATYPE argtypes[]) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_tile_transform                                   */
/*......................................................................*/
/*                                                                      */
/* Register LSR tile functions                                          */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_tile_transform(GOTH_STRING   funcname,
                                                GOTH_INTEGER  func_address,
                                                GOTH_INTEGER  nargs,
                                                GOTH_DATATYPE argtypes[]) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_mbr_transform                                    */
/*......................................................................*/
/*                                                                      */
/*                                                                      */
/* Register LSR raster mbr functions                                    */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_mbr_transform(GOTH_STRING   funcname,
                                               GOTH_INTEGER  func_address,
                                               GOTH_INTEGER  nargs,
                                               GOTH_DATATYPE argtypes[]) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_register_coord_transform                                  */
/*......................................................................*/
/*                                                                      */
/* Register LSR raster point functions                                  */
/*                                                                      */
/* funcname -in- the name to register the function                      */
/* func_address -in- the function address                               */
/* nargs -in- the number of arguments of the function                   */
/* argtypes -in- the datatypes of the argument list                     */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  lsr_register_coord_transform(GOTH_STRING   funcname,
                                                 GOTH_INTEGER  func_address,
                                                 GOTH_INTEGER  nargs,
                                                 GOTH_DATATYPE argtypes[]) ;
/*----------------------------------------------------------------------*/
/* EXTERN lsr_get_enumerated_value                                     */
/*......................................................................*/
/*                                                                      */
/* Return the value of an enumerated datatype to an external source     */
/*                                                                      */
/* string -in- the string to check against                              */
/*                                                                      */
/* returns -1 if no string                                              */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER lsr_get_enumerated_value(char *string) ;

