unit frmAbm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, ButtonPanel, EditBtn, StdCtrls, DBCtrls, frmMaestro,
  DB, sqldb, frmsgcddatamodule, LCLType, IBConnection, strutils, BufDataset, ShellApi;

type

  { TAbm }
  TModo = (Inicial, Alta, Baja, Modificacion);

  TAbm = class(TMaestro)
    procedure ButtonPanel1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure EditEliminarFiltroKeyUp(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure EditModificarFiltroKeyUp(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure MenuItemAyudaClick(Sender: TObject);
    procedure SQLQuery1DeleteError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure SQLQuery1EditError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure SQLQuery1PostError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure SQLQuery1UpdateError(Sender: TObject; DataSet: TCustomBufDataset;
      E: EUpdateError; UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    FInsQuery: string;
    FQuery: string;
    FWhereQuery: string;
    procedure SetInsQuery(AValue: string);
    procedure SetQuery(AValue: string);
    procedure SetWhereQuery(AValue: string);
  published
    ButtonEliminarFiltrar: TButton;
    ButtonModificarFiltrar: TButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigatorEliminar: TDBNavigator;
    DBNavigatorModificar: TDBNavigator;
    EditEliminarFiltro: TEdit;
    EditModificarFiltro: TEdit;
    LabelEliminarFiltro: TLabel;
    LabelEliminarGrid: TLabel;
    LabelModificarFiltro: TLabel;
    LabelModificarGrid: TLabel;
    StaticTextEmpezar: TStaticText;
    MenuItemGuardar: TMenuItem;
    ButtonPanel1: TButtonPanel;
    Datasource1: TDatasource;
    MenuItemAcciones: TMenuItem;
    MenuItemNuevo: TMenuItem;
    MenuItemModificar: TMenuItem;
    MenuItemEliminar: TMenuItem;
    PanelEliminar: TPanel;
    PanelModificar: TPanel;
    PanelNuevo: TPanel;
    SQLQuery1: TSQLQuery;
    procedure AbrirCursor; virtual;
    procedure AbrirCursorFiltrado(param: string); virtual;
    procedure Actualizar; virtual abstract;
    procedure ButtonEliminarFiltrarClick(Sender: TObject);
    procedure ButtonModificarFiltrarClick(Sender: TObject);
    procedure CampoNumerico(Sender: TObject; var Key: char; Field: TEdit);
    procedure CerrarDataset; virtual;
    procedure CloseButtonClick(Sender: TObject); virtual;
    function DatosValidos: boolean; virtual abstract;
    procedure DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer); virtual;
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer); virtual;
    procedure DBNavigatorEliminarBeforeAction(Sender: TObject;
      Button: TDBNavButtonType);
    procedure DBNavigatorModificarClick(Sender: TObject; Button: TDBNavButtonType);
    procedure Borrar; virtual;
    function FechaValida(const param: string): boolean;
    function FechaValida(const param: TDateTime): boolean;
    function Filtrar(Cadena: string): string;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject); virtual;
    procedure FormShow(Sender: TObject);
    procedure Guardar; virtual;
    procedure GuardarRefrescar;
    procedure Insertar; virtual abstract;
    procedure Limpiar;
    procedure LimpiarCampos; virtual;
    procedure ManejoErrores(E: EDatabaseError); override;
    procedure MenuItemEliminarClick(Sender: TObject); virtual;
    procedure MenuItemGuardarClick(Sender: TObject); virtual;
    procedure MenuItemModificarClick(Sender: TObject); virtual;
    procedure MenuItemNuevoClick(Sender: TObject); virtual;
    procedure ModificarDatos; virtual abstract;
    procedure OKButtonClick(Sender: TObject); virtual;
    property Query: string read FQuery write SetQuery;
    property InsQuery: string read FInsQuery write SetInsQuery;
    property WhereQuery: string read FWhereQuery write SetWhereQuery;
    procedure IniciaForm(NombreTabla: string; IdentificadorPrincipal: string);
    procedure ArmadorQuerys(querytabla: string; insertquery: string;
      objecttdbquery: TSQLQuery; nombretabla: string; idprincipal: string);
  public
    Estado: TModo;
  protected
    NombreTabla: string;
    IdentificadorPrincipal: string;
    querytabla: string;
    insertquery: string;
    objecttdbquery: TSQLQuery;
    idprincipal: string;
  end;

var
  Abm: TAbm;
  msg: TStringList;

implementation

{$R *.lfm}


{ TAbm }
{
*********************************************
MANEJO DE ERRORES
*********************************************
}

procedure TAbm.ManejoErrores(E: EDatabaseError);
begin
  inherited ManejoErrores(E);
  CerrarDataset;
  Limpiar;
end;

{
 *********************************************
 SETTER Y GETTERS
 *********************************************
}

procedure TAbm.ButtonPanel1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_RETURN then
    Abort;
end;

procedure TAbm.DBGrid1TitleClick(Column: TColumn);
var
  i: integer;
begin
  // apply grid formatting changes here e.g. title styling
  if TDBGrid(Column.Grid).DataSource = nil then
    Exit;
  with TDBGrid(Column.Grid) do
  begin
    for i := 0 to Columns.Count - 1 do
      Columns[i].Title.Font.Style := Columns[i].Title.Font.Style - [fsBold];
    Column.Title.Font.Style := Column.Title.Font.Style + [fsBold];
    with TSQLQuery(DataSource.DataSet) do
    begin
      DisableControls;
      if Active then
        Close;
      IndexFieldNames := Column.FieldName;
      if not Active then
        Open;
      try
        First;
        while not EOF do
        begin
          Next;
        end;
      finally
        EnableControls;
      end;
    end;
  end;
end;

procedure TAbm.EditEliminarFiltroKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Estado in [Baja]) then
    ButtonEliminarFiltrar.Click;
end;

procedure TAbm.EditModificarFiltroKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Estado in [Modificacion]) then
    ButtonModificarFiltrar.Click;
end;

procedure TAbm.MenuItemAyudaClick(Sender: TObject);
begin
  inherited;
  ShellExecute(Handle, 'open', 'help\ABMs\abm.html', nil, nil, 1);
end;

procedure TAbm.SQLQuery1DeleteError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
  ManejoErrores(E);
end;

procedure TAbm.SQLQuery1EditError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
  ManejoErrores(E);
end;

procedure TAbm.SQLQuery1PostError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin
  ManejoErrores(E);
end;

procedure TAbm.SQLQuery1UpdateError(Sender: TObject; DataSet: TCustomBufDataset;
  E: EUpdateError; UpdateKind: TUpdateKind; var Response: TResolverResponse);
begin
  ManejoErrores(E);
end;

procedure TAbm.SetInsQuery(AValue: string);
begin
  if FInsQuery = AValue then
    Exit;
  FInsQuery := AValue;
end;

procedure TAbm.SetQuery(AValue: string);
begin
  if FQuery = AValue then
    Exit;
  FQuery := AValue;
end;

procedure TAbm.SetWhereQuery(AValue: string);
begin
  if FWhereQuery = AValue then
    Exit;
  FWhereQuery := AValue;
end;

{
 ***********************************************
 EVENTOS DE LOS GRIDS
 ***********************************************
 }
procedure TAbm.DBNavigatorEliminarBeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if Button in [nbDelete] then
  begin
    Borrar;
    Abort;
  end;
end;

procedure TAbm.DBNavigatorModificarClick(Sender: TObject; Button: TDBNavButtonType);
begin
  if Button in [nbEdit] then
  begin
    PanelNuevo.Visible := True;
    PanelEliminar.Visible := False;
    PanelModificar.Visible := False;
    ModificarDatos;
  end;
end;

procedure TAbm.DBGrid2DblClick(Sender: TObject);
begin
  PanelNuevo.Visible := True;
  PanelEliminar.Visible := False;
  PanelModificar.Visible := False;
  ModificarDatos;
end;

procedure TAbm.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
begin
  if Button in [mbRight] then
  begin
    try
      msg := TStringList.Create();
      for i := 0 to TDBGrid(Sender).Columns.Count - 1 do
      begin
        msg.Add(TDBGrid(Sender).Columns.Items[i].Field.DisplayName +
          ': ' + TDBGrid(Sender).Columns.Items[i].Field.AsString);
      end;
      MessageDlg('Contenido del registro', msg.Text, mtCustom, [mbOK], 0);
    finally
      msg.Free
    end;
  end;
end;

procedure TAbm.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i: integer;
begin
  if Button in [mbRight] then
  begin
    try
      msg := TStringList.Create();
      for i := 0 to TDBGrid(Sender).Columns.Count - 1 do
      begin
        msg.Add(TDBGrid(Sender).Columns.Items[i].Field.DisplayName +
          ': ' + TDBGrid(Sender).Columns.Items[i].Field.AsString);
      end;
      MessageDlg('Contenido del registro', msg.Text, mtCustom, [mbOK], 0);
    finally
      msg.Free
    end;
  end;
end;

procedure TAbm.DBGrid1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_DELETE) and (not (DBGrid1.EditorMode)) then
  begin
    //borrar la fila actual
    Borrar;
  end;
end;

procedure TAbm.IniciaForm(NombreTabla: string; IdentificadorPrincipal: string);
begin
  Self.NombreTabla := NombreTabla;
  Self.IdentificadorPrincipal := IdentificadorPrincipal;
  self.objecttdbquery := Self.SQLQuery1;
end;

{
 *********************************
 MANEJO DE LOS CURSORES
 *********************************
}

procedure TAbm.FormCreate(Sender: TObject);
begin
  /// self.parametro query
  /// self.parametro insertarquery
  /// query a quitar sus fieldDefs
  //  MessageDlg('Query', 'Query ' + Self.SQLQuery1.SQL.Text , mtError, [mbOK], 0);
  ArmadorQuerys(self.Query, self.InsQuery, self.objecttdbquery,
    self.NombreTabla, self.IdentificadorPrincipal);
  self.Query := self.querytabla;
  self.InsQuery := self.insertquery;
end;


procedure TAbm.ArmadorQuerys(querytabla: string; insertquery: string;
  objecttdbquery: TSQLQuery; nombretabla: string; idprincipal: string);
var
  i: integer;
begin
  //MessageDlg('Query', 'Query ' + Self.SQLQuery1.SQL.Text , mtError, [mbOK], 0);
  Self.querytabla := 'SELECT * FROM ' + nombretabla;
  Self.insertquery := 'INSERT INTO ' + nombretabla + ' ( ';
  //MessageDlg('Query', 'Query ' + IntToStr(Self.objecttdbquery.FieldDefs.Count) , mtError, [mbOK], 0);
  for i := 0 to objecttdbquery.FieldDefs.Count - 1 do
  begin
    //artificio de mierda
    if not (SameText(objecttdbquery.FieldDefs.Items[i].Name, 'CALCID')) then
    begin
      Self.insertquery :=
        Self.insertquery + objecttdbquery.FieldDefs.Items[i].Name;
      if (i < objecttdbquery.FieldDefs.Count - 1) then
        Self.insertquery := Self.insertquery + ', ';
    end;
    //MessageDlg('Query', 'Query ' + Self.InsQuery + 'cantidad de campos: '+ IntToStr(SQLQuery1.FieldDefs.Count) + ' indice ' + IntToStr(i)  , mtError, [mbOK], 0);
  end;
  Self.insertquery := Self.insertquery + ') VALUES ((SELECT COALESCE(MAX(' +
    idprincipal + '), 0)+1 AS ' + idprincipal + ' FROM ' + nombretabla + ')';
  //  MessageDlg('Query', 'Query ' + Self.InsQuery + 'cantidad de campos: '+ IntToStr(SQLQuery1.FieldDefs.Count) + ' indice ' + IntToStr(i)  , mtError, [mbOK], 0);
  for i := 0 to objecttdbquery.FieldDefs.Count - 1 do
  begin
    if not (SameText(objecttdbquery.FieldDefs.Items[i].Name, 'CALCID')) then
    begin
      if not (SameText(objecttdbquery.FieldDefs.Items[i].Name, idprincipal)) then
        Self.insertquery :=
          Self.insertquery + ':' + objecttdbquery.FieldDefs.Items[i].Name;
      if (i < objecttdbquery.FieldDefs.Count - 1) then
        Self.insertquery := Self.insertquery + ', ';
      //            MessageDlg('Query', 'Query ' + self.insertquery + 'cantidad de campos: '+ IntToStr(SQLQuery1.FieldDefs.Count) + ' indice ' + IntToStr(i)  , mtError, [mbOK], 0);
    end;
  end;
  self.insertquery := self.insertquery + ')';
end;

procedure TAbm.AbrirCursor;
begin
  with SQLQuery1 do
  begin
    try
      SQLQuery1.Close;
      SQL.Clear;
      SQL.Add(Query);
      InsertSQL.Clear;
      InsertSQL.Add(InsQuery);
      Open;
    except
      on E:
        EDatabaseError do
      begin
        ManejoErrores(E);
      end;
    end;
  end;
end;

procedure TAbm.AbrirCursorFiltrado(param: string);
begin
  with SQLQuery1 do
  begin
    try
      SQLQuery1.Close;
      SQL.Clear;
      SQL.Add(Query);
      SQL.Add(StringReplace(WhereQuery, ':PARAMETER', param, [rfReplaceAll]));
      InsertSQL.Clear;
      InsertSQL.Add(InsQuery);
      Open;
    except
      on E:
        EDatabaseError do
      begin
        ManejoErrores(E);
      end;
    end;
  end;
end;

{
 ***************************************************************************
 PROCEDIMIENTOS VARIOS PARA LOS QUERYS (VALIDACIONES, APERTURA, CIERRE, ETC)
 ***************************************************************************
 }

procedure TAbm.Borrar;
begin
  //si se requiere hacer algo diferente a borrar el registro se debe overridear
  //el metodo
  SQLQuery1.Delete;
end;

function TAbm.FechaValida(const param: string): boolean;
var
  dtTemp: TDateTime;
begin
  if ((TryStrToDate(param, dtTemp)) or (StrToDate(param) <
    (StrToDate('01/01/1900')))) then
  begin
    MessageDlg('Informacion', 'Fecha no válida', mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

function TAbm.FechaValida(const param: TDateTime): boolean;
begin
  if param < StrToDate('01/01/1900') then
  begin
    MessageDlg('Informacion', 'Fecha no válida', mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TAbm.CampoNumerico(Sender: TObject; var Key: char; Field: TEdit);
begin
  if not (Key in [#8, '0'..'9', DecimalSeparator]) then
  begin
    ShowMessage('Tecla inválida: ' + Key);
    Key := #0;
  end
  else if (Key = DecimalSeparator) and (Pos(Key, Field.Text) > 0) then
  begin
    ShowMessage('Tecla inválida: doble ' + Key);
    Key := #0;
  end;
end;

{ aqui se filtran las cadenas de texto introducidas para sacar los caracteres
  especiales, a fin de evitar una inyeccion SQL }
function TAbm.Filtrar(Cadena: string): string;
var
  tmp: string;
begin
  { se reemplazan los caracteres con espacios en blanco }
  tmp := StringReplace(Cadena, '''', ' ', [rfReplaceAll]);
  tmp := StringReplace(Cadena, '"', ' ', [rfReplaceAll]);
  tmp := StringReplace(Cadena, '/', ' ', [rfReplaceAll]);
  tmp := StringReplace(Cadena, '--', ' ', [rfReplaceAll]);
  tmp := StringReplace(Cadena, '*', ' ', [rfReplaceAll]);
  Result := tmp;
end;

procedure TAbm.CerrarDataset;
begin
  //if (SQLQuery1.State in [dsEdit, dsInsert]) then
  //  SQLQuery1.Cancel;
  SQLQuery1.Close;
  //SGCDDataModule.sqlTran.Rollback;
end;

{ aplica los cambios hechos al dataset, comitea los cambios }
procedure TAbm.Guardar;
begin
  SQLQuery1.ApplyUpdates;
  SGCDDataModule.sqlTran.Commit;
end;

{ aplica los cambios hechos al dataset, comitea los cambios y vuelve a abrir
  el cursor y refrescar el dataset }
procedure TAbm.GuardarRefrescar;
begin
  Guardar;
  SQLQuery1.Open;
  SQLQuery1.Refresh;
end;

{
 *******************************************
 MANEJO DE VENTANA
 *******************************************
}

{ limpia la ventana, ocultando los paneles de alta, baja y modificacion }
procedure TAbm.Limpiar;
begin
  Self.Estado := Inicial;
  PanelNuevo.Visible := False;
  PanelEliminar.Visible := False;
  PanelModificar.Visible := False;
  LimpiarCampos;
end;

{ cierra la ventana}
procedure TAbm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseButtonClick(Self);
  inherited;
end;

{ establece conexion a la base de datos y la asigna al dataset}
{ al heredar se deberia poner aca la en ListaCampos a todos los campos }
{ limpia la ventana }
procedure TAbm.FormShow(Sender: TObject);
begin
  Limpiar;
  try
    SGCDDataModule.dbConn.Connected := True;
    SQLQuery1.DataBase := SGCDDataModule.dbConn;
    SQLQuery1.Transaction := SGCDDataModule.sqlTran;
    SQLQuery1.Close;
    Self.Estado := Inicial;
    //para que salga el listado primero
    MenuItemModificarClick(Self);
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited;
end;

procedure TAbm.LimpiarCampos;
begin
  EditModificarFiltro.Clear;
  EditEliminarFiltro.Clear;
end;

{
 ********************************************
 ACCIONES DE LOS BOTONES DE LA VENTANA
 ********************************************
 }

{ baja }
procedure TAbm.MenuItemEliminarClick(Sender: TObject);
begin
  if not (Estado in [Baja]) then
    CerrarDataset;
  PanelNuevo.Visible := False;
  PanelEliminar.Visible := True;
  PanelModificar.Visible := False;
  Self.Estado := Baja;
  AbrirCursor;
  ButtonEliminarFiltrarClick(Self);
  EditEliminarFiltro.SetFocus;
end;

{ modificacion }
procedure TAbm.MenuItemModificarClick(Sender: TObject);
begin
  if not (Estado in [Modificacion]) then
    CerrarDataset;
  PanelNuevo.Visible := False;
  PanelEliminar.Visible := False;
  PanelModificar.Visible := True;
  Self.Estado := Modificacion;
  ButtonModificarFiltrarClick(Self);
  EditModificarFiltro.SetFocus;
end;

{ alta }
procedure TAbm.MenuItemNuevoClick(Sender: TObject);
begin
  if not (Estado in [Alta]) then
    CerrarDataset;
  LimpiarCampos;
  PanelNuevo.Visible := True;
  PanelEliminar.Visible := False;
  PanelModificar.Visible := False;
  Self.Estado := Alta;
  AbrirCursor;
end;

procedure TAbm.ButtonEliminarFiltrarClick(Sender: TObject);
begin
  with SQLQuery1 do
  begin
    { si el Edit esta vacio o contiene solo espacios }
    if not (Trim(EditEliminarFiltro.Text) = '') then
    begin
      AbrirCursorFiltrado(EditEliminarFiltro.Text);
    end
    else
    begin
      AbrirCursor;
    end;
  end;
  //DBGrid1.Columns[0].Visible := False;
end;

procedure TAbm.ButtonModificarFiltrarClick(Sender: TObject);
begin
  with SQLQuery1 do
  begin
    { si el Edit esta vacio o contiene solo espacios }
    if not (Trim(EditModificarFiltro.Text) = '') then
    begin
      AbrirCursorFiltrado(EditModificarFiltro.Text);
    end
    else
    begin
      AbrirCursor;
    end;
  end;
  //DBGrid2.Columns[0].Visible := False;
end;

{ boton guardar del menu }
procedure TAbm.MenuItemGuardarClick(Sender: TObject);
begin
  OKButtonClick(Self);
end;

{ comitea los cambios de la transaccion }
procedure TAbm.OKButtonClick(Sender: TObject);
begin
  // para alta
  if (Self.Estado in [Alta]) then
  begin
    if not (DatosValidos) then
      Exit
    else
      try
        Insertar;
        Guardar;
        LimpiarCampos;
        MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
        MenuItemNuevoClick(Self); //para seguir insertando
        Exit;
      except
        on E: EDatabaseError do
        begin
          ManejoErrores(E);
          Exit;
        end;
      end;
  end
  //para eliminacion
  else if (Self.Estado in [Baja]) and (SQLQuery1.RowsAffected > 0) then
  begin
    try
      begin
        Guardar;
        AbrirCursor;
        LimpiarCampos;
        MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
      end;
    except
      on E: EDatabaseError do
      begin
        ManejoErrores(E);
        Exit;
      end;
    end;
  end
  //modificacion
  else if ((Self.Estado in [Modificacion]) and (SQLQuery1.State in
    [dsEdit, dsInsert])) then
  begin
    if not (DatosValidos) then
      Exit
    else
      try
        begin
          Actualizar; //PONER EN UPDATE EL DATASET
          Guardar;
          AbrirCursor;
          LimpiarCampos;
          MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
          PanelNuevo.Visible := False;
          PanelEliminar.Visible := False;
          PanelModificar.Visible := True;
        end;
      except
        on E: EDatabaseError do
        begin
          ManejoErrores(E);
          Exit;
        end;
      end;
  end
  else
  begin
    MessageDlg('Informacion', 'Nada que guardar', mtInformation, [mbOK], 0);
  end;
end;

{ chequea si hay cambios pendientes y pregunta que hacer}
procedure TAbm.CloseButtonClick(Sender: TObject);
begin
  try
    if (SQLQuery1.State in [dsEdit, dsInsert]) then
      if (MessageDlg('Confirmar saldia',
        'Hay cambios sin guardar. ¿Realmente desea salir?', mtConfirmation,
        mbYesNo, 0, mbYes) = mrNo) then
        Abort;
    SQLQuery1.Close;
    SQLQuery1.SQL.Clear;
    SQLQuery1.InsertSQL.Clear;
    SGCDDataModule.sqlTran.Active := False;
    SGCDDataModule.dbConn.Connected := False;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited;
end;

end.
