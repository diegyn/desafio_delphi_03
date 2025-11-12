unit _FormBotaoFechar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _FormBase, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFormBotaoFechar = class(TFormBase)
    sbFechar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormBotaoFechar.FormCreate(Sender: TObject);
begin
  inherited;
  sbFechar.OnClick := sbFecharClick;
end;

procedure TFormBotaoFechar.sbFecharClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
