unit frmpopupmodulo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  DBGrids, frmpopup, db, sqldb;

type

  { TPopupSeleccionarModulo }

  TPopupSeleccionarModulo = class(TPopup)
    DatasourceAux: TDatasource;
    DBGrid1: TDBGrid;
    SQLQueryAux: TSQLQuery;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PopupSeleccionarModulo: TPopupSeleccionarModulo;

implementation

{$R *.lfm}

end.

