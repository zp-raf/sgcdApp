unit frmDeudaPago;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, StdCtrls, DBGrids, DbCtrls, frmProceso;

type

  { TProcesoDeudaPago }

  TProcesoDeudaPago = class(TProceso)
    Datasource1: TDatasource;
    DatasourceAlumno: TDatasource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    dsAranceles: TDatasource;
    dsMatricula: TDatasource;
    IdMatricula: TLongintField;
    qryMatricula: TSQLQuery;
    qryArancelesACTIVO: TSmallintField;
    qryArancelesDESCRIPCION: TStringField;
    qryArancelesID: TLongintField;
    qryArancelesMONTO: TFloatField;
    qryArancelesNOMBRE: TStringField;
    qryMatriculaACTIVA: TSmallintField;
    qryMatriculaALUMNOPERSONAID: TLongintField;
    qryMatriculaCONFIRMADA: TSmallintField;
    qryMatriculaDERECHOEXAMEN: TSmallintField;
    qryMatriculaDESARROLLOMATERIAID: TLongintField;
    qryMatriculaFECHA: TDateField;
    qryMatriculaID: TLongintField;
    qryMatriculaOBSERVACIONES: TStringField;
    SQLQuery1: TSQLQuery;
    SQLQuery1ALUMNOID: TLongintField;
    SQLQuery1ARANCELID: TLongintField;
    SQLQuery1DESCRIPCION: TStringField;
    SQLQuery1FECHAINICIO: TDateField;
    SQLQuery1FECHATOPE: TDateField;
    SQLQuery1ID: TLongintField;
    SQLQuery1MATRICULAID: TLongintField;
    SQLQuery1MONTO_DEUDA: TFloatField;
    SQLQuery1MONTO_PAGADO: TFloatField;
    SQLQuery1SALDO: TFloatField;
    qryAranceles: TSQLQuery;
    NombreArancel: TStringField;
    SQLQueryAlumno: TSQLQuery;
    SQLQueryAlumnoAPELLIDO: TStringField;
    SQLQueryAlumnoCEDULA: TStringField;
    SQLQueryAlumnoFECHANAC: TDateField;
    SQLQueryAlumnoID: TLongintField;
    SQLQueryAlumnoNOMBRE: TStringField;
    SQLQueryAlumnoNOMBRECOMPLETO: TStringField;
    SQLQueryAlumnoSEXO: TStringField;
    NombreAlumno: TStringField;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ProcesoDeudaPago: TProcesoDeudaPago;

implementation

{$R *.lfm}

{ TProcesoDeudaPago }

end.

