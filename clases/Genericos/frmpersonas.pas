unit frmpersonas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, EditBtn, frmAbm, DB, sqldb,
  frmsgcddatamodule, ShellApi;

type

  { TAbmPersonas }

  TAbmPersonas = class(TAbm)
    qryDetalle: TSQLQuery;
    procedure MenuItemAyudaClick(Sender: TObject);
  private
    FInsQueryDir: string;
    FInsQueryTel: string;
    FQueryDir: string;
    FQueryTel: string;
    Fx: integer;
    procedure SetInsQueryDir(AValue: string);
    procedure SetInsQueryTel(AValue: string);
    procedure SetQueryDir(AValue: string);
    procedure SetQueryTel(AValue: string);
    procedure Setx(AValue: integer);
  published
    ButtonInfoContacto: TButton;
    DatasourceTel: TDatasource;
    DatasourceDir: TDatasource;
    DateEditFechaNac: TDateEdit;
    DBGridTel: TDBGrid;
    DBGridDir: TDBGrid;
    DBNavigatorDir: TDBNavigator;
    DBNavigatorTel: TDBNavigator;
    GroupBoxContacto: TGroupBox;
    GroupBoxBasica: TGroupBox;
    LabelTelefonos: TLabel;
    LabelDirecciones: TLabel;
    LabelNuevoFechaNac: TLabel;
    LabeledEditNuevoNombres: TLabeledEdit;
    LabeledEditNuevoApellidos: TLabeledEdit;
    LabeledEditNuevoCedula: TLabeledEdit;
    RadioButtonF: TRadioButton;
    RadioButtonM: TRadioButton;
    RadioGroupSexo: TRadioGroup;
    SQLQuery1APELLIDO: TStringField;
    SQLQuery1CEDULA: TStringField;
    SQLQuery1FECHANAC: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRE: TStringField;
    SQLQuery1SEXO: TStringField;
    SQLQueryDir: TSQLQuery;
    SQLQueryDirBARRIO: TStringField;
    SQLQueryDirCIUDAD: TStringField;
    SQLQueryDirDEPARTAMENTO: TStringField;
    SQLQueryDirDESCRIPCION: TStringField;
    SQLQueryDirDIRECCION: TStringField;
    SQLQueryDirID: TLongintField;
    SQLQueryDirIDPERSONA: TLongintField;
    SQLQueryTel: TSQLQuery;
    SQLQueryTelDESCRIPCION: TStringField;
    SQLQueryTelID: TLongintField;
    SQLQueryTelIDPERSONA: TLongintField;
    SQLQueryTelNUMERO: TStringField;
    SQLQueryTelPREFIJO: TStringField;
    procedure AbrirCursor; override;
    procedure AbrirCursorInfoContacto; virtual;
    procedure Actualizar; override;
    function DatosValidos: boolean; override;
    procedure CerrarDataset; override;
    procedure CloseButtonClick(Sender: TObject); override;
    procedure FormCreate(Sender: TObject); override;
    procedure Guardar; override;
    procedure Insertar; override;
    procedure LimpiarCampos; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    property QueryDir: string read FQueryDir write SetQueryDir;
    property InsQueryDir: string read FInsQueryDir write SetInsQueryDir;
    property QueryTel: string read FQueryTel write SetQueryTel;
    property InsQueryTel: string read FInsQueryTel write SetInsQueryTel;
    procedure ButtonInfoContactoClick(Sender: TObject); virtual;
    procedure MenuItemModificarClick(Sender: TObject); override;
    function SiguienteValor(Field: ansistring; Table: ansistring): integer;
    procedure SQLQueryDirAfterInsert(DataSet: TDataSet);
    procedure SQLQueryDirFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryTelAfterInsert(DataSet: TDataSet);
    procedure SQLQueryTelFilterRecord(DataSet: TDataSet; var Accept: boolean);
    property x: integer read Fx write Setx;
  public

  protected
           thesqlquerydir : TSQLQuery;
           thesqlquerytel : TSQLQuery;
    { public declarations }
  end;

var
  AbmPersonas: TAbmPersonas;


implementation

{$R *.lfm}
{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TAbmPersonas.FormCreate(Sender: TObject);
begin
{  Self.Query := 'SELECT ID, NOMBRE, APELLIDO, CEDULA, FECHANAC, SEXO FROM PERSONA';
  Self.WhereQuery := ' WHERE NOMBRE CONTAINING UPPER('':PARAMETER'') OR ' +
    'APELLIDO CONTAINING UPPER('':PARAMETER'') OR ' +
    'CEDULA CONTAINING UPPER('':PARAMETER'')';
  QueryDir := 'SELECT * FROM DIRECCION';
  InsQueryDir := 'INSERT INTO DIRECCION (ID, IDPERSONA, DIRECCION, CIUDAD, ' +
    'BARRIO, DEPARTAMENTO, DESCRIPCION) VALUES ( ' +
    '(SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM DIRECCION), :IDPERSONA, ' +
    ':DIRECCION, :CIUDAD, :BARRIO, :DEPARTAMENTO, :DESCRIPCION)';
  QueryTel := 'SELECT * FROM TELEFONO';
  InsQueryTel := 'INSERT INTO TELEFONO (ID, IDPERSONA, PREFIJO, NUMERO, ' +
    'DESCRIPCION) VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM TELEFONO), ' +
    ':IDPERSONA, :PREFIJO, :NUMERO, :DESCRIPCION)';}
    IniciaForm('PERSONA', 'ID');
    inherited;

    thesqlquerydir := self.SQLQueryDir;
    thesqlquerytel := self.SQLQueryTel;
    ArmadorQuerys('QueryDir','InsQueryDir',thesqlquerydir,'DIRECCION', 'ID');
    Self.QueryDir:= self.querytabla;
    self.InsQueryDir:= self.insertquery;
    ArmadorQuerys('QueryTel','InsQueryTel',thesqlquerytel,'TELEFONO', 'ID');
    Self.QueryTel:= self.querytabla;
    self.InsQueryTel:= self.insertquery;
end;



{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmPersonas.AbrirCursor;
begin
  with SQLQuery1 do
  begin
    try
      Close;
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

procedure TAbmPersonas.AbrirCursorInfoContacto;
begin
  with SQLQueryDir do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add(QueryDir);
      InsertSQL.Clear;
      InsertSQL.Add(InsQueryDir);
      Filtered := True;
      Open;
      SQLQueryDir.FieldByName('ID').Required := False;
      DBGridDir.Columns[0].Visible := False;
      DBGridDir.Columns[1].Visible := False;
    except
      on E:
        EDatabaseError do
      begin
        ManejoErrores(E);
      end;
    end;
  end;
  with SQLQueryTel do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add(QueryTel);
      InsertSQL.Clear;
      InsertSQL.Add(InsQueryTel);
      Filtered := True;
      Open;
      SQLQueryDir.FieldByName('ID').Required := False;
      DBGridTel.Columns[0].Visible := False;
      DBGridTel.Columns[1].Visible := False;
    except
      on E:
        EDatabaseError do
      begin
        ManejoErrores(E);
      end;
    end;
  end;
end;

procedure TAbmPersonas.Insertar;
begin
  SQLQuery1.Append;
  SQLQuery1NOMBRE.AsString := LabeledEditNuevoNombres.Text;
  SQLQuery1APELLIDO.AsString := LabeledEditNuevoApellidos.Text;
  SQLQuery1CEDULA.AsString := LabeledEditNuevoCedula.Text;
  SQLQuery1FECHANAC.AsDateTime := DateEditFechaNac.Date;
  if RadioButtonF.Checked then
    SQLQuery1SEXO.AsString := 'F'
  else if RadioButtonM.Checked then
    SQLQuery1SEXO.AsString := 'M';
  Self.x := SiguienteValor('ID', 'PERSONA');
  SQLQuery1ID.AsInteger := Self.x;
  { se guarda en cache pero no se comitea, en caso
    de que el usuario no quiera guardar los cambios }
  SQLQuery1.ApplyUpdates;
  { AL USAR LA PROPIEDAD X PARA GUARDAR EL AUTOINCREMENTO NO ES NECESARIO HACER
    LO QUE VIENE A CONTINUACION }
   {refrescamos el dataset para obtener todos los datos
    del registro recien insertado y poder asignar al FK
    de telefono y direccion}
  //SQLQuery1.Refresh;
   {se debe posicionar el cursor en el nuevo registro, para ello buscamos
    con locate por la cedula recien insertada ya que es un campo unico
    si falla la busqueda o no se encuentra el registro pasamos al ultimo registro}
  //if not SQLQuery1.Locate('CEDULA', LabeledEditNuevoCedula.Text,
  //  [loCaseInsensitive]) then
  //  SQLQuery1.Last;
end;

procedure TAbmPersonas.Actualizar;
begin
  SQLQuery1.Edit;
  SQLQuery1NOMBRE.AsString := LabeledEditNuevoNombres.Text;
  SQLQuery1APELLIDO.AsString := LabeledEditNuevoApellidos.Text;
  SQLQuery1CEDULA.AsString := LabeledEditNuevoCedula.Text;
  SQLQuery1FECHANAC.AsDateTime := DateEditFechaNac.Date;
  if RadioButtonF.Checked then
    SQLQuery1SEXO.AsString := 'F'
  else if RadioButtonM.Checked then
    SQLQuery1SEXO.AsString := 'M';
  SQLQuery1.ApplyUpdates;
end;

procedure TAbmPersonas.Guardar;
begin
  if (Self.Estado in [Alta, Modificacion]) then
  begin
    {si no se desea meter informacion de contacto entonces no hace falta guardar
    los dataset de direccion y telefono}
    if GroupBoxContacto.Enabled then
    begin
      SQLQueryDir.ApplyUpdates; //guardar los cambios de direccion y telefono
      SQLQueryTel.ApplyUpdates; //persona ya esta guardado
      SQLQuery1.ApplyUpdates;
    end
    else
      SQLQuery1.ApplyUpdates;
    //si no se presiono el boton de agregar contacto hay que guardar los cambios
  end;
  if (Self.Estado in [Baja]) then
    SQLQuery1.ApplyUpdates;  //si hay baja solo hay que guardar lo del query principal
  SGCDDataModule.sqlTran.Commit; //y aca recien comitear
end;

procedure TAbmPersonas.CerrarDataset;
begin
  SQLQuery1.Cancel;
  SQLQueryDir.Cancel;
  SQLQueryTel.Cancel;
  SGCDDataModule.sqlTran.Rollback;
  SQLQuery1.Close;
  SQLQueryDir.Close;
  SQLQueryTel.Close;
end;

function TAbmPersonas.SiguienteValor(Field: ansistring; Table: ansistring): integer;
var
  qry: string;
  qry_resul: integer;
begin
  qry := 'SELECT COALESCE(MAX(' + Field + '), 0)+1 AS RESUL FROM ' + Table;
  qry_resul := StrToInt(SGCDDataModule.DevuelveValor(qry, 'RESUL'));
  Result := qry_resul;
end;

procedure TAbmPersonas.SQLQueryDirAfterInsert(DataSet: TDataSet);
begin
  SQLQueryDirIDPERSONA.AsInteger := SQLQuery1ID.AsInteger;
end;

procedure TAbmPersonas.SQLQueryDirFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('IDPERSONA').AsInteger = SQLQuery1ID.AsInteger;
end;

procedure TAbmPersonas.SQLQueryTelAfterInsert(DataSet: TDataSet);
begin
  SQLQueryTelIDPERSONA.AsInteger := SQLQuery1ID.AsInteger;
end;

procedure TAbmPersonas.SQLQueryTelFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('IDPERSONA').AsInteger = SQLQuery1ID.AsInteger;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmPersonas.LimpiarCampos;
begin
  inherited;
  LabeledEditNuevoNombres.Clear;
  LabeledEditNuevoApellidos.Clear;
  LabeledEditNuevoCedula.Clear;
  DateEditFechaNac.Clear;
  EditModificarFiltro.Clear;
  EditEliminarFiltro.Clear;
end;

procedure TAbmPersonas.ModificarDatos;
begin
  LabeledEditNuevoNombres.Text := SQLQuery1NOMBRE.AsString;
  LabeledEditNuevoApellidos.Text := SQLQuery1APELLIDO.AsString;
  LabeledEditNuevoCedula.Text := SQLQuery1CEDULA.AsString;
  if SQLQuery1SEXO.AsString = 'M' then
    RadioButtonM.Checked := True
  else if SQLQuery1SEXO.AsString = 'F' then
    RadioButtonF.Checked := True;
  DateEditFechaNac.Date := SQLQuery1FECHANAC.AsDateTime;
  AbrirCursorInfoContacto;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TAbmPersonas.DatosValidos: boolean;
begin
  if ((Trim(LabeledEditNuevoNombreS.Text) = '') or
    (Trim(LabeledEditNuevoApellidos.Text) = '') or
    (Trim(LabeledEditNuevoCedula.Text) = '') or (Trim(DateEditFechaNac.Text) = '') or
    not (FechaValida(DateEditFechaNac.Date))) then
  begin
    MessageDlg('Informacion', 'Complete los campos requeridos',
      mtInformation, [mbOK], 0);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS MENUS
 ********************************************************
 }
procedure TAbmPersonas.MenuItemModificarClick(Sender: TObject);
begin
  inherited;
  ButtonInfoContacto.Visible := False;
  GroupBoxContacto.Enabled := True;
end;

procedure TAbmPersonas.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  ButtonInfoContacto.Visible := True;
  ButtonInfoContacto.Enabled := True;
  try
    SQLQueryTel.Close;
    SQLQueryDir.Close;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  LabeledEditNuevoNombres.SetFocus;
  GroupBoxContacto.Enabled := False;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

 {
 en este caso necesariamente se debe insertar la informacion de la persona
 antes de asignarle direccion y telefono para mantener la integridad referencial
}
procedure TAbmPersonas.ButtonInfoContactoClick(Sender: TObject);
begin
  try
    //deshabilitamos el boton para evitar nuevos clicks
    ButtonInfoContacto.Enabled := False;
    if DatosValidos then
    begin
      Insertar;
      {se abren los dataset de direccion
      y telefono y ya se pueden insertar datos  }
      AbrirCursorInfoContacto;
      GroupBoxContacto.Enabled := True; //habilitamos el panel
    end
    else
    begin
      ButtonInfoContacto.Enabled := True;
      Exit;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ButtonInfoContacto.Enabled := True;
      ManejoErrores(E);
      Exit;
    end;
  end;
end;

procedure TAbmPersonas.OKButtonClick(Sender: TObject);
begin
  inherited;
  if Estado in [Alta] then
    LabeledEditNuevoNombres.SetFocus;
end;

procedure TAbmPersonas.CloseButtonClick(Sender: TObject);
begin
  try
    Estado := Inicial;
    SQLQuery1.Close;
    SQLQueryDir.Close;
    SQLQueryTel.Close;
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

procedure TAbmPersonas.MenuItemAyudaClick(Sender: TObject);
begin
  //inherited;
    ShellExecute(Handle, 'open', 'help\ABMs\personal.html', nil, nil, 1);
end;

{
 **************************************************
 SETTERS Y GETTERS
 **************************************************
 }
procedure TAbmPersonas.SetInsQueryDir(AValue: string);
begin
  if FInsQueryDir = AValue then
    Exit;
  FInsQueryDir := AValue;
end;

procedure TAbmPersonas.SetInsQueryTel(AValue: string);
begin
  if FInsQueryTel = AValue then
    Exit;
  FInsQueryTel := AValue;
end;

procedure TAbmPersonas.SetQueryDir(AValue: string);
begin
  if FQueryDir = AValue then
    Exit;
  FQueryDir := AValue;
end;

procedure TAbmPersonas.SetQueryTel(AValue: string);
begin
  if FQueryTel = AValue then
    Exit;
  FQueryTel := AValue;
end;

procedure TAbmPersonas.Setx(AValue: integer);
begin
  if Fx = AValue then
    Exit;
  Fx := AValue;
end;

end.
