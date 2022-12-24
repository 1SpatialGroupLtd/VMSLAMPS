/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:23:10.000000000 +0000
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
#ifndef _USER_INTRINSICS_H
#define _USER_INTRINSICS_H


/*>>> EXTERN functions from USERLIB.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN user_read_definitions						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine must be called before any other USERLIB routines.	*/
/* This routine reads all user definitions and initialises data so that	*/
/* USERLIB knows which users have certain privileges and what each	*/
/* user's password is. This routine can be called after calling other	*/
/* USERLIB routines, the user definitions will be re-read.		*/
/*									*/
/* The first non-comment line of the file has an identifier which can be*/
/* interpreted by USERLIB to determine the password encryption method.	*/
/* This allows USERLIB to move to new encryption schemes if it becomes	*/
/* impossible to maintain the same encryption scheme over all supported	*/
/* platforms.								*/
/*									*/
/* The identifier is as follows CR#, where # is a multi-digit number	*/
/* understood by USERLIB.						*/
/*									*/
/* UNIX encryption method:- CR00.					*/
/*									*/
/* If these details are written back to the file using			*/
/* user_write_definitions(), the comment and blank lines that were	*/
/* present in the file [after] the encryption method will be lost.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* None.								*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__ERROR		The user definitions file contains errors.	*/
/*			The password encryption method could not be	*/
/*			determined.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_read_definitions();
/*----------------------------------------------------------------------*/
/* EXTERN user_write_definitions					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to write the user definitions, privileges and	*/
/* passwords to the user definitions file. All previous definitions are	*/
/* overwritten.								*/
/*									*/
/* The first line of the file has an identifier which can be interpreted*/
/* by USERLIB to determine the password encryption method. This allows	*/
/* USERLIB to move to new encryption schemes if it becomes impossible to*/
/* maintain the same encryption scheme over all supported platforms.	*/
/*									*/
/* The identifier is as follows CR#, where # is a multi-digit number	*/
/* understood by USERLIB.						*/
/*									*/
/* UNIX encryption method:- CR00.					*/
/*									*/
/* This routine does not write comment lines, so the any comments that	*/
/* were in the file will be lost.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* None.								*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__ERROR		The user definitions file contains errors.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_write_definitions();
/*----------------------------------------------------------------------*/
/* EXTERN user_set_user							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to set the current user of USERLIB. The user set*/
/* by this routine will be the user that is deemed to be the caller of	*/
/* all subsequent calls to other USERLIB routines.			*/
/*									*/
/* Too many successive calls to this routine that fail result in the	*/
/* routine rejecting all users. The threshold for the failures is 10.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	Name of user to set.				*/
/* password	-in-	Password for the user.				*/
/* *valid	-out-	TRUE if the user name and password match.	*/
/*			FALSE if the user name and password do not	*/
/*			match, or too many failed attempts at setting a	*/
/*			password have occurred.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_set_user(GOTH_STRING	user_name,
				 GOTH_STRING	password,
				 GOTH_BOOLEAN	*valid);
/*----------------------------------------------------------------------*/
/* EXTERN user_set_batch_user				       		*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to set the current user of USERLIB. The user set*/
/* by this routine will be the user that is deemed to be the caller of	*/
/* all subsequent calls to other USERLIB routines.			*/
/*									*/
/* The password is passed in an encrypyed form together with the key.	*/
/* This routine merely decrypts the password and calls user_set_user()	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	Name of user to set.				*/
/* key		-in-	Key to decrypt password				*/
/* encrypt_password -in- Encrypted password for the user.      		*/
/* *valid	-out-	TRUE if the user name and password match.	*/
/*			FALSE if the user name and password do not	*/
/*			match, or too many failed attempts at setting a	*/
/*			password have occurred.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_set_batch_user(
				       GOTH_STRING	user_name,
				       GOTH_STRING	key,
				       GOTH_STRING	encrypt_password,
				       GOTH_BOOLEAN	*valid);
/*----------------------------------------------------------------------*/
/* EXTERN user_get_batch_password	      		       		*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to get the encrypted form (based on the 	*/
/* supplied key) of the user's password which has been stored (per	*/
/* session) within USERLIB. Thus this routine can only be called once	*/
/* the user has successfully logged in.	The routine returns a copy of	*/
/* the batch password which the user should free up when finished with 	*/
/* it.									*/
/*									*/
/* If the current password is not present then encrypt_password	will	*/
/* return NULL.								*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* key		-in-	Key to encrypt password				*/
/* encrypt_password -out- Encrypted password for the user.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_get_batch_password(
					   GOTH_STRING	key,
					   GOTH_STRING	*encrypt_password );
/*----------------------------------------------------------------------*/
/* EXTERN user_verify_password		      		       		*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to verify that the specified password (or part thereof) is	*/
/* valid inasmuch as the characters it contains are valid.		*/
/*									*/
/* *ret_ok is set to TRUE is password is an empty string		*/
/* *ret_ok is set to FALSE is password is NULL				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* password	-in-	password to be verified				*/
/* ret_ok      	-out-	OK flag returned				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_verify_password(
					GOTH_STRING	password,
					GOTH_BOOLEAN	*ret_ok );
/*----------------------------------------------------------------------*/
/* EXTERN user_get_user							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to get a readonly copy of the current user. If	*/
/* no user has been set, the routine returns "" as the user name.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* *user_name	-out-	A READONLY user name.			       !*/
/*			"" if no user specified.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_get_user(GOTH_STRING	*user_name);
/*----------------------------------------------------------------------*/
/* EXTERN user_get_users						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine returns a collection containing all the user names for	*/
/* the GOTHIC system. The collection is allocated by this routine. The	*/
/* caller of this routine is responsible for destroying the collection.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* *user_set	-out-	Set of users of system.				*/
/*			Empty collection returned if no users.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_get_users(GD_COLLECTION	*user_set);
/*----------------------------------------------------------------------*/
/* EXTERN user_alter_password						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to alter the password of a user. To do this the	*/
/* existing password for the user must be specified. If the user does	*/
/* not have a password, a password of "" must be specified. If the	*/
/* user_name and existing password match, the password can be		*/
/* overwritten by the new password.					*/
/*									*/
/* If the user that is having their password changed is not the same	*/
/* user as the current user, then the current user must have the	*/
/* privilege PRIV_ALTERUSER.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	Name of user that is having their password	*/
/*			changed.					*/
/* old_password	-in-	Existing password for the user.			*/
/* new_password	-in-	New password for user.				*/
/* *valid	-out-	TRUE if new password installed.		       !*/
/*			FALSE if error occurred.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__NOTPRIVILEGE	The user is not privileged to change passwords.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_alter_password(GOTH_STRING	user_name,
				       GOTH_STRING	old_password,
				       GOTH_STRING	new_password,
				       GOTH_BOOLEAN	*valid);
/*----------------------------------------------------------------------*/
/* EXTERN user_get_own_privileges					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to get a set of the current user's privileges.	*/
/* if the user has no privileges, an empty collection is returned. The	*/
/* collection returned is always a set.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* *priv_set	-out-	Set of user's privileges.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_get_own_privileges(GD_COLLECTION	*priv_set);
/*----------------------------------------------------------------------*/
/* EXTERN user_check_own_privilege					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is provided to allow a user to determine if they have a	*/
/* particular privilege.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* privilege	-in-	Name of the privilege to check.			*/
/* *valid	-out-	TRUE if the user has the privilege named.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_check_own_privilege(GOTH_STRING		privilege,
					    GOTH_BOOLEAN	*valid);
/*----------------------------------------------------------------------*/
/* EXTERN user_add_privilege						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to add a privilege for a user. If the user	*/
/* already has the privilege, an error occurs. The current user must	*/
/* have the privilege PRIV_SETPRIV for this operation to succeed.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	User to add privilege for.			*/
/* privilege	-in-	Privilege to add to user.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__EXISTS		The user already has this privilege.		*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_add_privilege(GOTH_STRING	user_name,
				      GOTH_STRING	privilege);
/*----------------------------------------------------------------------*/
/* EXTERN user_remove_privilege						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to remove a privilege for a user. If the user	*/
/* does not have the privilege, an error occurs. The current user must	*/
/* have the privilege PRIV_SETPRIV for this operation to succeed.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	User to remove privilege for.			*/
/* privilege	-in-	Privilege to remove from user.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__ABSENT		The user does not have this privilege.		*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_remove_privilege(GOTH_STRING	user_name,
					 GOTH_STRING	privilege);
/*----------------------------------------------------------------------*/
/* EXTERN user_get_privileges						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to get a set of the user's privileges.		*/
/* If the user has no privileges, an empty collection is returned. The	*/
/* collection returned is always a set.	The current user must have the	*/
/* privilege PRIV_GETPRIV for this operation to succeed.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	User to get the privileges for.			*/
/* *priv_set	-out-	Set of user's privileges.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__NOTPRIVILEGE	The current user is not privileged to do this	*/
/*			operation.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_get_privileges(GOTH_STRING	user_name,
				       GD_COLLECTION	*priv_set);
/*----------------------------------------------------------------------*/
/* EXTERN user_set_privileges						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to set the user's privileges. The current user	*/
/* must have the privilege PRIV_SETPRIV for this operation to succeed.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	User to get the privileges for.			*/
/* priv_set	-in-	Set of user's privileges.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_set_privileges(GOTH_STRING	user_name,
				       GD_COLLECTION	priv_set);
/*----------------------------------------------------------------------*/
/* EXTERN user_add_user							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to add a user to the user definitions. The user	*/
/* must not already exist. The password supplied must be a minimum of	*/
/* 6 characters in length. Neither the user name or password can have   */
/* delimiter characters in them.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	Name of user to add.				*/
/* password	-in-	Password for this user.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/* GOTH__EXISTS		A user with this name already exists.		*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__NOTPRIVILEGE	The current user is not privileged to do this	*/
/*			operation.					*/
/* GOTH__MALLOC		Memory exhausted, no memory available.		*/
/* GOTH__ERROR		A '/' or '#' character was found in the user	*/
/*			name or password.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_add_user(GOTH_STRING	user_name,
				 GOTH_STRING	password);
/*----------------------------------------------------------------------*/
/* EXTERN user_remove_user						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to remove a user. The current user must have the*/
/* privilege PRIV_ALTERUSER to succeed in performing this routine.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	Name of user being removed.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__NOTPRIVILEGE	The current user is not privileged to do this	*/
/*			operation.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_remove_user(GOTH_STRING	user_name);
/*----------------------------------------------------------------------*/
/* EXTERN user_reset_password						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is provided to allow a user's password to be reset. This*/
/* is to handle the case when the user forgets their password.		*/
/* The current user must have privilege PRIV_ALTERUSER to succeed in	*/
/* calling this routine.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	Name of user having their password reset.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__DESC		A bad descriptor has been encountered.		*/
/* GOTH__UNKNOWNUSER	The user specified does not exist.		*/
/* GOTH__NOTPRIVILEGE	The current user is not privileged to do this	*/
/*			operation.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_reset_password(GOTH_STRING	user_name);
/*----------------------------------------------------------------------*/
/* EXTERN user_get_privilege_set					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine builds a set with the names of all the privileges that	*/
/* a user can have.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* *priv_set	-out-	Collection (set) of strings representing each	*/
/*			valid privilege a user can have.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_get_privilege_set(GD_COLLECTION	*priv_set);
/*----------------------------------------------------------------------*/
/* EXTERN user_exists							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This routine is used to determine is a user name is a valid user of	*/
/* the system.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* user_name	-in-	User name to test.				*/
/* *valid	-out-	TRUE if user is known to the system.	       !*/
/*			FALSE if the user is not known to the system.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful, normal completion.			*/
/* GOTH__ERROR		Internal error.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS user_exists(GOTH_STRING	user_name,
			       GOTH_BOOLEAN	*exists);
#endif
/* $Header: /lslhome/gothic/hdr/userlib/v1-4/RCS/hdr.user_intrinsics.h,v 1.5 1994/02/16 21:28:33 jon Exp $								*/
/* 									*/
/* $Log: hdr.user_intrinsics.h,v $
 * Revision 1.5  1994/02/16  21:28:33  jon
 * Version v1-4 derived from v1-3
 * change 'userlib.c' to use srand() and rand(), which are the ANSI standard
 * unlike random() and srandom()
 *
 * Revision 1.4  1993/09/15  13:09:54  davida
 * Version v1-3 derived from v1-2
 * Allow use of passwords in batch - see WICC 131.
 *
 * Revision 1.3  1993/09/09  11:04:32  adrian
 * Version v1-2 derived from v1-1
 * WICC 5.
 * Update the user name retreival function so that if no users, the current
 * login ID is returned with <System Login> appended to the name.
 *
 * Revision 1.2  1993/07/20  15:49:08  davem
 * Version v1-1 derived from v1-0
 * Work Instruction 76
 * The function user_read_definitions() has an unitialised variable str, that
 * can become uninitialised if the variable num_strings is zero or less. This can
 * cause serious errors.
 *
 * Revision 1.1  1993/07/15  21:19:32  jon
 * Version v1-0 derived from root
 * Extracted to design module.
 * In the absence of a user password file the initial version defaults to the
 * behaviour of before, namely no password control.
 *								*/
