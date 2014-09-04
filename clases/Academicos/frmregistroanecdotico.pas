unit frmRegistroAnecdotico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, EditBtn, frmAbm, DB, sqldb,
  strutils;

type

  { TAbmRegistroAnecdotico }

  TAbmRegistroAnecdotico = class(TAbm)
    DateEdit1: TDateEdit;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    dsal: TDatasource;
    DBGrid3: TDBGrid;
    Fecha: TLabel;
    Contexto: TLabel;
    Evento: TLabel;
    LabeledEdit1: TLabeledEdit;
    qryal: TSQLQuery;
    qryalAPELLIDO: TStringField;
    qryalCEDULA: TStringField;
    qryalCONFIRMADO: TSmallintField;
    qryalFECHANAC: TDateField;
    qryalID: TLongintField;
    qryalNOMBRE: TStringField;
    qryalNOMBRECOMPLETO: TStringField;
    qryalSEXO: TStringField;
    SQLQuery1ALUMNOPERSONAID: TLongintField;
    SQLQuery1CONTEXTO: TStringField;
    SQLQuery1EVENTO: TStringField;
    SQLQuery1FECHA: TDateField;
    SQLQuery1ID: TLongintField;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure AbrirCursor; override;
    procedure AbrirCursorFiltrado(param: string); override;
    procedure Actualizar; override;
    procedure ButtonEliminarFiltrarClick(Sender: TObject);
    procedure ButtonModificarFiltrarClick(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure qryalFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmRegistroAnecdotico: TAbmRegistroAnecdotico;

implementation

{$R *.lfm}

{ TAbmRegistroAnecdotico }

procedure TAbmRegistroAnecdotico.AbrirCursor;
begin
  inherited AbrirCursor;
  qryal.Close;
  qryal.Open;
end;

procedure TAbmRegistroAnecdotico.AbrirCursorFiltrado(param: string);
begin
  inherited AbrirCursorFiltrado(param);
  qryal.Close;
  qryal.Open;
end;

procedure TAbmRegistroAnecdotico.Actualizar;
begin
  SQLQuery1FECHA.AsDateTime := DateEdit1.Date;
end;

procedure TAbmRegistroAnecdotico.ButtonEliminarFiltrarClick(Sender: TObject);
begin
  if not (Trim(EditEliminarFiltro.Text) = '') then
  begin
    SQLQuery1.Filtered := True;
    SQLQuery1.Refresh;
  end
  else
  begin
    SQLQuery1.Filtered := False;
    SQLQuery1.Refresh;
  end;
end;

procedure TAbmRegistroAnecdotico.ButtonModificarFiltrarClick(Sender: TObject);
begin
  if not (Trim(EditModificarFiltro.Text) = '') then
  begin
    SQLQuery1.Filtered := True;
    SQLQuery1.Refresh;
  end
  else
  begin
    SQLQuery1.Filtered := False;
    SQLQuery1.Refresh;
  end;
end;

function TAbmRegistroAnecdotico.DatosValidos: boolean;
begin
  if (Trim(DateEdit1.Text) = '') or (Trim(DBMemo2.Text) = '') then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end;
end;

procedure TAbmRegistroAnecdotico.FormCreate(Sender: TObject);
begin
  IniciaForm('REGISTROANECDOTICO', 'ID');
  inherited;
end;

procedure TAbmRegistroAnecdotico.Insertar;
begin
  SQLQuery1FECHA.AsDateTime := DateEdit1.Date;
  SQLQuery1ALUMNOPERSONAID.Value := qryalID.Value;
end;

procedure TAbmRegistroAnecdotico.LabeledEdit1Change(Sender: TObject);
begin
  qryal.Refresh;
end;

procedure TAbmRegistroAnecdotico.MenuItemNuevoClick(Sender: TObject);
begin
  inherited MenuItemNuevoClick(Sender);
  DBGrid3.Enabled := True;
  if not (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.Append;
end;

procedure TAbmRegistroAnecdotico.ModificarDatos;
begin
  qryal.Locate('ID', SQLQuery1ALUMNOPERSONAID.Value, [loCaseInsensitive]);
  DBGrid3.Enabled := False;
  if not (SQLQuery1.State in [dsEdit, dsInsert]) then
    SQLQuery1.Edit;
end;

procedure TAbmRegistroAnecdotico.qryalFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Trim(LabeledEdit1.Text) = '') then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
      LabeledEdit1.Text) or AnsiContainsText(
      DataSet.FieldByName('CEDULA').AsString, LabeledEdit1.Text);
end;

procedure TAbmRegistroAnecdotico.SQLQuery1FilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Estado in [Alta]) then
    Accept := True
  else if (Estado in [Baja]) and not (Trim(EditEliminarFiltro.Text) = '') then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
      EditEliminarFiltro.Text) or AnsiContainsText(
      DataSet.FieldByName('CEDULA').AsString, EditEliminarFiltro.Text)
  else if (Estado in [Modificacion]) and not (Trim(EditModificarFiltro.Text) = '') then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
      EditModificarFiltro.Text) or AnsiContainsText(
      DataSet.FieldByName('CEDULA').AsString, EditModificarFiltro.Text);
end;

end.
