unit frmseleccionarUnaFactura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  PairSplitter, DBGrids, Menus, ExtCtrls, frmseleccionarfacturas, frmpopup,
  sqldb, DB, strutils, mensajes;

type

  { TPopupSeleccionarUnaFactura }

  TPopupSeleccionarUnaFactura = class(TPopup)
    ButtonCancel: TButton;
    ButtonOK: TButton;
    DBGrid1: TDBGrid;
    ds: TDatasource;
    LabeledEdit1: TLabeledEdit;
    qry: TSQLQuery;
    qryCOBRADA: TLongintField;
    qryCONTADO: TSmallintField;
    qryFECHA_EMISION: TDateField;
    qryID: TLongintField;
    qryNOMBRE: TStringField;
    qryNUMERO: TLongintField;
    qryRUC: TStringField;
    qryTOTAL: TFloatField;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    constructor Create(AOwner: TComponent; Factura: TMensajeFacturaUnica); overload;

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarUnaFactura: TPopupSeleccionarUnaFactura;
  FFactura: TMensajeFacturaUnica;

implementation

{$R *.lfm}

{ TPopupSeleccionarUnaFactura }

procedure TPopupSeleccionarUnaFactura.qryFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Trim(LabeledEdit1.Text) = '') then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('RUC').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('TIMBRADO').AsString,
      LabeledEdit1.Text);
end;

constructor TPopupSeleccionarUnaFactura.Create(AOwner: TComponent;
  Factura: TMensajeFacturaUnica);
begin
  inherited Create(AOwner);
  FFactura := Factura;
end;

procedure TPopupSeleccionarUnaFactura.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FFactura.factura.ID := qryID.AsInteger;
  inherited;
end;

procedure TPopupSeleccionarUnaFactura.FormCreate(Sender: TObject);
begin
  with qry do
  begin
    Close;
    Open;
  end;
  if not qry.Locate('ID', IntToStr(FFactura.factura.ID), [loCaseInsensitive]) then
    qry.First;
end;

procedure TPopupSeleccionarUnaFactura.LabeledEdit1Change(Sender: TObject);
begin
  qry.Refresh;
end;

end.
