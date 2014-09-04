program sgcd;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, login, Principal, frmsgcddatamodule, frmcalcularnota, frmescala,
  frmConfirmar, frmmatriculados, frmprocesocargahoraprof,
  frmListaALumnos, frmpopupmodulo, frmprestamoequipo, frmcuentasxcobrar;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TSGCDDataModule, SGCDDataModule);
  if TLogin1.Execute then
  begin
    Application.CreateForm(TPrincipal1, Principal1);
    { Correr la aplicacion }
    Application.Run;
  end
  else
    Application.Terminate;
end.

