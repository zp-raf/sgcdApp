unit frmgenerardeuda;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, PairSplitter, DBGrids, DBCtrls, ExtCtrls, frmProceso,
  sqldb, DB, variants, strutils, ButtonPanel, frmsgcddatamodule, ShellApi;

const
  nullValue = 'null';

type

  { TProcesoGenerarDeuda }

  TProcesoGenerarDeuda = class(TProceso)
    Alumnos: TGroupBox;
    Aranceles: TGroupBox;
    CheckGroup1: TCheckGroup;
    dsAr: TDatasource;
    LabeledEdit2: TLabeledEdit;
    qryALUMNO_CONFIRMADO: TSmallintField;
    qryAPELLIDO: TStringField;
    qryArID: TLongintField;
    qryArMONTO: TFloatField;
    qryArNOMBRE: TStringField;
    qryCEDULA: TStringField;
    qryDERECHOEXAMEN: TSmallintField;
    qryDESARROLLOMATERIAID: TLongintField;
    qryDeudaACTIVO: TSmallintField;
    qryDeudaARANCELID: TLongintField;
    qryDeudaCANTIDAD: TLongintField;
    qryDeudaCANT_CUOTAS: TLongintField;
    qryDeudaCUOTA_NRO: TLongintField;
    qryDeudaDESCRIPCION: TStringField;
    qryDeudaFECHA_DEUDA: TDateField;
    qryDeudaID: TLongintField;
    qryDeudaMATRICULAID: TLongintField;
    qryDeudaMONTO_DEUDA: TFloatField;
    qryDeudaMONTO_PAGADO: TFloatField;
    qryDeudaPERSONAID: TLongintField;
    qryDeudaSALDO: TFloatField;
    qryDeudaVENCIMIENTO: TDateField;
    qryEMPLEADOPERSONAID: TLongintField;
    qryFECHA: TDateField;
    qryFECHANAC: TDateField;
    qryGRUPOID: TLongintField;
    qryID: TLongintField;
    qryID_MATRICULA: TLongintField;
    qryMATERIAID: TLongintField;
    qryMATRICULA_CONFIRMADA: TSmallintField;
    qryMODULOID: TLongintField;
    qryNOMBRE: TStringField;
    qryNOMBRE_GRUPO: TStringField;
    qryNOMBRE_MATERIA: TStringField;
    qryNOMBRE_MATERIA_DET: TStringField;
    qryNOMBRE_MOD: TStringField;
    qryNOMBRE_PERIODO: TStringField;
    qryNOMBRE_PROFESOR: TStringField;
    qryNOMBRE_SECCION: TStringField;
    qryOBSERVACIONES: TStringField;
    qryPERIODOLECTIVOID: TLongintField;
    qryPerNOMBRE_PERIODO: TStringField;
    qryPerPERIODOLECTIVOID: TLongintField;
    qryProEMPLEADOPERSONAID: TLongintField;
    qryProNOMBRE_PROFESOR: TStringField;
    qrySECCIONID: TLongintField;
    qrySEXO: TStringField;
    SeleccionarTodo: TButton;
    SeleccionarNada: TButton;
    dsPer: TDatasource;
    dsPro: TDatasource;
    LabeledEdit1: TLabeledEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    ds: TDatasource;
    dsDes: TDatasource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Profesor: TLabel;
    Periodo: TLabel;
    Materia: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    qryDes: TSQLQuery;
    qry: TSQLQuery;
    qryDesDESARROLLOMATERIAID: TLongintField;
    qryDesNOMBRE_MATERIA_DET: TStringField;
    qryPer: TSQLQuery;
    qryPro: TSQLQuery;
    qryAr: TSQLQuery;
    qryDeuda: TSQLQuery;
    procedure AbrirCursor;
    procedure ActualizarQry(Sender: TObject);
    procedure ActualizarQry(Sender: TObject; Index: integer);
    procedure CancelButtonClick(Sender: TObject); override;
    procedure CheckGroup1ItemClick(Sender: TObject; Index: integer);
    procedure FormCreate(Sender: TObject); override;
    procedure LabeledEdit2Change(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject); override;
    procedure qryArFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SeleccionarNadaClick(Sender: TObject);
    procedure SeleccionarTodoClick(Sender: TObject);
    procedure TDBGridTitleClick(Column: TColumn); override;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoGenerarDeuda: TProcesoGenerarDeuda;

implementation

{$R *.lfm}

{ TProcesoGenerarDeuda }

procedure TProcesoGenerarDeuda.AbrirCursor;
begin
  try
    qryAr.Close;
    qry.Close;
    qryDes.Close;
    qryPer.Close;
    qryPro.Close;
    qryDeuda.Close;
    qryAr.Open;
    qry.Open;
    qryDes.Open;
    qryPer.Open;
    qryPro.Open;
    qryDeuda.Open;
  except
    on E: EDatabaseError do
      ManejoErrores(E);
  end;
end;

procedure TProcesoGenerarDeuda.ActualizarQry(Sender: TObject);
begin
  qry.Refresh;
end;

procedure TProcesoGenerarDeuda.ActualizarQry(Sender: TObject; Index: integer);
begin
  qry.Refresh;
end;

procedure TProcesoGenerarDeuda.CancelButtonClick(Sender: TObject);
begin
  try
    qry.Cancel;
    AbrirCursor;
  except
    on E: EDatabaseError do
      ManejoErrores(E);
  end;
end;

procedure TProcesoGenerarDeuda.CheckGroup1ItemClick(Sender: TObject; Index: integer);
begin
  qry.Refresh;
end;

procedure TProcesoGenerarDeuda.FormCreate(Sender: TObject);
begin
  AbrirCursor;
end;

procedure TProcesoGenerarDeuda.LabeledEdit2Change(Sender: TObject);
begin
  qryAr.Refresh;
end;

procedure TProcesoGenerarDeuda.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\genDeuda.html ', nil, nil, 1);
end;

procedure TProcesoGenerarDeuda.OKButtonClick(Sender: TObject);
var
  i, j, selectedRows1, selectedRows2: integer;
begin
  {
  Selected rows solo cuenta las filas que estan seleccionadas con CTRL
  las otras no
  Por eso cuando no hay ninguna fila seleccionada con CTRL usamos la posicion
  actual del cursor en vez de la fila seleccionada (porque no hay ninguna
  seleccionada!)
  Usamos el artificio de dos variables auxialiares que guarden el numero de
  filas seleccionadas a fin de evitar mas lineas de codigo que hagan lo mismo
  cuando no haya filas seleccionadas con CTRL ponemos en '1' la variable que
  corresponde a la fila y asi se ejecuta solo una vez el ciclo que le corresponde
  La propiedad DBGrid1.SelectedRows.Count verificamos si es mayor a 0 antes de
  usar la lista de bookmarks para no causar un error fatal
  }
  if (DBGrid1.SelectedRows.Count > 0) then
    selectedRows1 := DBGrid1.SelectedRows.Count
  else
    selectedRows1 := 1;
  if (DBGrid2.SelectedRows.Count > 0) then
    selectedRows2 := DBGrid2.SelectedRows.Count
  else
    selectedRows2 := 1;

  try
    for i := 0 to selectedRows1 - 1 do
    begin
      //por cada celda seleccionada corremos
      if (DBGrid1.SelectedRows.Count > 0) then
        qry.GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));
      //creamos una deuda nueva por cada arancel seleccionado
      for j := 0 to selectedRows2 - 1 do
      begin
        if (DBGrid2.SelectedRows.Count > 0) then
          qryAr.GotoBookmark(Pointer(DBGrid2.SelectedRows.Items[j]));
        //insert into deuda
        //if not qryDeuda.State in [dsEdit, dsInsert] then
        qryDeuda.Append;
        qryDeudaID.AsInteger := SGCDDataModule.SiguienteValor('GENERATOR_DEUDA');
        qryDeudaARANCELID.Value := qryArID.Value;
        qryDeudaPERSONAID.Value := qryID.Value;
        qryDeudaACTIVO.AsInteger := 1;
        qryDeudaMONTO_DEUDA.Value := qryArMONTO.Value;
        qryDeudaMONTO_PAGADO.Value := 0.0; //todavia no se pago nada
        qryDeudaFECHA_DEUDA.Value := Now;
        qryDeudaDESCRIPCION.Value :=
          'Deuda de ' + qryArNOMBRE.AsString + ' - ' + qryNOMBRE.AsString +
          ' ' + qryAPELLIDO.AsString;
        qryDeudaCANTIDAD.AsInteger := 1;
      end;
    end;
    qryDeuda.ApplyUpdates;
    SGCDDataModule.sqlTran.Commit;
    MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
      AbrirCursor;
    end;
  end;
end;

procedure TProcesoGenerarDeuda.qryArFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  with LabeledEdit2 do
  begin
    if (Trim(Text) = '') then
      Accept := True
    else
      Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString, Trim(Text));
  end;
end;

procedure TProcesoGenerarDeuda.qryFilterRecord(DataSet: TDataSet; var Accept: boolean);
var
  c1, c2, c3, c4, c5: boolean;
begin
  if (Trim(DBLookupComboBox1.Text) = '') then
    c1 := True
  else
    c1 := DataSet.FieldByName('DESARROLLOMATERIAID').AsInteger =
      qryDesDESARROLLOMATERIAID.AsInteger;

  if (Trim(DBLookupComboBox2.Text) = '') then
    c2 := True
  else
    c2 := DataSet.FieldByName('PERIODOLECTIVOID').AsInteger =
      qryPerPERIODOLECTIVOID.AsInteger;

  if (Trim(DBLookupComboBox3.Text) = '') then
    c3 := True
  else
    c3 := DataSet.FieldByName('EMPLEADOPERSONAID').AsInteger =
      qryProEMPLEADOPERSONAID.AsInteger;

  with LabeledEdit1 do
  begin
    if (Trim(Text) = '') then
      c4 := True
    else
      c4 := AnsiContainsText(DataSet.FieldByName('NOMBRE').AsString, Trim(Text)) or
        AnsiContainsText(DataSet.FieldByName('APELLIDO').AsString, Trim(Text)) or
        AnsiContainsText(DataSet.FieldByName('CEDULA').AsString, Trim(Text));
  end;

  with CheckGroup1 do
  begin
    if Checked[0] and Checked[1] then
      c5 := True
    else if Checked[0] and not Checked[1] then
      if DataSet.FieldByName('ALUMNO_CONFIRMADO').AsInteger = 1 then
        c5 := True
      else
        c5 := False
    else if Checked[1] and not Checked[0] then
      if DataSet.FieldByName('ALUMNO_CONFIRMADO').AsInteger = 0 then
        c5 := True
      else
        c5 := False
    else
      c5 := False;
  end;

  Accept := c1 and c2 and c3 and c4 and c5;
end;

procedure TProcesoGenerarDeuda.SeleccionarNadaClick(Sender: TObject);
begin
  with DBGrid1 do
  begin
    SelectedRows.Clear;
    DataSource.DataSet.First;
  end;
end;

procedure TProcesoGenerarDeuda.SeleccionarTodoClick(Sender: TObject);
begin
  SeleccionarNadaClick(nil);
  with DBGrid1.DataSource.DataSet do
  begin
    DisableControls;
    First;
    try
      while not EOF do
      begin
        DBGrid1.SelectedRows.CurrentRowSelected := True;
        Next;
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure TProcesoGenerarDeuda.TDBGridTitleClick(Column: TColumn);
begin
  inherited TDBGridTitleClick(Column);
end;

end.
