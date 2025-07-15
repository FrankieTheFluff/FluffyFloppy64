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
Database properties dialog
-----------------------------------------------------------------
}
unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls;

type

  { TfrmDB }

  TfrmDB = class(TForm)
    btOK: TButton;
    memComment: TDBMemo;
    grbDBProperties: TGroupBox;
    lblCreated: TLabel;
    lblLocation: TLabel;
    lblComment: TLabel;
    lblVersion: TLabel;
    sTLocation: TStaticText;
    sTVersion: TStaticText;
    sTCreated: TStaticText;
    procedure btOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure memCommentEditingDone(Sender: TObject);
  private

  public

  end;

var
  frmDB: TfrmDB;

implementation

{$R *.lfm}

uses
  unit1;

{ TfrmDB }

procedure TfrmDB.btOKClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDB.FormActivate(Sender: TObject);
begin
  frmMain.SQLQueryDB.Active:=true;
  sTVersion.Caption := frmMain.SQLQueryDB.FieldByName('DBVersion').AsString + ' ';
  sTCreated.Caption := frmMain.SQLQueryDB.FieldByName('DBCreated').AsString + ' ';
  sTLocation.Caption := IniFluff.ReadString('Database', 'Location', '');
end;

procedure TfrmDB.memCommentEditingDone(Sender: TObject);
begin
   if frmMain.ATransaction.Active then
   begin
     frmMain.SQlQueryDB.Edit;
     frmMain.SQlQueryDB.FieldByName('DBComment').AsString := memComment.Lines.Text;
     frmMain.SQlQueryDB.Post;
     frmMain.SQlQueryDB.ApplyUpdates;
     frmMain.SQLQueryDB.Active:=false;
   end;
end;

end.

