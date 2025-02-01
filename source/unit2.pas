{
-----------------------------------------------------------------
FluffyFloppy64
v0.xx
-----------------------------------------------------------------
A Microsoft(r) Windows(r) tool to catalog Commodore 64 (C64)
floppy disk images (D64, G64, D71, D81, PRG)
FREEWARE / OpenSource
License: GNU General Public License v2.0
(c) 2021-2025 FrankieTheFluff
Web: https://github.com/FrankieTheFluff/FluffyFloppy64
Mail: fluxmyfluffyfloppy@mail.de
-----------------------------------------------------------------
Database properties dialog
-----------------------------------------------------------------
}
unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    btOK: TButton;
    grbDBProperties: TGroupBox;
    lblCreated: TLabel;
    lblLocation: TLabel;
    lblVersion: TLabel;
    sTLocation: TStaticText;
    sTVersion: TStaticText;
    sTCreated: TStaticText;
    procedure btOKClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.btOKClick(Sender: TObject);
begin
  close;
end;

end.

