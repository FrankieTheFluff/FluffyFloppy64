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
unit unit6;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, EditBtn, LazFileUtils;

type

  { TfrmImport }

  TfrmImport = class(TForm)
    btClose: TButton;
    btSaveHints: TButton;
    btImport: TButton;
    btCancel: TButton;
    cbImgD64: TCheckBox;
    cbImgD81: TCheckBox;
    cbImgD71: TCheckBox;
    cbImgPRG: TCheckBox;
    cbImgG64: TCheckBox;
    cbImgTAP: TCheckBox;
    cbImgNIB: TCheckBox;
    cbImgNFO: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    cbArcZIP: TCheckBox;
    cbLogNoImport: TCheckBox;
    cbImgTXT: TCheckBox;
    DirImport: TDirectoryEdit;
    grImportProgress: TGroupBox;
    grImportFrom: TGroupBox;
    lblCP: TLabel;
    lblFileArc: TLabel;
    lblArchiveProgress: TLabel;
    lblFileSel: TLabel;
    lblFileProgress: TLabel;
    lblFileImg: TLabel;
    lblImportCountArc: TStaticText;
    lblImportCP: TStaticText;
    lblImportHintsErrors: TLabel;
    lblImportCount: TStaticText;
    lblImportCountErr: TStaticText;
    lblImportFoundImg: TStaticText;
    lblImportFoundArc: TStaticText;
    memoImport: TMemo;
    memoImportErr: TMemo;
    memoProgressBar: TProgressBar;
    lblImportFound: TStaticText;
    SaveHintsErrors: TSaveDialog;
    procedure btCloseClick(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure btImportEnter(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btSaveHintsClick(Sender: TObject);
    procedure DirImportChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Import;
    procedure Init_DirImport;
    procedure FindAllImages(aFileFull: String; aPathArchive: String);
    Procedure FindAllImagesInArchive(aPathArchive: String);
    procedure Init_str_FindAllImages_Sync;
  private

  public

  end;

var
  frmImport: TfrmImport;
  str_AllImages : TStringList;
  str_AllImagesInArchive, str_FindAllImagesArchive, str_FindAllImagesTmp : TStringlist;
  Terminate : Boolean;
  tmpDir : String;
  ImgAdd, ImageCount, ImageCountA, ImageCountA2, ImgCountErr : Integer;  // Images/archives

implementation

{$R *.lfm}

uses
  unit1, FFFunctions;

{ TfrmImport }

procedure TfrmImport.Import;
var
  fstream : TFileStream;
  filesizeImg, ImageFile, ImageFileA : String;
  img, dbMod : Integer;
  msgImp01, msgImp02, msgImp03, msgImp04, msgImp05, msgImp06  : String;
begin

  // Lng
  msgImp01 := IniLng.ReadString('MSG', 'msgImp01', 'Importing...');
  msgImp02 := IniLng.ReadString('MSG', 'msgImp02', 'No import (already exists):');
  msgImp03 := IniLng.ReadString('MSG', 'msgImp03', 'No import (filesize = "0"):');
  msgImp04 := IniLng.ReadString('MSG', 'msgImp04', 'Import "G64" failed (directory sector not found):');
  msgImp05 := IniLng.ReadString('MSG', 'msgImp05', 'Import "NIB" failed (directory sector not found):');
  msgImp06 := IniLng.ReadString('MSG', 'msgImp06', 'Import failed:');


  frmMain.cbDBFilePath.ItemIndex:=0;
  frmMain.cbDBFileNameExt.ItemIndex:=0;
  frmMain.LstBxDirectoryPETSCII.Clear;
  frmMain.LstBAM.Clear;
  frmMain.lstBoxSectors.Clear;
  frmMain.lstBoxPETSCII.Clear;
  frmMain.LstBxDirectoryTXT.Clear;
  frmMain.MemoBAMHint.Clear;
  frmMain.StatusBar1.Panels[1].Text:= msgImp01;
  frmMain.Statusbar1.Panels[2].Text := '';
  frmMain.Statusbar1.Panels[3].Text := '';
  frmMain.Statusbar1.Panels[4].Text := '';
  frmMain.Statusbar1.Refresh;

  btImport.Enabled := false;
  memoImport.Clear;
  Terminate := false;
  lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';

 // Images
 if str_AllImages.Count > 0 then
  begin
   // accept only valid files to stringlist str_Images
   for img := 0 to str_AllImages.count-1 do
    begin
     try
     memoProgressBar.Position := memoProgressBar.Position + 1;
     ImageFile := str_AllImages.Strings[img]; // e.g. ....d64

     // Split, check if image is in archive
     If ImageFile.Contains('|')then
      begin
       ImageFileArray := str_AllImages.Strings[img].Split('|');
       ImageFileA := str_AllImages.Strings[img];  // Archive ZIP | Image location inside of archive
       ImageFile  := ImageFileArray[1];           // image location in tmp folder  e.g. "temp\123.zip\abc.d64"
      end
     else
      begin
       ImageFileA := '';           // no archive
      end;

    //TAP - check if valid file
    if cbImgPRG.Checked = true then
     begin
      if lowercase(ExtractFileExt(ImageFile)) = '.tap' then
       begin
        // Add
        ImgCount := ImgCount + 1;
        if Database_Ins_TAP(ImageFileA, ImageFile, ImgCount) = false then
          begin
           ImgCount := ImgCount - 1;
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
          end
        else
          begin
           ImgAdd := ImgAdd + 1;
           lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
           memoImport.Lines.Clear;
           memoImport.Lines.Add(ImageFile);
          end;
         // Add Ende
       end;
     end;

     //PRG - check if valid file
     if cbImgPRG.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.prg' then
        begin
         // Add
         ImgCount := ImgCount + 1;
         if Database_Ins_PRG(ImageFileA, ImageFile, ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
           end
         else
           begin
            ImgAdd := ImgAdd + 1;
            lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(ImageFile);
           end;
          // Add Ende
        end;
      end;

     //D64
     if cbImgD64.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.d64' then
        begin
         fstream:= TFileStream.Create(ImageFile, fmShareCompat or fmOpenRead);
         filesizeImg := FloatToStr(fstream.Size);
         fstream.Free;
         ImgCount := ImgCount + 1;
         if filesizeImg = '0' then
          begin
           ImgCount := ImgCount - 1;
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add(msgImp03 + ' ' + ImageFile);
          end
         else
          begin
           if Database_Ins_D64(ImageFileA, ImageFile, ImgCount) = false then
             begin
              ImgCount := ImgCount - 1;
              ImgCountErr := ImgCountErr + 1;
              lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
              if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
             end
           else
             begin
              ImgAdd := ImgAdd + 1;
              lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
              memoImport.Lines.Clear;
              memoImport.Lines.Add(ImageFile);
             end;
          end;
      end; //lowercase d64
     end;

     //D71
     if cbImgD71.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.d71' then
        begin
        fstream:= TFileStream.Create(ImageFile, fmShareCompat or fmOpenRead);
        filesizeImg := FloatToStr(fstream.Size);
        fstream.Free;
        ImgCount := ImgCount + 1;
        if filesizeImg = '0' then
         begin
          ImgCount := ImgCount - 1;
          ImgCountErr := ImgCountErr + 1;
          lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
          memoImportErr.Lines.Add(msgImp03 + ' ' + ImageFile);
         end
        else
         begin
         if Database_Ins_D71(ImageFileA, ImageFile, ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
           end
         else
           begin
            ImgAdd := ImgAdd + 1;
            lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(ImageFile);
           end;
         end;
        end;
      end;

     //D81
     if cbImgD81.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.d81' then
        begin
        fstream:= TFileStream.Create(ImageFile, fmShareCompat or fmOpenRead);
        filesizeImg := FloatToStr(fstream.Size);
        fstream.Free;
        ImgCount := ImgCount + 1;
        if filesizeImg = '0' then
         begin
          ImgCount := ImgCount - 1;
          ImgCountErr := ImgCountErr + 1;
          lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
          memoImportErr.Lines.Add(msgImp03 + ' ' + ImageFile);
         end
        else
         begin
         if Database_Ins_D81(ImageFileA, ImageFile, ImgCount) = false then
          begin
           ImgCount := ImgCount - 1;
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
          end
         else
           begin
            ImgAdd := ImgAdd + 1;
            lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(ImageFile);
           end;
        end;
       end;
      end;

     // G64
     if cbImgG64.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.g64' then
        begin
         btClose.Enabled:=false;
         ImgCount := ImgCount + 1;
         // Convert
         frmMain.Convert_G64NIB(ImageFile);
         // Checking if convert failed
         If filesize(IncludeTrailingPathDelimiter(tmpDir) + ChangeFileExt(ExtractFileName(ImageFile),'.d64')) = 0 then
          begin
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add(msgImp04 + ' ' + ImageFile);
          end  // end checking if convert failed
         else
          begin
           if Database_Ins_D64(ImageFileA, ImageFile, ImgCount) = false then
            begin
             ImgCount := ImgCount - 1;
             ImgCountErr := ImgCountErr + 1;
             lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
             if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
            end
           else
            begin
             ImgAdd := ImgAdd + 1;
             lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
             memoImport.Lines.Clear;
             memoImport.Lines.Add(ImageFile);
            end;
           end;
          DeleteFileUTF8(IncludeTrailingPathDelimiter(tmpDir) + ChangeFileExt(ExtractFileName(ImageFile),'.d64'));
        end;
      end;  // Ende g64

     // NIB
     if cbImgNIB.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.nib' then
        begin
         btClose.Enabled:=false;
         ImgCount := ImgCount + 1;
         // Convert
         frmMain.Convert_G64NIB(ImageFile);
         // Checking if convert failed
         If filesize(IncludeTrailingPathDelimiter(tmpDir) + ChangeFileExt(ExtractFileName(ImageFile),'.d64')) = 0 then
          begin
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add(msgImp05 + ' ' + ImageFile);
          end  // end checking if convert failed
         else
          begin
           if Database_Ins_D64(ImageFileA, ImageFile, ImgCount) = false then
            begin
             ImgCount := ImgCount - 1;
             ImgCountErr := ImgCountErr + 1;
             lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
             if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
            end
           else
            begin
             ImgAdd := ImgAdd + 1;
             lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
             memoImport.Lines.Clear;
             memoImport.Lines.Add(ImageFile);
            end;
           end;
          DeleteFileUTF8(IncludeTrailingPathDelimiter(tmpDir) + ChangeFileExt(ExtractFileName(ImageFile),'.d64'));
        end;
      end;  // Ende nib

     //TXT - check if valid file
     if cbImgTXT.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.txt' then
        begin
         // Add
         ImgCount := ImgCount + 1;
         if Database_Ins_TXT(ImageFileA, ImageFile, ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
           end
         else
           begin
            ImgAdd := ImgAdd + 1;
            lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(ImageFile);
           end;
          // Add Ende
        end;
      end;

     //NFO - check if valid file
     if cbImgNFO.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.nfo' then
        begin
         // Add
         ImgCount := ImgCount + 1;
         if Database_Ins_NFO(ImageFileA, ImageFile, ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            if cbLogNoImport.Checked then memoImportErr.Lines.Add(msgImp02 + ' ' + ImageFile);
           end
         else
           begin
            ImgAdd := ImgAdd + 1;
            lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(ImageFile);
           end;
          // Add Ende
        end;
      end;

     // Commit every e.g. 50 entries (In case of a application crash to avoid database goes corrupt)
     dbMod := IniFluff.ReadInteger('FluffyFloppy64', 'DBModulo', 50); // Default 50
     if ImgAdd >= dbMod then
      begin
       if (ImgAdd mod dbMod = 0) then
        begin
         If Dev_Mode = true then Showmessage('[Dev_Mode] - DBModula: ' + IntToStr(ImgAdd));
         if frmMain.ATransaction.Active then
          begin
           frmMain.ATransaction.Commit;
          end;
        end;
      end;
     except
      memoImportErr.Lines.Add(msgImp06 + ' ' + ImageFile);
     end; // accept only valid files to import

    Application.ProcessMessages;

    // Cancel
    if terminate = true then
     begin
      if frmMain.ATransaction.Active then
       begin
        frmMain.ATransaction.Commit;
       end;
      exit;
     end;
   end;  // accept only valid files

  end;  // > 0
end;

procedure TfrmImport.btCloseClick(Sender: TObject);
begin
 close;
end;

procedure TfrmImport.btImportClick(Sender: TObject);
var
  answer, img, ImgCountA : integer;
  msgImp07, msgImp08, msgImp09, msgImp10, msgImp11, msgImp12, msgImp13 : String;
begin
 ImgCountA := 0;

 // Lng
 msgImp07 := IniLng.ReadString('MSG', 'msgImp07', 'Directory not found!');
 msgImp08 := IniLng.ReadString('MSG', 'msgImp08', 'Temporary directory not found! Please check settings...');
 msgImp09 := IniLng.ReadString('MSG', 'msgImp09', 'G64 cannot be imported because NibConv not found! Please check settings first or deselect G64...');
 msgImp10 := IniLng.ReadString('MSG', 'msgImp10', 'NIB cannot be imported because NibConv not found! Please check settings first or deselect NIB...');
 msgImp11 := IniLng.ReadString('MSG', 'msgImp11', 'Files found in archive');
 msgImp12 := IniLng.ReadString('MSG', 'msgImp12', 'Unable to unpack');
 msgImp13 := IniLng.ReadString('MSG', 'msgImp13', 'Clearing...');

 // Check if import directory exists
 if (DirImport.Directory = '') or (DirectoryExists(DirImport.Directory) = false) then
  begin
   answer := MessageDlg(msgImp07,mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      btClose.Enabled:=true;
      exit;
     end;
  end;

 // Check if temp directory exists
 if (tmpDir = '') or (DirectoryExists(tmpDir) = false) then
 begin
  answer := MessageDlg(msgImp08, mtWarning, [mbOK], 0);
   if answer = mrOk then
    begin
     btClose.Enabled:=true;
     exit;
    end;
 end;

 //Check if nibtools for G64 available?
 If cbImgG64.Checked = true then
  begin
   If FileExists(IniFluff.ReadString('NibConv', 'Location', '')) = false then
    begin
     answer := MessageDlg(msgImp09, mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        btClose.Enabled:=true;
        exit;
       end;
    end;
  end;

 //Check if nibtools for nib available?
 If cbImgNIB.Checked = true then
  begin
   If FileExists(IniFluff.ReadString('NibConv', 'Location', '')) = false then
    begin
     answer := MessageDlg(msgImp10, mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        btClose.Enabled:=true;
        exit;
       end;
    end;
  end;

 // Start import
 btImport.Enabled:=false;
 btCancel.Enabled:=true;
 btClose.Enabled:=false;
 btSaveHints.Enabled:=true;
 memoProgressBar.Position := 1;
 frmMain.DBGridDir.DataSource := nil;
 frmMain.PC2.ActivePage.Visible:=false;

 // Import images (D64, D71...)
 if str_AllImages.Count > 0 then
  begin
   memoProgressBar.Max:= str_AllImages.Count;
   memoProgressBar.Repaint;
   Import;
  end;

 // Import archives (ZIP)
 if str_AllImagesInArchive.Count > 0 then  // After "select directory": "Init_str_FindAllFilesArchive" collected ZIPs
  begin
   lblImportfound.Caption := ' ' + msgImp11;
   memoProgressBar.Max:= str_AllImages.Count + str_AllImagesInArchive.Count; // Add found images also in ZIPs
   memoProgressBar.Repaint;
   for img := 0 to str_AllImagesInArchive.Count-1 do
    begin
     CleanTmp(tmpDir);
     If Terminate = true then break;
     If UnpackArchive(str_AllImagesInArchive[img], tmpDir, IniFluff.ReadString('Options', 'Codepage', 'System')) = true then  //  one archive after the other...
      begin
       FindAllImages(tmpDir,str_AllImagesInArchive[img]);
       ImgCountA := ImgCountA + 1;
       lblImportCountArc.Caption := IntToStr(ImgCountA) + ' ' ;
       Import;  // Import directory of the image
      end
     else memoImportErr.Lines.Add(msgImp12 + ' "' + str_AllImagesInArchive[img] + '"');
     CleanTmp(tmpDir);
    end;
  end;

  str_AllImages.Clear;
  str_AllImagesInArchive.Clear;
  str_FindAllImagesTmp.Clear;
  str_FindAllImagesArchive.Clear;
  memoImport.Lines.Add(msgImp13);
  frmMain.SQLQueryDir.SQL.Clear;
  frmMain.SQLQueryDir.SQL.Add('Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, DiskIDTxt, DOSTypeTxt, FilePath, Favourite, Corrupt, Tags, Info from FileImage');
  frmMain.SQLQueryDir.Active:=true;
  frmMain.DBFilter;
  If Terminate = false then memoImport.Lines.Add('Import finished! (duplicates ignored)');
  If Terminate = true then memoImport.Lines.Add('Import cancelled! (duplicates ignored)');
  btImport.Enabled := true;
  btCancel.Enabled := false;
  btClose.Enabled := true;
  frmMain.DBGridDir.DataSource := frmMain.DataSourceDir;
  frmMain.DBGridDir_ReadEntry(frmMain.SQLQueryDir.FieldByName('FileFull').Text);
  frmMain.Init_FilePath;
  frmMain.PC2.ActivePage.Visible:=true;

end;



procedure TfrmImport.btImportEnter(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.btCancelClick(Sender: TObject);
begin
 // Stop import
 Terminate := true;
 btSaveHints.Enabled:=true;
end;

procedure TfrmImport.btSaveHintsClick(Sender: TObject);
begin
 if SaveHintsErrors.Execute then
    memoImportErr.Lines.SaveToFile(SaveHintsErrors.FileName);
end;

procedure TfrmImport.DirImportChange(Sender: TObject);
begin
  Init_DirImport;
end;

procedure TfrmImport.FormActivate(Sender: TObject);
begin
 Application.ProcessMessages;
 if IniFluff.ReadBool('Options', 'cbDirImport', false) then
   begin
    DirImport.Directory := IniFluff.ReadString('Options', 'FolderImport', '');
    Init_DirImport;
   end;
 DirImport.Enabled := true;
end;

procedure TfrmImport.Init_DirImport;
var
 msgImp14, msgImp15 : String;
begin
 // Lng
 msgImp14 := IniLng.ReadString('MSG', 'msgImp14', 'Collecting images and archives... Please wait!');
 msgImp15 := IniLng.ReadString('MSG', 'msgImp15', 'Collect finished');

 ImgAdd := 0;
 ImageCountA2 := 0;
 memoImport.Clear;
 memoImportErr.Clear;
 ImgCountErr := 0;
 lblImportFoundImg.Caption := '0 ';
 lblImportFoundArc.Caption := '0 ';
 lblImportCount.Caption := '0 ';
 lblImportCountErr.Caption := '0 ';
 Terminate := false;

 If DirImport.Directory = '' then
  begin
   btImport.Enabled := false;
   btCancel.Enabled := false;
   btClose.Enabled := true;
   exit;
  end;

 lblImportfound.Caption := ' ' + msgImp14;
 CleanTmp(tmpDir);

 // Images   : str_AllImages
 FindAllImages(DirImport.Directory,'');
 // Archives : str_AllImagesInArchive
 If cbArcZIP.Checked = true then FindAllImagesInArchive(DirImport.Directory);

 lblImportfound.Caption := ' ' + msgImp15;
 memoProgressbar.Position:=0;
 If str_AllImages.count > 0 then   btImport.Enabled := true;
 If str_AllImagesInArchive.count > 0 then btImport.Enabled := true;

end;

procedure TfrmImport.FindAllImages(aFileFull : String; aPathArchive : String);
var
  i : integer;
  msgImp16, msgImp17, fExt : String;
begin
 // aFileFull = path to the image e.g. also \temp
 // aPathArchive = path to the archive also ...\temp123.zip
 // ImageCountA2 = found images in archive

 // Lng
 //msgImp17 := IniLng.ReadString('MSG', 'msgImp17', 'image(s) found.');

 str_AllImages.Clear;
 str_FindAllImagesTmp.Clear;

 // Known images files without archives
 fExt := '';
 If cbIMGD64.Checked then fExt := fExt + '*.d64';
 If cbIMGG64.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.g64'
   end
   else fExt := '*.g64';
 If cbIMGNIB.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.nib'
   end
   else fExt := '*.nib';
 If cbIMGD71.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.d71'
   end
   else fExt := '*.d71';
 If cbIMGD81.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.d81'
   end
   else fExt := '*.d81';
 If cbIMGPRG.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.prg'
   end
   else fExt := '*.prg';
 If cbIMGTAP.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.tap'
   end
   else fExt := '*.tap';
 If cbIMGTXT.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.txt'
   end
   else fExt := '*.txt';
 If cbIMGNFO.Checked then
   begin
    if fExt <> '' then fExt := fExt + ';*.nfo'
   end
   else fExt := '*.nfo';

 FindAllFiles(str_FindAllImagesTmp, IncludeTrailingPathDelimiter(aFileFull), fExt, true);

 If aPathArchive = '' then // running this procedure without archives
  begin
   str_AllImages.Text := str_FindAllImagesTmp.Text;
   ImageCount := str_AllImages.Count;
  end;

  If aPathArchive <> '' then // running this procedure with archives
   begin
   for i := 0 to str_FindAllImagesTmp.Count-1 do
    begin
     str_AllImages.Add(aPathArchive + '|' + str_FindAllImagesTmp[i]);
    end;
   ImageCountA2 := ImageCountA2 + str_AllImages.Count; // add all images inside archive(s)
  end;

 if (ImageCount + ImageCountA2) = 0 then
   begin
    msgImp16 := IniLng.ReadString('MSG', 'msgImp16', 'No image(s) to import!');
    memoImport.Lines.Add(msgImp16);
    ImageCount  := 0;
   end;

  lblImportFoundImg.Caption := ' ' + IntToStr(ImageCount + ImageCountA2) + ' ';
  Application.ProcessMessages;
end;

procedure TfrmImport.FindAllImagesInArchive(aPathArchive : String);
var
  msgImp18 : String;
begin

 // aPathArchive = path to the archive
 str_AllImagesInArchive.Clear;

 // Known images files
 FindAllFiles(str_AllImagesInArchive, IncludeTrailingPathDelimiter(aPathArchive), '*.zip', true);
 if str_AllImagesInArchive.Count = 0 then
   begin
    ImageCountA := 0;
    lblImportfound.Caption := '0 ';
   end;
 If str_AllImagesInArchive.Count > 0 then
  begin
   ImageCountA := str_AllImagesInArchive.Count;
  end;
 lblImportFoundArc.Caption := ' ' + IntToStr(ImageCountA) + ' ';
 if str_AllImagesInArchive.Count = 0 then  // pre then "Init_str_FindAllImages" checks also
   begin
    memoImport.Lines.Add('No archive(s) to import!');
   end else
   begin
    msgImp18 := IniLng.ReadString('MSG', 'msgImp18', 'archive(s) found.');
    memoImport.Lines.Add(IntToStr(str_AllImagesInArchive.Count) + ' ' + msgImp18);
   end;
end;

procedure TfrmImport.Init_str_FindAllImages_Sync;
begin
 str_AllImages.Clear;
 str_AllImages.Add(frmMain.SQLQueryDir.FieldByName('FileFull').Text);
 //ImpCount := 1;

 frmMain.AConnection.ExecuteDirect('DELETE from DirectoryTXT WHERE idxTXT = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
 frmMain.AConnection.ExecuteDirect('DELETE from Tracks WHERE idxTrks = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
 frmMain.SQLQueryDir.Delete;
 frmMain.SQLQueryDir.ApplyUpdates;
 frmMain.ATransaction.CommitRetaining;

 // Import
 frmImport.Import;
 str_AllImages.Free;
end;

procedure TfrmImport.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 str_AllImages.Free;
 str_AllImagesInArchive.Free;
 str_FindAllImagesTmp.Free;
 str_FindAllImagesArchive.Free;
 CleanTmp(tmpDir);
 IniFluff.WriteString('Options', 'FolderImport', DirImport.Directory);
 frmMain.DBFilter;
end;

procedure TfrmImport.FormShow(Sender: TObject);
var
 msgImp19, msgImp20 : String;
begin
 // Lng
 msgImp19 := IniLng.ReadString('MSG', 'msgImp19', 'Nothing to import!');
 msgImp20 := IniLng.ReadString('MSG', 'msgImp20', 'No folder selected!');

 ImgAdd := 0;
 ImageCountA2 := 0;
 DirImport.Text:='';
 DirImport.Directory:='';
 memoImport.Clear;
 memoImportErr.Clear;
 ImgCountErr := 0;
 lblImportFoundImg.Caption := '0 ';
 lblImportFoundArc.Caption := '0 ';
 lblImportCount.Caption := '0 ';
 lblImportCountArc.Caption := '0 ';
 lblImportCountErr.Caption := '0 ';
 lblimportCP.Caption := IniFluff.ReadString('Options', 'Codepage', 'System') + ' ';
 memoImport.Lines.Add(msgImp19);
 lblImportFound.Caption := ' ' + msgImp20 + ' ';
 btImport.Enabled := false;
 btSaveHints.Enabled:=false;

 Terminate := false;

 str_AllImages := TStringList.Create;
 str_AllImagesInArchive := TStringList.Create;
 str_FindAllImagesTmp := TStringList.Create;
 str_FindAllImagesArchive := TStringList.Create;
 tmpDir := IniFluff.ReadString('Options', 'FolderTemp', '');
 memoProgressbar.Position:=0;
 memoImport.Clear;
 memoImportErr.Clear;
end;

end.

