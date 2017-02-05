# HackerBooks

Hola Fernando¡, buenas tardes desde España y buenos diás en San Francisco. Te respondo a las preguntas que he 
encontrado en el pdf.

A la hora de la descarga, he modificado el json para añadirle una propiedad (favorite,inicializado a false, en todos los libros)
y lo guardo así directamente en el sistema de ficheros (dentro del sandbox carpeta Documents). He preferido añadirle esta 
propiedad al json, en vez de añadirlo como un tag, dado que lo veo totalmente separado de la entidad Tag, porque es una 
propiedad del usuario.

Por otro lado, creo que lo suyo, y lo más óptimo, hubiese sido parsear el json e introducirlo en core data ( ó realm),
porque manejar ficheros (a parte de ser aburrido y un autentico coñazo) no te garantiza la atomicidad de una base de datos.

Cada vez que el usuario cambie el estado de un libro se envía una notificación. Esta notificación llega a mi controlador
de tabla modificando el estado y realiza una recarga utilizando gcd. Comencé utilizando un delegado pero a la hora
de utilizar un SplitViewController me dejó de funcionar, imagino que será por algún error o porqué ambos controladores están
separados....tengo que verlo. Pero sin duda, enviar una notificación es la mejor opción.

Para mí, volver a cargar datos en memoria que ya tenía no es lo correcto, pero tengo que investigar 
si puedo cambiar un registro (ó fila) en la tabla y que  se refresque únicamente ese registro ( no sé yo si esto es posible).
Por otro lado, y según he visto, no se dispara el consumo de memoria al recargar la tabla, así que lo veo viable¡.

Cada vez que el usuario seleccione un libro en el tableViewController se envía una notificación, en vez de un delegado,
porque puede tener diferentes controladores. Si utilizase un delegado, tan sólo podría enviar un evento a un único 
controlador.


## Extras
Le añadiría las siguientes funcionalidades:

      +Búsqueda por autores.
      +Evaluar al libro y añadir opiniones (tipo amazon)
      +Sección de novedades, es decir, en funcion de los libros que seleccione un usuario como sus favoritos,
       me gustara ofrecerle más libros similares con una preview, por si le interesa.

No puedo subir esta app a la apple store porque me echarían por cutre..... Pero se me ocurre que podramos monetizar esta app
en función de las descargas de los pdf's. Podríamos habilitar un apartado, para que el usuario registrase su tarjeta de 
crédito y cobrarle a luro (euro) las descargas de los pdf's.
       
## Mejoras
Tengo algunas cosas que mejorar ( y que sin duda voy a hacer), como la carga de las portadas de los libros  que no me ha 
quedado fina ( he modificado tu clase AsyncData, pero se me ha ocurrido una forma mejor...). Por otro lado, he visto 
que al pulsar sobre un libro, la animación del navigation controller no me funciona correctamente, 
pero sólo pasa aleatoriamente ( y no sé porque leches pasa....).

En fin, tengo que mejorar y trabajar menos.

Un saludo
David.
