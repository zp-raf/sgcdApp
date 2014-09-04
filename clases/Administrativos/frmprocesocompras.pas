unit frmProcesoCompras;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, DB, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ButtonPanel, StdCtrls, DBCtrls, EditBtn, PairSplitter, DBGrids,
  XMLPropStorage, frmProceso, IBConnection, frmsgcddatamodule,
  frmbuscaralumnos, mensajes, frmbuscartalonario, PropertyStorage, strutils, LCLType,
  frmfacturacion, ShellApi;

type

  { TProcesoFactCompra }


  TProcesoFactCompra = class(TProceso)
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    NumeroFactura: TLabel;
    Timbrado: TLabel;
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
    qryCabeceraPERSONAID: TLongintField;
    qryCabeceraRUC: TStringField;
    qryCabeceraSUBTOTAL_EXENTAS: TFloatField;
    qryCabeceraSUBTOTAL_IVA10: TFloatField;
    qryCabeceraSUBTOTAL_IVA5: TFloatField;
    qryCabeceraTALONARIOID: TLongintField;
    qryCabeceraTELEFONO: TStringField;
    qryCabeceraTIMBRADO: TStringField;
    qryCabeceraTOTAL: TFloatField;
    qryCabeceraVENCIMIENTO: TDateField;
    qryDetalleCANTIDAD: TLongintField;
    qryDetalleDETALLE: TStringField;
    qryDetalleDEUDAID: TLongintField;
    qryDetalleEXENTA: TFloatField;
    qryDetalleFACTURACOMPID: TLongintField;
    qryDetalleID: TLongintField;
    qryDetalleIVA10: TFloatField;
    qryDetalleIVA5: TFloatField;
    qryDetallePRECIO_UNITARIO: TFloatField;
    qryPersonaCEDULA: TStringField;
    qryPersonaID: TLongintField;
    qryPersonaNOMBRE_COMPLETO: TStringField;
    talonario: TMenuItem;
    opciones: TMenuItem;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MenuItemAyudaClick(Sender: TObject);
  private
    { private declarations }
    FFacturaID: integer;
    FTalonarioID: integer;
    procedure SetFacturaID(AValue: integer);
    procedure SetTalonarioID(AValue: integer);
  published
    btSeleccionar: TButton;
    ButtonLimpiar: TButton;
    Cabecera: TGroupBox;
    Condicion: TDBRadioGroup;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Detalles: TGroupBox;
    dsCabecera: TDatasource;
    dsDetalle: TDatasource;
    dsDeuda: TDatasource;
    dsPersona: TDatasource;
    Grantotal: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryCabecera: TSQLQuery;
    qryDetalle: TSQLQuery;
    qryDeuda: TSQLQuery;
    qryDeudaCANT: TLongintField;
    qryDeudaDETALLE: TStringField;
    qryDeudaDEUDAID: TLongintField;
    qryDeudaEXENTA: TFloatField;
    qryDeudaIVA10: TFloatField;
    qryDeudaIVA5: TFloatField;
    qryDeudaPERSONAID: TLongintField;
    qryDeudaPRECIO_UNITARIO: TFloatField;
    qryNumero: TSQLQuery;
    qryNumeroNUM: TLongintField;
    qryPersona: TSQLQuery;
    Subtotal: TLabel;
    Subtotal1: TLabel;
    Subtotal2: TLabel;
    Totales: TGroupBox;
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
// public
{ public declarations }
//end;

var
  ProcesoFactCompra: TProcesoFactCompra;
  ProcesoFacturacion: TProcesoFacturacion;
  f: TPopupSeleccionAlumnos;
  g: TPopupBuscarTalonario;

implementation

{$R *.lfm}

{ TProcesoFactCompra }


{
*************************************
SETTERS Y GETTERS
*************************************
}

procedure TProcesoFactCompra.SetFacturaID(AValue: integer);
begin
  if FFacturaID = AValue then
    Exit;
  FFacturaID := AValue;
end;

procedure TProcesoFactCompra.SetTalonarioID(AValue: integer);
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

procedure TProcesoFactCompra.AbrirCursor;
begin
  try
    qryPersona.Close;
    qryCabecera.Close;
    qryDetalle.Close;
    //qryNumero.Close;
    qryDeuda.Close;
    qryPersona.Open;
    qryCabecera.Open;
    qryDetalle.Open;
    //qryNumero.Open;
    qryDeuda.Open;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;


procedure TProcesoFactCompra.qryDetalleFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('FACTURACOMPID').AsInteger = pFacturaID;
end;

{
 aca manejamos el autoincremento del dataset
}
procedure TProcesoFactCompra.qryDetalleNewRecord(DataSet: TDataSet);
begin
  qryDetalleID.AsInteger := SGCDDataModule.SiguienteValor('GEN_FACTURA_COMPRA_DET');
  qryDetalleFACTURACOMPID.AsInteger := pFacturaID;
  qryDetalleDETALLE.AsString := '';
  qryDetalleCANTIDAD.AsInteger := 0;
  qryDetalleEXENTA.AsFloat := 0;
  qryDetalleIVA5.AsFloat := 0;
  qryDetalleIVA10.AsFloat := 0;
end;

procedure TProcesoFactCompra.qryDeudaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = qryPersonaID.AsInteger;
end;

{
*************************************
EVENTOS DE BOTONES Y MENUS
*************************************
}

procedure TProcesoFactCompra.ActualizarTotal;
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

procedure TProcesoFactCompra.btSeleccionarClick(Sender: TObject);
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
    qryCabeceraNOMBRE.AsString := qryPersonaNOMBRE_COMPLETO.AsString;
    ActualizarTotal;

    //recorremos el dataset y vamos cargando en la factura
    {
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
    }
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

procedure TProcesoFactCompra.ButtonLimpiarClick(Sender: TObject);
begin
  try

    //traemos el siguiente numero de factura disponible del talonario
    {
     qryNumero.Params[0].AsInteger := pTalonarioID;
     qryNumero.Close;
     qryNumero.Open;
    }
    {si se devuelve negativo quiere decir que el talonario no existe y se pide
    seleccionar uno}
    //sacamos un nuevo id de factura
    pFacturaID := SGCDDataModule.SiguienteValor('gen_factura_compra');
    DateEdit1.Clear;
    DateEdit2.Clear;
    AbrirCursor;
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

procedure TProcesoFactCompra.CancelButtonClick(Sender: TObject);
begin
  SGCDDataModule.sqlTran.Rollback;
  Close;
end;

procedure TProcesoFactCompra.CondicionChange(Sender: TObject);
begin
  if Condicion.Value = '0' then
    DateEdit2.Enabled := True
  else
    DateEdit2.Enabled := False;
end;

//para seleccionar el talonario a usar
procedure TProcesoFactCompra.talonarioClick(Sender: TObject);
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

procedure TProcesoFactCompra.DBGrid1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
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

procedure TProcesoFactCompra.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
   ShellExecute(Handle, 'open', 'help\ABMs\factura-compra.html', nil, nil, 1);
end;

procedure TProcesoFactCompra.OKButtonClick(Sender: TObject);
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
    //qryCabeceraNUMERO.AsInteger := qryNumeroNUM.AsInteger;
    qryCabecera.ApplyUpdates;
    qryDetalle.ApplyUpdates;
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
*************************************
MANEJO DE VENTANA
*************************************
}
procedure TProcesoFactCompra.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoFactCompra.FormCreate(Sender: TObject);
begin
  XMLPropStorage1.Restore;
  //creamos los objetos que sirven de mensajeros entre los forms de busqueda y principal
  FAlumno := TMensajeAlumno.Create();
  FTalonario := TMensajeTalonario.Create();
  ButtonLimpiarClick(Self);
end;

{
*************************************
MANEJO DE ERRORES
*************************************
}
procedure TProcesoFactCompra.ManejoErrores(E: EDatabaseError);
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

procedure TProcesoFactCompra.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  if Trim(XMLPropStorage1.StoredValues.Items[0].Value) = '' then
    pTalonarioID := 0
  else
    pTalonarioID := StrToInt(XMLPropStorage1.StoredValues.Items[0].Value);
end;

procedure TProcesoFactCompra.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.StoredValues.Items[0].Value := IntToStr(pTalonarioID);
end;

end.


