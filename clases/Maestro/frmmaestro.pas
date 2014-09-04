unit frmMaestro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  PopupNotifier, XMLPropStorage, DB, IBConnection, strutils, manejoerrores;

type

  { TMaestro }

  TMaestro = class(TForm)
  published
    MainMenu1: TMainMenu;
    MenuArchivo: TMenuItem;
    MenuAyuda: TMenuItem;
    MenuItemSalir: TMenuItem;
    MenuItemAyuda: TMenuItem;
    MenuItemAbout: TMenuItem;
    constructor Create(TheOwner: TComponent); override;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception); virtual;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemAyudaClick(Sender: TObject); virtual;
    procedure MenuItemSalirClick(Sender: TObject);
    procedure ManejoErrores(E: EIBDatabaseError); virtual;
    procedure ManejoErrores(E: EDatabaseError); virtual;
    procedure ManejoErrores(E: Exception); virtual;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Maestro: TMaestro;
  FApplicationProperties: TApplicationProperties;

implementation

{$R *.lfm}

{ TMaestro }
procedure TMaestro.ManejoErrores(E: EDatabaseError);
begin
  MensajeError(E);
end;

procedure TMaestro.ManejoErrores(E: Exception);
begin
  MensajeError(E);
end;

procedure TMaestro.ManejoErrores(E: EIBDatabaseError);
begin
  MensajeError(E);
end;

procedure TMaestro.MenuItemAboutClick(Sender: TObject);
begin
  Application.MessageBox('Sistema de Gestión de Cursos de Danza ' +
    #13#10 + 'Versión 0.0.0.1' + #13#10 + '(c) 2014 Rafael Aquino - Federico Pérez',
    'SGCD', 0);
end;

procedure TMaestro.MenuItemAyudaClick(Sender: TObject);
begin

end;

procedure TMaestro.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  TForm(GetOwner).Enabled := True;
  TForm(GetOwner).SetFocus;
  //FApplicationProperties.Free;
end;

constructor TMaestro.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FApplicationProperties := TApplicationProperties.Create(Self);
  FApplicationProperties.CaptureExceptions := True;
  FApplicationProperties.OnException := @ApplicationProperties1Exception;
end;

procedure TMaestro.ApplicationProperties1Exception(Sender: TObject; E: Exception);
begin
  ManejoErrores(E);
end;

procedure TMaestro.FormShow(Sender: TObject);
begin
  TForm(GetOwner).Enabled := False;
end;

procedure TMaestro.MenuItemSalirClick(Sender: TObject);
begin
  Close;
end;

end.
