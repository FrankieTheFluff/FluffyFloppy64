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
Options
-----------------------------------------------------------------
}
unit Unit4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  EditBtn, ColorBox, Spin, FileUtil, LazFileUtils, windows;

type

  { TForm4 }

  TForm4 = class(TForm)
    btCopyFont: TButton;
    btDefaultBackground: TButton;
    btDefaultFont: TButton;
    btDefaultSize: TButton;
    btOK: TButton;
    btCancel: TButton;
    cbImportT18T19: TCheckBox;
    cbImportT18T53: TCheckBox;
    cbImportT40: TCheckBox;
    cbStartOpenDB: TCheckBox;
    cbPETSCIITracks: TCheckBox;
    clbBackground: TColorBox;
    clbFont: TColorBox;
    cbLng: TComboBox;
    fileCCS64: TFileNameEdit;
    fileDenise: TFileNameEdit;
    fileEmu64: TFileNameEdit;
    fileDirMaster: TFileNameEdit;
    fileHoxs64: TFileNameEdit;
    fileNibConv: TFileNameEdit;
    fileVICE: TFileNameEdit;
    folderTemp: TDirectoryEdit;
    Form4: TCheckBox;
    grbImportD64: TGroupBox;
    grbStart: TGroupBox;
    grbDatabase: TGroupBox;
    grbImportD71: TGroupBox;
    grbImportD81: TGroupBox;
    grbFontOptions: TGroupBox;
    grbLocations: TGroupBox;
    grbFontLocation: TGroupBox;
    grbEmulator: TGroupBox;
    grbTools: TGroupBox;
    grbLng: TGroupBox;
    lbFontFolder: TLabel;
    lbFontFolder2: TLabel;
    lblImportHint1: TLabel;
    lblImportHint2: TLabel;
    lblImportHint3: TLabel;
    lblLocHoxs64: TLabel;
    lblLocCCS64: TLabel;
    lblLocDenise: TLabel;
    lblLocEmu64: TLabel;
    lblLocDirMaster: TLabel;
    lblFontBackground: TLabel;
    lblFontColor: TLabel;
    lblFontSize: TLabel;
    lblNibConv: TLabel;
    lbNibConvHint1: TLabel;
    lbNibConvHint2: TLabel;
    lblLocVice: TLabel;
    lblTempFolder: TLabel;
    spFontSize: TSpinEdit;
    tbPETSCII: TTabSheet;
    tbImport: TTabSheet;
    tbSettings: TPageControl;
    tbSetting: TTabSheet;
    tbEmu: TTabSheet;
    procedure btCancelClick(Sender: TObject);
    procedure btDefaultBackgroundClick(Sender: TObject);
    procedure btDefaultFontClick(Sender: TObject);
    procedure btDefaultSizeClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCopyFontClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;

implementation
uses unit1, FFFunctions;

{$R *.lfm}

{ TForm4 }

procedure TForm4.btOKClick(Sender: TObject);
begin
  InIFluff.WriteString('FluffyFloppy64', 'Language', cbLng.Text);
  IniFluff.WriteBool('Start', 'OpenDatabase', cbStartOpenDB.Checked);
  IniFluff.WriteBool('Options', 'cbPETSCIITracks', cbPETSCIITracks.Checked);
  IniFluff.WriteBool('Options', 'IncludeT18T19', cbImportT18T19.Checked);
  IniFluff.WriteBool('Options', 'IncludeT18T53', cbImportT18T53.Checked);
  IniFluff.WriteBool('Options', 'IncludeT40', cbImportT40.Checked);
  IniFluff.WriteInteger('Options', 'DirFontSize', spFontSize.Value);
  IniFluff.WriteString('Options', 'DirFont', ColorToString(clbFont.Selected));
  IniFluff.WriteString('Options', 'DirFontBackground', ColorToString(clbBackground.Selected));
  IniFluff.WriteString('Options', 'FolderTemp', IncludeTrailingPathDelimiter(folderTemp.Directory));
  IniFluff.WriteString('NibConv', 'Location', fileNibConv.FileName);
  IniFluff.WriteString('DirMaster', 'Location', fileDirMaster.FileName);
  IniFluff.WriteString('CCS64', 'Location', fileCCS64.FileName);
  IniFluff.WriteString('Denise', 'Location', fileDenise.FileName);
  IniFluff.WriteString('Emu64', 'Location', fileEmu64.FileName);
  IniFluff.WriteString('Hoxs64', 'Location', fileHoxs64.FileName);
  IniFluff.WriteString('VICE', 'Location', fileVICE.FileName);
  IniFluff.WriteString('DirMaster', 'Location', fileDirMaster.FileName);
  frmMain.LstBxDirectoryPETSCII.Font.Size := IniFluff.ReadInteger('Options', 'DirFontSize', 12);
  frmMain.LstBxDirectoryPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  frmMain.LstBxDirectoryPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  frmMain.LstBAM.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  frmMain.LstBAM.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  frmMain.LstBoxSectors.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  frmMain.LstBoxSectors.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  frmMain.lstBoxPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  frmMain.lstBoxPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  if fileexists(IncludeTrailingPathDelimiter(sAppPath + 'lng')+ cbLng.Text + '.ini') = true then frmMain.GetLng(ChangeFileExt(ExtractFileName(cbLng.Text), ''));

  close;
end;

procedure TForm4.btCopyFontClick(Sender: TObject);
var
  msgSet03, msgSet04, msgSet05 : String;
begin
  // Lng
  msgSet03 := IniLng.ReadString('SET', 'msgSet03', 'Font not found:');
  msgSet04 := IniLng.ReadString('SET', 'msgSet04', 'Font successfully copied!');
  msgSet05 := IniLng.ReadString('SET', 'msgSet05', 'Please restart the application to make the changes take effect...');

  If fileexists(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf') = false then
   begin
    Showmessage(msgSet03 + ' ' + chr(13) + PChar(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf'));
   end
   else
    begin
     FileUtil.CopyFile(PChar(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf'), SHGetFolderPathUTF8(20)+'C64_Pro_Mono-STYLE.ttf');
     Showmessage(msgSet04 + chr(13) + msgSet05);
    end;
end;

procedure TForm4.btCancelClick(Sender: TObject);
begin
  close;
end;

procedure TForm4.btDefaultBackgroundClick(Sender: TObject);
begin
 clbBackground.Selected := StringToColor('$00DB3F1E');
end;

procedure TForm4.btDefaultFontClick(Sender: TObject);
begin
 clbFont.Selected := StringToColor('$00F9B775');
end;

procedure TForm4.btDefaultSizeClick(Sender: TObject);
begin
 spFontSize.Value := 12;
end;

procedure TForm4.FormShow(Sender: TObject);
var
  LngDefs : tStringList;
  i : Integer;
  lngFile : String;
  msgSet01, msgSet02 : String;
  msgSet10, msgSet11, msgSet12, msgSet13, msgSet14, msgSet15, msgSet16, msgSet17, msgSet18, msgSet19 : String;
  msgSet20, msgSet21, msgSet22, msgSet23, msgSet24, msgSet25, msgSet26, msgSet27 : String;
  msgSet30, msgSet31, msgSet32, msgSet33, msgSet34, msgSet35, msgSet36, msgSet38, msgSet39 : String;
  msgSet40, msgSet41, msgSet42, msgSet43, msgSet44, msgSet45, msgSet46, msgSet47, msgSet48, msgSet49 : String;
  msgSet50 : String;
begin

  cbStartOpenDB.Checked := IniFluff.ReadBool('Start', 'OpenDatabase', true);
  cbPETSCIITracks.Checked := IniFluff.ReadBool('Options', 'cbPETSCIITracks', false);
  cbImportT18T19.Checked := IniFluff.ReadBool('Options', 'IncludeT18T19', false);
  cbImportT18T53.Checked := IniFluff.ReadBool('Options', 'IncludeT18T53', false);
  cbImportT40.Checked := IniFluff.ReadBool('Options', 'IncludeT40', false);
  folderTemp.Directory := IniFluff.ReadString('Options', 'FolderTemp', '');
  fileNibConv.FileName := IniFluff.ReadString('NibConv', 'Location', '');
  spFontSize.Value := IniFluff.ReadInteger('Options', 'DirFontSize', 12);
  clbFont.Selected := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  clbBackground.Selected := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  fileCCS64.FileName := IniFluff.ReadString('CCS64', 'Location', '');
  fileDenise.FileName := IniFluff.ReadString('Denise', 'Location', '');
  fileEmu64.FileName := IniFluff.ReadString('Emu64', 'Location', '');
  fileHoxs64.FileName := IniFluff.ReadString('Hoxs64', 'Location', '');
  fileVICE.FileName := IniFluff.ReadString('VICE', 'Location', '');
  fileDirMaster.FileName := IniFluff.ReadString('DirMaster', 'Location', '');

  LngDefs := FindAllFiles(IncludeTrailingPathDelimiter(sAppPath + 'lng'), '*.ini', True);
  if LngDefs.Count = 0 then
   begin
    LngDefs.Free;
   end;
  if LngDefs.Count > 0 then
   begin
    cbLng.Clear;
    for i := 0 to LngDefs.Count-1 do
     begin
      cbLng.Items.Add(ChangeFileExt(ExtractFileName(LngDefs[i]), ''));
     end;
    LngDefs.Free;
    lngFile := IniFluff.ReadString('FluffyFloppy64', 'Language', 'English');
    if fileexists(IncludeTrailingPathDelimiter(sAppPath + 'lng')+ lngFile + '.ini') = true then cbLng.Text:= lngFile;
   end;


  //Lng (selected)
  msgSet01 := IniLng.ReadString('SET', 'msgSet01', 'Cancel');
  msgSet02 := IniLng.ReadString('SET', 'msgSet02', 'OK');
  msgSet10 := IniLng.ReadString('SET', 'msgSet10', 'Settings');
  msgSet11 := IniLng.ReadString('SET', 'msgSet11', 'Start:');
  msgSet12 := IniLng.ReadString('SET', 'msgSet12', 'Open recent used database (default)');
  msgSet13 := IniLng.ReadString('SET', 'msgSet13', 'Locations:');
  msgSet14 := IniLng.ReadString('SET', 'msgSet14', 'Temporary folder:');
  msgSet15 := IniLng.ReadString('SET', 'msgSet15', 'NibConv:');
  msgSet16 := IniLng.ReadString('SET', 'msgSet16', 'Database:');
  msgSet17 := IniLng.ReadString('SET', 'msgSet17', 'Load PETSCII directory if tracks (18,19,40 or 53) were fully imported into database, instead from image file');
  msgSet18 := IniLng.ReadString('SET', 'msgSet18', 'HINT: If checked but not stored in database you will not see it - Statusbar will show "Directory not stored in database"');
  msgSet19 := IniLng.ReadString('SET', 'msgSet19', 'Not recommended! See Import settings first!');
  msgSet20 := IniLng.ReadString('SET', 'msgSet20', 'Import');
  msgSet21 := IniLng.ReadString('SET', 'msgSet21', 'Import D64, G64, NIB:');
  msgSet22 := IniLng.ReadString('SET', 'msgSet22', 'Import also track 18/19 to database (fully usage of database without images)');
  msgSet23 := IniLng.ReadString('SET', 'msgSet23', 'Not recommended! Could go slow, needs more storage');
  msgSet24 := IniLng.ReadString('SET', 'msgSet24', 'Import D71:');
  msgSet25 := IniLng.ReadString('SET', 'msgSet25', 'Import also track 18/53 to database (fully usage of database without images)');
  msgSet26 := IniLng.ReadString('SET', 'msgSet26', 'Import D81:');
  msgSet27 := IniLng.ReadString('SET', 'msgSet27', 'Import also track 40 to database (fully usage of database without images)');
  msgSet30 := IniLng.ReadString('SET', 'msgSet30', 'Open with...');
  msgSet31 := IniLng.ReadString('SET', 'msgSet31', 'Emulator:');
  msgSet32 := IniLng.ReadString('SET', 'msgSet32', 'CCS64:');
  msgSet33 := IniLng.ReadString('SET', 'msgSet33', 'Denise:');
  msgSet34 := IniLng.ReadString('SET', 'msgSet34', 'Emu64:');
  msgSet35 := IniLng.ReadString('SET', 'msgSet35', 'Hoxs64:');
  msgSet36 := IniLng.ReadString('SET', 'msgSet36', 'Vice:');
  msgSet38 := IniLng.ReadString('SET', 'msgSet38', 'Tools:');
  msgSet39 := IniLng.ReadString('SET', 'msgSet39', 'DirMaster:');
  msgSet40 := IniLng.ReadString('SET', 'msgSet40', 'PETSCII Font');
  msgSet41 := IniLng.ReadString('SET', 'msgSet41', 'Options:');
  msgSet42 := IniLng.ReadString('SET', 'msgSet42', 'Font size (directory):');
  msgSet43 := IniLng.ReadString('SET', 'msgSet43', 'Font color:');
  msgSet44 := IniLng.ReadString('SET', 'msgSet44', 'Background color:');
  msgSet45 := IniLng.ReadString('SET', 'msgSet45', 'Default');
  msgSet46 := IniLng.ReadString('SET', 'msgSet46', 'Location:');
  msgSet47 := IniLng.ReadString('SET', 'msgSet47', 'Copy "~APPLICATIONPATH\C64_Pro_Mono-STYLE.ttf" to default operating system "~\fonts\" folder');
  msgSet48 := IniLng.ReadString('SET', 'msgSet48', 'Needs a restart of the application to make the changes take effect...');
  msgSet49 := IniLng.ReadString('SET', 'msgSet49', 'Copy2Fonts');
  msgSet50 := IniLng.ReadString('SET', 'msgSet50', 'Language:');

  btCancel.Caption:= msgSet01;
  btOK.Caption:= msgSet02;
  tbSetting.Caption := msgSet10;
  grbStart.Caption := msgSet11;
  cbStartOpenDB.Caption := msgSet12;
  grbLocations.Caption := msgSet13;
  lblTempFolder.Caption := msgSet14;
  lblNibConv.Caption := msgSet15;
  grbDatabase.Caption := msgSet16;
  cbPETSCIITracks.Caption := msgSet17;
  lbNibConvHint1.Caption := msgSet18;
  lbNibConvHint2.Caption := msgSet19;
  tbImport.Caption := msgSet20;
  grbImportD64.Caption := msgSet21;
  cbImportT18T19.Caption := msgSet22;
  lblImportHint1.Caption := msgSet23;
  grbImportD71.Caption := msgSet24;
  cbImportT18T53.Caption := msgSet25;
  lblImportHint2.Caption := msgSet23;
  grbImportD81.Caption := msgSet26;
  cbImportT40.Caption := msgSet27;
  lblImportHint3.Caption := msgSet23;
  tbEmu.Caption := msgSet30;
  grbEmulator.Caption := msgSet31;
  lblLocCCS64.Caption := msgSet32;
  lblLocDenise.Caption := msgSet33;
  lblLocEmu64.Caption := msgSet34;
  lblLocHoxs64.Caption := msgSet35;
  lblLocVice.Caption := msgSet36;
  grbTools.Caption := msgSet39;
  lblLocDirMaster.Caption := msgSet40;
  tbPETSCII.Caption := msgSet40;
  grbFontOptions.Caption := msgSet41;
  lblFontSize.Caption := msgSet42;
  lblFontColor.Caption := msgSet43;
  lblFontBackground.Caption := msgSet44;
  btDefaultSize.Caption := msgSet45;
  btDefaultFont.Caption := msgSet45;
  btDefaultBackground.Caption := msgSet45;
  grbFontLocation.Caption := msgSet46;
  lbFontFolder.Caption := msgSet47;
  lbFontFolder2.Caption := msgSet48;
  btCopyFont.Caption := msgSet49;
  grbLng.Caption := msgSet50;

end;


end.

