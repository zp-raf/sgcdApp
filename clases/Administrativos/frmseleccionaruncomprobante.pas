unit frmseleccionarUnComprobante;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  DBGrids, StdCtrls, ExtCtrls, frmpopup, sqldb, DB, strutils, mensajes;

type

  { TPopupSeleccionarUnComprobante }

  TPopupSeleccionarUnComprobante = class(TPopup)
    Aceptar: TButton;
    Cancelar: TButton;
    SoloFacturas: TCheckBox;
    ds: TDatasource;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    qry: TSQLQuery;
    qryFECHA_EMISION: TDateField;
    qryID: TLongintField;
    qryNOMBRE: TStringField;
    qryNUMERO: TLongintField;
    qryPERSONAID: TLongintField;
    qryRUC: TStringField;
    qryTALONARIOID: TLongintField;
    qryTIPO: TLongintField;
    qryTOTAL: TFloatField;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    constructor Create(AOwner: TComponent; var Comprobante: TMensajeComprobante);
      overload;
    procedure SoloFacturasChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarUnComprobante: TPopupSeleccionarUnComprobante;
  FComprobante: TMensajeComprobante;

implementation

{$R *.lfm}

{ TPopupSeleccionarUnComprobante }

procedure TPopupSeleccionarUnComprobante.LabeledEdit1Change(Sender: TObject);
begin
  qry.Refresh;
end;

procedure TPopupSeleccionarUnComprobante.FormCreate(Sender: TObject);
begin
  qry.Close;
  qry.Open;
end;

procedure TPopupSeleccionarUnComprobante.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FComprobante.comprobante.ID := qryID.AsInteger;
  FComprobante.comprobante.Tipo := qryTIPO.AsInteger;
  FComprobante.comprobante.PersonaID := qryPERSONAID.AsInteger;
  FComprobante.comprobante.Total := qryTOTAL.AsFloat;
  inherited;
end;

procedure TPopupSeleccionarUnComprobante.qryFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if (Trim(LabeledEdit1.Text) = '') then
    if not SoloFacturas.Checked then
      Accept := True
    else
      Accept := DataSet.FieldByName('TIPO').AsInteger = 1
  else
  if not SoloFacturas.Checked then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('RUC').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('TIMBRADO').AsString,
      LabeledEdit1.Text)
  else
    Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('RUC').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('TIMBRADO').AsString,
      LabeledEdit1.Text)) and (DataSet.FieldByName('TIPO').AsInteger = 1);
end;

constructor TPopupSeleccionarUnComprobante.Create(AOwner: TComponent;
  var Comprobante: TMensajeComprobante);
begin
  inherited Create(AOwner);
  FComprobante := Comprobante;
end;

procedure TPopupSeleccionarUnComprobante.SoloFacturasChange(Sender: TObject);
begin
  qry.Refresh;
end;

end.
