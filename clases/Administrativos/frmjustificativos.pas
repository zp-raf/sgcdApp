unit frmjustificativos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, ExtDlgs, EditBtn, frmAbm,
  DB, sqldb, strutils;

type

  { TAbmJustificativos }

  TAbmJustificativos = class(TAbm)
    noAprobados: TCheckBox;
    FechaInasistencia: TDateEdit;
    FechaPresentacion: TDateEdit;
    Aprobado: TDBCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Motivo: TDBMemo;
    Detalles: TDBMemo;
    dsAlumnos: TDatasource;
    DBGrid3: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    qryAlumnosCEDULA: TStringField;
    qryAlumnosID: TLongintField;
    qryAlumnosNOMBRECOMPLETO: TStringField;
    SQLQuery1APROBADO: TSmallintField;
    SQLQuery1DETALLES: TStringField;
    SQLQuery1FECHAINASISTENCIA: TDateField;
    SQLQuery1FECHAPRESENTACION: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MOTIVO: TStringField;
    SQLQuery1PERSONAID: TLongintField;
    qryAlumnos: TSQLQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure Actualizar; override;
    procedure AbrirCursor; override;
    procedure AbrirCursorFiltrado(param: string); override;
    procedure ButtonModificarFiltrarClick(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure FechaInasistenciaEditingDone(Sender: TObject);
    procedure FechaPresentacionEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure qryAlumnosFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure noAprobadosChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmJustificativos: TAbmJustificativos;

implementation

{$R *.lfm}

{ TAbmJustificativos }

procedure TAbmJustificativos.Actualizar;
begin
  SQLQuery1FECHAPRESENTACION.AsDateTime := FechaPresentacion.Date;
  SQLQuery1FECHAINASISTENCIA.AsDateTime := FechaInasistencia.Date;
  SQLQuery1PERSONAID.AsInteger := qryAlumnosID.AsInteger;
end;

procedure TAbmJustificativos.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    qryAlumnos.Close;
    qryAlumnos.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TAbmJustificativos.AbrirCursorFiltrado(param: string);
begin
  inherited AbrirCursorFiltrado(param);
  try
    qryAlumnos.Close;
    qryAlumnos.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TAbmJustificativos.ButtonModificarFiltrarClick(Sender: TObject);
begin
  inherited ButtonModificarFiltrarClick(Sender);
end;

function TAbmJustificativos.DatosValidos: boolean;
begin
  Result := True;
end;

procedure TAbmJustificativos.FechaInasistenciaEditingDone(Sender: TObject);
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Edit;
  SQLQuery1FECHAINASISTENCIA.AsDateTime := FechaInasistencia.Date;
end;

procedure TAbmJustificativos.FechaPresentacionEditingDone(Sender: TObject);
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Edit;
  SQLQuery1FECHAPRESENTACION.AsDateTime := FechaPresentacion.Date;
end;

procedure TAbmJustificativos.FormCreate(Sender: TObject);
begin
  IniciaForm('JUSTIFICATIVOASISTENCIA', 'ID');
  inherited;
  MenuItemEliminar.Visible := False;
end;

procedure TAbmJustificativos.Insertar;
begin
  SQLQuery1FECHAPRESENTACION.AsDateTime := FechaPresentacion.Date;
  SQLQuery1FECHAINASISTENCIA.AsDateTime := FechaInasistencia.Date;
  SQLQuery1PERSONAID.AsInteger := qryAlumnosID.AsInteger;
end;

procedure TAbmJustificativos.LabeledEdit1Change(Sender: TObject);
begin
  qryAlumnos.Refresh;
end;

procedure TAbmJustificativos.MenuItemModificarClick(Sender: TObject);
begin
  inherited;
end;

procedure TAbmJustificativos.MenuItemNuevoClick(Sender: TObject);
begin
  inherited MenuItemNuevoClick(Sender);
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
  SQLQuery1APROBADO.AsInteger := 0;
end;

procedure TAbmJustificativos.ModificarDatos;
begin
  qryAlumnos.Locate('ID', SQLQuery1PERSONAID.Value, [loCaseInsensitive]);
  FechaPresentacion.Date := SQLQuery1FECHAPRESENTACION.AsDateTime;
  FechaInasistencia.Date := SQLQuery1FECHAINASISTENCIA.AsDateTime;
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Edit;
end;

procedure TAbmJustificativos.qryAlumnosFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Estado in [Alta]) and (Trim(LabeledEdit1.Text) = '') then
    Accept := True
  else if (Estado in [Alta]) then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
      LabeledEdit1.Text)
  else if not (Estado in [Alta]) then
    Accept := True;
end;

procedure TAbmJustificativos.SQLQuery1FilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Estado in [Modificacion]) and (Trim(EditModificarFiltro.Text) = '') and
    noAprobados.Checked then
    Accept := DataSet.FieldByName('APROBADO').AsInteger = 1
  else if (Estado in [Modificacion]) and (Trim(EditModificarFiltro.Text) = '') then
    Accept := True
  else if (Estado in [Modificacion]) and noAprobados.Checked then
    Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('MOTIVO').AsString,
      LabeledEdit1.Text)) and (DataSet.FieldByName('APROBADO').AsInteger = 1)
  else if (Estado in [Modificacion]) then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('MOTIVO').AsString,
      LabeledEdit1.Text)
  else
    Accept := True;
end;

procedure TAbmJustificativos.noAprobadosChange(Sender: TObject);
begin
  SQLQuery1.Refresh;
end;

end.
