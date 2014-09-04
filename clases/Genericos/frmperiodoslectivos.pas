unit frmPeriodosLectivos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, EditBtn, frmAbm,
  DB, sqldb, frmsgcddatamodule;

type

  { TAbmPeriodosLectivos }

  TAbmPeriodosLectivos = class(TAbm)
    ButtonActivar: TButton;
    CheckBoxNuevoActivo: TCheckBox;
    DateEditFechaFin: TDateEdit;
    DateEditFechaIni: TDateEdit;
    LabeledEditNuevoNombre: TLabeledEdit;
    LabeledEditNuevoDescripcion: TLabeledEdit;
    LabelNuevoFechaIni: TLabel;
    LabelNuevoFechaFin: TLabel;
    LabelNuevoNombre: TLabel;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1FECHAFIN: TDateField;
    SQLQuery1FECHAINICIO: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    procedure Actualizar; override;
    procedure Borrar; override;
    procedure ButtonActivarClick(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure DateEditFechaIniExit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmPeriodosLectivos: TAbmPeriodosLectivos;

implementation

{$R *.lfm}

{ TAbmPeriodosLectivos }

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TAbmPeriodosLectivos.FormCreate(Sender: TObject);
begin
{  Self.Query := 'SELECT ID, NOMBRE, DESCRIPCION, FECHAINICIO, FECHAFIN, ACTIVO ' +
    'FROM PERIODOLECTIVO';
  Self.InsQuery :=
    'INSERT INTO PERIODOLECTIVO (ID, NOMBRE, DESCRIPCION, FECHAINICIO, FECHAFIN,' +
    ' ACTIVO) VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM PERIODOLECTIVO),' +
    ' :NOMBRE, :DESCRIPCION, :FECHAINICIO, :FECHAFIN, :ACTIVO )';}
  IniciaForm('PERIODOLECTIVO', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmPeriodosLectivos.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1.Append;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  SQLQuery1FECHAINICIO.AsDateTime := DateEditFechaIni.Date;
  SQLQuery1FECHAFIN.AsDateTime := DateEditFechaFin.Date;
  if CheckBoxNuevoActivo.Checked then
    SQLQuery1ACTIVO.AsInteger := 1
  else
    SQLQuery1ACTIVO.AsInteger := 0;
end;

procedure TAbmPeriodosLectivos.Actualizar;
begin
  SQLQuery1.Edit;
  SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
  SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
  SQLQuery1FECHAINICIO.AsDateTime := DateEditFechaIni.Date;
  SQLQuery1FECHAFIN.AsDateTime := DateEditFechaFin.Date;
  if CheckBoxNuevoActivo.Checked then
    SQLQuery1ACTIVO.AsInteger := 1
  else
    SQLQuery1ACTIVO.AsInteger := 0;
end;

procedure TAbmPeriodosLectivos.Borrar;
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


{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmPeriodosLectivos.LimpiarCampos;
begin
  inherited;
  LabeledEditNuevoDescripcion.Clear;
  LabeledEditNuevoNombre.Clear;
  DateEditFechaIni.Clear;
  DateEditFechaFin.Clear;
  EditModificarFiltro.Clear;
  EditEliminarFiltro.Clear;
end;

procedure TAbmPeriodosLectivos.ModificarDatos;
begin
  LabeledEditNuevoNombre.Text := SQLQuery1NOMBRE.AsString;
  LabeledEditNuevoDescripcion.Text := SQLQuery1DESCRIPCION.AsString;
  DateEditFechaIni.Date := SQLQuery1FECHAINICIO.AsDateTime;
  DateEditFechaFin.Date := SQLQuery1FECHAFIN.AsDateTime;
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
function TAbmPeriodosLectivos.DatosValidos: boolean;
begin
  if ((Trim(LabeledEditNuevoNombre.Text) = '') or
    (Trim(DateEditFechaIni.ToString) = '') or
    (Trim(DateEditFechaFin.ToString) = '')) then
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
  if not ((FechaValida(DateEditFechaIni.Date)) or
    (FechaValida(DateEditFechaFin.Date))) then
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

procedure TAbmPeriodosLectivos.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  LabeledEditNuevoNombre.SetFocus;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TAbmPeriodosLectivos.ButtonActivarClick(Sender: TObject);
begin
  try
    if not (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Edit;
    SQLQuery1ACTIVO.AsInteger := 1;
    Guardar;
    MenuItemModificarClick(Self);
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      SQLQuery1.Cancel;
      SGCDDataModule.sqlTran.Rollback;
      SQLQuery1.Close;
      MenuItemModificarClick(Self);
    end;
  end;
end;


procedure TAbmPeriodosLectivos.DateEditFechaIniExit(Sender: TObject);
begin
  ShowMessage(DateEditFechaFin.Text);
end;

procedure TAbmPeriodosLectivos.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
    LabeledEditNuevoNombre.SetFocus;
end;

end.
end.
