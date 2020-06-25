# Rubiks cube parser

Para resolver "puzles giratorios" como los cubos de rubik, se suele definir una notación estándard para ser usada por la comunidad y compartir algoritmos y soluciones. Para los cubos de rubik por ejemplo, esta notación consta de una letra:

(F)ront, (B)ack, (R)ight, (L)eft, (U)p, (D)own,

que indican una rotación de 90º en el sentido de las agujas del reloj de la cara correspondiente.

Estos movimientos se pueden extender o combinar para formar unos nuevos, lo cual se ve necesario cuantas más capas añadas al cubo. Por ejemplo:

* un apóstrofe (') después de un movimiento indica que la rotación es inversa a la habitual
* para los cubos 3x3x3, existe la notación (Lw) o 'Left wide', que indica que además de mover la capa izquierda hay que mover la central junto a ella.
* x, y o z indican que se rota el cubo entero alrededor de cada uno de esos ejes que lo atraviesan
* cualquier secuencia de movimientos entre paréntesis y con un multiplicador, por ejemplo, (R U R' U')x2 indica que ésta se debe repetir por el número indicado.
 

Mi programa analiza ficheros que contengan secuencias de movimientos. El analizador léxico convierte cada uno de estos movimientos y modificadores en tokens, incluyendo la sentencia de multiplicación.

El analizador sintáctico se encarga de que los tokens estén ordenados adecuadamente y que tengan sentido.

En un principio quería realizar la optimización de los movimientos desde las propias reglas de la grámatica: por ejemplo, si viene un movimiento seguido del mismo inverso estos se deberían anular. Sin embargo, no encontré la forma de hacerlo de manera que la optimización sea continua y se mantena la secuencialidad, por ejemplo en la cadena R U U' R' se anularían U con U' pero también deberían de anularse R con R' tras ello.

Por ello, acabé usando una lista o un stack en el que voy mirando el anterior movimiento antes de insertar uno, para realizar las optimizaciones oportunas.

La lista de movimientos de salida la usa la clase Rubik de los archivos rubiks.h y rubiks.cpp. Realmente no funcionan como debería ahora mismo, tiene un fallo de lógica al ejecutar los movimientos sobre el cubo. Se visualiza por consola.

# TODO
Arreglar la ejecución de movimientos sobre el cubo. Añadir  visualización 3D.

# Instrucciones

Linux. Para compilar y probar ejecutar "make" en el directorio
Ejecutar `rubiks` y escribir movimientos en la entrada estándard, o escribir en un archivo como `ejemplo_rubiks.txt` y usarlo como argumento: `./rubiks ejemplo_rubiks.txt`.

