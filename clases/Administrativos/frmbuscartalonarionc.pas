unit frmbuscartalonarioNC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, 
    frmbuscartalonario, mensajes;

type
  TPopupBuscarTalonarioNC = class(TPopupBuscarTalonario)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupBuscarTalonarioNC: TPopupBuscarTalonarioNC;
  FTalonario: TMensajeTalonario;

implementation

{$R *.lfm}

end.

