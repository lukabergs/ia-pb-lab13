with ada.directories, ada.characters.handling, ada.integer_text_io, ada.text_io, nt_console;
use ada.directories, ada.characters.handling, ada.integer_text_io, ada.text_io, nt_console;

package body P_Imagen_Escondida is

   ------------------------------------
   -- AUTHOR: BERGARETXE LOPEZ, LUKA --
   ------------------------------------

   ----------------
   -- Es_Lateral --
   ----------------

   function Es_Lateral
     (Img:in T_Imagen;
      Fil,Col:in Positive)
      return Boolean
   is
      r : Boolean;
   begin
      if (Fil = Img'First(1) or Fil = Img'Last(1)) xor (Col = Img'First(2) or Col = Img'Last(2)) then
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
     (Img:in T_Imagen;
      Fil,Col:in Positive)
      return Boolean
   is
      r : Boolean;
   begin
      if (Fil = Img'First(1) or Fil = Img'Last(1)) and (Col = Img'First(2) or Col = Img'Last(2)) then
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
     (Img: in T_Imagen;
      Fil,Col: in Positive)
      return Boolean
   is
      r : Boolean;
   begin
      if (Fil = Img'First(1) or Fil = Img'Last(1)) or (Col = Img'First(2) or Col = Img'Last(2)) then
         r := False;
      else
         r := True;
      end if;
      return r;
   end Es_Interior;

   ------------------
   -- Imagen_vacia --
   ------------------

   function Imagen_vacia (filas,columnas: in Integer) return T_Imagen is
      r : T_Imagen(1..filas, 1..columnas);
   begin
      for i in 1..filas loop
         for j in 1..columnas loop
            r(i,j) := Duda;
         end loop;
      end loop;
      return r;
   end Imagen_vacia;

   -------------
   -- Mostrar --
   -------------

   procedure Mostrar (Img: in T_Imagen) is
   begin
      for i in Img'range(1) loop
         for j in Img'range(2) loop
            if Img(i,j) = Duda then
               Set_Background(Gray);
               Set_Foreground(Red);
            elsif Img(i,j) = Blanco then
               Set_Background(White);
               Set_Foreground(Black);
            else
               Set_Background(Black);
               Set_Foreground(White);
            end if;
            put(" ");
         end loop;
         new_line;
      end loop;
      Set_Background(Black);
      Set_Foreground(Gray);
   end mostrar;

   --------------------
   -- Contar_cuadros --
   --------------------

   procedure Contar_cuadros
     (Img: in T_Imagen;
      Fil, Col: in Integer;
      Contador: out T_contador)
   is
   begin
      Contador := (others => 0);
      for i in Fil-1..Fil+1 loop
         for j in Col-1..Col+1 loop
            if i in Img'range(1) and j in Img'range(2) then
               if Img(i,j) = Duda then
                  Contador(Duda) := Contador(Duda) + 1;
               elsif Img(i,j) = Blanco then
                  Contador(Blanco) := Contador(Blanco) + 1;
               else
                  Contador(Negro) := Contador(Negro) + 1;
               end if;
            end if;
         end loop;
      end loop;
   end Contar_cuadros;

   --------------
   -- Completa --
   --------------


   function Completa (Img: in T_Imagen) return Boolean is
      r : Boolean := True;
      i, j : Positive := 1;
   begin
      while r and i in Img'range(1) loop
         j := 1;
         while r and j in Img'range(2) loop
            r := Img(i,j) /= Duda;
            j := j + 1;
         end loop;
         i := i + 1;
      end loop;
      return r;
   end Completa;

   --------------
   -- Colorear --
   --------------

   procedure Colorear (Img: in out T_Imagen; P: in T_Pista) is
      cont : T_Contador;
      i : Integer := P.Fil - 1;
      j : Integer;
   begin
      Contar_cuadros(Img, P.Fil, P.Col, cont);
      if cont(Duda) > 0 then
         if P.Valor = 0 or P.Valor = cont(Blanco) then
            while i <= P.Fil + 1 and cont(Duda) > 0 loop
               if i in Img'range(1) then
                  j := P.Col - 1;
                  while j <= P.Col + 1 and cont(Duda) > 0 loop
                     if j in Img'range(2) then
                        if Img(i, j) = Duda then
                           Img(i, j) := Negro;
                           cont(Duda) := cont(Duda) - 1;
                        end if;
                     end if;
                     j := j + 1;
                  end loop;
               end if;
               i := i + 1;
            end loop;
         elsif P.Valor - cont(Blanco) = cont(Duda) then
            while i <= P.Fil + 1 and cont(Duda) > 0 loop
               if i in Img'range(1) then
                  j := P.Col - 1;
                  while j <= P.Col + 1 and cont(Duda) > 0 loop
                     if j in Img'range(2) then
                        if Img(i, j) = Duda then
                           Img(i, j) := Blanco;
                           cont(Duda) := cont(Duda) - 1;
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

   procedure Mostrar (L: in T_Lista_E_Pistas) is
      ox : constant Integer := Where_X;
      oy : constant Integer := Where_Y;
   begin
      for i in 1..L.Cont loop
         goto_xy(ox + L.Rest(i).Col - 1, oy + L.Rest(i).Fil - 1);
         put(character'val((L.Rest(i).Valor) + 48));
      end loop;
   end Mostrar;

   ------------
   -- Anadir --
   ------------

   procedure Anadir (L: in out T_Lista_E_Pistas; P: in T_Pista) is
   begin
      L.Cont := L.Cont + 1;
      L.Rest(L.Cont) := P;
   end Anadir;

   ------------
   -- Borrar --
   ------------

   procedure Borrar (L: in out T_Lista_E_Pistas; P: in T_Pista) is
      i : Integer := 1;
      r : Boolean := False;
   begin
      loop
         if L.Rest(i) = P then
            L.Rest(i..L.Cont) := L.Rest(i+1..L.Cont+1);
            L.Cont := L.Cont - 1;
            r := True;
         end if;
         exit when i >= L.Cont or r;
         i := i + 1;
      end loop;
   end Borrar;

   ------------------
   -- Buscar_Pista --
   ------------------

   procedure Buscar_Pista
     (Lp: in T_Lista_E_Pistas;
      Img: in T_Imagen;
      P: out T_Pista)
   is
      r : Boolean := False;
      i : Integer := Lp.Rest'first;
      cont : T_Contador;
   begin
      while not r and i <= Lp.Cont loop
         Contar_cuadros(Img, Lp.Rest(i).Fil, Lp.Rest(i).Col, cont);
         if lp.Rest(i).Valor = 0 or lp.Rest(i).Valor = cont(Blanco) or lp.Rest(i).Valor - cont(Blanco) = cont(Duda) then
            P := Lp.Rest(i);
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

   function longitud (L:in T_Lista_D_Pistas) return Natural is
      r : Natural := 0;
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

   procedure Anadir (L: in out T_Lista_D_Pistas; P: in T_Pista) is
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

   procedure Concatenar (L1,L2: in out T_Lista_D_Pistas) is
      a : T_Lista_D_Pistas;
   begin
      if L1 /= null then
         a := L1;
         while a.Sig /= null loop
            a := a.Sig;
         end loop;
         a.Sig := L2;
         L2 := null;
      end if;
   end Concatenar;

   -------------
   -- Mostrar --
   -------------

   procedure Mostrar (L: in T_Lista_D_Pistas) is
      a : T_Lista_D_Pistas := L;
   begin
      while a /= null loop
         goto_xy(a.Pista.Col - 1, a.Pista.Fil - 1);
         put(character'val((a.Pista.Valor) + 48));
         a := a.Sig;
      end loop;
   end Mostrar;

   -------------------
   -- Iniciar_Juego --
   -------------------

   procedure Iniciar_Juego
     (Ruta: in String;
      filas,columnas:  out Integer;
      LP :  out T_Lista_E_Pistas)
   is
      f1 : file_type;
      a : Character;
      i, j : Integer := 1;
   begin
      LP.cont := 0;
      open(f1, In_File,"games/" & Ruta & ".game");
      get(f1, filas);
      get(f1, columnas);
      while not end_of_file(f1) loop
         get(f1, a);
         if a in '0'..'9' then
            Anadir(LP, (i, j, (character'pos(a) - 48)));
         end if;
         if end_of_line(f1) then
            i := i + 1;
            j := 1;
         else
            j := j + 1;
         end if;
      end loop;
      close(f1);
   end Iniciar_Juego;

   -------------------
   -- Guardar_Juego --
   -------------------

   procedure Guardar_Juego
     (filename: in String;
      fils,cols:  in Integer;
      Lp :  in T_Lista_e_Pistas;
      LS :  in T_lista_D_Pistas)
   is
      f1 : file_type;
      a : T_Lista_D_Pistas := LS;
   begin
      if exists(filename) then
         open(f1, Out_File, "saves/" & filename & ".sav");
      else
         create(f1, Out_File, "saves/" & filename & ".sav");
      end if;
      put(f1, fils'img);
      put(f1, cols'img);
      new_line(f1);
      put(f1, Lp.Cont'img);
      new_line(f1);
      for i in Lp.Rest'first..Lp.Cont loop
         put(f1, Lp.Rest(i).Fil'img);
         put(f1, Lp.Rest(i).Col'img);
         put(f1, Lp.Rest(i).Valor'img);
      end loop;
      new_line(f1);
      put(f1, longitud(LS)'img);
      new_line(f1);
      if a /= null then
         loop
            put(f1, a.Pista.Fil'img);
            put(f1, a.Pista.Col'img);
            put(f1, a.Pista.Valor'img);
            exit when a.Sig = null;
            a := a.Sig;
         end loop;
      end if;
      close(f1);
   end Guardar_Juego;

   --------------------
   -- Reanudar_Juego --
   --------------------

   procedure Reanudar_Juego
     (filename: in String;
      filas, columnas:  out Integer;
      Lp :  out T_Lista_e_Pistas;
      LS :  out T_lista_D_Pistas)
   is
      f1 : file_type;
      j : Integer;
      P : T_Pista;
   begin
      LS := null;
      Lp.cont := 0;
      open(f1, In_File, "saves/" & filename & ".sav");
      get(f1, filas);
      get(f1, columnas);
      get(f1, j);
      for i in 1..j loop
         get(f1, P.Fil);
         get(f1, P.Col);
         get(f1, P.Valor);
         Anadir(Lp, P);
      end loop;
      get(f1, j);
      for i in 1..j loop
         get(f1, P.Fil);
         get(f1, P.Col);
         get(f1, P.Valor);
         Anadir(LS, P);
      end loop;
      close(f1);
   end Reanudar_Juego;

   -------------------------
   -- Es_Posible_Resolver --
   -------------------------

   function Es_Posible_Resolver
     (Img: in T_Imagen;
      P: in T_Pista)
      return Boolean
   is
      r : Boolean;
      cont : T_Contador;
   begin
      Contar_Cuadros(Img, P.Fil, P.Col, cont);
      if cont(Duda) = 0 then
         if cont(Blanco) > 0 or cont(Negro) > 0 then
            r := True;
         else
            r := False;
         end if;
      elsif P.Valor - cont(Blanco) = cont(Duda) or P.Valor = 0 or P.Valor = cont(Blanco) then
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
     (Filas,Columnas: in Integer;
      Lp: in T_Lista_E_Pistas;
      P: out T_Pista)
   is
      f, c, i : Integer;
      r : Boolean := False;
   begin
      get(f);
      get(c);
      if f in 1..Filas and c in 1..Columnas then
         i := 1;
         loop
            if lp.Rest(i).Fil = f and lp.Rest(i).Col = c then
               r := True;
            end if;
            exit when r or i = lp.Cont;
            i := i + 1;
         end loop;
      end if;
      if r then
         P := lp.Rest(i);
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
     (Filas, Columnas: in Integer;
      Lp: in T_Lista_E_Pistas)
      return T_Imagen
   is
      img : T_Imagen := Imagen_Vacia(Filas, Columnas);
      P : T_Pista;
      a : T_Lista_E_Pistas := Lp;
   begin
      loop
         Buscar_Pista(a, img, P);
         exit when Completa(img) or not Es_Posible_Resolver(img, P);
         Colorear(img, P);
         Borrar(a, P);
      end loop;
      return img;
   end Resolver;

   ------------
   -- Fase_1 --
   ------------

   procedure Fase_1
     (filas, columnas: in Integer;
      Lp:in out T_Lista_E_Pistas;
      Sol: out T_lista_D_Pistas)
   is
      img : T_Imagen := Imagen_Vacia(Filas, Columnas);
      P : T_Pista;
      r : Boolean := False;
      ox, oy : Integer;
      s, pr : character;
      res_prog : Boolean;
   begin
      Sol := null;
      new_line;
      ox := Where_X;
      oy := Where_Y;
      Mostrar(img);
      goto_xy(ox, oy);
      Mostrar(LP);
      loop
         goto_xy(ox, oy + filas + 1);
         put("Resolver progresivamente? <S/N>: ");
         get(pr);
         if to_lower(pr) = 's' then
            res_prog := True;
         elsif to_lower(pr) = 'n' then
            res_prog := False;
         else
            goto_xy(ox, oy + filas + 1);
            put("                                     ");
            goto_xy(ox, oy + filas + 1);
            put("Especifica una opcion valida. ");
            delay(1.0);
         end if;
         exit when to_lower(pr) = 's' or to_lower(pr) = 'n';
      end loop;
      goto_xy(ox, oy);
      if res_prog then
         loop
            Buscar_Pista(Lp, img, P);
            exit when r or not Es_Posible_Resolver(img, P);
            Colorear(img, P);
            Mostrar(img);
            goto_xy(ox, oy);
            Mostrar(LP);
            goto_xy(ox, oy);
            Anadir(Sol, P);
            Borrar(Lp, P);
            r := Completa(img);
         end loop;
         Mostrar(img);
      else
         loop
            Buscar_Pista(Lp, img, P);
            exit when r or not Es_Posible_Resolver(img, P);
            Colorear(img, P);
            Anadir(Sol, P);
            Borrar(Lp, P);
            r := Completa(img);
         end loop;
         Mostrar(img);
      end if;
      if r then
         goto_xy(ox, oy + filas + 1);
         put("                                     ");
         goto_xy(ox, oy + filas + 1);
         put_line("Imagen resuelta!");
      else
         goto_xy(ox, oy + filas + 1);
         put("                                     ");
         goto_xy(ox, oy + filas + 1);
         put_line("Imagen irresoluble.");
      end if;
      delay(1.0);
      loop
         goto_xy(ox, oy + filas + 1);
         put("                                     ");
         goto_xy(ox, oy + filas + 1);
         put("Salir del juego? <S/N>: ");
         get(s);
         if to_lower(s) = 's' then
            Clear_Screen(Black);
            Set_Foreground(Gray);
         elsif to_lower(s) /= 'n' then
            goto_xy(ox, oy + filas + 1);
            put("Especifica una opcion valida. ");
            delay(1.0);
         end if;
         exit when to_lower(s) = 's';
      end loop;
   end Fase_1;

   ------------
   -- Fase_2 --
   ------------

   procedure Fase_2
     (filas, columnas: in Integer;
      LP: in out T_Lista_E_Pistas;
      Sol: in out T_Lista_D_Pistas)
   is
      img : T_Imagen := Imagen_Vacia(filas, columnas);
      P : T_Pista;
      pc, fin, r, sa : Boolean := False;
      a : T_Lista_D_Pistas := Sol;
      g, s : character;
      ox : Integer;
      oy : Integer;
      filename : string(1..5);
   begin
      while a /= null loop
         Colorear(img, a.Pista);
         a := a.Sig;
      end loop;
      new_line;
      ox := Where_X;
      oy := Where_Y;
      Mostrar(img);
      goto_xy(ox, oy);
      Mostrar(LP);
      goto_xy(ox, oy);
      if LP.cont = 0 then
         if Completa(img) then
            goto_xy(ox, oy + filas + 1);
            put_line("Imagen resuelta!");
         else
            goto_xy(ox, oy + filas + 1);
            put_line("Imagen irresoluble.");
         end if;
      else
         loop
            Buscar_Pista(LP, img, P);
            if Es_Posible_Resolver(img, P) then
               pc := False;
               loop
                  goto_xy(ox, oy + filas + 1);
                  put("Introduce coords (F C) de pista [0 para guardar]: ");
                  Obtener_Pista(filas, columnas, LP, P);
                  if P.Fil = 0 then
                     goto_xy(ox, oy + filas + 1);
                     put("                                                                                 ");
                     goto_xy(ox, oy + filas + 1);
                     put("Introduce un nombre para el archivo de guardado (5 caracteres): ");
                     get(filename);
                     goto_xy(ox, oy + filas + 1);
                     Put("                                                                                                                 ");
                     goto_xy(ox, oy + filas + 1);
                     if exists(compose(Current_Directory & "/saves",filename,"sav")) then
                        Put_Line("Renombrando "& filename & ".sav" & " a " & filename & ".old.sav" & "...");
                        delay(1.0);
                        goto_xy(ox, oy + filas + 1);
                        Put("                                                                                                                 ");
                        goto_xy(ox, oy + filas + 1);
                        if exists(compose(Current_directory & "/saves",filename,"old.sav")) then
                           delete_file(compose(filename,"old.sav"));
                           rename(compose(Current_Directory & "/saves", filename,"sav"), compose(Current_directory & "/saves",filename,"old.sav"));
                        end if;
                     end if;
                     Put_Line("Guardando "& filename & ".sav" & "...");
                     delay(1.0);
                     Guardar_Juego(filename, filas, columnas, LP, Sol);
                     loop
                        goto_xy(ox, oy + filas + 1);
                        put("                                                                      ");
                        goto_xy(ox, oy + filas + 1);
                        put("Salir del juego? <S/N>: ");
                        get(s);
                        if to_lower(s) = 's' then
                           Clear_Screen(Black);
                           Set_Foreground(Gray);
                           sa := True;
                        elsif to_lower(s) /= 'n' then
                           goto_xy(ox, oy + filas + 1);
                           put("Especifica una opcion valida. ");
                           delay(1.0);
                        end if;
                        exit when to_lower(s) = 'n' or to_lower(s) = 's';
                     end loop;
                  end if;
                  if not sa and P.Fil /= 0 then
                     goto_xy(ox, oy + filas + 1);
                     if Es_Posible_Resolver(img, P) then
                        put("                                                                          ");
                        goto_xy(ox, oy + filas + 1);
                        put_line("Pista correcta!");
                        delay(1.0);
                        Colorear(img, P);
                        Anadir(Sol, P);
                        Borrar(Lp, P);
                        goto_xy(ox, oy);
                        Mostrar(img);
                        goto_xy(ox, oy);
                        Mostrar(LP);
                        r := Completa(img);
                        fin := r;
                        pc := True;
                     elsif P.Fil = -1 then
                        put("                                                                          ");
                        goto_xy(ox, oy + filas + 1);
                        put_line("No existe pista en las coordenadas introducidas.");
                        delay(1.0);
                     else
                        put("                                                                          ");
                        goto_xy(ox, oy + filas + 1);
                        put_line("Pista incorrecta.");
                        delay(1.0);
                     end if;
                  end if;
                  exit when pc or sa;
               end loop;
            else
               fin := true;
            end if;
            exit when fin or sa;
            goto_xy(ox, oy);
         end loop;
         if not sa then
            if r then
               goto_xy(ox, oy + filas + 1);
               put_line("Imagen resuelta!");
            else
               goto_xy(ox, oy + filas + 1);
               put_line("Imagen irresoluble.");
            end if;
            goto_xy(ox, oy);
            Mostrar(img);
         end if;
      end if;
      if not sa then
         delay(1.0);
         loop
            goto_xy(ox, oy + filas + 1);
            put("                                                                          ");
            goto_xy(ox, oy + filas + 1);
            put("Guardar progreso? <S/N>: ");
            get(g);
            if to_lower(g) = 's' then
               goto_xy(ox, oy + filas + 1);
               put("Introduce un nombre para el archivo de guardado (5 caracteres): ");
               get(filename);
               goto_xy(ox, oy + filas + 1);
               Put("                                                                                                                 ");
               goto_xy(ox, oy + filas + 1);
               if exists(compose(Current_Directory & "/saves",filename,"sav")) then
                  Put("Renombrando "& filename & ".sav" & " a " & filename & ".old.sav" & "...");
                  delay(1.0);
                  goto_xy(ox, oy + filas + 1);
                  Put("                                                             ");
                  goto_xy(ox, oy + filas + 1);
                  if exists(compose(Current_directory & "/saves",filename,"old.sav")) then
                     delete_file(compose(Current_directory & "/saves",filename,"old.sav"));
                     rename(compose(Current_Directory & "/saves", filename,"sav"),compose(Current_directory & "/saves",filename,"old.sav"));
                  end if;
               end if;
               Put("Guardando " & filename & ".sav" & "...");
               delay(1.0);
               Guardar_Juego(filename, filas, columnas, LP, Sol);
            elsif to_lower(g) /= 'n' then
               goto_xy(ox, oy + filas + 1);
               put("Especifica una opcion valida. ");
               delay(1.0);
            end if;
            exit when to_lower(g) = 's' or to_lower(g) = 'n';
         end loop;
         loop
            goto_xy(ox, oy + filas + 1);
            put("                                                                      ");
            goto_xy(ox, oy + filas + 1);
            put("Salir del juego? <S/N>: ");
            get(s);
            if to_lower(s) = 's' then
               Clear_Screen(Black);
               Set_Foreground(Gray);
            elsif to_lower(s) /= 'n' then
               goto_xy(ox, oy + filas + 1);
               put("Especifica una opcion valida. ");
               delay(1.0);
            end if;
            exit when to_lower(s) = 's';
         end loop;
      end if;
   end Fase_2;
end P_Imagen_Escondida;
