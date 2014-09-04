unit frmsecciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, frmAbm, DB, sqldb;

type

  { TAbmSecciones }

  TAbmSecciones = class(TAbm)
    LabeledEditNuevoNombre: TLabeledEdit;
    LabeledEditNuevoDescripcion: TLabeledEdit;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    procedure Actualizar; override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure Modificardatos; override;
    procedure OKButtonClick(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmSecciones: TAbmSecciones;

implementation

{$R *.lfm}

{ TAbmSecciones }

procedure TAbmSecciones.FormCreate(Sender: TObject);
begin
{  Self.Query := 'SELECT ID, NOMBRE, DESCRIPCION FROM SECCION';
  Self.InsQuery := 'INSERT INTO SECCION (ID, NOMBRE, DESCRIPCION) ' +
    'VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM SECCION), :NOMBRE, ' +
    ':DESCRIPCION)';}
  IniciaForm ('SECCION', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmSecciones.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1.Append;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
end;

procedure TAbmSecciones.Actualizar;
begin
  SQLQuery1.Edit;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmSecciones.LimpiarCampos;
begin
  inherited;
  LabeledEditNuevoNombre.Clear;
  LabeledEditNuevoDescripcion.Clear;
end;

procedure TAbmSecciones.Modificardatos;
begin
  LabeledEditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  LabeledEditNuevoDescripcion.Text := SQLQuery1DESCRIPCION.AsString;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TAbmSecciones.DatosValidos: boolean;
begin
  if (Trim(LabeledEditNuevoNombre.Text) = '') then
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

procedure TAbmSecciones.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  LabeledEditNuevoNombre.SetFocus;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }


procedure TAbmSecciones.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
    LabeledEditNuevoNombre.SetFocus;
end;

end.
