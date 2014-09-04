unit frmReporte;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ButtonPanel, frmMaestro;

type

  { TReporte }

  TReporte = class(TMaestro)
    ButtonPanel1: TButtonPanel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Reporte: TReporte;

implementation

{$R *.lfm}

{ TReporte }

end.

