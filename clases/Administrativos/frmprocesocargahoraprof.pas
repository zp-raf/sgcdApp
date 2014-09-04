unit frmprocesoCargaHoraProf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, LR_DBSet, LR_Class, Forms, Controls,
  Graphics, Dialogs, Menus, ButtonPanel, StdCtrls, DBGrids, DBCtrls, ShellCtrls,
  ExtCtrls, frmProceso, frmsgcddatamodule, ShellApi;

type

  { TprocesoCargaHoraProf }

  TprocesoCargaHoraProf = class(TProceso)
    Button1: TButton;
    Button2: TButton;
    btnReporte: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    dsCabecera: TDatasource;
    dsPersona: TDatasource;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    lblArchivoSeleccionado: TLabel;
    lblNombreArchivoSeleccionado: TLabel;
    OpenDialog1: TOpenDialog;
    qryCabecera: TSQLQuery;
    qryCabeceraFECHA: TDateField;
    qryCabeceraHORA: TTimeField;
    qryPersona: TSQLQuery;
    qryCabeceraANTIPASS: TLongintField;
    qryCabeceraDATETIME: TDateTimeField;
    qryCabeceraENMO: TLongintField;
    qryCabeceraGMNO: TLongintField;
    qryCabeceraID: TLongintField;
    qryCabeceraIN_OUT: TLongintField;
    qryCabeceraMODE: TLongintField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraTMNO: TLongintField;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    StringField1: TStringField;
    StringField2: TStringField;
    procedure btnReporteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure dsCabeceraDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);  override;
    procedure FormShow(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);

  published
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure AbrirCursor;
    procedure CancelButtonClick(Sender: TObject); override;
    procedure CondicionChange(Sender: TObject);
    procedure DBGrid1EditingDone(Sender: TObject);
    procedure ManejoErrores(E: EDatabaseError); override;
    procedure OKButtonClick(Sender: TObject); override;

  private
    { private declarations }
    SelectedFileName: TFilename;
    ultimaRuta: string;
  public
    { public declarations }
  end;

var
  procesoCargaHoraProf: TprocesoCargaHoraProf;

implementation

{$R *.lfm}

{ TprocesoCargaHoraProf }

procedure TprocesoCargaHoraProf.FormCreate(Sender: TObject);
begin
  //Inherited;
//  qryCabecera.SQL.Text := 'select * from asistencia3;';
 qryCabecera.SQL.Text := 'select * from asistencia2;';

   qryCabecera.InsertSQL.Text :=
     'insert into asistencia2 (id, numero, tmno, enmo, personaid, gmno, mode, in_out, antipass, datetime) '
     +
     'values (:id, :numero, :tmno, :enmo, :personaid, :gmno, :mode, :in_out, :antipass, :datetime);';


  AbrirCursor;
end;

procedure TprocesoCargaHoraProf.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TprocesoCargaHoraProf.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\registroAsistencia.html', nil, nil, 1);
end;


procedure TprocesoCargaHoraProf.AbrirCursor;
begin
  try
    qryCabecera.Close;
    qryPersona.Close;
    qryCabecera.Open;
    qryPersona.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TprocesoCargaHoraProf.dsCabeceraDataChange(Sender: TObject; Field: TField);
begin

end;

procedure TprocesoCargaHoraProf.Button1Click(Sender: TObject);
var
  Archivo, Linea: TStringList;
  i: integer;
  Fmt: TFormatSettings;
  error: integer;
  // SelectedFileName: TFilename; quito de aca porque decalro como private
begin
  Archivo := TStringList.Create;
  Linea := TStringList.Create;
  Archivo.LoadFromFile(SelectedFileName);
  for i := 1 to Archivo.Count - 1 do
  begin
    error := 0;
    fmt.ShortDateFormat := 'yyyy/mm/dd';
    fmt.DateSeparator := '/';
    fmt.LongTimeFormat := 'hh:mm:ss';
    fmt.TimeSeparator := ':';
    Linea.CommaText := Archivo[i];

    try
      AbrirCursor;
      if not (qryCabecera.State in [dsEdit, dsInsert]) then
        qryCabecera.Edit;

      qryCabecera.Append;
      qryCabeceraID.AsInteger :=
        SGCDDataModule.SiguienteValor('GENERATOR_ASISTENCIA');
      if not SameText((Linea[0]), '') then
        qryCabeceraNUMERO.AsInteger := StrToInt(Linea[0]);
      if not SameText((Linea[1]), '') then
        qryCabeceraTMNO.AsInteger := StrToInt(Linea[1]);
      if not SameText((Linea[2]), '') then
        qryCabeceraENMO.AsInteger := StrToInt(Linea[2]);
      if not SameText((Linea[3]), '') then
        qryCabeceraPERSONAID.AsInteger := StrToInt(Linea[3]);
      if not SameText((Linea[4]), '') then
        qryCabeceraGMNO.AsInteger := StrToInt(Linea[4]);
      if not SameText((Linea[5]), '') then
        qryCabeceraMODE.AsInteger := StrToInt(Linea[5]);
      if not SameText((Linea[6]), '') then
        qryCabeceraIN_OUT.AsInteger := StrToInt(Linea[6]);
      if not ((SameText((Linea[7]), '')) and not
        (SameText(Linea[8], ''))) then
        begin
          qryCabeceraDATETIME.AsDateTime :=
          StrToDateTime((Linea[7] + ' ' + Linea[8]), Fmt);

          qryCabeceraFECHA.AsDateTime:= StrToDateTime(Linea [7], Fmt);
          qryCabeceraHORA.AsDateTime:= StrToTime(Linea [8]);
        end;
      qryCabecera.ApplyUpdates;

    except
      on e: EConvertError do
      begin
        MessageDlg('Error',
          'Verifique nuevamente la fecha de su archivo, la misma ' +
          'debe ser de la forma YYYY/MM/DD HH:MM:SS o que los valores '+
          'del archivo adjunto esten correctamente cargados.',
          mtError, [mbOK], 0);
        SGCDDataModule.sqlTran.Rollback;
        error := 1;
        // si error = 1 no quiero que se comitee nada luego, ver mas abajo xD, no estoy seguro si llega luego a ese punto por el exit
        exit;
      end;
    end;
  end;
  if (error <> 1) then
  begin
    SGCDDataModule.sqlTran.Commit;
    AbrirCursor;
  end;
end;

procedure TprocesoCargaHoraProf.btnReporteClick(Sender: TObject);
begin
     frReport1.LoadFromFile('reportes\registro_asistencia1.lrf');
     frReport1.PrepareReport;
     frReport1.ShowReport;
end;

procedure TprocesoCargaHoraProf.Button2Click(Sender: TObject);
var
  i: integer;
begin
  if SameText(ultimaRuta, '') then
    OpenDialog1.InitialDir := GetCurrentDir
  else
    OpenDialog1.InitialDir := ultimaRuta;
  if not OpenDialog1.Execute then
    ShowMessage('Se canceló la carga del archivo')
  else
  begin
    for i := 0 to OpenDialog1.Files.Count - 1 do
    begin
//      ShowMessage(opendialog1.Files[i]); al pedo, si muestro luego en un label
      SelectedFileName := OpenDialog1.Files[i];
      lblNombreArchivoSeleccionado.Caption := SelectedFileName;
      Button1.Enabled:= True;
      ultimaRuta := ExtractFileDir(SelectedFileName);
    end;
  end;
end;

procedure TprocesoCargaHoraProf.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  //  XMLPropStorage1.Save;
  inherited;
end;

procedure TprocesoCargaHoraProf.CancelButtonClick(Sender: TObject);
begin
  SGCDDataModule.sqlTran.Rollback;
  AbrirCursor;
  //  Self.Close;
  //  ButtonLimpiarClick(Self);
end;

procedure TprocesoCargaHoraProf.CondicionChange(Sender: TObject);
begin

end;

procedure TprocesoCargaHoraProf.DBGrid1EditingDone(Sender: TObject);
begin

end;



procedure TprocesoCargaHoraProf.ManejoErrores(E: EDatabaseError);
begin
  inherited ManejoErrores(E);
end;

procedure TprocesoCargaHoraProf.OKButtonClick(Sender: TObject);
begin
  try
    qryCabecera.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    ShowMessage('Cambios guardados');
    AbrirCursor;
    //ButtonLimpiarClick(Self);
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
      SGCDDataModule.sqlTran.Rollback;
      AbrirCursor;
      //ButtonLimpiarClick(Self);
    end;
  end;
end;

end.
