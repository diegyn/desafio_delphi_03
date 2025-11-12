program Aliare;

uses
  Vcl.Forms,
  Menu in 'Fontes\Menu.pas' {FormMenu},
  Ambiente in 'Fontes\Ambiente.pas',
  _FormBase in 'Utils\Forms\_FormBase.pas' {FormBase},
  _FormBotaoFechar in 'Utils\Forms\_FormBotaoFechar.pas' {FormBotaoFechar},
  _FormEditar in 'Utils\Forms\_FormEditar.pas' {FormEditar},
  Produtor in 'Fontes\Produtor.pas' {FormProdutor},
  Distribuidor in 'Fontes\Distribuidor.pas' {FormDistribuidor},
  _Conexao in 'Utils\Firebird\_Conexao.pas',
  _Produtor in 'Banco\_Produtor.pas',
  _Tabela in 'Utils\Firebird\_Tabela.pas',
  _Execucao in 'Utils\Firebird\_Execucao.pas',
  _Generator in 'Utils\Firebird\_Generator.pas',
  _Distribuidor in 'Banco\_Distribuidor.pas',
  _Produto in 'Banco\_Produto.pas',
  Produto in 'Fontes\Produto.pas' {FormProduto},
  Negociacao in 'Fontes\Negociacao.pas' {FormNegociacao},
  _Negociacao in 'Banco\_Negociacao.pas',
  _NegociacaoItem in 'Banco\_NegociacaoItem.pas',
  _ProdutorDistribuidor in 'Banco\_ProdutorDistribuidor.pas';

{$R *.res}

begin
  Application.Initialize;

  Ambiente.Iniciar;

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMenu, FormMenu);
  Application.Run;
end.
