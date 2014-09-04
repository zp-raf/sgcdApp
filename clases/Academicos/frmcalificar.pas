unit frmcalificar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBGrids, ExtCtrls, PairSplitter, PopupNotifier,
  XMLPropStorage, frmProceso, sqldb, DB, frmsgcddatamodule, strutils, ShellApi;

type

  { TProcesoCalificar }
  TEstado = (Seleccionar, Editar, Guardado);

  TProcesoCalificar = class(TProceso)
    ButtonSeleccionar: TButton;
    ds: TDatasource;
    dsAlumno: TDatasource;
    dsExamen: TDatasource;
    DBGridAlumno: TDBGrid;
    DBGridTrabajo: TDBGrid;
    dsDesarrollo: TDatasource;
    dsProfesor: TDatasource;
    DBGridMaterias: TDBGrid;
    DBGridProfesor: TDBGrid;
    GroupBoxAlumnos: TGroupBox;
    GroupBoxDesarrollo: TGroupBox;
    GroupBoxExamen: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryCOMENTARIOS: TStringField;
    qryDesarrollo: TSQLQuery;
    qryDesarrolloEMPLEADOPERSONAID: TLongintField;
    qryDesarrolloID: TLongintField;
    qryDesarrolloMATERIAID: TLongintField;
    qryDesarrolloNOMBRE_COMPLETO: TStringField;
    qryDesarrolloNOMBRE_MATERIA: TStringField;
    qryDesarrolloNOMBRE_PERIODO: TStringField;
    qryDesarrolloNOMBRE_SECCION: TStringField;
    qryDesarrolloPERIODOLECTIVOID: TLongintField;
    qryDesarrolloSECCIONID: TLongintField;
    qryExamenACTIVO: TSmallintField;
    qryExamenDESARROLLOMATERIAID: TLongintField;
    qryExamenFECHA: TDateField;
    qryExamenID: TLongintField;
    qryEXAMENID_principal: TLongintField;
    qryExamenOBSERVACIONES: TStringField;
    qryExamenPUNTAJEMAX: TFloatField;
    qryMATRICULAID: TLongintField;
    qryProfesor: TSQLQuery;
    qryProfesorCEDULA: TStringField;
    qryProfesorID: TLongintField;
    qryProfesorNOMBRE_COMPLETO: TStringField;
    qry: TSQLQuery;
    qryAlumno: TSQLQuery;
    qryAlumnoAPELLIDO: TStringField;
    qryAlumnoCEDULA: TStringField;
    qryAlumnoDESARROLLOMATERIAID: TLongintField;
    qryAlumnoID: TLongintField;
    qryAlumnoID_MATRICULA: TLongintField;
    qryAlumnoMATERIAID: TLongintField;
    qryAlumnoNOMBRE: TStringField;
    qryAlumnoSECCIONID: TLongintField;
    qryExamen: TSQLQuery;
    qryPUNTAJEOBTENIDO: TFloatField;
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
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryAfterScroll(DataSet: TDataSet);
    procedure qryAlumnoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryDesarrolloFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryExamenFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryPostError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure qryProfesorFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure TDBGridTitleClick(Column: TColumn); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoCalificar: TProcesoCalificar;
  Estado: TEstado;
  ExamenID: integer;
  DesarrolloID: integer;

implementation

{$R *.lfm}

{ TProcesoCalificar }

procedure TProcesoCalificar.CancelButtonClick(Sender: TObject);
begin
  try
    qry.Cancel;
    SGCDDataModule.sqlTran.Rollback;
    AbrirCursor;
    ButtonSeleccionar.Enabled := True;
    GroupBoxExamen.Enabled := False;
    Estado := Seleccionar;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoCalificar.AbrirCursor;
begin
  try
    qryProfesor.Close;
    qryDesarrollo.Close;
    qryExamen.Close;
    qryAlumno.Close;
    qry.Close;
    qryProfesor.Open;
    qryDesarrollo.Open;
    qryExamen.Open;
    qryAlumno.Open;
    qry.Open;
  except
    on E: EDatabaseError do
      ManejoErrores(E);
  end;
end;

procedure TProcesoCalificar.ApplicationProperties1Exception(Sender: TObject;
  E: Exception);
begin
  ManejoErrores(E);
  CancelButtonClick(Self);
end;

procedure TProcesoCalificar.ButtonSeleccionarClick(Sender: TObject);
begin
  try
    if (qry.State in [dsEdit, dsInsert]) then
    begin
      qry.CancelUpdates;
    end;
    ExamenID := qryExamenID.AsInteger;
    DesarrolloID := qryExamenDESARROLLOMATERIAID.AsInteger;
    qryAlumno.Close;
    qry.Close;
    qry.Open;
    qryAlumno.Open;
    if qry.IsEmpty then
    begin
      //preparamos la tabla para meter los datos
      qryAlumno.First;
      while not qryAlumno.EOF do
      begin
        qry.Append;
        //qryID.AsInteger := SGCDDataModule.SiguienteValor('GEN_CALIFICACION');
        qryMATRICULAID.AsInteger := qryAlumnoID_MATRICULA.AsInteger;
        qryEXAMENID_principal.AsInteger := qryExamenID.AsInteger;
        qryPUNTAJEOBTENIDO.AsFloat := 0.0;//por defecto 0.0
        qryAlumno.Next;
      end;
      DBGridAlumno.Refresh;
      Estado := Editar;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoCalificar.DBGridMateriasCellClick(Column: TColumn);
begin
  try
    if not GroupBoxExamen.Enabled and (Estado in [Seleccionar]) then
      GroupBoxExamen.Enabled := True;
    qryExamen.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoCalificar.DBGridProfesorCellClick(Column: TColumn);
begin
  qryDesarrollo.Refresh;
end;

procedure TProcesoCalificar.FormCreate(Sender: TObject);
begin
  try
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

procedure TProcesoCalificar.LabeledEdit1Change(Sender: TObject);
begin
  qryProfesor.Refresh;
end;

procedure TProcesoCalificar.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\calificarExamen.html', nil, nil, 1);
end;

procedure TProcesoCalificar.OKButtonClick(Sender: TObject);
begin
  try
    qry.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
    AbrirCursor;
    ButtonSeleccionar.Enabled := True;
    GroupBoxExamen.Enabled := False;
    Estado := Seleccionar;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoCalificar.qryAfterScroll(DataSet: TDataSet);
begin
  if not (DataSet.State in dsEditModes) then
    DataSet.Edit;
end;

procedure TProcesoCalificar.qryAlumnoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('DESARROLLOMATERIAID').Value = DesarrolloID;
end;

procedure TProcesoCalificar.qryDesarrolloFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('EMPLEADOPERSONAID').AsInteger =
    qryProfesorID.AsInteger;
end;

procedure TProcesoCalificar.qryExamenFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('DESARROLLOMATERIAID').AsInteger =
    qryDesarrolloID.AsInteger;
end;

procedure TProcesoCalificar.qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := (DataSet.FieldByName('EXAMENID').Value = ExamenID);
end;

procedure TProcesoCalificar.qryPostError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
  DataSet.Cancel;
end;

procedure TProcesoCalificar.qryProfesorFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if Trim(LabeledEdit1.Text) = '' then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_COMPLETO').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
      LabeledEdit1.Text);
end;

procedure TProcesoCalificar.TDBGridTitleClick(Column: TColumn);
begin
  inherited TDBGridTitleClick(Column);
end;

end.
