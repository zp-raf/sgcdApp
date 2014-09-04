unit frmmodulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, StdCtrls, DBGrids, DBCtrls, frmAbm, DB,
  sqldb;

type

  { TAbmModulos }

  TAbmModulos = class(TAbm)
    Habilitado: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBMemo4: TDBMemo;
    dsCod: TDatasource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelNuevoPerfil: TLabel;
    LabelNuevoRequisitos: TLabel;
    LabelNuevoFundamentacion: TLabel;
    LabelNuevoObjetivos: TLabel;
    qryCodSIGNIFICADO: TStringField;
    qryCodVALOR: TLongintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1DURACION_CANTIDAD: TLongintField;
    SQLQuery1DURACION_UNIDAD: TSmallintField;
    SQLQuery1FUNDAMENTACION: TStringField;
    SQLQuery1HABILITADO: TSmallintField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQuery1OBJETIVOS: TStringField;
    SQLQuery1PERFILEGRESADO: TStringField;
    SQLQuery1REQUISITOS: TStringField;
    qryCod: TSQLQuery;
    StringField1: TStringField;
    procedure Actualizar; override;
    procedure Borrar; override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure FormResize(Sender: TObject);
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmModulos: TAbmModulos;

implementation

{$R *.lfm}

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TAbmModulos.FormCreate(Sender: TObject);
begin
{  Self.Query :=
    'SELECT ID, NOMBRE, DESCRIPCION, FUNDAMENTACION, OBJETIVOS, REQUISITOS, ' +
    'DURACION, PERFILEGRESADO, HABILITADO FROM MODULO';
  Self.InsQuery :=
    'INSERT INTO MODULO (ID, NOMBRE, DESCRIPCION, FUNDAMENTACION, OBJETIVOS, ' +
    'REQUISITOS, DURACION, PERFILEGRESADO, HABILITADO) VALUES ' +
    '( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM MODULO), :NOMBRE, ' +
    ':DESCRIPCION, :FUNDAMENTACION, :OBJETIVOS, :REQUISITOS, :DURACION, ' +
    ':PERFILEGRESADO, :HABILITADO )';}
  IniciaForm('MODULO', 'ID');
  inherited;
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
end;

procedure TAbmModulos.FormResize(Sender: TObject);
begin
  DBMemo1.Width := trunc(Width / 2.1405);
  DBMemo3.Width := trunc(Width / 2.1405);
  DBMemo2.Width := trunc(Width / 2.1405);
  DBMemo4.Width := trunc(Width / 2.1405);
  DBMemo1.Height := trunc(Height / 3.7);
  DBMemo3.Height := trunc(Height / 3.7);
  DBMemo2.Height := trunc(Height / 4);
  DBMemo4.Height := trunc(Height / 4);
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmModulos.Borrar;
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

procedure TAbmModulos.Insertar;
begin

end;

procedure TAbmModulos.Actualizar;
begin

end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmModulos.LimpiarCampos;
begin
  inherited;
end;

procedure TAbmModulos.ModificarDatos;
begin
  if not (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.Edit;
end;


{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TAbmModulos.DatosValidos: boolean;
begin
  if (0 = 1) then
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

procedure TAbmModulos.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  DBEdit1.SetFocus;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TAbmModulos.OKButtonClick(Sender: TObject);
begin
  SQLQuery1.FieldByName('ID').Required := False;
  inherited;
  if Estado in [Alta] then
    DBEdit1.SetFocus;
end;

end.
