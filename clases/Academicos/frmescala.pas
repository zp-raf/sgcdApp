unit frmescala;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, DBGrids, DBCtrls, frmProceso, sqldb, DB, frmsgcddatamodule,ShellApi;

type

  { TProcesoEscala }

  TProcesoEscala = class(TProceso)
    ds: TDatasource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    qry: TSQLQuery;
    qryID: TLongintField;
    qryLIMITEINF: TFloatField;
    qryLIMITESUP: TFloatField;
    qryNOTA: TLongintField;
    qryVALIDO: TSmallintField;
    procedure AbrirCursor;
    procedure CancelButtonClick(Sender: TObject); override;
    procedure FormCreate(Sender: TObject); override;
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryNewRecord(DataSet: TDataSet);
    procedure qryPostError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoEscala: TProcesoEscala;

implementation

{$R *.lfm}

{ TProcesoEscala }

procedure TProcesoEscala.OKButtonClick(Sender: TObject);
begin
  try
    qry.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      FormCreate(Self);
    end;
  end;
end;

procedure TProcesoEscala.qryNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').Value := SGCDDataModule.SiguienteValor('GEN_ESCALA');
  DataSet.FieldByName('VALIDO').Value:= 1;//por defecto activo
end;

procedure TProcesoEscala.qryPostError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
  ManejoErrores(E);
  FormCreate(Self);
end;

procedure TProcesoEscala.AbrirCursor;
begin
  try
    qry.Close;
    qry.Open;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      FormCreate(Self);
    end;
  end;
end;

procedure TProcesoEscala.CancelButtonClick(Sender: TObject);
begin
  try
    if (qry.State in [dsInsert, dsEdit]) then
      qry.CancelUpdates;
    qry.Close;
    SGCDDataModule.sqlTran.Rollback;
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      FormCreate(Self);
    end;
  end;
end;

procedure TProcesoEscala.FormCreate(Sender: TObject);
begin
  inherited;
  AbrirCursor;
end;

procedure TProcesoEscala.MenuItemAyudaClick(Sender: TObject);
begin
 // inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\escala.html', nil, nil, 1);
end;

end.

