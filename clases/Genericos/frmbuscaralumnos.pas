unit frmbuscaralumnos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  DBGrids, ExtCtrls, ButtonPanel, StdCtrls, frmpopup, sqldb, DB, strutils, mensajes;

type

  { TPopupSeleccionAlumnos }

  TPopupSeleccionAlumnos = class(TPopup)
    ButtonCancel: TButton;
    ButtonOK: TButton;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    LabeledEdit1: TLabeledEdit;
    Personas: TRadioGroup;
    SQLQuery1: TSQLQuery;
    SQLQuery1ACTIVO: TSmallintField;
    SQLQuery1CEDULA: TStringField;
    SQLQuery1ESADMINISTRATIVO: TLongintField;
    SQLQuery1ESALUMNO: TLongintField;
    SQLQuery1ESCOORDINADOR: TLongintField;
    SQLQuery1ESENCARGADO: TLongintField;
    SQLQuery1ESINTERVENTOR: TLongintField;
    SQLQuery1ESPROFESOR: TLongintField;
    SQLQuery1ESPROVEEDOR: TLongintField;
    SQLQuery1ESVEEDOR: TLongintField;
    SQLQuery1FECHANAC: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1NOMBRECOMPLETO: TStringField;
    SQLQuery1SEXO: TStringField;
    procedure conDeudaChange(Sender: TObject);
    constructor Create(AOwner: TComponent; var Alumno: TMensajeAlumno); overload;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure PersonasSelectionChanged(Sender: TObject);
    procedure SQLQuery1FilterRecord(DataSet: TDataSet; var Accept: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionAlumnos: TPopupSeleccionAlumnos;
  FAlumno: TMensajeAlumno;

implementation

{$R *.lfm}

{ TPopupSeleccionAlumnos }

constructor TPopupSeleccionAlumnos.Create(AOwner: TComponent;
  var Alumno: TMensajeAlumno);
begin
  inherited Create(AOwner);
  FAlumno := Alumno;
end;

procedure TPopupSeleccionAlumnos.conDeudaChange(Sender: TObject);
begin
  //SQLQuery1.Refresh;
end;

procedure TPopupSeleccionAlumnos.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FAlumno.alumno.ID := SQLQuery1ID.AsInteger;
  inherited;
end;


procedure TPopupSeleccionAlumnos.FormCreate(Sender: TObject);
begin
  SQLQuery1.Open;
end;

procedure TPopupSeleccionAlumnos.LabeledEdit1Change(Sender: TObject);
begin
  SQLQuery1.Refresh;
end;

procedure TPopupSeleccionAlumnos.PersonasSelectionChanged(Sender: TObject);
begin
  SQLQuery1.Refresh;
end;

procedure TPopupSeleccionAlumnos.SQLQuery1FilterRecord(DataSet: TDataSet;
  var Accept: boolean);
begin
  if Trim(LabeledEdit1.Text) = '' then
  begin
    case Personas.ItemIndex of
      0: Accept := True;
      1: Accept := (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
          (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
          (DataSet.FieldByName('ESVEEDOR').AsInteger = 1);
      2: Accept := DataSet.FieldByName('ESALUMNO').AsInteger = 1;
      3: Accept := DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1;
    end;
  end
  else
  begin
    case Personas.ItemIndex of
      0: Accept := AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
          LabeledEdit1.Text);
      1: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
          LabeledEdit1.Text)) and ((DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1) or
          (DataSet.FieldByName('ESINTERVENTOR').AsInteger = 1) or
          (DataSet.FieldByName('ESVEEDOR').AsInteger = 1));
      2: Accept := (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
          LabeledEdit1.Text)) and (DataSet.FieldByName('ESALUMNO').AsInteger = 1);
      3: Accept:= (AnsiContainsText(DataSet.FieldByName('NOMBRECOMPLETO').AsString,
          LabeledEdit1.Text) or AnsiContainsText(DataSet.FieldByName('CEDULA').AsString,
          LabeledEdit1.Text)) and (DataSet.FieldByName('ESPROVEEDOR').AsInteger = 1);
    end;
  end;
end;

end.
