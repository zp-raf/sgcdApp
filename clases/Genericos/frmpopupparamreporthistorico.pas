unit frmpopupparamreporthistorico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LR_Class, LR_DBSet, Forms, Controls,
  Graphics, Dialogs, Menus, EditBtn, StdCtrls, DbCtrls, frmpopup, mensajes,
  frmbuscaralumnos, frmsgcddatamodule, PropertyStorage, strutils, LCLType,
  DBGrids, IBConnection;

type

  { TTPopUpParamReportHistorico }

  TTPopUpParamReportHistorico = class(TPopup)
    ds2: TDatasource;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    qry1ACUMULADO_CREDITO: TFloatField;
    qry1ACUMULADO_CREDITO1: TFloatField;
    qry1ACUMULADO_DEBITO: TFloatField;
    qry1ACUMULADO_DEBITO1: TFloatField;
    qry1DESCRIPCION1: TStringField;
    qry1DETALLE_ACUMULADO: TStringField;
    qry1DETALLE_ACUMULADO1: TFloatField;
    qry1FECHA1: TDateField;
    qry1MONTO1: TFloatField;
    qry1MONTO_CREDITO1: TFloatField;
    qry1MONTO_DEBITO1: TFloatField;
    qry1NOMBRE_ALUMNO: TStringField;
    qry1NOMBRE_ALUMNO1: TStringField;
    qry1SALDO_ACUMULADO: TFloatField;
    qry1SALDO_ACUMULADO1: TFloatField;
    qry1SALDO_LINEA1: TFloatField;
    qry1TIPO_MOV1: TStringField;
    qry1TOTAL_CREDITO1: TFloatField;
    qry1TOTAL_DEBITO1: TFloatField;
    qry1TOTAL_SALDO1: TFloatField;
    qry2: TSQLQuery;
    qry2NRO_DOC: TLongintField;
    qry2TIPO_DOC: TStringField;

  private
    { private declarations }
    FAlumnoID: integer;
    procedure SetAlumnoID(AValue: integer);
  published
    btSeleccionar: TButton;
    Button1: TButton;
    Button2: TButton;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBEdit12: TDBEdit;
    ds1: TDatasource;
    dsPersona: TDatasource;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    qry1: TSQLQuery;
    qryPersona: TSQLQuery;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    //constructor Create(AOwner: TComponent; var Impresion: TImpresion); overload;
    procedure btSeleccionarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AbrirCursor;
    property pAlumnoID: integer read FAlumnoID write SetAlumnoID;

  public
    { public declarations }
  end;

var
  TPopUpParamReportHistorico: TTPopUpParamReportHistorico;
//  FImpresion: TImpresion;
  f: TPopupSeleccionAlumnos;

implementation

{$R *.lfm}

{constructor TTPopUpParamReportHistorico.Create(AOwner: TComponent;
  var Impresion: TImpresion);
begin
  inherited Create(AOwner);
  FImpresion := Impresion;
end;}

procedure TTPopUpParamReportHistorico.SetAlumnoID(AValue: integer);
begin
  if FAlumnoID = AValue then
    Exit;
  FAlumnoID := AValue;
end;

procedure TTPopUpParamReportHistorico.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
//  FAlumno.alumno.ID := SQLQuery1ID.AsInteger;
  inherited;
end;

procedure TTPopUpParamReportHistorico.btSeleccionarClick(Sender: TObject);
begin
  try
    //creamos la ventana de seleccion
    try
      f := TPopupSeleccionAlumnos.Create(Self, FAlumno);
      if (f.ShowModal = mrOk) then
      begin
        if not qryPersona.Locate('ID', IntToStr(FAlumno.alumno.ID),
          [loCaseInsensitive]) then
          Exit;
      end
      else
      begin
        Exit;
      end;
    finally
          f.Free;
    end;
    pAlumnoID:= qryPersonaID.AsInteger;
    DBEdit12.Text:= qryPersonaNOMBRECOMPLETO.AsString;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TTPopUpParamReportHistorico.Button1Click(Sender: TObject);
begin
  // cierro los querys de donde obtengo los datasets de los reportes
  qry1.Close;
  qry2.Close;
  // le paso los parametros a los objetos qry
   qry1.Params.ParamByName('alumnoid').AsInteger := pAlumnoID;
   qry1.Params.ParamByName('fecha_fin').AsDate := DateEdit1.Date;
   qry2.Params.ParamByName('alumnoid').AsInteger := pAlumnoID;
   qry2.Params.ParamByName('fecha_ini').AsDate := DateEdit1.Date;
   qry2.Params.ParamByName('fecha_fin').AsDate := DateEdit2.Date;
   // abro
   qry1.Open;
   qry2.Open;
   // cargo el archivo de reporte
   frReport1.LoadFromFile('reportes\historico_saldos_2.lrf');
   frReport1.PrepareReport;
   frReport1.ShowReport;
end;

procedure TTPopUpParamReportHistorico.Button2Click(Sender: TObject);
begin
  Self.Close;
end;


procedure TTPopUpParamReportHistorico.FormCreate(Sender: TObject);
begin
     FAlumno := TMensajeAlumno.Create();
     AbrirCursor;
  //SQLQuery1.Open;
end;

procedure TTPopUpParamReportHistorico.AbrirCursor;
begin
  try
    qryPersona.Close;
    qry1.Close;
    qryPersona.Open;
    qry1.Open;
   except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;


end.

