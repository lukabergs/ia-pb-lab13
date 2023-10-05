with P_Imagen_Escondida, Ada.Text_IO, Ada.Integer_Text_IO, Ada.Directories,
  NT_Console;
use P_Imagen_Escondida, Ada.Text_IO, Ada.Integer_Text_IO, Ada.Directories,
  NT_Console;
procedure pruebas is

   L_Pistas : T_Lista_E_Pistas;
   F, C     : Integer;
   Solucion : T_Lista_D_Pistas := null;
   Opcion   : Integer;
   type T_nombre_Fichero is record
      name : String (1 .. 100);
      long : Natural;
   end record;
   nombre_fichero : T_nombre_Fichero;
   ox, oy         : Integer;

   procedure Seleccionar_fichero
     (Extension, Directory : in String; nombre_fichero : out T_nombre_Fichero)
   is
      Ficheros : Search_Type;
      type T_L_Ficheros is array (1 .. 9) of Directory_Entry_Type;
      L_Juegos : T_L_Ficheros;
      I        : Integer;
      Opcion   : Integer;
   begin
      loop
         I := 0;
         Start_Search
           (Search  => Ficheros, Directory => Directory,
            Pattern => "*." & Extension,
            Filter  => (Ordinary_File => True, others => False));
         while More_Entries (Ficheros) and I < 9 loop
            I := I + 1;
            Get_Next_Entry (Ficheros, L_Juegos (I));
            Put (I, 2);
            Put (" ");
            Put_Line (Simple_Name (L_Juegos (I)));
         end loop;
         New_Line;
         Put ("Elige una opcion -> ");
         Get (Opcion);
         exit when Opcion in 1 .. I;
         Put_Line ("ERROR: Se esperaba un numero entre 1 y" & I'Img);
         New_Line;
      end loop;
      if Opcion > 0 then
         nombre_fichero.long                            :=
           Base_Name (Simple_Name (L_Juegos (Opcion)))'Length;
         nombre_fichero.name (1 .. nombre_fichero.long) :=
           Base_Name (Simple_Name (L_Juegos (Opcion)));
      end if;
   end Seleccionar_fichero;
begin
   loop
      Put_Line("              :::::::::: ::::::::::: :::        :::                         ");
      Put_Line("              :+:            :+:     :+:        :+:                         ");
      Put_Line("              +:+            +:+     +:+        +:+                         ");
      Put_Line("              :#::+::#       +#+     +#+        +#+                         ");
      Put_Line("              +#+            +#+     +#+        +#+                         ");
      Put_Line("              #+#            #+#     #+#        #+#                         ");
      Put_Line("              ###        ########### ########## ##########                  ");
      Put_Line("                                   :::                                      ");
      Put_Line("                                 :+: :+:                                    ");
      Put_Line("                                +:+   +:+                                   ");
      Put_Line("                 +#++:++#++:++ +#++:++#++: +#++:++#++:++                    ");
      Put_Line("                               +#+     +#+                                  ");
      Put_Line("                               #+#     #+#                                  ");
      Put_Line("                               ###     ###                                  ");
      Put_Line("::::::::: ::::::::::: :::::::: ::::::::::: :::    ::: :::::::::  :::::::::: ");
      Put_Line(":+:    :+:    :+:    :+:    :+:    :+:     :+:    :+: :+:    :+: :+:        ");
      Put_Line("+:+    +:+    +:+    +:+           +:+     +:+    +:+ +:+    +:+ +:+        ");
      Put_Line("+#++:++#+     +#+    +#+           +#+     +#+    +:+ +#++:++#:  +#++:++#   ");
      Put_Line("+#+           +#+    +#+           +#+     +#+    +#+ +#+    +#+ +#+        ");
      Put_Line("#+#           #+#    #+#    #+#    #+#     #+#    #+# #+#    #+# #+#        ");
      Put_Line("###       ########### ########     ###      ########  ###    ### ########## ");
      Put_Line("                                                                            ");
      Put_Line("--------------------------------------------------------------------------- ");
      Put_Line("                      AUTHOR : BERGARETXE LOPEZ, LUKA                       ");
      Put_Line("--------------------------------------------------------------------------- ");
      Put_Line("+================+");
      Put_Line("| MENU PRINCIPAL |");
      Put_Line("+================+");
      New_Line;
      Put_Line("[1] Resolver juego automaticamente");
      Put_Line("[2] Elegir y jugar a un juego");
      Put_Line("[3] Reanudar juego guardado");
      Put_Line("[4] Guardar juego");
      New_Line;
      ox := Where_X;
      oy := Where_Y;
      loop
         Put ("Elige una opcion [0 para salir]-> ");
         Get (Opcion);
         exit when Opcion in 0 .. 4;
         Goto_XY (ox, oy);
         Put_Line ("ERROR: Se esperaba un numero entre 0 y 4");
         delay (1.0);
         Goto_XY (ox, oy);
         Put ("                                                ");
         Goto_XY (ox, oy);
      end loop;
      exit when Opcion = 0;
      case Opcion is
         when 1 =>
            Seleccionar_fichero
              ("game", Current_Directory & "/games", nombre_fichero);
            Put
              ("Cargando " & nombre_fichero.name (1 .. nombre_fichero.long) &
               "...");
            New_Line;
            Iniciar_Juego
              (nombre_fichero.name (1 .. nombre_fichero.long), F, C, L_Pistas);
            Fase_1 (F, C, L_Pistas, Solucion);
         when 2 =>
            Seleccionar_fichero
              ("game", Current_Directory & "/games", nombre_fichero);
            Put
              ("Cargando " & nombre_fichero.name (1 .. nombre_fichero.long) &
               "...");
            New_Line;
            Iniciar_Juego
              (nombre_fichero.name (1 .. nombre_fichero.long), F, C, L_Pistas);
            Solucion := null;
            Fase_2 (F, C, L_Pistas, Solucion);
         when 3 =>
            Seleccionar_fichero
              ("sav", Current_Directory & "/saves", nombre_fichero);
            Put
              ("Reanudando " & nombre_fichero.name (1 .. nombre_fichero.long) &
               "...");
            New_Line;
            Reanudar_Juego
              (nombre_fichero.name (1 .. nombre_fichero.long), F, C, L_Pistas,
               Solucion);
            Fase_2 (F, C, L_Pistas, Solucion);
         when others =>
            if Exists
                (Compose
                   (Current_Directory & "/saves",
                   nombre_fichero.name (1 .. nombre_fichero.long), "sav"))
            then
               Put_Line
                 ("renombrando " &
                  nombre_fichero.name (1 .. nombre_fichero.long) & " a " &
                  Compose
                    (Current_Directory & "/saves",
                     nombre_fichero.name (1 .. nombre_fichero.long),
                     "old.game") &
                  "...");
               delay (1.0);
               if Exists
                   (Compose
                      (Current_Directory & "/saves",
                       nombre_fichero.name (1 .. nombre_fichero.long),
                       "old.sav"))
               then
                  Delete_File
                    (Compose
                       (Current_Directory & "/saves",
                        nombre_fichero.name (1 .. nombre_fichero.long),
                        "old.sav"));
                  Rename
                    (Compose
                       (Current_Directory & "/saves",
                        nombre_fichero.name (1 .. nombre_fichero.long), "sav"),
                     Compose
                       (Current_Directory & "/saves",
                        nombre_fichero.name (1 .. nombre_fichero.long),
                        "old.game"));
               end if;
            end if;
            Put_Line
              ("Guardando " &
               Compose
                 (Current_Directory & "/saves",
                   nombre_fichero.name (1 .. nombre_fichero.long), "sav"));
            delay (1.0);
            Guardar_Juego
              (nombre_fichero.name (1 .. nombre_fichero.long), F, C, L_Pistas,
               Solucion);
      end case;
   end loop;
   Put_Line ("Fin del programa");
end pruebas;
