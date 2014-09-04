unit frmpopup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, frmMaestro, ShellApi;

type

  { TPopup }

  TPopup = class(TMaestro)
    procedure ButtonDescartarClick(Sender: TObject);
    procedure ButtonGuardarClick(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Popup: TPopup;

implementation

{$R *.lfm}

{ TPopup }

procedure TPopup.ButtonGuardarClick(Sender: TObject);
begin

end;

procedure TPopup.MenuItemAyudaClick(Sender: TObject);
begin
//  inherited;
     ShellExecute(Handle, 'open', 'help\ABMs\seleccionDatos.html', nil, nil, 1);
end;

procedure TPopup.ButtonDescartarClick(Sender: TObject);
begin

end;

end.

