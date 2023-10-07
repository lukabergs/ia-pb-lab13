package Lab13 is

   type T_Casilla is (Duda, Blanco, Negro);
   type T_contador is array (T_Casilla) of Natural;
   type T_Imagen is array (Integer range <>, Integer range <>) of T_Casilla;
   type T_Pista is record
      Fil, Col, Valor : Integer;
   end record;
   type T_Vector_pistas is array (Integer range <>) of T_Pista;
   type T_Lista_E_Pistas is record
      Cont : Natural;
      Rest : T_Vector_pistas (1 .. 1_000);
   end record;
   type T_Nodo_Pista;
   type T_Lista_D_Pistas is access T_Nodo_Pista;
   type T_Nodo_Pista is record
      Pista : T_Pista;
      Sig   : T_Lista_D_Pistas;
   end record;

   function Es_Lateral
     (Img : in T_Imagen; Fil, Col : in Positive) return Boolean;
   --Post: True <-> Fila y col es una posici�n Lateral de Img

   function Es_Esquina
     (Img : in T_Imagen; Fil, Col : in Positive) return Boolean;
   --Post: True <-> Fila y col es una posici�n de esquina de Img

   function Es_Interior
     (Img : in T_Imagen; Fil, Col : in Positive) return Boolean;
   --Post: True <-> Fila y col es una posici�n interior de Img

   function Imagen_vacia (filas, columnas : in Integer) return T_Imagen;
   --pre: filas, columnas > 0
   --post: resultado es una imagen de filas x columnas inicializada a dudas

   procedure Mostrar (Img : in T_Imagen);
   --Salida: Muestra en pantalla el contenido de la imagen oculta

   procedure Contar_cuadros
     (Img : in T_Imagen; Fil, Col : in Integer; Contador : out T_contador);
   -- Post: contador cuenta cuantas casillas blancas, negras y duda hay
   -- en las nueve (generalmente) casillas que designa el recuadro con
   -- centro en (fila, columna)

   function Completa (Img : in T_Imagen) return Boolean;
   --Post: Resultado=true <-> I es una imagen sin dudas

   procedure Colorear (Img : in out T_Imagen; P : in T_Pista);
   --pre: P es una pista que se puede resolver
   --Post: Imagen integra la pista dada

   procedure Mostrar (L : in T_Lista_E_Pistas);
   --Salida: Muestra en pantalla el contenido de las pistas

   procedure Anadir (L : in out T_Lista_E_Pistas; P : in T_Pista);
   --post: anade a L al final, la pista P

   procedure Borrar (L : in out T_Lista_E_Pistas; P : in T_Pista);
   --post: Borra de L la pista P

   procedure Buscar_Pista
     (Lp : in T_Lista_E_Pistas; Img : in T_Imagen; P : out T_Pista);
   --Post: P es una pista de LP que se puedde aplicar en Img

   function longitud (L : in T_Lista_D_Pistas) return Natural;
   --post: Resultado es el numero de elementos de L
   procedure Anadir (L : in out T_Lista_D_Pistas; P : in T_Pista);
   --post: anade a L al final, la pista P

   procedure Concatenar (L1, L2 : in out T_Lista_D_Pistas);
   --post: anade a L2 al final de L1
   procedure Mostrar (L : in T_Lista_D_Pistas);
   --Salida: Muestra en pantalla el contenido de las pistas de la solucion

   procedure Iniciar_Juego
     (Ruta : in     String; filas, columnas : out Integer;
      LP   :    out T_Lista_E_Pistas);
   -- Post: Carga el fichero indicado en ruta que tiene un juego
   --       Img tiene la imagen llena de dudas
   --       LP tiene la lista de pistas a resolver

   procedure Guardar_Juego
     (filename : in String; fils, cols : in Integer; Lp : in T_Lista_E_Pistas;
      LS       : in T_Lista_D_Pistas);
   -- Post: Guarda el fichero indicado en ruta el juego
   --       Img tiene la imagen llena de dudas
   --       LP tiene la lista de pistas que quedan por resolver
   --       LS tiene la lista de pistas ya resueltas en la imagen

   procedure Reanudar_Juego
     (filename : in     String; filas, columnas : out Integer;
      Lp       :    out T_Lista_E_Pistas; LS : out T_Lista_D_Pistas);
   -- Post: Carga el fichero indicado en ruta que tiene un juego
   --       Img tiene la imagen en el estado actual
   --       LP tiene la lista de pistas a resolver

   function Es_Posible_Resolver
     (Img : in T_Imagen; P : in T_Pista) return Boolean;
   -- Post: Resultado = true <-> si la pista P se puede resolver en
   --                            el estado actual de la imagen I

   procedure Obtener_Pista
     (Filas, Columnas : in Integer; Lp : in T_Lista_E_Pistas; P : out T_Pista);
   --Entrada: numeros de filas y columnas (en el teclado) terminado en un par que están entre 1..Filas y 1..Columnas
   --         y que exista una pista con ese numero de fila y de columna especificado
   --Datos: numero maximo de filas de filas y columnas aceptable
   --       Lista de pistas
   --Post: Devuelve la primera pista de LP cuya fila y columna se haya especificado por teclado y coincida

   function Resolver
     (Filas, Columnas : in Integer; Lp : in T_Lista_E_Pistas) return T_Imagen;
   --post: REsultado es la imagen que se obtiene al resolver el maximo de pistas de la lista LP
   --      (hasta que no se pueda ninguna mas o esté completa la imagen)

   procedure Fase_1
     (filas, columnas : in     Integer; Lp : in out T_Lista_E_Pistas;
      Sol             :    out T_Lista_D_Pistas);
   -- Post: LS es la lista de pistas que se pueden resolver de la imagen

   procedure Fase_2
     (filas, columnas : in     Integer; LP : in out T_Lista_E_Pistas;
      Sol             : in out T_Lista_D_Pistas);
   -- Post: Sol es la lista de pistas que se pueden resolver de la imagen

end Lab13;