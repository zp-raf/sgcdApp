unit frmprocesorecibocompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, PairSplitter, StdCtrls, DBGrids, DBCtrls, EditBtn,
  XMLPropStorage, frmProceso, frmbuscartalonariorec, frmseleccionarUnaFactura,
  frmbuscaralumnos, mensajes, frmsgcddatamodule, LCLType, strutils, frmcobro, ShellApi;

type

  { TProcesoReciboCompra }

  TProcesoReciboCompra = class(TProceso)
    DBEdit2: TDBEdit;
    DBEdit4: TDBEdit;
    Numero: TLabel;
    Timbrado: TLabel;
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFACTURACOMPRAID: TLongintField;
    qryCabeceraFECHA_EMISION: TDateField;
    qryCabeceraID: TLongintField;
    qryCabeceraNOMBRE: TStringField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTIMBRADO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleFACTURACOMPID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryDetalleRECIBOCOMPID: TLongintField;
    qryDetalleTOTAL: TFloatField;

    qryDeudaCANT: TLongintField;
    qryDeudaDETALLE: TStringField;
    qryDeudaDEUDAID: TLongintField;
    qryDeudaEXENTA: TFloatField;
    qryDeudaIVA10: TFloatField;
    qryDeudaIVA5: TFloatField;
    qryDeudaPERSONAID: TLongintField;
    qryDeudaPRECIO_UNITARIO: TFloatField;
    qryFacCONTADO: TSmallintField;
    qryFacDIRECCION: TStringField;
    qryFacFECHA_EMISION: TDateField;
    qryFacID: TLongintField;
    qryFacIVA10: TFloatField;
    qryFacIVA5: TFloatField;
    qryFacIVA_TOTAL: TFloatField;
    qryFacNOMBRE: TStringField;
    qryFacNOTA_REMISION: TStringField;
    qryFacNUMERO: TLongintField;
    qryFacPERSONAID: TLongintField;
    qryFacRUC: TStringField;
    qryFacSUBTOTAL_EXENTAS: TFloatField;
    qryFacSUBTOTAL_IVA10: TFloatField;
    qryFacSUBTOTAL_IVA5: TFloatField;
    qryFacTALONARIOID: TLongintField;
    qryFacTELEFONO: TStringField;
    qryFacTIMBRADO: TStringField;
    qryFacTOTAL: TFloatField;
    qryFacVENCIMIENTO: TDateField;
    qryPersonaAPELLIDO: TStringField;
    qryPersonaCEDULA: TStringField;
    qryPersonaESENCARGADO: TSmallintField;
    qryPersonaESINTERVENTOR: TSmallintField;
    qryPersonaESVEEDOR: TSmallintField;
    qryPersonaFECHANAC: TDateField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRE: TStringField;
    qryPersonaNOMBRE_COMPLETO: TStringField;
    qryPersonaSEXO: TStringField;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure SeleccionarClick(Sender: TObject);
    procedure SeleccionarFacturaClick(Sender: TObject);
  private

    FpReciboID: integer;
    FpTalonarioID: integer;
    procedure SetpReciboID(AValue: integer);
    procedure SetpTalonarioID(AValue: integer);
  published
    ButtonLimpiar: TButton;
    Cabecera: TGroupBox;
    DateEdit1: TDateEdit;
    DBEdit1: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit6: TDBEdit;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Detalles: TGroupBox;
    dsCabecera: TDatasource;
    dsDetalle: TDatasource;
    dsDeuda: TDatasource;
    dsPersona: TDatasource;
    Grantotal: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryCabecera: TSQLQuery;
    qryDetalle: TSQLQuery;
    qryDeuda: TSQLQuery;
    qryFac: TSQLQuery;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    qryPersona: TSQLQuery;
    Seleccionar: TButton;
    SeleccionarFactura: TButton;
    Totales: TGroupBox;
    XMLPropStorage1: TXMLPropStorage;
    constructor Create(AOwner: TComponent; var Factura: TMensajeFacturaUnica); overload;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SeleccionarFacturasClick(Sender: TObject);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
    procedure AbrirCursor;
    procedure ActualizarTotal;
    procedure CargarRecibo;
    procedure CrearRecibo;
    procedure btSeleccionarClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject); override;
    procedure FormCreate(Sender: TObject); override;
    procedure Guardar;
    procedure ManejoErrores(E: EDatabaseError); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryDetalleFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryDetalleNewRecord(DataSet: TDataSet);
    procedure qryDeudaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure talonarioClick(Sender: TObject);
    property pTalonarioID: integer read FpTalonarioID write SetpTalonarioID;
    property pReciboID: integer read FpReciboID write SetpReciboID;
  end;

var
  ProcesoReciboCompra: TProcesoReciboCompra;
  f: TPopupSeleccionAlumnos;
  g: TPopupBuscarTalonarioRec;
  h: TPopupSeleccionarUnaFactura;
  FTalonario: TMensajeTalonario;
  FFactura: TMensajeFacturaUnica;
  FComprobante: TMensajeComprobante;
  hola: TProcesoCobro;

implementation

constructor TProcesoReciboCompra.Create(AOwner: TComponent;
  var Factura: TMensajeFacturaUnica);
begin
  FFactura := Factura;
  inherited Create(AOwner);
  XMLPropStorage1.Restore;
end;

{
****************************
FILTROS Y EVENTOS DE DATASET
****************************
}
procedure TProcesoReciboCompra.AbrirCursor;
begin
  try
    qryPersona.Close;
    qryCabecera.Close;
    qryDetalle.Close;
    //qryNumero.Close;
    qryDeuda.Close;
    qryFac.Close;
    qryPersona.Open;
    qryCabecera.Open;
    qryDetalle.Open;
    //qryNumero.Open;
    qryDeuda.Open;
    qryFac.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoReciboCompra.qryDetalleFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('RECIBOCOMPID').AsInteger = pReciboID;
end;

//aca manejamos el autoincremento del dataset
procedure TProcesoReciboCompra.qryDetalleNewRecord(DataSet: TDataSet);
begin
  qryDetalleID.AsInteger := SGCDDataModule.SiguienteValor('seq_recibo_detalle');
  qryDetalleRECIBOCOMPID.AsInteger := pReciboID;
  qryDetalleDETALLE.AsString := '';
  qryDetalleCANTIDAD.AsInteger := 0;
end;

procedure TProcesoReciboCompra.qryDeudaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = qryPersonaID.AsInteger;
end;

{
*******************************
ACCIONES DE BOTONES Y MENUS
*******************************
}

procedure TProcesoReciboCompra.SeleccionarFacturasClick(Sender: TObject);
begin
  try
    h := TPopupSeleccionarUnaFactura.Create(Self, FFactura);
    if (h.ShowModal = mrOk) then
    begin
      try
        ButtonLimpiarClick(Self);
        DateEdit1.Clear;
      except
        on e: EDatabaseError do
        begin
          ManejoErrores(e);
        end;
      end;
    end
    else
      Exit;
  finally
    h.Free;
  end;
  if DateEdit1.Text = '' then
  begin
    DateEdit1.Date := Now;
  end;
  CargarRecibo;
  DBGrid1.AutoSizeColumns;
  DBGrid1.SetFocus;
end;

//para seleccionar el talonario a usar
procedure TProcesoReciboCompra.talonarioClick(Sender: TObject);
begin
  //creamos la ventana de seleccion
  try
    FTalonario.talonario.ID := pTalonarioID;
    g := TPopupBuscarTalonarioRec.Create(Self, FTalonario);
    if (g.ShowModal = mrOk) then
    begin
      pTalonarioID := FTalonario.talonario.ID;
      {por si se entro en condicion de error de talonario no existente
      entonces volvemos a habilitar los campos}
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      ButtonLimpiarClick(Self);
      Exit;
    end
    else
    begin
      Exit;
    end;
  finally
    g.Free;
  end;
end;

procedure TProcesoReciboCompra.ActualizarTotal;
begin
  if not (qryCabecera.State in [dsEdit, dsInsert]) then
    qryCabecera.Edit;
  qryCabeceraTOTAL.AsFloat := 0.0;
  if not qryDetalle.IsEmpty then
  begin
    qryDetalle.First;
    while not qryDetalle.EOF do
    begin
      qryCabeceraTOTAL.AsFloat :=
        qryCabeceraTOTAL.AsFloat + qryDetalleTOTAL.AsFloat;
      qryDetalle.Next;
    end;
  end;
end;

procedure TProcesoReciboCompra.CargarRecibo;
begin
  try
    if not qryFac.Locate('ID', IntToStr(FFactura.factura.ID),
      [loCaseInsensitive]) then
      Exit;
    qryCabeceraFECHA_EMISION.AsDateTime := Now;
    qryCabeceraPERSONAID.AsInteger := qryDeudaPERSONAID.AsInteger;
    qryCabeceraNOMBRE.AsString := qryFacNOMBRE.AsString;

    //cargamos detalles
    qryDetalle.Append;
    qryDetalleCANTIDAD.AsInteger := 1;
    qryDetalleDETALLE.AsString :=
      'Pago de factura nro. ' + qryFacNUMERO.AsString + ' emitida en fecha ' +
      qryFacFECHA_EMISION.AsString;
    qryDetallePRECIO_UNITARIO.AsFloat := qryFacTOTAL.AsFloat;
    qryDetalleTOTAL.AsFloat :=
      qryDetalleCANTIDAD.AsFloat * qryDetallePRECIO_UNITARIO.AsFloat;
    DBGrid1.AutoSizeColumns;
    ActualizarTotal;
    DBGrid1.SetFocus;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoReciboCompra.CrearRecibo;
begin
  ButtonLimpiarClick(Self);
  CargarRecibo;
  Guardar;
end;

procedure TProcesoReciboCompra.btSeleccionarClick(Sender: TObject);
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
        //aplicamos los cambios a la cabecera
    qryCabeceraFECHA_EMISION.AsDateTime := Now;
    qryCabeceraPERSONAID.AsInteger := FAlumno.alumno.ID;
    qryCabeceraNOMBRE.AsString := qryPersonaNOMBRE_COMPLETO.AsString;
        if DateEdit1.Text = '' then
    begin
      DateEdit1.Date := Now;
    end;
    { //filtramos la deuda para sacar solo la del alumno seleccionado
    qryDeuda.Close;
    qryDeuda.Open;


    //aplicamos los cambios a la cabecera
    qryCabeceraFECHA_EMISION.AsDateTime := Now;
    qryCabeceraPERSONAID.AsInteger := qryDeudaPERSONAID.AsInteger;
    qryCabeceraNOMBRE.AsString := qryPersonaNOMBRE_COMPLETO.AsString;
    ActualizarTotal;

    //recorremos el dataset y vamos cargando en la factura
    qryDeuda.First;
    while not qryDeuda.EOF do
    begin
      qryDetalle.Append;
      qryDetalleCANTIDAD.AsInteger := qryDeudaCANT.AsInteger;
      qryDetalleDETALLE.AsString := qryDeudaDETALLE.AsString;
      qryDetallePRECIO_UNITARIO.AsFloat := qryDeudaPRECIO_UNITARIO.AsFloat;
      qryDetalleTOTAL.AsFloat := qryDeudaEXENTA.AsFloat;
      qryDetalleFACTURACOMPID.AsInteger := qryFacID.AsInteger;
      qryDeuda.Next;
    end; }
    ActualizarTotal;
    DBGrid1.AutoSizeColumns;
    DBGrid1.SetFocus;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoReciboCompra.ButtonLimpiarClick(Sender: TObject);
begin
  try
    //traemos el siguiente numero de factura disponible del talonario
    //qryNumero.Params[0].AsInteger := pTalonarioID;
    //qryNumero.Close;
    //qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}
    //sacamos un nuevo id de factura
    pReciboID := SGCDDataModule.SiguienteValor('seq_recibo');
    AbrirCursor;
    //creamos nueva factura
    qryCabecera.Append;
    qryCabeceraID.AsInteger := pReciboID;
    //    qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoReciboCompra.CancelButtonClick(Sender: TObject);
begin
  SGCDDataModule.sqlTran.Rollback;
  ButtonLimpiarClick(Self);
  DateEdit1.Clear;
end;

procedure TProcesoReciboCompra.OKButtonClick(Sender: TObject);
begin
  try
    qryCabeceraFECHA_EMISION.AsDateTime := DateEdit1.Date;
    Guardar;
    //AL SER FACTURA COMPRA NO SE DEBE COBRAR
    {//si no es un recibo que paga una factura contado generamos el pago
    if qryCabeceraFACTURACOMPRAID.IsNull then
    begin
      FComprobante.comprobante.ID := pReciboID;
      FComprobante.comprobante.PersonaID := qryCabeceraPERSONAID.AsInteger;
      FComprobante.comprobante.Tipo := Recibo;
      FComprobante.comprobante.Total := qryCabeceraTOTAL.AsFloat;
      try
        hola := TProcesoCobro.Create(Self, FComprobante);
        if (hola.ShowModal = mrCancel) then
        begin
          raise EDatabaseError.Create('Se cancelo el pago y no se guarda el recibo');
        end
        else
        begin
          SGCDDataModule.sqlTran.Commit;
          SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
          SGCDDataModule.sqlTran.Commit;
          ShowMessage('OK');
          ButtonLimpiarClick(Self);
          Exit;
        end;
      finally
        //hola.Free;
      end;
    end;}
    SGCDDataModule.sqlTran.Commit;
    ShowMessage('OK');
    ButtonLimpiarClick(Self);
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
      SGCDDataModule.sqlTran.Rollback;
      ButtonLimpiarClick(Self);
    end;
  end;
end;

procedure TProcesoReciboCompra.SeleccionarClick(Sender: TObject);
begin

end;

procedure TProcesoReciboCompra.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TProcesoReciboCompra.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
  ShellExecute(Handle, 'open', 'help\ABMs\recibos-compra.html', nil, nil, 1);
end;

procedure TProcesoReciboCompra.DBGrid1KeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    if not (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Edit;
    case DBGrid1.SelectedField.FieldName of
      'TOTAL':
      begin
        qryDetalleTOTAL.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGrid1.SelectedIndex := 1;
      end;
      else
      begin
        Exit;
      end;
    end;
  end
  else if (Key = VK_DELETE) and (not (DBGrid1.EditorMode)) and not
    qryDetalle.IsEmpty then
  begin
    //borrar la fila actual
    if (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Cancel;
    qryDetalle.Delete;
    ActualizarTotal;
  end
  else if (key = VK_ESCAPE) and not qryDetalle.IsEmpty then
  begin
    if (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Delete;
    ActualizarTotal;
  end;
end;

procedure TProcesoReciboCompra.SeleccionarFacturaClick(Sender: TObject);
begin

end;

procedure TProcesoReciboCompra.SetpReciboID(AValue: integer);
begin
  if FpReciboID = AValue then
    Exit;
  FpReciboID := AValue;
end;

procedure TProcesoReciboCompra.SetpTalonarioID(AValue: integer);
begin
  if FpTalonarioID = AValue then
    Exit;
  FpTalonarioID := AValue;
end;


procedure TProcesoReciboCompra.DBGrid1CellClick(Column: TColumn);
begin
  if (Column.Title.Caption = 'BORRAR') and not qryDetalle.IsEmpty then
  begin
    //borrar la fila actual
    qryDetalle.Delete;
    ActualizarTotal;
  end;
end;

{
****************************************
MANEJO DE VENTANA
****************************************
}
procedure TProcesoReciboCompra.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoReciboCompra.FormCreate(Sender: TObject);
begin
  XMLPropStorage1.Restore;

  //creamos los objetos que sirven de mensajeros entre los forms de busqueda y principal
  FAlumno := TMensajeAlumno.Create();
  FTalonario := TMensajeTalonario.Create();
  FFactura := TMensajeFacturaUnica.Create();
  FComprobante := TMensajeComprobante.Create();
  ButtonLimpiarClick(Self);
  DateEdit1.Clear;
end;

procedure TProcesoReciboCompra.Guardar;
begin
  qryCabeceraNUMERO.AsInteger := qryNumeroNUM.AsInteger;
  qryCabecera.ApplyUpdates;
  qryDetalle.ApplyUpdates;
end;

{
***********************************
MANEJO DE ERRORES
***********************************
}
procedure TProcesoReciboCompra.ManejoErrores(E: EDatabaseError);
begin
  inherited ManejoErrores(E);
  Cabecera.Enabled := False;
  Detalles.Enabled := False;
  Totales.Enabled := False;
end;

{
************************************
GUARDADO DE PROPIEDADES
************************************
}

procedure TProcesoReciboCompra.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if Trim(XMLPropStorage1.StoredValues.Items[0].Value) = '' then
    pTalonarioID := 0
  else
    pTalonarioID := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoReciboCompra.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(pTalonarioID);
end;


{$R *.lfm}

end.
