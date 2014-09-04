unit frmempleados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ButtonPanel, ExtCtrls, DBGrids, StdCtrls, DBCtrls, EditBtn, frmAbm, DB, sqldb,
  frmsgcddatamodule, frmpersonas;

type

  { TAbmEmpleados }

  TAbmEmpleados = class(TAbmPersonas)
    qryDetalleACTIVO: TSmallintField;
    qryDetalleESADMINISTRATIVO: TSmallintField;
    qryDetalleESCOORDINADOR: TSmallintField;
    qryDetalleESENCARGADO: TSmallintField;
    qryDetalleESPROFESOR: TSmallintField;
    qryDetallePERSONAID: TLongintField;
    SmallintField1: TSmallintField;
    SmallintField2: TSmallintField;
    SmallintField3: TSmallintField;
    SmallintField4: TSmallintField;
    SmallintField5: TSmallintField;
    procedure ButtonInfoContactoClick(Sender: TObject); override;
    procedure CloseButtonClick(Sender: TObject); override;
  private
    FQueryEmp: string;
    procedure SetQueryEmp(AValue: string);
  published
    CheckBoxEncargado: TCheckBox;
    CheckBoxProfesor: TCheckBox;
    CheckBoxAdministrativo: TCheckBox;
    CheckBoxCoordinador: TCheckBox;
    CheckGroupRol: TCheckGroup;
    CheckBoxActivo: TCheckBox;
    CheckGroupActivo: TCheckGroup;
    DatasourceEmpleado: TDatasource;
    SQLQueryEmpleado: TSQLQuery;
    SQLQueryEmpleadoACTIVO: TSmallintField;
    SQLQueryEmpleadoESADMINISTRATIVO: TSmallintField;
    SQLQueryEmpleadoESCOORDINADOR: TSmallintField;
    SQLQueryEmpleadoESENCARGADO: TSmallintField;
    SQLQueryEmpleadoESPROFESOR: TSmallintField;
    SQLQueryEmpleadoPERSONAID: TLongintField;
    procedure MenuItemModificarClick(Sender: TObject); override;
    procedure AbrirCursor; override;
    procedure Actualizar; override;
    procedure Borrar; override;
    procedure CerrarDataset; override;
    function DatosValidos: boolean; override;
    procedure FormCreate(Sender: TObject); override;
    procedure Insertar; override;
    procedure MenuItemNuevoClick(Sender: TObject); override;
    procedure ModificarDatos; override;
    procedure OKButtonClick(Sender: TObject); override;
    property QueryEmp: string read FQueryEmp write SetQueryEmp;
    procedure SQLQueryEmpleadoFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmEmpleados: TAbmEmpleados;

implementation

{$R *.lfm}

{ TAbmEmpleados }
{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
}
procedure TAbmEmpleados.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  //volvemos a cambiar el query principal para mostrar solo empleados
  //el InsQuery no hace falta cambiar
  Self.Query := 'SELECT ID, NOMBRE, APELLIDO, CEDULA, FECHANAC, SEXO ' +
    'FROM PERSONA WHERE EXISTS (SELECT 1 FROM EMPLEADO WHERE PERSONAID = ID)';
  Self.WhereQuery := ' AND NOMBRE CONTAINING UPPER('':PARAMETER'') OR ' +
    'APELLIDO CONTAINING UPPER('':PARAMETER'') OR ' +
    'CEDULA CONTAINING UPPER('':PARAMETER'')';
  Self.QueryEmp := 'SELECT PERSONAID, ACTIVO, ESENCARGADO, ESCOORDINADOR, ' +
    'ESADMINISTRATIVO, ESPROFESOR FROM EMPLEADO';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
 }
procedure TAbmEmpleados.AbrirCursor;
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
  inherited AbrirCursor;
  with SQLQueryEmpleado do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add(QueryEmp);
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

end;

procedure TAbmEmpleados.Actualizar;
begin
  inherited Actualizar;
  SQLQueryEmpleado.Edit;
  if CheckBoxAdministrativo.Checked then
    SQLQueryEmpleadoESADMINISTRATIVO.AsInteger := 1
  else
    SQLQueryEmpleadoESADMINISTRATIVO.AsInteger := 0;
  if CheckBoxCoordinador.Checked then
    SQLQueryEmpleadoESCOORDINADOR.AsInteger := 1
  else
    SQLQueryEmpleadoESCOORDINADOR.AsInteger := 0;
  if CheckBoxEncargado.Checked then
    SQLQueryEmpleadoESENCARGADO.AsInteger := 1
  else
    SQLQueryEmpleadoESENCARGADO.AsInteger := 0;
  if CheckBoxProfesor.Checked then
    SQLQueryEmpleadoESPROFESOR.AsInteger := 1
  else
    SQLQueryEmpleadoESPROFESOR.AsInteger := 0;
  if CheckBoxActivo.Checked then
    SQLQueryEmpleadoACTIVO.AsInteger := 1
  else
    SQLQueryEmpleadoACTIVO.AsInteger := 0;
  SQLQueryEmpleado.ApplyUpdates;
end;

procedure TAbmEmpleados.Borrar;
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

procedure TAbmEmpleados.CerrarDataset;
begin
  //primero cancelamos todo, como en el metodo padre
  SQLQueryEmpleado.Cancel;
  inherited CerrarDataset; //ejecutamos el metodo padre que hace rollback en la DB
  //y cerramos el dataset
  SQLQueryEmpleado.Close;
end;

procedure TAbmEmpleados.Insertar;
begin
  inherited Insertar;
  {movemos el cursor al registro recien insertado}
  SQLQueryEmpleado.Append;
  SQLQueryEmpleadoPERSONAID.AsInteger := x;
  if CheckBoxAdministrativo.Checked then
    SQLQueryEmpleadoESADMINISTRATIVO.AsInteger := 1
  else
    SQLQueryEmpleadoESADMINISTRATIVO.AsInteger := 0;
  if CheckBoxCoordinador.Checked then
    SQLQueryEmpleadoESCOORDINADOR.AsInteger := 1
  else
    SQLQueryEmpleadoESCOORDINADOR.AsInteger := 0;
  if CheckBoxEncargado.Checked then
    SQLQueryEmpleadoESENCARGADO.AsInteger := 1
  else
    SQLQueryEmpleadoESENCARGADO.AsInteger := 0;
  if CheckBoxProfesor.Checked then
    SQLQueryEmpleadoESPROFESOR.AsInteger := 1
  else
    SQLQueryEmpleadoESPROFESOR.AsInteger := 0;
  if CheckBoxActivo.Checked then
    SQLQueryEmpleadoACTIVO.AsInteger := 1
  else
    SQLQueryEmpleadoACTIVO.AsInteger := 0;
  SQLQueryEmpleado.ApplyUpdates;
end;

procedure TAbmEmpleados.SQLQueryEmpleadoFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = SQLQuery1ID.AsInteger;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}

procedure TAbmEmpleados.ModificarDatos;
begin
  //actualizamos el dataset de alumno ahora que se movio el cursor a un nuevo registro
  try
    begin
      SQLQueryEmpleado.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited ModificarDatos;
  if SQLQueryEmpleadoESADMINISTRATIVO.AsInteger = 1 then
    CheckBoxAdministrativo.Checked := True
  else
    CheckBoxAdministrativo.Checked := False;
  if SQLQueryEmpleadoESCOORDINADOR.AsInteger = 1 then
    CheckBoxCoordinador.Checked := True
  else
    CheckBoxCoordinador.Checked := False;
  if SQLQueryEmpleadoESENCARGADO.AsInteger = 1 then
    CheckBoxEncargado.Checked := True
  else
    CheckBoxEncargado.Checked := False;
  if SQLQueryEmpleadoESPROFESOR.AsInteger = 1 then
    CheckBoxProfesor.Checked := True
  else
    CheckBoxProfesor.Checked := False;
  if SQLQueryEmpleadoACTIVO.AsInteger = 1 then
    CheckBoxActivo.Checked := True
  else
    CheckBoxActivo.Checked := False;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
 }
function TAbmEmpleados.DatosValidos: boolean;
begin
  if ((Trim(LabeledEditNuevoNombreS.Text) = '') or
    (Trim(LabeledEditNuevoApellidos.Text) = '') or
    (Trim(LabeledEditNuevoCedula.Text) = '') or (Trim(DateEditFechaNac.Text) = '') or
    not (FechaValida(DateEditFechaNac.Date)) or
    (not CheckBoxProfesor.Checked and not CheckBoxEncargado.Checked and
    not CheckBoxCoordinador.Checked and not CheckBoxAdministrativo.Checked)) then
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

procedure TAbmEmpleados.MenuItemNuevoClick(Sender: TObject);
begin
  inherited MenuItemNuevoClick(Sender);
  CheckGroupActivo.Enabled := False;
  CheckGroupRol.Enabled := True;
end;

procedure TAbmEmpleados.MenuItemModificarClick(Sender: TObject);
begin
  {
   habria que agregar funcionalidad de filtrar por rol
   definir filtros y esa onda
  }
  inherited MenuItemModificarClick(Sender);
  CheckGroupActivo.Enabled := True;
  CheckGroupRol.Enabled := True;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
 }

procedure TAbmEmpleados.OKButtonClick(Sender: TObject);
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
  inherited OKButtonClick(Sender);
end;

procedure TAbmEmpleados.CloseButtonClick(Sender: TObject);
begin
  try
    SQLQuery1.Cancel;
    SQLQueryEmpleado.Cancel;
    SQLQueryDir.Cancel;
    SQLQueryTel.Cancel;
    SQLQuery1.Close;
    SQLQueryEmpleado.Cancel;
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

procedure TAbmEmpleados.ButtonInfoContactoClick(Sender: TObject);
begin
  inherited ButtonInfoContactoClick(Self);
end;

 {
 **************************************************
 SETTERS Y GETTERS
 **************************************************
 }
procedure TAbmEmpleados.SetQueryEmp(AValue: string);
begin
  if FQueryEmp = AValue then
    Exit;
  FQueryEmp := AValue;
end;

end.
