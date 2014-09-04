unit frmgrupos2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics,
  Dialogs, Menus, ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls,
  frmAbm, frmsgcddatamodule;

type

  { TABMGrupos }

  TABMGrupos = class(TAbm)
    CheckBoxNuevoActivo: TCheckBox;
    DatasourceAnterior: TDatasource;
    DBLookupComboBox1: TDBLookupComboBox;
    Label1: TLabel;
    LabeledEditNuevoDescripcion: TLabeledEdit;
    LabeledEditNuevoNombre: TLabeledEdit;
    SQLQuery1ANTERIOR: TLongintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1HABILITADO: TLongintField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQueryAnterior: TSQLQuery;
    SQLQueryAnteriorID: TLongintField;
    SQLQueryAnteriorNOMBRE: TStringField;
    procedure AbrirCursor; override;
    procedure Actualizar; override;
    procedure Borrar; override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemEliminarClick(Sender: TObject); override;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure SQLQueryAnteriorFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ABMGrupos: TABMGrupos;

implementation

{$R *.lfm}

{ TABMGrupos }

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TABMGrupos.FormCreate(Sender: TObject);
begin
  //Self.Query := 'SELECT G.ID, G.MODULOID, M.NOMBRE MODULO_NOMBRE, G.NOMBRE, G.HABILITADO, ' +
  //'G.DESCRIPCION FROM GRUPO G, MODULO M WHERE G.MODULOID=M.ID';
 { Self.Query := 'SELECT ID, MODULOID, NOMBRE, DESCRIPCION, HABILITADO FROM GRUPO';
  Self.InsQuery := 'INSERT INTO GRUPO (ID, MODULOID, NOMBRE, DESCRIPCION, ' +
    'HABILITADO) VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM GRUPO), ' +
    ':MODULOID, :NOMBRE, :DESCRIPCION, :HABILITADO)';
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';}
  IniciaForm('GRUPO', 'ID');
  inherited;
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TABMGrupos.Insertar;
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
  SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  if CheckBoxNuevoActivo.Checked then
    SQLQuery1HABILITADO.AsInteger := 1
  else
    SQLQuery1HABILITADO.AsInteger := 0;
end;

procedure TABMGrupos.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    SQLQueryAnterior.Close;
    SQLQueryAnterior.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TABMGrupos.Actualizar;
begin
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  if CheckBoxNuevoActivo.Checked then
    SQLQuery1HABILITADO.AsInteger := 1
  else
    SQLQuery1HABILITADO.AsInteger := 0;
end;

procedure TABMGrupos.Borrar;
begin
  try
    if not (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Edit;
    SQLQuery1HABILITADO.AsInteger := 0;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TABMGrupos.LimpiarCampos;
begin
  inherited;
  LabeledEditNuevoNombre.Clear;
  LabeledEditNuevoDescripcion.Clear;
  EditModificarFiltro.Clear;
  EditEliminarFiltro.Clear;
end;

procedure TABMGrupos.MenuItemEliminarClick(Sender: TObject);
begin
  inherited;
end;

procedure TABMGrupos.MenuItemModificarClick(Sender: TObject);
begin
  SQLQueryAnterior.Close;
  inherited;
end;

procedure TABMGrupos.ModificarDatos;
begin
  SQLQueryAnterior.Refresh;
  SQLQuery1.Edit;
  LabeledEditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  LabeledEditNuevoDescripcion.Text := SQLQuery1DESCRIPCION.AsString;
  if SQLQuery1HABILITADO.AsInteger = 1 then
    CheckBoxNuevoActivo.Checked := True
  else
    CheckBoxNuevoActivo.Checked := False;
end;

procedure TABMGrupos.SQLQueryAnteriorFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := not (DataSet.FieldByName('ID').AsInteger = SQLQuery1ID.AsInteger);
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TABMGrupos.DatosValidos: boolean;
begin
  if ((Trim(LabeledEditNuevoNombre.Text) = '') {or
    (Trim(DBLookupComboBox1.Text) = '')}) then
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
 MANEJO DE LAS ACCIONES DE LOS MENUS
 ********************************************************
 }

procedure TABMGrupos.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  LabeledEditNuevoNombre.SetFocus;
  try
    if not (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Append;
    SQLQueryAnterior.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TABMGrupos.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
  begin
    LabeledEditNuevoNombre.SetFocus;
    MenuItemNuevoClick(Self); // para seguir insertando registros
  end;
end;

end.
