unit frmnotacredito;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  XMLPropStorage, frmProceso, sqldb, DB, IBConnection, frmsgcddatamodule,
  frmbuscaralumnos, mensajes, frmbuscartalonarioNC, PropertyStorage, strutils,
  LCLType, frmseleccionarfacturas, ShellApi;

type
  { TProcesoNotaCredito }

  TProcesoNotaCredito = class(TProceso)
    dsNum: TDatasource;
    DBText1: TDBText;
    DBText2: TDBText;
    dstal: TDatasource;
    Label11: TLabel;
    Label12: TLabel;
    qryCabeceraPERSONAID: TLongintField;
    qryDetalleCONTRA_FACTURA: TLongintField;
    qryFacPERSONAID: TLongintField;
    tal: TSQLQuery;
    talID: TLongintField;
    talTIMBRADO: TStringField;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure talFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    FpNotaCreditoID: integer;
    FpTalonarioID: integer;
    procedure SetpNotaCreditoID(AValue: integer);
    procedure SetpTalonarioID(AValue: integer);
  published
    btSeleccionar: TButton;
    ButtonLimpiar: TButton;
    DBNavigator1: TDBNavigator;
    dsPersona: TDatasource;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    dsDeuda: TDatasource;
    dsCabecera: TDatasource;
    dsDetalle: TDatasource;
    DateEdit1: TDateEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBGrid1: TDBGrid;
    Cabecera: TGroupBox;
    Detalles: TGroupBox;
    Grantotal: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryCabeceraDIRECCION: TStringField;
    qryCabeceraFECHA_EMISION: TDateField;
    qryCabeceraID: TLongintField;
    qryCabeceraIVA10: TFloatField;
    qryCabeceraIVA5: TFloatField;
    qryCabeceraIVA_TOTAL: TFloatField;
    qryCabeceraNOMBRE: TStringField;
    qryCabeceraNOTA_REMISION: TStringField;
    qryCabeceraNUMERO: TLongintField;
    qryCabeceraRUC: TStringField;
    qryCabeceraSUBTOTAL_EXENTAS: TFloatField;
    qryCabeceraSUBTOTAL_IVA10: TFloatField;
    qryCabeceraSUBTOTAL_IVA5: TFloatField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryDetalleDETALLE: TStringField;
    qryDetalleID: TLongintField;
    qryDeuda: TSQLQuery;
    qryDeudaPERSONAID: TLongintField;
    qryDeudaCANT: TLongintField;
    qryDeudaDETALLE: TStringField;
    qryDeudaDEUDAID: TLongintField;
    qryDeudaEXENTA: TFloatField;
    qryDeudaIVA10: TFloatField;
    qryDeudaIVA5: TFloatField;
    qryDeudaPRECIO_UNITARIO: TFloatField;
    qryDetalle: TSQLQuery;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    qryPersona: TSQLQuery;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRECOMPLETO: TStringField;
    qryCabecera: TSQLQuery;
    Subtotal: TLabel;
    Subtotal1: TLabel;
    Subtotal2: TLabel;
    Totales: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    XMLPropStorage1: TXMLPropStorage;
    qryDetalleNOTACREDITOID: TLongintField;
    MenuItemOpciones: TMenuItem;
    MenuItemTalonario: TMenuItem;
    qryFacCONTADO: TSmallintField;
    qryFacDetCANTIDAD: TLongintField;
    qryFacDetDETALLE: TStringField;
    qryFacDetDEUDAID: TLongintField;
    qryFacDetEXENTA: TFloatField;
    qryFacDetFACTURAID: TLongintField;
    qryFacDetID: TLongintField;
    qryFacDetIVA10: TFloatField;
    qryFacDetIVA5: TFloatField;
    qryFacDetPRECIO_UNITARIO: TFloatField;
    qryFacFECHA_EMISION: TDateField;
    qryFacID: TLongintField;
    qryFacNOMBRE: TStringField;
    qryFacNUMERO: TLongintField;
    qryFacRUC: TStringField;
    qryFacTOTAL: TFloatField;
    SeleccionarFacturas: TButton;
    qryFac: TSQLQuery;
    qryFacDet: TSQLQuery;
    procedure qryFacDetFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryFacFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SeleccionarFacturasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
    procedure AbrirCursor;
    procedure ActualizarTotal;
    procedure btSeleccionarClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject); override;
    procedure FormCreate(Sender: TObject); override;
    procedure ManejoErrores(E: EDatabaseError); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryDetalleFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryDetalleNewRecord(DataSet: TDataSet);
    procedure qryDeudaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure talonarioClick(Sender: TObject);
    property pTalonarioID: integer read FpTalonarioID write SetpTalonarioID;
    property pNotaCreditoID: integer read FpNotaCreditoID write SetpNotaCreditoID;
  end;

var
  ProcesoNotaCredito: TProcesoNotaCredito;
  f: TPopupSeleccionAlumnos;
  g: TPopupBuscarTalonarioNC;
  h: TPopupSeleccionarFacturas;
  //Fqry: TMensajeFactura;
  Factura: TMensajeFacturaUnica;

implementation

{$R *.lfm}

{ TProcesoNotaCredito }

{
**************************
SETTERS Y GETTERS
**************************
}

procedure TProcesoNotaCredito.talFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ID').AsInteger = pTalonarioID;
end;

procedure TProcesoNotaCredito.DBGrid1KeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    if not (qryDetalle.State in [dsEdit, dsInsert]) then
      qryDetalle.Edit;
    case DBGrid1.SelectedField.FieldName of
      'EXENTA':
      begin
        qryDetalleIVA5.AsFloat := 0;
        qryDetalleIVA10.AsFloat := 0;
        qryDetalleEXENTA.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGrid1.SelectedIndex := 1;
      end;
      'IVA5':
      begin
        qryDetalleEXENTA.AsFloat := 0;
        qryDetalleIVA10.AsFloat := 0;
        qryDetalleIVA5.AsFloat :=
          qryDetalleCANTIDAD.AsInteger * qryDetallePRECIO_UNITARIO.AsFloat;
        qryDetalle.Post;
        ActualizarTotal;
        qryDetalle.Append;
        DBGrid1.SelectedIndex := 1;
      end;
      'IVA10':
      begin
        qryDetalleEXENTA.AsFloat := 0;
        qryDetalleIVA5.AsFloat := 0;
        qryDetalleIVA10.AsFloat :=
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

procedure TProcesoNotaCredito.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\nota-credito-venta.html', nil, nil, 1);
end;

procedure TProcesoNotaCredito.SetpNotaCreditoID(AValue: integer);
begin
  if FpNotaCreditoID = AValue then
    Exit;
  FpNotaCreditoID := AValue;
end;

procedure TProcesoNotaCredito.SetpTalonarioID(AValue: integer);
begin
  if FpTalonarioID = AValue then
    Exit;
  FpTalonarioID := AValue;
end;

{
****************************
FILTROS Y EVENTOS DE DATASET
****************************
}
procedure TProcesoNotaCredito.AbrirCursor;
begin
  try
    qryPersona.Close;
    qryCabecera.Close;
    qryDetalle.Close;
    //qryNumero.Close;
    qryDeuda.Close;
    qryFac.Close;
    qryFacDet.Close;
    tal.Close;
    qryPersona.Open;
    qryCabecera.Open;
    qryDetalle.Open;
    //qryNumero.Open;
    qryDeuda.Open;
    qryFac.Open;
    qryFacDet.Open;
    tal.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoNotaCredito.qryDetalleFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('NOTACREDITOID').AsInteger = pNotaCreditoID;
end;

procedure TProcesoNotaCredito.qryFacFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if Factura.factura.ID = -99 then
    Accept := True
  else
    Accept := DataSet.FieldByName('ID').AsInteger = Factura.factura.ID;
end;

procedure TProcesoNotaCredito.qryFacDetFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('FACTURAID').AsInteger = qryFacID.AsInteger;
end;

//aca manejamos el autoincremento del dataset
procedure TProcesoNotaCredito.qryDetalleNewRecord(DataSet: TDataSet);
begin
  qryDetalleID.AsInteger := SGCDDataModule.SiguienteValor('seq_nota_credito_detalle');
  qryDetalleNOTACREDITOID.AsInteger := pNotaCreditoID;
  qryDetalleDETALLE.AsString := '';
  qryDetalleCANTIDAD.AsInteger := 0;
  qryDetalleEXENTA.AsFloat := 0;
  qryDetalleIVA5.AsFloat := 0;
  qryDetalleIVA10.AsFloat := 0;
end;

procedure TProcesoNotaCredito.qryDeudaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = qryPersonaID.AsInteger;
end;

{
*******************************
ACCIONES DE BOTONES Y MENUS
*******************************
}

procedure TProcesoNotaCredito.SeleccionarFacturasClick(Sender: TObject);
begin
  try
    h := TPopupSeleccionarFacturas.Create(Self, Factura);
    if (h.ShowModal = mrOk) then
    begin
      try
        //traemos el siguiente numero de factura disponible del talonario
        qryNumero.Params[0].AsInteger := pTalonarioID;
        qryNumero.Close;
        qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}
        DateEdit1.Clear;
        qryCabecera.Cancel;
        AbrirCursor;
        //creamos nueva factura
        qryCabecera.Append;
        qryCabeceraID.AsInteger := pNotaCreditoID;
        qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
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
  try
    {qryFac.Refresh;
    if not Fqry.Locate('FACTURAID', qryFac.FieldByName('ID').AsString,
      [loCaseInsensitive]) then
      Exit; }
    qryCabeceraPERSONAID.AsInteger := qryFacPERSONAID.AsInteger;
    qryCabeceraRUC.AsString := qryFacRUC.AsString;
    qryCabeceraNOMBRE.AsString := qryFacNOMBRE.AsString;
    DateEdit1.Date := Now;

    //recorremos el dataset y vamos cargando en la factura
    {Fqry.First;
    while not Fqry.EOF do
    begin
      qryFac.Refresh;}
    qryFac.First;
    while not qryFac.EOF do
    begin
      qryFacDet.Refresh;
      qryFacDet.First;
      while not qryFacDet.EOF do
      begin
        qryDetalle.Append;
        qryDetalleCANTIDAD.AsInteger := qryFacDetCANTIDAD.AsInteger;
        qryDetalleDETALLE.AsString :=
          'Devolución de Factura nro ' + qryFacNUMERO.AsString +
          ' emitida en ' + qryFacFECHA_EMISION.AsString + '. Detalle: ' +
          qryFacDetDETALLE.AsString;
        qryDetallePRECIO_UNITARIO.AsFloat := qryFacDetPRECIO_UNITARIO.AsFloat;
        qryDetalleEXENTA.AsFloat := qryFacDetEXENTA.AsFloat;
        qryDetalleIVA5.AsFloat := qryFacDetIVA5.AsFloat;
        qryDetalleIVA10.AsFloat := qryFacDetIVA10.AsFloat;
        qryDetalleDEUDAID.AsInteger := qryFacDetDEUDAID.AsInteger;
        qryDetalleCONTRA_FACTURA.AsInteger := 1;
        qryFacDet.Next;
      end;
      qryFac.Next;
    end;
    //Fqry.Next;
    //end;
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

//para seleccionar el talonario a usar
procedure TProcesoNotaCredito.talonarioClick(Sender: TObject);
begin
  //creamos la ventana de seleccion
  try
    FTalonario.talonario.ID := pTalonarioID;
    g := TPopupBuscarTalonarioNC.Create(Self, FTalonario);
    if (g.ShowModal = mrOk) then
    begin
      pTalonarioID := FTalonario.talonario.ID;
      {por si se entro en condicion de error de talonario no existente
      entonces volvemos a habilitar los campos}
      Cabecera.Enabled := True;
      Detalles.Enabled := True;
      Totales.Enabled := True;
      //Fqry.OnFilterRecord := @qryFilterRecord;
      ButtonLimpiarClick(Self);
      Exit;
    end
    else
    begin
      //Fqry.Cancel;
      Exit;
    end;
  finally
    g.Free;
  end;
end;

procedure TProcesoNotaCredito.ActualizarTotal;
begin
  if not (qryCabecera.State in [dsEdit, dsInsert]) then
    qryCabecera.Edit;
  qryCabeceraSUBTOTAL_EXENTAS.AsFloat := 0.0;
  qryCabeceraSUBTOTAL_IVA5.AsFloat := 0.0;
  qryCabeceraSUBTOTAL_IVA10.AsFloat := 0.0;
  if not qryDetalle.IsEmpty then
  begin
    qryDetalle.First;
    while not qryDetalle.EOF do
    begin
      qryCabeceraSUBTOTAL_EXENTAS.AsFloat :=
        qryCabeceraSUBTOTAL_EXENTAS.AsFloat + qryDetalleEXENTA.AsFloat;
      qryCabeceraSUBTOTAL_IVA5.AsFloat :=
        qryCabeceraSUBTOTAL_IVA5.AsFloat + qryDetalleIVA5.AsFloat;
      qryCabeceraSUBTOTAL_IVA10.AsFloat :=
        qryCabeceraSUBTOTAL_IVA10.AsFloat + qryDetalleIVA10.AsFloat;
      qryDetalle.Next;
    end;
    qryCabeceraTOTAL.AsFloat :=
      round(qryCabeceraSUBTOTAL_EXENTAS.AsFloat + qryCabeceraSUBTOTAL_IVA5.AsFloat +
      qryCabeceraSUBTOTAL_IVA10.AsFloat);
    qryCabeceraIVA5.AsFloat := round(qryCabeceraSUBTOTAL_IVA5.AsFloat / 23.0);
    qryCabeceraIVA10.AsFloat := round(qryCabeceraSUBTOTAL_IVA10.AsFloat / 11.0);
    qryCabeceraIVA_TOTAL.AsFloat :=
      round(qryCabeceraIVA5.AsFloat + qryCabeceraIVA10.AsFloat);
  end;
end;

procedure TProcesoNotaCredito.btSeleccionarClick(Sender: TObject);
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
        //Fqry.Cancel;
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

    //aplicamos los cambios a la cabecera
    if DateEdit1.Text = '' then
    begin
      DateEdit1.Date := Now;
    end;
    qryCabeceraPERSONAID.AsInteger := qryDeudaPERSONAID.AsInteger;
    qryCabeceraRUC.AsString := qryPersonaCEDULA.AsString;
    qryCabeceraNOMBRE.AsString := qryPersonaNOMBRECOMPLETO.AsString;
    ActualizarTotal;

    //recorremos el dataset y vamos cargando en la factura
    qryDeuda.First;
    while not qryDeuda.EOF do
    begin
      qryDetalle.Append;
      qryDetalleCANTIDAD.AsInteger := qryDeudaCANT.AsInteger;
      qryDetalleDETALLE.AsString := 'Cancelación de ' + qryDeudaDETALLE.AsString;
      qryDetallePRECIO_UNITARIO.AsFloat := qryDeudaPRECIO_UNITARIO.AsFloat;
      qryDetalleEXENTA.AsFloat := qryDeudaEXENTA.AsFloat;
      qryDetalleIVA5.AsFloat := qryDeudaIVA5.AsFloat;
      qryDetalleIVA10.AsFloat := qryDeudaIVA10.AsFloat;
      qryDetalleDEUDAID.AsInteger := qryDeudaDEUDAID.AsInteger;
      qryDeuda.Next;
    end;
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

procedure TProcesoNotaCredito.ButtonLimpiarClick(Sender: TObject);
begin
  try
    //traemos el siguiente numero de factura disponible del talonario
    qryNumero.Params[0].AsInteger := pTalonarioID;
    qryNumero.Close;
    qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}
    //sacamos un nuevo id de factura
    pNotaCreditoID := SGCDDataModule.SiguienteValor('seq_nota_credito');
    DateEdit1.Clear;
    AbrirCursor;
    tal.refresh;
    //creamos nueva factura
    qryCabecera.Append;
    qryCabeceraID.AsInteger := pNotaCreditoID;
    qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoNotaCredito.CancelButtonClick(Sender: TObject);
begin
  qryPersona.Close;
  qryCabecera.Close;
  qryDetalle.Close;
  //qryNumero.Close;
  qryDeuda.Close;
  qryFac.Close;
  qryFacDet.Close;
  //SGCDDataModule.sqlTran.Rollback;
  ButtonLimpiarClick(Self);
end;

procedure TProcesoNotaCredito.OKButtonClick(Sender: TObject);
begin
  try
    qryCabeceraFECHA_EMISION.AsDateTime := DateEdit1.Date;
    qryCabeceraNUMERO.AsInteger := qryNumeroNUM.AsInteger;
    qryCabecera.ApplyUpdates;
    qryDetalle.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
    SGCDDataModule.sqlTran.Commit;
    ShowMessage('OK');
    ButtonLimpiarClick(Self);
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

{
****************************************
MANEJO DE VENTANA
****************************************
}
procedure TProcesoNotaCredito.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoNotaCredito.FormCreate(Sender: TObject);
begin
  XMLPropStorage1.Restore;

  //creamos los objetos que sirven de mensajeros entre los forms de busqueda y principal
  FAlumno := TMensajeAlumno.Create();
  FTalonario := TMensajeTalonario.Create();
  Factura := TMensajeFacturaUnica.Create();
  Factura.factura.ID := -99;

  ButtonLimpiarClick(Self);
end;

{
***********************************
MANEJO DE ERRORES
***********************************
}
procedure TProcesoNotaCredito.ManejoErrores(E: EDatabaseError);
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

procedure TProcesoNotaCredito.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if Trim(XMLPropStorage1.StoredValues.Items[0].Value) = '' then
    pTalonarioID := 0
  else
    pTalonarioID := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoNotaCredito.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(pTalonarioID);
end;

end.
