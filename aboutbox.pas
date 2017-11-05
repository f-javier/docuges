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

unit aboutbox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type

  { TfAboutBox }

  TfAboutBox = class(TForm)
    btnSalir: TBitBtn;
    Imagen: TImage;
    Label1: TLabel;
    LVersion: TLabel;
    LNombre: TLabel;
    Label3: TLabel;
    Licencia: TMemo;
    pc: TPageControl;
    tsAbout: TTabSheet;
    tsLicencia: TTabSheet;
    procedure btnSalirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fAboutBox: TfAboutBox;

implementation

{ TfAboutBox }
 uses recursostexto;
procedure TfAboutBox.FormCreate(Sender: TObject);
begin
  LVersion.Caption := 'DocuGes - Ver. 1.0 (Rev. 20)';
  pc.ActivePage:=tsAbout;
  Imagen.Picture.LoadFromFile(DirectorioAplicacion+'about.png');
  Licencia.Lines.LoadFromFile(UTF8ToAnsi(DirectorioAplicacion+'license.txt'));
end;


procedure TfAboutBox.btnSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfAboutBox.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

initialization
  {$I aboutbox.lrs}
end.

