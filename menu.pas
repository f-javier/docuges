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

unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Menus, PrintersDlgs, Process;

type

  { Tfmenu }

  Tfmenu = class(TForm)
    MainMenu1: TMainMenu;
    MenuArchivo: TMenuItem;
    MenuAyuda: TMenuItem;
    Linea11: TMenuItem;
    MenuConfigurarImpresora: TMenuItem;
    MenuAcercaDe: TMenuItem;
    MenuGrupos: TMenuItem;
    MenuConexion: TMenuItem;
    Menuconectar: TMenuItem;
    MenuActBBDD: TMenuItem;
    MenuCopiaSeg: TMenuItem;
    MenuUtilidades: TMenuItem;
    MenuTipos: TMenuItem;
    MenuSubGrupos: TMenuItem;
    Linea21: TMenuItem;
    MenuDocumentos: TMenuItem;
    MenuMaestros: TMenuItem;
    MenuSalir: TMenuItem;
    Linea12: TMenuItem;
    Linea13: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    procedure FormCreate(Sender: TObject);
    procedure MenuAcercaDeClick(Sender: TObject);
    procedure MenuActBBDDClick(Sender: TObject);
    procedure MenuConexionClick(Sender: TObject);
    procedure MenuConfigurarImpresoraClick(Sender: TObject);
    procedure MenuCopiaSegClick(Sender: TObject);
    procedure MenuDocumentosClick(Sender: TObject);
    procedure MenuGruposClick(Sender: TObject);
    procedure MenuconectarClick(Sender: TObject);
    procedure MenuSalirClick(Sender: TObject);
    procedure MenuSubGruposClick(Sender: TObject);
    procedure MenuTiposClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fmenu: Tfmenu;

implementation

{ Tfmenu }

uses
  aboutbox, conexion, grupos, subgrupos, tipos, documentos, recursostexto, datos, copiaseg;

procedure Tfmenu.MenuSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfmenu.MenuSubGruposClick(Sender: TObject);
begin
  fSubGrupos := TfSubGrupos.Create(Application);
  fSubGrupos.ShowModal;
end;

procedure Tfmenu.MenuTiposClick(Sender: TObject);
begin
  fTipos := TfTipos.Create(Application);
  fTipos.ShowModal;
end;

procedure Tfmenu.MenuGruposClick(Sender: TObject);
begin
  fGrupos := TfGrupos.Create(Application);
  fGrupos.ShowModal;
end;

procedure Tfmenu.MenuconectarClick(Sender: TObject);
begin
  conectarservidor;
end;

procedure Tfmenu.MenuDocumentosClick(Sender: TObject);
begin
  fDocumentos := TfDocumentos.Create(Application);
  fDocumentos.ShowModal;
end;

procedure Tfmenu.MenuConfigurarImpresoraClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure Tfmenu.MenuCopiaSegClick(Sender: TObject);
begin
  fCopiaSeg := TfCopiaSeg.Create(Application);
  fCopiaSeg.ShowModal;
end;

procedure Tfmenu.MenuAcercaDeClick(Sender: TObject);
begin
  fAboutBox := TfAboutBox.Create(Application);
  fAboutBox.ShowModal;
end;

procedure Tfmenu.MenuActBBDDClick(Sender: TObject);
var
  Aprocess: TProcess;
begin
  AProcess := TProcess.Create(nil);
  {$IFDEF LINUX}
     AProcess.CommandLine := 'gksu '+ExtractFilePath(ParamStr(0))+'actbbdd';
  {$ELSE}
     AProcess.CommandLine := ExtractFilePath(ParamStr(0))+'actbbdd';
  {$ENDIF}
  AProcess.Execute;
  AProcess.Free;
end;

procedure Tfmenu.FormCreate(Sender: TObject);
begin
  ShortDateFormat:='DD/MM/YYYY';
  DecimalSeparator:='.';

  DirectorioAplicacion:=ExtractFilePath(ParamStr(0));
  DirectorioFicheroINI:=DirectorioAplicacion + 'opciones.ini';
  DirectorioDocumentos:=DirectorioAplicacion + 'documentos';
end;

procedure Tfmenu.MenuConexionClick(Sender: TObject);
begin
  fConexion:=TfConexion.Create(Application);
  fConexion.ShowModal;
end;

initialization
  {$I menu.lrs}

end.

