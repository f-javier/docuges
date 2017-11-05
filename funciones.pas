{
  DocuGes - Gestion Documental

  Autores: Equipo de FacturLinEx ( http://facturlinex.sourceforge.net )

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

unit funciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, DBGrids, LCLType, ZDataset, Dialogs;

  procedure BlancoGrid(Grid: TDBGrid);
  function LFill( SourceStr: String; NewLen: Byte; FillChar: Char): String;
  function StrLFill( SourceStr: PChar;NewLen: Word; FillChar: Char): PChar;
  function Pregunta(Texto:String):Integer;
  procedure DaValorQuery(Query:TZQuery; sql:string);

implementation
 Uses
  recursostexto;

//-------- Poner las columnas del grid en blanco
procedure BlancoGrid(Grid: TDBGrid);
var
  conta:integer;
begin
for conta:=0 to Grid.Columns.Count-1 do
    begin Grid.Columns[conta].Color:= $00F4E7E7 ; //clWindow;
  end;
end;

//-------- RELLENAR SPACIOS A LA IZQUIERDA
function LFill( SourceStr: String;NewLen: Byte; FillChar: Char): String;
var
  aPChar   : PChar;
  newPChar : PChar;
begin
  DecimalSeparator:='.';
  if NewLen > Length(SourceStr) then
   begin
     aPChar := StrAlloc(NewLen+1);
     StrPCopy(aPChar,SourceStr);
     newPChar := StrLFill(aPChar,NewLen,FillChar);
     Result   := StrPas(newPChar);
     StrDispose(aPChar);
   end
  else
   begin
     Result := SourceStr;
   end;
end;
{--------------------------------------------------------------------------}
function StrLFill( SourceStr : PChar;
                   NewLen    : Word;
                   FillChar  : Char): PChar;
var
   tempStr : PChar;
   startStr: PChar;
   fillLen : Word;
   oldSize : Word;
   maxSize : Word;
   i       : Word;
begin
  DecimalSeparator:='.';
     maxSize := StrBufSize(SourceStr);
     oldSize := StrLen(SourceStr);
     if NewLen > oldSize then
     begin
          if NewLen > maxSize then
          begin
               fillLen := maxSize - oldSize;
          end
          else
          begin
               fillLen := NewLen - oldSize;
          end;
          tempStr := StrAlloc(maxSize);
          StrCopy(tempStr,SourceStr);
          startStr := SourceStr;
          for i := 1 to fillLen do
          begin
               StartStr^ := FillChar;
               inc(startStr);
          end;
          StartStr^ := #0;
          StrCat(SourceStr,tempStr);
          StrDispose(TempStr);
     end;
     Result := SourceStr;
end;

function Pregunta(Texto:String):Integer;
begin
  result:=Application.MessageBox(PChar(Texto), PChar(rsDocuGes), MB_ICONQUESTION + MB_YESNO);
end;

procedure DaValorQuery(Query: TZQuery; sql: string);
begin
  try
    Query.active:=false;
    Query.SQL.Text:= sql;
    Query.active:=true;
  except
     ShowMessage(Format(rsErrorConsulta, [sql]));
  end;
end;

end.

