unit frmseleccionarfacturas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, StdCtrls, PairSplitter, frmpopup, mensajes, sqldb, DB,
  strutils, frmsgcddatamodule;

type

  { TPopupSeleccionarFacturas }

  TPopupSeleccionarFacturas = class(TPopup)
    Aceptar: TButton;
    ds: TDatasource;
    Cancelar: TButton;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    qryFacturas: TSQLQuery;
    qryFacturasCONTADO: TSmallintField;
    qryFacturasFECHA_EMISION: TDateField;
    qryFacturasID: TLongintField;
    qryFacturasNOMBRE: TStringField;
    qryFacturasNUMERO: TLongintField;
    qryFacturasRUC: TStringField;
    qryFacturasTOTAL: TFloatField;
    procedure AbrirCursor;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    constructor Create(AOwner: TComponent; var Factura: TMensajeFacturaUnica); overload;
    procedure qryFacturasFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarFacturas: TPopupSeleccionarFacturas;
  FFactura: TMensajeFacturaUnica;

implementation

{$R *.lfm}

{ TPopupSeleccionarFacturas }

procedure TPopupSeleccionarFacturas.LabeledEdit1Change(Sender: TObject);
begin
  qryFacturas.Refresh;
end;

constructor TPopupSeleccionarFacturas.Create(AOwner: TComponent; var Factura: TMensajeFacturaUnica);
begin
  inherited Create(AOwner);
  FFactura := Factura;
end;

procedure TPopupSeleccionarFacturas.qryFacturasFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if Trim(LabeledEdit1.Text) = '' then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NUMERO').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('RUC').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      LabeledEdit1.Text);
  {if (Trim(LabeledEdit1.Text) = '') and (Trim(auxRUC) = '') then
    Accept := True
  else if not (Trim(LabeledEdit1.Text) = '') and (Trim(auxRUC) = '') then
    Accept := (not Fqry.Locate('FACTURAID', DataSet.FieldByName('ID').AsString,
      [loCaseInsensitive])) and (AnsiContainsText(
      DataSet.FieldByName('NUMERO').AsString, LabeledEdit1.Text) or
      AnsiContainsText(DataSet.FieldByName('RUC').AsString, LabeledEdit1.Text) or
      AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      LabeledEdit1.Text)) and (DataSet.FieldByName('RUC').AsString = auxRUC)
  else if (Trim(auxRUC) = '') then
    Accept := (not Fqry.Locate('FACTURAID', DataSet.FieldByName('ID').AsString,
      [loCaseInsensitive])) and (AnsiContainsText(
      DataSet.FieldByName('NUMERO').AsString, LabeledEdit1.Text) or
      AnsiContainsText(DataSet.FieldByName('RUC').AsString, LabeledEdit1.Text) or
      AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString, LabeledEdit1.Text))
  else
    Accept := (not Fqry.Locate('FACTURAID', DataSet.FieldByName('ID').AsString,
      [loCaseInsensitive])) and (DataSet.FieldByName('RUC').AsString = auxRUC);}
end;

procedure TPopupSeleccionarFacturas.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FFactura.factura.ID := qryFacturasID.AsInteger;
  inherited;
end;

procedure TPopupSeleccionarFacturas.FormShow(Sender: TObject);
begin
  inherited;
  AbrirCursor;
end;

procedure TPopupSeleccionarFacturas.AbrirCursor;
begin
  qryFacturas.Close;
  qryFacturas.Open;
end;

end.
