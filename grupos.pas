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

unit grupos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, IBConnection, db, FileUtil, LResources, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, DbCtrls, Buttons, StdCtrls, LCLType,
  ZDataset;

type

  { TfGrupos }

  TfGrupos = class(TForm)
    dbeID: TDBEdit;
    dbeNombre: TDBEdit;
    dsGrupos: TDatasource;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    sbSalir: TSpeedButton;
    sbBuscar: TSpeedButton;
    ZGrupos: TZQuery;
    ZGruposID_GRUPO: TLongintField;
    ZGruposNOMBRE: TStringField;
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbSalirClick(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure ZGruposAfterDelete(DataSet: TDataSet);
    procedure ZGruposBeforeDelete(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fGrupos: TfGrupos;

implementation

uses
  busquedas, datos, recursostexto, funciones;

{ TfGrupos }

procedure TfGrupos.sbSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfGrupos.sbBuscarClick(Sender: TObject);
var
  valret: string;
begin
  if dsGrupos.State in dsEDitModes then begin   // No es posible acceder a busquedas si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  valret:=FBusquedas.IniciaBusquedas('SELECT ID_GRUPO,NOMBRE FROM grupos',['Código','Nombre'],'ID_GRUPO');
  if StrToIntDef(valret,0)>0 then begin
     DaValorQuery(ZGrupos, Format(rsSelectGrupos1, [valret]));
  end;
end;

procedure TfGrupos.ZGruposAfterDelete(DataSet: TDataSet);
begin
  ZGrupos.Active:=False;
  ZGrupos.SQL.Text:='SELECT * FROM grupos ORDER BY id_grupo';
  ZGrupos.Active:=True;
  ZGrupos.First;
end;

procedure TfGrupos.ZGruposBeforeDelete(DataSet: TDataSet);
begin
  if Pregunta(rsBorrar) = IDNO then Abort;
end;

procedure TfGrupos.FormCreate(Sender: TObject);
begin
  if BaseNoConectada then Abort;
  try
    ZGrupos.Active:=true;

  except
    ShowMessage(rsNoExisteBase);

  end;
end;

procedure TfGrupos.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
begin
  if button=nbInsert then dbeNombre.SetFocus;
end;

procedure TfGrupos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if dsGrupos.State in dsEDitModes then begin  // No es posible Salir si está en modo Edición
     ShowMessage(rsConfirmarCambios);
     Abort;
  end;
  ZGrupos.active:=false ;
  CloseAction:=caFree;
end;

initialization
  {$I grupos.lrs}

end.

