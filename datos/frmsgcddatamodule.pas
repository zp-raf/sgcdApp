unit frmsgcddatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, Forms,
  Dialogs, Menus, XMLPropStorage, DB;

type

  { TDataModule1 }

  { TSGCDDataModule }

  TSGCDDataModule = class(TDataModule)
  private
    Fdb: string;
    Fhost: string;
    Fpass: string;
    Fuser: string;
    procedure Setdb(AValue: string);
    procedure Sethost(AValue: string);
    procedure Setpass(AValue: string);
    procedure Setuser(AValue: string);
  published
    dsAux: TDatasource;
    dbConn: TIBConnection;
    qryAux: TSQLQuery;
    sqlTran: TSQLTransaction;
    procedure dbConnAfterConnect(Sender: TObject);
    procedure dbConnBeforeConnect(Sender: TObject);
    function DevuelveValor(qry: string; NombreCampoADevolver: string): string;
    procedure Conectar;
    procedure Ejecutar(qry: string);
    function SiguienteValor(gen: string): integer;
    property user: string read Fuser write Setuser;
    property pass: string read Fpass write Setpass;
    property host: string read Fhost write Sethost;
    property db: string read Fdb write Setdb;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  SGCDDataModule: TSGCDDataModule;

implementation

{$R *.lfm}

{ TSGCDDataModule }

procedure TSGCDDataModule.Setdb(AValue: string);
begin
  if Fdb = AValue then
    Exit;
  Fdb := AValue;
end;

procedure TSGCDDataModule.Sethost(AValue: string);
begin
  if Fhost = AValue then
    Exit;
  Fhost := AValue;
end;

procedure TSGCDDataModule.Setpass(AValue: string);
begin
  if Fpass = AValue then
    Exit;
  Fpass := AValue;
end;

procedure TSGCDDataModule.Setuser(AValue: string);
begin
  if Fuser = AValue then
    Exit;
  Fuser := AValue;
end;

procedure TSGCDDataModule.dbConnAfterConnect(Sender: TObject);
begin

end;

procedure TSGCDDataModule.dbConnBeforeConnect(Sender: TObject);
begin

end;

function TSGCDDataModule.DevuelveValor(qry: string;
  NombreCampoADevolver: string): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  with qryAux do
  begin
    Close;
    SQL.Clear;
    sl.AddStrings(SQL);
    SQL.Add(qry);
    Open;
    try
      ExecSQL;
    except
      on E: Exception do//SQL.SaveToFile('qrys\ERROR_' + NombreCampoADevolver);
        //             log.doError('Error al ejecutar la consulta:'+#13#10+sql.Text+#13#10+'Mensaje del servidor:' + E.Message);
        MessageDlg('Error', 'Error en la conexion a la base de datos',
          mtError, [mbOK], 0);
    end;

    Result := FieldByName(NombreCampoADevolver).AsString;
    Close;
    SQL.Clear;
    SQL.AddStrings(sl);
  end;
  sl.Free;
end;

procedure TSGCDDataModule.Conectar;
begin
  with dbConn do
  begin
    Connected := False;
    HostName := host;
    DatabaseName := db;
    UserName := user;
    Password := pass;
    Transaction := sqlTran;
    Connected := True;
  end;
end;

procedure TSGCDDataModule.Ejecutar(qry: string);
begin
  with qryAux do
  begin
    Close;
    SQL.Clear;
    SQL.Add(qry);
    Open;
    try
      ExecSQL;
    except
      on E: Exception do//SQL.SaveToFile('qrys\ERROR_' + NombreCampoADevolver);
        //             log.doError('Error al ejecutar la consulta:'+#13#10+sql.Text+#13#10+'Mensaje del servidor:' + E.Message);
        MessageDlg('Error', 'Error en la conexion a la base de datos',
          mtError, [mbOK], 0);
    end;
  end;
end;

function TSGCDDataModule.SiguienteValor(gen: string): integer;
begin
  Result := StrToInt(DevuelveValor('select next value for ' + gen +
    ' from rdb$database', 'GEN_ID'));
end;

end.
