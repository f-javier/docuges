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

unit subgrupos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, DbCtrls, StdCtrls, LCLType, ZDataset;

type

  { TfSubGrupos }

  TfSubGrupos = class(TForm)
    dsGrupos: TDatasource;
    dbeID: TDBEdit;
    dbeNombre: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBNavigator1: TDBNavigator;
    dsSubGrupos: TDatasource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    sbBuscar: TSpeedButton;
    sbSalir: TSpeedButton;
    ZGrupos: TZQuery;
    ZSubGrupos: TZQuery;
    ZSubGruposGRUPO_ID: TLongintField;
    ZSubGruposID_SUBGRUPO: TLongintField;
    ZSubGruposNOMBRE: TStringField;
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure sbSalirClick(Sender: TObject);
    procedure ZSubGruposAfterDelete(DataSet: TDataSet);
    procedure ZSubGruposBeforeDelete(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fSubGrupos: TfSubGrupos;

implementation

uses
  datos, busquedas, recursostexto, funciones;

{ TfSubGrupos }

procedure TfSubGrupos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if dsSubGrupos.State in dsEDitModes then begin  // No es posible Salir si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  ZSubGrupos.Active:=false;
  ZGrupos.Active:=false;
  CloseAction:=caFree;
end;

procedure TfSubGrupos.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if button=nbInsert then dbeNombre.SetFocus;
end;

procedure TfSubGrupos.FormCreate(Sender: TObject);
begin
  if BaseNoConectada then Abort;
  try
    ZSubGrupos.Active:=True;
    ZGrupos.Active:=True;

  except
    ShowMessage(rsNoExisteBase);

  end;
end;

procedure TfSubGrupos.sbBuscarClick(Sender: TObject);
var
  valret: string;
begin
  if dsSubGrupos.State in dsEDitModes then begin   // No es posible acceder a busquedas si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  valret:=FBusquedas.IniciaBusquedas('SELECT ID_SUBGRUPO, NOMBRE FROM subgrupos',['Código','Nombre'],'ID_SUBGRUPO');
  if StrToIntDef(valret,0)>0 then begin
     DaValorQuery(ZSubGrupos, Format(rsSelectSubGrupos1, [valret]));
  end;
end;

procedure TfSubGrupos.sbSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfSubGrupos.ZSubGruposAfterDelete(DataSet: TDataSet);
begin
  ZSubGrupos.Active:=False;
  ZSubGrupos.SQL.Text:='SELECT * FROM subgrupos ORDER BY id_subgrupo';
  ZSubGrupos.Active:=True;
  ZSubGrupos.First;

end;

procedure TfSubGrupos.ZSubGruposBeforeDelete(DataSet: TDataSet);
begin
  if Pregunta(rsBorrar) = IDNO then Abort;
end;

initialization
  {$I subgrupos.lrs}

end.

