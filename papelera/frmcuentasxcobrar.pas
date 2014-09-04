unit frmcuentasxcobrar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, EditBtn, ComCtrls,
  frmAbm, frmsgcddatamodule, strutils;

type

  { TABMDeudasAlumno }

  TABMDeudasAlumno = class(TAbm)
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBMemo1: TDBMemo;
    dsPersona: TDatasource;
    dsArancel: TDatasource;
    Label2: TLabel;
    Label4: TLabel;
    LabeledEdit1: TLabeledEdit;
    qryArancel: TSQLQuery;
    qryPersona: TSQLQuery;
    qryArancelDESCRIPCION: TStringField;
    qryArancelID: TLongintField;
    qryArancelMONTO: TFloatField;
    qryArancelNOMBRE: TStringField;
    qryPersonaAPELLIDO: TStringField;
    qryPersonaCEDULA: TStringField;
    qryPersonaESADMINISTRATIVO: TLongintField;
    qryPersonaESALUMNO: TLongintField;
    qryPersonaESCOORDINADOR: TLongintField;
    qryPersonaESENCARGADO: TLongintField;
    qryPersonaESINTERVENTOR: TLongintField;
    qryPersonaESPROFESOR: TLongintField;
    qryPersonaESPROVEEDOR: TLongintField;
    qryPersonaESVEEDOR: TLongintField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRE: TStringField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1ARANCELID: TLongintField;
    SQLQuery1CANTIDAD: TLongintField;
    SQLQuery1CANT_CUOTAS: TLongintField;
    SQLQuery1CUOTA_NRO: TLongintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1FECHA_DEUDA: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MATRICULAID: TLongintField;
    NombreArancel: TStringField;
    SQLQuery1MONTO_DEUDA: TFloatField;
    SQLQuery1MONTO_PAGADO: TFloatField;
    SQLQuery1PERSONAID: TLongintField;
    SQLQuery1SALDO: TFloatField;
    StringField1: TStringField;
    procedure AbrirCursor; override;
    procedure AbrirCursorFiltrado(param: string); override;
    procedure Borrar; override;
    procedure FormCreate(Sender: TObject); override;
    procedure FormShow(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure Insertar; override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure Actualizar; override;
    procedure ModificarDatos; override;
    procedure qryPersonaFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ABMDeudasAlumno: TABMDeudasAlumno;

implementation

{$R *.lfm}

{ TABMDeudasAlumno }

procedure TABMDeudasAlumno.FormCreate(Sender: TObject);
begin
  IniciaForm('DEUDA', 'ID');
  inherited;
   {
   Self.InsQuery := 'insert into DEUDA (ID, ARANCELID, PERSONAID, MATRICULAID, ACTIVO, MONTO_DEUDA, MONTO_PAGADO, FECHA_DEUDA, DESCRIPCION, ' +
   'CUOTA_NRO, CANT_CUOTAS, CANTIDAD)'  +
    'values (:ID, :ARANCELID, :PERSONAID, :MATRICULAID, :ACTIVO, :MONTO_DEUDA, :MONTO_PAGADO, :FECHA_DEUDA, :DESCRIPCION,' +
    ':CUOTA_NRO, :CANT_CUOTAS, :CANTIDAD)';
    }
end;

procedure TABMDeudasAlumno.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    qryPersona.Close;
    qryArancel.Close;

    qryPersona.Open;
    qryArancel.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TABMDeudasAlumno.AbrirCursorFiltrado(param: string);
begin
  inherited AbrirCursorFiltrado(param);
  try
    qryPersona.Close;
    qryArancel.Close;

    qryPersona.Open;
    qryArancel.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TABMDeudasAlumno.Borrar;
begin
  //inherited Borrar;
  SQLQuery1ACTIVO.AsInteger := 0;
end;

///ejemplo de abrir otro form

{procedure TfrmContratosSubcontratistas.btnAnexarClick(Sender: TObject);
var
  frmPresupuestos : TfrmPresupuestos;
begin
  inherited;
  frmPresupuestos := TfrmPresupuestos(datos.frmManager.getInstanceOf('TfrmPresupuestos'));
  frmPresupuestos.Show;
  frmPresupuestos.qryPrincipal.Insert;
  frmPresupuestos.qryPrincipalID_CONTRATO.AsInteger := qryPrincipalID_CONTRATO.AsInteger;
  frmPresupuestos.qryPrincipalID_BPARTNER.AsInteger := qryPrincipalID_SUBCONTRATISTA.AsInteger;
  frmPresupuestos.qryPrincipalDESCRIPCION.AsString := qryPrincipalREFERENTE.AsString;
  frmPresupuestos.qryPrincipalNUMERO.AsInteger := dbgDetalles.RowCount+1 ;
  frmPresupuestos.qryPrincipal.Post;
  qryDetalle.Close;
  qryDetalle.Open;
end;
}

procedure TABMDeudasAlumno.FormShow(Sender: TObject);
begin
  Limpiar;
  try
    SGCDDataModule.dbConn.Connected := True;
    SQLQuery1.DataBase := SGCDDataModule.dbConn;
    SQLQuery1.Transaction := SGCDDataModule.sqlTran;
    SQLQuery1.Close;
    Self.Estado := Inicial;
    //para que salga el listado primero
    MenuItemModificar.Visible := False;
    MenuItemEliminarClick(Self);
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

function TABMDeudasAlumno.DatosValidos: boolean;
begin
  if (Trim(DBMemo1.Text) = '') then
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


procedure TABMDeudasAlumno.Insertar;
begin
  SQLQuery1ID.AsInteger := SGCDDataModule.SiguienteValor('GENERATOR_DEUDA');
  SQLQuery1MONTO_PAGADO.AsFloat := 0; //obviamente jeje
  SQLQuery1FECHA_DEUDA.AsDateTime := Now;  //fecha de ho
  SQLQuery1CANTIDAD.AsInteger := 1; // asi le pongo al insertar desde aca
  SQLQuery1PERSONAID.AsInteger := qryPersonaID.AsInteger;
  SQLQuery1ARANCELID.AsInteger := qryArancelID.AsInteger;
end;

procedure TABMDeudasAlumno.LabeledEdit1Change(Sender: TObject);
begin
  qryPersona.Refresh;
end;

procedure TABMDeudasAlumno.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
end;

procedure TABMDeudasAlumno.OKButtonClick(Sender: TObject);
begin
  //  Como ya guarde en el proceso anterior, limpio nada mas mi dataset o lo que sea
  inherited;
end;

procedure TABMDeudasAlumno.Actualizar;
begin
  //no se permite actualizar
end;

procedure TABMDeudasAlumno.ModificarDatos;
begin
  //no se permite modificar
end;

procedure TABMDeudasAlumno.qryPersonaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Estado in [Modificacion, Baja]) then
    Accept := True
  else if Trim(LabeledEdit1.Text) = '' then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName(
      'NOMBRECOMPLETO').AsString, LabeledEdit1.Text);
end;

end.
