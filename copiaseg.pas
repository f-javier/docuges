{
  Gestion LinEx FacturLinEx

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

unit copiaseg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, ZConnection, StdCtrls, LCLType, sqldb, ZDataset, DB,
  ComCtrls, Grids, Strings;

type

  { TFCopiaSeg }

  TFCopiaSeg = class(TForm)
    bBtnSel: TBitBtn;
    bBtnSelINI: TBitBtn;
    btnGenerar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    BitBtnIniciar: TBitBtn;
    BitBtnRestaurar: TBitBtn;
    cbIncluir: TCheckBox;
    cbIncluirR: TCheckBox;
    DestinoCopia: TEdit;
    DestinoINICopia: TEdit;
    edLinProc: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    OrigenCopia: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OrigenINICopia: TEdit;
    pc: TPageControl;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    Query:  TZQuery;
    Query0: TZQuery;
    Query1: TZQuery;
    sgEstadisticas: TStringGrid;
    tsEstadisticas: TTabSheet;
    tsRestore: TTabSheet;
    tsBackup: TTabSheet;
    dbQuery: TZQuery;
    procedure bBtnSelINIClick(Sender: TObject);
    procedure btnGenerarClick(Sender: TObject);
    procedure cbIncluirClick(Sender: TObject);
    procedure cbIncluirRClick(Sender: TObject);
    function LimpiaCadena(cadena: String): String;
    procedure bBtnSelClick(Sender: TObject);
    procedure BitBtnRestaurarClick(Sender: TObject);
    function FiltrarCadena(cadena: string): String;
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnIniciarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    Function Char2Hex(cPassedChar : Char) : String;
    Function Val2Hex(ilPassedValue : LongInt) : String;
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure ShowFormCopiaSeg;

var
  FCopiaSeg: TFCopiaSeg;
  TotalRegistros: integer;

implementation

uses funciones, datos;

{ TFCopiaSeg }

// Función para eliminar los carácteres #10 en las sentencias SQL
function TFCopiaSeg.LimpiaCadena(cadena: string): string;
var
  cont: integer;
begin
   cont := 1;
   while cont <= length(cadena) do begin
       if cadena[cont]= #10 then delete(cadena,cont,1);
       cont := cont + 1;
   end;
   Result := cadena;
end;

// Funcion para filtrar las cadenas y añadir los caracteres de control
function TFCopiaSeg.FiltrarCadena(cadena: string): string;
var
   cont: integer;
begin
   cont := 1;
   while cont <= length(cadena) do begin
       if cadena[cont]= #39 then begin
          insert(#92,cadena,cont);
          cont := cont + 1;
       end;
       cont := cont + 1;
   end;
   Result := cadena;
end;

//=============== Val2Hex -> LongInt a Hexadecimal ================
 Function TFCopiaSeg.Val2Hex(ilPassedValue : LongInt) : String;
 var sRetStr  : String;
     sTempStr : String;
     iRest    : Integer;
     ilFigure : LongInt;
 begin
    sRetStr  := '';
    sTempStr := '';
    iRest    := 0;
    ilFigure := 0;
    ilFigure := ilPassedValue;
    Repeat
       iRest := ilFigure MOD 16;
       Case iRest of
          0 : sTempStr := '0';
          1 : sTempStr := '1';
          2 : sTempStr := '2';
          3 : sTempStr := '3';
          4 : sTempStr := '4';
          5 : sTempStr := '5';
          6 : sTempStr := '6';
          7 : sTempStr := '7';
          8 : sTempStr := '8';
          9 : sTempStr := '9';
         10 : sTempStr := 'A';
         11 : sTempStr := 'B';
         12 : sTempStr := 'C';
         13 : sTempStr := 'D';
         14 : sTempStr := 'E';
         15 : sTempStr := 'F';
       End;
       sRetStr := sTempStr + sRetStr;
       ilFigure := ilFigure - iRest;
       ilFigure := ilFigure DIV 16;
    Until ilFigure = 0;
    Val2Hex := sRetStr;
 end;

//=============== Char2Hex -> Char a Hexadecimal ================
 Function TFCopiaSeg.Char2Hex(cPassedChar : Char) : String;
 var sRetStr  : String;
 begin
    sRetStr  := '';
    sRetStr := Val2Hex(Ord(cPassedChar));
    While length(sRetStr) < 2 do
          sRetStr := '0' + sRetStr;
    Char2hex := sRetStr;

 end;

//=============== Crea el formulario ================
procedure ShowFormCopiaSeg;
begin
  with TFCopiaSeg.Create(Application) do
  begin
    ShowModal;
  end;
end;

procedure TFCopiaSeg.FormCreate(Sender: TObject);
begin
  dmDatos.ZConexion.Connect;
  DestinoCopia.Text := ExtractFilePath(ParamStr(0)) + 'copiaseg'+
                       FormatDateTime('yyyymmdd',now)+'.sql';
  DestinoINICopia.Text:= ExtractFilePath(ParamStr(0)) + 'opciones'+
                         FormatDateTime('yyymmdd',now)+'.ini';
  OpenDialog1.InitialDir:=ExtractFilePath(ParamStr(0));
  pc.ActivePage:=tsBackup;

end;

procedure TFCopiaSeg.BitBtnCerrarClick(Sender: TObject);
begin
  Close();
end;

procedure TFCopiaSeg.BitBtnIniciarClick(Sender: TObject);
var
  F:    TFileStream;
  clong, cont, cont2, cont3: integer;
  Cabecera: array[1..7] of string;
  s, Destino, DestinoConf, cString, cEnHex:    string;
  dia, mes, anio: word;
  hora, minuto, segundo, milisegundo: word;
  car: char;
begin
  // ----------
  // Creación del fichero SQL con el script de la Copia de Seguridad
  // al fichero de la copia se añade la fecha en la que se hace
  // el usuario puede cambiar el nombre del fichero a su elección
  // ----------
  destino:=DestinoCopia.Text;
  progressBar1.Position := 0;
  if Query.Active then Query.Close;
  if Query0.Active then Query0.Close;
  if Query1.Active then Query1.Close;
  Cabecera[1] := '# --';
  Cabecera[2] := '# -- Gestion Documental (DocuGes) -> dump';
  Cabecera[3] := '# -- Script de Copia de Seguridad';
  Cabecera[4] := '# --';
  Cabecera[5] := '# --------------------------------';
  Cabecera[6] := '# -- Fecha: '+DateToStr(date())+ '  Hora: '+TimeToStr(Time());
  Cabecera[7] := '# --';
  // Añadir aqui toda la información de interes a indicar en el fichero de copias
  if FileExists(DestinoCopia.Text) then
  begin
    if Application.MessageBox('¡EL DESTINO SELECCIONADO YA EXISTE!' +
      #13 + '¿DESEA REEMPLAZARLO?', 'DocuGes',
      MB_ICONQUESTION + MB_YESNO) = idYes then
      DeleteFile(DestinoCopia.Text)
    else
      abort;
  end;
  Application.ProcessMessages;
  F := TFileStream.Create(DestinoCopia.Text, fmCreate);
  // Creación de la Cabecera del Fichero de copia
  for cont := 1 to 7 do
  begin
    s := Cabecera[cont] + #10;    F.Write(s[1], Length(s));
  end;
  s := #13 + #10;   F.Write(s[1], Length(s)); // Añadimos una linea en blanco para una mejor visualizacio

  // NOTAS
  // * show create database database - regresa la instrucción sql para crear la base (CREATE DATABASE...)
  // * show tables from database - te regresa una tabla con los nombre de las tablas de la base.
  // * show create table database.table - te regresa la instrucción sql para crear la tabla (CREATE TABLE ...)

  Query.SQL.Clear;
  Query.SQL.Add('show create database '+dmDatos.ZConexion.Database);
  Query.Open;
  s := '# --' + Query.FieldByName('Create Database').AsString + ';' + #10;  F.Write(s[1], Length(s));
  Query.Close;

  s := #10;   F.Write(s[1], Length(s));    // Linea en blanco

  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+dmDatos.ZConexion.Database);
  Query0.Open;
  Query0.First;
  While not Query0.EOF do begin
     Query.SQL.Clear;
     Query.SQL.Add('show create table '+dmDatos.ZConexion.Database+'.'+Query0.Fields.FieldByNumber(1).AsString);
     Query.Open;
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := '# -- Estructura de la Tabla '+Query0.Fields.FieldByNumber(1).AsString + #10;     F.Write(s[1], Length(s));
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     s := Query.FieldByName('Create Table').AsString + ';';
     s := LimpiaCadena(s);      // Función para eliminar el carácter #10 LF
     F.Write(s[1], Length(s));
     s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := '# -- Datos Contenidos en la Tabla '+Query0.Fields.FieldByNumber(1).AsString + #10;     F.Write(s[1], Length(s));
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := #13 + #10;   F.Write(s[1], Length(s));    // Linea en blanco
     Query1.SQL.Clear;
     Query1.SQL.Add('select * from '+Query0.Fields.FieldByNumber(1).AsString);
     Query1.Open;
     Query1.First;
     if Query1.EOF = Query1.BOF then begin
        s := '# -- NO HAY DATOS EN ESTA TABLA...';   F.Write(s[1], Length(s));
        s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     end else begin
         While not Query1.EOF do begin
            s := 'INSERT INTO `'+Query0.Fields.FieldByNumber(1).AsString+'` VALUES (';
            for cont2 := 1 to Query1.FieldCount do begin
                // Verificamos el tipo de la variable para generar el fichero de salida
                if Query1.Fields.FieldByNumber(cont2).IsNull then     // Contenido NULL
                   s := s + 'NULL'
                else begin
                   CASE Query1.Fields.FieldByNumber(cont2).DataType of
                        ftDate :  begin
                                    DecodeDate(Query1.Fields.FieldByNumber(cont2).AsDateTime,anio,mes,dia);
                                    s := s + '''';
                                    s := s + IntToStr(anio) + '-' + IntToStr(mes) + '-' + IntToStr(dia);
                                    s := s + '''';
                                  end;
                       ftTime :   begin
                                    DecodeTime(Query1.Fields.FieldByNumber(cont2).AsDateTime,hora, minuto, segundo, milisegundo);
                                    s := s + '''';
                                    s := s + IntToStr(hora) + ':' + IntToStr(minuto) + ':' + IntToStr(segundo);
                                    s := s + '''';
                                  end;
                        ftBlob  : begin
                                    if length(Query1.Fields.FieldByNumber(cont2).AsString) > 0 then begin
                                       cEnHex := '0x';
                                       cString := Query1.Fields.FieldByNumber(cont2).AsString;
                                       for cont3 := 1 to length(cString) do begin
                                           car := cString[cont3];
                                           cEnHex := cEnHex + Char2Hex(car);
                                       end;
                                       s := s + cEnHex;
                                    end else
                                       s := s + '''''';
                                  end;
                   else begin
                           s := s + '''';
                           s := s + FiltrarCadena(Query1.Fields.FieldByNumber(cont2).AsString);
                           s := s + '''';
                        end;
                   end;
                end;
                   if cont2 <> Query1.FieldCount then s := s + ',';

            end;
            s := s + ');' + #10;     F.Write(s[1], Length(s));
            Query1.Next;
         end;
     end;
     Query1.Close;
     s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     Query0.Next;
    ProgressBar1.Position := Round((Query0.RecNo*100)/Query0.RecordCount);
    Application.ProcessMessages;
  end;
  Query.Close;
  Query0.Close;
  Query1.Close;
  F.Free;

  // ----------
  // Copia del fichero de configuración del programa
  // ----------
  if (cbIncluir.Checked) then begin
     if FileExists(DestinoINICopia.Text) then begin
        if Application.MessageBox('¡EL FICHERO DE CONFIGURACION YA EXISTE' +
          #13 + 'EN EL DESTINO SELECCIONADO!' +
          #13 + '¿DESEA REEMPLAZARLO?', 'DocuGes',
          MB_ICONQUESTION + MB_YESNO) = idYes then
          DeleteFile(DestinoINICopia.Text)
        else
          abort;
     end;
       CopyFile(ExtractFilePath(ParamStr(0))+'opciones.ini',DestinoINICopia.Text);
  end;
  ShowMessage('PROCESO DE COPIAS FINALIZADO');
end;


procedure TFCopiaSeg.BitBtnRestaurarClick(Sender: TObject);
var
  maxregs: integer;
  Txt: String;
  F: TextFile;
  contlin: longint; // Contador de lineas para actualizar el progressbar2
begin
  // ---------- Restaurar la Copia de Seguridad
  // ----- Sólo se restaura en el caso de que la base de datos esté vacía
  if OrigenCopia.Text='' then begin
     ShowMessage('¡NO HAY UN FICHERO DE COPIAS SELECCIONADO!');
     abort;
  end;
  // ----- Comprobamos que las tablas estan totalmente vacias
  // ----- Con lo que lo damos por válido para la restauración
  if Query0.Active then Query0.Close;
  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+dmDatos.ZConexion.Database);
  Query0.Open;
  Query0.First;
  While not Query0.EOF do begin
     Query.SQL.Clear;
     Query.SQL.Add('select count(*) from '+dmDatos.ZConexion.Database+'.'+Query0.Fields.FieldByNumber(1).AsString);
     Query.Open;
     maxregs:=0;  // Maximo de registros permitidos en una tabla. Se controlan las excepciones...
     if Query.Fields.FieldByNumber(1).AsInteger > maxregs then begin
        ShowMessage('EL FICHERO '+Query0.Fields.FieldByNumber(1).AsString+' CONTIENTE '+Query.Fields.FieldByNumber(1).AsString+' REGISTROS'+#13+
                    'EL CONTENIDO MAXIMO PERMITIDO ES DE '+IntToStr(maxregs)+#13+
                    'NO ES POSIBLE RESTAURAR LA COPIA DE SEGURIDAD');
        abort;
     end;
     Query0.Next;
  end;
  // Borrado de TODAS las tablas de la base de datos
  // Así las creamos directamente con el fichero de copias
  if Query0.Active then Query0.Close;
  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+dmDatos.ZConexion.Database);
  Query0.Open;
  Query0.First;
  While not Query0.EOF do begin
     Query.SQL.Clear;
     Query.SQL.Add('drop table '+Query0.Fields.FieldByNumber(1).AsString);
     Query.ExecSQL;
     Query0.Next;
   end;
  // Creamos tablas nuevamente y cargamos los datos en ellas
  contlin := 0;
  edLinProc.Visible:=true;
  AssignFile(F,OrigenCopia.Text);
  Reset(F);

  TotalRegistros:=0;
  while not EOF(F) do
    begin
     Readln(F,Txt);
     TotalRegistros:=TotalRegistros+1;
    end;

  Closefile(F);    // Reinializamos el fichero sql.
  AssignFile(F, OrigenCopia.Text);
  Reset(F);
  while not EOF(F) do begin
     Readln(F,Txt);
     if (Txt<>'') and (copy(Txt,1,1)<>'#') then
       begin
         if (contlin mod 10) = 0 then edLinProc.Text := 'Procesando línea ' + IntToStr(contlin); // El contador de lineas se muestra de 10 en 10
         dbQuery.SQL.Text:=Txt;
         dbQuery.ExecSQL;
       end;
     contlin := contlin + 1;
     ProgressBar2.Position := Round((contlin*100)/TotalRegistros);
     Application.ProcessMessages;
    end;
  edLinProc.Visible:=false;

  // ----------
  // Se restaura la copia del fichero de configuración del programa
  // a su ubicación original.
  // ----------
  if cbIncluirR.Checked then begin
     {$IFDEF LINUX}
        if FileExists(ExtractFilePath(ParamStr(0))+'opciones.ini') then
           if Application.MessageBox('ESTA SEGURO DE QUE DESEA REEMPLAZAR' +
             #13 + 'EL FICHERO DE CONFIGURACION?', 'DocuGes',
             MB_ICONQUESTION + MB_YESNO) = idYes then begin
             DeleteFile(ExtractFilePath(ParamStr(0))+'opciones.ini');
             CopyFile(OrigenINICopia.Text,ExtractFilePath(ParamStr(0))+'opciones.ini');
           end else
             abort;

     {$ELSE}
        if FileExists(ExtractFilePath(ParamStr(0))+'opciones.ini') then
           if Application.MessageBox('ESTA SEGURO DE QUE DESEA REEMPLAZAR' +
             #13 + 'EL FICHERO DE CONFIGURACION?', 'DocuGes',
             MB_ICONQUESTION + MB_YESNO) = idYes then  begin
             DeleteFile(ExtractFilePath(ParamStr(0))+'opciones.ini');
             CopyFile(OrigenINICopia.Text,ExtractFilePath(ParamStr(0))+'opciones.ini');
           end else
             abort;

     {$ENDIF}
  end;

  ShowMessage('PROCESO DE RESTAURACION FINALIZADO');
end;

procedure TFCopiaSeg.bBtnSelClick(Sender: TObject);
begin
  OpenDialog1.Filter:='Script SQL|*.sql';
  if OpenDialog1.Execute then
     OrigenCopia.Text:=OpenDialog1.FileName
  else
     OrigenCopia.Text:='';
end;

// Generación de datos en la pestaña Estadísticas
// Inicialmente es un procedimiento de control.
procedure TFCopiaSeg.btnGenerarClick(Sender: TObject);
var
  cont : integer;
begin
  TotalRegistros:=0;
  cont:=1;
  ProgressBar3.Position:=0;
  if Query0.Active then Query0.Close;
  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+dmDatos.ZConexion.Database);
  Query0.Open;
  Query0.First;
  While not Query0.EOF do begin
     Query.SQL.Clear;
     Query.SQL.Add('select count(*) from '+dmDatos.ZConexion.Database+'.'+Query0.Fields.FieldByNumber(1).AsString);
     Query.Open;
     sgEstadisticas.RowCount:=cont+1;
     sgEstadisticas.Cells[0,cont]:=Query0.Fields.FieldByNumber(1).AsString;
     sgEstadisticas.Cells[1,cont]:=Query.Fields.FieldByNumber(1).AsString;
     TotalRegistros:=TotalRegistros+Query.Fields.FieldByNumber(1).AsInteger;
     Query.Close;
     Query0.Next;
     cont:=cont+1;
     ProgressBar3.Position := Round((Query0.RecNo*100)/Query0.RecordCount);
  end;
  Query0.Close;
  ProgressBar3.Position:=0;
  sgEstadisticas.SetFocus;
end;

procedure TFCopiaSeg.bBtnSelINIClick(Sender: TObject);
begin
  OpenDialog1.Filter:='Opciones de Configuracion INI|*.ini';
  if OpenDialog1.Execute then
     OrigenINICopia.Text:=OpenDialog1.FileName
  else
     OrigenINICopia.Text:='';
end;

procedure TFCopiaSeg.cbIncluirClick(Sender: TObject);
begin
  if cbIncluir.Checked then
     DestinoINICopia.Enabled:=true
  else
     DestinoINICopia.Enabled:=false;
end;

procedure TFCopiaSeg.cbIncluirRClick(Sender: TObject);
begin
  if cbIncluirR.Checked then
     OrigenINICopia.Enabled:=True
  else
     OrigenINICopia.Enabled:=False;
end;

procedure TFCopiaSeg.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

initialization
  {$I copiaseg.lrs}

end.

