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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    btOK: TButton;
    memComment: TDBMemo;
    grbDBProperties: TGroupBox;
    lblCreated: TLabel;
    lblLocation: TLabel;
    lblLocation1: TLabel;
    lblVersion: TLabel;
    sTLocation: TStaticText;
    sTVersion: TStaticText;
    sTCreated: TStaticText;
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure memCommentEditingDone(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

uses
  unit1;

{ TForm2 }

procedure TForm2.btOKClick(Sender: TObject);
begin
  close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  Form1.SQLQueryDB.Active:=true;
  sTVersion.Caption := Form1.SQLQueryDB.FieldByName('DBVersion').AsString + ' ';
  sTCreated.Caption := Form1.SQLQueryDB.FieldByName('DBCreated').AsString + ' ';
  sTLocation.Caption := IniFluff.ReadString('Database', 'Location', '');
end;

procedure TForm2.memCommentEditingDone(Sender: TObject);
begin
   if Form1.ATransaction.Active then
   begin
     Form1.SQlQueryDB.Edit;
     Form1.SQlQueryDB.FieldByName('DBComment').AsString := memComment.Lines.Text;
     Form1.SQlQueryDB.Post;
     Form1.SQlQueryDB.ApplyUpdates;
     Form1.SQLQueryDB.Active:=false;
   end;
end;

end.

