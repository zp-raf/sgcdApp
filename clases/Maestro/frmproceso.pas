unit frmProceso;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, frmMaestro, DB, strutils, frmsgcddatamodule,
  LCLType, DBGrids, sqldb, ShellApi;

type

  { TProceso }

  TProceso = class(TMaestro)
    ButtonPanel1: TButtonPanel;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception); override;
    procedure ButtonPanel1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure CancelButtonClick(Sender: TObject); virtual;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); virtual;
    procedure HelpButtonClick(Sender: TObject); virtual;
    procedure OKButtonClick(Sender: TObject); virtual abstract;
    procedure TDBGridTitleClick(Column: TColumn); virtual;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Proceso: TProceso;

implementation

{$R *.lfm}

{ TProceso }

procedure TProceso.ApplicationProperties1Exception(Sender: TObject; E: Exception);
begin
  inherited ApplicationProperties1Exception(Sender, E);
  FormCreate(Self);
end;

procedure TProceso.ButtonPanel1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    Abort;
end;

procedure TProceso.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TProceso.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TProceso.FormCreate(Sender: TObject);
begin

end;

procedure TProceso.HelpButtonClick(Sender: TObject);
begin

end;

procedure TProceso.TDBGridTitleClick(Column: TColumn);
var
  i: integer;
begin
  // apply grid formatting changes here e.g. title styling
  if TDBGrid(Column.Grid).DataSource = nil then
    Exit;
  with TDBGrid(Column.Grid) do
  begin
    for i := 0 to Columns.Count - 1 do
      Columns[i].Title.Font.Style := Columns[i].Title.Font.Style - [fsBold];
    Column.Title.Font.Style := Column.Title.Font.Style + [fsBold];
    with TSQLQuery(DataSource.DataSet) do
    begin
      DisableControls;
      if Active then
        Close;
      IndexFieldNames := Column.FieldName;
      if not Active then
        Open;
      try
        First;
        while not EOF do
        begin
          Next;
        end;
      finally
        EnableControls;
      end;
    end;
  end;
end;

end.
