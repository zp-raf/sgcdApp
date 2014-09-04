unit frmpersonasext;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, ExtCtrls, DBGrids, DBCtrls, EditBtn, frmpersonas, DB,
  sqldb, frmAbm, ShellApi;

type

  { TAbmPersonasExt }

  TAbmPersonasExt = class(TAbmPersonas)
    Proveedor: TCheckBox;
    qryDetalleACTIVO: TSmallintField;
    qryDetalleESENCARGADO: TSmallintField;
    qryDetalleESINTERVENTOR: TSmallintField;
    qryDetalleESPROVEEDOR: TSmallintField;
    qryDetalleESVEEDOR: TSmallintField;
    qryDetallePERSONAID: TLongintField;
    SmallintField1: TSmallintField;
    SmallintField2: TSmallintField;
    SmallintField3: TSmallintField;
    SmallintField4: TSmallintField;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQueryExtACTIVO: TSmallintField;
    SQLQueryExtESENCARGADO: TSmallintField;
    SQLQueryExtESINTERVENTOR: TSmallintField;
    SQLQueryExtESPROVEEDOR: TSmallintField;
    SQLQueryExtESVEEDOR: TSmallintField;
    SQLQueryExtPERSONAID: TLongintField;
    procedure CloseButtonClick(Sender: TObject); override;
    procedure MenuItemAyudaClick(Sender: TObject);
  private
    FQueryExt: string;
    procedure SetQueryExt(AValue: string);
  published
    CheckBoxActivo: TCheckBox;
    CheckBoxEncargado: TCheckBox;
    CheckGroupActivo: TCheckGroup;
    CheckGroupRol: TCheckGroup;
    DatasourceExt: TDatasource;
    RadioGroupExaminador: TRadioGroup;
    SQLQueryExt: TSQLQuery;
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
    property QueryExt: string read FQueryExt write SetQueryExt;
    procedure SQLQueryExtFilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AbmPersonasExt: TAbmPersonasExt;

implementation

{$R *.lfm}

{ TAbmPersonasExt }

{
 ****************************************
 QUERYS DE LA VISTA A UTILIZAR
 ****************************************
}

procedure TAbmPersonasExt.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  Self.Query := 'SELECT ID, NOMBRE, APELLIDO, CEDULA, FECHANAC, SEXO ' +
    'FROM PERSONA WHERE EXISTS (SELECT 1 FROM PERSONAEXTERNA WHERE PERSONAID = ID)';
  Self.WhereQuery := ' AND NOMBRE CONTAINING UPPER('':PARAMETER'') OR ' +
    'APELLIDO CONTAINING UPPER('':PARAMETER'') OR ' +
    'CEDULA CONTAINING UPPER('':PARAMETER'')';
  Self.QueryExt := 'SELECT PERSONAID, ACTIVO, ESVEEDOR, ESINTERVENTOR, ' +
    'ESENCARGADO, ESPROVEEDOR FROM PERSONAEXTERNA';
end;

{
 **********************************************
 MANEJO DE OPERACIONES CON DATOS
 **********************************************
}

procedure TAbmPersonasExt.AbrirCursor;
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
  with SQLQueryExt do
  begin
    try
      Close;
      SQL.Clear;
      SQL.Add(QueryExt);
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

procedure TAbmPersonasExt.Actualizar;
begin
  inherited Actualizar;
  SQLQueryExt.Edit;
  if CheckBoxEncargado.Checked then
    SQLQueryExtESENCARGADO.AsInteger := 1
  else
    SQLQueryExtESENCARGADO.AsInteger := 0;
  if RadioGroupExaminador.ItemIndex = 0 then
  begin
    SQLQueryExtESINTERVENTOR.AsInteger := 0;
    SQLQueryExtESVEEDOR.AsInteger := 1;
  end
  else
  begin
    SQLQueryExtESINTERVENTOR.AsInteger := 1;
    SQLQueryExtESVEEDOR.AsInteger := 0;
  end;
  if CheckBoxActivo.Checked then
    SQLQueryExtACTIVO.AsInteger := 1
  else
    SQLQueryExtACTIVO.AsInteger := 0;
  if Proveedor.Checked then
    SQLQueryExtESPROVEEDOR.AsInteger := 1
  else
    SQLQueryExtESPROVEEDOR.AsInteger := 0;
  SQLQueryExt.ApplyUpdates;
end;

procedure TAbmPersonasExt.Borrar;
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

procedure TAbmPersonasExt.CerrarDataset;
begin
  //primero cancelamos todo, como en el metodo padre
  SQLQueryExt.Cancel;
  inherited CerrarDataset; //ejecutamos el metodo padre que hace rollback en la DB
  //y cerramos el dataset
  SQLQueryExt.Close;
end;

procedure TAbmPersonasExt.Insertar;
begin
  inherited Insertar;
  SQLQueryExt.Append;
  SQLQueryExtPERSONAID.AsInteger := x;
  if CheckBoxEncargado.Checked then
    SQLQueryExtESENCARGADO.AsInteger := 1
  else
    SQLQueryExtESENCARGADO.AsInteger := 0;
  if RadioGroupExaminador.ItemIndex = 0 then
  begin
    SQLQueryExtESINTERVENTOR.AsInteger := 0;
    SQLQueryExtESVEEDOR.AsInteger := 1;
  end
  else
  begin
    SQLQueryExtESINTERVENTOR.AsInteger := 1;
    SQLQueryExtESVEEDOR.AsInteger := 0;
  end;
  if CheckBoxActivo.Checked then
    SQLQueryExtACTIVO.AsInteger := 1
  else
    SQLQueryExtACTIVO.AsInteger := 0;
  if Proveedor.Checked then
    SQLQueryExtESPROVEEDOR.AsInteger := 1
  else
    SQLQueryExtESPROVEEDOR.AsInteger := 0;
  SQLQueryExt.ApplyUpdates;
end;

procedure TAbmPersonasExt.SQLQueryExtFilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  Accept := DataSet.FieldByName('PERSONAID').AsInteger = SQLQuery1ID.AsInteger;
end;

{
 ***********************************************
 MANEJO DE LOS ELEMENTOS VISUALES DE LA VENTANA
 ***********************************************
}
procedure TAbmPersonasExt.ModificarDatos;
begin
  //actualizamos el dataset de alumno ahora que se movio el cursor a un nuevo registro
  try
    begin
      SQLQueryExt.Refresh;
    end;
  except
    on E:
      EDatabaseError do
    begin
      ManejoErrores(E);
    end;
  end;
  inherited ModificarDatos;
  if SQLQueryExtESENCARGADO.AsInteger = 1 then
    CheckBoxEncargado.Checked := True
  else
    CheckBoxEncargado.Checked := False;
  if SQLQueryExtESVEEDOR.AsInteger = 1 then
  begin
    RadioGroupExaminador.ItemIndex := 0;
    RadioGroupExaminador.Refresh;
  end
  else
  begin
    RadioGroupExaminador.ItemIndex := 1;
    RadioGroupExaminador.Refresh;
  end;
  if SQLQueryExtACTIVO.AsInteger = 1 then
    CheckBoxActivo.Checked := True
  else
    checkboxactivo.Checked := False;
  if SQLQueryExtESPROVEEDOR.AsInteger = 1 then
    Proveedor.Checked := True
  else
    Proveedor.Checked := False;
end;

{
 ************************************************
 MANEJO DE VALIDACIONES DE CAMPOS
 ************************************************
}

function TAbmPersonasExt.DatosValidos: boolean;
begin
  if ((Trim(LabeledEditNuevoNombreS.Text) = '') or
    (Trim(LabeledEditNuevoApellidos.Text) = '') or
    (Trim(LabeledEditNuevoCedula.Text) = '') or (Trim(DateEditFechaNac.Text) = '') or
    not (FechaValida(DateEditFechaNac.Date)) or
    ((not CheckBoxEncargado.Checked) and (RadioGroupExaminador.ItemIndex = -1)) and
    (not Proveedor.Checked)) then
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
procedure TAbmPersonasExt.MenuItemNuevoClick(Sender: TObject);
begin
  inherited MenuItemNuevoClick(Sender);
  CheckGroupActivo.Enabled := False;
  CheckGroupRol.Enabled := True;
end;

procedure TAbmPersonasExt.MenuItemModificarClick(Sender: TObject);
begin
  inherited MenuItemModificarClick(Sender);
  CheckGroupActivo.Enabled := True;
  CheckGroupRol.Enabled := True;
end;

{
 ********************************************************
 MANEJO DE LAS ACCIONES DE LOS BOTONES
 ********************************************************
}
procedure TAbmPersonasExt.OKButtonClick(Sender: TObject);
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

procedure TAbmPersonasExt.CloseButtonClick(Sender: TObject);
begin
  try
    SQLQuery1.Cancel;
    SQLQueryExt.Cancel;
    SQLQueryDir.Cancel;
    SQLQueryTel.Cancel;
    SQLQuery1.Close;
    SQLQueryExt.Cancel;
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

procedure TAbmPersonasExt.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
   ShellExecute(Handle, 'open', 'help\ABMs\pers-externas.html', nil, nil, 1);
end;

{
 **************************************************
 SETTERS Y GETTERS
 **************************************************
}
procedure TAbmPersonasExt.SetQueryExt(AValue: string);
begin
  if FQueryExt = AValue then
    Exit;
  FQueryExt := AValue;
end;

end.
