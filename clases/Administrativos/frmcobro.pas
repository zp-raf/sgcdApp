unit frmcobro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBGrids, DBCtrls, PairSplitter, frmProceso,
  mensajes, frmseleccionarUnComprobante, frmsgcddatamodule;

const
  Credito = 1;
  Debito = 2;
  Factura = 1;
  Recibo = 2;
  NotaCredito = 3;
  Efectivo = 1;
  Cheque = 2;
  TarjetaDebito = 3;
  TarjetaCredito = 4;

  TipoMovimiento: array[Credito..Debito] of shortstring = (
    'Credito',
    'Debito');
  TipoComprobante: array[Factura..NotaCredito] of shortstring = (
    'Factura',
    'Recibo',
    'NotaCredito');
  TipoPago: array[Efectivo..TarjetaCredito] of shortstring = (
    'Efectivo',
    'Cheque',
    'TarjetaDebito',
    'TarjetaCredito');

type

  { TProcesoCobro }

  TProcesoCobro = class(TProceso)
    Button1: TButton;
    cdDetCh: TDatasource;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    dsDetTa: TDatasource;
    dsCabecera: TDatasource;
    DBEdit2: TDBEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    Detalles: TGroupBox;
    qryCabeceraCHEQUES: TFloatField;
    qryCabeceraEFECTIVO: TFloatField;
    qryCabeceraTARJETAS: TFloatField;
    qryCabeceraTOTALPAGADO: TFloatField;
    qryCabeceraVUELTO: TFloatField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryCabecera: TSQLQuery;
    qryCabeceraDESCRIPCION: TStringField;
    qryCabeceraFACTURAID: TLongintField;
    qryCabeceraFECHA: TDateField;
    qryCabeceraHORA: TTimeField;
    qryCabeceraID: TLongintField;
    qryCabeceraMONTO: TFloatField;
    qryCabeceraNOTA_CREDITOID: TLongintField;
    qryCabeceraRECIBOID: TLongintField;
    qryCabeceraTIPO_MOVIMIENTO: TLongintField;
    qryCabeceraVALIDO: TSmallintField;
    qryCodOBJETO: TStringField;
    qryCodSIGNIFICADO: TStringField;
    qryCodVALOR: TLongintField;
    qryDetCh: TSQLQuery;
    qryDetChEMISOR_CHEQUE: TStringField;
    qryDetChID: TLongintField;
    qryDetChMONTO: TFloatField;
    qryDetChNRO_CHEQUE: TStringField;
    qryDetChPAGOID: TLongintField;
    qryDetChTIPO_PAGO: TLongintField;
    qryDetTa: TSQLQuery;
    qryCod: TSQLQuery;
    qryDetTaCOMPROBANTE_TARJETA: TStringField;
    qryDetTaEMISOR_TARJETA: TStringField;
    qryDetTaID: TLongintField;
    qryDetTaMONTO: TFloatField;
    qryDetTaNRO_TARJETA: TStringField;
    qryDetTaPAGOID: TLongintField;
    qryDetTaTIPO_PAGO: TLongintField;
    StringField1: TStringField;
    Totales: TGroupBox;
    constructor Create(AOwner: TComponent; var Comprobante: TMensajeComprobante);
      overload;
    procedure ActualizarTotales;
    procedure AbrirCursor;
    procedure Button1Click(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject); override;
    procedure CrearPago;
    procedure DBEdit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure FormShow(Sender: TObject);
    procedure Limpiar;
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryCabeceraEFECTIVOChange(Sender: TField);
    procedure qryCabeceraNewRecord(DataSet: TDataSet);
    procedure qryCabeceraTOTALPAGADOChange(Sender: TField);
    procedure qryDetChAfterDelete(DataSet: TDataSet);
    procedure qryDetChAfterPost(DataSet: TDataSet);
    procedure qryDetChBeforePost(DataSet: TDataSet);
    procedure qryDetChFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryDetChNewRecord(DataSet: TDataSet);
    procedure qryDetTaAfterDelete(DataSet: TDataSet);
    procedure qryDetTaAfterPost(DataSet: TDataSet);
    procedure qryDetTaBeforePost(DataSet: TDataSet);
    procedure qryDetTaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryDetTaNewRecord(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoCobro: TProcesoCobro;
  f: TPopupSeleccionarUnComprobante;
  pid: integer;
  pdid: integer;
  FComprobante: TMensajeComprobante;
  AsPopUp: boolean = False;

implementation

{$R *.lfm}

{ TProcesoCobro }

constructor TProcesoCobro.Create(AOwner: TComponent;
  var Comprobante: TMensajeComprobante);
begin
  AsPopUp := True;
  FComprobante := Comprobante;
  inherited Create(AOwner);
end;

procedure TProcesoCobro.ActualizarTotales;
begin
  try
    //qryDetCh.Refresh;
    qryCabeceraCHEQUES.AsFloat := 0;
    qryDetCh.First;
    while not qryDetCh.EOF do
    begin
      qryCabeceraCHEQUES.AsFloat := qryCabeceraCHEQUES.AsFloat + qryDetChMONTO.AsFloat;
      qryDetCh.Next;
    end;
    //qryDetTa.Refresh;
    qryCabeceraTARJETAS.AsFloat := 0;
    qryDetTa.First;
    while not qryDetTa.EOF do
    begin
      qryCabeceraTARJETAS.AsFloat := qryCabeceraTARJETAS.AsFloat + qryDetTaMONTO.AsFloat;
      qryDetTa.Next;
    end;
    qryCabeceraTOTALPAGADO.AsFloat := 0;
    qryCabeceraTOTALPAGADO.AsFloat :=
      qryCabeceraEFECTIVO.AsFloat + qryCabeceraCHEQUES.AsFloat +
      qryCabeceraTARJETAS.AsFloat;
    if qryCabeceraTOTALPAGADO.AsFloat > qryCabeceraMONTO.AsFloat then
      qryCabeceraVUELTO.AsFloat :=
        qryCabeceraTOTALPAGADO.AsFloat - qryCabeceraMONTO.AsFloat
    else
      qryCabeceraVUELTO.AsFloat := 0;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
      AbrirCursor;
    end;
  end;
end;

procedure TProcesoCobro.AbrirCursor;
begin
  try
    qryCabecera.Close;
    qryCod.Close;
    qryDetCh.Close;
    qryDetTa.Close;
    qryCabecera.Open;
    qryCod.Open;
    qryDetCh.Open;
    qryDetTa.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.Button1Click(Sender: TObject);
begin
  try
    FComprobante := TMensajeComprobante.Create();
    f := TPopupSeleccionarUnComprobante.Create(Self, FComprobante);
    if not (f.ShowModal = mrOk) then
      Exit;
  finally
    f.Free;
  end;

  {
  if FComprobante.comprobante.Tipo = Factura then
    try
      FFactura := TMensajeFacturaUnica.Create;
      FFactura.factura.ID:=FComprobante.comprobante.ID;
      g := TProcesoRecibo.Create(Self, FFactura);
      g.CrearRecibo;
    finally
      g.Free;
    end;
    }
  CrearPago;
end;

procedure TProcesoCobro.CancelButtonClick(Sender: TObject);
begin
  try
    if AsPopUp then
      Close;
    Limpiar;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.CrearPago;
begin
  try
    //Limpiar;
    AbrirCursor;
    qryCabecera.Append;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.DBEdit1EditingDone(Sender: TObject);
begin
  ActualizarTotales;
end;

procedure TProcesoCobro.FormCreate(Sender: TObject);
begin
  inherited;
  if AsPopUp then
  begin
    Button1.Enabled := False;
    ButtonPanel1.OKButton.ModalResult := mrOk;
    ButtonPanel1.CancelButton.ModalResult := mrCancel;
    ButtonPanel1.CloseButton.ModalResult := mrClose;
    CrearPago;
  end;
end;

procedure TProcesoCobro.FormShow(Sender: TObject);
begin
  inherited;
  //AbrirCursor;
end;

procedure TProcesoCobro.Limpiar;
begin
  try
    qryCabecera.Cancel;
    qryDetCh.Cancel;
    qryDetTa.Cancel;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.OKButtonClick(Sender: TObject);
begin
  try
    //metemos el pago en efectivo
    {qrydetCh.Append;
    qryDetChMONTO.AsFloat:=qryCabeceraEFECTIVO.AsFloat;
    qryDetChTIPO_PAGO.AsInteger:=Efectivo; }

    qryCabecera.ApplyUpdates;
    qryDetCh.ApplyUpdates;
    qryDetTa.ApplyUpdates;

    //actualizamos los estados de deuda si no se crea el pago desde otra ventana
    if not AsPopUp then
    begin
      SGCDDataModule.sqlTran.Commit;
      SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
      SGCDDataModule.sqlTran.Commit;
      ShowMessage('OK');
    end;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
      AbrirCursor;
    end;
  end;
end;

procedure TProcesoCobro.qryCabeceraEFECTIVOChange(Sender: TField);
begin
  ActualizarTotales;
end;

procedure TProcesoCobro.qryCabeceraNewRecord(DataSet: TDataSet);
begin
  try
    pid := SGCDDataModule.SiguienteValor('generator_pago');
    DataSet.FieldByName('MONTO').AsFloat := FComprobante.comprobante.Total;
    DataSet.FieldByName('ID').AsInteger := pid;
    DataSet.FieldByName('FECHA').AsDateTime := Now;
    DataSet.FieldByName('HORA').AsDateTime := Now;
    DataSet.FieldByName('TIPO_MOVIMIENTO').AsInteger := Debito;
    if FComprobante.comprobante.Tipo = Recibo then
    begin
      DataSet.FieldByName('DESCRIPCION').AsString :=
        'Pago de recibo nro. ' + IntToStr(FComprobante.comprobante.ID);
      DataSet.FieldByName('RECIBOID').AsInteger := FComprobante.comprobante.ID;
    end
    else if FComprobante.comprobante.Tipo = Factura then
    begin
      DataSet.FieldByName('DESCRIPCION').AsString :=
        'Pago de factura nro. ' + IntToStr(FComprobante.comprobante.ID);
      DataSet.FieldByName('FACTURAID').AsInteger := FComprobante.comprobante.ID;
    end;
    DataSet.FieldByName('VALIDO').AsInteger := 1;
    DataSet.FieldByName('EFECTIVO').AsFloat := 0;
    DataSet.FieldByName('CHEQUES').AsFloat := 0;
    DataSet.FieldByName('TARJETAS').AsFloat := 0;
    DataSet.FieldByName('TOTALPAGADO').AsFloat := 0;
    DataSet.FieldByName('VUELTO').AsFloat := 0;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.qryCabeceraTOTALPAGADOChange(Sender: TField);
begin
  {if (qryCabeceraTOTALPAGADO.AsFloat > qryCabeceraMONTO.AsFloat) then
    MessageDlg('Advertencia', 'El total pagado es mayor a la deuda. Revise los datos.',
      mtWarning, [mbOK], 0);}
end;

procedure TProcesoCobro.qryDetChAfterDelete(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TProcesoCobro.qryDetChAfterPost(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TProcesoCobro.qryDetChBeforePost(DataSet: TDataSet);
begin
  if (Trim(DataSet.FieldByName('MONTO').AsString) = '') or
    (DataSet.FieldByName('MONTO').AsFloat <= 0) or
    (Trim(DataSet.FieldByName('NRO_CHEQUE').AsString) = '') or
    (Trim(DataSet.FieldByName('EMISOR_CHEQUE').AsString) = '') then
    DataSet.Cancel;
end;

procedure TProcesoCobro.qryDetChFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := (DataSet.FieldByName('TIPO_PAGO').AsInteger = Cheque) and
    (DataSet.FieldByName('PAGOID').AsInteger = pid);
end;

procedure TProcesoCobro.qryDetChNewRecord(DataSet: TDataSet);
begin
  try
    pdid := SGCDDataModule.SiguienteValor('GENERATOR_PAGO_DETALLE');
    DataSet.FieldByName('ID').AsInteger := pdid;
    DataSet.FieldByName('PAGOID').AsInteger := pid;
    DataSet.FieldByName('TIPO_PAGO').AsInteger := Cheque;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.qryDetTaAfterDelete(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TProcesoCobro.qryDetTaAfterPost(DataSet: TDataSet);
begin
  ActualizarTotales;
end;

procedure TProcesoCobro.qryDetTaBeforePost(DataSet: TDataSet);
begin
  if (Trim(DataSet.FieldByName('MONTO').AsString) = '') or
    (DataSet.FieldByName('MONTO').AsFloat <= 0) or
    (Trim(DataSet.FieldByName('NRO_TARJETA').AsString) = '') or
    (Trim(DataSet.FieldByName('TIPO_PAGO').AsString) = '') or
    (Trim(DataSet.FieldByName('EMISOR_TARJETA').AsString) = '') or
    (Trim(DataSet.FieldByName('COMPROBANTE_TARJETA').AsString) = '') then
    DataSet.Cancel;
end;

procedure TProcesoCobro.qryDetTaFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  try
    Accept := ((DataSet.FieldByName('TIPO_PAGO').AsInteger = TarjetaDebito) or
      (DataSet.FieldByName('TIPO_PAGO').AsInteger = TarjetaDebito)) and
      (DataSet.FieldByName('PAGOID').AsInteger = pid);
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoCobro.qryDetTaNewRecord(DataSet: TDataSet);
begin
  try
    pdid := SGCDDataModule.SiguienteValor('GENERATOR_PAGO_DETALLE');
    DataSet.FieldByName('ID').AsInteger := pdid;
    DataSet.FieldByName('PAGOID').AsInteger := pid;
    //DataSet.FieldByName('TIPO_PAGO').AsInteger := TarjetaCredito;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

end.
