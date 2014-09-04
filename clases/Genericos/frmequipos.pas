unit frmequipos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, StdCtrls, ExtDlgs, DBGrids, DBCtrls, EditBtn,
  frmAbm, DB, sqldb;

type

  { TAbmEquipos }

  TAbmEquipos = class(TAbm)
    CheckBoxNuevoActivo: TCheckBox;
    DateEditFechaIngreso: TDateEdit;
    EditNuevoDescripcion: TEdit;
    EditNuevoNroSerie: TEdit;
    EditNuevoNombre: TEdit;
    LabelNuevoFechaIngreso: TLabel;
    LabelNuevoDescripcion: TLabel;
    LabelNuevoNroSerie: TLabel;
    LabelNuevoNombre: TLabel;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1FECHAINGRESO: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQuery1NROSERIE: TStringField;
    procedure ModificarDatos; override;
    procedure Actualizar; override;
    procedure Borrar; override;
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
  AbmEquipos: TAbmEquipos;

implementation

{$R *.lfm}

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TAbmEquipos.FormCreate(Sender: TObject);
begin
{  Self.Query := 'SELECT ID, NOMBRE, NROSERIE, DESCRIPCION, FECHAINGRESO, ACTIVO ' +
    'FROM EQUIPO';
  Self.InsQuery :=
    'INSERT INTO EQUIPO (ID, NOMBRE, NROSERIE, DESCRIPCION, FECHAINGRESO, ' +
    'ACTIVO) VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM EQUIPO), ' +
    ':NOMBRE, :NROSERIE, :DESCRIPCION, :FECHAINGRESO, :ACTIVO)';}
  IniciaForm('EQUIPO', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmEquipos.Borrar;
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

procedure TAbmEquipos.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1.Append;
  SQLQuery1NOMBRE.AsString := Filtrar(EditNuevoNombre.Text);
  SQLQuery1NROSERIE.AsString := Filtrar(EditNuevoNroSerie.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(EditNuevoDescripcion.Text);
  SQLQuery1FECHAINGRESO.AsDateTime := DateEditFechaIngreso.Date;
  if CheckBoxNuevoActivo.Checked = True then
    SQLQuery1ACTIVO.AsInteger := 1
  else
    SQLQuery1ACTIVO.AsInteger := 0;
end;


procedure TAbmEquipos.Actualizar;
begin
  SQLQuery1.Edit;
  SQLQuery1NOMBRE.AsString := Filtrar(EditNuevoNombre.Text);
  SQLQuery1NROSERIE.AsString := Filtrar(EditNuevoNroSerie.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(EditNuevoDescripcion.Text);
  SQLQuery1FECHAINGRESO.AsDateTime := DateEditFechaIngreso.Date;
  if CheckBoxNuevoActivo.Checked = True then
    SQLQuery1ACTIVO.AsInteger := 1
  else
    SQLQuery1ACTIVO.AsInteger := 0;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmEquipos.LimpiarCampos;
begin
  inherited;
  EditNuevoNombre.Clear;
  EditNuevoNroSerie.Clear;
  EditNuevoDescripcion.Clear;
  DateEditFechaIngreso.Clear;
  EditModificarFiltro.Clear;
  EditEliminarFiltro.Clear;
end;

procedure TAbmEquipos.ModificarDatos;
begin
  EditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  EditNuevoNroSerie.Text := SQLQuery1NROSERIE.AsString;
  EditNuevoDescripcion.Text := SQLQuery1DESCRIPCION.AsString;
  DateEditFechaIngreso.Date := SQLQuery1FECHAINGRESO.AsDateTime;
  if SQLQuery1ACTIVO.AsInteger = 1 then
    CheckBoxNuevoActivo.Checked := True
  else
    CheckBoxNuevoActivo.Checked := False;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TAbmEquipos.DatosValidos: boolean;
begin
  if ((Trim(EditNuevoNombre.Text) = '') or (Trim(EditNuevoNroSerie.Text) = '') or
    (Trim(DateEditFechaIngreso.ToString) = '')) then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
    Exit;
  end
  else
  begin
    Result := True;
  end;

  { validacion de fecha }
  if not FechaValida(DateEditFechaIngreso.Date) then
  begin
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

procedure TAbmEquipos.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  EditNuevoNombre.SetFocus;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TAbmEquipos.OKButtonClick(Sender: TObject);
begin
  SQLQuery1.FieldByName('ID').Required := False;
  inherited;
  if Estado in [Alta] then
    EditNuevoNombre.SetFocus;
end;

end.
