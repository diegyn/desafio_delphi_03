unit _FormBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFormBase = class(TForm)
    pnActions: TPanel;

    procedure TeclarEnter(Sender: TObject; var Key: Char);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFormBase }

procedure TFormBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormBase.FormCreate(Sender: TObject);
var
  i: integer;
  j: integer;
  c: TComponent;
  botao: TSpeedButton;
begin

  for i := 0 to ComponentCount - 1 do begin
    c := Components[i];

    // TPanel
    if c is TPanel then begin
      if TPanel(c).Tag <> -1 then
        TPanel(c).Color := Color;
    end
    // TSpeedButton
    else if c is TSpeedButton then begin
    	botao := TSpeedButton(c);

      botao.Flat := True;
      botao.AlignWithMargins := True;
      botao.Font.Style := [fsBold];
      botao.Glyph.Transparent := True;
      botao.Glyph.TransparentColor := Color;

      if botao.Parent = pnActions then begin
        if pnActions.Height > pnActions.Width then begin
          botao.Margin := 3;

          if LowerCase(botao.Name) = LowerCase('sbFechar') then
            botao.Align := alBottom
          else
            botao.Align := alTop;
        end
        else begin
          botao.Margin := -1;

          if LowerCase(botao.Name) = LowerCase('sbFechar') then
            botao.Align := alRight
          else
            botao.Align := alLeft;
        end;
      end;
    end
    // TFrame - se forem frames, ajustar os SpeedButtons tamb�m
    else if c is TFrame then begin
      for j := 0 to c.ComponentCount - 1 do begin
      	if c.Components[j] is TSpeedButton then
        	TSpeedButton(c.Components[j]).Flat := True;
      end;
    end;
  end;
end;

procedure TFormBase.TeclarEnter(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    PerForm(WM_NEXTDLGCTL,0,0);
  end;
end;

end.
