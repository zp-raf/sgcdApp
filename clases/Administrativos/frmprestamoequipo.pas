unit frmprestamoequipo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, PairSplitter, StdCtrls, DBGrids, DBCtrls, ExtCtrls, EditBtn,
  frmProceso, sqldb, DB, strutils, frmsgcddatamodule, ShellApi;

type

  { TProcesoPrestamo }

  TProcesoPrestamo = class(TProceso)
    ACTIVO: TDBCheckBox;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    dsPer: TDatasource;
    ds: TDatasource;
    DBGrid2: TDBGrid;
    dsEq: TDatasource;
    DBGrid1: TDBGrid;
    eqACTIVO: TSmallintField;
    eqDESCRIPCION: TStringField;
    eqDISPONIBLE: TSmallintField;
    eqID: TLongintField;
    eqNOMBRE: TStringField;
    eqNRO_SERIE: TStringField;
    Equipos: TGroupBox;
    Inicio: TLabel;
    Fin: TLabel;
    LabeledEdit1: TLabeledEdit;
    Prestamo: TGroupBox;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    eq: TSQLQuery;
    qry: TSQLQuery;
    qryACTIVO: TSmallintField;
    qryEQUIPOID: TLongintField;
    qryFECHAFIN: TDateField;
    qryFECHAINICIO: TDateField;
    qryID: TLongintField;
    qryPer: TSQLQuery;
    qryPerCEDULA: TStringField;
    qryPerID: TLongintField;
    qryPerNOMBRECOMPLETO: TStringField;
    qryPERSONAID: TLongintField;
    procedure AbrirCursor;
    function DatosValidos: boolean;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject); override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryNewRecord(DataSet: TDataSet);
    procedure qryPerFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoPrestamo: TProcesoPrestamo;

implementation

{$R *.lfm}

{ TProcesoPrestamo }

procedure TProcesoPrestamo.qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('EQUIPOID').Value = eqID.Value;
end;

procedure TProcesoPrestamo.qryNewRecord(DataSet: TDataSet);
begin
  qryID.AsInteger := SGCDDataModule.SiguienteValor('GEN_PRESTAMO');
end;

procedure TProcesoPrestamo.qryPerFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  if (trim(LabeledEdit1.Text) = '') then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').Value,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').Value,
      LabeledEdit1.Text);
end;

procedure TProcesoPrestamo.AbrirCursor;
begin
  eq.Close;
  qry.Close;
  qryPer.Close;
  eq.Open;
  qry.Open;
  qryPer.Open;
end;

function TProcesoPrestamo.DatosValidos: boolean;
begin
  if (DateEdit1.Text = '') or (DateEdit2.Text = '') then
  begin
    ShowMessage('Complete los campos requeridos');
    Result := False;
  end;
end;

procedure TProcesoPrestamo.DBGrid1CellClick(Column: TColumn);
begin
  try
    if (qry.State in [dsEdit, dsInsert]) then
      qry.Cancel;
    qry.Refresh;
    if not qryPer.Locate('ID', qryPERSONAID.Value, [loCaseInsensitive]) then
      qryPer.First;
    if eqDISPONIBLE.AsInteger = 1 then
    begin
      if not (qry.State in [dsEdit, dsInsert]) then
        qry.Append;
      qryACTIVO.AsInteger := 1;
    end
    else
    begin
      DateEdit1.Date := qryFECHAINICIO.AsDateTime;
      DateEdit2.Date := qryFECHAFIN.AsDateTime;
      if not (qry.State in [dsEdit, dsInsert]) then
        qry.Edit;
    end;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      AbrirCursor;
    end;
  end;
end;

procedure TProcesoPrestamo.FormCreate(Sender: TObject);
begin
  inherited;
  AbrirCursor;
end;

procedure TProcesoPrestamo.LabeledEdit1Change(Sender: TObject);
begin
  qryPer.Refresh;
end;

procedure TProcesoPrestamo.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
  ShellExecute(Handle, 'open', 'help\ABMs\prestamoEquipo.html', nil, nil, 1);
end;

procedure TProcesoPrestamo.OKButtonClick(Sender: TObject);
begin
  try
    if (qry.State in [dsEdit, dsInsert]) and DatosValidos then
    begin
      qryFECHAINICIO.AsDateTime := DateEdit1.Date;
      qryFECHAFIN.AsDateTime := DateEdit2.Date;
      qryPERSONAID.AsInteger := qryPerID.AsInteger;
      qryEQUIPOID.AsInteger := eqID.AsInteger;
      qry.ApplyUpdates;
      SGCDDataModule.sqlTran.Commit;
      AbrirCursor;
    end;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      AbrirCursor;
    end;
  end;
end;

end.

