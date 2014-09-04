unit frmPagos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DbCtrls, EditBtn, frmAbm, frmsgcddatamodule;

type

  { TProcGenerarPago }

  TProcGenerarPago = class(TAbm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DBGrid3: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    dsCargaPagoDetalle: TDatasource;
    dsPagoDetalle: TDatasource;
    DateEdit1: TDateEdit;
    dsAlumno: TDatasource;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    qryAlumno: TSQLQuery;
    qryPagoDetalleCOMPROBANTE_TARJETA: TStringField;
    qryPagoDetalleEMISOR_CHEQUE: TStringField;
    qryPagoDetalleEMISOR_TARJETA: TStringField;
    qryPagoDetalleID: TLongintField;
    qryPagoDetalleMONTO: TFloatField;
    qryPagoDetalleNRO_CHEQUE: TStringField;
    qryPagoDetalleNRO_TARJETA: TStringField;
    qryPagoDetallePAGOID: TLongintField;
    qryPagoDetalleTIPO_PAGO: TLongintField;
    spCargaPagoDetalle: TSQLQuery;
    qryAlumnoACTIVO: TSmallintField;
    qryAlumnoAPELLIDO: TStringField;
    qryAlumnoCEDULA: TStringField;
    qryAlumnoCONFIRMADO: TSmallintField;
    qryAlumnoFECHANAC: TDateField;
    qryAlumnoID: TLongintField;
    qryAlumnoNOMBRE: TStringField;
    qryAlumnoNOMBRECOMPLETO: TStringField;
    qryAlumnoPERSONAID: TLongintField;
    qryAlumnoSEXO: TStringField;
    qryPagoDetalle: TSQLQuery;
    NombreAlumno: TStringField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1DEUDAID: TSmallintField;
    SQLQuery1FACTURAID: TLongintField;
    SQLQuery1FECHA: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MONTO: TFloatField;
    SQLQuery1NOTA_CREDITOID: TLongintField;
    SQLQuery1PERSONAID: TLongintField;
    SQLQuery1RECIBOID: TLongintField;
    SQLQuery1TIPO_MOVIMIENTO: TLongintField;
    SQLQuery1VALIDO: TSmallintField;

    procedure Button1Click(Sender: TObject);
    //procedure FormCreate(Sender: TObject);

    procedure FormCreate(Sender: TObject); override;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure PanelNuevoClick(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure OKButtonClick(Sender: TObject); override;

    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Actualizar; override;
    procedure ModificarDatos; override;
    function SiguienteValor(Field: ansistring; Table: ansistring): integer;
    constructor FormCreate(Sender: TObject ; deudaid: integer); overload;
    constructor FormShow(Sender: TObject); overload;
  private
    { private declarations }
  public
    { public declarations }
  protected
    idtabla : Integer;
    llamadoExterno : Boolean;
    deudaid_local : Integer;
  end;

var
  ProcGenerarPago: TProcGenerarPago;

implementation


constructor TProcGenerarPago.FormCreate( Sender : TObject; deudaid: integer);
begin
     //inherited;
     FormCreate(Self);
     llamadoExterno := True;
     deudaid_local :=  deudaid;
     FormShow(Self);
  //  Self.MenuItemEliminar.Visible := False;
  //  Self.MenuItemModificar.Caption:= 'Ver pagos generados';
  //  MenuItemNuevoClick(Self);
 // Enabled:= True; /// ????
end;

constructor TProcGenerarPago.FormShow( Sender : TObject);
begin
  MenuItemEliminar.Visible:= False;
  MenuItemModificar.Caption:= 'Ver pagos generados';
  MenuItemNuevoClick(Self);
end;



procedure TProcGenerarPago.Button1Click(Sender: TObject);
  /// tengo que crear un objeto query que llame a SP_CARGA_PAGO_DETALLE, mañana nomas ya
var
  cant_cuotas : Integer;
  i : Integer;
  id_arancel: Integer;
begin
  //id_arancel := SQLQuery1ARANCELID.AsInteger;
  try
    //deshabilitamos el boton para evitar nuevos clicks
    Button1.Enabled := False;
    if DatosValidos then
    begin
      Insertar;
      Guardar;
      {se abren los dataset de direccion
      y telefono y ya se pueden insertar datos  }
      //AbrirCursorInfoContacto;
      //GroupBoxContacto.Enabled := True; //habilitamos el panel
    end
    else
    begin
      Button1.Enabled := True;
      Exit;
    end;
  except
    on E:
      EDatabaseError do
    begin
      Button1.Enabled := True;
      ManejoErrores(E);
      Exit;
    end;
  end;

  //qryDeudaDetalle.Params.ParamByName('deudaid').AsInteger:= idtabla;

  qryPagoDetalle.Params.ParamByName('pagoid').AsInteger:= idtabla;

  //cant_cuotas := StrToInt(SGCDDataModule.DevuelveValor('select ca.cantidadcuota cant_cuota from cuotaxarancel ca where ca.arancelid = '+ IntToStr(id_arancel),'cant_cuota'));

  with spCargaPagoDetalle do
  begin
    try
        Close;
        SQL.Clear;
        SQL.Add('execute procedure sp_carga_pago_detalle (:pagoid);');
        Params.ParamByName('pagoid').AsInteger:= idtabla;
//        Params.ParamByName('nro_cuota').AsInteger:= i+1 ;
        Open;
       // spPrueba.ExecSQL; descarto esto, porque ya se ejecuta mi stored procedure en el open
       spCargaPagoDetalle.ApplyUpdates;
       SGCDDataModule.sqlTran.Commit;
       qryPagoDetalle.Close;
       qryPagoDetalle.Open;
    except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  end;
  SQLQuery1.Close;
  SQLQuery1.Open;
end;


procedure TProcGenerarPago.FormCreate (Sender: TObject);
begin
     IniciaForm('PAGO','ID');
//   inherited;
     Self.Query := 'select * from pago';
     Self.InsQuery :=
    'insert into PAGO (ID, FECHA, TIPO_MOVIMIENTO, PERSONAID, DEUDAID, FACTURAID, RECIBOID, NOTA_CREDITOID, MONTO, DESCRIPCION, VALIDO)'+
    ' values ((SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM pago), :ARANCELID, :PERSONAID, :MATRICULAID, :ACTIVO, :MONTO_DEUDA, :MONTO_PAGADO, :FECHA_DEUDA, :DESCRIPCION,:CUOTA_NRO, :CANT_CUOTAS, :CANTIDAD)';
     Self.MenuItemEliminar.Visible:= False; /// No permito eliminar el historial
     Self.MenuItemNuevo.Visible:= False;
     Self.MenuItemModificar.Caption:= 'Ver histórico de transacciones';
    // if (Sender.ClassName = 'TProcDeudasAlumno') then
   // begin
      //empty
   // end;
end;


procedure TProcGenerarPago.FormShow(Sender: TObject);
begin
//  inherited;
  LimpiarCampos;
  PanelNuevo.Visible := False;
  PanelEliminar.Visible := False;
  PanelModificar.Visible := True;
  Self.Estado := Alta;
  AbrirCursor;
    try
    qryAlumno.Close;
    qryPagoDetalle.Close;
    qryAlumno.SQL.Clear;
    qryPagoDetalle.SQL.Clear;
    qryAlumno.SQl.SetText('SELECT * FROM PERSONA P JOIN ALUMNO A ON P.ID = A.PERSONAID WHERE A.ACTIVO = 1;');
    qryPagoDetalle.SQL.SetText('select * from pago_detalle where pagoid = :pagoid;');
    qryAlumno.Open;
    qryPagoDetalle.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;

 // Edit1.SetFocus;
    //parche para que funcionen los lookupcombobox :(
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
end;



procedure TProcGenerarPago.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    { if Button in [mbRight] then
    MessageDlg('Contenido del campo',
      '- Nro. Desarrollo Mat.: ' + SQLQuery1ID.AsString + #13#10 + '- Materia: ' +
      NombreMateria.AsString + #13#10 + '- Profesor: ' +
      NombreCompleto.AsString + #13#10 + '- Seción: ' +
      NombreSeccion.AsString + #13#10 + '- Período Lectivo: ' +
      NombrePeriodoLectivo.AsString, mtCustom, [mbOK], 0);}
end;

procedure TProcGenerarPago.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    { if Button in [mbRight] then
    MessageDlg('Contenido del campo',
      '- Nro. Desarrollo Mat.: ' + SQLQuery1ID.AsString + #13#10 + '- Materia: ' +
      NombreMateria.AsString + #13#10 + '- Profesor: ' +
      NombreCompleto.AsString + #13#10 + '- Seción: ' +
      NombreSeccion.AsString + #13#10 + '- Período Lectivo: ' +
      NombrePeriodoLectivo.AsString, mtCustom, [mbOK], 0);}
end;


procedure TProcGenerarPago.PanelNuevoClick(Sender: TObject);
begin
     LimpiarCampos;
end;

function TProcGenerarPago.DatosValidos: boolean;
begin
  if ((Trim(Edit1.Text) = '')) then
{     or (Trim(Edit4.Text) = '')
     or (Trim(Edit5.Text) = '')
     or (Trim(Edit6.Text) = ''))  then}
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;

{  if not (FechaValida ( DateEdit2.Date)
         or FechaValida(DateEdit1.Date)) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;}

end;


procedure TProcGenerarPago.Insertar;
begin
  idtabla := StrToInt(SGCDDataModule.DevuelveValor('select gen_id (GENERATOR_PAGO,1) as id from rdb$database','id')) ;

  if llamadoExterno then
     SQLQuery1DEUDAID.AsInteger:= deudaid_local;
 // SQLQuery1.FieldByName('ID').Required := False;
  SQLQuery1ID.AsInteger:= idtabla;
  //SQLQuery1NRORECIBO.AsString:= Edit1.Text;
  SQLQuery1FECHA.AsDateTime:= DateEdit1.Date;
//  SQLQuery1DETALLE.AsString:= Edit2.Text;


  if CheckBox1.Checked then
    SQLQuery1VALIDO.AsInteger := 1
  else
    SQLQuery1VALIDO.AsInteger := 0;

{  if CheckBox2.Checked then
//     SQLQuery1RECIBOIMPRESO.AsInteger:= 1
  else
  //    SQLQuery1RECIBOIMPRESO.AsInteger:= 0;
 }

//  SQLQuery1DESCRIPCION.AsString:= Edit1.Text;
  {SQLQuery1FECHAINICIO.AsDateTime:= DateEdit1.Date;
  SQLQuery1FECHATOPE.AsDateTime:= DateEdit2.Date;
    SQLQuery1MONTO_DEUDA.AsFloat:= StrToFloat(Edit4.Text);
  SQLQuery1MONTO_PAGADO.AsFloat:= StrToFloat(Edit5.Text);
  SQLQuery1SALDO.AsFloat:= StrToFloat(Edit6.Text);

   Self.x := SiguienteValor('ID', 'PERSONA');
   SQLQuery1ID.AsInteger := Self.x;
  }
  { se guarda en cache pero no se comitea, en caso
    de que el usuario no quiera guardar los cambios }
  //SQLQuery1.ApplyUpdates;

end;

procedure TProcGenerarPago.LimpiarCampos;
begin
  Inherited;
//  Edit1.Clear;
 { DateEdit1.Clear;
  DateEdit2.Clear;
  Edit4.Clear;
  Edit5.Clear;
  Edit6.Clear;
  NombreAlumno.Clear;
  NombreArancel.Clear;
  IDMatricula.Clear;}
end;

procedure  TProcGenerarPago.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  try
    qryAlumno.Close;
    qryPagoDetalle.Close;
    qryAlumno.SQL.Clear;
    qryPagoDetalle.SQL.Clear;
    qryAlumno.SQl.SetText('SELECT * FROM PERSONA P JOIN ALUMNO A ON P.ID = A.PERSONAID WHERE A.ACTIVO = 1;');
    qryPagoDetalle.SQL.SetText('select * from pago_detalle where pagoid = :pagoid;');
    qryAlumno.Open;
    qryPagoDetalle.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;

  Edit1.SetFocus;
    //parche para que funcionen los lookupcombobox :(
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
end;

procedure TProcGenerarPago.OKButtonClick(Sender: TObject);
begin
//  SQLQuery1.FieldByName('ID').Required := False;


//  Como ya guarde en el proceso anterior, limpio nada mas mi dataset o lo que sea
  if (Self.Estado in [Alta]) then
    if not (DatosValidos) then
      Exit
    else
      try
//        Insertar;
       //Guardar;
        AbrirCursor; // para seguir insertando datos
        LimpiarCampos;
        MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
        Exit;
      except
        on E: EDatabaseError do
        begin
          ManejoErrores(E);
          CerrarDataset;
          Limpiar;
          Exit;
        end;
      end;
  //inherited;
  //if Estado in [Alta] then
    //    MemoNuevoTema.SetFocus;
   // SQLQuery1.Append;
end;


procedure TProcGenerarPago.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;


procedure TProcGenerarPago.Actualizar;
begin
  {
  SQLQuery1.Append;
   SQLQuery1NOMBRE.AsString := Filtrar(LabeledEditNuevoNombre.Text);
   SQLQuery1DESCRIPCION.AsString := Filtrar(LabeledEditNuevoDescripcion.Text);
   SQLQuery1DURACION.AsString := Filtrar(LabeledEditDuracion.Text);
   SQLQuery1JUSTIFICACION.AsString := Filtrar(MemoNuevoJustificacion.Text);
   SQLQuery1OBJETIVOS.AsString := Filtrar(MemoNuevoObjetivos.Text);
   SQLQuery1CONTENIDO.AsString := Filtrar(MemoNuevoContenido.Text);
   SQLQuery1ESTRATEGIAS.AsString := Filtrar(MemoNuevoEstrategia.Text);
   SQLQuery1MATERIALES.AsString := Filtrar(MemoNuevoMaterial.Text);
   SQLQuery1EVALUACION.AsString := Filtrar(MemoNuevoEvaluacion.Text);
   SQLQuery1BIBLIOGRAFIA.AsString := Filtrar(MemoNuevoBibliografia.Text);
   if CheckBoxNuevoHabilitado.Checked then
     SQLQuery1HABILITADA.AsInteger := 1
   else
     SQLQuery1HABILITADA.AsInteger := 0;
}
end;

procedure TProcGenerarPago.ModificarDatos;
begin
  {
   SQLQuery1.Edit; //parche para que funcionen los lookups, se pone en edicion aca en vez de al hacer ok :(
   LabeledEditNuevoNombre.Text:= SQLQuery1NOMBRE.AsString;
   LabeledEditNuevoDescripcion.Text:= SQLQuery1DESCRIPCION.AsString;
   LabeledEditDuracion.Text:= SQLQuery1DURACION.AsString;
   MemoNuevoJustificacion.Text:= SQLQuery1JUSTIFICACION.AsString;
   MemoNuevoObjetivos.Text:= SQLQuery1OBJETIVOS.AsString;
   MemoNuevoContenido.Text:= SQLQuery1CONTENIDO.AsString;
   MemoNuevoEstrategia.Text:= SQLQuery1ESTRATEGIAS.AsString;
   MemoNuevoMaterial.Text:= SQLQuery1MATERIALES.AsString;
   MemoNuevoEvaluacion.Text:= SQLQuery1EVALUACION.AsString;
   MemoNuevoBibliografia.Text:= SQLQuery1BIBLIOGRAFIA.AsString;
   if SQLQuery1HABILITADA.AsInteger = 1 then
     CheckBoxNuevoHabilitado .Checked := True
   else
     CheckBoxNuevoHabilitado.Checked := False;
  }
  DateEdit1.Date:= SQLQuery1FECHA.AsDateTime;
//  Edit2.Text:= SQLQuery1DETALLE.AsString;
  Edit1.Text:= FloatToStr(SQLQuery1MONTO.AsFloat);
  Edit2.Text:= SQLQuery1DESCRIPCION.AsString;
  Edit3.Text:= SQLQuery1TIPO_MOVIMIENTO.AsString;

  if SQLQuery1TIPO_MOVIMIENTO.AsInteger = 1 then
    Edit3.Text:= 'CRE'
  else if SQLQuery1TIPO_MOVIMIENTO.AsInteger = 2 then
    Edit3.Text:= 'DEB';

  if SQLQuery1VALIDO.AsInteger = 1 then
      CheckBox1.Checked := True
    else
      CheckBox1.Checked := False;
  {
   if SQLQuery1RECIBOIMPRESO.AsInteger = 1 then
       CheckBox2.Checked := True
     else
       CheckBox2.Checked := False;
  }
end;


function TProcGenerarPago.SiguienteValor(Field: ansistring; Table: ansistring): integer;
var
  qry: string;
  qry_resul: integer;
begin
  qry := 'SELECT COALESCE(MAX(ID), 0)+1 AS RESUL FROM DEUDA';
  qry_resul := StrToInt(SGCDDataModule.DevuelveValor(qry, 'RESUL'));
  Result := qry_resul;
end;

{$R *.lfm}

end.

