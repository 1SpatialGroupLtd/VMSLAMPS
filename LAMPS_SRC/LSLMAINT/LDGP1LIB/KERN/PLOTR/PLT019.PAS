[INHERIT ('Inherit_File')]
MODULE PLT019 ;

{ PLT019.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE CSLF_Create_Selected_Layers_File ;
(**********************************************************************)
VAR
   Index,
   J,
   I      : INTEGER ;
   Len    : INTEGER ;

    Line_Symbol_String : PACKED ARRAY [ 1..17 ] OF CHAR ;

   Data_String : String_128 ;

   SString      : String_40 ;
   Number_Of_Characters : INTEGER ;
   Value       : DOUBLE ;
   Error       : BOOLEAN ;

BEGIN (* PROCEDURE CSLF_Create_Selected_Layers_File *)

     { silly time! }
     CLOSE ( Input_File, ERROR := CONTINUE ) ;
     OPEN ( Input_File,
            FILE_NAME := Input_File_Name,
            HISTORY := OLD ) ;
     RESET ( Input_File ) ;

     OPEN ( Layer_File,
              FILE_NAME := Temp_File,
              ACCESS_METHOD := DIRECT,
              DISPOSITION := DELETE ) ;
     REWRITE( Layer_File ) ;

     { initialize }
     Layer := FALSE ;
     FOR I := 1 TO Max_Layers DO
         BEGIN
              LOCATE ( Layer_File, I ) ;
              WRITE ( Layer_File, Layer ) ;
          END ;

     Layer := TRUE ;
     REPEAT
           READ ( Input_File, Line_Symbol_String [1] ) ;

           IF Line_Symbol_String [1] = 'C'
              THEN BEGIN
                        READ ( Input_File, Line_Symbol_String ) ;
                        IF Line_Symbol_String = 'HANGE TO LINETYPE'
                           THEN BEGIN
                                     READ ( Input_File, I ) ;
                                     LOCATE ( Layer_File, I ) ;
                                     WRITE ( Layer_File, Layer ) ;
                                  END ;

                        IF Line_Symbol_String = 'HANGE TO SYMBOL  '
                           THEN BEGIN
                                     READ ( Input_File, I ) ;
                                     LOCATE ( Layer_File, I + 1000 ) ;
                                     WRITE ( Layer_File, Layer ) ;
                                  END ;

                     END ;

           READLN ( Input_File ) ;


     UNTIL    ( Line_Symbol_String [1] = 'Q' )
           OR EOF ( Input_File ) ;

     CLOSE ( Input_File ) ;

     { create selected levels )
     { lines }
     FOR I := 1 TO 1000 DO
         BEGIN
              FIND ( Layer_File, I ) ;
              READ  ( Layer_File, Layer ) ;
              IF Layer
                 THEN BEGIN
                           { read the data from the files }
                           FIND ( Library_Pointer, I ) ;
                           READ ( Library_Pointer, Data_String           ) ;
                           { get line level from file }
                           { #2   LINE LEVEL = Line_Level }
                           SString := Blank_40 ;
                           Number_Of_Characters := 3 ;
                           FOR J := 1 TO Number_Of_Characters DO
                               SString[J] := Data_String[J+84];
                           Convert_To_Numeric( SString, Number_Of_Characters,
                                               Value, Error );
                           IF NOT ERROR
                              THEN BEGIN
                                        Line_Level := TRUNC ( Value ) ;
                                        LOCATE ( Layer_File, Line_Level+2000 );
                                        WRITE  ( Layer_File, Layer ) ;
                                     END ;
                        END ;
           END ;


     { symbols }
     FOR I := 1 TO 1000 DO
         BEGIN
              FIND  ( Layer_File, I+1000 ) ;
              READ  ( Layer_File, Layer ) ;
              IF Layer
                 THEN BEGIN
                           { read the data from the file }
                           Index := I + Library_Size + 1 ;
                           FIND ( Library_Pointer, Index       ) ;
                           READ ( Library_Pointer, Data_String ) ;
                           { get symbol level from file }
                           { #2   SYMBOL LEVEL = Symbol_Level }
                           SString := Blank_40 ;
                           Number_Of_Characters := 3 ;
                           FOR J := 1 TO Number_Of_Characters DO
                               SString[J] := Data_String[J+34];
                           Convert_To_Numeric( SString, Number_Of_Characters,
                                               Value, Error );
                           IF NOT ERROR
                              THEN BEGIN
                                        Symbol_Level := TRUNC ( Value ) ;
                                        LOCATE ( Layer_File, Symbol_Level+3000);
                                        WRITE  ( Layer_File, Layer ) ;
                                     END ;
                        END ;
           END ;


END ; (* PROCEDURE CSLF_Create_Selected_Layers_File *)


(**********************************************************************)
[GLOBAL] PROCEDURE OPF_Open_Plot_File ;
(**********************************************************************)
VAR
   I            : INTEGER ;
   Len          : INTEGER ;

   Message_4    : String_40 ;

BEGIN (* PROCEDURE OPF_Open_Plot_File *)

     Message_4 := 'OPENING                                 ' ;
     FOR I := 1 TO File_Name_Length-8 DO Message_4[I+8] := Input_File_Name[I] ;
     IRAWF_Indicate_Reading_And_Writing_Files
     ('           Opening Plot File            ',  Message_4) ;

     CLOSE ( Input_File, ERROR := CONTINUE ) ;
     OPEN ( Input_File,
            FILE_NAME := Input_File_Name,
            HISTORY := OLD,
            ERROR := CONTINUE ) ;
     RESET ( Input_File, ERROR := CONTINUE ) ;

     IF EOF ( Input_File ) THEN Len := -1
     ELSE
       BEGIN
         Len := 1 ;
         CLOSE ( Input_File ) ;
       END ;

     IF Len <= 0
        THEN BEGIN
                  DBHEIG_Double_Height (8) ;
                  SELGRA_Select_Graphics ('R') ;
                  WRITELN ('            FILE NOT FOUND              ') ;
                  WRITELN ('            FILE NOT FOUND              ') ;
                  SELGRA_Select_Graphics ('O') ;

                  DBWIDT_Double_Width (24) ;
                  WRITE ('TO CONTINUE THE PROGRAM PRESS <RETURN> ') ;
                  BELLRI_Bell_Ring ;

                  READLN ;
                  ERASCR_Erase_Screen ;
                  EP_Exit_Program;
               END ;


END ; (* PROCEDURE OPF_Open_Plot_File *)


(**********************************************************************)
[GLOBAL] PROCEDURE FSPF_Find_Start_of_Plot_File ;
(**********************************************************************)
VAR
   Found        : BOOLEAN ;
   Finished     : BOOLEAN ;
   Start_String : String_5 ;
   Len          : INTEGER ;


BEGIN (* PROCEDURE FSPF_Find_Start_of_Plot_File *)

     CLOSE ( Input_File, ERROR := CONTINUE ) ;
     OPEN ( Input_File,
            FILE_NAME := Input_File_Name,
            HISTORY := OLD ) ;
     RESET ( Input_File ) ;

     { find start of the file }
     Found    := FALSE ;
     Finished := FALSE ;

     REPEAT

           READLN ( Input_File, Start_String ) ;

           IF Start_String = 'START'
              THEN Found := TRUE ;

           IF EOF ( Input_File )
              THEN Finished := TRUE ;

           IF Start_String = 'QUIT '
              THEN Finished := TRUE ;

     UNTIL    Found
           OR Finished ;

     IF NOT Found
        THEN BEGIN
                  DBHEIG_Double_Height (8) ;
                  SELGRA_Select_Graphics ('R') ;
                  WRITELN ('       START OF FILE NOT FOUND          ') ;
                  WRITELN ('       START OF FILE NOT FOUND          ') ;
                  SELGRA_Select_Graphics ('O') ;

                  DBWIDT_Double_Width (24) ;
                  WRITE ('TO CONTINUE THE PROGRAM PRESS <RETURN> ') ;
                  BELLRI_Bell_Ring ;

                  READLN ;
                  ERASCR_Erase_Screen ;
                  EP_Exit_Program;
               END ;

END ; (* PROCEDURE FSPF_Find_Start_of_Plot_File *)
END.
