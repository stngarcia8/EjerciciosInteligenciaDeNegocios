Alumno: Daniel Garcia Loyola.
Fecha entrega: 11/09/2019.
Ramo: Inteligencia de negocio.
Profesor: Cristian salazar.

Archivos incluidos:
1. Modelo relacional (imagen01-modeloRelacional.png, script01-modeloRelacional.sql)
2. Modelo estrella (imagen02-modeloDimensional-star.png, script02-modeloDimensional-star.sql)
3. Modelo copo de nieve (imagen03-modeloDimensional-snowflake.png, script03-modeloDimensional-snowflake.sql)

Notas de los script:
Para la creación de las bases de datos, fue realizado solamente con el comando create database sin parametros adicionales de nombre de archivo, incremento, tamaño y tamaño maximo, debido a que trabajo con contenedores docker, este contenedor esta corriendo bajo linux (ubuntu 16.x)  por lo tanto, la ruta que debe ser definida en el parametro filename del comando create, debe ser una ruta linux (/var/opt/mssql/data), por esto no lo inclui ya que puede traer inconvenientes al momento de ejecutar los script en sql server instalado en windows, entonces cuando los ejecute, el motor instalado indicará la ruta correspondiente sin problemas.

Notas de los diagramas:
No podía ordenar de buena forma las tablas en el diagrama, para no perder el tiempo intentando mover cajitas de un lado a otro, me salía más fácil dejar estas tan solo con el nombre, esto lo realicé haciendo click con el boton derecho en la zona del diagrama, luego seleccioné la opción "vista de tablas" y por último "solo nombre",  asi pude ordenar el monito lo mejor posible, en los modelos dimensionales, la unica tabla que esta expandida es la tabla de hechos para que pueda visualizarse de mejor manera.

