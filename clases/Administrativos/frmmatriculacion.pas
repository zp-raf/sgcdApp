unit frmmatriculacion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, DBGrids, DBCtrls, ButtonPanel, XMLPropStorage, frmProceso,
  sqldb, DB, frmsgcddatamodule, strutils, mensajes, frmseleccionararancel, ShellApi;

const
  Delimiter = ',';

type

  { TProcesoMatriculacion }
  TEstado = (Inicial, Procesando, Guardado);

  TProcesoMatriculacion = class(TProceso)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItemArancel: TMenuItem;
    SQLQueryMateriaNOMBRE_MOD: TStringField;
    XMLPropStorage1: TXMLPropStorage;
    ButtonEliminar: TButton;
    ButtonAgregar: TButton;
    ButtonFiltrar: TButton;
    ButtonSeleccionarAlumno1: TButton;
    DatasourcePeriodo: TDatasource;
    DatasourceMatricula: TDatasource;
    DatasourceMatHab: TDatasource;
    DatasourceAlumno: TDatasource;
    DatasourceDesarrolloMat: TDatasource;
    DatasourceMateria: TDatasource;
    DatasourceModulo: TDatasource;
    DatasourceProfesor: TDatasource;
    DatasourceSeccion: TDatasource;
    DBGridMatHab: TDBGrid;
    DBGridMatricula: TDBGrid;
    DBGridDesarrolloMat: TDBGrid;
    DBGridAlumno: TDBGrid;
    DBGridAlumno1: TDBGrid;
    DBMemoObservaciones: TDBMemo;
    EditFiltro: TEdit;
    GroupBoxAlumno: TGroupBox;
    GroupBoxMaterias: TGroupBox;
    LabelFiltro: TLabel;
    qryGen: TSQLQuery;
    SQLQueryDesarrolloMatMATERIAID: TLongintField;
    SQLQueryMateriaNOMBRE_GRUPO: TStringField;
    SQLQueryMateriaNOMBRE_MAT: TStringField;
    SQLQueryMatHabGRUPOID: TLongintField;
    SQLQueryMatHabPERSONAID: TLongintField;
    SQLQueryMatriculaACTIVA: TSmallintField;
    SQLQueryMatriculaDERECHOEXAMEN: TSmallintField;
    SQLQueryMatriculaMATERIAID: TLongintField;
    SQLQueryMatriculaSECCIONID: TLongintField;
    SQLQueryPeriodo: TSQLQuery;
    SQLQueryAlumnoID: TLongintField;
    SQLQueryMatricula: TSQLQuery;
    SQLQueryMatriculaALUMNOPERSONAID: TLongintField;
    SQLQueryMatriculaCONFIRMADA: TSmallintField;
    SQLQueryMatriculaDESARROLLOMATERIAID: TLongintField;
    SQLQueryMatriculaFECHA: TDateField;
    SQLQueryMatriculaID: TLongintField;
    SQLQueryMatriculaOBSERVACIONES: TStringField;
    SQLQueryMatHab: TSQLQuery;
    SQLQueryAlumnoCONFIRMADO: TSmallintField;
    SQLQueryDesarrolloMatEMPLEADOPERSONAID: TLongintField;
    SQLQueryDesarrolloMatID: TLongintField;
    SQLQueryDesarrolloMatPERIODOLECTIVOID: TLongintField;
    SQLQueryDesarrolloMatSECCIONID: TLongintField;
    SQLQueryDesarrolloMat: TSQLQuery;
    SQLQueryAlumno: TSQLQuery;
    SQLQueryAlumnoAPELLIDO: TStringField;
    SQLQueryAlumnoCEDULA: TStringField;
    SQLQueryAlumnoFECHANAC: TDateField;
    SQLQueryAlumnoNOMBRE: TStringField;
    SQLQueryAlumnoSEXO: TStringField;
    SQLQueryMateria: TSQLQuery;
    SQLQueryMateriaID: TLongintField;
    SQLQueryMateriaNOMBRE: TStringField;
    SQLQueryMatHabID: TLongintField;
    SQLQueryModulo: TSQLQuery;
    SQLQueryModuloID: TLongintField;
    SQLQueryModuloNOMBRE: TStringField;
    SQLQueryPeriodoID: TLongintField;
    SQLQueryPeriodoNOMBRE: TStringField;
    SQLQueryProfesor: TSQLQuery;
    SQLQueryProfesorACTIVO: TSmallintField;
    SQLQueryProfesorAPELLIDO: TStringField;
    SQLQueryProfesorID: TLongintField;
    SQLQueryProfesorNOMBRE: TStringField;
    SQLQueryProfesorNOMBRE_COMPLETO: TStringField;
    SQLQuerySeccion: TSQLQuery;
    SQLQuerySeccionID: TLongintField;
    SQLQuerySeccionNOMBRE: TStringField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    procedure DBGridAlumnoCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure MenuItemArancelClick(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure popupHelpTextRestoreProperties(Sender: TObject);
    procedure popupHelpTextSaveProperties(Sender: TObject);
    procedure AbrirCursor;
    procedure Borrar;
    procedure ButtonEliminarClick(Sender: TObject);
    procedure ButtonAgregarClick(Sender: TObject);
    procedure ButtonFiltrarClick(Sender: TObject);
    procedure Cancelar;
    procedure CancelButtonClick(Sender: TObject); override;
    procedure DBGridMatHabCellClick(Column: TColumn);
    procedure DBMemoObservacionesEditingDone(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject); override;
    procedure FormResize(Sender: TObject);
    procedure InicializarVentana;
    procedure OKButtonClick(Sender: TObject); override;
    procedure SQLQueryAlumnoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryDesarrolloMatFilterRecord(DataSet: TDataSet;
      var Accept: boolean);
    procedure SQLQueryMatHabFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryMatriculaFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure ManejoErrores(E: EDatabaseError); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoMatriculacion: TProcesoMatriculacion;
  Estado: TEstado;
  AlumnoID: integer;
  f: TPopupSeleccionarArancel;

implementation

{$R *.lfm}
{
**********************************
PROPIEDADES
**********************************
}

procedure TProcesoMatriculacion.popupHelpTextRestoreProperties(Sender: TObject);
begin
  with XMLPropStorage1 do
  begin
    FAranceles.Clear;
    FAranceles.Delimiter := Delimiter;
    if Trim(StoredValues.Values['aranceles'].Value) = '' then
      FAranceles.Add('0')
    else
    begin
      FAranceles.DelimitedText := StoredValues.Values['aranceles'].Value;
    end;
  end;
end;

procedure TProcesoMatriculacion.popupHelpTextSaveProperties(Sender: TObject);
begin
  with XMLPropStorage1 do
  begin
    if FAranceles.Count = 0 then
    begin
      StoredValues.Values['aranceles'].Value := '';
    end
    else
    begin
      StoredValues.Values['aranceles'].Value := FAranceles.DelimitedText;
    end;
  end;
end;

{
**********************************
SETTERS Y GETTERS
**********************************
}

{
*********************************
MANEJO DE DATASETS
*********************************
}
procedure TProcesoMatriculacion.AbrirCursor;
begin
  SQLQueryMatHab.Close;
  SQLQueryDesarrolloMat.Close;
  SQLQueryMatricula.Close;
  SQLQueryMateria.Close;
  SQLQueryProfesor.Close;
  SQLQuerySeccion.Close;
  SQLQueryModulo.Close;
  //hay que abrir antes de mathab para que funcione el filtro
  SQLQueryMatricula.Open;
  SQLQueryMatHab.Open;
  SQLQueryDesarrolloMat.Open;
  SQLQueryMateria.Open;
  SQLQueryProfesor.Open;
  SQLQuerySeccion.Open;
  SQLQueryModulo.Open;
end;

procedure TProcesoMatriculacion.Cancelar;
begin
  //cancelamos todo
  SQLQueryMatHab.Cancel;
  SQLQueryDesarrolloMat.Cancel;
  SQLQueryMatricula.Cancel;
  SQLQueryMateria.Cancel;
  SQLQueryProfesor.Cancel;
  SQLQuerySeccion.Cancel;
  SQLQueryModulo.Cancel;
  //y cerramos los cursores
  SQLQueryMatHab.Close;
  SQLQueryDesarrolloMat.Close;
  SQLQueryMatricula.Close;
  SQLQueryMateria.Close;
  SQLQueryProfesor.Close;
  SQLQuerySeccion.Close;
  SQLQueryModulo.Close;
end;

procedure TProcesoMatriculacion.Borrar;
begin
  try
    if not (SQLQueryMatricula.State in [dsInsert, dsEdit]) then
      SQLQueryMatricula.Edit;
    SQLQueryMatriculaACTIVA.AsInteger := 0;
    SQLQueryMatricula.ApplyUpdates;
  except
    on e: EDatabaseError do
    begin
      ManejoErrores(e);
    end;
  end;
end;

{
*************************
MANEJO DE ERRORES
*************************
}
{ TProcesoMatriculacion }
procedure TProcesoMatriculacion.ManejoErrores(E: EDatabaseError);
begin
  inherited;
  //MessageDlg('Error', 'Error de base de datos. Consulta: ' +
  //  SQLQueryMatricula.SQL.Text + 'Insercion: ' + SQLQueryMatricula.InsertSQL.Text +
  //  'Modificacion: ' + SQLQueryMatricula.UpdateSQL.Text + #13#10 +
  //  'Mensaje del error: ' + #13#10 + E.Message, mtError, [mbOK], 0);
  Cancelar;
  SGCDDataModule.sqlTran.Rollback;
  InicializarVentana;
end;

{
*************************
FILTROS DE DATASET
*************************
}
procedure TProcesoMatriculacion.SQLQueryAlumnoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString, EditFiltro.Text) or
    AnsiContainsText(DataSet.FieldByName('APELLIDO').AsString, EditFiltro.Text) or
    AnsiContainsText(DataSet.FieldByName('CEDULA').AsString, EditFiltro.Text);
end;

procedure TProcesoMatriculacion.SQLQueryDesarrolloMatFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  {
   Accept := (DataSet.FieldByName('MATERIAID').AsInteger =
     SQLQueryMatHabID.AsInteger) and not
     (SQLQueryMatricula.Locate('DESARROLLOMATERIAID', DataSet.FieldByName('ID').AsString,
     [loCaseInsensitive]));
  }
  Accept := DataSet.FieldByName('MATERIAID').AsInteger = SQLQueryMatHabID.AsInteger;
end;

procedure TProcesoMatriculacion.SQLQueryMatHabFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := (DataSet.FieldByName('ID').AsInteger = AlumnoID) and not
    (SQLQueryMatricula.Locate('MATERIAID', DataSet.FieldByName('ID_MAT').AsString,
    [loCaseInsensitive]));
end;

procedure TProcesoMatriculacion.SQLQueryMatriculaFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ALUMNOPERSONAID').AsInteger = AlumnoID;
end;

{
******************************************
EVENTOS DE OBEJTOS (BOTONES, CAMPOS, ETC.)
******************************************
}
procedure TProcesoMatriculacion.ButtonFiltrarClick(Sender: TObject);
begin
  try
    if Trim(EditFiltro.Text) = '' then
    begin
      SQLQueryAlumno.Filtered := False;
      SQLQueryAlumno.Refresh;
    end
    else
    begin
      SQLQueryAlumno.Filtered := True;
      SQLQueryAlumno.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.ButtonAgregarClick(Sender: TObject);
begin
  try
    if not SQLQueryDesarrolloMat.IsEmpty then
    begin
      Estado := Procesando;
      if not (SQLQueryMatricula.State in [dsInsert]) then
        SQLQueryMatricula.Append; //si el dataset ya no esta en modo de insercion
      SQLQueryMatricula.FieldByName('ID').Required := False;
      SQLQueryMatricula.FieldByName('FECHA').Required := False;
      SQLQueryMatricula.FieldByName('ACTIVA').Required := False;
      SQLQueryMatricula.FieldByName('CONFIRMADA').Required := False;
      SQLQueryMatricula.FieldByName('DERECHOEXAMEN').Required := False;
      {no hace falta insertar id, fecha, activo, confimado y derechoexamen porque
      en el insert statement se autoincrementa, se usa la fecha del sistema, se
      inserta 1 para activo, 0 para confirmado y 0 para derecho a examen,
      respectivamente}
      SQLQueryMatriculaDESARROLLOMATERIAID.AsInteger :=
        SQLQueryDesarrolloMatID.AsInteger;
      SQLQueryMatriculaALUMNOPERSONAID.AsInteger := AlumnoID;
      {las observaciones se ingresan con el DBMemo}
      SQLQueryMatricula.ApplyUpdates;
      {actualizamos todos los grids}
      SQLQueryMatricula.Refresh;
      SQLQueryMatHab.Refresh;
      SQLQueryDesarrolloMat.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.ButtonEliminarClick(Sender: TObject);
begin
  try
    if not SQLQueryMatricula.IsEmpty then
    begin
      Borrar;
      //SQLQueryMatricula.Delete;
      //SQLQueryMatricula.ApplyUpdates;
      {actualizamos todos los grids}
      SQLQueryMatricula.Refresh;
      SQLQueryMatHab.Refresh;
      SQLQueryDesarrolloMat.Refresh;
      Estado := Procesando;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.CancelButtonClick(Sender: TObject);
begin
  try
    Cancelar;
    SGCDDataModule.sqlTran.Rollback;
      {Estado := Inicial;
      SQLQueryAlumno.Open;
    {reposicionamos el cursor para que se pueda seguir trabajando sobre el mismo
    alumno}
    if not SQLQueryAlumno.Locate('ID', IntToStr(AlumnoID), [loCaseInsensitive]) then
      SQLQueryAlumno.First;
    DBGridAlumnoCellClick(DBGridAlumno.Columns.Items[0]);
    //no importa que columna se le mande con tal que clickee}
    InicializarVentana;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.DBGridMatHabCellClick(Column: TColumn);
begin
  try
    SQLQueryDesarrolloMat.Refresh;
    SQLQueryMatricula.Refresh;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.DBMemoObservacionesEditingDone(Sender: TObject);
begin
  try
    SQLQueryMatricula.ApplyUpdates;
    SQLQueryMatricula.Refresh;
    Estado := Procesando;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.OKButtonClick(Sender: TObject);
var
  i: integer;
begin
  try
    if (Estado in [Procesando]) then
    begin
      SGCDDataModule.sqlTran.Commit; //guardamos la matriculacion
      //actualizar las deudas
      SQLQueryMatricula.Open;
      SQLQueryMatricula.First;
      while not SQLQueryMatricula.EOF do
      begin
        qryGen.Params.ParamByName('MATRICULAID').AsInteger :=
          SQLQueryMatriculaID.AsInteger;
        for i := 0 to FAranceles.Count - 1 do
        begin
          qryGen.Params.ParamByName('ARANCELID').AsString := FAranceles[i];
          qryGen.Active := True;
          qryGen.Prepare;
          qryGen.ExecSQL;
          qryGen.ApplyUpdates;
          //SGCDDataModule.sqlTran.Commit;
        end;
        SQLQueryMatricula.Next;
      end;
      SGCDDataModule.sqlTran.Commit;
      MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
      AbrirCursor;
      SQLQueryAlumno.Open;
      {reposicionamos el cursor para que se pueda seguir trabajando sobre el mismo
      alumno}
      if not SQLQueryAlumno.Locate('ID', IntToStr(AlumnoID), [loCaseInsensitive]) then
        SQLQueryAlumno.First;
      //el nuevo estado es guardado
      Estado := Guardado;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.MenuItemArancelClick(Sender: TObject);
begin
  try
    f := TPopupSeleccionarArancel.Create(Self, FAranceles);
    if (f.ShowModal = mrOk) then
    begin
      GroupBoxAlumno.Enabled := True;
      InicializarVentana;
    end
    else
      Exit;
  finally
    f.Free
  end;
end;

procedure TProcesoMatriculacion.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
   ShellExecute(Handle, 'open', 'help\ABMs\matricularAlumno.html', nil, nil, 1);
end;



{
*************************
MANEJO VENTANA
*************************
}
procedure TProcesoMatriculacion.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SQLQueryMatHab.Close;
  SQLQueryDesarrolloMat.Close;
  SQLQueryMatricula.Close;
  SQLQueryMateria.Close;
  SQLQueryProfesor.Close;
  SQLQuerySeccion.Close;
  SQLQueryModulo.Close;
  XMLPropStorage1.Save;
  inherited;
end;

procedure TProcesoMatriculacion.InicializarVentana;
begin
  //if (FAranceles.Count = 0) or ((FAranceles[0] = '0') and (FAranceles.Count = 1)) then
  if (FAranceles[0] = '0') then
  begin
    ShowMessage('Por favor seleccione los aranceles correspondientes a la ' +
      'matriculacion en el menu opciones');
    GroupBoxAlumno.Enabled := False;
    GroupBoxMaterias.Visible := False;
    Exit;
  end;

  GroupBoxMaterias.Visible := False;
  EditFiltro.Clear;
  SQLQueryAlumno.Filtered := False;
  Estado := Inicial;
  try
    SQLQueryAlumno.Close;
    SQLQueryAlumno.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.FormShow(Sender: TObject);
begin
  inherited;
  InicializarVentana; //esto es un workaround porque a veces no entra :(
end;

procedure TProcesoMatriculacion.DBGridAlumnoCellClick(Column: TColumn);
begin
  try
    if (Estado in [Procesando]) then
      case MessageDlg('Guardar cambios',
          'No ha guardado los cambios realizados. ¿Desea guardarlos antes de continuar?',
          mtConfirmation, mbYesNoCancel, 0) of
        mrYes:
        begin
          //guardar
          OKButtonClick(Self);
          AlumnoID := SQLQueryAlumnoID.AsInteger;
        end;
        mrNo:
        begin
          //descartar
          AlumnoID := SQLQueryAlumnoID.AsInteger;
          SGCDDataModule.sqlTran.Rollback;
          SQLQueryAlumno.Close;
          SQLQueryAlumno.Open;
          {reposicionamos el cursor para que se pueda seguir trabajando sobre
          el mismo alumno}
          if not SQLQueryAlumno.Locate('ID', IntToStr(AlumnoID),
            [loCaseInsensitive]) then
            SQLQueryAlumno.First;
        end;
        mrCancel:
        begin
          {reposicionamos el cursor para que se pueda seguir trabajando sobre el mismo
          alumno}
          if not SQLQueryAlumno.Locate('ID', IntToStr(AlumnoID),
            [loCaseInsensitive]) then
            SQLQueryAlumno.First;
          Exit;
        end;
      end
    else
    begin
      AlumnoID := SQLQueryAlumnoID.AsInteger;
    end;
    AbrirCursor;
    GroupBoxMaterias.Visible := True;
    Estado := Procesando;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TProcesoMatriculacion.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if (Estado in [Procesando]) then
    case MessageDlg('Guardar cambios',
        'No ha guardado los cambios realizados. ¿Desea guardarlos antes salir?',
        mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
      begin
        //guardar
        OKButtonClick(Self);
        CanClose := True;
      end;
      mrNo:
      begin
        //descartar
        Cancelar;
        SGCDDataModule.sqlTran.Rollback;
        CanClose := True;
      end;
      mrCancel:
      begin
        CanClose := False;
      end;
    end;
end;

procedure TProcesoMatriculacion.FormCreate(Sender: TObject);
begin
  FAranceles := TMensajeAranceles.Create();
  XMLPropStorage1.Restore;
end;

procedure TProcesoMatriculacion.FormResize(Sender: TObject);
begin
  DBGridMatricula.Width := trunc(Self.Width / 3) - 27;
  DBGridDesarrolloMat.Width := trunc(Self.Width / 3) - 27;
  DBGridMatHab.Width := trunc(Self.Width / 3) - 27;
end;

end.
