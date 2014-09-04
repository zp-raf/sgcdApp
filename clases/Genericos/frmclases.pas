unit frmClases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, EditBtn,
  PairSplitter, frmAbm, frmsgcddatamodule, strutils;

type

  { TABMClases }

  TABMClases = class(TAbm)
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    dsProfesor: TDatasource;
    DateEditFecha: TDateEdit;
    dsDesarrolloMat: TDatasource;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelNuevoActividades: TLabel;
    LabelNuevoEvaluacion: TLabel;
    IDDesarrolloMat: TLongintField;
    LabelNuevoMaterial: TLabel;
    LabelNuevoObjEspfco: TLabel;
    LabelNuevoObjGral: TLabel;
    LabelNuevoTema: TLabel;
    MemoNuevoActividades: TMemo;
    MemoNuevoEvaluacion: TMemo;
    MemoNuevoMaterial: TMemo;
    MemoNuevoObjEspfco: TMemo;
    MemoNuevoObjGral: TMemo;
    MemoNuevoTema: TMemo;
    qryDesarrolloMat: TSQLQuery;
    qryDesarrolloMatEMPLEADOPERSONAID: TLongintField;
    qryDesarrolloMatID: TLongintField;
    qryDesarrolloMatMATERIAID: TLongintField;
    qryDesarrolloMatNOMBRE_COMPLETO: TStringField;
    qryDesarrolloMatNOMBRE_MATERIA: TStringField;
    qryDesarrolloMatNOMBRE_PERIODO: TStringField;
    qryDesarrolloMatNOMBRE_SECCION: TStringField;
    qryDesarrolloMatPERIODOLECTIVOID: TLongintField;
    qryDesarrolloMatSECCIONID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleNOMBRE_COMPLETO: TStringField;
    qryDetalleNOMBRE_MATERIA: TStringField;
    qryDetalleNOMBRE_SECCION: TStringField;
    qryProfesorID: TLongintField;
    qryProfesorNOMBRE_COMPLETO: TStringField;
    SQLQuery1ACTIVIDADES: TStringField;
    SQLQuery1DESARROLLOMATERIAID: TLongintField;
    SQLQuery1EVALUACION: TStringField;
    SQLQuery1FECHA: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MATERIALES: TStringField;
    SQLQuery1OBJETIVOGENERAL: TStringField;
    SQLQuery1OBJETIVOSESPECIFICOS: TStringField;
    SQLQuery1TEMA: TStringField;
    qryProfesor: TSQLQuery;
    qryDetalle: TSQLQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    procedure AbrirCursor; override;
    procedure DBGrid4CellClick(Column: TColumn);
    procedure DBLookupComboBox2Change(Sender: TObject);
    {procedure DBLookupComboBox1Change(Sender: TObject);
    procedure DBLookupComboBox1Exit(Sender: TObject);}
    function DatosValidos: boolean; override;
    procedure DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormResize(Sender: TObject);
    procedure Insertar; override;
    procedure Actualizar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure qryDesarrolloMatFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryProfesorFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ABMClases: TABMClases;

implementation

{$R *.lfm}

{ TABMClases }

procedure TABMClases.AbrirCursor;
begin
  try
    qryDetalle.Close;
    qryDetalle.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited AbrirCursor;
  try
    qryProfesor.Close;
    qryProfesor.Close;
    qryDesarrolloMat.Close;
    qryProfesor.Open;
    qryProfesor.Open;
    qryDesarrolloMat.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TABMClases.DBGrid4CellClick(Column: TColumn);
begin
  qryDesarrolloMat.Refresh;
end;

procedure TABMClases.DBLookupComboBox2Change(Sender: TObject);
begin
  qryDesarrolloMat.Refresh;
end;

{procedure TABMClases.DBLookupComboBox1Change(Sender: TObject);
var
  qry: string;
  qry_resul: string;
begin

  qry := 'select s.nombre from desarrollomateria dm ';
  qry := qry + 'inner join seccion s on s.id = dm.seccionid ';
  qry := qry + 'where dm.id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'nombre');
  LabelNombreSeccion.Caption := qry_resul;

  qry := '';
  qry_resul := '';
  qry := 'select s.nombre from desarrollomateria dm ';
  qry := qry + 'inner join materia s on s.id = dm.materiaid ';
  qry := qry + 'where dm.id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'nombre');
  LabelNombreMateria.Caption := qry_resul;

  qry := '';
  qry_resul := '';
  qry := 'select s.nombre from desarrollomateria dm ';
  qry := qry + 'inner join modulo s on s.id = dm.materiaid ';
  qry := qry + 'where dm.id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'nombre');
  LabelNombreModulo.Caption := qry_resul;

end;}

{ procedure TABMClases.DBLookupComboBox1Exit(Sender: TObject);
var
  qry: string;
  qry_resul: string;
begin

  qry := 'select s.nombre from desarrollomateria dm ';
  qry := qry + 'inner join seccion s on s.id = dm.seccionid ';
  qry := qry + 'where dm.id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'nombre');
  LabelNombreSeccion.Caption := qry_resul;

  qry := '';
  qry_resul := '';
  qry := 'select s.nombre from desarrollomateria dm ';
  qry := qry + 'inner join materia s on s.id = dm.materiaid ';
  qry := qry + 'where dm.id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'nombre');
  LabelNombreMateria.Caption := qry_resul;

  qry := '';
  qry_resul := '';
  qry := 'select s.nombre from desarrollomateria dm ';
  qry := qry + 'inner join modulo s on s.id = dm.materiaid ';
  qry := qry + 'where dm.id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'nombre');
  LabelNombreModulo.Caption := qry_resul;

end;}

procedure TABMClases.FormCreate(Sender: TObject);
begin
{  Self.Query :=
    'select ID, DESARROLLOMATERIAID, DESARROLLOMATERIASECCIONID, DESARROLLOMATERIAMATERIAID, DESARROLLOMATMATERIAMODID,' +
    'FECHA, TEMA, OBJETIVOGENERAL, OBJETIVOSESPECIFICOS, ACTIVIDADES, MATERIALES, EVALUACION from CLASE';
  Self.InsQuery :=
    'insert into CLASE (ID, DESARROLLOMATERIAID, DESARROLLOMATERIASECCIONID, DESARROLLOMATERIAMATERIAID,' +
    'DESARROLLOMATMATERIAMODID, FECHA, TEMA, OBJETIVOGENERAL, OBJETIVOSESPECIFICOS, ACTIVIDADES, MATERIALES, EVALUACION) values ' +
    '((SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM clase), :DESARROLLOMATERIAID, :DESARROLLOMATERIASECCIONID, :DESARROLLOMATERIAMATERIAID, :DESARROLLOMATMATERIAMODID,' +
    ':FECHA, :TEMA, :OBJETIVOGENERAL, :OBJETIVOSESPECIFICOS, :ACTIVIDADES, :MATERIALES, :EVALUACION)';}
  IniciaForm('CLASE', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }


procedure TABMClases.Insertar;
{var
  qry: string;
  qry_resul: string; }
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
  SQLQuery1TEMA.AsString := Filtrar(MemoNuevoTema.Text);
  SQLQuery1OBJETIVOGENERAL.AsString := Filtrar(MemoNuevoObjGral.Text);
  SQLQuery1OBJETIVOSESPECIFICOS.AsString := Filtrar(MemoNuevoObjEspfco.Text);
  SQLQuery1ACTIVIDADES.AsString := Filtrar(MemoNuevoActividades.Text);
  SQLQuery1MATERIALES.AsString := Filtrar(MemoNuevoMaterial.Text);
  SQLQuery1EVALUACION.AsString := Filtrar(MemoNuevoEvaluacion.Text);
  SQLQuery1FECHA.AsDateTime := DateEditFecha.Date;
  SQLQuery1DESARROLLOMATERIAID.AsInteger := qryDesarrolloMatID.AsInteger;
  {qry := 'select materiaid from desarrollomateria ';
  qry := qry + 'where id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'materiaid');
  //SQLQuery1DESARROLLOMATERIAMATERIAID.AsString := qry_resul;
  //Limpio ambos
  qry := '';
  qry_resul := '';
  qry := 'select seccionid from desarrollomateria ';
  qry := qry + 'where id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;

  qry_resul := SGCDDataModule.DevuelveValor(qry, 'seccionid');
  //SQLQuery1DESARROLLOMATERIASECCIONID.AsString:= qry_resul;
  //limpio again
  qry := '';
  qry_resul := '';
 { qry := 'select materiamoduloid from desarrollomateria ';
  qry := qry + 'where id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul:= SGCDDataModule.DevuelveValor(qry,'materiamoduloid');}
  //SQLQuery1DESARROLLOMATMATERIAMODID.AsString:= qry_resul; }

end;

procedure TABMClases.Actualizar;
{var
  qry: string;
  qry_resul: string; }
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Edit;
  SQLQuery1TEMA.AsString := Filtrar(MemoNuevoTema.Text);
  SQLQuery1OBJETIVOGENERAL.AsString := Filtrar(MemoNuevoObjGral.Text);
  SQLQuery1OBJETIVOSESPECIFICOS.AsString := Filtrar(MemoNuevoObjEspfco.Text);
  SQLQuery1ACTIVIDADES.AsString := Filtrar(MemoNuevoActividades.Text);
  SQLQuery1MATERIALES.AsString := Filtrar(MemoNuevoMaterial.Text);
  SQLQuery1EVALUACION.AsString := Filtrar(MemoNuevoEvaluacion.Text);
  SQLQuery1FECHA.AsDateTime := DateEditFecha.Date;
   {
  // Al actulizar hago esto, por si es que cambia el combobox, para que vayan sus nuevos datos
  qry := 'select materiaid from desarrollomateria ';
  qry := qry + 'where id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul := SGCDDataModule.DevuelveValor(qry, 'materiaid');
  //  SQLQuery1DESARROLLOMATERIAMATERIAID.AsString := qry_resul;
  //Limpio ambos
  qry := '';
  qry_resul := '';
  qry := 'select seccionid from desarrollomateria ';
  qry := qry + 'where id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;

  qry_resul := SGCDDataModule.DevuelveValor(qry, 'seccionid');
  // SQLQuery1DESARROLLOMATERIASECCIONID.AsString:= qry_resul;
  //limpio again
  qry := '';
  qry_resul := '';
 { qry := 'select materiamoduloid from desarrollomateria ';
  qry := qry + 'where id = ' + SQLQuery1DESARROLLOMATERIAID.AsString;
  qry_resul:= SGCDDataModule.DevuelveValor(qry,'materiamoduloid');}
  // SQLQuery1DESARROLLOMATMATERIAMODID.AsString:= qry_resul; ´}

end;



{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TABMClases.FormResize(Sender: TObject);
var
  x, y: integer;
begin
  x := trunc(Width / 3.2407);
  y := trunc(Height / 4.8897);

  MemoNuevoObjGral.Width := x;
  MemoNuevoObjEspfco.Width := x;
  MemoNuevoMaterial.Width := x;
  MemoNuevoTema.Width := x;
  MemoNuevoActividades.Width := x;
  MemoNuevoEvaluacion.Width := x;

  MemoNuevoObjGral.Height := y;
  MemoNuevoObjEspfco.Height := y;
  MemoNuevoMaterial.Height := y;
  MemoNuevoTema.Height := y;
  MemoNuevoActividades.Height := y;
  MemoNuevoEvaluacion.Height := y;
end;

procedure TABMClases.LimpiarCampos;
begin
  inherited;
  MemoNuevoTema.Clear;
  MemoNuevoObjGral.Clear;
  MemoNuevoObjEspfco.Clear;
  MemoNuevoActividades.Clear;
  MemoNuevoMaterial.Clear;
  MemoNuevoEvaluacion.Clear;
  DateEditFecha.Clear;
end;

procedure TABMClases.ModificarDatos;
begin
  GroupBox1.Enabled := False;
  MemoNuevoTema.Text := SQLQuery1TEMA.AsString;
  MemoNuevoObjGral.Text := SQLQuery1OBJETIVOGENERAL.AsString;
  MemoNuevoObjEspfco.Text := SQLQuery1OBJETIVOSESPECIFICOS.AsString;
  MemoNuevoActividades.Text := SQLQuery1ACTIVIDADES.AsString;
  MemoNuevoMaterial.Text := SQLQuery1MATERIALES.AsString;
  MemoNuevoEvaluacion.Text := SQLQuery1EVALUACION.AsString;
  DateEditFecha.Date := SQLQuery1FECHA.AsDateTime;
end;

procedure TABMClases.qryDesarrolloMatFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('EMPLEADOPERSONAID').AsInteger = qryProfesorID.AsInteger;
end;

procedure TABMClases.qryProfesorFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  if (Trim(Edit1.Text) = '') or (Edit1.Text = 'Filtrar...') then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_COMPLETO').AsString,
      Edit1.Text);
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS MENUS
 ********************************************************
 }

procedure TABMClases.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  GroupBox1.Enabled := True;
end;


{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }

function TABMClases.DatosValidos: boolean;
begin
  if (Trim(MemoNuevoTema.Text) = '') or (Trim(DateEditFecha.Text) = '') then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TABMClases.DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin

end;

procedure TABMClases.Edit1Change(Sender: TObject);
begin
  qryProfesor.Refresh;
end;

procedure TABMClases.Edit1Enter(Sender: TObject);
begin
  Edit1.Clear;
end;




{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TABMClases.OKButtonClick(Sender: TObject);
begin
  SQLQuery1.FieldByName('ID').Required := False;
  inherited;
  {
   if Estado in [Alta] then
     if not (SQLQuery1.State in [dsInsert, dsEdit]) then
       SQLQuery1.Append;
  }
end;

end.

