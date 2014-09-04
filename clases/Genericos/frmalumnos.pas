unit frmalumnos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, EditBtn, frmAbm, DB, sqldb,
  frmsgcddatamodule, frmpersonas, frmAcademia, ShellApi;

type

  { TAbmAlumnos }

  TAbmAlumnos = class(TAbmPersonas)
    detACADEMIAS: TStringField;
    detAREAS: TStringField;
    detID: TLongintField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    qryDetalleACTIVO: TSmallintField;
    qryDetalleCONFIRMADO: TSmallintField;
    qryDetallePERSONAID: TLongintField;
    SmallintField1: TSmallintField;
    SmallintField2: TSmallintField;
    det: TSQLQuery;
    StringField3: TStringField;
    StringField4: TStringField;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MenuItemAyudaClick(Sender: TObject);
  private
    FInsQueryAl: string;
    FQueryAl: string;
    FQueryAcad: string;
    FQueryAux: string;
    procedure SetInsQueryAl(AValue: string);
    procedure SetQueryAl(AValue: string);
    procedure SetQueryAcad(AValue: string);
    procedure SetQueryAux(AValue: string);
  published
    ButtonAgregarArea: TButton;
    ButtonEliminarArea: TButton;
    DatasourceArea: TDatasource;
    DatasourceCursa: TDatasource;
    DBGridArea: TDBGrid;
    DBGridCursa: TDBGrid;
    GroupBoxAreas: TGroupBox;
    SQLQueryArea: TSQLQuery;
    SQLQueryAreaID: TLongintField;
    SQLQueryAreaNOMBRE: TStringField;
    SQLQueryCursa: TSQLQuery;
    SQLQueryCursaALUMNOPERSONAID: TLongintField;
    SQLQueryCursaMODULOID: TLongintField;
    StringField2: TStringField;
    ButtonAgregarAcad: TButton;
    ButtonEliminarAcad: TButton;
    CheckBoxActivo: TCheckBox;
    CheckBoxConfirmado: TCheckBox;
    DatasourceAlumno: TDatasource;
    DatasourceAux: TDatasource;
    DatasourceAcad: TDatasource;
    DBGridAcademias: TDBGrid;
    DBGridAcademiaAlumno: TDBGrid;
    GroupBoxAcademia: TGroupBox;
    GroupBoxAlumno: TGroupBox;
    SQLQueryAlumno: TSQLQuery;
    SQLQueryAlumnoACTIVO: TSmallintField;
    SQLQueryAlumnoCONFIRMADO: TSmallintField;
    SQLQueryAlumnoPERSONAID: TLongintField;
    SQLQueryAux: TSQLQuery;
    SQLQueryAcad: TSQLQuery;
    SQLQueryAcadACADEMIAID: TLongintField;
    SQLQueryAcadALUMNOPERSONAID: TLongintField;
    SQLQueryAuxID: TLongintField;
    SQLQueryAuxNOMBRE: TStringField;
    StringField1: TStringField;
    procedure AbrirCursor; override;
    procedure AbrirCursorInfoContacto; override;
    procedure Actualizar; override;
    procedure Borrar; override;
    procedure ButtonAgregarAcadClick(Sender: TObject);
    procedure ButtonEliminarAcadClick(Sender: TObject);
    procedure ButtonInfoContactoClick(Sender: TObject); override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure SQLQueryAcadFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure SQLQueryAlumnoFilterRecord(DataSet: TDataSet; var Accept: boolean);
    procedure OKButtonClick(Sender: TObject); override;
    property QueryAl: string read FQueryAl write SetQueryAl;
    property QueryAcad: string read FQueryAcad write SetQueryAcad;
    property QueryAux: string read FQueryAux write SetQueryAux;
    procedure ButtonABMClick(Sender: TObject);
    procedure ButtonAgregarAreaClick(Sender: TObject);
    procedure ButtonEliminarAreaClick(Sender: TObject);
    procedure CerrarDataset; override;
    procedure CloseButtonClick(Sender: TObject); override;
    procedure FormResize(Sender: TObject);
    procedure SQLQueryCursaFilterRecord(DataSet: TDataSet; var Accept: boolean);
  public
  protected
    // thesqlquerydir : TSQLQuery;
    //thesqlquerytel : TSQLQuery;
    thesqlqueryalumno: TSQLQuery;
    { public declarations }
  end;

var
  AbmAlumnos: TAbmAlumnos;

implementation

{$R *.lfm}
 {
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
 }

procedure TAbmAlumnos.FormCreate(Sender: TObject);
begin
  //Self.InsQuery := 'INSERT INTO PERSONA (ID, NOMBRE, APELLIDO, CEDULA, ' +
  //  'FECHANAC, SEXO) VALUES ( (SELECT COALESCE(MAX(ID), 0)+1 AS ID FROM PERSONA), ' +
  //  ':NOMBRE, :APELLIDO, :CEDULA, :FECHANAC, :SEXO)';



{  IniciaForm('PERSONA', 'ID');

  thesqlquerydir := self.SQLQueryDir;
  thesqlquerytel := self.SQLQueryTel;

  ArmadorQuerys('QueryDir','InsQueryDir',thesqlquerydir,'DIRECCION', 'ID');
  Self.QueryDir:= self.querytabla;
  self.InsQueryDir:= self.insertquery;
  ArmadorQuerys('QueryTel','InsQueryTel',thesqlquerytel,'TELEFONO', 'ID');
  Self.QueryTel:= self.querytabla;
  self.InsQueryTel:= self.insertquery;}
  inherited;
  //volvemos a cambiar el query principal para mostrar solo alumnos
  Self.Query := 'SELECT ID, NOMBRE, APELLIDO, CEDULA, FECHANAC, SEXO ' +
    'FROM PERSONA WHERE EXISTS (SELECT 1 FROM ALUMNO WHERE PERSONAID = ID)';
  Self.WhereQuery := ' AND NOMBRE CONTAINING UPPER('':PARAMETER'') OR ' +
    'APELLIDO CONTAINING UPPER('':PARAMETER'') OR ' +
    'CEDULA CONTAINING UPPER('':PARAMETER'')';
  Self.QueryAl := 'SELECT PERSONAID, ACTIVO, CONFIRMADO FROM ALUMNO';
  thesqlqueryalumno := self.SQLQueryAlumno;
  ArmadorQuerys('QueryAl', 'InsQueryAl', thesqlqueryalumno, 'ALUMNO', 'PERSONAID');
  Self.QueryAl := self.querytabla;
  Self.QueryAcad := 'SELECT ACADEMIAID, ALUMNOPERSONAID FROM ACADEMIA_ALUMNO';
  Self.QueryAux := 'SELECT ID, NOMBRE FROM ACADEMIA';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }

procedure TAbmAlumnos.AbrirCursor;
begin
  with qryDetalle do
  begin
    try
      Close;
      Open;
    except
      on E:
        EDatabaseError do
      begin
        ManejoErrores(E);
      end;
    end;
  end;
  inherited;
  with SQLQueryAlumno do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add(QueryAl);
      Filtered := True;
      Open;
    except
      on E:
        EDatabaseError do
      begin
        ManejoErrores(E);
      end;
    end;
  end;
  with det do
  begin
    try
      Close;
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

procedure TAbmAlumnos.AbrirCursorInfoContacto;
begin
  inherited;
  try
    SQLQueryAcad.Close;
    SQLQueryCursa.Close;
    SQLQueryAux.Close;
    SQLQueryArea.Close;
    {no se que mierda pasa aca que al abrirse acad y cursa le llama al filtro de
    aux y area en vez del suyo, dejo qe filtre al apretar los botones recien
    o sino no anda}
    SQLQueryAux.Filtered := False;
    SQLQueryArea.Filtered := False;

    SQLQueryAcad.Open;
    SQLQueryCursa.Open;
    SQLQueryAux.Open;
    SQLQueryArea.Open;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmAlumnos.Actualizar;
begin
  inherited;
  SQLQueryAlumno.Edit;
  if CheckBoxActivo.Checked then
    SQLQueryAlumnoACTIVO.AsInteger := 1
  else
    SQLQueryAlumnoACTIVO.AsInteger := 0;
  if CheckBoxConfirmado.Checked then
    SQLQueryAlumnoCONFIRMADO.AsInteger := 1
  else
    SQLQueryAlumnoCONFIRMADO.AsInteger := 0;
  SQLQueryAlumno.ApplyUpdates;
end;

procedure TAbmAlumnos.Borrar;
begin
  try
    if not (qryDetalle.Locate('PERSONAID', SQLQuery1ID.AsString,
      [loCaseInsensitive])) then
      raise EDatabaseError.Create('Error. No se encuentran los detalles de la persona');
    if not (qryDetalle.State in [dsInsert, dsEdit]) then
      qryDetalle.Edit;
    qryDetalleACTIVO.AsInteger := 0;
    qryDetalle.ApplyUpdates;
    AbrirCursor;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmAlumnos.CerrarDataset;
begin
  //primero cancelamos todo, como en el metodo padre
  SQLQueryAcad.Cancel;
  SQLQueryAux.Cancel;
  inherited CerrarDataset;//ejecutamos el metodo padre que hace rollback en la DB
  //y cerramos el dataset
  SQLQueryAcad.Close;
  SQLQueryAux.Close;
end;

procedure TAbmAlumnos.Insertar;
begin
  inherited;
  {insertamos los datos especificos del alumno en el dataset de alumno
  por defecto se le pone activo y no confirmado}
  SQLQueryAlumno.Append;
  SQLQueryAlumnoPERSONAID.AsInteger := x;
  if CheckBoxActivo.Checked then
    SQLQueryAlumnoACTIVO.AsInteger := 1
  else
    SQLQueryAlumnoACTIVO.AsInteger := 0;
  if CheckBoxConfirmado.Checked then
    SQLQueryAlumnoCONFIRMADO.AsInteger := 1
  else
    SQLQueryAlumnoCONFIRMADO.AsInteger := 0;
  SQLQueryAlumno.ApplyUpdates;
end;

procedure TAbmAlumnos.SQLQueryAcadFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ALUMNOPERSONAID').AsInteger = SQLQuery1ID.AsInteger;
end;

procedure TAbmAlumnos.SQLQueryAlumnoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = SQLQuery1ID.AsInteger;
end;

procedure TAbmAlumnos.SQLQueryCursaFilterRecord(DataSet: TDataSet; var Accept: boolean);
begin
  Accept := DataSet.FieldByName('ALUMNOPERSONAID').AsInteger = SQLQuery1ID.AsInteger;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}

procedure TAbmAlumnos.FormResize(Sender: TObject);
begin
  GroupBoxAcademia.Width := trunc(Self.Width / 1.526);
  //DBGridAcademiaAlumno.Width := trunc(Self.Width / 2 - 170);
  //DBGridAcademias.Width := trunc(Self.Width / 2 - 170);
  //DBGridArea.Height := trunc(Self.Height / 2 - 299);
  //DBGridCursa.Height := trunc(Self.Height / 2 - 299);
  DBGridAcademiaAlumno.Width := trunc(Self.Width / 3.48);
  DBGridAcademias.Width := trunc(Self.Width / 3.48);
  DBGridArea.Height := trunc(Self.Height / 2 - 299);
  DBGridCursa.Height := trunc(Self.Height / 2 - 299);
end;


procedure TAbmAlumnos.ModificarDatos;
begin
  //actualizamos el dataset de alumno ahora que se movio el cursor a un nuevo registro
  try
    begin
      //SQLQueryAlumno.Filtered:=False;
      //SQLQueryAlumno.Open;
      SQLQueryAlumno.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited; //hacemos lo que esta en la clase padre
  if SQLQueryAlumnoACTIVO.AsInteger = 1 then
    CheckBoxActivo.Checked := True
  else if SQLQueryAlumnoACTIVO.AsInteger = 0 then
    CheckBoxActivo.Checked := False;
  if SQLQueryAlumnoCONFIRMADO.AsInteger = 1 then
    CheckBoxConfirmado.Checked := True
  else if SQLQueryAlumnoCONFIRMADO.AsInteger = 0 then
    CheckBoxConfirmado.Checked := False;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TAbmAlumnos.DatosValidos: boolean;
begin
  if ((Trim(LabeledEditNuevoNombreS.Text) = '') or
    (Trim(LabeledEditNuevoApellidos.Text) = '') or
    (Trim(LabeledEditNuevoCedula.Text) = '') or (Trim(DateEditFechaNac.Text) = '') or
    not (FechaValida(DateEditFechaNac.Date)) or
    {ahora se evalua si estamos en modificacion y no se selecciono ninguna academia
    o area}
    ((Self.Estado in [Modificacion]) and SQLQueryAcad.IsEmpty) or
    ((Self.Estado in [Modificacion]) and SQLQueryCursa.IsEmpty) or
    {evaluamos si estamos en alta y ya se presiono el boton de agregar contacto
    y no se añadio ninguna academia}
    ((Self.Estado in [Alta]) and GroupBoxContacto.Enabled and SQLQueryAcad.IsEmpty) or
    ((Self.Estado in [Alta]) and GroupBoxContacto.Enabled and SQLQueryCursa.IsEmpty) or
    ((Self.Estado in [Alta]) and ButtonInfoContacto.Enabled and
    SQLQueryAcad.IsEmpty)) then
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

procedure TAbmAlumnos.MenuItemNuevoClick(Sender: TObject);
begin
  inherited;
  GroupBoxAcademia.Enabled := False;
  GroupBoxAlumno.Enabled := False;
  GroupBoxAreas.Enabled := False;
end;

procedure TAbmAlumnos.MenuItemModificarClick(Sender: TObject);
begin
  inherited;
  GroupBoxAlumno.Enabled := True;
  GroupBoxAcademia.Enabled := True;
  GroupBoxAreas.Enabled := True;
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

procedure TAbmAlumnos.ButtonAgregarAreaClick(Sender: TObject);
begin
  try
    if not (SQLQueryCursa.State in [dsInsert]) then
      SQLQueryCursa.Append; //si el dataset ya no esta en modo de insercion
    if SQLQueryCursa.Locate('MODULOID', SQLQueryAreaID.AsString,
      [loCaseInsensitive]) then
      Exit;
    SQLQueryCursaALUMNOPERSONAID.AsInteger := SQLQuery1ID.AsInteger;
    SQLQueryCursaMODULOID.AsInteger := SQLQueryAreaID.AsInteger;
    SQLQueryCursa.ApplyUpdates;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmAlumnos.ButtonABMClick(Sender: TObject);
begin
  //TABMAcademia.Create(Self).Show;
end;

procedure TAbmAlumnos.ButtonEliminarAreaClick(Sender: TObject);
begin
  try
    if SQLQueryCursa.IsEmpty then
      Exit;
    SQLQueryCursa.Delete;
    SQLQueryCursa.ApplyUpdates;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmAlumnos.CloseButtonClick(Sender: TObject);
begin
  try
    SQLQuery1.Cancel;
    SQLQueryAlumno.Cancel;
    SQLQueryAcad.Cancel;
    SQLQueryCursa.Cancel;
    SQLQueryDir.Cancel;
    SQLQueryTel.Cancel;
    SQLQuery1.Close;
    SQLQueryAlumno.Close;
    SQLQueryAcad.Close;
    SQLQueryCursa.Close;
    SQLQueryDir.Close;
    SQLQueryTel.Close;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited;
end;

procedure TAbmAlumnos.ButtonInfoContactoClick(Sender: TObject);
begin
  inherited;
  GroupBoxAcademia.Enabled := True;
  GroupBoxAreas.Enabled := True;
end;

procedure TAbmAlumnos.ButtonAgregarAcadClick(Sender: TObject);
begin
  try
    if not (SQLQueryAcad.State in [dsInsert]) then
      SQLQueryAcad.Append; //si el dataset ya no esta en modo de insercion
    if SQLQueryAcad.Locate('ACADEMIAID', SQLQueryAuxID.AsString,
      [loCaseInsensitive]) then
      Exit;
    SQLQueryAcadALUMNOPERSONAID.AsInteger := SQLQuery1ID.AsInteger;
    SQLQueryAcadACADEMIAID.AsInteger := SQLQueryAuxID.AsInteger;
    SQLQueryAcad.ApplyUpdates;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmAlumnos.ButtonEliminarAcadClick(Sender: TObject);
begin
  try
    if SQLQueryAcad.IsEmpty then
      Exit;
    SQLQueryAcad.Delete;
    SQLQueryAcad.ApplyUpdates;
  except
    on E: EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
end;

procedure TAbmAlumnos.OKButtonClick(Sender: TObject);
begin
  // para alta
  if (Self.Estado in [Alta]) then
    if not (DatosValidos) then
      Exit
    else
      try
        if not GroupBoxContacto.Enabled then
          Insertar;
        Guardar;
        AbrirCursor; // para seguir insertando datos
        LimpiarCampos;
        MessageDlg('Informacion', 'Cambios guardados', mtInformation, [mbOK], 0);
        MenuItemNuevoClick(Self);
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
  inherited;
end;

procedure TAbmAlumnos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  inherited;
end;

procedure TAbmAlumnos.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
  ShellExecute(Handle, 'open', 'help\ABMs\alumno.html', nil, nil, 1);
end;

{
 **************************************************
 SETTERS Y GETTERS
 **************************************************
 }
procedure TAbmAlumnos.SetInsQueryAl(AValue: string);
begin
  if FInsQueryAl = AValue then
    Exit;
  FInsQueryAl := AValue;
end;

procedure TAbmAlumnos.SetQueryAl(AValue: string);
begin
  if FQueryAl = AValue then
    Exit;
  FQueryAl := AValue;
end;

procedure TAbmAlumnos.SetQueryAcad(AValue: string);
begin
  if FQueryAcad = AValue then
    Exit;
  FQueryAcad := AValue;
end;


procedure TAbmAlumnos.SetQueryAux(AValue: string);
begin
  if FQueryAux = AValue then
    Exit;
  FQueryAux := AValue;
end;

end.
