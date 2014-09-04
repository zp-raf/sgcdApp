unit frmrecibo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, XMLPropStorage, PairSplitter,
  DBGrids, frmProceso, frmbuscartalonariorec, frmseleccionarUnaFactura,
  frmbuscaralumnos, mensajes, frmsgcddatamodule, LCLType, strutils, frmcobro, ShellApi;

type

  { TProcesoRecibo }

  TProcesoRecibo = class(TProceso)
    dsNum: TDatasource;
    DBText1: TDBText;
    DBText2: TDBText;
    dstal: TDatasource;
    Label11: TLabel;
    Label12: TLabel;
    qryCabeceraPERSONAID: TLongintField;
    qryDeudaCANT: TLongintField;
    qryDeudaDETALLE: TStringField;
    qryDeudaDEUDAID: TLongintField;
    qryDeudaEXENTA: TFloatField;
    qryDeudaIVA10: TFloatField;
    qryDeudaIVA5: TFloatField;
    qryDeudaPERSONAID: TLongintField;
    qryDeudaPRECIO_UNITARIO: TFloatField;
    qryFacPERSONAID: TLongintField;
    tal: TSQLQuery;
    talID: TLongintField;
    talTIMBRADO: TStringField;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure talFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    FpReciboID: integer;
    FpTalonarioID: integer;
    procedure SetpReciboID(AValue: integer);
    procedure SetpTalonarioID(AValue: integer);
  published
    dsCabecera: TDatasource;
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFACTURAID: TLongintField;
    qryCabeceraFECHA_EMISION: TDateField;
    qryCabeceraID: TLongintField;
    qryCabeceraNOMBRE: TStringField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryDetalleRECIBOID: TLongintField;
    qryDetalleTOTAL: TFloatField;
    qryFacCONTADO: TSmallintField;
    qryFacFECHA_EMISION: TDateField;
    qryFacID: TLongintField;
    qryFacNOMBRE: TStringField;
    qryFacNUMERO: TLongintField;
    qryFacRUC: TStringField;
    qryFacTOTAL: TFloatField;
    SeleccionarFactura: TButton;
    Seleccionar: TButton;
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
    dsPersona: TDatasource;
    dsDetalle: TDatasource;
    dsDeuda: TDatasource;
    Grantotal: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    qryCabecera: TSQLQuery;
    qryFac: TSQLQuery;
    Talonarios: TMenuItem;
    Opciones: TMenuItem;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryPersona: TSQLQuery;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    qryDetalle: TSQLQuery;
    qryDetalleID: TLongintField;
    qryDeuda: TSQLQuery;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    Totales: TGroupBox;
    XMLPropStorage1: TXMLPropStorage;
    constructor Create(AOwner: TComponent; var Factura: TMensajeFacturaUnica); overload;
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
    procedure DBGrid1EditingDone(Sender: TObject);
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
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoRecibo: TProcesoRecibo;
  f: TPopupSeleccionAlumnos;
  g: TPopupBuscarTalonarioRec;
  h: TPopupSeleccionarUnaFactura;
  FTalonario: TMensajeTalonario;
  FFactura: TMensajeFacturaUnica;
  FComprobante: TMensajeComprobante;
  hola: TProcesoCobro;

implementation

{$R *.lfm}

{ TProcesoRecibo }
{
**************************
SETTERS Y GETTERS
**************************
}


constructor TProcesoRecibo.Create(AOwner: TComponent;
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
procedure TProcesoRecibo.AbrirCursor;
begin
  try
    qryPersona.Close;
    qryCabecera.Close;
    qryDetalle.Close;
    //qryNumero.Close;
    qryDeuda.Close;
    qryFac.Close;
    tal.Close;
    qryPersona.Open;
    qryCabecera.Open;
    qryDetalle.Open;
    //qryNumero.Open;
    qryDeuda.Open;
    qryFac.Open;
    tal.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoRecibo.qryDetalleFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('RECIBOID').AsInteger = pReciboID;
end;

//aca manejamos el autoincremento del dataset
procedure TProcesoRecibo.qryDetalleNewRecord(DataSet: TDataSet);
begin
  qryDetalleID.AsInteger := SGCDDataModule.SiguienteValor('seq_recibo_detalle');
  qryDetalleRECIBOID.AsInteger := pReciboID;
  qryDetalleDETALLE.AsString := '';
  qryDetalleCANTIDAD.AsInteger := 0;
end;

procedure TProcesoRecibo.qryDeudaFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = qryPersonaID.AsInteger;
end;

{
*******************************
ACCIONES DE BOTONES Y MENUS
*******************************
}

procedure TProcesoRecibo.SeleccionarFacturasClick(Sender: TObject);
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
procedure TProcesoRecibo.talonarioClick(Sender: TObject);
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

procedure TProcesoRecibo.ActualizarTotal;
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

procedure TProcesoRecibo.CargarRecibo;
begin
  try
    if not qryFac.Locate('ID', IntToStr(FFactura.factura.ID),
      [loCaseInsensitive]) then
      Exit;
    qryCabeceraFECHA_EMISION.AsDateTime := Now;
    qryCabeceraPERSONAID.AsInteger := qryFacPERSONAID.AsInteger;
    qryCabeceraNOMBRE.AsString := qryFacNOMBRE.AsString;
    qryCabeceraFACTURAID.AsInteger := FFactura.factura.ID;

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

procedure TProcesoRecibo.CrearRecibo;
begin
  ButtonLimpiarClick(Self);
  CargarRecibo;
  Guardar;
end;

procedure TProcesoRecibo.btSeleccionarClick(Sender: TObject);
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
    //filtramos la deuda para sacar solo la del alumno seleccionado
    qryDeuda.Close;
    qryDeuda.Open;

    if DateEdit1.Text = '' then
    begin
      DateEdit1.Date := Now;
    end;
    //aplicamos los cambios a la cabecera
    qryCabeceraFECHA_EMISION.AsDateTime := Now;
    qryCabeceraPERSONAID.AsInteger := qryPersonaID.AsInteger;
    qryCabeceraNOMBRE.AsString := qryPersonaNOMBRECOMPLETO.AsString;
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
      qryDetalleDEUDAID.AsInteger := qryDeudaDEUDAID.AsInteger;
      qryDeuda.Next;
    end;
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

procedure TProcesoRecibo.ButtonLimpiarClick(Sender: TObject);
begin
  try
    //traemos el siguiente numero de factura disponible del talonario
    qryNumero.Params[0].AsInteger := pTalonarioID;
    qryNumero.Close;
    qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}
    //sacamos un nuevo id de factura
    pReciboID := SGCDDataModule.SiguienteValor('seq_recibo');
    AbrirCursor;
    tal.refresh;
    //creamos nueva factura
    qryCabecera.Append;
    qryCabeceraID.AsInteger := pReciboID;
    qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoRecibo.CancelButtonClick(Sender: TObject);
begin
  SGCDDataModule.sqlTran.Rollback;
  ButtonLimpiarClick(Self);
  DateEdit1.Clear;
end;

procedure TProcesoRecibo.OKButtonClick(Sender: TObject);
begin
  try
    qryCabeceraFECHA_EMISION.AsDateTime := DateEdit1.Date;
    Guardar;
    //si no es un recibo que paga una factura contado generamos el pago
    FComprobante.comprobante.ID := pReciboID;
    FComprobante.comprobante.PersonaID := qryCabeceraPERSONAID.AsInteger;
    FComprobante.comprobante.Tipo := Recibo;
    FComprobante.comprobante.Total := qryCabeceraTOTAL.AsFloat;
    try
      hola := TProcesoCobro.Create(Self, FComprobante);
      case hola.ShowModal of
        mrCancel:
          raise EDatabaseError.Create('#Se cancelo el pago y no se guarda el recibo#');
        mrOk:
        begin
          SGCDDataModule.sqlTran.Commit; //se comitea el pago
          //actualizamos el estado de las deudas
          SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
          //y comiteamos el stored procedure
          SGCDDataModule.sqlTran.Commit;
          ShowMessage('OK');
          ButtonLimpiarClick(Self);
          Exit;
        end
        else
          Exit;
      end;
    finally
      //hola.Free;
    end;
    //SGCDDataModule.sqlTran.Commit;
    //ShowMessage('OK');
    //ButtonLimpiarClick(Self);
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
      SGCDDataModule.sqlTran.Rollback;
      ButtonLimpiarClick(Self);
    end;
  end;
end;

procedure TProcesoRecibo.DBGrid1EditingDone(Sender: TObject);
begin
  if not (qryDetalle.State in [dsEdit, dsInsert]) then
    qryDetalle.Edit;

  if (qryDetalleCANTIDAD.AsFloat <> 0) and (qryDetallePRECIO_UNITARIO.AsFloat <> 0) then
  begin
    ActualizarTotal;
    DBGrid1.SetFocus;
  end;
end;

procedure TProcesoRecibo.talFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ID').AsInteger = pTalonarioID;
end;

procedure TProcesoRecibo.DBGrid1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
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

procedure TProcesoRecibo.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
   ShellExecute(Handle, 'open', 'help\ABMs\recibos.html', nil, nil, 1);
end;

procedure TProcesoRecibo.SetpReciboID(AValue: integer);
begin
  if FpReciboID = AValue then
    Exit;
  FpReciboID := AValue;
end;

procedure TProcesoRecibo.SetpTalonarioID(AValue: integer);
begin
  if FpTalonarioID = AValue then
    Exit;
  FpTalonarioID := AValue;
end;

{
****************************************
MANEJO DE VENTANA
****************************************
}
procedure TProcesoRecibo.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoRecibo.FormCreate(Sender: TObject);
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

procedure TProcesoRecibo.Guardar;
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
procedure TProcesoRecibo.ManejoErrores(E: EDatabaseError);
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

procedure TProcesoRecibo.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if Trim(XMLPropStorage1.StoredValues.Items[0].Value) = '' then
    pTalonarioID := 0
  else
    pTalonarioID := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoRecibo.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(pTalonarioID);
end;

end.
