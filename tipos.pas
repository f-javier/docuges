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

unit tipos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, DbCtrls, ExtCtrls, Buttons, StdCtrls, LCLType,
  ZDataset;

type

  { TfTipos }

  TfTipos = class(TForm)
    dbeID: TDBEdit;
    dbeNombre: TDBEdit;
    dbeVisor: TDBEdit;
    DBNavigator1: TDBNavigator;
    dsTipos: TDatasource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    sbBuscar: TSpeedButton;
    sbSalir: TSpeedButton;
    SpeedButton1: TSpeedButton;
    sbAyuda: TSpeedButton;
    ZTipos: TZQuery;
    ZTiposID_TIPO: TLongintField;
    ZTiposNOMBRE: TStringField;
    ZTiposVISOR: TStringField;
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbAyudaClick(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure sbSalirClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ZTiposAfterDelete(DataSet: TDataSet);
    procedure ZTiposBeforeDelete(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fTipos: TfTipos;

implementation

{ TfTipos }

uses
  datos, busquedas, recursostexto, funciones;

procedure TfTipos.sbSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfTipos.SpeedButton1Click(Sender: TObject);
begin
  if dsTipos.State in dsEditModes then begin
     OpenDialog1.Execute;
     dbeVisor.Text := OpenDialog1.FileName;
  end else begin
      ShowMessage(rsNoModoEdicion);
  end;
end;

procedure TfTipos.ZTiposAfterDelete(DataSet: TDataSet);
begin
  ZTipos.Active:=False;
  ZTipos.SQL.Text:='SELECT * FROM tipos ORDER BY id_tipo';
  ZTipos.Active:=True;
  ZTipos.First;
end;

procedure TfTipos.ZTiposBeforeDelete(DataSet: TDataSet);
begin
  if Pregunta(rsBorrar) = IDNO then Abort;
end;

procedure TfTipos.sbBuscarClick(Sender: TObject);
var
  valret: string;
begin
  if dsTipos.State in dsEDitModes then begin   // No es posible acceder a busquedas si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  valret:=FBusquedas.IniciaBusquedas('SELECT ID_TIPO, NOMBRE FROM tipos',['Código','Nombre'],'ID_TIPO');
  if StrToIntDef(valret,0)>0 then begin
     DaValorQuery(ZTipos, Format(rsSelectTipos1, [valret]));
  end;
end;

procedure TfTipos.FormCreate(Sender: TObject);
begin
  OpenDialog1.InitialDir := DirectorioAplicacion;
  if BaseNoConectada then Abort;
  try
    ZTipos.Active:=true;

  except
    ShowMessage(rsNoExisteBase);

  end;
end;

procedure TfTipos.sbAyudaClick(Sender: TObject);
begin
  ShowMessage('Ejemplo de visor:'+chr(13)+
  {$IFDEF WINDOWS}
              'C:\Archivos de Programas\Adobe\Reader.exe');
  {$ELSE}
              '/usr/bin/evince');
  {$ENDIF}
end;

procedure TfTipos.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
begin
  if button=nbInsert then dbeNombre.SetFocus;
end;

procedure TfTipos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if dsTipos.State in dsEDitModes then begin  // No es posible Salir si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  ZTipos.active:=false ;
  CloseAction:=caFree;
end;

initialization
  {$I tipos.lrs}

end.

