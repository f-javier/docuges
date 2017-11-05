{
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

unit ActualizaBBDD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, Buttons, ExtCtrls, Grids, StdCtrls, CheckLst, ZConnection, ZDataset,
  strutils, Inifiles, Process, LCLType;

type

  { TFActualizaBBDD }

  TFActualizaBBDD = class(TForm)
    BitBtn1: TBitBtn;
    bBtnActualizar: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    clbTablas: TCheckListBox;
    Edit1: TEdit;
    edProtocolo: TEdit;
    edServidor: TEdit;
    edUsuario: TEdit;
    edClave: TEdit;
    edBBDD: TEdit;
    edPuerto: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbServidor: TLabel;
    lbUsuario: TLabel;
    lbBBDD: TLabel;
    lbPuerto: TLabel;
    lbProtocolo: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    sgTablas: TStringGrid;
    dbConect: TZConnection;
    Query0: TZQuery;
    Query1: TZQuery;
    Query2: TZQuery;
    procedure bBtnActualizarClick(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure RevisarTablas(Sender: TObject);
    procedure CargarTablas(Sender: TObject);
    procedure clbTablasClick(Sender: TObject);
    function FiltrarCadena(cadena: string): String;
    function CargarFL2(Tabla: String): String;
    function CargarCampos(Tabla: String): String;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Inicia();
    procedure Panel1Enter(Sender: TObject);
    procedure Conectate();
    procedure PresentaDatosConexion();

  private
    { private declarations }
  public
    { public declarations }
    IniReader : TIniFile;
    Sections : TStringList;
    Contents : TStringList;
  end; 


var
  FActualizaBBDD: TFActualizaBBDD;
  FileTemporal: String;
  ExisteConfig: Boolean;
  Aprocess: TProcess;
  AStringList: TStringList;

implementation

{ TFActualizaBBDD }

uses
   funciones;

//=========================== CREAR FORMULARIO ======================
procedure TFActualizaBBDD.FormCreate(Sender: TObject);
begin
   ShortDateFormat:='DD/MM/YYYY';

  {$IFDEF LINUX}
     DecimalSeparator:='.';

     // Comprobamos si la aplicación es para desarrollo o en producción.
     AProcess := TProcess.Create(nil);
     AStringList := TStringList.Create;
     AProcess.CommandLine := 'pwd';
     AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
     AProcess.Execute;
     AStringList.LoadFromStream(AProcess.Output);
     AProcess.Free; AStringList.Free;
  {$ELSE}
     DecimalSeparator:='.';
  {$ENDIF}
  Label5.Caption := 'Rev. 1.0-rc1';
end;

procedure TFActualizaBBDD.Inicia();
begin
 if FileExists(ExtractFilePath(ParamStr(0))+'opciones.ini') then
   begin
    OpenDialog1.FileName:=ExtractFilePath(ParamStr(0))+'opciones.ini';
    IniReader := TIniFile.Create(OpenDialog1.FileName);
    Sections := TStringList.Create;
    Contents := TStringList.Create;
    IniReader.ReadSections( Sections );
    //----------------- Conexion -----------------
    if IniReader.ReadString('BBDD','host','')<>'' then
     begin
      edServidor.Text:=IniReader.ReadString('BBDD','host','');
      edBBDD.Text:=IniReader.ReadString('BBDD','database','');
      edUsuario.Text:=IniReader.ReadString('BBDD','user','');
      edClave.Text:=IniReader.ReadString('BBDD','pass','');
      edPuerto.Text:=IniReader.ReadString('BBDD','port','');
      edProtocolo.Text:=IniReader.ReadString('BBDD','protocol','');
     end;
     PresentaDatosConexion();
     Conectate(); Exit;
  end ;

    // Presentamos datos de conexión y permitimos cambios.
  panel2.Visible:=True; edClave.SetFocus;

end;

procedure TFActualizaBBDD.PresentaDatosConexion();
begin
  lbServidor.Caption:='SERVIDOR : '+ edServidor.Text;
  lbBBDD.Caption:='BASE DE DATOS : '+ edBBDD.Text;
  lbUsuario.Caption:='USUARIO : '+ edUsuario.Text;
  lbPuerto.Caption:='PUERTO : '+ edPuerto.Text;
  lbProtocolo.Caption:='PROTOCOLO : ' + edProtocolo.Text;

end;

procedure TFActualizaBBDD.Conectate();
begin
  dbConect.HostName:=edServidor.Text;
  dbConect.Database:=edBBDD.Text;
  dbConect.User:=edUsuario.Text;
  dbConect.Password:=edClave.Text;
  dbConect.Port:=StrToInt(edPuerto.Text);
  dbConect.Protocol:=edProtocolo.Text;
  dbConect.Connected:=True;

  RevisarTablas(Self);
  CargarTablas(self);
  {$IFDEF LINUX}
  FileTemporal:='/tmp/QWASZX.TXT';
  {$ELSE}
   FileTemporal:='C:/QWASZX.TXT';
  {$ENDIF}
end;

procedure TFActualizaBBDD.Panel1Enter(Sender: TObject);
begin
  Inicia();
end;


//====================== CERRAR FORMULARIO ===========================
procedure TFActualizaBBDD.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFActualizaBBDD.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;


// Procedimiento utilizado para filtrar una cadena y eliminar los carácteres no válidos
function TFActualizaBBDD.FiltrarCadena(cadena: String): String;
var
  cont : integer;
begin
   cont := 1;
   while cont <= length(cadena) do begin
       if ((cadena[cont]=#10) or (cadena[cont]='`')) then delete(cadena,cont,1);
       cont := cont + 1;
   end;
   Result := cadena;
end;

// Procedimiento en el que se comprueban si hay tablas temporales generadas
// por algún error ocurrido en una ejecución anterior.
// En el caso de que exista, contiene los datos coorectos de la tabla
// por lo que se borrará la tabla sin extensión y se renombrará la temporal.
procedure TFActualizaBBDD.RevisarTablas(Sender: TObject);
begin
  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+dbConect.Database);
  Query0.Open;
  Query0.First;
  While not Query0.EOF do begin
        if (copy(Query0.Fields.FieldByNumber(1).AsString, length(Query0.Fields.FieldByNumber(1).AsString)-3,4)) = '_tmp' then begin
           // Existe la tabla temporal
           // Se pide confirmación de reparación al usuario y en caso afirmativo se deja la tabla _tmp como normal
           if Application.MessageBox(PChar('¿DESEA REPARAR LA TABLA '+Query0.Fields.FieldByNumber(1).AsString+'?'),'FacturLinEx', MB_ICONQUESTION + MB_YESNO) = IDYES then begin
              Query1.SQL.Clear;
              // ShowMessage('DROP TABLE IF EXISTS '+copy(Query0.Fields.FieldByNumber(1).AsString, 1,length(Query0.Fields.FieldByNumber(1).AsString)-4)+';');
              Query1.SQL.Add('DROP TABLE IF EXISTS '+copy(Query0.Fields.FieldByNumber(1).AsString, 1,length(Query0.Fields.FieldByNumber(1).AsString)-4)+';');
              Query1.ExecSQL;
              Query1.Close;

              Query1.SQL.Clear;
              // ShowMessage('RENAME TABLE '+Query0.Fields.FieldByNumber(1).AsString+' TO '+copy(Query0.Fields.FieldByNumber(1).AsString, 1,length(Query0.Fields.FieldByNumber(1).AsString)-4)+';');
              Query1.SQL.Add('RENAME TABLE '+Query0.Fields.FieldByNumber(1).AsString+' TO '+copy(Query0.Fields.FieldByNumber(1).AsString, 1,length(Query0.Fields.FieldByNumber(1).AsString)-4)+';');
              Query1.ExecSQL;
              Query1.Close;
           end;
        end;
        Query0.Next;
  end;
  Query0.Close;
end;

// Cargar el objeto TCheckListBox con las tablas existentes en la BBDD
procedure TFActualizaBBDD.CargarTablas(Sender: TObject);
begin
  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+dbConect.Database);
  Query0.Open;
  Query0.First;
  clbTablas.Clear;
  While not Query0.EOF do begin
        clbTablas.Items.Add(Query0.Fields.FieldByNumber(1).AsString);
        Query0.Next;
  end;
  Query0.Close;
end;

procedure TFActualizaBBDD.bBtnActualizarClick(Sender: TObject);
var
  cont, posicion: integer;
  tabla, txt, txt2: string;
  F: TextFile;
begin
  // Se revisan todos las tablas para procesar las actualizaciones
  for cont:=0 to clbTablas.Count-1 do begin
      if (clbTablas.Checked[cont]) then begin
         label4.Visible:=true;
         Edit1.Visible:=true;
         Edit1.Text:='Procesando tabla '+clbTablas.Items.Strings[cont];
         Application.ProcessMessages;
         // Si existe el fichero temporal de traspaso, se borra
         if FileExists(FileTemporal) then DeleteFile(FileTemporal);
         // Se renombran las tablas seleccionadas a tabla-temporal
         if Query1.Active then Query1.Close;
         Query1.SQL.Clear;
//         ShowMessage('RENAME TABLE '+clbTablas.Items.Strings[cont]+' TO '+clbTablas.Items.Strings[cont]+'_tmp;');
         Query1.SQL.Add('RENAME TABLE '+clbTablas.Items.Strings[cont]+' TO '+clbTablas.Items.Strings[cont]+'_tmp;');
         Query1.ExecSQL;
         Query1.Close;

         // Se carga la sentencia Create de la tabla especificada y se ejecuta, creando la tabla nueva
         Query1.SQL.Clear;
         // ShowMessage(CargarFL2(clbTablas.Items.Strings[cont]));
         Query1.SQL.Add(CargarFL2(clbTablas.Items.Strings[cont]));
         Query1.ExecSQL;
         Query1.Close;

         // Asignación el Juego de Caracteres
         if Query1.Active then Query1.Close;
         Query1.SQL.Clear;
         Query1.SQL.Add('SET @@global.character_set_client = UTF8;');
         Query1.ExecSQL;
         // Se traspasa la información de la tabla temporal a la nueva tabla creada
         // El traspaso se realiza con el apoyo de un fichero temporal de text
         if Query1.Active then Query1.Close;
         Query1.SQL.Clear;
//         ShowMessage('SELECT * FROM '+clbTablas.Items.Strings[cont]+'_tmp INTO OUTFILE '''+FileTemporal+''';');
         Query1.SQL.Add('SELECT * FROM '+clbTablas.Items.Strings[cont]+'_tmp INTO OUTFILE '''+FileTemporal+''';');
         Query1.ExecSQL;
         Query1.Close;

         Query1.SQL.Clear;
//         ShowMessage('LOAD DATA INFILE '''+FileTemporal+''' INTO TABLE '+clbTablas.Items.Strings[cont]+' ('+CargarCampos(clbTablas.Items.Strings[cont]+'_tmp')+');');
         Query1.SQL.Add('LOAD DATA INFILE '''+FileTemporal+''' INTO TABLE '+clbTablas.Items.Strings[cont]+' CHARACTER SET utf8 ('+CargarCampos(clbTablas.Items.Strings[cont]+'_tmp')+');');
         Query1.ExecSQL;
         Query1.Close;

         // Borrado de la tabla temporal
         Query1.SQL.Clear;
//         ShowMessage('DROP TABLE '+clbTablas.Items.Strings[cont]+'_tmp;');
         Query1.SQL.Add('DROP TABLE '+clbTablas.Items.Strings[cont]+'_tmp;');
         Query1.ExecSQL;
         Query1.Close;

         // Borrado del fichero temporal de traspaso
         deletefile(FileTemporal);

//         ShowMessage('PROCESO FINALIZADO');
         Edit1.Visible:=false;
         label4.Visible:=false;
      end;
  end;

  // Procesamos el fichero createall.sql para añadir las tablas que no existan
  {$IFDEF LINUX}
      AssignFile(F,ExtractFilePath(ParamStr(0))+'scripts/createall.sql');
  {$ELSE}
    AssignFile(F,ExtractFilePath(ParamStr(0))+'scripts/createall.sql');
  {$ENDIF}
  Reset(F);
  while not EOF(F) do
    begin
     Readln(F,Txt);
     if (Txt<>'') and (copy(Txt,1,1)<>'#') then
       begin
           Query1.SQL.Text:=Txt;
           Query1.ExecSQL;
       end;
    end;
    CloseFile(F);
end;

procedure TFActualizaBBDD.BitBtn19Click(Sender: TObject);
begin
      PresentaDatosConexion();
      Conectate();
      panel2.Visible:=False;
end;

//======================= MARCAR/DESMARCAR TODAS LAS TABLAS ==================
procedure TFActualizaBBDD.BitBtn2Click(Sender: TObject);
var
  cont: integer;
begin
  for cont:=0 to clbTablas.Count-1 do begin
       if clbTablas.Checked[cont]=True then
          clbTablas.Checked[cont]:=False else clbTablas.Checked[cont]:=True;
  end;
end;

//======================= DESMARCAR TODAS LAS TABLAS ==================
procedure TFActualizaBBDD.clbTablasClick(Sender: TObject);
var
  cont, cant : integer;
begin
  // la propiedad SelCount del objeto TCheckListBox debería devolver un entero
  // con el número de items seleccionados, por lo menos es lo que dice la ayuda.
  // Mientras se soluciona el bug (si es que es un bug) se cuentan directamente.
  cant:=0;
  for cont:=0 to clbTablas.Count-1 do begin
       if (clbTablas.Checked[cont]) then cant:=cant+1;
  end;
  Label1.Caption:='Tablas seleccionadas: '+IntToStr(cant)+
                   ' / '+IntToStr(clbTablas.Count);
end;

// ----- Procesos de Carga y Visualización de datos del fichero createall.SQL
// ----- Datos extraidos del fichero scripts/createall.sql
function TFActualizaBBDD.CargarFL2(Tabla: String): String;
var
  F: TFileStream;
  s, NombreTbl, strcreate: String;
  posicion: integer;
begin
  {$IFDEF LINUX}
    F := TFileStream.Create(ExtractFilePath(ParamStr(0))+'scripts/createall.sql',fmOpenRead);
  {$ELSE}
    F := TFileStream.Create('scripts/createall.sql',fmOpenRead);
  {$ENDIF}
  SetLength( s, F.Size );
  F.Read( s[1], F.Size );
  F.Free;
  // La variable s contiene todo el contenido de createall.sql
  // Buscamos el create table que necesitamos para la comparación
  NombreTbl:=Tabla;
  posicion:=Pos('CREATE TABLE IF NOT EXISTS '+NombreTbl,s);
  if posicion=0 then begin
     ShowMessage('¡¡¡ NO ES POSIBLE LOCALIZAR LA TABLA '+NombreTbl+' EN facturlinex2.sql !!!');
     abort;
  end else begin
     delete(s,1,posicion-1);   // borramos todo el texto anterior...
     posicion:=Pos('CHARSET=utf8',s);
     strcreate := FiltrarCadena(copy(s,1,posicion+12));
  end;
  result:=strcreate;
end;

// ----- Procesos de Cargar los campos de una tabla de MySQL
function TFActualizaBBDD.CargarCampos(Tabla: String): String;
var
  NombreTbl, NombreDev: String;
begin
  NombreTbl:=Tabla;
  NombreDev:='';
  if Query2.Active then Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Add('SHOW COLUMNS FROM '+dbConect.Database+'.'+Tabla);
  Query2.Open;
  Query2.First;
  while not Query2.EOF do begin
        NombreDev := NombreDev + Query2.Fields[0].AsString;
        Query2.Next;
        if not Query2.EOF then NombreDev := NombreDev + ',';;
  end;
  Query2.Close;
  result:=NombreDev;
end;


initialization
  {$I actualizabbdd.lrs}

end.
