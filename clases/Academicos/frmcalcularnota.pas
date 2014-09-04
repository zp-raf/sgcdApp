unit frmcalcularnota;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBGrids, DBCtrls, ExtCtrls, frmListaALumnos,
  sqldb, DB, frmsgcddatamodule, ShellApi;

type

  { TProcesoCalcularNota }

  TProcesoCalcularNota = class(TProcesoListaALumnos)
    notaPUNTAJE_FINAL: TFloatField;
    notaV_NOTA: TLongintField;
    qryNOTA: TLongintField;
    qrynotasFECHA_NOTA: TDateField;
    qrynotasID: TLongintField;
    qrynotasMATRICULAID: TLongintField;
    qrynotasNOTA: TLongintField;
    qrynotasOBSERVACIONES: TStringField;
    qrynotasPUNTAJE: TFloatField;
    qryPUNTAJE: TFloatField;
    nota: TSQLQuery;
    qrynotas: TSQLQuery;
    procedure CancelButtonClick(Sender: TObject); override;
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure TDBGridTitleClick(Column: TColumn); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoCalcularNota: TProcesoCalcularNota;

implementation

{$R *.lfm}

{ TProcesoCalcularNota }

procedure TProcesoCalcularNota.OKButtonClick(Sender: TObject);
var
  selectedRows, i: integer;
begin
  if DBGrid1.SelectedRows.Count > 0 then
    selectedRows := DBGrid1.SelectedRows.Count
  else
    selectedRows := 1;
  try
    qrynotas.Open;
    for i := 0 to selectedRows - 1 do
    begin
      if DBGrid1.SelectedRows.Count > 0 then
        DBGrid1.DataSource.DataSet.GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
      with nota do
      begin
        if Active then
          Close;
        ParamByName('ALUMNOID').AsInteger :=
          DBGrid1.DataSource.DataSet.FieldByName('ID').AsInteger;
        ParamByName('MATRICULAID').AsInteger :=
          DBGrid1.DataSource.DataSet.FieldByName('ID_MATRICULA').AsInteger;
        if not Active then
          Open;
        if notaV_NOTA.IsNull and notaPUNTAJE_FINAL.IsNull then
          Continue;
        if (not qrynotas.Locate('MATRICULAID',
          DBGrid1.DataSource.DataSet.FieldByName('ID_MATRICULA').Value,
          [loCaseInsensitive])) then
        begin
          //if not (qrynotas.State in [dsEdit, dsInsert]) then
            qrynotas.Append;
        end
        else
        begin
          if not (qrynotas.State in [dsEdit, dsInsert]) then
            qrynotas.Edit;
        end;
        qrynotasID.AsInteger := SGCDDataModule.SiguienteValor('GEN_NOTA');
        qrynotasFECHA_NOTA.AsDateTime := Now;
        qrynotasMATRICULAID.AsInteger :=
          DBGrid1.DataSource.DataSet.FieldByName('ID_MATRICULA').AsInteger;
        qrynotasOBSERVACIONES.AsString := '';
        qrynotasPUNTAJE.Value := notaPUNTAJE_FINAL.Value;
        qrynotasNOTA.Value := notaV_NOTA.Value;
      end;
    end;
    qrynotas.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      SGCDDataModule.sqlTran.Rollback;
      AbrirCursor;
    end;
  end;
end;

procedure TProcesoCalcularNota.TDBGridTitleClick(Column: TColumn);
begin
  inherited TDBGridTitleClick(Column);
end;

procedure TProcesoCalcularNota.CancelButtonClick(Sender: TObject);
begin
  try
    SGCDDataModule.sqlTran.Rollback;
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      AbrirCursor;
    end;
  end;
end;

procedure TProcesoCalcularNota.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
     ShellExecute(Handle, 'open', 'help\ABMs\calcularNota.html', nil, nil, 1);
end;

end.
