unit frmcuentasxcobrar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, DBGrids, ExtCtrls, frmProceso, sqldb, db, strutils;

type

  { TProcesoCuentasAlumno }

  TProcesoCuentasAlumno = class(TProceso)
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    ARANCEL: TStringField;
    qryArancel: TSQLQuery;
    qryArancelDESCRIPCION: TStringField;
    qryArancelID: TLongintField;
    qryArancelMONTO: TFloatField;
    qryArancelNOMBRE: TStringField;
    qryPersona: TSQLQuery;
    qryPersonaAPELLIDO: TStringField;
    qryPersonaCEDULA: TStringField;
    qryPersonaESADMINISTRATIVO: TLongintField;
    qryPersonaESALUMNO: TLongintField;
    qryPersonaESCOORDINADOR: TLongintField;
    qryPersonaESENCARGADO: TLongintField;
    qryPersonaESINTERVENTOR: TLongintField;
    qryPersonaESPROFESOR: TLongintField;
    qryPersonaESPROVEEDOR: TLongintField;
    qryPersonaESVEEDOR: TLongintField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRE: TStringField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    SQLQuery1: TSQLQuery;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1ARANCELID: TLongintField;
    SQLQuery1CANTIDAD: TLongintField;
    SQLQuery1CANT_CUOTAS: TLongintField;
    SQLQuery1CUOTA_NRO: TLongintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1FECHA_DEUDA: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MATRICULAID: TLongintField;
    SQLQuery1MONTO_DEUDA: TFloatField;
    SQLQuery1MONTO_PAGADO: TFloatField;
    SQLQuery1PERSONAID: TLongintField;
    SQLQuery1SALDO: TFloatField;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure AbrirCursor;
    procedure FormCreate(Sender: TObject); override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure TDBGridTitleClick(Column: TColumn); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoCuentasAlumno: TProcesoCuentasAlumno;

implementation

{$R *.lfm}

{ TProcesoCuentasAlumno }

procedure TProcesoCuentasAlumno.AbrirCursor;
begin
  SQLQuery1.Close;
  qryArancel.Close;
  qryPersona.Close;
  SQLQuery1.Open;
  qryArancel.Open;
  qryPersona.Open;
end;

procedure TProcesoCuentasAlumno.FormCreate(Sender: TObject);
begin
  inherited;
  AbrirCursor
end;

procedure TProcesoCuentasAlumno.LabeledEdit1Change(Sender: TObject);
begin
  SQLQuery1.Refresh;
end;

procedure TProcesoCuentasAlumno.OKButtonClick(Sender: TObject);
begin
    //nada
end;

procedure TProcesoCuentasAlumno.SQLQuery1FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
   if Trim(LabeledEdit1.Text)='' then
   Accept:=True
   else
     Accept:=AnsiContainsText(DataSet.FieldByName('ARANCEL').AsString, LabeledEdit1.Text)
     or AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString, LabeledEdit1.Text)
     or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString, LabeledEdit1.Text);
end;

procedure TProcesoCuentasAlumno.TDBGridTitleClick(Column: TColumn);
begin
  inherited TDBGridTitleClick(Column);
end;

end.

