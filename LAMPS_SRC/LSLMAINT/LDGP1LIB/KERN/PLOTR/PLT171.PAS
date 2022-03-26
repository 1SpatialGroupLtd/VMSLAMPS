[INHERIT ('Inherit_File')]
MODULE PLT171 ;

{ PLT171.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE WMP7CRT_Write_Menu_Page_7_CRT ;
(**********************************************************************)

BEGIN (* WMP7CRT_Write_Menu_Page_7_CRT *)

  KT_Kern_Title ( Ten_Digit_Number, Title ) ;
  WRITELN ( 'OFF-LINE PLOTTING                   PAGE 7          LINE AND SYMBOL SELECTION ' ) ;
  WRITELN ;

  WRITELN ( ' 1.                             SELECTED LINE = ') ;
  WRITELN ( ' 2.                           SELECTED SYMBOL = ') ;
  WRITELN ;
  WRITELN ( ' 3.                       SELECTED LINE LEVEL = ') ;
  WRITELN ( ' 4.                     SELECTED SYMBOL LEVEL = ') ;
  WRITELN ;
  WRITELN ( ' 5.            DISPLAY INPUT FILE LINES (Y/N) = NO ') ;
  WRITELN ( ' 6.          DISPLAY INPUT FILE SYMBOLS (Y/N) = NO ') ;
  WRITELN ;
  WRITELN ( ' 7.      DISPLAY INPUT FILE LINE LEVELS (Y/N) = NO ') ;
  WRITELN ( ' 8.    DISPLAY INPUT FILE SYMBOL LEVELS (Y/N) = NO ') ;
  WRITELN ;

END ;  (* WMP7CRT_Write_Menu_Page_7_CRT *)


(**********************************************************************)
[GLOBAL] PROCEDURE PMP7_Print_Menu_Page_7 ;
(**********************************************************************)

VAR
     I,
     Title_Length,
     Cursor_Position     :   INTEGER ;
     Out_Write           :   TEXT    ;

     Nr_Line             :   INTEGER ;



BEGIN (* PMP_Print_Menu_Page *)

   OPEN ( Out_Write,
          FILE_NAME := '$PRINTER' ) ;

   REWRITE ( Out_Write ) ;

   PKT_Print_Kern_Title ( Ten_Digit_Number, Title );

   WRITELN (Out_Write, 'OFF-LINE PLOTTING                   PAGE 7          LINE AND SYMBOL SELECTION ' ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, ' 1.                   INPUT FILE NAME = ', Input_File_Name ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, ' 2.                 LIBRARY FILE NAME = ', Library_File_Name ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

WRITELN ( Out_Write, '  LINE  ALPHA DESCRIPTION                    LINE  ALPHA DESCRIPTION') ;
   WRITELN (Out_Write) ;

      Nr_Line := 0 ;
      { look and display }
      FOR I := 1 TO 1000 DO
          BEGIN
               FIND  ( Layer_File, I ) ;
               READ  ( Layer_File, Layer ) ;

               IF Layer
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            Line_Type_Code_Number := I ;
                            Get_Line_Definition ;
                            IF ODD(Nr_Line)
                               THEN WRITE ( Out_Write, I:5,
                                            Line_Alpha_Description:20,' ':18 )
                               ELSE WRITELN ( Out_Write, I:5,
                                            Line_Alpha_Description:20);
                        END ;
            END ;


   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN ( Out_Write, 'SYMBOL  ALPHA DESCRIPTION                  SYMBOL  ALPHA DESCRIPTION') ;
   WRITELN (Out_Write) ;

      Nr_Line := 0 ;
      FOR I := 1 TO 1000 DO
          BEGIN
               FIND  ( Layer_File, I+1000 ) ;
               READ  ( Layer_File, Layer ) ;

               IF Layer
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            Symbol_Code_Number := I ;
                            Get_Symbol_Definition ;
                            IF ODD(Nr_Line)
                               THEN WRITE ( Out_Write, I:5,
                                            Symbol_Alpha_Description:20,
                                                 ' ':18 )
                               ELSE WRITELN ( Out_Write, I:5,
                                              Symbol_Alpha_Description:20) ;
                         END ;

            END ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

WRITELN ( Out_Write, '  LINE  LEVELS                               LINE  LEVELS') ;
   WRITELN (Out_Write) ;

      Nr_Line := 0 ;
      { look and display }
      FOR I := 1 TO 1000 DO
          BEGIN
               FIND  ( Layer_File, I+2000 ) ;
               READ  ( Layer_File, Layer ) ;

               IF Layer
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            Line_Type_Code_Number := I ;
                            Get_Line_Definition ;
                            IF ODD(Nr_Line)
                               THEN WRITE   ( Out_Write, I:5, ' ':38 )
                               ELSE WRITELN ( Out_Write, I:5 ) ;
                        END ;
            END ;


   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

   WRITELN ( Out_Write, 'SYMBOL  LEVEL                              SYMBOL  LEVEL ' ) ;
   WRITELN (Out_Write) ;

      Nr_Line := 0 ;
      FOR I := 1 TO 1000 DO
          BEGIN
               FIND  ( Layer_File, I+3000 ) ;
               READ  ( Layer_File, Layer ) ;

               IF Layer
                  THEN BEGIN
                            Nr_Line := Nr_Line + 1 ;
                            Symbol_Code_Number := I ;
                            Get_Symbol_Definition ;
                            IF ODD(Nr_Line)
                               THEN WRITE   ( Out_Write, I:5, ' ':38 )
                               ELSE WRITELN ( Out_Write, I:5 ) ;
                         END ;

            END ;

   WRITELN (Out_Write) ;
   CLOSE (Out_Write) ;

END ;  (* PMP_Print_Menu_Page *)
END.
