[INHERIT ('Inherit_File')]
MODULE PLT016 ;

{ PLT016.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE CLF_Check_Library_File ;
(********************************************************************)
{
    This procedure opens the line and symbol definition file (LIBPAR.DAT).
    The name of this file is read from the plot parameter file
    (PLOTR.DEF). The name of the library file can be changed in
    definition page 3.
}

VAR
    I                      : INTEGER ;
    Len			   : INTEGER ;
    Err                    : Boolean;
    File_Exists		   : Boolean;
    Message_4              : String_40 ;
    SString                 : String_40 ;
    Number_Of_Characters   : INTEGER ;
    Return                 : BOOLEAN ;
    Arrow_Key              : CHAR ;
    Library_Record:	String_128 ;

BEGIN (* PROCEDURE CLF_Check_Library_File *)

  KT_Kern_Title (Ten_Digit_Number, Title) ;
  Message_4 := 'OPENING                                 ' ;
  FOR I := 1 TO File_Name_Length-8 DO Message_4[I+8] := Library_File_Name[I] ;
  IRAWF_Indicate_Reading_And_Writing_Files
    ('Opening Line and Symbol Definition File ',  Message_4) ;

  OPEN ( Library_Pointer,
         FILE_NAME := Library_File_Name,
         RECORD_TYPE := FIXED,
         RECORD_LENGTH := 128,
         HISTORY := OLD,
         ACCESS_METHOD := DIRECT,
         ERROR := CONTINUE ) ;

  RESET ( Library_Pointer, ERROR := CONTINUE ) ;
  IF EOF ( Library_Pointer ) THEN Len := -1
  ELSE Len := 1 ;

  IF Len > 0 THEN
    BEGIN
      { Find the number of records }
       Library_Size := 0 ;
       WHILE NOT EOF (Library_Pointer) DO
         BEGIN
           READ ( Library_Pointer, Library_Record ) ;
           Library_Size := Library_Size + 1 ;
         END ;
       Library_Size := (( Library_Size + 1 ) DIV 2 ) -1 ;
       CLOSE ( Library_Pointer ) ;
     END
   ELSE
     BEGIN
       DBHEIG_Double_Height (8) ;
       SELGRA_Select_Graphics ('R') ;
       WRITELN ('            FILE NOT FOUND              ') ;
       WRITELN ('            FILE NOT FOUND              ') ;
       SELGRA_Select_Graphics ('O') ;

       DBWIDT_Double_Width (24) ;
       WRITE ('TO CONTINUE THE PROGRAM PRESS <RETURN> ') ;
       BELLRI_Bell_Ring ;

       Read_Key_Board ( SString, Number_Of_Characters, Scape,
                        Return, Arrow_Key, 1) ;

       IF Scape AND ( Arrow_Key = ' ' ) THEN
         BEGIN
           ERASCR_Erase_Screen ;
           EP_Exit_Program;
         END
       ELSE
         DOP_Define_Overall_Parameters ;

     END ;

END ; (* PROCEDURE CLF_Check_Library_File *)
END.
