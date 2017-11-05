{
  DocuGes - Gestion Documental

  Autor: Xaime Alvarez Ares

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

unit Busquedas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  DBGrids, db, sqldb, ZDataset, ExtCtrls, StdCtrls, Buttons,
  LCLType;

type

  { TFBusquedas }

  TFBusquedas = class(TForm)
    BtAplicar: TBitBtn;
    BtCancelar: TBitBtn;
    BtCerrar: TBitBtn;
    CBCampos: TComboBox;
    CBFiltros: TComboBox;
    Datasource1: TDatasource;
    GridBusquedas: TDBGrid;
    EdTexto: TEdit;
    GBCampo: TGroupBox;
    GBTexto: TGroupBox;
    GroupBox1: TGroupBox;
    dbBusquedas: TZQuery;

    procedure BtAplicarClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
//    procedure CBFiltrosChange(Sender: TObject);
    procedure DividirConsulta(TxtConsulta: string);
    procedure BtCerrarClick(Sender: TObject);
    procedure CBCamposChange(Sender: TObject);
    procedure EdTextoChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ActualizaGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBusquedasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridBusquedasTitleClick(Column: TColumn);
    procedure Reordena(nColumna: integer; var AntColund: String; var Orden: String);

    function IniciaBusquedas(TxtConsulta: string; const TituloCampos: Array of string; CampoBusqueda: string ):string;
    function CargaTitulos(var TitulosGrid: TDBGrid): variant;

  private
    { private declarations }
  public
    { public declarations }
  end; 

    procedure ShowFormBusquedas;

var
  AntColumna, Orden: String;
  FBusquedas: TFBusquedas;
  ConsultaOriginal, Consulta, ConsultaAnterior: string;
  InicioConsulta, FinalConsulta: string;
  CampoBuscar: string;
//  modificador: string;
//  Comodin: string;
  Resultado: variant;
  TxtCampos: array of string;
  RefCampos: array of string;

   Modificadores: array[0..6] of string=
     ('=','<>','<=','>=',' LIKE ','N0','N1');
   Comodines: array[0..6] of string=
     ('','','','','%','','');

implementation

uses
 Funciones, recursostexto;

{ TFBusquedas }


procedure ShowFormBusquedas;
begin
  with TFBusquedas.Create(Application) do
    begin
      ShowModal;
    end;
end;


function TFBusquedas.IniciaBusquedas(TxtConsulta: string; const TituloCampos: Array of string; CampoBusqueda: string):string;
var
  contador: integer;
begin
   Resultado:='';
   AntColumna:='';
   Orden:= ' ASC';
   Consulta:= TxtConsulta;
   ConsultaOriginal:= Consulta;
   CampoBuscar:= CampoBusqueda;
 //  modificador:=' LIKE '; Comodin:='%';   al poner el combo como itemindex:=4 ya se asigna solo
   SetLength(TxtCampos, length(TituloCampos));
    for contador:=high(TituloCampos) downto low(TituloCampos)  do
       TxtCampos[contador]:= TituloCampos[contador];

   ShowFormBusquedas;
   Result:= Resultado;
end;

procedure TFBusquedas.BtAplicarClick(Sender: TObject);
begin
 // if modificador='' then                    //quitado al poner que el combo es solo el modo drowlist
//     begin
//        Showmessage(rsNoFiltro);
//        Exit;
//     end;
  case CBFiltros.ItemIndex of
    5: Consulta:= ConsultaAnterior ;
    6: Consulta:= ConsultaOriginal;
    else begin
        if edTexto.Text='' then  begin
          Showmessage(rsNoValorFiltro);
          Exit;
        end;
        ConsultaAnterior:= Consulta;
        DividirConsulta(Consulta);
        Exit;
      end;
  end;
// Solo llegan los de consultas anterior o original

   CBFiltros.ItemIndex:= 0;
   ActualizaGrid;
   CBCampos.ItemIndex:= 1;
   CBCamposChange(nil);
end;

procedure TFBusquedas.BtCancelarClick(Sender: TObject);
begin
   Resultado:=-1;
   Close();
end;

//procedure TFBusquedas.CBFiltrosChange(Sender: TObject);
//begin
// case CBFiltros.ItemIndex of
//   0: modificador:='=';
//   1: modificador:='<>';
//   2: modificador:='<=';
//   3: modificador:='>=';
//   4: begin; modificador:=' LIKE '; Comodin:='%'; end;
//   5: modificador:='N0';
//   6: modificador:='N1';
// end;
//end;

procedure TFBusquedas.BtCerrarClick(Sender: TObject);
begin
  if CampoBuscar='' then Resultado := Consulta
                    else Resultado:= dbBusquedas.FieldByName(CampoBuscar).Value;
  if (Resultado = null) then Resultado:=-1;
  Close();
end;

procedure TFBusquedas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Closeaction:=CaFree;
end;

procedure TFBusquedas.DividirConsulta(TxtConsulta: string);
var
  comillas: string;
  enlazador: string;
  Posicion:integer;
  //quitado los poswhere  y posotra  y dejado solo con uno
begin
  InicioConsulta:= TxtConsulta;
  FinalConsulta := TxtConsulta;
  Posicion:= pos('WHERE', uppercase(TxtConsulta));
  if Posicion<>0 then  begin
       enlazador:= ' AND ';
       Delete(InicioConsulta, Posicion , length(TxtConsulta));
       Delete(FinalConsulta, 1, Posicion +5  );
  end else
  begin
       enlazador:=' ';
       Posicion:= pos('GROUP BY', uppercase(TxtConsulta));
       if Posicion = 0 then
          Posicion:= pos('ORDER BY', uppercase(TxtConsulta));
       if Posicion<>0 then
       begin
          Delete(InicioConsulta, Posicion , length(TxtConsulta));
          Delete(FinalConsulta, 1, Posicion-1 );
       end else
       begin
          FinalConsulta := '';
       end;
  end;

 if dbBusquedas.Fields[CBCampos.ItemIndex].DataType in [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic, ftInteger]
   then comillas:='' else comillas:='"';

 if dbBusquedas.Fields[CBCampos.ItemIndex].DataType in [ftBytes, ftVarBytes,  ftInteger]
  then begin
   try
   strtoint(EdTexto.Text);
   except
   ShowMessage(rsErrorNumero);
   abort;
   end;

  end;
 Consulta := InicioConsulta + 'WHERE ' + RefCampos[CBCampos.ItemIndex] +
 //              modificador + comillas + Comodin + edTexto.Text+ comodin + comillas + enlazador + ' '+
    Modificadores[CBFiltros.ItemIndex] + comillas + Comodines[CBFiltros.ItemIndex] + edTexto.Text+ Comodines[CBFiltros.ItemIndex] + comillas + enlazador
//               +' ' Al poner el enlazador en vez de '' como ' ' no hace falta añadir un espacio ya que el and tambien los lleva
    + FinalConsulta;
 CBFiltros.ItemIndex:= 4;
 ActualizaGrid;
end;

procedure TFBusquedas.ActualizaGrid;
begin
//   dbBusquedas.Active:=False;
//   dbBusquedas.Sql.Text:=Consulta;
//   dbBusquedas.Active:=True;
   DaValorQuery(dbBusquedas, Consulta);

   Reordena(CBCampos.ItemIndex, AntColumna, Orden);
end;

procedure TFBusquedas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
   VK_F8:  begin key:=0; btAplicarClick(nil); End;
   VK_RETURN: begin key:=0; btCerrarClick(nil); end;
   VK_ESCAPE: begin key:=0; btCancelarClick(nil); end;
   VK_F12: begin
     if (GridBusquedas.Focused) then begin key:=0; EdTexto.SetFocus;  End else begin
       if (EdTexto.Focused) then begin key:=0; GridBusquedas.SetFocus;  End;
     end;
    end;
  end;
end;

procedure TFBusquedas.GridBusquedasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) then begin key:=0; btCerrarClick(nil); end;
end;

procedure TFBusquedas.GridBusquedasTitleClick(Column: TColumn);
begin
    ConsultaAnterior:= Consulta;
    CBCampos.ItemIndex:= Column.Index;
    Reordena(Column.Index, AntColumna, Orden);
    Consulta:= dbBusquedas.SQL.Text;
end;

procedure TFBusquedas.CBCamposChange(Sender: TObject);
begin
    ConsultaAnterior:= Consulta;
    GridBusquedas.SelectedColumn.Index:=CBCampos.ItemIndex;
    Reordena(CBCampos.ItemIndex, AntColumna, Orden);
    Consulta:= dbBusquedas.SQL.Text;
end;

procedure TFBusquedas.EdTextoChange(Sender: TObject);
begin
 if dbBusquedas.Fields[CBCampos.ItemIndex].DataType in [ftBytes, ftVarBytes,  ftInteger]
   then begin
   try
   strtoint(EdTexto.Text);
   dbBusquedas.Locate(RefCampos[CBCampos.ItemIndex], EdTexto.Text, [loPartialkey, loCaseInsensitive] )

   except
   ShowMessage(rsErrorNumero);
   end;
    end else begin
    dbBusquedas.Locate(RefCampos[CBCampos.ItemIndex], EdTexto.Text, [loPartialkey, loCaseInsensitive] )

   end;
end;


procedure TFBusquedas.FormActivate(Sender: TObject);
begin
  GridBusquedas.SetFocus;
end;

procedure TFBusquedas.FormCreate(Sender: TObject);
var
   ncontador, columnasvisibles, ncolumnas: integer;
begin
  self.BorderStyle:=bsSizeable;
//  dbBusquedas.SQL.Text:=ConsultaOriginal;
  Datasource1.DataSet:=dbBusquedas;
//  dbBusquedas.Active:= True;
  DaValorQuery(dbBusquedas, ConsultaOriginal);
  columnasvisibles:= GridBusquedas.Columns.VisibleCount;
  CBCampos.Clear;
  setlength(RefCampos, columnasvisibles);
  CBCampos.ItemIndex:=1;
  for ncolumnas:=0 to columnasvisibles-1 do
      begin
        RefCampos[ncolumnas]:=dbBusquedas.Fields.Fields[ncolumnas].FieldName;
        CBCampos.Items.Add(txtCampos[ncolumnas]);
        If CampoBuscar = RefCampos[ncolumnas] then CBCampos.ItemIndex:=ncolumnas;
      end;
  for ncontador:=0 to length(txtCampos)-1 do
      GridBusquedas.Columns.Items[ncontador].Title.Caption:= txtCampos[ncontador];
  CBCamposChange(nil);
end;

procedure TFBusquedas.Reordena(nColumna: integer; var AntColund: String; var Orden: String);
var
 TxtQuery,TxtQuery1: String;
 ncontador,x,j: integer;
begin
  TxtQuery:=dbBusquedas.Sql.Text;
  j:=length(TxtQuery);
  x:=pos('ORDER',TxtQuery);
  if x=0 then x:=pos('ORDER',TxtQuery);
  delete(TxtQuery,x,j-(x-1));
  BlancoGrid(GridBusquedas);
  if AntColund <> '' then
     begin
        If StrToIntDEf(AntColund,0) = nColumna Then
          if Orden = ' ASC' then Orden:='DESC' else Orden:=' ASC';
     end;
  TxtQuery1:=' ORDER BY ' + RefCampos[nColumna] +' '+ Orden;
  Insert(TxtQuery1,TxtQuery,j);
//  dbBusquedas.Active:=False;
//  dbBusquedas.Sql.Text:=TxtQuery;
//  dbBusquedas.Active:=True;
  DaValorQuery(dbBusquedas, TxtQuery);
  AntColund:=IntTostr(nColumna);
  if Orden = 'DESC' then GridBusquedas.Columns.Items[nColumna].Color := $00DEDEF5 else
                         GridBusquedas.Columns.Items[nColumna].Color := clSkyBlue;
  for ncontador:=0 to length(txtCampos)-1 do
      GridBusquedas.Columns.Items[ncontador].Title.Caption:= txtCampos[ncontador];
  GridBusquedas.Columns.Items[nColumna].Title.Caption:=GridBusquedas.Columns.Items[nColumna].Title.Caption + ' ['+orden+']';
end;

function TFBusquedas.CargaTitulos(var TitulosGrid: TDBGrid): variant;
var
  ncontador: integer;
  Titulos: array of string;
begin
  setlength(Titulos, TitulosGrid.Columns.VisibleCount);
  for ncontador:=0 to length(TxtCampos)-1 do
      Titulos[ncontador]:=TitulosGrid.Columns.Items[ncontador].Title.Caption;
  Result:= Titulos;
end;

initialization
  {$I busquedas.lrs}

end.

