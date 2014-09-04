unit frmparampopupcertifestudio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LR_Class, LR_DBSet, Forms, Controls,
  Graphics, Dialogs, Menus, EditBtn, StdCtrls, DbCtrls, frmpopup, mensajes,
  frmbuscaralumnos, frmsgcddatamodule, PropertyStorage, strutils, LCLType,
  DBGrids, IBConnection;

type

  { TPopUpParamReportCertif }

  TPopUpParamReportCertif = class(TPopup)
    frDBDataSet1: TfrDBDataSet;
    qry1DURACION_MATERIA: TStringField;
    qry1FECHAFIN: TDateField;
    qry1FECHAINICIO: TDateField;
    qry1FECHANAC: TDateField;
    qry1GRUPO: TStringField;
    qry1MATERIA: TStringField;
    qry1MODULO: TStringField;
    qry1NOMBRECOMPLETO: TStringField;
    qry1NOTA: TLongintField;
    qry1OBSERVACIONES: TStringField;
    qry1PERIODO_LECTIVO: TStringField;
  private
    { private declarations }
    FAlumnoID: integer;
    procedure SetAlumnoID(AValue: integer);
  public
    { public declarations }

  published
    btSeleccionar: TButton;
    Button1: TButton;
    Button2: TButton;
    DBEdit12: TDBEdit;
    ds1: TDatasource;
    ds2: TDatasource;
    dsPersona: TDatasource;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    qry1: TSQLQuery;
    qry1ACUMULADO_CREDITO1: TFloatField;
    qry1ACUMULADO_DEBITO1: TFloatField;
    qry1DESCRIPCION1: TStringField;
    qry1DETALLE_ACUMULADO1: TFloatField;
    qry1FECHA1: TDateField;
    qry1MONTO1: TFloatField;
    qry1MONTO_CREDITO1: TFloatField;
    qry1MONTO_DEBITO1: TFloatField;
    qry1NOMBRE_ALUMNO1: TStringField;
    qry1SALDO_ACUMULADO1: TFloatField;
    qry1SALDO_LINEA1: TFloatField;
    qry1TIPO_MOV1: TStringField;
    qry1TOTAL_CREDITO1: TFloatField;
    qry1TOTAL_DEBITO1: TFloatField;
    qry1TOTAL_SALDO1: TFloatField;
    qry2: TSQLQuery;
    qry2NRO_DOC: TLongintField;
    qry2TIPO_DOC: TStringField;
    qryPersona: TSQLQuery;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    procedure FormShow(Sender: TObject);
    procedure btSeleccionarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AbrirCursor;
    property pAlumnoID: integer read FAlumnoID write SetAlumnoID;

  end;

var
  PopUpParamReportCertif: TPopUpParamReportCertif;
  f: TPopupSeleccionAlumnos;

implementation

{$R *.lfm}

procedure TPopUpParamReportCertif.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TPopUpParamReportCertif.SetAlumnoID(AValue: integer);
begin
  if FAlumnoID = AValue then
    Exit;
  FAlumnoID := AValue;
end;

procedure TPopUpParamReportCertif.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
//  FAlumno.alumno.ID := SQLQuery1ID.AsInteger;
  inherited;
end;

procedure TPopUpParamReportCertif.btSeleccionarClick(Sender: TObject);
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

procedure TPopUpParamReportCertif.Button1Click(Sender: TObject);
begin
  // cierro los querys de donde obtengo los datasets de los reportes
  qry1.Close;
  // le paso los parametros a los objetos qry
   qry1.Params.ParamByName('personaid').AsInteger := pAlumnoID;
   // abro
   qry1.Open;
   // cargo el archivo de reporte
   frReport1.LoadFromFile('reportes\certif_estudios.lrf');
   frReport1.PrepareReport;
   frReport1.ShowReport;
end;

procedure TPopUpParamReportCertif.Button2Click(Sender: TObject);
begin
  Self.Close;
end;


procedure TPopUpParamReportCertif.FormCreate(Sender: TObject);
begin
     FAlumno := TMensajeAlumno.Create();
     AbrirCursor;
  //SQLQuery1.Open;
end;

procedure TPopUpParamReportCertif.AbrirCursor;
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

