unit frmMaterias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, PairSplitter,
  frmAbm, frmsgcddatamodule;

type

  { TAbmMaterias }

  TAbmMaterias = class(TAbm)
    ButtonAgregar: TButton;
    ButtonEliminar: TButton;
    ButtonPre: TButton;
    CheckBoxComun: TCheckBox;
    CheckBoxNuevoHabilitado: TCheckBox;
    DatasourcePre: TDatasource;
    DatasourceMat: TDatasource;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBLookupComboBoxGrupo: TDBLookupComboBox;
    DBLookupComboBoxModulo: TDBLookupComboBox;
    dsModulo: TDatasource;
    dsGrupo: TDatasource;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBoxPre: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEditDuracion: TLabeledEdit;
    LabeledEditNuevoDescripcion: TLabeledEdit;
    LabeledEditNuevoNombre: TLabeledEdit;
    LabelNuevoBibliografia: TLabel;
    LabelNuevoContenido: TLabel;
    LabelNuevoEstrategia: TLabel;
    LabelNuevoEvaluacion: TLabel;
    LabelNuevoGrupo: TLabel;
    LabelNuevoJustificacion: TLabel;
    LabelNuevoMaterial: TLabel;
    LabelNuevoModulo: TLabel;
    LabelNuevoObjetivos: TLabel;
    MemoNuevoBibliografia: TMemo;
    MemoNuevoContenido: TMemo;
    MemoNuevoEstrategia: TMemo;
    MemoNuevoEvaluacion: TMemo;
    MemoNuevoJustificacion: TMemo;
    MemoNuevoMaterial: TMemo;
    MemoNuevoObjetivos: TMemo;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryGrupoDESCRIPCION: TStringField;
    qryGrupoHABILITADO: TLongintField;
    qryGrupoID: TLongintField;
    qryGrupoNOMBRE: TStringField;
    qryModulo: TSQLQuery;
    qryGrupo: TSQLQuery;
    qryModuloID: TLongintField;
    qryModuloNOMBRE: TStringField;
    SQLQuery1BIBLIOGRAFIA: TStringField;
    SQLQuery1CONTENIDO: TStringField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1DURACION: TStringField;
    SQLQuery1ESTRATEGIAS: TStringField;
    SQLQuery1EVALUACION: TStringField;
    SQLQuery1GRUPOID: TLongintField;
    SQLQuery1HABILITADA: TSmallintField;
    SQLQuery1ID: TLongintField;
    SQLQuery1JUSTIFICACION: TStringField;
    SQLQuery1MATERIALES: TStringField;
    SQLQuery1MODULOID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQuery1OBJETIVOS: TStringField;
    SQLQuery2: TSQLQuery;
    SQLQuery2ID: TLongintField;
    SQLQuery2NOMBRE_GRUPO: TStringField;
    SQLQuery2NOMBRE_MAT: TStringField;
    SQLQuery3: TSQLQuery;
    SQLQuery3ANTERIOR: TLongintField;
    SQLQuery3GRUPOID: TLongintField;
    SQLQueryMat: TSQLQuery;
    SQLQueryMatGRUPOID: TLongintField;
    SQLQueryMatID: TLongintField;
    SQLQueryMatNOMBRE_MAT: TStringField;
    SQLQueryPre: TSQLQuery;
    SQLQueryPreMATERIAID: TLongintField;
    SQLQueryPreMATERIAID_PRE: TLongintField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    procedure AbrirCursor; override;
    procedure Borrar; override;
    procedure ButtonAgregarClick(Sender: TObject);
    procedure ButtonEliminarClick(Sender: TObject);
    procedure ButtonPreClick(Sender: TObject);
    procedure CheckBoxComunChange(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormResize(Sender: TObject);
    procedure GroupBox1Resize(Sender: TObject);
    procedure GroupBox2Resize(Sender: TObject);
    procedure GroupBoxPreResize(Sender: TObject);
    procedure Insertar; override;
    procedure Actualizar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure SQLQuery3FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryMatFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryPreFilterRecord(DataSet: TDataSet; var Accept: boolean);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmMaterias: TAbmMaterias;
  MateriaID: integer;

implementation

{$R *.lfm}

{ TAbmMaterias }

procedure TAbmMaterias.FormCreate(Sender: TObject);
begin
{   Self.Query :=
    'select ID, MODULOID, NOMBRE, DESCRIPCION, DURACION, JUSTIFICACION, OBJETIVOS, CONTENIDO, ESTRATEGIAS, MATERIALES,' +
    'EVALUACION, BIBLIOGRAFIA, HABILITADA, GRUPOID, GRUPOMODULOID from MATERIA';
  Self.InsQuery :=
    'insert into MATERIA (ID, MODULOID, NOMBRE, DESCRIPCION, DURACION, JUSTIFICACION, OBJETIVOS, CONTENIDO, ESTRATEGIAS,' +
    'MATERIALES, EVALUACION, BIBLIOGRAFIA, HABILITADA, GRUPOID, GRUPOMODULOID) VALUES ' +
    '((SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM MATERIA), :MODULOID, :NOMBRE, :DESCRIPCION, :DURACION,' +
    ':JUSTIFICACION, :OBJETIVOS, :CONTENIDO, :ESTRATEGIAS,' +
    ':MATERIALES, :EVALUACION, :BIBLIOGRAFIA, :HABILITADA, :GRUPOID, NULL)';}
  IniciaForm('MATERIA', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmMaterias.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    //cerrar
    qryGrupo.Close;
    qryModulo.Close;
    SQLQuery2.Close;
    SQLQuery3.Close;
    SQLQueryPre.Close;
    SQLQueryMat.Close;
    //abrir
    SQLQuery3.Open;
    SQLQuery2.Open;
    qryModulo.Open;
    qryGrupo.Open;
    SQLQueryPre.Open;
    SQLQueryMat.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmMaterias.Borrar;
begin
  try
    if not (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Edit;
    SQLQuery1HABILITADA.AsInteger := 0;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmMaterias.Insertar;
begin
  {para que no se inserte nada si ya se inserto}
  if not (SQLQuery1.State in [dsInsert]) then
    Exit;
  MateriaID := StrToInt(SGCDDataModule.DevuelveValor(
    'select coalesce(max(id),0)+1 as id from materia', 'id'));
  SQLQuery1ID.AsInteger := MateriaID;
  if CheckBoxComun.Checked then
    SQLQuery1MODULOID.Clear;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  SQLQuery1DURACION.AsString := Filtrar(LabeledEditDuracion.Text);
  SQLQuery1JUSTIFICACION.AsString := Filtrar(MemoNuevoJustificacion.Text);
  SQLQuery1OBJETIVOS.AsString := Filtrar(MemoNuevoObjetivos.Text);
  SQLQuery1CONTENIDO.AsString := Filtrar(MemoNuevoContenido.Text);
  SQLQuery1ESTRATEGIAS.AsString := Filtrar(MemoNuevoEstrategia.Text);
  SQLQuery1MATERIALES.AsString := Filtrar(MemoNuevoMaterial.Text);
  SQLQuery1EVALUACION.AsString := Filtrar(MemoNuevoEvaluacion.Text);
  SQLQuery1BIBLIOGRAFIA.AsString := Filtrar(MemoNuevoBibliografia.Text);
  if CheckBoxNuevoHabilitado.Checked then
    SQLQuery1HABILITADA.AsInteger := 1
  else
    SQLQuery1HABILITADA.AsInteger := 0;
end;

procedure TAbmMaterias.Actualizar;
begin
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  SQLQuery1DURACION.AsString := Filtrar(LabeledEditDuracion.Text);
  SQLQuery1JUSTIFICACION.AsString := Filtrar(MemoNuevoJustificacion.Text);
  SQLQuery1OBJETIVOS.AsString := Filtrar(MemoNuevoObjetivos.Text);
  SQLQuery1CONTENIDO.AsString := Filtrar(MemoNuevoContenido.Text);
  SQLQuery1ESTRATEGIAS.AsString := Filtrar(MemoNuevoEstrategia.Text);
  SQLQuery1MATERIALES.AsString := Filtrar(MemoNuevoMaterial.Text);
  SQLQuery1EVALUACION.AsString := Filtrar(MemoNuevoEvaluacion.Text);
  SQLQuery1BIBLIOGRAFIA.AsString := Filtrar(MemoNuevoBibliografia.Text);
  if CheckBoxNuevoHabilitado.Checked then
    SQLQuery1HABILITADA.AsInteger := 1
  else
    SQLQuery1HABILITADA.AsInteger := 0;
end;


procedure TAbmMaterias.SQLQueryMatFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := (not SQLQueryPre.Locate('MATERIAID_PRE', DataSet.FieldByName('ID').AsString,
    [loCaseInsensitive])) and {(not (DataSet.FieldByName('ID').AsInteger =
    SQLQuery1ID.AsInteger)) and (not (DataSet.FieldByName('GRUPOID').AsInteger =
    SQLQuery1GRUPOID.AsInteger));} SQLQuery3.Locate('ANTERIOR',
    DataSet.FieldByName('GRUPOID').AsString, [loCaseInsensitive]);
end;

procedure TAbmMaterias.SQLQueryPreFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('MATERIAID').AsInteger = MateriaID;
end;

procedure TAbmMaterias.SQLQuery3FilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('GRUPOID').AsInteger = SQLQuery1GRUPOID.AsInteger;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmMaterias.FormResize(Sender: TObject);
var
  x: integer;
begin
  x := trunc(Width / 2.0645);
  GroupBox1.Width := x;
  GroupBox2.Width := x;
end;

procedure TAbmMaterias.GroupBox1Resize(Sender: TObject);
var
  y: integer;
begin
  y := trunc(GroupBox2.Height / 7.3182);
  MemoNuevoMaterial.Height := y;
  MemoNuevoBibliografia.Height := y;
  MemoNuevoEvaluacion.Height := y;
end;

procedure TAbmMaterias.GroupBox2Resize(Sender: TObject);
var
  y: integer;
begin
  y := trunc(GroupBox2.Height / 7.3182);
  MemoNuevoJustificacion.Height := y;
  MemoNuevoObjetivos.Height := y;
  MemoNuevoContenido.Height := y;
  MemoNuevoEstrategia.Height := y;
end;

procedure TAbmMaterias.GroupBoxPreResize(Sender: TObject);
var
  x: integer;
begin
  x := trunc(GroupBoxPre.Width / 2.2407);
  DBGrid3.Width := x;
  DBGrid4.Width := x;
end;

procedure TAbmMaterias.LimpiarCampos;
begin
  inherited;
  LabeledEditNuevoNombre.Clear;
  LabeledEditNuevoDescripcion.Clear;
  LabeledEditDuracion.Clear;
  MemoNuevoJustificacion.Clear;
  MemoNuevoObjetivos.Clear;
  MemoNuevoContenido.Clear;
  MemoNuevoEstrategia.Clear;
  MemoNuevoMaterial.Clear;
  MemoNuevoEvaluacion.Clear;
  MemoNuevoBibliografia.Clear;
end;

procedure TAbmMaterias.ModificarDatos;
begin
  //parche para que funcionen los lookups, se pone en edicion aca en vez de al hacer ok :(
  if not (SQLQuery1.State in [dsEdit]) then
    SQLQuery1.Edit;

  SQLQuery3.Refresh;
  SQLQueryMat.Refresh;
  SQLQueryPre.Refresh;
  ButtonPre.Enabled := True;

  MateriaID := SQLQuery1ID.AsInteger;
  LabeledEditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  LabeledEditNuevoDescripcion.Text := SQLQuery1DESCRIPCION.AsString;
  LabeledEditDuracion.Text := SQLQuery1DURACION.AsString;
  MemoNuevoJustificacion.Text := SQLQuery1JUSTIFICACION.AsString;
  MemoNuevoObjetivos.Text := SQLQuery1OBJETIVOS.AsString;
  MemoNuevoContenido.Text := SQLQuery1CONTENIDO.AsString;
  MemoNuevoEstrategia.Text := SQLQuery1ESTRATEGIAS.AsString;
  MemoNuevoMaterial.Text := SQLQuery1MATERIALES.AsString;
  MemoNuevoEvaluacion.Text := SQLQuery1EVALUACION.AsString;
  MemoNuevoBibliografia.Text := SQLQuery1BIBLIOGRAFIA.AsString;
  if SQLQuery1HABILITADA.AsInteger = 1 then
    CheckBoxNuevoHabilitado.Checked := True
  else
    CheckBoxNuevoHabilitado.Checked := False;
  if SQLQuery1MODULOID.IsNull then
    CheckBoxComun.Checked := True
  else
    CheckBoxComun.Checked := False;
  //ButtonPreClick(Self);//para que se puedan editar directamente los prerreqisitos
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS MENUS
 ********************************************************
 }

procedure TAbmMaterias.MenuItemModificarClick(Sender: TObject);
begin
  inherited MenuItemModificarClick(Sender);
  GroupBoxPre.Enabled := True;
  ButtonPre.Enabled := True;
end;

procedure TAbmMaterias.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  DBLookupComboBoxModulo.Enabled := True;
  CheckBoxComun.Checked := False;
  DBLookupComboBoxModulo.SetFocus;
  GroupBoxPre.Enabled := False;
  ButtonPre.Enabled := True;

  //parche para que funcionen los lookupcombobox :(
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;

end;


{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }

function TAbmMaterias.DatosValidos: boolean;
begin
  if (Trim(LabeledEditNuevoNombre.Text) = '') or
    ((Trim(DBLookupComboBoxModulo.Text) = '') and not CheckBoxComun.Checked) or
    (Trim(DBLookupComboBoxGrupo.Text) = '') then
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


{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TAbmMaterias.DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  inherited;
end;

procedure TAbmMaterias.DBGrid2DblClick(Sender: TObject);
begin
  inherited;
end;

procedure TAbmMaterias.ButtonAgregarClick(Sender: TObject);
begin
  if SQLQueryMat.IsEmpty then
    Exit;
  try
    SQLQueryPre.Append;
    SQLQueryPreMATERIAID.AsInteger := MateriaID;
    SQLQueryPreMATERIAID_PRE.AsInteger := SQLQueryMatID.AsInteger;
    {
     ShowMessage(SQLQueryPreMATERIAID.AsString);
     ShowMessage(SQLQueryPreMATERIAID_PRE.AsString);
    }
    SQLQueryPre.ApplyUpdates;
    SQLQueryPre.Refresh;
    SQLQueryMat.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmMaterias.ButtonEliminarClick(Sender: TObject);
begin
  if SQLQueryPre.IsEmpty then
    Exit;
  try
    SQLQueryPre.Delete;
    SQLQueryPre.ApplyUpdates;
    SQLQueryPre.Refresh;
    SQLQueryMat.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmMaterias.ButtonPreClick(Sender: TObject);
begin
  try
    if (Estado in [Alta]) then
    begin
      Insertar;
      SQLQuery1.ApplyUpdates;
    end;
    SQLQuery3.Close;
    SQLQuery3.Open;
    SQLQueryPre.Refresh;
    SQLQueryMat.Refresh;
    ButtonPre.Enabled := False;
    GroupBoxPre.Enabled := True;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmMaterias.CheckBoxComunChange(Sender: TObject);
begin
  if CheckBoxComun.Checked then
  begin
    DBLookupComboBoxModulo.Enabled := False;
  end
  else
  begin
    DBLookupComboBoxModulo.Enabled := True;
  end;
end;


procedure TAbmMaterias.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
    MenuItemNuevoClick(Self);
end;


end.
