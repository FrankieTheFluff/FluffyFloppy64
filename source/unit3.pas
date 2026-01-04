{
-----------------------------------------------------------------
FluffyFloppy64
v0.xx
-----------------------------------------------------------------
FREEWARE / OpenSource
License: GNU General Public License v2.0
(c) 2021-2026 FrankieTheFluff
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

  { TfrmAbout }

  TfrmAbout = class(TForm)
    btOK: TButton;
    lblFree: TLabel;
    Label10: TLabel;
    lblNibtools: TLabel;
    Label12: TLabel;
    lblDB: TLabel;
    lblSQLite: TLabel;
    lblFont: TLabel;
    lblStyle64: TLabel;
    lblLiability: TLabel;
    Label3: TLabel;
    lblWebsite: TLabel;
    lblLicense: TLabel;
    lblLic: TLabel;
    lblUses: TLabel;
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
  frmAbout: TfrmAbout;

implementation

{$R *.lfm}

{ TfrmAbout }

procedure TfrmAbout.btOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.lblNibtoolsClick(Sender: TObject);
begin
  OpenURL('https://github.com/rittwage/nibtools');
end;

procedure TfrmAbout.lblSQLiteClick(Sender: TObject);
begin
  OpenURL('https://www.sqlite.org/index.html');
end;

procedure TfrmAbout.lblStyle64Click(Sender: TObject);
begin
  OpenURL('https://style64.org/c64-truetype');
end;

procedure TfrmAbout.lblWebsiteClick(Sender: TObject);
begin
  OpenURL('https://github.com/FrankieTheFluff/FluffyFloppy64');
end;

procedure TfrmAbout.lblLicenseClick(Sender: TObject);
begin
  OpenURL('https://www.gnu.org/licenses/old-licenses/gpl-2.0.html');
end;

end.

