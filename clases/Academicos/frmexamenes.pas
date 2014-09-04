unit frmexamenes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, EditBtn, frmAbm, DB,
  sqldb, frmsgcddatamodule, strutils;

type

  { TAbmExamenes }
  TEstado = (Inicial, Procesando);

  TAbmExamenes = class(TAbm)
    ButtonAgregar: TButton;
    ButtonAgregar1: TButton;
    ButtonEliminar: TButton;
    ButtonEliminar1: TButton;
    DatasourceVeedores: TDatasource;
    DatasourceInterventores: TDatasource;
    DatasourceExamenPersonas: TDatasource;
    DatasourcePersonasExt: TDatasource;
    DatasourceDesarrolloMat: TDatasource;
    DateEdit1: TDateEdit;
    DBCheckBoxActivo: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGridDesarrolloMat: TDBGrid;
    DBMemo1: TDBMemo;
    GroupBoxPersonas: TGroupBox;
    GroupBoxExamen: TGroupBox;
    GroupBoxDesarrolloMat: TGroupBox;
    Peso: TLabel;
    Label2: TLabel;
    SmallintField1: TSmallintField;
    SmallintField2: TSmallintField;
    SQLQuery1PESO: TFloatField;
    SQLQueryInterventoresCEDULA: TStringField;
    SQLQueryPersonasExtESINTERVENTOR: TSmallintField;
    SQLQueryPersonasExtESVEEDOR: TSmallintField;
    SQLQueryPersonasExtID: TLongintField;
    SQLQueryPersonasExtNOMBRE_COMPLETO: TStringField;
    SQLQueryVeedoresCEDULA: TStringField;
    SQLQueryVeedoresID: TLongintField;
    SQLQueryVeedoresNOMBRE_COMPLETO: TStringField;
    StringField9: TStringField;
    Veedor: TLabel;
    LabelPuntajeMax: TLabel;
    LabelObservaciones: TLabel;
    LabelFecha: TLabel;
    LabelDesarrolloMat: TLabel;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1DESARROLLOMATERIAID: TLongintField;
    SQLQuery1FECHA: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1OBSERVACIONES: TStringField;
    SQLQuery1PUNTAJEMAX: TFloatField;
    SQLQueryVeedores: TSQLQuery;
    SQLQueryAux: TSQLQuery;
    SQLQueryInterventores: TSQLQuery;
    SQLQueryExamenPersonas: TSQLQuery;
    SQLQueryExamenPersonasEXAMENID: TLongintField;
    SQLQueryExamenPersonasPERSONAEXTERNAPERSONAID: TLongintField;
    SQLQueryInterventoresID: TLongintField;
    SQLQueryInterventoresNOMBRE_COMPLETO: TStringField;
    SQLQueryPersonasExt: TSQLQuery;
    SQLQueryMatID: TLongintField;
    SQLQueryMatNOMBRE: TStringField;
    SQLQueryPeriodoID: TLongintField;
    SQLQueryPeriodoNOMBRE: TStringField;
    SQLQueryProfesor: TSQLQuery;
    SQLQueryPeriodo: TSQLQuery;
    SQLQueryMat: TSQLQuery;
    SQLQueryProfesorID: TLongintField;
    SQLQueryProfesorNOMBRE_COMPLETO: TStringField;
    SQLQuerySecc: TSQLQuery;
    SQLQueryDesarrolloMat: TSQLQuery;
    SQLQueryDesarrolloMatACTIVO: TSmallintField;
    SQLQueryDesarrolloMatEMPLEADOPERSONAID: TLongintField;
    SQLQueryDesarrolloMatID: TLongintField;
    SQLQueryDesarrolloMatMATERIAID: TLongintField;
    SQLQueryDesarrolloMatPERIODOLECTIVOID: TLongintField;
    SQLQueryDesarrolloMatSECCIONID: TLongintField;
    SQLQuerySeccID: TLongintField;
    SQLQuerySeccNOMBRE: TStringField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    procedure Actualizar; override;
    procedure AbrirCursor; override;
    procedure ButtonAgregar1Click(Sender: TObject);
    procedure ButtonAgregarClick(Sender: TObject);
    procedure ButtonEliminar1Click(Sender: TObject);
    procedure ButtonEliminarClick(Sender: TObject);
    procedure ButtonEliminarFiltrarClick(Sender: TObject);
    procedure ButtonModificarFiltrarClick(Sender: TObject);
    procedure Cancelar;
    function PreInsercion: boolean;
    procedure CerrarDataset; override;
    procedure DateEdit1EditingDone(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure DBGridDesarrolloMatCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject); override;
    procedure Guardar; override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryExamenPersonasFilterRecord(DataSet: TDataSet;
      var Accept: boolean);
    procedure SQLQueryInterventoresFilterRecord(DataSet: TDataSet;
      var Accept: boolean);
    procedure SQLQueryVeedoresFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmExamenes: TAbmExamenes;
  ExamenID: integer;
  DesarrolloID: integer;
  EstadoNuevo: TEstado;

implementation

{$R *.lfm}

{ TAbmExamenes }

procedure TAbmExamenes.Cancelar;
begin
  try
    if (SQLQueryExamenPersonas.State in [dsInsert, dsEdit]) then
      SQLQueryExamenPersonas.Cancel;
    if (SQLQuery1.State in [dsInsert, dsEdit]) then
      SQLQuery1.Cancel;
    inherited;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

function TAbmExamenes.PreInsercion: boolean;
begin
  if (SQLQuery1.State in [dsEdit, dsInsert]) then
  begin
    if (Trim(SQLQuery1FECHA.AsString) = '') or
      (Trim(SQLQuery1PUNTAJEMAX.AsString) = '') then
    begin
      MessageDlg('Informacion', 'Complete los campos requeridos',
        mtInformation, [mbOK], 0);
      Result := False;
    end
    else if (SQLQuery1PUNTAJEMAX.AsFloat <= 0.0) then
    begin
      MessageDlg('Informacion', 'Puntaje inválido', mtInformation, [mbOK], 0);
      Result := False;
    end
    else
    begin
      SQLQuery1.ApplyUpdates;
      //si se esta modificando es importante que se vuelva a poner en modo edicion
      if (Estado in [Modificacion]) then
      begin
        SQLQuery1.Locate('ID', ExamenID, [loCaseInsensitive]);
        SQLQuery1.Edit;
      end;
      Result := True;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TAbmExamenes.CerrarDataset;
begin
  //Cancelar;
  SQLQueryAux.Close;
  SQLQueryDesarrolloMat.Close;
  SQLQueryInterventores.Close;
  SQLQueryPersonasExt.Close;
  SQLQueryExamenPersonas.Close;
  SQLQueryPeriodo.Close;
  SQLQueryMat.Close;
  SQLQuerySecc.Close;
  SQLQueryProfesor.Close;
  SQLQueryVeedores.Close;
end;

procedure TAbmExamenes.DateEdit1EditingDone(Sender: TObject);
begin
  if (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1FECHA.AsDateTime := DateEdit1.Date;
end;

function TAbmExamenes.DatosValidos: boolean;
begin
  if (Trim(SQLQuery1FECHA.AsString) = '') or
    (Trim(SQLQuery1PUNTAJEMAX.AsString) = '') or
    (Trim(SQLQuery1PESO.AsString) = '') then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else if (SQLQuery1PUNTAJEMAX.AsFloat <= 0.0) then
  begin
    MessageDlg('Error', 'Puntaje inválido', mtError, [mbOK], 0);
    Result := False;
  end
  else if (EstadoNuevo in [Procesando]) and SQLQueryExamenPersonas.IsEmpty then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else if (Estado in [Modificacion]) and SQLQueryExamenPersonas.IsEmpty then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
    Result := True;
end;

procedure TAbmExamenes.DBGridDesarrolloMatCellClick(Column: TColumn);
begin
  if (EstadoNuevo in [Procesando]) then
    case MessageDlg('Cambios no guardados',
        'No ha guardado los cambios realizados. ¿Desea continuar sin guardarlos?',
        mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
      begin
        //descartar
        Cancelar;
      end;
      mrNo:
      begin
        Exit;
      end;
    end;

  try
    ExamenID := StrToInt(SGCDDataModule.DevuelveValor(
      'SELECT COALESCE(MAX(ID),0)+1 AS ID FROM EXAMEN', 'ID'));
    DesarrolloID := SQLQueryDesarrolloMatID.AsInteger;
    GroupBoxExamen.Enabled := True;
    GroupBoxPersonas.Enabled := True;
    SQLQuery1.Append;
    //ponemos por defecto activo
    SQLQuery1ACTIVO.AsInteger := 1;
    SQLQuery1ID.AsInteger := ExamenID;
    SQLQuery1DESARROLLOMATERIAID.AsInteger := DesarrolloID;
    DateEdit1.SetFocus;
    SQLQueryExamenPersonas.Refresh;
    SQLQueryInterventores.Refresh;
    SQLQueryVeedores.Refresh;
    EstadoNuevo := Procesando;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.FormCreate(Sender: TObject);
begin
  IniciaForm('EXAMEN', 'ID');
  inherited;
  Self.InsQuery := '';
  //para que se autogenere el insertsql
  //en este form se debe sacar por separado el id
  //ya que se usa en varias partes
end;

procedure TAbmExamenes.Guardar;
begin
  try
    if (SQLQuery1.State in [dsEdit, dsInsert]) or (Estado in [Baja]) then
      SQLQuery1.ApplyUpdates;
    if (SQLQueryExamenPersonas.State in [dsEdit, dsInsert]) then
      SQLQueryExamenPersonas.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.Insertar;
begin
  //no es necesario
end;

procedure TAbmExamenes.LimpiarCampos;
begin
  inherited;
  DateEdit1.Clear;
end;

procedure TAbmExamenes.MenuItemNuevoClick(Sender: TObject);
begin
  inherited MenuItemNuevoClick(Sender);
  GroupBoxExamen.Enabled := False;
  GroupBoxPersonas.Enabled := False;
  GroupBoxDesarrolloMat.Enabled := True;
  EstadoNuevo := Inicial;
end;

procedure TAbmExamenes.ModificarDatos;
begin
  ExamenID := SQLQuery1ID.AsInteger;
  SQLQueryExamenPersonas.Refresh;
  GroupBoxDesarrolloMat.Enabled := False;
  GroupBoxExamen.Enabled := True;
  GroupBoxPersonas.Enabled := True;
  SQLQueryInterventores.Refresh;
  SQLQueryVeedores.Refresh;
  DateEdit1.Date := SQLQuery1FECHA.AsDateTime;
  SQLQuery1.Edit;
end;

procedure TAbmExamenes.OKButtonClick(Sender: TObject);
begin
  if (Estado in [Alta]) and (EstadoNuevo in [Inicial]) then
  begin
    MessageDlg('Informacion', 'Nada que guardar', mtInformation, [mbOK], 0);
    Exit;
  end;
  inherited OKButtonClick(Sender);
end;

procedure TAbmExamenes.SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  if ((Estado in [Modificacion]) and (Trim(EditModificarFiltro.Text) = '')) or
    ((Estado in [Baja]) and (Trim(EditEliminarFiltro.Text) = '')) or (Estado = Alta) then
    Accept := True
  else if ((Estado in [Modificacion]) and not (Trim(EditModificarFiltro.Text) = '')) then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_MATERIA').AsString,
      Trim(EditModificarFiltro.Text))
  else if ((Estado in [Baja]) and (Trim(EditEliminarFiltro.Text) = '')) then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_MATERIA').AsString,
      Trim(EditEliminarFiltro.Text));
end;

procedure TAbmExamenes.SQLQueryExamenPersonasFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := (DataSet.FieldByName('EXAMENID').AsInteger = ExamenID);
end;

procedure TAbmExamenes.SQLQueryInterventoresFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := not SQLQueryExamenPersonas.Locate('PERSONAEXTERNAPERSONAID',
    DataSet.FieldByName('ID').AsString, [loCaseInsensitive]);
end;

procedure TAbmExamenes.SQLQueryVeedoresFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := not SQLQueryExamenPersonas.Locate('PERSONAEXTERNAPERSONAID',
    DataSet.FieldByName('ID').AsString, [loCaseInsensitive]);
end;

procedure TAbmExamenes.ButtonAgregarClick(Sender: TObject);
begin
  try
    if PreInsercion then
    begin  //si no se aplican los updates del sqlquery1 no anda bien esta parte
      if SQLQueryInterventores.IsEmpty then
        Exit;
      if not (SQLQueryExamenPersonas.State in [dsInsert]) then
        SQLQueryExamenPersonas.Append;
      SQLQueryExamenPersonasPERSONAEXTERNAPERSONAID.AsInteger :=
        SQLQueryInterventoresID.AsInteger;
      SQLQueryExamenPersonasEXAMENID.AsInteger := ExamenID;
      SQLQueryExamenPersonas.ApplyUpdates;
      SQLQueryInterventores.Refresh;
      SQLQueryVeedores.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.ButtonEliminar1Click(Sender: TObject);
begin
  try
    if PreInsercion then
    begin
      if SQLQueryExamenPersonas.IsEmpty then
        Exit;
      SQLQueryExamenPersonas.Delete;
      SQLQueryExamenPersonas.ApplyUpdates;
      SQLQueryInterventores.Refresh;
      SQLQueryVeedores.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.Actualizar;
begin
  if not (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.Edit;
 SQLQuery1FECHA.AsDateTime := DateEdit1.Date;
  if (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.ApplyUpdates;
  if (SQLQueryExamenPersonas.State in [dsEdit, dsInsert]) then
    SQLQueryExamenPersonas.ApplyUpdates;
end;

procedure TAbmExamenes.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    //por si las moscas, cerramos todo primero... thank you freepascal!
    SQLQueryAux.Close;
    SQLQueryDesarrolloMat.Close;
    SQLQueryInterventores.Close;
    SQLQueryPersonasExt.Close;
    SQLQueryExamenPersonas.Close;
    SQLQueryPeriodo.Close;
    SQLQueryMat.Close;
    SQLQuerySecc.Close;
    SQLQueryProfesor.Close;
    SQLQueryVeedores.Close;
    //y volvemos a abrir
    SQLQueryAux.Open;
    SQLQueryDesarrolloMat.Open;
    SQLQueryPersonasExt.Open;
    SQLQueryExamenPersonas.Open;
    SQLQueryInterventores.Open;
    SQLQueryPeriodo.Open;
    SQLQueryMat.Open;
    SQLQuerySecc.Open;
    SQLQueryProfesor.Open;
    SQLQueryVeedores.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.ButtonAgregar1Click(Sender: TObject);
begin
  try
    if PreInsercion then
    begin //si no se aplican los updates del sqlquery1 no anda bien esta parte
      if SQLQueryVeedores.IsEmpty then
        Exit;
      if not (SQLQueryExamenPersonas.State in [dsInsert]) then
        SQLQueryExamenPersonas.Append;
      SQLQueryExamenPersonasPERSONAEXTERNAPERSONAID.AsInteger :=
        SQLQueryVeedoresID.AsInteger;
      SQLQueryExamenPersonasEXAMENID.AsInteger := ExamenID;
      SQLQueryExamenPersonas.ApplyUpdates;
      SQLQueryInterventores.Refresh;
      SQLQueryVeedores.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.ButtonEliminarClick(Sender: TObject);
begin
  try
    if PreInsercion then
    begin
      if SQLQueryExamenPersonas.IsEmpty then
        Exit;
      SQLQueryExamenPersonas.Delete;
      SQLQueryExamenPersonas.ApplyUpdates;
      SQLQueryInterventores.Refresh;
      SQLQueryVeedores.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmExamenes.ButtonEliminarFiltrarClick(Sender: TObject);
begin
  SQLQuery1.Refresh;
  inherited;
end;

procedure TAbmExamenes.ButtonModificarFiltrarClick(Sender: TObject);
begin
  SQLQuery1.Refresh;
  inherited;
end;

end.
