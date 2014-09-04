unit frmentrega;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBGrids, DBCtrls, ExtDlgs, EditBtn, ExtCtrls,
  PopupNotifier, XMLPropStorage, PairSplitter, frmProceso, sqldb, DB,
  IBConnection, frmsgcddatamodule, strutils, ShellApi;

type

  { TProcesoEntrega }
  TEstado = (Seleccionar, Editar, Guardado);

  TProcesoEntrega = class(TProceso)
    ButtonSeleccionar: TButton;
    Datasource1: TDatasource;
    DatasourceTrabajo: TDatasource;
    DatasourceAlumno: TDatasource;
    DatasourceDesarrollo: TDatasource;
    DatasourceProfesor: TDatasource;
    DBGridTrabajo: TDBGrid;
    DBGridAlumno: TDBGrid;
    DBGridMaterias: TDBGrid;
    DBGridProfesor: TDBGrid;
    GroupBoxAlumnos: TGroupBox;
    GroupBoxtrabajo: TGroupBox;
    GroupBoxDesarrollo: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    SQLQuery1: TSQLQuery;
    SQLQuery1ALUMNOPERSONAID: TLongintField;
    SQLQuery1COMENTARIOS: TStringField;
    SQLQuery1FECHAENTREGA: TDateField;
    SQLQuery1PUNTAJEOBTENIDO: TFloatField;
    SQLQuery1TRABAJOID: TLongintField;
    SQLQueryAlumnoAPELLIDO: TStringField;
    SQLQueryAlumnoCEDULA: TStringField;
    SQLQueryAlumnoDESARROLLOMATERIAID: TLongintField;
    SQLQueryAlumnoID: TLongintField;
    SQLQueryAlumnoID_MATRICULA: TLongintField;
    SQLQueryAlumnoMATERIAID: TLongintField;
    SQLQueryAlumnoNOMBRE: TStringField;
    SQLQueryAlumnoSECCIONID: TLongintField;
    SQLQueryProfesorCEDULA: TStringField;
    SQLQueryTrabajo: TSQLQuery;
    SQLQueryAlumno: TSQLQuery;
    SQLQueryDesarrollo: TSQLQuery;
    SQLQueryDesarrolloEMPLEADOPERSONAID: TLongintField;
    SQLQueryDesarrolloID: TLongintField;
    SQLQueryDesarrolloMATERIAID: TLongintField;
    SQLQueryDesarrolloNOMBRE_COMPLETO: TStringField;
    SQLQueryDesarrolloNOMBRE_MATERIA: TStringField;
    SQLQueryDesarrolloNOMBRE_PERIODO: TStringField;
    SQLQueryDesarrolloNOMBRE_SECCION: TStringField;
    SQLQueryDesarrolloPERIODOLECTIVOID: TLongintField;
    SQLQueryDesarrolloSECCIONID: TLongintField;
    SQLQueryProfesor: TSQLQuery;
    SQLQueryProfesorID: TLongintField;
    SQLQueryProfesorNOMBRE_COMPLETO: TStringField;
    SQLQueryTrabajoACTIVO: TSmallintField;
    SQLQueryTrabajoDESARROLLOMATERIAID: TLongintField;
    SQLQueryTrabajoDESCRIPCION: TStringField;
    SQLQueryTrabajoFECHAFIN: TDateField;
    SQLQueryTrabajoFECHAINICIO: TDateField;
    SQLQueryTrabajoID: TLongintField;
    SQLQueryTrabajoNOMBRE: TStringField;
    SQLQueryTrabajoPESO: TFloatField;
    SQLQueryTrabajoPUNTAJEMAX: TFloatField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    procedure AbrirCursor;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception); override;
    procedure ButtonSeleccionarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject); override;
    procedure DBGridMateriasCellClick(Column: TColumn);
    procedure DBGridProfesorCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject); override;
    function FechaValida(const param: TDateTime): boolean;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure SQLQuery1AfterScroll(DataSet: TDataSet);
    procedure SQLQuery1EditError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryAlumnoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryDesarrolloFilterRecord(DataSet: TDataSet;
      var Accept: boolean);
    procedure SQLQueryProfesorFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryTrabajoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure TDBGridTitleClick(Column: TColumn); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoEntrega: TProcesoEntrega;
  AlumnoID: integer;
  TrabajoID: integer;
  Estado: TEstado;

implementation

{$R *.lfm}

{ TProcesoEntrega }

procedure TProcesoEntrega.DBGridProfesorCellClick(Column: TColumn);
begin
  try
    if (Estado in [Editar]) then
    begin
      SQLQuery1.Cancel;
      SQLQuery1.Close;
      SQLQuery1.Open;
    end;
    SQLQueryDesarrollo.Refresh;
    SQLQueryTrabajo.Refresh;
    SQLQueryAlumno.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoEntrega.FormCreate(Sender: TObject);
begin
  try
    DBGridAlumno.Clear;
    AbrirCursor;
    Estado := Seleccionar;
    ButtonSeleccionar.Enabled := True;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

function TProcesoEntrega.FechaValida(const param: TDateTime): boolean;
begin
  if param < StrToDate('01/01/1900') then
  begin
    MessageDlg('Informacion', 'Fecha no válida', mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TProcesoEntrega.LabeledEdit1Change(Sender: TObject);
begin
  SQLQueryProfesor.Refresh;
end;

procedure TProcesoEntrega.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\calificarTrabajo.html', nil, nil, 1);
end;

procedure TProcesoEntrega.OKButtonClick(Sender: TObject);
begin
  try
    //SQLQuery1FECHAENTREGA.AsDateTime := DateEdit1.Date;
    SQLQuery1.ApplyUpdates;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
      ButtonSeleccionarClick(Self);
      Exit;
    end;
  end;

  try
    SGCDDataModule.sqlTran.Commit;
    AbrirCursor;
    ButtonSeleccionar.Enabled := True;
    GroupBoxtrabajo.Enabled := False;
    Estado := Seleccionar;
    MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
      SGCDDataModule.sqlTran.Rollback;
    end;
  end;
end;

procedure TProcesoEntrega.SQLQuery1AfterScroll(DataSet: TDataSet);
begin
  if not (DataSet.State in [dsEdit, dsInsert]) then
    DataSet.Edit;
end;

procedure TProcesoEntrega.SQLQuery1EditError(DataSet: TDataSet;
  E: EDatabaseError; var DataAction: TDataAction);
begin
  SQLQuery1.Cancel;
end;

procedure TProcesoEntrega.SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := (DataSet.FieldByName('TRABAJOID').AsInteger = TrabajoID); {and

    (DataSet.FieldByName('ALUMNOPERSONAID').AsInteger = SQLQueryAlumnoID.AsInteger); }
end;

procedure TProcesoEntrega.SQLQueryAlumnoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('DESARROLLOMATERIAID').AsInteger =
    SQLQueryDesarrolloID.AsInteger;
end;

procedure TProcesoEntrega.DBGridMateriasCellClick(Column: TColumn);
begin
  try
    if (Estado in [Editar]) then
    begin
      SQLQuery1.Cancel;
      SQLQuery1.Close;
      SQLQuery1.Open;
    end;
    if not GroupBoxtrabajo.Enabled and (Estado in [Seleccionar]) then
      GroupBoxtrabajo.Enabled := True;
    SQLQueryTrabajo.Refresh;
    SQLQueryAlumno.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoEntrega.AbrirCursor;
begin
  try
    SQLQuery1.Close;
    SQLQueryProfesor.Close;
    SQLQueryDesarrollo.Close;
    SQLQueryTrabajo.Close;
    SQLQueryAlumno.Close;

    SQLQuery1.Open;
    SQLQueryProfesor.Open;
    SQLQueryDesarrollo.Open;
    SQLQueryTrabajo.Open;
    SQLQueryAlumno.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoEntrega.ApplicationProperties1Exception(Sender: TObject;
  E: Exception);
begin
  ManejoErrores(E);
  CancelButtonClick(Self);
end;

procedure TProcesoEntrega.ButtonSeleccionarClick(Sender: TObject);
begin
  try
    if (SQLQuery1.State in [dsEdit, dsInsert]) then
    begin
      SQLQuery1.CancelUpdates;
    end;
    TrabajoID := SQLQueryTrabajoID.AsInteger;
    SQLQueryAlumno.Close;
    SQLQuery1.Close;
    SQLQuery1.Open;
    SQLQueryAlumno.Open;
    if SQLQuery1.IsEmpty then
    begin
      //preparamos la tabla para meter los datos
      SQLQueryAlumno.First;
      while not SQLQueryAlumno.EOF do
      begin
        SQLQuery1.Append;
        SQLQuery1ALUMNOPERSONAID.AsInteger := SQLQueryAlumnoID.AsInteger;
        SQLQuery1TRABAJOID.AsInteger := TrabajoID;
        SQLQuery1FECHAENTREGA.AsDateTime := Now;//por defecto la fecha de hoy
        SQLQuery1PUNTAJEOBTENIDO.AsFloat := 0.0;//por defecto 0.0
        SQLQueryAlumno.Next;
      end;

      {
       AlumnoID := SQLQueryAlumnoID.AsInteger;
       TrabajoID := SQLQueryTrabajoID.AsInteger;
       SQLQuery1.Append;
       SQLQuery1ALUMNOPERSONAID.AsInteger := AlumnoID;
       SQLQuery1TRABAJOID.AsInteger := TrabajoID;
       GroupBoxtrabajo.Enabled := True;
      }
      DBGridAlumno.Refresh;
      //ButtonSeleccionar.Enabled := False;
      Estado := Editar;
    end;
    {
     else
     begin
       SQLQuery1.Edit;
     end;
    }
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoEntrega.CancelButtonClick(Sender: TObject);
begin
  try
    SQLQuery1.Cancel;
    SGCDDataModule.sqlTran.Rollback;
    AbrirCursor;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoEntrega.SQLQueryDesarrolloFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('EMPLEADOPERSONAID').AsInteger =
    SQLQueryProfesorID.AsInteger;
end;

procedure TProcesoEntrega.SQLQueryProfesorFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if Trim(LabeledEdit1.Text) = '' then

    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_COMPLETO').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
      LabeledEdit1.Text);
end;

procedure TProcesoEntrega.SQLQueryTrabajoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('DESARROLLOMATERIAID').AsInteger =
    SQLQueryDesarrolloID.AsInteger;
end;

procedure TProcesoEntrega.TDBGridTitleClick(Column: TColumn);
begin
  inherited TDBGridTitleClick(Column);
end;

end.
