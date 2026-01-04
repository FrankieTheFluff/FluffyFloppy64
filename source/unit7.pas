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
Import
-----------------------------------------------------------------
}
unit Unit7;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TfrmSync }

  TfrmSync = class(TForm)
    btClose: TButton;
    btSync: TButton;
    cbSyncDir: TComboBox;
    GroupBox1: TGroupBox;
    grSyncProgress: TGroupBox;
    lblImportFound: TLabel;
    lblSync: TLabel;
    lblSyncCount: TLabel;
    memoSync: TMemo;
    memoProgressBar: TProgressBar;
    procedure btSyncClick(Sender: TObject);
    procedure cbSyncDirChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Sync;
    procedure Init_str_FindAllImages;
  private

  public

  end;

var
  frmSync: TfrmSync;
  str_FindAllImages : TStringList;

implementation
uses unit1, FFFunctions;

{$R *.lfm}

{ TfrmSync }

procedure TfrmSync.FormShow(Sender: TObject);
begin
  str_FindAllImages := TStringList.Create;
  memoProgressbar.Position:=0;
  cbSyncDir.Items := Form1.cbDBFilePath.Items;        // Fill dropdown
  cbSyncDir.ItemIndex:=Form1.cbDBFilePath.ItemIndex;
end;

procedure TfrmSync.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 str_FindAllImages.Free;
 lblSyncCount.Caption := '0';
 memoSync.Lines.Clear;
end;

procedure TfrmSync.btSyncClick(Sender: TObject);
begin
 Sync;
end;

procedure TfrmSync.cbSyncDirChange(Sender: TObject);
begin
  Init_str_FindAllImages;
end;

procedure TfrmSync.Init_str_FindAllImages;
begin
 str_FindAllImages.Clear;
 FindAllFiles(str_FindAllImages, DirCheck(cbSyncDir.Text), '*.d64;*.prg;*.g64;*.d71;*.d81', true);
 if str_FindAllImages.Count = 0 then
   begin
    memoSync.Lines.Clear;
    memoSync.Lines.Add('Nothing to sync!');
    lblImportfound.Caption:= IntToStr(str_FindAllImages.Count) + ' file(s) found';
    btClose.SetFocus;
    btSync.Enabled := false;
    exit;
   end;
 if str_FindAllImages.Count > 0 then
   begin
    lblImportfound.Caption:= IntToStr(str_FindAllImages.Count) + ' file(s) found';
   end;
end;

procedure TfrmSync.Sync;
var
  fstream : TFileStream;
  answer, ImgCount , img : Integer;
begin
  btClose.Enabled:=false;
  Form1.cbDBFilePath.ItemIndex:=0;
  Form1.cbDBFileNameExt.ItemIndex:=0;
  Form1.DBFilter;

  Form1.LstBxDirectoryPETSCII.Clear;
  Form1.LstBAM.Clear;
  Form1.lstBoxSectors.Clear;
  Form1.lstBoxASCII.Clear;
  Form1.LstBxDirectoryTXT.Clear;
  Form1.StatusBar1.Panels[1].Text:= 'Syncing...';
  Form1.Statusbar1.Panels[2].Text := '';
  Form1.Statusbar1.Panels[3].Text := '';
  Form1.Statusbar1.Panels[4].Text := '';
  Form1.Statusbar1.Refresh;

 if str_FindAllImages.Count > 0 then
  begin
   Application.ProcessMessages;
   memoProgressbar.Min:=1;
   memoProgressBar.Max:=str_FindAllImages.Count;
   Form1.SQLQueryDir.Last;
   ImgCount := Form1.SQLQueryDir.FieldByName('idxImg').AsInteger;  // idxImg, idxTxt Zähler
   Form1.SQLQueryDir.Active:=false;
   Form1.ATransaction.Active:=false;

   // accept only valid and not existing files to stringlist str_Images
   for img := 0 to str_FindAllImages.count-1 do
    begin
     try

     //PRG - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.prg' then
      begin
       ImgCount := ImgCount + 1;
       if Database_Ins_PRG(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then ImgCount := ImgCount - 1
       else
         begin
          Application.ProcessMessages;
          lblSyncCount.Caption:=IntTostr(img+1);
          memoSync.Lines.Clear;
          memoSync.Lines.Add(str_FindAllImages.Strings[img]);
          memoProgressBar.Position := img+1;
         end;
      end;

     //D64 - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.d64' then
      begin
       fstream:= TFileStream.Create(str_FindAllImages.Strings[img], fmShareCompat or fmOpenRead);
       if  (fstream.Size = 174848) or  (fstream.Size = 175531) or (fstream.Size = 196608) or  (fstream.Size = 197376) or (fstream.Size = 205312) or  (fstream.Size = 206114) or  (fstream.Size = 210483) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D64(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then ImgCount := ImgCount - 1
         else
           begin
            Application.ProcessMessages;
            lblSyncCount.Caption:=IntTostr(img+1);
            memoSync.Lines.Clear;
            memoSync.Lines.Add(str_FindAllImages.Strings[img]);
            memoProgressBar.Position := img+1;
           end;
        end
       else fstream.Free;
      end;

     //D71 - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.d71' then
      begin
       fstream:= TFileStream.Create(str_FindAllImages.Strings[img], fmShareCompat or fmOpenRead);
       if  (fstream.Size = 349696) or (fstream.Size = 351062) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D71(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then ImgCount := ImgCount - 1
         else
           begin
            Application.ProcessMessages;
            lblSyncCount.Caption:=IntTostr(img+1);
            memoSync.Lines.Clear;
            memoSync.Lines.Add(str_FindAllImages.Strings[img]);
            memoProgressBar.Position := img+1;
           end;
        end
       else fstream.Free;
      end;

     //D81 - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.d81' then
      begin
       fstream:= TFileStream.Create(str_FindAllImages.Strings[img], fmShareCompat or fmOpenRead);
       if  (fstream.Size = 819200) or (fstream.Size = 822400) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D81(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then ImgCount := ImgCount - 1
         else
           begin
            Application.ProcessMessages;
            lblSyncCount.Caption:=IntTostr(img+1);
            memoSync.Lines.Clear;
            memoSync.Lines.Add(str_FindAllImages.Strings[img]);
            memoProgressBar.Position := img+1;
           end;
        end
       else fstream.Free;
      end;

    // G64
    if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.g64' then
     begin
      if fileexists(IniFluff.ReadString('NibConv', 'Location', '')) = false then
       begin
        answer := MessageDlg('NibConv.exe not found! Please go to settings...',mtWarning, [mbOK], 0);
         if answer = mrOk then
          begin
           exit;
          end;
       end;
      // Temp folder
      if IniFluff.ReadString('Options', 'FolderTemp', '') = '' then
       begin
        answer := MessageDlg('Temporary folder not defined! Please go to settings...',mtWarning, [mbOK], 0);
         if answer = mrOk then
          begin
           exit;
          end;
       end;
       Form1.Convert_G64(str_FindAllImages.Strings[img]);
       fstream:= TFileStream.Create(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ChangeFileExt(ExtractFileName(str_FindAllImages.Strings[img]),'.d64'), fmShareCompat or fmOpenRead);
       if  (fstream.Size = 174848) or  (fstream.Size = 175531) or (fstream.Size = 196608) or  (fstream.Size = 197376) or (fstream.Size = 205312) or  (fstream.Size = 206114) or  (fstream.Size = 210483) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D64(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then ImgCount := ImgCount - 1
         else
           begin
            Application.ProcessMessages;
            lblSyncCount.Caption:=IntTostr(img+1);
            memoSync.Lines.Clear;
            memoSync.Lines.Add(str_FindAllImages.Strings[img]);
            memoProgressBar.Position := img+1;
           end;
        end
       else fstream.Free;
       DeleteFile(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ExtractFileName(ChangeFileExt(str_FindAllImages.Strings[img],'.d64')));
      end; // Ende g64
    finally
      //
    end;
   end;
   memoSync.Lines.Clear;
   memoSync.Lines.Add('Import finished! (duplicates ignored)');
   Form1.SQLQueryDir.SQL.Clear;
   Form1.SQLQueryDir.SQL.Add('Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, DiskIDTxt, DOSTypeTxt, FilePath, Favourite, Corrupt, Tags, Info from FileImage');
   Form1.SQLQueryDir.Active:=true;
   Form1.DBGridDir_ReadEntry;
   Form1.Init_FilePath;
  end;
  str_FindAllImages.Clear;
  btClose.Enabled:=true;
  btClose.SetFocus;
end;

end.

