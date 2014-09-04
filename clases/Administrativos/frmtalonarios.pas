unit frmtalonarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, EditBtn, frmAbm,
  frmsgcddatamodule;

type

  { TAbmTalonarios }
  TAbmTalonarios = class(TAbm)
  published
    dsDet: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBCheckBox1: TDBCheckBox;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    det: TSQLQuery;
    detOBJETO: TStringField;
    detSIGNIFICADO: TStringField;
    detVALOR: TLongintField;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1CAJA: TStringField;
    SQLQuery1COPIAS: TLongintField;
    SQLQuery1DIRECCION: TStringField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQuery1NUMERO_FIN: TLongintField;
    SQLQuery1NUMERO_INI: TLongintField;
    SQLQuery1RUBRO: TStringField;
    SQLQuery1RUC: TStringField;
    SQLQuery1SUCURSAL: TStringField;
    SQLQuery1TELEFONO: TStringField;
    SQLQuery1TIMBRADO: TStringField;
    SQLQuery1TIPO: TLongintField;
    SQLQuery1VALIDO_DESDE: TDateField;
    SQLQuery1VALIDO_HASTA: TDateField;
    StringField1: TStringField;
    procedure AbrirCursor; override;
    procedure AbrirCursorFiltrado(param: string); override;
    procedure Actualizar; override;
    procedure Borrar; override;
    procedure CerrarDataset; override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure ModificarDatos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure LimpiarCampos; override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure SQLQuery1TIPOChange(Sender: TField);
  end;

var
  AbmTalonarios: TAbmTalonarios;

implementation

{$R *.lfm}

{ TAbmTalonarios }

procedure TAbmTalonarios.AbrirCursor;
begin
  with det do
  begin
    Close;
    Open;
  end;
  inherited AbrirCursor;
end;

procedure TAbmTalonarios.AbrirCursorFiltrado(param: string);
begin
  with det do
  begin
    Close;
    Open;
  end;
  inherited AbrirCursorFiltrado(param);
end;

procedure TAbmTalonarios.Actualizar;
begin
  SQLQuery1VALIDO_DESDE.AsDateTime := DateEdit1.Date;
  SQLQuery1VALIDO_HASTA.AsDateTime := DateEdit2.Date;
end;

procedure TAbmTalonarios.Borrar;
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Edit;
  SQLQuery1ACTIVO.AsInteger := 0;
end;

procedure TAbmTalonarios.CerrarDataset;
begin
  inherited CerrarDataset;
end;

function TAbmTalonarios.DatosValidos: boolean;
begin
  if (Trim(SQLQuery1DIRECCION.AsString) = '') or
    (Trim(SQLQuery1NOMBRE.AsString) = '') or (Trim(SQLQuery1RUBRO.AsString) = '') or
    (Trim(SQLQuery1TELEFONO.AsString) = '') or
    (Trim(SQLQuery1TIMBRADO.AsString) = '') or (Trim(DateEdit1.Text) = '') or
    (Trim(DateEdit2.Text) = '') or (Trim(SQLQuery1NUMERO_INI.AsString) = '') or
    (Trim(SQLQuery1NUMERO_FIN.AsString) = '') or
    (Trim(SQLQuery1SUCURSAL.AsString) = '') or (Trim(SQLQuery1CAJA.AsString) = '') or
    (Trim(SQLQuery1ACTIVO.AsString) = '') or
    (Trim(SQLQuery1COPIAS.AsString) = '') then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else if (SQLQuery1NUMERO_INI.AsInteger < 1) or
    (SQLQuery1NUMERO_FIN.AsInteger < 1) or (SQLQuery1COPIAS.AsInteger < 1) then
  begin
    Result := False;
    MessageDlg('Informacion',
      'Los campos de numero inicial, numero final y numero de copias deben ser mayores a 1',
      mtInformation, [mbOK], 0);
  end
  else if SQLQuery1NUMERO_INI.AsInteger > SQLQuery1NUMERO_FIN.AsInteger then
  begin
    Result := False;
    MessageDlg('Informacion',
      'El numero inicial no puede ser mayor al final',
      mtInformation, [mbOK], 0);
  end
  else if (SQLQuery1TIPO.AsInteger in [1, 3]) and (Trim(SQLQuery1RUC.AsString) = '') then
  begin
    Result := False;
    MessageDlg('Informacion',
      'El campo RUC no puede quedar vacío para el tipo de talonario seleccionado',
      mtInformation, [mbOK], 0);
  end
  else if not (FechaValida(DateEdit1.Date) and FechaValida(DateEdit2.Date)) then
    Result := False
  else if DateEdit1.Date > DateEdit2.Date then
  begin
    Result := False;
    MessageDlg('Informacion',
      'La fecha de inicio de validez no puede ser mayor a la de culminación de validez',
      mtInformation, [mbOK], 0);
  end
  else
    Result := True;
end;

procedure TAbmTalonarios.FormCreate(Sender: TObject);
begin
  self.Query := 'SELECT * FROM TALONARIO';
  self.InsQuery := 'INSERT INTO TALONARIO (ID, TIPO, NOMBRE, RUBRO, DIRECCION, ' +
    'TELEFONO, TIMBRADO, VALIDO_DESDE, VALIDO_HASTA, RUC, SUCURSAL, CAJA, ' +
    'NUMERO_INI, NUMERO_FIN, COPIAS, ACTIVO) VALUES (:ID, :TIPO, :NOMBRE, :RUBRO, ' +
    ':DIRECCION, :TELEFONO, :TIMBRADO, :VALIDO_DESDE, :VALIDO_HASTA, :RUC, ' +
    ':SUCURSAL, :CAJA, :NUMERO_INI, :NUMERO_FIN, :COPIAS, :ACTIVO)';
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')' +
    'OR RUC CONTAINING UPPER('':PARAMETER'')' +
    'OR TIMBRADO CONTAINING UPPER('':PARAMETER'')';
end;

procedure TAbmTalonarios.Insertar;
begin
  SQLQuery1ID.AsInteger := SGCDDataModule.SiguienteValor('SEQ_TALONARIO');
  SQLQuery1VALIDO_DESDE.AsDateTime := DateEdit1.Date;
  SQLQuery1VALIDO_HASTA.AsDateTime := DateEdit2.Date;
end;

procedure TAbmTalonarios.ModificarDatos;
begin
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Edit;
  DBLookupComboBox1.Enabled := False;
  DateEdit1.Date := SQLQuery1VALIDO_DESDE.AsDateTime;
  DateEdit2.Date := SQLQuery1VALIDO_HASTA.AsDateTime;
end;

procedure TAbmTalonarios.MenuItemNuevoClick(Sender: TObject);
begin
  inherited MenuItemNuevoClick(Sender);
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
  DBLookupComboBox1.Enabled := True;
  SQLQuery1ACTIVO.AsInteger := 1;//activo pro defecto
end;

procedure TAbmTalonarios.LimpiarCampos;
begin
  inherited LimpiarCampos;
  DateEdit1.Clear;
  DateEdit2.Clear;
end;

procedure TAbmTalonarios.OKButtonClick(Sender: TObject);
begin
  inherited OKButtonClick(Sender);
end;

procedure TAbmTalonarios.SQLQuery1TIPOChange(Sender: TField);
begin
    if SQLQuery1TIPO.AsInteger = 2 then
  begin
    DBEdit3.Enabled := False;
    SQLQuery1RUC.Clear;
  end
  else
    DBEdit3.Enabled := True;
end;

end.
