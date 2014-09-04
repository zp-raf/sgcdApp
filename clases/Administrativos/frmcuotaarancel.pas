unit frmCuotaArancel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, frmAbm,
  frmsgcddatamodule, strutils;

type

  { TCuotaArancel }

  TCuotaArancel = class(TAbm)
    dsCod: TDatasource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    dsArancel: TDatasource;
    qryArancelID: TLongintField;
    qryArancelMONTO: TFloatField;
    qryArancelNOMBRE: TStringField;
    SQLQuery1ARANCELID: TLongintField;
    SQLQuery1CANTIDADCUOTA: TFloatField;
    SQLQuery1ID: TLongintField;
    SQLQuery1VENCIMIENTO_CANTIDAD: TLongintField;
    SQLQuery1VENCIMIENTO_UNIDAD: TSmallintField;
    NombreArancel: TStringField;
    VencimientoUnidad: TStringField;
    Vencimiento: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    qryCodOBJETO: TStringField;
    qryCodSIGNIFICADO: TStringField;
    qryCodVALOR: TLongintField;
    qryArancel: TSQLQuery;
    qryCod: TSQLQuery;
    procedure Actualizar; override;
    procedure AbrirCursor; override;
    procedure AbrirCursorFiltrado(param: string); override;
    procedure ButtonEliminarFiltrarClick(Sender: TObject);
    procedure ButtonModificarFiltrarClick(Sender: TObject);
    function DatosValidos: boolean; override;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    procedure FormShow(Sender: TObject);
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CuotaArancel: TCuotaArancel;

implementation

{$R *.lfm}

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TCuotaArancel.FormCreate(Sender: TObject);
begin
  IniciaForm('CUOTAXARANCEL', 'ID');
  inherited;
  // Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'')';
  // Self.WhereQuery := ' WHERE ID = (:PARAMETER)';
  // Self.WhereQuery:= 'where id = '+ inttostr (filtroupdate);
end;


{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }


procedure TCuotaArancel.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TCuotaArancel.SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  if ((Estado in [Modificacion]) and (Trim(EditModificarFiltro.Text) = '')) or
    ((Estado in [Baja]) and (Trim(EditEliminarFiltro.Text) = '')) then
    Accept := True
  else if (Estado in [Modificacion]) then
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_ARANCEL').AsString,
      Trim(EditModificarFiltro.Text))
  else
    Accept := AnsiContainsText(DataSet.FieldByName('NOMBRE_ARANCEL').AsString,
      Trim(EditEliminarFiltro.Text));
end;

procedure TCuotaArancel.Insertar;
begin
  SQLQuery1.FieldByName('ID').Required := False;
  //SQLQuery1.Append;
  //SQLQuery1CANTIDADCUOTA.AsInteger := StrToInt(Edit1.Text);
end;

procedure TCuotaArancel.Actualizar;
begin
  //SQLQuery1.Edit;
  //SQLQuery1CANTIDADCUOTA.AsFloat := StrToFloat(Edit1.Text);
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TCuotaArancel.LimpiarCampos;
begin
  inherited;
  //Edit1.Clear;
  //DBLookupComboBox1.Clear;
end;

procedure TCuotaArancel.ModificarDatos;
begin
  if not (SQLQuery1.State in [dsEdit]) then
    SQLQuery1.Edit;
  DBLookupComboBox1.SetFocus;
  //Edit1.Text := IntToStr(SQLQuery1CANTIDADCUOTA.AsInteger);
  //Estado := Modificacion;
  //filtroupdate := SQLQuery1ID.AsInteger;
  //Self.WhereQuery := 'where id = ' + IntToStr(filtroupdate);
end;


{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TCuotaArancel.DatosValidos: boolean;
begin
  if ((SQLQuery1CANTIDADCUOTA.AsInteger <= 0) or
    (SQLQuery1VENCIMIENTO_CANTIDAD.AsInteger <= 0)) then
  begin
    MessageDlg('Informacion', 'Numeros negativos ingresados. Revise los datos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TCuotaArancel.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  inherited;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS MENUS
 ********************************************************
 }

procedure TCuotaArancel.MenuItemNuevoClick(Sender: TObject);
begin
  SQLQuery1.Filtered := False;
  inherited;
  DBLookupComboBox1.SetFocus;
  if not (SQLQuery1.State in [dsInsert, dsEdit]) then
    SQLQuery1.Append;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TCuotaArancel.OKButtonClick(Sender: TObject);
begin
  inherited;
  try
    qryArancel.Close;
    qryArancel.SQL.Clear;
    qryArancel.SQL.SetText('select * from arancel a where a.activo = 1');
    qryArancel.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;

  end;
  if Estado in [Alta] then
    DBLookupComboBox1.SetFocus;
end;


procedure TCuotaArancel.AbrirCursor;
begin
  inherited AbrirCursor;
  try
    //cerrar
    qryArancel.Close;
    qryCod.Close;
    //abrir
    qryArancel.Open;
    qryCod.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TCuotaArancel.AbrirCursorFiltrado(param: string);
begin
  inherited AbrirCursorFiltrado(param);
end;

procedure TCuotaArancel.ButtonEliminarFiltrarClick(Sender: TObject);
begin
  if Trim(EditEliminarFiltro.Text) = '' then
  begin
    SQLQuery1.Filtered := False;
    Exit;
  end
  else
  begin
    SQLQuery1.Filtered := True;
    SQLQuery1.Refresh;
  end;
end;

procedure TCuotaArancel.ButtonModificarFiltrarClick(Sender: TObject);
begin
  if Trim(EditModificarFiltro.Text) = '' then
  begin
    SQLQuery1.Filtered := False;
    Exit;
  end
  else
  begin
    SQLQuery1.Filtered := True;
    SQLQuery1.Refresh;
  end;
end;

end.
