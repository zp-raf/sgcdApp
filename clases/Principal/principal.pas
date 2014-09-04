unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazHelpCHM, Forms, Controls, Graphics, Dialogs,
  Menus, ExtCtrls, ComCtrls, StdCtrls, frmAcademia, frmaranceles, frmequipos,
  frmgrupos2, frmmodulos, frmsecciones, frmpopup, frmPeriodosLectivos,
  frmsgcddatamodule, frmMaterias, frmClases, frmDesarrolloMateria, frmpersonas,
  frmalumnos, frmempleados, frmpersonasext, frmmatriculacion, {frmDeudaPago,}
  frmcuentasxcobrar, frmexamenes, frmtrabajos, frmentrega, frmCuotaArancel,
  {frmPagos,} frmfacturacion, login, frmtalonarios, frmnotacredito, frmrecibo, frmcobro,
  frmProcesoCompras, frmjustificativos, frmprocesorecibocompra, frmhistorico, frmmultas,
  frmparampopupcertifestudio, frmparampopupreportasistencia,
  frmprocesoCargaHoraProf, ShellApi, frmgenerardeuda, frmPrestamoEquipo,
  frmRegistroAnecdotico, frmcalificar, frmcalcularnota, manejoerrores, frmConfirmar, frmescala,
  frmpopupparamreporthistorico;

type

  { TPrincipal1 }

  TPrincipal1 = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    Academico: TMenuItem;
    Administrativo: TMenuItem;
    ayuda2: TMenuItem;
    asistenciaProfesores: TMenuItem;
    aboutUs1: TMenuItem;
    ayuda1: TMenuItem;
    gestionCurso: TMenuItem;
    academias: TMenuItem;
    grupos: TMenuItem;
    matricular: TMenuItem;
    materias: TMenuItem;
    clases: TMenuItem;
    examenes: TMenuItem;
    equipos: TMenuItem;
    historico: TMenuItem;
    cuentasCobrar: TMenuItem;
    cuentasPagar: TMenuItem;
    cargarRecibo: TMenuItem;
    cargarFactura: TMenuItem;
    cargarNotaCredito: TMenuItem;
    desarrolloMaterias: TMenuItem;
    aranceles: TMenuItem;
    cuotaxarancel: TMenuItem;
    examenabm: TMenuItem;
    calificar: TMenuItem;
    generarDeuda: TMenuItem;
    certificadoEstudio: TMenuItem;
    historicoMovimiento: TMenuItem;
    reportRegAsistencia: TMenuItem;
    reporte1: TMenuItem;
    calcularnota: TMenuItem;
    confirmar: TMenuItem;
    escala: TMenuItem;
    multas: TMenuItem;
    talonarios: TMenuItem;
    secciones: TMenuItem;
    periodos: TMenuItem;
    modulos: TMenuItem;
    Salir: TMenuItem;
    allpersonas: TMenuItem;
    facturas: TMenuItem;
    notaCredito: TMenuItem;
    recibo: TMenuItem;
    justificativos: TMenuItem;
    financiero: TMenuItem;
    trabajos: TMenuItem;
    entregas: TMenuItem;
    personasSub: TMenuItem;
    alumnos: TMenuItem;
    personal: TMenuItem;
    personasext: TMenuItem;
    reservaEquipo1: TMenuItem;
    registroAnecdotico1: TMenuItem;
    StatusBar1: TStatusBar;
    trabajoPractico1: TMenuItem;
    procedure aboutUs1Click(Sender: TObject);
    procedure academiasClick(Sender: TObject);
    procedure allpersonasClick(Sender: TObject);
    procedure alumnosClick(Sender: TObject);
    procedure arancelesClick(Sender: TObject);
    procedure asistenciaProfesoresClick(Sender: TObject);
    procedure ayuda1Click(Sender: TObject);
    procedure calcularnotaClick(Sender: TObject);
    procedure calificarClick(Sender: TObject);
    procedure cargarFacturaClick(Sender: TObject);
    procedure cargarNotaCreditoClick(Sender: TObject);
    procedure cargarReciboClick(Sender: TObject);
    procedure certificadoEstudioClick(Sender: TObject);
    procedure clasesClick(Sender: TObject);
    procedure cuentasCobrarClick(Sender: TObject);
    procedure cuentasPagarClick(Sender: TObject);
    procedure cuotaxarancelClick(Sender: TObject);
    procedure desarrolloMateriasClick(Sender: TObject);
    procedure entregasClick(Sender: TObject);
    procedure equiposClick(Sender: TObject);
    procedure escalaClick(Sender: TObject);
    procedure examenesClick(Sender: TObject);
    procedure facturasClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure generarDeudaClick(Sender: TObject);
    procedure gruposClick(Sender: TObject);
    procedure historicoClick(Sender: TObject);
    procedure historicoMovimientoClick(Sender: TObject);
    procedure justificativosClick(Sender: TObject);
    procedure materiasClick(Sender: TObject);
    procedure matricularClick(Sender: TObject);
    procedure MensajeSalida;
    procedure confirmarClick(Sender: TObject);
    procedure modulosClick(Sender: TObject);
    procedure multasClick(Sender: TObject);
    procedure notaCreditoClick(Sender: TObject);
    procedure periodosClick(Sender: TObject);
    procedure personalClick(Sender: TObject);
    procedure personasextClick(Sender: TObject);
    procedure reciboClick(Sender: TObject);
    procedure registroAnecdotico1Click(Sender: TObject);
    procedure reportRegAsistenciaClick(Sender: TObject);
    procedure reservaEquipo1Click(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure seccionesClick(Sender: TObject);
    procedure setConnStatus(connected: boolean; host: string);
    procedure setLoggedUser(username: string);
    procedure talonariosClick(Sender: TObject);
    procedure trabajosClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Principal1: TPrincipal1;

implementation

{$R *.lfm}

{ TPrincipal1 }

procedure TPrincipal1.setConnStatus(connected: boolean; host: string);
begin
  if connected then
    StatusBar1.Panels.Items[1].Text := 'Server: ' + host
  else
    StatusBar1.Panels.Items[1].Text := 'Desconectado';
end;

procedure TPrincipal1.setLoggedUser(username: string);
begin
  StatusBar1.Panels.Items[0].Text := username;
end;

procedure TPrincipal1.talonariosClick(Sender: TObject);
begin
  TAbmTalonarios.Create(Self).Show;
end;

procedure TPrincipal1.trabajosClick(Sender: TObject);
begin
  TAbmTrabajos.Create(Self).Show;
end;

procedure TPrincipal1.MensajeSalida;
begin
  case MessageDlg('Salir', 'Está seguro de que desea salir del sistema?',
      mtConfirmation, mbYesNo, 0) of
    mrYes:
    begin
      Visible := False;
      if TLogin1.Execute then
      begin
        Visible := True;
        Exit;
      end
      else
        Application.Terminate;
    end;
    mrNo: Abort;
  end;
end;

procedure TPrincipal1.confirmarClick(Sender: TObject);
begin
  TProcesoConfirmar.Create(Self).Show;
end;

procedure TPrincipal1.modulosClick(Sender: TObject);
begin
  TAbmModulos.Create(Self).Show;
end;

procedure TPrincipal1.multasClick(Sender: TObject);
begin
  TProcesoMultas.Create(Self).Show;
end;

procedure TPrincipal1.notaCreditoClick(Sender: TObject);
begin
  TProcesoNotaCredito.Create(Self).Show;
end;

procedure TPrincipal1.periodosClick(Sender: TObject);
begin
  TAbmPeriodosLectivos.Create(Self).Show;
end;

procedure TPrincipal1.personalClick(Sender: TObject);
begin
  TAbmEmpleados.Create(self).Show;
end;

procedure TPrincipal1.personasextClick(Sender: TObject);
begin
  TAbmPersonasExt.Create(Self).Show;
end;

procedure TPrincipal1.reciboClick(Sender: TObject);
begin
  TProcesoRecibo.Create(Self).Show;
end;

procedure TPrincipal1.registroAnecdotico1Click(Sender: TObject);
begin
  //nada
  TAbmRegistroAnecdotico.Create(Self).Show;
end;

procedure TPrincipal1.reportRegAsistenciaClick(Sender: TObject);
begin
   TPopUpParamReportAsistencia.Create(Self).Show;
end;

procedure TPrincipal1.reservaEquipo1Click(Sender: TObject);
begin
  //nada
  TProcesoPrestamo.Create(Self).Show;
end;

procedure TPrincipal1.SalirClick(Sender: TObject);
begin
  MensajeSalida;
end;

procedure TPrincipal1.seccionesClick(Sender: TObject);
begin
  TAbmSecciones.Create(Self).Show;
end;

procedure TPrincipal1.aboutUs1Click(Sender: TObject);
begin
  Application.MessageBox('Sistema de Gestión de Cursos de Danza ' +
    #13#10 + #13#10 + '(c) 2014 Rafael Aquino - Federico Pérez',
    'SGCD', 0);
end;

procedure TPrincipal1.academiasClick(Sender: TObject);
begin
  TABMAcademia.Create(Self).Show;
end;

procedure TPrincipal1.allpersonasClick(Sender: TObject);
begin
  //nada
end;

procedure TPrincipal1.alumnosClick(Sender: TObject);
begin
  TAbmAlumnos.Create(self).Show;
end;

procedure TPrincipal1.arancelesClick(Sender: TObject);
begin
  TABMAranceles.Create(Self).Show;
end;

procedure TPrincipal1.asistenciaProfesoresClick(Sender: TObject);
begin
  //nada
  TprocesoCargaHoraProf.Create(Self).Show;
end;

procedure TPrincipal1.ayuda1Click(Sender: TObject);
begin
  //hacer algo
//  ShellExecute(Handle, 'open', 'help\sgcd-help_v1.chm', nil, nil, 1);
  ShellExecute(Handle, 'open', 'help\ABMs\index.html', nil, nil, 1);
end;

procedure TPrincipal1.calcularnotaClick(Sender: TObject);
begin
  TProcesoCalcularNota.Create(Self).Show;
end;

procedure TPrincipal1.calificarClick(Sender: TObject);
begin
  TProcesoCalificar.Create(Self).Show;
end;

procedure TPrincipal1.cargarFacturaClick(Sender: TObject);
begin
  TProcesoFactCompra.Create(Self).Show;
end;

procedure TPrincipal1.cargarNotaCreditoClick(Sender: TObject);
begin
  //nada
end;

procedure TPrincipal1.cargarReciboClick(Sender: TObject);
begin
  TProcesoReciboCompra.Create(Self).Show;
end;

procedure TPrincipal1.certificadoEstudioClick(Sender: TObject);
begin
   TPopUpParamReportCertif.Create(Self).Show;
end;

procedure TPrincipal1.clasesClick(Sender: TObject);
begin
  TABMClases.Create(Self).Show;
end;

procedure TPrincipal1.cuentasCobrarClick(Sender: TObject);
begin
  TProcesoCuentasAlumno.Create(Self).Show;
end;

procedure TPrincipal1.cuentasPagarClick(Sender: TObject);
begin
  //nada
end;

procedure TPrincipal1.cuotaxarancelClick(Sender: TObject);
begin
  TCuotaArancel.Create(Self).Show;
end;

procedure TPrincipal1.desarrolloMateriasClick(Sender: TObject);
begin
  TAbmDesarrolloMateria.Create(Self).Show;
end;

procedure TPrincipal1.entregasClick(Sender: TObject);
begin
  TProcesoEntrega.Create(Self).Show;
end;

procedure TPrincipal1.equiposClick(Sender: TObject);
begin
  TAbmEquipos.Create(Self).Show;
end;

procedure TPrincipal1.escalaClick(Sender: TObject);
begin
  TProcesoEscala.Create(Self).Show;
end;

procedure TPrincipal1.examenesClick(Sender: TObject);
begin
  TAbmExamenes.Create(Self).Show;
end;

procedure TPrincipal1.facturasClick(Sender: TObject);
begin
  TProcesoFacturacion.Create(Self).Show;
end;

procedure TPrincipal1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  MensajeSalida;
end;

procedure TPrincipal1.FormCreate(Sender: TObject);
begin
  //TLogin1.Create(Self).Show;
end;

procedure TPrincipal1.FormShow(Sender: TObject);
begin
  //TLogin1.Create(Self).Show;
  setConnStatus(SGCDDataModule.dbConn.Connected, SGCDDataModule.dbConn.HostName);
  setLoggedUser(SGCDDataModule.dbConn.UserName);
end;

procedure TPrincipal1.generarDeudaClick(Sender: TObject);
begin
  TProcesoGenerarDeuda.Create(Self).Show;
end;

procedure TPrincipal1.gruposClick(Sender: TObject);
begin
  TABMGrupos.Create(Self).Show;
end;

procedure TPrincipal1.historicoClick(Sender: TObject);
begin
  TProcesoHistorico.Create(Self).Show;
end;

procedure TPrincipal1.historicoMovimientoClick(Sender: TObject);
begin
   TTPopUpParamReportHistorico.Create(Self).Show;
end;

procedure TPrincipal1.justificativosClick(Sender: TObject);
begin
  TAbmJustificativos.Create(Self).Show;
end;

procedure TPrincipal1.materiasClick(Sender: TObject);
begin
  TAbmMaterias.Create(Self).Show;
end;

procedure TPrincipal1.matricularClick(Sender: TObject);
begin
  TProcesoMatriculacion.Create(Self).Show;
end;

end.
