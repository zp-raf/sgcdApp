unit frmtrabajos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, EditBtn, frmAbm, DB, sqldb,
  dateutils;

type

  { TAbmTrabajos }
  TEstadoNuevo = (Materia, Trabajo, Guardado);

  TAbmTrabajos = class(TAbm)
    ButtonSeleecionar: TButton;
    DatasourceProfesor: TDatasource;
    DatasourceDesarrollo: TDatasource;
    DateEditFin: TDateEdit;
    DateEditInicio: TDateEdit;
    DBCheckBox1: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBGridMaterias: TDBGrid;
    DBGridProfesor: TDBGrid;
    DBMemo1: TDBMemo;
    GroupBoxTrabajo: TGroupBox;
    GroupBoxDesarrollo: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1DESARROLLOMATERIAID: TLongintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1FECHAFIN: TDateField;
    SQLQuery1FECHAINICIO: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQuery1PESO: TFloatField;
    SQLQuery1PUNTAJEMAX: TFloatField;
    SQLQueryDesarrollo: TSQLQuery;
    SQLQueryDesarrolloEMPLEADOPERSONAID: TLongintField;
    SQLQueryDesarrolloID: TLongintField;
    SQLQueryDesarrolloMATERIAID: TLongintField;
    SQLQueryDesarrolloNOMBRE_COMPLETO: TStringField;
    SQLQueryDesarrolloNOMBRE_GRUPO: TStringField;
    SQLQueryDesarrolloNOMBRE_MATERIA: TStringField;
    SQLQueryDesarrolloNOMBRE_PERIODO: TStringField;
    SQLQueryDesarrolloNOMBRE_SECCION: TStringField;
    SQLQueryDesarrolloPERIODOLECTIVOID: TLongintField;
    SQLQueryDesarrolloSECCIONID: TLongintField;
    SQLQueryProfesor: TSQLQuery;
    SQLQueryProfesorCEDULA: TStringField;
    SQLQueryProfesorID: TLongintField;
    SQLQueryProfesorNOMBRE_COMPLETO: TStringField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    procedure AbrirCursor; override;
    procedure Actualizar; override;
    procedure ButtonSeleecionarClick(Sender: TObject);
    procedure Cancelar;
    function DatosValidos: boolean; override;
    procedure DBCalendar1Change(Sender: TObject);
    procedure DBCalendar2Change(Sender: TObject);
    procedure DBGridProfesorCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure MenuItemEliminarClick(Sender: TObject); override;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure SQLQueryDesarrolloFilterRecord(DataSet: TDataSet;
      var Accept: boolean);
    procedure OKButtonClick(Sender: TObject); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmTrabajos: TAbmTrabajos;
  EstadoNuevo: TEstadoNuevo;
  DesarrolloID: integer;

implementation

{$R *.lfm}

{ TAbmTrabajos }

procedure TAbmTrabajos.ModificarDatos;
begin
  if not (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.Edit;
  GroupBoxDesarrollo.Enabled := False;
  GroupBoxTrabajo.Enabled := True;
  DateEditInicio.Date := SQLQuery1FECHAINICIO.AsDateTime;
  DateEditFin.Date := SQLQuery1FECHAFIN.AsDateTime;
end;

procedure TAbmTrabajos.SQLQueryDesarrolloFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Estado in [Baja, Modificacion]) then
    Accept := True
  else
    Accept := DataSet.FieldByName('EMPLEADOPERSONAID').AsInteger =
      SQLQueryProfesorID.AsInteger;
end;

procedure TAbmTrabajos.OKButtonClick(Sender: TObject);
begin
  if (EstadoNuevo in [Materia]) and (Estado in [Alta]) then
  begin
    MessageDlg('Informacion', 'Nada que guardar', mtInformation, [mbOK], 0);
    Exit;
  end;
  inherited OKButtonClick(Sender);
  //el nuevo estado de alta es "Guardado"
  if (Self.Estado in [Alta]) then
  begin
    EstadoNuevo := Guardado;
  end;
  //parche jarebola
  //DBGrid2.Columns[0].Visible := True;
  //DBGrid1.Columns[0].Visible := True;
end;

procedure TAbmTrabajos.AbrirCursor;
begin
  try
    //por si las moscas, cerramos todo primero... thank you freepascal!
    SQLQueryProfesor.Close;
    SQLQueryDesarrollo.Close;
    //y volvemos a abrir
    SQLQueryProfesor.Open;
    SQLQueryDesarrollo.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited AbrirCursor;//abrimos dps el query principal para que salgan los campos lookup
end;

procedure TAbmTrabajos.Actualizar;
begin
  SQLQuery1FECHAINICIO.AsDateTime := DateEditInicio.Date;
  SQLQuery1FECHAFIN.AsDateTime := DateEditFin.Date;
  if (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.ApplyUpdates;
end;

procedure TAbmTrabajos.ButtonSeleecionarClick(Sender: TObject);
begin
  try
    if (EstadoNuevo in [Trabajo]) then
      case MessageDlg('Guardar cambios',
          'No ha guardado los cambios realizados. ¿Desea guardarlos y continuar?',
          mtConfirmation, [mbYes, mbNo], 0) of
        mrYes:
        begin
          //guardar
          OKButtonClick(Self);
        end;
        mrNo:
        begin
          //descartar
          Cancelar;
        end;
      end;
    DesarrolloID := SQLQueryDesarrolloID.AsInteger;
    SQLQuery1.Append;
    SQLQuery1DESARROLLOMATERIAID.AsInteger := DesarrolloID;
    //sacamos el desarrolloid para trabajar
    {por defecto las fechas se ponen al dia de hoy}
    SQLQuery1FECHAINICIO.AsDateTime := Now;
    SQLQuery1FECHAFIN.AsDateTime := Now;
    {activo a true}
    SQLQuery1ACTIVO.AsInteger := 1;
    GroupBoxTrabajo.Enabled := True;
    EstadoNuevo := Trabajo;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmTrabajos.Cancelar;
begin
  try
    sqlquery1.Cancel;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

function TAbmTrabajos.DatosValidos: boolean;
begin
  if (Trim(DBEdit1.Text) = '') or (Trim(DBEdit2.Text) = '') or
    (Trim(DBEdit3.Text) = '') or (Trim(DBMemo1.Text) = '') then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    {chequeamos los datos}
    {if not FechaValida(DateEditInicio.Date) or FechaValida(DateEditFin.Date) then
    begin
      MessageDlg('Informacion', 'Fechas no válidas',
        mtInformation, [mbOK], 0);
      Result := False;
      Exit;
    end; }
    if CompareDate(SQLQuery1FECHAFIN.AsDateTime,
      SQLQuery1FECHAINICIO.AsDateTime) = -1 then
    begin
      MessageDlg('Informacion',
        'La fecha de incio debe ser menor o igual a la de fin',
        mtInformation, [mbOK], 0);
      Result := False;
      Exit;
    end;
    if (SQLQuery1PUNTAJEMAX.AsFloat <= 0.0) then
    begin
      MessageDlg('Informacion', 'Puntaje inválido', mtInformation, [mbOK], 0);
      Result := False;
      Exit;
    end;
    if (SQLQuery1PESO.AsFloat <= 0.0) or (SQLQuery1PESO.AsFloat > 100.0) then
    begin
      MessageDlg('Informacion', 'Peso inválido', mtInformation, [mbOK], 0);
      Result := False;
      Exit;
    end;
    Result := True;
  end;
end;

procedure TAbmTrabajos.DBCalendar1Change(Sender: TObject);
begin
  if (SQLQuery1.State in [dsInsert, dsEdit]) then
  begin
    SQLQuery1FECHAINICIO.AsDateTime := DateEditInicio.Date;
  end;
end;

procedure TAbmTrabajos.DBCalendar2Change(Sender: TObject);
begin
  if (SQLQuery1.State in [dsInsert, dsEdit]) then
  begin
    SQLQuery1FECHAFIN.AsDateTime := DateEditFin.Date;
  end;
end;

procedure TAbmTrabajos.DBGridProfesorCellClick(Column: TColumn);
begin
  try
    SQLQueryDesarrollo.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmTrabajos.FormCreate(Sender: TObject);
begin
  IniciaForm('TRABAJO', 'ID');
  inherited FormCreate(Sender);
  Self.WhereQuery :=
    ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'') OR DESCRIPCION CONTAINING ' +
    ' UPPER('':PARAMETER'')';
end;

procedure TAbmTrabajos.Insertar;
begin
  //no hace falta
end;

procedure TAbmTrabajos.MenuItemEliminarClick(Sender: TObject);
begin
  SQLQueryDesarrollo.Close;
  SQLQueryDesarrollo.Filtered := False;
  inherited;
end;

procedure TAbmTrabajos.MenuItemModificarClick(Sender: TObject);
begin
  SQLQueryDesarrollo.Close;
  SQLQueryDesarrollo.Filtered := False;
  inherited;
end;

procedure TAbmTrabajos.MenuItemNuevoClick(Sender: TObject);
begin
  SQLQueryDesarrollo.Close;
  SQLQueryDesarrollo.Filtered := True;
  inherited MenuItemNuevoClick(Sender);
  GroupBoxDesarrollo.Enabled := True;
  GroupBoxTrabajo.Enabled := False;
  EstadoNuevo := Materia;
end;

end.
