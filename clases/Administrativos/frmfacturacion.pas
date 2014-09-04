unit frmfacturacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_DBSet, LR_Class, Forms, Controls, Graphics,
  Dialogs, Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter,
  DBGrids, XMLPropStorage, frmProceso, sqldb, DB, IBConnection,
  frmsgcddatamodule, frmbuscaralumnos, mensajes, frmbuscartalonario,
  PropertyStorage, strutils, LCLType, frmcobro, ShellApi;

type
  { TProcesoFacturacion }

  TProcesoFacturacion = class(TProceso)
    DBText2: TDBText;
    dstal: TDatasource;
    dsNum: TDatasource;
    DBText1: TDBText;
    frDBReporteCab: TfrDBDataSet;
    frDBReporteDet: TfrDBDataSet;
    frReport1: TfrReport;
    Label11: TLabel;
    Label12: TLabel;
    qryCabecera1: TSQLQuery;
    qryCabecera1ACTIVO: TSmallintField;
    qryCabecera1CAJA: TStringField;
    qryCabecera1CONTADO: TSmallintField;
    qryCabecera1COPIAS: TLongintField;
    qryCabecera1DIRECCION: TStringField;
    qryCabecera1DIRECCION_1: TStringField;
    qryCabecera1ES_CONTADO: TStringField;
    qryCabecera1ES_CREDITO: TStringField;
    qryCabecera1FECHA_EMISION: TDateField;
    qryCabecera1ID: TLongintField;
    qryCabecera1IVA10: TFloatField;
    qryCabecera1IVA5: TFloatField;
    qryCabecera1IVA_TOTAL: TFloatField;
    qryCabecera1NOMBRE: TStringField;
    qryCabecera1NOMBRE_1: TStringField;
    qryCabecera1NOTA_REMISION: TStringField;
    qryCabecera1NUMERO: TLongintField;
    qryCabecera1NUMERO_FIN: TLongintField;
    qryCabecera1NUMERO_INI: TLongintField;
    qryCabecera1RUBRO: TStringField;
    qryCabecera1RUC: TStringField;
    qryCabecera1RUC_1: TStringField;
    qryCabecera1SUBTOTAL_EXENTAS: TFloatField;
    qryCabecera1SUBTOTAL_IVA10: TFloatField;
    qryCabecera1SUBTOTAL_IVA5: TFloatField;
    qryCabecera1SUCURSAL: TStringField;
    qryCabecera1TELEFONO: TStringField;
    qryCabecera1TELEFONO_1: TStringField;
    qryCabecera1TIMBRADO: TStringField;
    qryCabecera1TIPO: TLongintField;
    qryCabecera1TOTAL: TFloatField;
    qryCabecera1VALIDO_DESDE: TDateField;
    qryCabecera1VALIDO_HASTA: TDateField;
    qryCabecera1VENCIMIENTO: TDateField;
    qryCabeceraPERSONAID: TLongintField;
    qryDetalle1: TSQLQuery;
    qryDetalleCANTIDAD1: TLongintField;
    qryDetalleDETALLE1: TStringField;
    qryDetalleDEUDAID1: TLongintField;
    qryDetalleEXENTA1: TFloatField;
    qryDetalleFACTURAID1: TLongintField;
    qryDetalleID1: TLongintField;
    qryDetalleIVA11: TFloatField;
    qryDetalleIVA6: TFloatField;
    qryDetallePRECIO_UNITARIO1: TFloatField;
    tal: TSQLQuery;
    talACTIVO: TSmallintField;
    talCAJA: TStringField;
    talCOPIAS: TLongintField;
    talDIRECCION: TStringField;
    talID: TLongintField;
    talNOMBRE: TStringField;
    talNUMERO_FIN: TLongintField;
    talNUMERO_INI: TLongintField;
    talRUBRO: TStringField;
    talRUC: TStringField;
    talSUCURSAL: TStringField;
    talTELEFONO: TStringField;
    talTIMBRADO: TStringField;
    talTIPO: TLongintField;
    talVALIDO_DESDE: TDateField;
    talVALIDO_HASTA: TDateField;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure talFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    FFacturaID: integer;
    FTalonarioID: integer;
    procedure SetFacturaID(AValue: integer);
    procedure SetTalonarioID(AValue: integer);
  published
    btSeleccionar: TButton;
    ButtonLimpiar: TButton;
    DateEdit2: TDateEdit;
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
    Condicion: TDBRadioGroup;
    Cabecera: TGroupBox;
    Detalles: TGroupBox;
    Grantotal: TLabel;
    Label10: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryCabeceraCONTADO: TSmallintField;
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
    qryCabeceraVENCIMIENTO: TDateField;
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
    qryDetalleFACTURAID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    talonario: TMenuItem;
    opciones: TMenuItem;
    qryDetalle: TSQLQuery;
    XMLPropStorage1: TXMLPropStorage;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
    procedure AbrirCursor;
    procedure ActualizarTotal;
    procedure btSeleccionarClick(Sender: TObject);
    procedure ButtonLimpiarClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject); override;
    procedure CondicionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
    procedure ManejoErrores(E: EDatabaseError); override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryDetalleFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryDetalleNewRecord(DataSet: TDataSet);
    procedure qryDeudaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure talonarioClick(Sender: TObject);
    property pTalonarioID: integer read FTalonarioID write SetTalonarioID;
    property pFacturaID: integer read FFacturaID write SetFacturaID;
  end;

var
  ProcesoFacturacion: TProcesoFacturacion;
  f: TPopupSeleccionAlumnos;
  g: TPopupBuscarTalonario;
  hola: TProcesoCobro;

implementation

{$R *.lfm}

{ TProcesoFacturacion }

{
*************************************
SETTERS Y GETTERS
*************************************
}

procedure TProcesoFacturacion.SetFacturaID(AValue: integer);
begin
  if FFacturaID = AValue then
    Exit;
  FFacturaID := AValue;
end;

procedure TProcesoFacturacion.SetTalonarioID(AValue: integer);
begin
  if FTalonarioID = AValue then
    Exit;
  FTalonarioID := AValue;
end;

{
*************************************
FILTROS Y EVENTOS DEL DATASET
*************************************
}

procedure TProcesoFacturacion.AbrirCursor;
begin
  try
    qryPersona.Close;
    qryCabecera.Close;
    qryDetalle.Close;
    //qryNumero.Close;
    qryDeuda.Close;
    tal.Close;
    qryPersona.Open;
    qryCabecera.Open;
    qryDetalle.Open;
    //qryNumero.Open;
    qryDeuda.Open;
    tal.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;


procedure TProcesoFacturacion.qryDetalleFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('FACTURAID').AsInteger = pFacturaID;
end;

{
 aca manejamos el autoincremento del dataset
}
procedure TProcesoFacturacion.qryDetalleNewRecord(DataSet: TDataSet);
begin
  qryDetalleID.AsInteger := SGCDDataModule.SiguienteValor('seq_factura_detalle');
  qryDetalleFACTURAID.AsInteger := pFacturaID;
  qryDetalleDETALLE.AsString := '';
  qryDetalleCANTIDAD.AsInteger := 0;
  qryDetalleEXENTA.AsFloat := 0;
  qryDetalleIVA5.AsFloat := 0;
  qryDetalleIVA10.AsFloat := 0;
end;

procedure TProcesoFacturacion.qryDeudaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = qryPersonaID.AsInteger;
end;

{
*************************************
EVENTOS DE BOTONES Y MENUS
*************************************
}

procedure TProcesoFacturacion.ActualizarTotal;
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

procedure TProcesoFacturacion.btSeleccionarClick(Sender: TObject);
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

    //aplicamos los cambios a la cabecera
    if DateEdit1.Text = '' then
    begin
      DateEdit1.Date := Now;
    end;
    qryCabeceraPERSONAID.AsInteger := qryPersonaID.AsInteger;
    qryCabeceraRUC.AsString := qryPersonaCEDULA.AsString;
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

procedure TProcesoFacturacion.ButtonLimpiarClick(Sender: TObject);
begin
  try

    //traemos el siguiente numero de factura disponible del talonario
    qryNumero.Params[0].AsInteger := pTalonarioID;
    qryNumero.Close;
    qryNumero.Open;
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}

    //sacamos un nuevo id de factura
    pFacturaID := SGCDDataModule.SiguienteValor('seq_factura');
    DateEdit1.Clear;
    DateEdit2.Clear;
    AbrirCursor;
    tal.Refresh;
    //creamos nueva factura
    qryCabecera.Append;
    qryCabeceraID.AsInteger := pFacturaID;
    qryCabeceraTALONARIOID.AsInteger := pTalonarioID;
    qryCabeceraCONTADO.AsInteger := 1;//por defecto contado
    DateEdit2.Enabled := False;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

procedure TProcesoFacturacion.CancelButtonClick(Sender: TObject);
begin
  SGCDDataModule.sqlTran.Rollback;
  ButtonLimpiarClick(Self);
end;

procedure TProcesoFacturacion.CondicionChange(Sender: TObject);
begin
  if Condicion.Value = '0' then
    DateEdit2.Enabled := True
  else
    DateEdit2.Enabled := False;
end;

//para seleccionar el talonario a usar
procedure TProcesoFacturacion.talonarioClick(Sender: TObject);
begin
  //creamos la ventana de seleccion
  try
    FTalonario.talonario.ID := pTalonarioID;
    g := TPopupBuscarTalonario.Create(Self, FTalonario);
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

procedure TProcesoFacturacion.DBGrid1KeyDown(Sender: TObject;
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

procedure TProcesoFacturacion.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
   ShellExecute(Handle, 'open', 'help\ABMs\factura-venta.html', nil, nil, 1);
end;

procedure TProcesoFacturacion.talFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ID').AsInteger = pTalonarioID;
end;

procedure TProcesoFacturacion.OKButtonClick(Sender: TObject);
begin
  try
    qryCabeceraFECHA_EMISION.AsDateTime := DateEdit1.Date;
    if qryCabeceraCONTADO.AsInteger = 0 then
    begin
      qryCabeceraVENCIMIENTO.AsDateTime := DateEdit2.Date;
      if (qryCabeceraVENCIMIENTO.AsDateTime <= qryCabeceraFECHA_EMISION.AsDateTime) then
        raise EDatabaseError.Create(
          '#La fecha de vencimiento no puede ser anterior a la fecha de emision#');
    end;
    qryCabeceraNUMERO.AsInteger := qryNumeroNUM.AsInteger;
    //si la factura es contado ya abrimos la ventana para pagar
    if qryCabeceraCONTADO.AsInteger = 1 then
    begin
      //guardamos los datos para pasarle a la ventana de cobro
      FComprobante.comprobante.ID := pFacturaID;
      FComprobante.comprobante.Tipo := 1;
      FComprobante.comprobante.PersonaID := qryCabeceraPERSONAID.AsInteger;
      FComprobante.comprobante.Total := qryCabeceraTOTAL.AsFloat;

      qryCabecera.ApplyUpdates;
      qryDetalle.ApplyUpdates;
      try
        hola := TProcesoCobro.Create(Self, FComprobante);
        case hola.ShowModal of
          mrOk:
          begin
            SGCDDataModule.sqlTran.Commit; //se comitea el pago
            //actualizamos el estado de las deudas
            SGCDDataModule.Ejecutar('execute procedure actualizar_estado_deuda');
            //y comiteamos el stored procedure
            SGCDDataModule.sqlTran.Commit;
          end;
          mrCancel:
            raise EDatabaseError.Create('#Se cancelo el pago y no se guarda el recibo#');
          else
            Exit;
        end;
      finally
        //hola.Free;
      end;
    end
    else
    begin
      qryCabecera.ApplyUpdates;
      qryDetalle.ApplyUpdates;
      SGCDDataModule.sqlTran.Commit;
    end;
    //mostrar reporte
    qryCabecera1.Params.ParamByName('factura_id').AsInteger := pFacturaID;
    qryDetalle1.Params.ParamByName('facturaid').AsInteger := pFacturaID;
    frReport1.LoadFromFile('reportes\reporte-factura.lrf');
    frReport1.ShowReport;

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

{
*************************************
MANEJO DE VENTANA
*************************************
}
procedure TProcesoFacturacion.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoFacturacion.FormCreate(Sender: TObject);
begin
  XMLPropStorage1.Restore;
  //creamos los objetos que sirven de mensajeros entre los forms de busqueda y principal
  FAlumno := TMensajeAlumno.Create();
  FTalonario := TMensajeTalonario.Create();
  FComprobante := TMensajeComprobante.Create();
  ButtonLimpiarClick(Self);
end;

{
*************************************
MANEJO DE ERRORES
*************************************
}
procedure TProcesoFacturacion.ManejoErrores(E: EDatabaseError);
begin
  inherited ManejoErrores(E);
  Cabecera.Enabled := False;
  Detalles.Enabled := False;
  Totales.Enabled := False;
end;

{
*************************************
GUARDADO DE PROPIEDADES
*************************************
}

procedure TProcesoFacturacion.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if Trim(XMLPropStorage1.StoredValues.Items[0].Value) = '' then
    pTalonarioID := 0
  else
    pTalonarioID := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoFacturacion.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(pTalonarioID);
end;

end.
