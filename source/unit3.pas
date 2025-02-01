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
About
-----------------------------------------------------------------
}
unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, LCLIntf;

type

  { TForm3 }

  TForm3 = class(TForm)
    btOK: TButton;
    Label1: TLabel;
    Label10: TLabel;
    lblNibtools: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    lblSQLite: TLabel;
    Label15: TLabel;
    lblStyle64: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblWebsite: TLabel;
    lblLicense: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblApp: TLabel;
    lblCopy: TLabel;
    lblVersion: TLabel;
    Panel1: TPanel;
    procedure btOKClick(Sender: TObject);
    procedure lblNibtoolsClick(Sender: TObject);
    procedure lblSQLiteClick(Sender: TObject);
    procedure lblStyle64Click(Sender: TObject);
    procedure lblWebsiteClick(Sender: TObject);
    procedure lblLicenseClick(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.btOKClick(Sender: TObject);
begin
  Close;
end;

procedure TForm3.lblNibtoolsClick(Sender: TObject);
begin
  OpenURL('https://github.com/rittwage/nibtools');
end;

procedure TForm3.lblSQLiteClick(Sender: TObject);
begin
  OpenURL('https://www.sqlite.org/index.html');
end;

procedure TForm3.lblStyle64Click(Sender: TObject);
begin
  OpenURL('https://style64.org/c64-truetype');
end;

procedure TForm3.lblWebsiteClick(Sender: TObject);
begin
  OpenURL('https://github.com/FrankieTheFluff/FluffyFloppy64');
end;

procedure TForm3.lblLicenseClick(Sender: TObject);
begin
  OpenURL('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html');
end;

end.

