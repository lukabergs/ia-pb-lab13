with Ada.Directories, Ada.Characters.Handling, Ada.Integer_Text_IO,
  Ada.Text_IO, NT_Console;
use Ada.Directories, Ada.Characters.Handling, Ada.Integer_Text_IO, Ada.Text_IO,
  NT_Console;

package body Lab13 is

   ------------------------------------
   -- AUTHOR: BERGARETXE LOPEZ, LUKA --
   ------------------------------------

   ----------------
   -- Es_Lateral --
   ----------------

   function Es_Lateral
     (Img : in T_Imagen; Fil, Col : in Positive) return Boolean
   is
      r : Boolean;
   begin
      if (Fil = Img'First (1) or Fil = Img'Last (1)) xor
        (Col = Img'First (2) or Col = Img'Last (2))
      then
         r := True;
      else
         r := False;
      end if;
      return r;
   end Es_Lateral;

   ----------------
   -- Es_Esquina --
   ----------------

   function Es_Esquina
     (Img : in T_Imagen; Fil, Col : in Positive) return Boolean
   is
      r : Boolean;
   begin
      if (Fil = Img'First (1) or Fil = Img'Last (1)) and
        (Col = Img'First (2) or Col = Img'Last (2))
      then
         r := True;
      else
         r := False;
      end if;
      return r;
   end Es_Esquina;

   -----------------
   -- Es_Interior --
   -----------------

   function Es_Interior
     (Img : in T_Imagen; Fil, Col : in Positive) return Boolean
   is
      r : Boolean;
   begin
      if (Fil = Img'First (1) or Fil = Img'Last (1)) or
        (Col = Img'First (2) or Col = Img'Last (2))
      then
         r := False;
      else
         r := True;
      end if;
      return r;
   end Es_Interior;

   ------------------
   -- Imagen_vacia --
   ------------------

   function Imagen_vacia (filas, columnas : in Integer) return T_Imagen is
      r : T_Imagen (1 .. filas, 1 .. columnas);
   begin
      for i in 1 .. filas loop
         for j in 1 .. columnas loop
            r (i, j) := Duda;
         end loop;
      end loop;
      return r;
   end Imagen_vacia;

   -------------
   -- Mostrar --
   -------------

   procedure Mostrar (Img : in T_Imagen) is
   begin
      for i in Img'Range (1) loop
         for j in Img'Range (2) loop
            if Img (i, j) = Duda then
               Set_Background (Gray);
               Set_Foreground (Red);
            elsif Img (i, j) = Blanco then
               Set_Background (White);
               Set_Foreground (Black);
            else
               Set_Background (Black);
               Set_Foreground (White);
            end if;
            Put (" ");
         end loop;
         New_Line;
      end loop;
      Set_Background (Black);
      Set_Foreground (Gray);
   end Mostrar;

   --------------------
   -- Contar_cuadros --
   --------------------

   procedure Contar_cuadros
     (Img : in T_Imagen; Fil, Col : in Integer; Contador : out T_contador)
   is
   begin
      Contador := (others => 0);
      for i in Fil - 1 .. Fil + 1 loop
         for j in Col - 1 .. Col + 1 loop
            if i in Img'Range (1) and j in Img'Range (2) then
               if Img (i, j) = Duda then
                  Contador (Duda) := Contador (Duda) + 1;
               elsif Img (i, j) = Blanco then
                  Contador (Blanco) := Contador (Blanco) + 1;
               else
                  Contador (Negro) := Contador (Negro) + 1;
               end if;
            end if;
         end loop;
      end loop;
   end Contar_cuadros;

   --------------
   -- Completa --
   --------------

   function Completa (Img : in T_Imagen) return Boolean is
      r    : Boolean  := True;
      i, j : Positive := 1;
   begin
      while r and i in Img'Range (1) loop
         j := 1;
         while r and j in Img'Range (2) loop
            r := Img (i, j) /= Duda;
            j := j + 1;
         end loop;
         i := i + 1;
      end loop;
      return r;
   end Completa;

   --------------
   -- Colorear --
   --------------

   procedure Colorear (Img : in out T_Imagen; P : in T_Pista) is
      cont : T_contador;
      i    : Integer := P.Fil - 1;
      j    : Integer;
   begin
      Contar_cuadros (Img, P.Fil, P.Col, cont);
      if cont (Duda) > 0 then
         if P.Valor = 0 or P.Valor = cont (Blanco) then
            while i <= P.Fil + 1 and cont (Duda) > 0 loop
               if i in Img'Range (1) then
                  j := P.Col - 1;
                  while j <= P.Col + 1 and cont (Duda) > 0 loop
                     if j in Img'Range (2) then
                        if Img (i, j) = Duda then
                           Img (i, j)  := Negro;
                           cont (Duda) := cont (Duda) - 1;
                        end if;
                     end if;
                     j := j + 1;
                  end loop;
               end if;
               i := i + 1;
            end loop;
         elsif P.Valor - cont (Blanco) = cont (Duda) then
            while i <= P.Fil + 1 and cont (Duda) > 0 loop
               if i in Img'Range (1) then
                  j := P.Col - 1;
                  while j <= P.Col + 1 and cont (Duda) > 0 loop
                     if j in Img'Range (2) then
                        if Img (i, j) = Duda then
                           Img (i, j)  := Blanco;
                           cont (Duda) := cont (Duda) - 1;
                        end if;
                     end if;
                     j := j + 1;
                  end loop;
               end if;
               i := i + 1;
            end loop;
         end if;
      end if;
   end Colorear;

   -------------
   -- Mostrar --
   -------------

   procedure Mostrar (L : in T_Lista_E_Pistas) is
      ox : constant Integer := Where_X;
      oy : constant Integer := Where_Y;
   begin
      for i in 1 .. L.Cont loop
         Goto_XY (ox + L.Rest (i).Col - 1, oy + L.Rest (i).Fil - 1);
         Put (Character'Val ((L.Rest (i).Valor) + 48));
      end loop;
   end Mostrar;

   ------------
   -- Anadir --
   ------------

   procedure Anadir (L : in out T_Lista_E_Pistas; P : in T_Pista) is
   begin
      L.Cont          := L.Cont + 1;
      L.Rest (L.Cont) := P;
   end Anadir;

   ------------
   -- Borrar --
   ------------

   procedure Borrar (L : in out T_Lista_E_Pistas; P : in T_Pista) is
      i : Integer := 1;
      r : Boolean := False;
   begin
      loop
         if L.Rest (i) = P then
            L.Rest (i .. L.Cont) := L.Rest (i + 1 .. L.Cont + 1);
            L.Cont               := L.Cont - 1;
            r                    := True;
         end if;
         exit when i >= L.Cont or r;
         i := i + 1;
      end loop;
   end Borrar;

   ------------------
   -- Buscar_Pista --
   ------------------

   procedure Buscar_Pista
     (Lp : in T_Lista_E_Pistas; Img : in T_Imagen; P : out T_Pista)
   is
      r    : Boolean := False;
      i    : Integer := Lp.Rest'First;
      cont : T_contador;
   begin
      while not r and i <= Lp.Cont loop
         Contar_cuadros (Img, Lp.Rest (i).Fil, Lp.Rest (i).Col, cont);
         if Lp.Rest (i).Valor = 0 or Lp.Rest (i).Valor = cont (Blanco) or
           Lp.Rest (i).Valor - cont (Blanco) = cont (Duda)
         then
            P := Lp.Rest (i);
            r := True;
         end if;
         i := i + 1;
      end loop;
      if not r then
         P := (-1, -1, 0);
      end if;
   end Buscar_Pista;

   --------------
   -- longitud --
   --------------

   function longitud (L : in T_Lista_D_Pistas) return Natural is
      r : Natural          := 0;
      a : T_Lista_D_Pistas := L;
   begin
      if a /= null then
         loop
            r := r + 1;
            exit when a.Sig = null;
            a := a.Sig;
         end loop;
      end if;
      return r;
   end longitud;

   ------------
   -- Anadir --
   ------------

   procedure Anadir (L : in out T_Lista_D_Pistas; P : in T_Pista) is
      a : T_Lista_D_Pistas := L;
   begin
      if L /= null then
         a := L;
         while a.Sig /= null loop
            a := a.Sig;
         end loop;
         a.Sig := new T_Nodo_Pista'(P, null);
      else
         L := new T_Nodo_Pista'(P, null);
      end if;
   end Anadir;

   ----------------
   -- Concatenar --
   ----------------

   procedure Concatenar (L1, L2 : in out T_Lista_D_Pistas) is
      a : T_Lista_D_Pistas;
   begin
      if L1 /= null then
         a := L1;
         while a.Sig /= null loop
            a := a.Sig;
         end loop;
         a.Sig := L2;
         L2    := null;
      end if;
   end Concatenar;

   -------------
   -- Mostrar --
   -------------

   procedure Mostrar (L : in T_Lista_D_Pistas) is
      a : T_Lista_D_Pistas := L;
   begin
      while a /= null loop
         Goto_XY (a.Pista.Col - 1, a.Pista.Fil - 1);
         Put (Character'Val ((a.Pista.Valor) + 48));
         a := a.Sig;
      end loop;
   end Mostrar;

   -------------------
   -- Iniciar_Juego --
   -------------------

   procedure Iniciar_Juego
     (Ruta : in     String; filas, columnas : out Integer;
      LP   :    out T_Lista_E_Pistas)
   is
      f1   : File_Type;
      a    : Character;
      i, j : Integer := 1;
   begin
      LP.Cont := 0;
      Open (f1, In_File, "games/" & Ruta & ".game");
      Get (f1, filas);
      Get (f1, columnas);
      while not End_Of_File (f1) loop
         Get (f1, a);
         if a in '0' .. '9' then
            Anadir (LP, (i, j, (Character'Pos (a) - 48)));
         end if;
         if End_Of_Line (f1) then
            i := i + 1;
            j := 1;
         else
            j := j + 1;
         end if;
      end loop;
      Close (f1);
   end Iniciar_Juego;

   -------------------
   -- Guardar_Juego --
   -------------------

   procedure Guardar_Juego
     (filename : in String; fils, cols : in Integer; Lp : in T_Lista_E_Pistas;
      LS       : in T_Lista_D_Pistas)
   is
      f1 : File_Type;
      a  : T_Lista_D_Pistas := LS;
   begin
      if Exists (filename) then
         Open (f1, Out_File, "saves/" & filename & ".sav");
      else
         Create (f1, Out_File, "saves/" & filename & ".sav");
      end if;
      Put (f1, fils'Img);
      Put (f1, cols'Img);
      New_Line (f1);
      Put (f1, Lp.Cont'Img);
      New_Line (f1);
      for i in Lp.Rest'First .. Lp.Cont loop
         Put (f1, Lp.Rest (i).Fil'Img);
         Put (f1, Lp.Rest (i).Col'Img);
         Put (f1, Lp.Rest (i).Valor'Img);
      end loop;
      New_Line (f1);
      Put (f1, longitud (LS)'Img);
      New_Line (f1);
      if a /= null then
         loop
            Put (f1, a.Pista.Fil'Img);
            Put (f1, a.Pista.Col'Img);
            Put (f1, a.Pista.Valor'Img);
            exit when a.Sig = null;
            a := a.Sig;
         end loop;
      end if;
      Close (f1);
   end Guardar_Juego;

   --------------------
   -- Reanudar_Juego --
   --------------------

   procedure Reanudar_Juego
     (filename : in     String; filas, columnas : out Integer;
      Lp       :    out T_Lista_E_Pistas; LS : out T_Lista_D_Pistas)
   is
      f1 : File_Type;
      j  : Integer;
      P  : T_Pista;
   begin
      LS      := null;
      Lp.Cont := 0;
      Open (f1, In_File, "saves/" & filename & ".sav");
      Get (f1, filas);
      Get (f1, columnas);
      Get (f1, j);
      for i in 1 .. j loop
         Get (f1, P.Fil);
         Get (f1, P.Col);
         Get (f1, P.Valor);
         Anadir (Lp, P);
      end loop;
      Get (f1, j);
      for i in 1 .. j loop
         Get (f1, P.Fil);
         Get (f1, P.Col);
         Get (f1, P.Valor);
         Anadir (LS, P);
      end loop;
      Close (f1);
   end Reanudar_Juego;

   -------------------------
   -- Es_Posible_Resolver --
   -------------------------

   function Es_Posible_Resolver
     (Img : in T_Imagen; P : in T_Pista) return Boolean
   is
      r    : Boolean;
      cont : T_contador;
   begin
      Contar_cuadros (Img, P.Fil, P.Col, cont);
      if cont (Duda) = 0 then
         if cont (Blanco) > 0 or cont (Negro) > 0 then
            r := True;
         else
            r := False;
         end if;
      elsif P.Valor - cont (Blanco) = cont (Duda) or P.Valor = 0 or
        P.Valor = cont (Blanco)
      then
         r := True;
      else
         r := False;
      end if;
      return r;
   end Es_Posible_Resolver;

   -------------------
   -- Obtener_Pista --
   -------------------

   procedure Obtener_Pista
     (Filas, Columnas : in Integer; Lp : in T_Lista_E_Pistas; P : out T_Pista)
   is
      f, c, i : Integer;
      r       : Boolean := False;
   begin
      Get (f);
      Get (c);
      if f in 1 .. Filas and c in 1 .. Columnas then
         i := 1;
         loop
            if Lp.Rest (i).Fil = f and Lp.Rest (i).Col = c then
               r := True;
            end if;
            exit when r or i = Lp.Cont;
            i := i + 1;
         end loop;
      end if;
      if r then
         P := Lp.Rest (i);
      elsif f = 0 or c = 0 then
         P := (0, 0, 0);
      else
         P := (-1, -1, 0);
      end if;
   end Obtener_Pista;

   --------------
   -- Resolver --
   --------------

   function Resolver
     (Filas, Columnas : in Integer; Lp : in T_Lista_E_Pistas) return T_Imagen
   is
      img : T_Imagen         := Imagen_vacia (Filas, Columnas);
      P   : T_Pista;
      a   : T_Lista_E_Pistas := Lp;
   begin
      loop
         Buscar_Pista (a, img, P);
         exit when Completa (img) or not Es_Posible_Resolver (img, P);
         Colorear (img, P);
         Borrar (a, P);
      end loop;
      return img;
   end Resolver;

   ------------
   -- Fase_1 --
   ------------

   procedure Fase_1
     (filas, columnas : in     Integer; Lp : in out T_Lista_E_Pistas;
      Sol             :    out T_Lista_D_Pistas)
   is
      img      : T_Imagen := Imagen_vacia (filas, columnas);
      P        : T_Pista;
      r        : Boolean  := False;
      ox, oy   : Integer;
      s, pr    : Character;
      res_prog : Boolean;
   begin
      Sol := null;
      New_Line;
      ox := Where_X;
      oy := Where_Y;
      Mostrar (img);
      Goto_XY (ox, oy);
      Mostrar (Lp);
      loop
         Goto_XY (ox, oy + filas + 1);
         Put ("Resolver progresivamente? <S/N>: ");
         Get (pr);
         if To_Lower (pr) = 's' then
            res_prog := True;
         elsif To_Lower (pr) = 'n' then
            res_prog := False;
         else
            Goto_XY (ox, oy + filas + 1);
            Put ("                                     ");
            Goto_XY (ox, oy + filas + 1);
            Put ("Especifica una opcion valida. ");
            delay (1.0);
         end if;
         exit when To_Lower (pr) = 's' or To_Lower (pr) = 'n';
      end loop;
      Goto_XY (ox, oy);
      if res_prog then
         loop
            Buscar_Pista (Lp, img, P);
            exit when r or not Es_Posible_Resolver (img, P);
            Colorear (img, P);
            Mostrar (img);
            Goto_XY (ox, oy);
            Mostrar (Lp);
            Goto_XY (ox, oy);
            Anadir (Sol, P);
            Borrar (Lp, P);
            r := Completa (img);
         end loop;
         Mostrar (img);
      else
         loop
            Buscar_Pista (Lp, img, P);
            exit when r or not Es_Posible_Resolver (img, P);
            Colorear (img, P);
            Anadir (Sol, P);
            Borrar (Lp, P);
            r := Completa (img);
         end loop;
         Mostrar (img);
      end if;
      if r then
         Goto_XY (ox, oy + filas + 1);
         Put ("                                     ");
         Goto_XY (ox, oy + filas + 1);
         Put_Line ("Imagen resuelta!");
      else
         Goto_XY (ox, oy + filas + 1);
         Put ("                                     ");
         Goto_XY (ox, oy + filas + 1);
         Put_Line ("Imagen irresoluble.");
      end if;
      delay (1.0);
      loop
         Goto_XY (ox, oy + filas + 1);
         Put ("                                     ");
         Goto_XY (ox, oy + filas + 1);
         Put ("Salir del juego? <S/N>: ");
         Get (s);
         if To_Lower (s) = 's' then
            Clear_Screen (Black);
            Set_Foreground (Gray);
         elsif To_Lower (s) /= 'n' then
            Goto_XY (ox, oy + filas + 1);
            Put ("Especifica una opcion valida. ");
            delay (1.0);
         end if;
         exit when To_Lower (s) = 's';
      end loop;
   end Fase_1;

   ------------
   -- Fase_2 --
   ------------

   procedure Fase_2
     (filas, columnas : in     Integer; LP : in out T_Lista_E_Pistas;
      Sol             : in out T_Lista_D_Pistas)
   is
      img            : T_Imagen         := Imagen_vacia (filas, columnas);
      P              : T_Pista;
      pc, fin, r, sa : Boolean          := False;
      a              : T_Lista_D_Pistas := Sol;
      g, s           : Character;
      ox             : Integer;
      oy             : Integer;
      filename       : String (1 .. 5);
   begin
      while a /= null loop
         Colorear (img, a.Pista);
         a := a.Sig;
      end loop;
      New_Line;
      ox := Where_X;
      oy := Where_Y;
      Mostrar (img);
      Goto_XY (ox, oy);
      Mostrar (LP);
      Goto_XY (ox, oy);
      if LP.Cont = 0 then
         if Completa (img) then
            Goto_XY (ox, oy + filas + 1);
            Put_Line ("Imagen resuelta!");
         else
            Goto_XY (ox, oy + filas + 1);
            Put_Line ("Imagen irresoluble.");
         end if;
      else
         loop
            Buscar_Pista (LP, img, P);
            if Es_Posible_Resolver (img, P) then
               pc := False;
               loop
                  Goto_XY (ox, oy + filas + 1);
                  Put ("Introduce coords (F C) de pista [0 para guardar]: ");
                  Obtener_Pista (filas, columnas, LP, P);
                  if P.Fil = 0 then
                     Goto_XY (ox, oy + filas + 1);
                     Put
                       ("                                                                                 ");
                     Goto_XY (ox, oy + filas + 1);
                     Put
                       ("Introduce un nombre para el archivo de guardado (5 caracteres): ");
                     Get (filename);
                     Goto_XY (ox, oy + filas + 1);
                     Put
                       ("                                                                                                                 ");
                     Goto_XY (ox, oy + filas + 1);
                     if Exists
                         (Compose
                            (Current_Directory & "/saves", filename, "sav"))
                     then
                        Put_Line
                          ("Renombrando " & filename & ".sav" & " a " &
                           filename & ".old.sav" & "...");
                        delay (1.0);
                        Goto_XY (ox, oy + filas + 1);
                        Put
                          ("                                                                                                                 ");
                        Goto_XY (ox, oy + filas + 1);
                        if Exists
                            (Compose
                               (Current_Directory & "/saves", filename,
                                  "old.sav"))
                        then
                           Delete_File (Compose (filename, "old.sav"));
                           Rename
                             (Compose
                                (Current_Directory & "/saves", filename,
                                 "sav"),
                              Compose
                                (Current_Directory & "/saves", filename,
                                 "old.sav"));
                        end if;
                     end if;
                     Put_Line ("Guardando " & filename & ".sav" & "...");
                     delay (1.0);
                     Guardar_Juego (filename, filas, columnas, LP, Sol);
                     loop
                        Goto_XY (ox, oy + filas + 1);
                        Put
                          ("                                                                      ");
                        Goto_XY (ox, oy + filas + 1);
                        Put ("Salir del juego? <S/N>: ");
                        Get (s);
                        if To_Lower (s) = 's' then
                           Clear_Screen (Black);
                           Set_Foreground (Gray);
                           sa := True;
                        elsif To_Lower (s) /= 'n' then
                           Goto_XY (ox, oy + filas + 1);
                           Put ("Especifica una opcion valida. ");
                           delay (1.0);
                        end if;
                        exit when To_Lower (s) = 'n' or To_Lower (s) = 's';
                     end loop;
                  end if;
                  if not sa and P.Fil /= 0 then
                     Goto_XY (ox, oy + filas + 1);
                     if Es_Posible_Resolver (img, P) then
                        Put
                          ("                                                                          ");
                        Goto_XY (ox, oy + filas + 1);
                        Put_Line ("Pista correcta!");
                        delay (1.0);
                        Colorear (img, P);
                        Anadir (Sol, P);
                        Borrar (LP, P);
                        Goto_XY (ox, oy);
                        Mostrar (img);
                        Goto_XY (ox, oy);
                        Mostrar (LP);
                        r   := Completa (img);
                        fin := r;
                        pc  := True;
                     elsif P.Fil = -1 then
                        Put
                          ("                                                                          ");
                        Goto_XY (ox, oy + filas + 1);
                        Put_Line
                          ("No existe pista en las coordenadas introducidas.");
                        delay (1.0);
                     else
                        Put
                          ("                                                                          ");
                        Goto_XY (ox, oy + filas + 1);
                        Put_Line ("Pista incorrecta.");
                        delay (1.0);
                     end if;
                  end if;
                  exit when pc or sa;
               end loop;
            else
               fin := True;
            end if;
            exit when fin or sa;
            Goto_XY (ox, oy);
         end loop;
         if not sa then
            if r then
               Goto_XY (ox, oy + filas + 1);
               Put_Line ("Imagen resuelta!");
            else
               Goto_XY (ox, oy + filas + 1);
               Put_Line ("Imagen irresoluble.");
            end if;
            Goto_XY (ox, oy);
            Mostrar (img);
         end if;
      end if;
      if not sa then
         delay (1.0);
         loop
            Goto_XY (ox, oy + filas + 1);
            Put
              ("                                                                          ");
            Goto_XY (ox, oy + filas + 1);
            Put ("Guardar progreso? <S/N>: ");
            Get (g);
            if To_Lower (g) = 's' then
               Goto_XY (ox, oy + filas + 1);
               Put
                 ("Introduce un nombre para el archivo de guardado (5 caracteres): ");
               Get (filename);
               Goto_XY (ox, oy + filas + 1);
               Put
                 ("                                                                                                                 ");
               Goto_XY (ox, oy + filas + 1);
               if Exists
                   (Compose (Current_Directory & "/saves", filename, "sav"))
               then
                  Put
                    ("Renombrando " & filename & ".sav" & " a " & filename &
                     ".old.sav" & "...");
                  delay (1.0);
                  Goto_XY (ox, oy + filas + 1);
                  Put
                    ("                                                             ");
                  Goto_XY (ox, oy + filas + 1);
                  if Exists
                      (Compose
                         (Current_Directory & "/saves", filename, "old.sav"))
                  then
                     Delete_File
                       (Compose
                          (Current_Directory & "/saves", filename, "old.sav"));
                     Rename
                       (Compose
                          (Current_Directory & "/saves", filename, "sav"),
                        Compose
                          (Current_Directory & "/saves", filename, "old.sav"));
                  end if;
               end if;
               Put ("Guardando " & filename & ".sav" & "...");
               delay (1.0);
               Guardar_Juego (filename, filas, columnas, LP, Sol);
            elsif To_Lower (g) /= 'n' then
               Goto_XY (ox, oy + filas + 1);
               Put ("Especifica una opcion valida. ");
               delay (1.0);
            end if;
            exit when To_Lower (g) = 's' or To_Lower (g) = 'n';
         end loop;
         loop
            Goto_XY (ox, oy + filas + 1);
            Put
              ("                                                                      ");
            Goto_XY (ox, oy + filas + 1);
            Put ("Salir del juego? <S/N>: ");
            Get (s);
            if To_Lower (s) = 's' then
               Clear_Screen (Black);
               Set_Foreground (Gray);
            elsif To_Lower (s) /= 'n' then
               Goto_XY (ox, oy + filas + 1);
               Put ("Especifica una opcion valida. ");
               delay (1.0);
            end if;
            exit when To_Lower (s) = 's';
         end loop;
      end if;
   end Fase_2;
end Lab13;
