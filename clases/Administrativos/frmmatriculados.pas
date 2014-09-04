unit frmmatriculados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, DBGrids, ButtonPanel, sqldb, db, frmMaestro;

type

  { TAlumnosMatriculados }

  TAlumnosMatriculados = class(TMaestro)
    ds: TDatasource;
    DBGrid1: TDBGrid;
    Filtros: TGroupBox;
    qry: TSQLQuery;
    qryALUMNO_CONFIRMADO: TSmallintField;
    qryAPELLIDO: TStringField;
    qryCEDULA: TStringField;
    qryDERECHOEXAMEN: TSmallintField;
    qryDESARROLLOMATERIAID: TLongintField;
    qryEMPLEADOPERSONAID: TLongintField;
    qryFECHA: TDateField;
    qryFECHANAC: TDateField;
    qryGRUPOID: TLongintField;
    qryID: TLongintField;
    qryID_MATRICULA: TLongintField;
    qryMATERIAID: TLongintField;
    qryMATRICULA_CONFIRMADA: TSmallintField;
    qryMODULOID: TLongintField;
    qryNOMBRE: TStringField;
    qryNOMBRE_GRUPO: TStringField;
    qryNOMBRE_MATERIA: TStringField;
    qryNOMBRE_MATERIA_DET: TStringField;
    qryNOMBRE_MOD: TStringField;
    qryNOMBRE_PERIODO: TStringField;
    qryNOMBRE_PROFESOR: TStringField;
    qryNOMBRE_SECCION: TStringField;
    qryOBSERVACIONES: TStringField;
    qryPERIODOLECTIVOID: TLongintField;
    qrySECCIONID: TLongintField;
    qrySEXO: TStringField;
    procedure qryFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AlumnosMatriculados: TAlumnosMatriculados;

implementation

{$R *.lfm}

{ TAlumnosMatriculados }

procedure TAlumnosMatriculados.qryFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin

end;

end.

