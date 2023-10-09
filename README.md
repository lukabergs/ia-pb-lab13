# LABORATORIO 13
## Práctica - Juego imagen escondida
Se trata de un pasatiempo de lógica que forma una figura pixelada cuando se termina. El juego es similar al buscaminas, ya que se basa en una cuadrícula que esconde la imagen. El jugador de este solitario debe decidir qué cuadros se tienen que pintar de negro y cuáles no hasta que se tenga una visión completa de la figura.

![Fig. 1](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/9d889f1d-1806-4fc6-8b44-a71c8c2372c7)

Estos pasatiempos tienen un nivel avanzado en el que se tienen en cuenta la situación de varias pistas para decidir el color de una casilla, pero nosotros nos vamos a quedar con el nivel básico, en el que el pasatiempo se puede resolver mirando siempre los valores de una de las casillas. Se puede considerar una extensión de la práctica estos pasatiempos más complicados.

La figura anterior muestra el pasatiempo al comienzo, cuando aún no se ha decidido el color de ninguna casilla. Las dos siguientes muestran el puzzle en un estado intermedio durante el desarrollo, en el que ya se han decidido algunas casillas que permanecen desocupadas (marcadas con una X), y cuales pintadas de negro.

![Fig. 2](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/c09c0503-fdd7-4037-9e7b-0c975dcbb50b)

Finalmente, la figura siguiente muestra la figura final (¿un camión y un sol?) porque ya se ha decidido sobre si deben permanecer en blanco o negro todas las piezas.

![Fig. 3](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/c6abd1fb-8802-41b6-a928-8d2273605feb)

El método de resolución se puede describir con un pasatiempo más pequeño. Supongamos que partimos del pasatiempo de la figura 4. Las pistas nos indican cuantas casillas se deben colorear en un recuadro formado por 9 cuadritos: las casillas que rodean a una dada junto con dicha casilla. En el caso de los laterales, el número de casillas disminuye y en las esquinas aún más.

![Fig. 4](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/6dbebb90-5d35-4f12-9c82-07907cdf1ac5)

Un primer paso es identificar las posiciones de inicio, que son las casillas interiores con un 9, las laterales con un 6 y las de esquina con un 4. Se deben colorear todas esas casillas. Del mismo modo, las casillas interiores con un 0, indican que la casilla debe permanecer sin colorear, así como las circundantes.

En la casilla (2,2) hay un 9 luego todos los cuadros circundantes deben ser negros, como se muestra en las figuras 5 y 6.

![Figs. 5 y 6](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/caf3e588-afc1-4244-bbce-bbe8c4408bf0)

En la casilla (5,1) tenemos el mismo caso, pero aplicado a una esquina. Las esquinas solo delimitan 4 casillas, por lo que un 4 significa que las cuatro casillas afectadas se deben colorear (ver figuras 7 y 8).

![Figs. 7 y 8](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/673bba18-27c3-4451-a195-1973005dbd53)

A continuación, las casillas que ya hemos decidido que son blancas o no, nos pueden ayudar con el resto de las pistas. Por ejemplo, en la posición (3,2) se indica que alrededor tiene que haber 8 casillas coloreadas (y ya las hay), por lo que se puede decidir que la restante debe quedar en blanco (ver figuras 9 y 10).

![Figs. 9 y 10](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/822d147a-8a7b-49d8-ab53-ac0d3ba6fcd4)

Y lo mismo ocurre con la pista de la posición (3,3). Dice que debe haber 8 casillas de 9 pintadas y ya se sabe cuál es la que no se tiene que pintar, por lo que se puede colorear el resto de las casillas centradas en esa posición (figuras 11 y 12).


![Figs. 11 y 12](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/b92ce63c-9691-4d3a-9f8e-6779ee1ba3bf)

La pista de la posición (5,3) nos indica que de las seis casillas, deben estar coloreadas 5, y ya se sabe cuál es la que no, por lo que se pueden colorear el resto de las que aún no están decididas (figuras 13 y 14).

![Figs. 13 y 14](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/702bdacd-9849-4957-9c4f-86c6cf856a4a)

Lo mismo ocurre con la pista de la posición de esquina (1,5), que cubre un espacio en el que solo debe haber una casilla coloreada que ya está pintada, luego el resto deben permanecer en blanco (figuras 15 y 16).

![Figs. 15 y 16](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/52b3b0d6-223b-45a4-a7a6-c7ee535edb4b)

Finalmente, la pista de3 la posición (5,5), indica que en sus circundantes debe haber dos elementos pintados de negro, que ya están por lo que el resto deberá aparecer pintado de blanco (figuras 17 y 18).

![Figs. 17 y 18](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/6cf8cbcc-7038-4d46-9a24-4051065a18f9)

Y la pista de la posición (4,5) indica que a su alrededor debe haber cuatro casillas negras, solo hay tres y solo hay una posible sin decidir, por lo tanto, será negra.

![Figs. 19 y 20](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/3d5e7604-e635-40f1-a52d-4e7655feef22)

Llegando a la imagen final, que representa una casa.

![Fig. 21](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/c13dc090-d492-4ee8-afdb-90013c5ad413)

La práctica consiste en implementar varios subprogramas que se pueden utilizar en el desarrollo del juego. En el desarrollo se utilizarán la mayoría de los conceptos que se han visto en clase: Entrada/salida de datos. Se proporciona un tipo de datos para la implementación de los distintos subprogramas y se pide la realización de un programa que permita funcionar en dos modos: el modo automático que permite que sea el propio sistema descubra cuál es la solución del puzle y el modo interactivo que permite al usuario indicar una coordenada y decidir si es correcta o no. Así mismo, tiene que dar la posibilidad de guardar el estado actual de la partida para poder retomarlo en un momento posterior.
### Descripción del formato de entrada
Un juego se especifica mediante un par de enteros en una línea que representan el número de filas y de columnas que tiene la imagen. A continuación, tantas líneas como filas se indiquen, cada una con tantos caracteres como columnas. En las líneas estarán formadas por puntos o dígitos. El punto indica la ausencia de pista y un dígito entre 0 y 9 indica el valor de la pista en esa fila y esa columna del cuadro.

![Fig. 22](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/965ae04e-d6ce-41ec-8f72-a8c9e20e57a8)

### FASE 1 - Resolver el puzzle
Construir un programa que pregunta por el nombre de un fichero donde se especifica un juego (ver formato de entrada de datos), lo cargue en memoria en forma de una imagen sin resolver y una serie de pistas a utilizar para obtener la imagen. La imagen se guarda en una matriz bidimensional y las pistas sin resolver en una lista estática de pistas. Hasta conocer cómo se trabaja con ficheros en Ada, supón que los datos se escriben directamente en el teclado (para las pruebas puedes copiar el fichero de entrada y pegarlo con CTRL+V).

El programa, después debe ir resolviendo pistas y mostrando la evolución de la imagen a medida que se van resolviendo. Se resuelven las pistas hasta agotarlas o hasta que se detecte que no se puede avanzar en la resolución del puzle. En el último caso, se indica la situación y el programa se debe detener y no quedarse ciclando indefinidamente.

Antes de acabar, el programa debe mostrar las pistas que se han resuelto y en el orden en el que se han hecho y que, se tienen que ir almacenando en una lista dinámica.

### FASE 2 - Juego interactivo
En este caso el juego es el mismo, pero en lugar de resolver el juego el programa ayuda al usuario a resolver el puzle, además de ofrecer la posibilidad de guardar el estado del juego para reanudarlo con posterioridad. Para ayudar al usuario el programa debe mostrar el estado actual de la imagen y el de las pistas que aún no se han resuelto. El usuario elige una pista a resolver. El programa debe comprobar que la pista existe, debe comprobar que esa pista se puede resolver, y si es así, resolverla y mostrar la imagen y las pistas actualizadas. Así mismo, el programa debe detectar si no hay más pistas que se puedan resolver y avisar al usuario.

### Formato para guardar el estado de un juego y restaurarlo
Para guardar el estado de un juego, se guarda primero las dimensiones de la imagen: número de filas y columnas en sendos enteros en una línea, seguido del número de pistas que quedan por resolver. A continuación, se indica el número de pistas que quedan por resolver y tantos tríos de valores como pistas queden pendientes de resolver (en el texto se han tachado los que NO deberían aparecer por ya estar resueltos y se sombrean las pistas alternas para facilitar la lectura). Finalmente, aparece el número de pistas que ya se han resuelto y la lista de las pistas resueltas en el orden en que se resolvieron.

![Fig. 23](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/d303ac8f-807f-4514-a119-bce168c4ff24)

![Fig. 24](https://github.com/lukabergs/ia-pb-lab13/assets/52601751/c64dce95-0be8-4708-b08c-4cd1bc36a193)
