unit frmaranceles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, ExtCtrls, ComCtrls, StdCtrls, DBGrids, DBCtrls, frmAbm;

type

  { TABMAranceles }

  TABMAranceles = class(TAbm)
    CheckBoxActivo: TCheckBox;
    EditNuevoNombre: TEdit;
    EditNuevoDesc: TEdit;
    EditNuevoMonto: TEdit;
    LabelNuevoNombre: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1ID: TLongintField;
    SQLQuery1IVA: TSmallintField;
    SQLQuery1MONTO: TFloatField;
    SQLQuery1NOMBRE: TStringField;
    procedure ModificarDatos; override;
    procedure Actualizar; override;
    procedure Borrar; override;
    procedure EditNuevoMontoKeyPress(Sender: TObject; var Key: char);
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ABMAranceles: TABMAranceles;

implementation

{$R *.lfm}

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TABMAranceles.FormCreate(Sender: TObject);
begin
{  Self.Query := 'SELECT * FROM ARANCEL';
  Self.InsQuery := 'INSERT INTO ARANCEL (ID, NOMBRE, DESCRIPCION, MONTO, ACTIVO) ' +
    'VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM ARANCEL), ' +
    ':NOMBRE, :DESCRIPCION, :MONTO, :ACTIVO)';}
  IniciaForm('ARANCEL', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }
procedure TABMAranceles.Borrar;
begin
  try
    if not (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Edit;
    SQLQuery1ACTIVO.AsInteger := 0;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TABMAranceles.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1.Append;
  SQLQuery1NOMBRE.AsString := Filtrar(EditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(EditNuevoDesc.Text);
  SQLQuery1MONTO.AsFloat := StrToFloat(EditNuevoMonto.Text);
  if CheckBoxActivo.Checked = True then
    SQLQuery1ACTIVO.AsInteger := 1
  else
    SQLQuery1ACTIVO.AsInteger := 0;
end;

procedure TABMAranceles.Actualizar;
begin
  SQLQuery1.Edit;
  SQLQuery1NOMBRE.AsString := Filtrar(EditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(EditNuevoDesc.Text);
  SQLQuery1MONTO.AsFloat := StrToFloat(EditNuevoMonto.Text);
  if CheckBoxActivo.Checked = True then
    SQLQuery1ACTIVO.AsInteger := 1
  else
    SQLQuery1ACTIVO.AsInteger := 0;
end;

 {
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TABMAranceles.LimpiarCampos;
begin
  inherited;
  EditNuevoMonto.Clear;
  EditNuevoDesc.Clear;
  EditNuevoNombre.Clear;
  CheckBoxActivo.Checked := False;
end;

procedure TABMAranceles.ModificarDatos;
begin
  EditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  EditNuevoDesc.Text := SQLQuery1DESCRIPCION.AsString;
  EditNuevoMonto.Text := SQLQuery1MONTO.AsString;
  if SQLQuery1ACTIVO.Value = 1 then
    CheckBoxActivo.State := cbChecked
  else if SQLQuery1ACTIVO.Value = 0 then
    CheckBoxActivo.State := cbUnchecked;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
{ CHEQUEAR QUE SE LLENEN LOS CAMPOS REQUERIDOS }
function TABMAranceles.DatosValidos: boolean;
begin
  if ((Trim(EditNuevoNombre.Text) = '') or (Trim(EditNuevoDesc.Text) = '') or
    (Trim(EditNuevoMonto.Text) = '')) then
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

{ chequear que se metan solo numeros en el monto }
procedure TABMAranceles.EditNuevoMontoKeyPress(Sender: TObject; var Key: char);
begin
  CampoNumerico(Self, Key, EditNuevoMonto);
end;

{
********************************************************
MANEJO DE LAS ACCIONES DE LOS MENUS
********************************************************
}

procedure TABMAranceles.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  EditNuevoNombre.SetFocus;
end;

procedure TABMAranceles.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
    EditNuevoNombre.SetFocus;
end;

end.
