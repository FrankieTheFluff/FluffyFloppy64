{
-----------------------------------------------------------------
FluffyFloppy64
v0.xx
-----------------------------------------------------------------
A Microsoft(r) Windows(r) tool to catalog Commodore 64 (C64)
floppy disk images (D64, G64, NIB, D71, D81, PRG, TAP)
FREEWARE / OpenSource
License: GNU General Public License v2.0
(c) 2021-2025 FrankieTheFluff
Web: https://github.com/FrankieTheFluff/FluffyFloppy64
Mail: fluxmyfluffyfloppy@mail.de
-----------------------------------------------------------------
Manual
-----------------------------------------------------------------
}
unit Unit8;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmManual }

  TfrmManual = class(TForm)
    btOK: TButton;
    memManual: TMemo;
    procedure btOKClick(Sender: TObject);
  private

  public

  end;

var
  frmManual: TfrmManual;

implementation

{$R *.lfm}

{ TfrmManual }

procedure TfrmManual.btOKClick(Sender: TObject);
begin
  close;
end;

end.

