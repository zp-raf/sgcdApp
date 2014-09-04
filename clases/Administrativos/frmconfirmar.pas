unit frmConfirmar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  frmListaALumnos, ButtonPanel, DBGrids, DB, sqldb, frmsgcddatamodule, ShellApi;

type

  { TProcesoConfirmar }

  TProcesoConfirmar = class(TProcesoListaALumnos)
    procedure CancelButtonClick(Sender: TObject); override;
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure OKButtonClick(Sender: TObject); override;
    procedure MenuItemAyudaClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoConfirmar: TProcesoConfirmar;
  new: integer;

implementation

{$R *.lfm}

{ TProcesoConfirmar }

procedure TProcesoConfirmar.CancelButtonClick(Sender: TObject);
begin
  inherited CancelButtonClick(Sender);
end;


procedure TProcesoConfirmar.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
  ShellExecute(Handle, 'open', 'help\ABMs\confirmarAlumno.html', nil, nil, 1);
end;

procedure TProcesoConfirmar.DBGrid1TitleClick(Column: TColumn);
var
  selectedRows, i: integer;
begin
  if DBGrid1.SelectedRows.Count > 0 then
    selectedRows := DBGrid1.SelectedRows.Count
  else
    selectedRows := 1;
  if (Column.FieldName = 'ALUMNO_CONFIRMADO') or
    ((Column.FieldName = 'MATRICULA_CONFIRMADA') and
    (DBGrid1.DataSource.DataSet.Name = 'qry')) then
  begin
    case new of
      0: new := 1;
      1: new := 0;
    end;
    for i := 0 to selectedRows - 1 do
    begin
      if (DBGrid1.SelectedRows.Count > 0) then
        DBGrid1.DataSource.DataSet.GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
      if DBGrid1.DataSource.DataSet.FieldByName(Column.FieldName).AsString = '' then
        Continue;
      if not (DBGrid1.DataSource.DataSet.State in [dsEdit]) then
        DBGrid1.DataSource.DataSet.Edit;
      DBGrid1.DataSource.DataSet.FieldByName(Column.FieldName).AsInteger := new;
    end;
  end
  else
  begin
    TDBGridTitleClick(Column);
  end;
end;

procedure TProcesoConfirmar.OKButtonClick(Sender: TObject);
begin
  try
    TSQLQuery(DBGrid1.DataSource.DataSet).ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      AbrirCursor;
    end;
  end;
end;

end.
