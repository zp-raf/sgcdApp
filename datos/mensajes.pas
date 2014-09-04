unit mensajes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb;

type

  { TAlumno }

  TAlumno = record
    ID: integer;
  end;

  { TTalonario }

  TTalonario = record
    ID: integer;
  end;

  TFactura = record
    ID: integer;
  end;

  { TComprobante }

  TComprobante = record
    ID: integer;
    Tipo: integer;
    PersonaID: integer;
    Total: Double;
  end;


  { TMensajeAranceles }

  TMensajeAranceles = class(TStringList)

  end;

  { TMensajeAlumno }

  TMensajeAlumno = class(TObject)
    alumno: TAlumno;
  end;

  { TMensajeTalonario }

  TMensajeTalonario = class(TObject)
    talonario: TTalonario;
  end;

  { TMensajeFactura }

  TMensajeFactura = class(TSQLQuery)

  end;

  { TMensajeFacturaUnica }

  TMensajeFacturaUnica = class(TObject)
    factura: TFactura;
  end;

  { TMensajeComprobante }

  TMensajeComprobante = class(TObject)
    comprobante: TComprobante;
  end;

implementation

end.

