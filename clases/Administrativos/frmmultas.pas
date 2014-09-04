unit frmmultas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, DBGrids, StdCtrls, XMLPropStorage, ExtCtrls, frmProceso, sqldb,
  DB, strutils, frmsgcddatamodule, ShellApi;

type

  { TProcesoMultas }

  TProcesoMultas = class(TProceso)
    DBGrid1: TDBGrid;
    ds: TDatasource;
    LabeledEdit1: TLabeledEdit;
    qry: TSQLQuery;
    qryDESCRIPCION: TStringField;
    qryID: TLongintField;
    qryMONTO: TFloatField;
    qryNOMBRE: TStringField;
    spMulta: TSQLQuery;
    XMLPropStorage1: TXMLPropStorage;
    procedure CancelButtonClick(Sender: TObject); override;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject); override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoMultas: TProcesoMultas;
  arancelid: integer;

implementation

{$R *.lfm}

{ TProcesoMultas }

procedure TProcesoMultas.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if XMLPropStorage1.StoredValues.Items[0].Value = '' then
    arancelid := 0
  else
    arancelid := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoMultas.OKButtonClick(Sender: TObject);
begin
  try
    arancelid := qryID.AsInteger;
    spMulta.Params.Items[0].AsInteger := arancelid;
    //spMulta.Active:=True;
    //spMulta.Prepare;
    spMulta.ExecSQL;
    //spMulta.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    ShowMessage('Exito');
    qry.Close;
    qry.Open;
    if not qry.Locate('ID', IntToStr(arancelid), [loCaseInsensitive]) then
      qry.First;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
      SGCDDataModule.sqlTran.Rollback;
    end;
  end;
end;

procedure TProcesoMultas.qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  if (Trim(LabeledEdit1.Text) = '') then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      Trim(LabeledEdit1.Text));
end;

procedure TProcesoMultas.CancelButtonClick(Sender: TObject);
begin
  inherited;
end;

procedure TProcesoMultas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoMultas.FormCreate(Sender: TObject);
begin
  try
    qry.Close;
    qry.Open;
    XMLPropStorage1.Restore;
    if not qry.Locate('ID', IntToStr(arancelid), [loCaseInsensitive]) then
      qry.First;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMultas.LabeledEdit1Change(Sender: TObject);
begin
  qry.Refresh;
end;

procedure TProcesoMultas.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\actualizarMulta.html', nil, nil, 1);
end;

procedure TProcesoMultas.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(arancelid);
end;

end.
