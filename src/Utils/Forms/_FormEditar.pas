unit _FormEditar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _FormBotaoFechar, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TFormEditar = class(TFormBotaoFechar)
    sbGravar: TSpeedButton;
    sbCancelar: TSpeedButton;
    sbExcluir: TSpeedButton;
    sbPesquisar: TSpeedButton;
    procedure sbCancelarClick(Sender: TObject);
    procedure sbExcluirClick(Sender: TObject);
    procedure sbGravarClick(Sender: TObject);
    procedure sbPesquisarClick(Sender: TObject);
  private
    { Private declarations }
  protected
    novo_registro: Boolean;

    function Gravar: Boolean; virtual;
    function Excluir: Boolean; virtual;

    procedure Cancelar; virtual;
    procedure Pesquisar; virtual;

    procedure Modo(editando: Boolean); virtual;
    procedure VerificarDados; virtual;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFormEdicao }

procedure TFormEditar.Cancelar;
begin

end;

function TFormEditar.Excluir: Boolean;
begin
  Result := True;
end;

function TFormEditar.Gravar: Boolean;
begin
  Result := True;
end;

procedure TFormEditar.Modo(editando: Boolean);
begin
  sbGravar.Enabled   := editando;
  sbCancelar.Enabled := editando;
  sbExcluir.Enabled  := editando and not novo_registro;

  sbPesquisar.Enabled := not editando;
end;

procedure TFormEditar.Pesquisar;
begin

end;

procedure TFormEditar.sbCancelarClick(Sender: TObject);
begin
  inherited;

  Cancelar;
	Modo(False);

end;

procedure TFormEditar.sbExcluirClick(Sender: TObject);
begin
  inherited;

  if Excluir then
    Modo(False);

end;

procedure TFormEditar.sbGravarClick(Sender: TObject);
begin
  inherited;

  VerificarDados;

  if Gravar then
    Modo(False);

end;

procedure TFormEditar.sbPesquisarClick(Sender: TObject);
begin
  inherited;
  Pesquisar;
end;

procedure TFormEditar.VerificarDados;
begin

end;

end.
