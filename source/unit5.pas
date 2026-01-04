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
    lblDel: TLabel;
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
   tmpFileFull := frmMain.SQLQueryDir.FieldByName('FileFull').Text;
   If tmpFileFull.Contains('|') = true then  // check if path locates an archive
   begin
    tmpImageFileArray := tmpFileFull.Split('|');
    DeleteFileUtf8(tmpImageFileArray[0]);
   end
   else DeleteFileUtf8(frmMain.SQLQueryDir.FieldByName('FileFull').Text);
  end;

 frmMain.AConnection.ExecuteDirect('DELETE from DirectoryTXT WHERE idxTXT = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
 frmMain.AConnection.ExecuteDirect('DELETE from Tracks WHERE idxTrks = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
 frmMain.SQLQueryDir.Delete;
 frmMain.SQLQueryDir.ApplyUpdates;
 frmMain.ATransaction.CommitRetaining;

if frmMain.DBGridDirTxt.Visible = true then
 begin
  if frmMain.SQlQuerySearch.RecordCount > 0 then frmMain.SQlQuerySearch.Locate('idxSearch', frmMain.SQLQueryDir.FieldByName('idxImg').Text, []);
 end;

 frmMain.UnpackFileFullContainsPipe(frmMain.SQLQueryDir.FieldByName('FileFull').Text);
 frmMain.DBGridDir_ReadEntry(FileFull);
 //frmMain.DBGridDirTxt_ReadEntry;
 frmMain.LoadBAM_D64(frmMain.SQLQueryDir.FieldByName('FileFull').Text,frmMain.SQLQueryDir.FieldByName('FileSizeImg').Text );
 frmMain.LoadTS(frmMain.SQLQueryDir.FieldByName('FileFull').Text);

 close;
end;

procedure TfrmDel.FormShow(Sender: TObject);
begin
 cbDelFile.Checked := false;
end;

end.

