unit frmhistorico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, Forms, Controls, Graphics,
  Dialogs, Menus, ButtonPanel, DbCtrls, DBGrids, ExtCtrls, StdCtrls, frmProceso,
  sqldb, db, frmsgcddatamodule, frmpopupparamreporthistorico, mensajes, ComCtrls, ShellApi;


type

  { TProcesoHistorico }

  TProcesoHistorico = class(TProceso)
    Button1: TButton;
    ds: TDatasource;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    qry: TSQLQuery;
    qryDESCRIPCION: TStringField;
    qryFECHA: TDateField;
    qryHORA: TTimeField;
    qryMONTO: TFloatField;
    qryNOMBRE_COMPROBANTE: TStringField;
    qryNOMBRE_PERSONA: TStringField;
    qryNUMERO_COMPROBANTE: TLongintField;
    qryPERSONAID: TLongintField;
    qryRUC: TStringField;
    qryTIMBRADO: TStringField;
    qryTIPO_COMPROBANTE: TStringField;
    qryTIPO_MOVIMIENTO: TStringField;
    qryTIPO_OPERACION: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure LabeledEdit1Change(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure TDBGridTitleClick(Column: TColumn); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoHistorico: TProcesoHistorico;
  f: TTPopUpParamReportHistorico;

implementation

{$R *.lfm}

{ TProcesoHistorico }

procedure TProcesoHistorico.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TProcesoHistorico.qryFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

procedure TProcesoHistorico.TDBGridTitleClick(Column: TColumn);
begin
  inherited TDBGridTitleClick(Column);
end;

procedure TProcesoHistorico.LabeledEdit1Change(Sender: TObject);
begin
  qry.Refresh;
end;

procedure TProcesoHistorico.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\historico-movimiento.html', nil, nil, 1);
end;

procedure TProcesoHistorico.FormCreate(Sender: TObject);
begin
//   Impresion : TPopUpParamReportHistorico.Create();
 // FImpresion := TImpresion.Create();
  qry.Close;
  qry.Open;
end;

procedure TProcesoHistorico.Button1Click(Sender: TObject);
var
  Fmt : TFormatSettings;
begin
      //mostrar reporte

{
 fmt.ShortDateFormat:='mm/dd/yyyy';
 fmt.DateSeparator:= '/';
 fmt.LongTimeFormat:='hh:mm:ss';
 fmt.TimeSeparator:= ':';
   qry1.Params.ParamByName('alumnoid').AsInteger:= 11;
   qry1.Params.ParamByName('fecha_ini').AsDate := StrToDate('01/07/2014'); ;
   qry1.Params.ParamByName('fecha_fin').AsDate := StrToDate('31/07/2014');
   frReport1.LoadFromFile('reportes\historico_saldos.lrf');
   frReport1.ShowReport;
}

/// Abro la ventana para los parametros del reporte
    try
    //creamos la ventana de seleccion
    try
       TTPopUpParamReportHistorico.Create(Self).Show;
 {     if (f.ShowModal = mrOk) then
      begin
        {
         if not qryPersona.Locate('ID', IntToStr(FAlumno.alumno.ID),
           [loCaseInsensitive]) then
           Exit;
        }
      end
      else
      begin
        Exit;
      end;}
    finally
      f.Free;
    end;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;


end;

end.

