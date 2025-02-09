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
Delete dialog y/n
-----------------------------------------------------------------
}
unit Unit5;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, ExtCtrls, LazFileUtils;

type

  { TfrmDel }

  TfrmDel = class(TForm)
    btNo: TButton;
    btYes: TButton;
    cbDelFile: TCheckBox;
    Image1: TImage;
    Label1: TLabel;
    procedure btNoClick(Sender: TObject);
    procedure btYesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmDel: TfrmDel;

implementation

uses
  unit1;

{$R *.lfm}

{ TfrmDel }

procedure TfrmDel.btNoClick(Sender: TObject);
begin
 close;
end;

procedure TfrmDel.btYesClick(Sender: TObject);
var
  tmpFileFull : String;
  tmpImageFileArray : TStringArray;
begin
 if cbDelFile.Checked = true then
  begin
   tmpFileFull := Form1.SQLQueryDir.FieldByName('FileFull').Text;
   If tmpFileFull.Contains('|') = true then  // check if path locates an archive
   begin
    tmpImageFileArray := tmpFileFull.Split('|');
    DeleteFileUtf8(tmpImageFileArray[0]);
   end
   else DeleteFileUtf8(Form1.SQLQueryDir.FieldByName('FileFull').Text);
  end;

 Form1.AConnection.ExecuteDirect('DELETE from DirectoryTXT WHERE idxTXT = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
 Form1.AConnection.ExecuteDirect('DELETE from Tracks WHERE idxTrks = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
 Form1.SQLQueryDir.Delete;
 Form1.SQLQueryDir.ApplyUpdates;
 Form1.ATransaction.CommitRetaining;

if Form1.DBGridDirTxt.Visible = true then
 begin
  if Form1.SQlQuerySearch.RecordCount > 0 then Form1.SQlQuerySearch.Locate('idxSearch', Form1.SQLQueryDir.FieldByName('idxImg').Text, []);
 end;

 Form1.UnpackFileFullContainsPipe(Form1.SQLQueryDir.FieldByName('FileFull').Text);
 Form1.DBGridDir_ReadEntry(FileFull);
 //Form1.DBGridDirTxt_ReadEntry;
 Form1.LoadBAM_D64(Form1.SQLQueryDir.FieldByName('FileFull').Text,Form1.SQLQueryDir.FieldByName('FileSizeImg').Text );
 Form1.LoadTS(Form1.SQLQueryDir.FieldByName('FileFull').Text);

 close;
end;

procedure TfrmDel.FormShow(Sender: TObject);
begin
 cbDelFile.Checked := false;
end;

end.

