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

program docuges;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LResources, SQLDBLaz, Printer4Lazarus, pack_powerpdf, menu, grupos,
  funciones, documentos, datos, Busquedas, subgrupos, tipos, aboutbox, conexion,
  recursostexto, copiaseg, zcomponent;

{$IFDEF WINDOWS}{$R docuges.rc}{$ENDIF}

begin
  {$I docuges.lrs}
  Application.Initialize;
  Application.CreateForm(Tfmenu, fmenu);
  Application.CreateForm(TdmDatos, dmDatos);
  Application.Run;
end.

