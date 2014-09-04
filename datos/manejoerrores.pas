unit manejoerrores;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, IBConnection, Dialogs, strutils;

function Recortar(s: string; token: string): string;
procedure MensajeError(E: EIBDatabaseError);
procedure MensajeError(E: EDatabaseError);
procedure MensajeError(E: Exception);

implementation

function Recortar(s: string; token: string): string;
var
  i: integer;
  est: integer;
begin
  if AnsiPos(token, s) = 0 then
  begin
    Result := s;
    Exit;
  end;
  est := 0;
  for i := 1 to Length(s) do
  begin
    if (est = 0) and (s[i] = token) then
      est := 1
    else if (est = 1) and not (s[i] = token) then
      Result := Result + s[i]
    else if (est = 1) and (s[i] = token) then
      break;
  end;
end;

procedure MensajeError(E: EIBDatabaseError);
begin
  {
  MessageDlg('Error', 'Error de base de datos. Consulta: ' +
    SQLQuery1.SQL.Text + 'Insercion: ' + SQLQuery1.InsertSQL.Text +
    'Modificacion: ' + SQLQuery1.UpdateSQL.Text + #13#10 +
    'Mensaje del error: ' + #13#10 + E.Message, mtError, [mbOK], 0);
  }
  MessageDlg('Error', 'Error ' + IntToStr(E.GDSErrorCode) +
    '. Mensaje del error: ' + #13#10 + E.Message, mtError, [mbOK], 0);
end;

procedure MensajeError(E: EDatabaseError);
var
  tmp: string;
begin
  {
  MessageDlg('Error', 'Error de base de datos. Consulta: ' +
    SQLQuery1.SQL.Text + 'Insercion: ' + SQLQuery1.InsertSQL.Text +
    'Modificacion: ' + SQLQuery1.UpdateSQL.Text + #13#10 +
    'Mensaje del error: ' + #13#10 + E.Message, mtError, [mbOK], 0);
  }
  tmp := E.Message;
  if SameText(tmp, Recortar(E.Message, '#')) then
  begin
    if AnsiContainsText(tmp, 'cannot delete primary key') then
      MessageDlg('Error',
        'Error de base de datos. Mensaje tecnico del error:' + #13#10 + tmp,
        mtError, [mbOK], 0)
    else if AnsiContainsText(tmp, 'violation of primary') then
      MessageDlg('Error',
        'Error de base de datos. Mensaje tecnico del error:' + #13#10 + tmp,
        mtError, [mbOK], 0)
    else if AnsiContainsText(tmp, 'violation of foreign') then
      MessageDlg('Error',
        'Error de base de datos. Mensaje tecnico del error:' + #13#10 + tmp,
        mtError, [mbOK], 0)
    else if AnsiContainsText(tmp, 'but not supplied') then
      MessageDlg('Error',
        'No se completaron los campos requeridos', mtError, [mbOK], 0)
    else if AnsiContainsStr(E.Message, '65432') then //frmfacturacion
      MessageDlg('Informacion',
        'Por favor seleccione un talonario en el menu "Opciones"', mtInformation,
        [mbOK], 0)
    else if AnsiContainsText(tmp, 'CHK1_ESCALA_POS') then
      MessageDlg('Error',
        'Los limites deben tener valores positivos',
        mtError, [mbOK], 0)
    else if AnsiContainsText(tmp, 'INTEG_329') then
      MessageDlg('Error',
        'Valor no admitido para columna VALIDO',
        mtError, [mbOK], 0)
    else
      MessageDlg('Error',
        'Error de base de datos. Mensaje tecnico del error:' + #13#10 + tmp,
        mtError, [mbOK], 0);
  end
  else
    MessageDlg('Error', Recortar(E.Message, '#'), mtError, [mbOK], 0);
end;

procedure MensajeError(E: Exception);
begin
  MessageDlg('Error',
    'Error de aplicacion. Mensaje tecnico del error:' + #13#10 + E.Message,
    mtError, [mbOK], 0);
end;

end.

