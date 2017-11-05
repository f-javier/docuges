#******************************************************************************/
#****                     Script de Generacion de Tablas                   ****/
#******************************************************************************/

#****                                TIPOS                                 ****/
CREATE TABLE IF NOT EXISTS tipos (ID_TIPO INTEGER(11) NOT NULL AUTO_INCREMENT, NOMBRE CHAR(30), VISOR CHAR(100), UNIQUE INDEX ORDEN (ID_TIPO)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#****                                GRUPOS                                ****/
CREATE TABLE IF NOT EXISTS grupos (ID_GRUPO INTEGER(11) NOT NULL AUTO_INCREMENT, NOMBRE CHAR(20), UNIQUE INDEX ORDEN (ID_GRUPO)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#****                               SUBGRUPOS                              ****/
CREATE TABLE IF NOT EXISTS subgrupos (ID_SUBGRUPO INTEGER(11) NOT NULL AUTO_INCREMENT, NOMBRE CHAR(30), GRUPO_ID INTEGER, UNIQUE INDEX ORDEN (ID_SUBGRUPO)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#****                              DOCUMENTOS                              ****/
CREATE TABLE IF NOT EXISTS documentos (ID_DOCUMENTO INTEGER(11) NOT NULL AUTO_INCREMENT, FECHA DATE, DOCUMENTO CHAR(50), DESCRIPCION CHAR(50), DETALLE BLOB, SUBGRUPO_ID INTEGER, FORMATO_ID INTEGER, UNIQUE INDEX ORDEN (ID_DOCUMENTO)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
