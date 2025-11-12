unit _Consulta;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TConsulta = class(TFDQuery)
  private
    registro: Integer;
  public
    constructor Create(AOwner: TComponent); override;

    function AsInt(coluna: string): Integer;
    function AsString(coluna: string): string;
    function AsDouble(coluna: string): Double;
    function AsDateTime(coluna: string): TDateTime;

//    procedure SetPos(posicao: Integer);
//    function Pesquisar: Boolean; overload;
//    function Pesquisar(valores: array of variant): Boolean; overload;
//    function IsNull(ind: Integer): Boolean; overload;
//    function IsNull(coluna: string): Boolean; overload;
//    function QtdRegistros: Integer;
  end;

implementation

{ TConsulta }

function TConsulta.AsDateTime(coluna: string): TDateTime;
begin
  Result := FieldByName(coluna).AsDateTime;
end;

function TConsulta.AsDouble(coluna: string): Double;
begin
  Result := FieldByName(coluna).AsFloat;
end;

function TConsulta.AsInt(coluna: string): Integer;
begin
  Result := FieldByName(coluna).AsInteger;
end;

function TConsulta.AsString(coluna: string): string;
begin
  Result := FieldByName(coluna).AsString;
end;

constructor TConsulta.Create(AOwner: TComponent);
begin
  inherited;
  inherited Create(AOwner);
  registro := -1;
end;

end.
