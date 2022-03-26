[INHERIT ('Inherit_File')]
MODULE PLT101 ;

{ PLT101.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE CAP_Chain_a_Program
        ( Next_Program : String_File_Name_Length );
(********************************************************************)
VAR
     In_Read                         : TEXT;
     Len                             : INTEGER;

     I,
     Length                          : INTEGER ;

     Message_3,
     Message_4                       : String_40 ;

     Command_List                    : Chain_List;
     Num_Commands                    : INTEGER ;


BEGIN (* PROCEDURE CAP_Chain_a_Program *)

     { Do lots of stuff to transfer a couple of strings }
     Command_List[1,1] := 'R';
     Command_List[1,2] := 'U';
     Command_List[1,3] := 'N';
     Command_List[1,4] := ' ';

     FOR I := 5 to Chain_String_Length Do Command_List[1,I] := ' ';
     FOR I := 1 to File_Name_Length Do Command_List[1,I+4] := Next_Program[I];

     Num_Commands := 1;

     KT_Kern_Title ( Ten_Digit_Number, Title ) ;
     { Indicate chaining to the next program }
     Message_3 := '          Chaining a Program            ' ;
     Message_4 := 'Chaining                                ' ;
     FOR I:= 1 TO File_Name_Length DO
         Message_4 [ 9+I ] := Next_Program [I] ;
     IRAWF_Indicate_Reading_And_Writing_Files ( Message_3, Message_4 ) ;

     { is the program in the device ? }
     OPEN ( In_Read,
            FILE_NAME := Next_Program,
            HISTORY := OLD,
            ERROR := CONTINUE ) ;
     RESET ( In_Read, ERROR := CONTINUE ) ;
     IF EOF ( In_Read ) THEN Len := -1
     ELSE Len := 1 ;

     IF Len < 0
        THEN BEGIN
                  DBHEIG_Double_Height ( 10 ) ;
                  SELGRA_Select_Graphics ( 'R' ) ;
                  WRITELN ( '             FILE NOT FOUND             ' ) ;
                  WRITELN ( '             FILE NOT FOUND             ' ) ;
                  SELGRA_Select_Graphics ( 'O' ) ;
                  DBWIDT_Double_Width ( 24 ) ;
                  WRITE ( '    TO CONTINUE PRESS <RETURN> ' ) ;
                  BELLRI_Bell_Ring ;
                  BELLRI_Bell_Ring ;
                  READLN ;
                  { reset scroll }
                  SETSCR_Set_Scroll (1,24) ;
                  ERASCR_Erase_Screen ;
                  EP_Exit_Program;
               END
        ELSE CC_Chain_Commands ( Command_List, Num_Commands );

END; (* PROCEDURE CAP_Chain_a_Program *)
END.
