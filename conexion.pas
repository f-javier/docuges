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

unit conexion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IniFiles;

type

  { TfConexion }

  TfConexion = class(TForm)
    btnTest: TBitBtn;
    btnOk: TBitBtn;
    btnSalir: TBitBtn;
    eBaseDatos: TEdit;
    eContrasena: TEdit;
    eProtocolo: TEdit;
    ePuerto: TEdit;
    eServidor: TEdit;
    eUsuario: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    procedure btnOkClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fConexion: TfConexion;

implementation

uses
  datos, recursostexto;


{ TfConexion }

procedure TfConexion.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfConexion.FormCreate(Sender: TObject);
var
  IniReader: TIniFile;
begin
  if FileExists(DirectorioFicheroINI) then begin
     IniReader := TIniFile.Create(DirectorioFicheroINI);
     eServidor.Text:=IniReader.ReadString('BBDD','host','');
     eBaseDatos.Text:=IniReader.ReadString('BBDD','database','');
     eUsuario.Text:=IniReader.ReadString('BBDD','user','');
     eContrasena.Text:=IniReader.ReadString('BBDD','pass','');
     eProtocolo.Text:=IniReader.ReadString('BBDD','protocol','');
     ePuerto.Text:=IniReader.ReadString('BBDD','port','');
  end;
end;

procedure TfConexion.btnSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfConexion.btnTestClick(Sender: TObject);
begin
  dmDatos.ZConexion.HostName:=eServidor.Text;
  dmDatos.ZConexion.Database:=eBaseDatos.Text;
  dmDatos.ZConexion.User:=eUsuario.Text;
  dmDatos.ZConexion.Password:=eContrasena.Text;
  dmDatos.ZConexion.Protocol:=eProtocolo.Text;
  dmDatos.ZConexion.Port:=StrToInt(ePuerto.Text);
  try
    conectarservidor;
    dmDatos.ZConexion.Connected:=True;
    ShowMessage(rsConexionEstablecida);
  except
    ShowMessage(rsImposibleConexion);
  end;
end;

procedure TfConexion.btnOkClick(Sender: TObject);
var
  IniReader: TIniFile;
begin
  IniReader := TIniFile.Create(DirectorioFicheroINI);
  IniReader.WriteString('BBDD','host',eServidor.Text);
  IniReader.WriteString('BBDD','database',eBaseDatos.Text);
  IniReader.WriteString('BBDD','user',eUsuario.Text);
  IniReader.WriteString('BBDD','pass',eContrasena.Text);
  IniReader.WriteString('BBDD','protocol',eProtocolo.Text);
  IniReader.WriteString('BBDD','port',ePuerto.Text);

  dmDatos.ZConexion.HostName:=eServidor.Text;
  dmDatos.ZConexion.Database:=eBaseDatos.Text;
  dmDatos.ZConexion.User:=eUsuario.Text;
  dmDatos.ZConexion.Password:=eContrasena.Text;
  dmDatos.ZConexion.Protocol:=eProtocolo.Text;
  dmDatos.ZConexion.Port:=StrToInt(ePuerto.Text);
 conectarservidor;
end;

initialization
  {$I conexion.lrs}

end.

