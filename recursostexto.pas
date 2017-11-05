{
  DocuGes - Gestion Documental

  Autor: Fco. Javier Perez Vidal  <developer at f-javier dot es>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit recursostexto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

resourcestring
  rsConexionEstablecida = 'Conexión establecida satisafactoriamente';
  rsImposibleConexion = 'Imposible establecer conexión' + #13 + 'Revise la información';
  rsFicheroNoExiste = 'EL FICHERO DE CONFIGURACION NO EXISTE' + #13 + 'SE CREARA CON LOS DATOS BASICOS' + #13 + '¿DESEA CREARLO?';
  rsDocuGes = 'Gestión Documental';
  rsFicheroIniCreado = 'FICHERO DE CONFIGURACION' + #13 + 'CREADO SATISFACTORIAMENTE' + #13 +
                       'VUELVA A EJECUTAR EL PROGRAMA';
  rsNoInsertaDocumentoGrupo = 'NO ES POSIBLE INSERTAR DOCUMENTOS SIN SUBGRUPO DEFINIDO'
         + #13 + 'PUEDE INDICAR SUBGRUPOS DESDE EL FORMULARIO SUBGRUPOS';
  rsNoCreaDirectorio = 'NO ES POSIBLE CREAR EL DIRECTORIO DE DESTINO' + #13 + 'CONSULTE CON EL ADMINISTRADOR';
  rsNoInsertaDocumento = 'NO ES POSIBLE INSERTAR DOCUMENTO' + #13 + 'CONFIRME PRIMERO EL REGISTRO';
  rsNoExisteBase = 'NO HAY CONEXION CON LA BASE DE DATOS' + #13 + 'CONTACTE CON EL ADMINISTRADOR';
  rsBorrar = '¿CONFIRMACION DE BORRADO?';
  rsSelectSubGrupos = 'SELECT * FROM subgrupos WHERE GRUPO_ID = %d ORDER BY NOMBRE';
  rsSelectDocumentos = 'SELECT * FROM documentos WHERE SUBGRUPO_ID = %d ORDER BY FECHA';
  rsSelectTipos1 = 'SELECT * FROM tipos WHERE ID_TIPO=''%s''';
  rsSelectSubgrupos1 = 'SELECT * FROM subgrupos WHERE ID_SUBGRUPO=''%s''';
  rsSelectGrupos1 = 'SELECT * FROM grupos WHERE ID_GRUPO=''%s''';
  rsErrorConsulta ='ERROR AL REALIZAR LA CONSULTA:' + #13 + '''%s''';
  rsNoFiltro = 'NO HAY SELECCIONADO UN FILTRO';
  rsNoValorFiltro = 'NO HAY VALOR PARA FILTRAR';
  rsErrorNumero = 'ERROR TIENE QUE SER UN VALOR NUMERICO';
  rsDesconectada = 'Conexión perdida con el servidor.';
  rsConfirmarCambios = 'POR FAVOR, CONFIRME O RECHACE LOS CAMBIOS';
  rsNoModoEdicion = 'LA TABLA NO ESTA EN MODO EDICION' + #13 + 'POR FAVOR, CAMBIE AL ESTADO CORRECTO';

  var
   DirectorioAplicacion:string;
   DirectorioFicheroINI:string;
   DirectorioDocumentos:string;


implementation

end.

