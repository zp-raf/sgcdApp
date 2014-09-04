unit frmbuscartalonario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBGrids, ExtCtrls, frmpopup, mensajes, strutils;

type

  { TPopupBuscarTalonario }

  TPopupBuscarTalonario = class(TPopup)
    ButtonCancel: TButton;
    ButtonOK: TButton;
    DBGrid1: TDBGrid;
    ds: TDatasource;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    qry: TSQLQuery;
    qryCAJA: TStringField;
    qryCOPIAS: TLongintField;
    qryDIRECCION: TStringField;
    qryID: TLongintField;
    qryNOMBRE: TStringField;
    qryNOMBRE_TIPO: TStringField;
    qryNUMERO_FIN: TLongintField;
    qryNUMERO_INI: TLongintField;
    qryRUBRO: TStringField;
    qryRUC: TStringField;
    qrySUCURSAL: TStringField;
    qryTELEFONO: TStringField;
    qryTIMBRADO: TStringField;
    qryTIPO: TLongintField;
    qryVALIDO_DESDE: TDateField;
    qryVALIDO_HASTA: TDateField;
    constructor Create(AOwner: TComponent; var Talonario: TMensajeTalonario); overload;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1EditingDone(Sender: TObject);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupBuscarTalonario: TPopupBuscarTalonario;
  FTalonario: TMensajeTalonario;

implementation

{$R *.lfm}

{ TPopupBuscarTalonario }
constructor TPopupBuscarTalonario.Create(AOwner: TComponent;
  var Talonario: TMensajeTalonario);
begin
  inherited Create(AOwner);
  FTalonario := Talonario;
end;

procedure TPopupBuscarTalonario.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FTalonario.talonario.ID := qryID.AsInteger;
  inherited;
end;

procedure TPopupBuscarTalonario.FormCreate(Sender: TObject);
begin
  qry.Close;
  qry.Open;
  if not qry.Locate('ID', IntToStr(FTalonario.talonario.ID), [loCaseInsensitive]) then
    qry.First;
end;

procedure TPopupBuscarTalonario.LabeledEdit1EditingDone(Sender: TObject);
begin
  qry.Refresh;
end;

procedure TPopupBuscarTalonario.qryFilterRecord(DataSet: TDataSet; var Accept: boolean);

begin
  if (Trim(LabeledEdit1.Text)) = '' then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('RUC').AsString,
      LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('TIMBRADO').AsString,
      LabeledEdit1.Text);
end;

end.
