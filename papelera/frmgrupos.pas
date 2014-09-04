unit frmGrupos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics,
  Dialogs, Menus, ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls,
  frmAbm;

type

  { TABMGrupos }

  TABMGrupos = class(TAbm)
    CheckBoxNuevoActivo: TCheckBox;
    DatasourceAux: TDatasource;
    DBLookupComboBox1: TDBLookupComboBox;
    LabelSeleccionarModulo: TLabel;
    LabeledEditNuevoDescripcion: TLabeledEdit;
    LabeledEditNuevoNombre: TLabeledEdit;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1HABILITADO: TLongintField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQueryAux: TSQLQuery;
    SQLQueryAuxID: TLongintField;
    SQLQueryAuxNOMBRE: TStringField;
    procedure Actualizar; override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemEliminarClick(Sender: TObject); override;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer); override;
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ABMGrupos: TABMGrupos;
  hintNuevo: string;
  hintEditar: string;

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
  IniciaForm ('GRUPO', 'ID');
  inherited;
  hintNuevo := 'Seleccione de la lista el modulo al que corresponde el grupo';
  hintEditar := 'No está permitido cambiar el modulo del grupo';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TABMGrupos.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  //SQLQuery1MODULOID.Clear;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  if CheckBoxNuevoActivo.Checked then
    SQLQuery1HABILITADO.AsInteger := 1
  else
    SQLQuery1HABILITADO.AsInteger := 0;
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
  inherited;
end;

procedure TABMGrupos.ModificarDatos;
begin
  SQLQuery1.Edit;
  //parche para que funcionen los lookups, se pone en edicion aca en vez de al hacer ok :(
  //SQLQuery1MODULOID.Clear;
  LabeledEditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  LabeledEditNuevoDescripcion.Text := SQLQuery1DESCRIPCION.AsString;
  if SQLQuery1HABILITADO.AsInteger = 1 then
    CheckBoxNuevoActivo.Checked := True
  else
    CheckBoxNuevoActivo.Checked := False;

  //no se puede cambiar el modulo una vez que se crea el grupo
  DBLookupComboBox1.Hint := hintEditar;
  DBLookupComboBox1.Enabled := False;
end;

procedure TABMGrupos.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button in [mbRight] then
    MessageDlg('Contenido del campo',
      '-Nombre: ' + SQLQuery1NOMBRE.AsString + #13#10 + '-Descripcion: ' +
      SQLQuery1DESCRIPCION.AsString + #13#10 + '-Habilitado: (1=Si, 0=No) ' +
      SQLQuery1HABILITADO.AsString,
      mtCustom, [mbOK], 0);
end;

procedure TABMGrupos.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button in [mbRight] then
    MessageDlg('Contenido del campo',
      '-Nombre: ' + SQLQuery1NOMBRE.AsString + #13#10 + '-Descripcion: ' +
      SQLQuery1DESCRIPCION.AsString + #13#10 + '-Habilitado: (1=Si, 0=No) ' +
      SQLQuery1HABILITADO.AsString,
      mtCustom, [mbOK], 0);
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
  //habilitar el comobobox de modulo
  DBLookupComboBox1.Hint := hintNuevo;
  DBLookupComboBox1.Enabled := True;
  try
    SQLQueryAux.Close;
    SQLQueryAux.SQL.Clear;
    SQLQueryAux.SQL.SetText('SELECT ID, NOMBRE FROM MODULO');
    SQLQueryAux.Open;
    //parche para que funcionen los lookupcombobox :(
    if not (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Append;
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
