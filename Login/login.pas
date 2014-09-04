unit login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  IniPropStorage, sqldb, DB, frmsgcddatamodule;

type

  { TLogin1 }

  TLogin1 = class(TForm)
    ButtonConectar: TButton;
    ButtonCancelar: TButton;
    dsUsuario: TDatasource;
    EditHost: TEdit;
    EditDB: TEdit;
    EditUsuario: TEdit;
    EditPassword: TEdit;
    IniPropStorage1: TIniPropStorage;
    LabelHost: TLabel;
    LabelDB: TLabel;
    LabelUsuario: TLabel;
    LabelPassword: TLabel;
    qryUsuario: TSQLQuery;
    qryUsuarioCONTRASENHA: TStringField;
    qryUsuarioUSUARIO: TStringField;
    procedure ButtonConectarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure IniPropStorage1RestoreProperties(Sender: TObject);
    procedure IniPropStorage1SaveProperties(Sender: TObject);
  private
    { private declarations }
  public
    class function Execute: boolean;
  end;

var
  Login1: TLogin1;

implementation

{$R *.lfm}

{ TLogin1 }

procedure TLogin1.ButtonConectarClick(Sender: TObject);
begin
  try
    with SGCDDataModule do
    begin
      user := EditUsuario.Text;
      pass := EditPassword.Text;
      host := EditHost.Text;
      db := EditDB.Text;
      Conectar;
      ModalResult := mrOk;
    end;
  except
    on E:
      EDatabaseError do
    begin
      MessageDlg('Error',
        'Error en la conexion a la base de datos. Compruebe los datos e intente de nuevo',
        mtError, [mbOK], 0);
      //Abort;
    end;
  end;
end;

procedure TLogin1.ButtonCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TLogin1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  //TForm(GetOwner).Enabled := True;
  //TForm(GetOwner).Visible := True;
  IniPropStorage1.Save;
end;

procedure TLogin1.FormShow(Sender: TObject);
begin
  //TForm(GetOwner).Enabled := False;
  //TForm(GetOwner).Visible := False;
  IniPropStorage1.Restore;
end;

procedure TLogin1.IniPropStorage1RestoreProperties(Sender: TObject);
begin
  with IniPropStorage1.StoredValues do
  begin
    EditUsuario.Text := Items[0].Value;
    EditPassword.Text := Items[1].Value;
    EditDB.Text := Items[2].Value;
    EditHost.Text := Items[3].Value;
  end;
end;

procedure TLogin1.IniPropStorage1SaveProperties(Sender: TObject);
begin
  with IniPropStorage1.StoredValues do
  begin
    Items[0].Value := EditUsuario.Text;
    Items[1].Value := EditPassword.Text;
    Items[2].Value := EditDB.Text;
    Items[3].Value := EditHost.Text;
  end;
end;

class function TLogin1.Execute: boolean;
begin
  with TLogin1.Create(nil) do
    try
      Result := ShowModal = mrOk;
    finally
      Free;
    end;
end;

end.
