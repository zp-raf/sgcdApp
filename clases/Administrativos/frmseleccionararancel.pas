unit frmseleccionararancel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, DBGrids, ExtCtrls, Grids, PairSplitter, DBCtrls, frmpopup,
  strutils, mensajes;

type

  { TPopupSeleccionarArancel }

  TPopupSeleccionarArancel = class(TPopup)
    Button1: TButton;
    Button2: TButton;
    DBGrid1: TDBGrid;
    ds: TDatasource;
    LabeledEdit1: TLabeledEdit;
    qry: TSQLQuery;
    qryDESCRIPCION: TStringField;
    qryID: TLongintField;
    qryMONTO: TFloatField;
    qryNOMBRE: TStringField;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    constructor Create(AOwner: TComponent; var Aranceles: TMensajeAranceles); overload;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarArancel: TPopupSeleccionarArancel;
  FAranceles: TMensajeAranceles;

implementation

{$R *.lfm}

{ TPopupSeleccionarArancel }
constructor TPopupSeleccionarArancel.Create(AOwner: TComponent;
  var Aranceles: TMensajeAranceles);
begin
  inherited Create(AOwner);
  FAranceles := Aranceles;
end;

procedure TPopupSeleccionarArancel.LabeledEdit1Change(Sender: TObject);
begin
  qry.Refresh;
end;

procedure TPopupSeleccionarArancel.FormCreate(Sender: TObject);
{var
  i: integer;    }
begin
  qry.Close;
  qry.Open;
  if FAranceles.Count = 0 then
    qry.First
  else if not qry.Locate('ID', FAranceles[0], [loCaseInsensitive]) then
    qry.First;
  {for i := 0 to FAranceles.Count - 1 do
  begin
    if not qry.Locate('ID', FAranceles[i], [loCaseInsensitive]) then
      Continue;
  end;}
end;

procedure TPopupSeleccionarArancel.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  i: integer;
begin
  //FAranceles.Add(qryID.AsString);
  {
  selected rows solo cuenta las filas que estan seleccionadas con CTRL
  las otras no
  por eso en el ELSE usamos la posicion actual del cursor en vez de la fila
  seleccionada (porque no hay ninguna seleccionada!)
  }
  FAranceles.Clear;
  if DBGrid1.SelectedRows.Count > 0 then
  begin
    with qry do
    begin
      for i := 0 to DBGrid1.SelectedRows.Count - 1 do
      begin
        GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
        FAranceles.Add(FieldByName('ID').AsString);
      end;
    end;
  end
  else
  begin
    with qry do
    begin
      FAranceles.Add(FieldByName('ID').AsString);
    end;
  end;
  inherited;
end;

procedure TPopupSeleccionarArancel.qryFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if Trim(LabeledEdit1.Text) = '' then
    Accept := True
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString,
      Trim(LabeledEdit1.Text)) or AnsiContainsText(
      DataSet.FieldByName('DESCRIPCION').AsString, Trim(LabeledEdit1.Text));
end;

end.
