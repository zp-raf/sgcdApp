unit frmDesarrolloMateria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, frmAbm,
  frmsgcddatamodule, strutils;

type

  { TAbmDesarrolloMateria }

  TAbmDesarrolloMateria = class(TAbm)
    cbNombreMateria: TDBLookupComboBox;
    cbNombreSeccion: TDBLookupComboBox;
    cbNombrePeriodoLectivo: TDBLookupComboBox;
    CheckBoxAll: TCheckBox;
    CheckBoxAll1: TCheckBox;
    cbNombreEmpleado: TDBLookupComboBox;
    DBCheckBox1: TDBCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    dsDummy: TDatasource;
    dsGrupo: TDatasource;
    dsModulo: TDatasource;
    dsPeriodoLectivo: TDatasource;
    dsPersona: TDatasource;
    dsEmpleado: TDatasource;
    dsSeccion: TDatasource;
    dsMateria: TDatasource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    LabelIDDesarrolloMat: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    qryDummyID: TLongintField;
    qryEmpleadoID: TLongintField;
    qryEmpleadoNOMBRECOMPLETO: TStringField;
    qryMateria: TSQLQuery;
    qryMateriaGRUPOID: TLongintField;
    qryMateriaID: TLongintField;
    qryMateriaNOMBRE: TStringField;
    qryMateriaNOMBRE_GRUPO: TStringField;
    qryModulo: TSQLQuery;
    qryPeriodoLectivo: TSQLQuery;
    qryPersonas: TSQLQuery;
    qryEmpleado: TSQLQuery;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1EMPLEADOPERSONAID: TLongintField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MATERIAID: TLongintField;
    SQLQuery1PERIODOLECTIVOID: TLongintField;
    SQLQuery1SECCIONID: TLongintField;
    qrySeccion: TSQLQuery;
    NombreSeccion: TStringField;
    NombrePeriodoLectivo: TStringField;
    NombreCompleto: TStringField;
    NombreMateria: TStringField;
    qryGrupo: TSQLQuery;
    qryGrupoID: TLongintField;
    qryGrupoNOMBRE: TStringField;
    qryDummy: TSQLQuery;
    StringField1: TStringField;
    procedure AbrirCursor; override;
    procedure Borrar; override;
    procedure CerrarDataset; override;
    procedure CheckBoxAllChange(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DBLookupComboBox1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormShow(Sender: TObject);
    procedure Insertar; override;
    procedure Actualizar; override;
    procedure MenuItemEliminarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure ButtonEliminarFiltrarClick(Sender: TObject);
    procedure ButtonModificarFiltrarClick(Sender: TObject);
    procedure qryMateriaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure LimpiarCampos; override;

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmDesarrolloMateria: TAbmDesarrolloMateria;

implementation

{$R *.lfm}

{ TAbmDesarrolloMateria }

procedure TAbmDesarrolloMateria.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    qryDummy.Close;
    qryGrupo.Close;
    qryMateria.Close;
    qrySeccion.Close;
    qryModulo.Close;
    qryPeriodoLectivo.Close;
    qryPersonas.Close;
    qryEmpleado.Close;
    qryDummy.Open;
    qryGrupo.Open;
    qryMateria.Open;
    qrySeccion.Open;
    qryModulo.Open;
    qryPeriodoLectivo.Open;
    qryPersonas.Open;
    qryEmpleado.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmDesarrolloMateria.Borrar;
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

procedure TAbmDesarrolloMateria.CerrarDataset;
begin
  qryDummy.Cancel;
  qryGrupo.Cancel;
  qryMateria.Cancel;
  qrySeccion.Cancel;
  qryModulo.Cancel;
  qryPeriodoLectivo.Cancel;
  qryPersonas.Cancel;
  qryEmpleado.Cancel;
  inherited CerrarDataset;
  qryDummy.Close;
  qryGrupo.Close;
  qryMateria.Close;
  qrySeccion.Close;
  qryModulo.Close;
  qryPeriodoLectivo.Close;
  qryPersonas.Close;
  qryEmpleado.Close;
end;

procedure TAbmDesarrolloMateria.CheckBoxAllChange(Sender: TObject);
begin
  try
    //si esta en baja y se elimino un registro se cancela y se vuelve a filtrar
    if (Estado in [Baja]) and (SQLQuery1.State in [dsEdit]) then
      SQLQuery1.Cancel;
    {if not TCheckBox(Sender).Checked then
      SQLQuery1.Filtered := True
    else
      SQLQuery1.Filtered := False; }
    SQLQuery1.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

function TAbmDesarrolloMateria.DatosValidos: boolean;
begin
  Result := True;
end;

procedure TAbmDesarrolloMateria.DBGrid1KeyUp(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  inherited;
end;

procedure TAbmDesarrolloMateria.DBLookupComboBox1EditingDone(Sender: TObject);
begin
  qryMateria.Refresh;
end;

procedure TAbmDesarrolloMateria.FormCreate(Sender: TObject);

begin
  IniciaForm('DESARROLLOMATERIA', 'ID');
  inherited;
end;

procedure TAbmDesarrolloMateria.FormShow(Sender: TObject);
begin
  inherited;
  Label2.Visible := False;
  LabelIDDesarrolloMat.Visible := False;
end;

procedure TAbmDesarrolloMateria.Insertar;
begin
  //no es necesario
end;

procedure TAbmDesarrolloMateria.Actualizar;
begin
  //no es necesario
end;

procedure TAbmDesarrolloMateria.MenuItemEliminarClick(Sender: TObject);
begin
  qryMateria.Filtered := False;
  SQLQuery1.Filtered := True; //para que ande el filtro
  inherited MenuItemEliminarClick(Sender);
end;

procedure TAbmDesarrolloMateria.MenuItemNuevoClick(Sender: TObject);
begin
  if LabelIDDesarrolloMat.Visible = True then
    LabelIDDesarrolloMat.Visible := False;
  if label2.Visible = True then
    Label2.Visible := False;
  qryMateria.Filtered := True;
  SQLQuery1.Filtered := False;//sacamos el filtro del sqlquery
  inherited;
  //parche para que funcionen los lookupcombobox :(
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
  SQLQuery1ACTIVO.AsInteger := 1; //para que sea activo por defecto
end;

procedure TAbmDesarrolloMateria.MenuItemModificarClick(Sender: TObject);
begin
  qryMateria.Filtered := False;
  SQLQuery1.Filtered := True; //para que ande el filtro
  inherited MenuItemModificarClick(Sender);
end;

procedure TAbmDesarrolloMateria.ModificarDatos;
begin
  SQLQuery1.Edit;
  Label2.Visible := True;
  LabelIDDesarrolloMat.Visible := True;
  LabelIDDesarrolloMat.Caption := SQLQuery1ID.AsString;
end;

procedure TAbmDesarrolloMateria.OKButtonClick(Sender: TObject);
begin
  SQLQuery1.FieldByName('ID').Required := False;
  inherited;
  if Estado in [Alta] then
  begin
    MenuItemNuevoClick(Self);
  end;
end;

procedure TAbmDesarrolloMateria.ButtonModificarFiltrarClick(Sender: TObject);
begin
  //SQLQuery1.Refresh;
  inherited;
  //for i := 1 to 7 do
  //begin
  //  DBGrid2.Columns[i].Visible := False;
  //end;
end;

procedure TAbmDesarrolloMateria.qryMateriaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('GRUPOID').AsInteger = qryDummyID.AsInteger;
end;

procedure TAbmDesarrolloMateria.SQLQuery1FilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  //baja
  if (Estado in [Baja]) and (Trim(EditEliminarFiltro.Text) = '') and
    CheckBoxAll1.Checked then
    Accept := True
  else if (Estado in [Baja]) and (Trim(EditEliminarFiltro.Text) = '') then
    Accept := DataSet.FieldByName('ACTIVO').AsInteger = 1
  else if (Estado in [Baja]) and CheckBoxAll1.Checked then
    Accept := AnsiContainsText(DataSet.FieldByName('NombreMateria').AsString,
      EditEliminarFiltro.Text)
  else if (Estado in [Baja]) then
    Accept := (DataSet.FieldByName('ACTIVO').AsInteger = 1) and
      AnsiContainsText(DataSet.FieldByName('NombreMateria').AsString,
      EditEliminarFiltro.Text)
  //modificacion
  else if (Estado in [Modificacion]) and (Trim(EditModificarFiltro.Text) = '') and
    CheckBoxAll.Checked then
    Accept := True
  else if (Estado in [Modificacion]) and (Trim(EditModificarFiltro.Text) = '') then
    Accept := DataSet.FieldByName('ACTIVO').AsInteger = 1
  else if (Estado in [Modificacion]) and CheckBoxAll.Checked then
    Accept := AnsiContainsText(DataSet.FieldByName('NombreMateria').AsString,
      EditModificarFiltro.Text)
  else
    Accept := (DataSet.FieldByName('ACTIVO').AsInteger = 1) and
      AnsiContainsText(DataSet.FieldByName('NombreMateria').AsString,
      EditModificarFiltro.Text);
end;

procedure TAbmDesarrolloMateria.ButtonEliminarFiltrarClick(Sender: TObject);
begin
  //SQLQuery1.Refresh;
  inherited;
  //for i := 1 to 7 do
  //begin
  //  DBGrid1.Columns[i].Visible := False;
  //end;
end;

procedure TAbmDesarrolloMateria.LimpiarCampos;
begin
  inherited;
  DBLookupComboBox1.Clear;
end;

end.
