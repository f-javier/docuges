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

unit datos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, LResources, Forms, Controls,
  Dialogs, IniFiles, LCLType, ZConnection, ZDataset;

type

  { TdmDatos }

  TdmDatos = class(TDataModule)
    ZConexion: TZConnection;
    dbQuery: TZQuery;
    procedure ConexionAfterConnect(Sender: TObject);
    procedure ConexionAfterDisconnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 
procedure conectarservidor;
function BaseNoConectada:boolean;
var
  dmDatos: TdmDatos;

implementation

Uses
funciones,  Conexion, recursostexto, menu;

{ TdmDatos }
procedure conectarservidor;
begin
  try
    dmDatos.ZConexion.Connected:=true;
  except
    ShowMessage(rsImposibleConexion);
  end;
end;

function BaseNoConectada:boolean;
begin
  result:=false;
  if not dmdatos.ZConexion.Connected then begin
     ShowMessage(rsNoExisteBase);
     result:=true;
  end;
end;

procedure TdmDatos.DataModuleCreate(Sender: TObject);
var
  IniReader: TIniFile;
  FicheroSQL, Txt: String;
  RC: integer;
  F: TextFile;
begin
  if not FileExists(DirectorioFicheroINI) then begin
     // El fichero de configuración no existe.
     if Pregunta(rsFicheroNoExiste) = IDYES then begin
        fConexion := TfConexion.Create(Application);
        fConexion.eServidor.Text:='localhost';
        fConexion.eBaseDatos.Text:='docuges';
        fConexion.eUsuario.Text:='root';
        fConexion.eContrasena.Text:='';
        fConexion.eProtocolo.Text:='mysql-5';
        fConexion.ePuerto.Text:='3306';
        fConexion.ShowModal;
        ShowMessage(rsFicheroIniCreado);
        Application.Terminate;
     end else
          Abort;
  end else begin
    // Carga de datos del fichero OPCIONES.INI
    IniReader := TIniFile.Create(DirectorioFicheroINI);
    ZConexion.HostName:=IniReader.ReadString('BBDD','host','');
    ZConexion.Database:=IniReader.ReadString('BBDD','database','');
    ZConexion.User:=IniReader.ReadString('BBDD','user','');
    ZConexion.Password:=IniReader.ReadString('BBDD','pass','');
    ZConexion.Protocol:=IniReader.ReadString('BBDD','protocol','');
    ZConexion.Port:=StrToInt(IniReader.ReadString('BBDD','port',''));
    try
      ZConexion.Connected:=true;
    except
      ShowMessage(rsImposibleConexion);
    end;
    ZConexion.ExecuteDirect('SHOW DATABASES LIKE "'+ZConexion.Database+'"', RC);
    if RC=0 then begin    // Si no existe la BBDD, se crea
        dbQuery.SQL.Text:='CREATE DATABASE '+ZConexion.Database;
        try
          dbQuery.ExecSQL;
        except
          begin ShowMessage('ERROR AL CREAR LA BASE DE DATOS'); exit; end;
        end;
      //----------------- Crear Tablas -------
      ZConexion.Disconnect;
      ZConexion.Database:=ZConexion.Database;
      ZConexion.Connected:=True;

      {$IFDEF LINUX}
         FicheroSql:= ExtractFilePath(ParamStr(0))+'scripts/createall.sql';
      {$ELSE}
         FicheroSql:= ExtractFilePath(ParamStr(0))+'scripts\createall.sql';
      {$ENDIF}
      AssignFile(F,FicheroSql);
      Reset(F);
      while not EOF(F) do begin
        Readln(F,Txt);
        if (Txt<>'') and (copy(Txt,1,1)<>'#') then begin
          dbQuery.SQL.Text:=Txt;
          dbQuery.ExecSQL;
        end;
      end;
    end;
    ZConexion.Disconnect;
  end;
    try
      ZConexion.Connected:=true;
    except
      ShowMessage(rsImposibleConexion);
    end;
end;

procedure TdmDatos.ConexionAfterDisconnect(Sender: TObject);
begin
      ShowMessage(rsDesconectada);
      fmenu.Menumaestros.enabled:=false; //desconecta el menu de archivo si se pierde la conexion
end;

procedure TdmDatos.ConexionAfterConnect(Sender: TObject);
begin
    ShowMessage(rsConexionEstablecida);
  fmenu.Menumaestros.enabled:=true; //desconecta el menu de archivo si se pierde la conexion
end;

procedure TdmDatos.DataModuleDestroy(Sender: TObject);
begin
  ZConexion.Connected:=false;
end;

initialization
  {$I datos.lrs}

end.

