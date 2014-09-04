unit frmparampopupreportasistencia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, Menus, StdCtrls, EditBtn, DbCtrls, frmpopup,
  mensajes, frmbuscaralumnos, frmsgcddatamodule, PropertyStorage, strutils, LCLType,
 DBGrids, IBConnection;


type

  { TPopUpParamReportAsistencia }

  TPopUpParamReportAsistencia = class(TPopup)
    btSeleccionar1: TButton;
    qry1FECHA_ASISTENCIA: TDateField;
    qry1HORAS_SUM: TSmallintField;
    qry1HORAS_SUM_CH: TStringField;
    qry1HORAS_SUM_EMP_CH: TStringField;
    qry1HORAS_TRABAJADAS: TTimeField;
    qry1HORA_ENTRADA: TTimeField;
    qry1HORA_SALIDA: TTimeField;
    qry1MINUTOS_SUM: TSmallintField;
    qry1MINUTOS_SUM_CH: TStringField;
    qry1MINUTOS_SUM_EMP_CH: TStringField;
    qry1NOMBRE: TStringField;
    qry1SEGUNDOS_SUM: TSmallintField;
    qry1SEGUNDOS_SUM_CH: TStringField;
    qry1SEGUNDOS_SUM_EMP_CH: TStringField;
    qry1TOTAL_HORAS: TFloatField;
    qry1TOTAL_HORAS_EMP: TFloatField;
    qry1TOTAL_HORAS_TRABAJADAS: TTimeField;
    procedure btSeleccionar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBEdit12: TDBEdit;
    ds1: TDatasource;
    dsPersona: TDatasource;
    frDBDataSet1: TfrDBDataSet;
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
    procedure btSeleccionarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AbrirCursor;
    property pAlumnoID: integer read FAlumnoID write SetAlumnoID;

  end;

var
  PopUpParamReportAsistencia: TPopUpParamReportAsistencia;
  f: TPopupSeleccionAlumnos;

implementation

{$R *.lfm}

procedure TPopUpParamReportAsistencia.btSeleccionar1Click(Sender: TObject);
begin
   pAlumnoID := -1;
   DBEdit12.Text:= 'Todos';
end;


procedure TPopUpParamReportAsistencia.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TPopUpParamReportAsistencia.SetAlumnoID(AValue: integer);
begin
  if FAlumnoID = AValue then
    Exit;
  FAlumnoID := AValue;
end;

procedure TPopUpParamReportAsistencia.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
//  FAlumno.alumno.ID := SQLQuery1ID.AsInteger;
  inherited;
end;

procedure TPopUpParamReportAsistencia.btSeleccionarClick(Sender: TObject);
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

procedure TPopUpParamReportAsistencia.Button1Click(Sender: TObject);
begin
  // cierro los querys de donde obtengo los datasets de los reportes
  qry1.Close;
  // le paso los parametros a los objetos qry
   qry1.Params.ParamByName('personaid').AsInteger := pAlumnoID;
   qry1.Params.ParamByName('fecha_ini').AsDate := DateEdit1.Date;
   qry1.Params.ParamByName('fecha_fin').AsDate := DateEdit2.Date;
   // abro
   qry1.Open;
   // cargo el archivo de reporte
   frReport1.LoadFromFile('reportes\registro_asistencia2.lrf');
   frReport1.PrepareReport;
   frReport1.ShowReport;
end;

procedure TPopUpParamReportAsistencia.Button2Click(Sender: TObject);
begin
  Self.Close;
end;


procedure TPopUpParamReportAsistencia.FormCreate(Sender: TObject);
begin
     FAlumno := TMensajeAlumno.Create();
     AbrirCursor;
  //SQLQuery1.Open;
end;

procedure TPopUpParamReportAsistencia.AbrirCursor;
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

