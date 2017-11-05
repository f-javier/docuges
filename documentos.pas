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

unit documentos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DbCtrls, DBGrids, DOS, LCLType,
  ZDataset;

type

  { TfDocumentos }

  TfDocumentos = class(TForm)
    dbeDescripcion: TDBEdit;
    DBNavigator1: TDBNavigator;
    dsTipos: TDatasource;
    dbeID: TDBEdit;
    dbeDocumento: TDBEdit;
    dbeFecha: TDBEdit;
    dblcFormato: TDBLookupComboBox;
    dbmDetalle: TDBMemo;
    dsDocumentos: TDatasource;
    dbgGrupos: TDBGrid;
    dbgDocumentos: TDBGrid;
    dbgSubGrupos: TDBGrid;
    dsGrupos: TDatasource;
    dsSubGrupos: TDatasource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    sbSalir: TSpeedButton;
    sbVisualizar: TSpeedButton;
    sbDocumento: TSpeedButton;
    ZDocumentosDESCRIPCION: TStringField;
    ZDocumentosDETALLE: TBlobField;
    ZDocumentosDOCUMENTO: TStringField;
    ZDocumentosFECHA: TDateField;
    ZDocumentosFORMATO_ID: TLongintField;
    ZDocumentosID_DOCUMENTO: TLongintField;
    ZDocumentosSUBGRUPO_ID: TLongintField;
    ZGrupos: TZQuery;
    ZGruposID_GRUPO: TLongintField;
    ZGruposNOMBRE: TStringField;
    ZDocumentos: TZQuery;
    ZTipos: TZQuery;
    ZSubGrupos: TZQuery;
    ZSubGruposGRUPO_ID: TLongintField;
    ZSubGruposID_SUBGRUPO: TLongintField;
    ZSubGruposNOMBRE: TStringField;
    ZTiposID_TIPO: TLongintField;
    ZTiposNOMBRE: TStringField;
    ZTiposVISOR: TStringField;
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbDocumentoClick(Sender: TObject);
    procedure sbSalirClick(Sender: TObject);
    procedure sbVisualizarClick(Sender: TObject);
    function  NoExisteDirectorio(Directorio:String):Boolean;
    procedure ZDocumentosBeforeDelete(DataSet: TDataSet);
    procedure ZDocumentosBeforeInsert(DataSet: TDataSet);
    procedure ZDocumentosNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fDocumentos: TfDocumentos;
  Separador:string;

implementation

{ TfDocumentos }

uses funciones, recursostexto, datos;

procedure TfDocumentos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if dsDocumentos.State in dsEDitModes then begin  // No es posible Salir si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  ZGrupos.Active:=False;
  ZSubGrupos.Active:=False;
  ZTipos.active:=false;
  ZDocumentos.active:=false;
  CloseAction:=caFree;
end;

procedure TfDocumentos.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if button=nbInsert then dbeFecha.SetFocus;
end;

procedure TfDocumentos.FormCreate(Sender: TObject);
begin
 {$IFDEF LINUX}
     Separador:='/';
 {$ELSE}
     Separador:='\';
  {$ENDIF}
  if BaseNoConectada then Abort;
  try
    ZGrupos.Active:=True;
    ZSubGrupos.Active:=True;
    ZTipos.Active:=True;
    ZDocumentos.Active:=True;

  except
    ShowMessage(rsNoExisteBase);

  end;
end;

procedure TfDocumentos.sbDocumentoClick(Sender: TObject);
var
  dir_destino, dir_verifica, arch_destino: string;
  posicion: integer;
begin
  if not(dsDocumentos.State in dsEditModes) then begin
      ShowMessage(rsNoModoEdicion);
      Abort;
  end;

  if (ZDocumentosID_DOCUMENTO.AsInteger=0) then begin
     ShowMessage(rsNoInsertaDocumento);
     Abort;
  end;

  // Se comprueba si existe la carpeta DOCUMENTOS/ dentro de la del programa
  dir_verifica:=DirectorioDocumentos;

  if NoExisteDirectorio (dir_verifica) then abort;
  // Proceso para insertar el documento dentro de su ubicación definitiva

  // El destino del documento está determinado por el ID del documento
  // Ajustado a 3 niveles de directorios y el documento en sí.
  // Ejemplo: El documento 1.pdf estará en 'documentos/00/00/00/01.pdf'
  dir_destino:=ZDocumentosID_DOCUMENTO.AsString;
  dir_destino:=funciones.LFill(dir_destino,8,'0'); // Ajustamos a 8 caracteres
  // Verificación del directorio del primer nivel. Si no existe, lo creamos
  dir_verifica:= DirectorioDocumentos+Separador+copy(dir_destino,1,2);
  if NoExisteDirectorio (dir_verifica) then abort;
  // Verificación del directorio del segundo nivel. Si no existe, lo creamos
  dir_verifica:= dir_verifica+Separador+copy(dir_destino,3,2);
  if NoExisteDirectorio (dir_verifica) then abort;
  // Verificación del directorio del tercer nivel. Si no existe, lo creamos
  dir_verifica:= dir_verifica+Separador+copy(dir_destino,5,2);
  if NoExisteDirectorio (dir_verifica) then abort;
  if OpenDialog1.FileName ='' then OpenDialog1.FileName :=DirectorioAplicacion;
  if OpenDialog1.Execute then begin
     arch_destino:=dir_verifica+Separador+funciones.LFill(ZDocumentosID_DOCUMENTO.AsString,2,'0')+copy(OpenDialog1.FileName,length(OpenDialog1.FileName)-3,4);


     CopyFile(OpenDialog1.FileName,arch_destino);
     posicion:=Pos(DirectorioAplicacion,arch_destino);
     ZDocumentos.edit;
     delete(arch_destino,1,posicion+length(DirectorioAplicacion)-1);
     ZDocumentosDOCUMENTO.Value:=arch_destino;
//  end else begin
//     ZDocumentosDOCUMENTO.Value:='';
  end;
end;

procedure TfDocumentos.sbSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfDocumentos.sbVisualizarClick(Sender: TObject);
begin
  Exec(ZTiposVISOR.AsString,DirectorioAplicacion+ZDocumentosDOCUMENTO.AsString);
end;

function TfDocumentos.NoExisteDirectorio(Directorio: String): Boolean;
begin
  result:=false;
  if not DirectoryExists(Directorio) then
    if not createdir(Directorio) then begin
      result:=true;
      ShowMessage(rsNoCreaDirectorio);
    end;
end;

procedure TfDocumentos.ZDocumentosBeforeDelete(DataSet: TDataSet);
begin
  if Pregunta(rsBorrar) = IDNO then Abort;
end;

procedure TfDocumentos.ZDocumentosBeforeInsert(DataSet: TDataSet);
begin
  if ZSubGruposID_SUBGRUPO.AsInteger = 0 then begin
     ShowMessage(rsNoInsertaDocumentoGrupo);
     abort;
  end;
end;

procedure TfDocumentos.ZDocumentosNewRecord(DataSet: TDataSet);
begin
  ZDocumentosFECHA.Value := date();
  ZDocumentosSUBGRUPO_ID.Value := ZSubGruposID_SUBGRUPO.AsInteger;
end;

initialization
  {$I documentos.lrs}

end.

