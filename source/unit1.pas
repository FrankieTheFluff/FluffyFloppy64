{
-----------------------------------------------------------------
FluffyFloppy64
v0.xx
-----------------------------------------------------------------
A Microsoft(r) Windows(r) tool to catalog Commodore 64 (C64)
floppy disk images D64, G64, NIB, D71, D81, PRG, TAP)
FREEWARE / OpenSource
License: GNU General Public License v2.0
(c) 2021-2025 FrankieTheFluff
Web: https://github.com/FrankieTheFluff/FluffyFloppy64
Mail: fluxmyfluffyfloppy@mail.de
-----------------------------------------------------------------
Main
-----------------------------------------------------------------
}
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Process, SQLite3Conn, SQLDB, DB, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, Buttons, DBGrids, Zipper,
  ShellCtrls, FileUtil, Inifiles, LCLIntf, DBCtrls, LazUTF8, LazFileUtils, Windows, Grids;

type
  TByteArr = array of Byte;

  { TForm1 }

  TForm1 = class(TForm)
    ATransaction: TSQLTransaction;
    AConnection : TSQLite3Connection;
    BtSQLSearch: TBitBtn;
    cbDBFilePath: TComboBox;
    cbDBFileNameExt: TComboBox;
    cbFilterCase: TCheckBox;
    cbSector: TComboBox;
    cbSource: TComboBox;
    cbSQLSearch: TComboBox;
    cbTrack: TComboBox;
    cbFilterFav: TCheckBox;
    cbFilterCorrupt: TCheckBox;
    cbEmulator: TComboBox;
    DataSourceDB: TDataSource;
    DataSourceDir: TDataSource;
    DataSourceDirTxt: TDataSource;
    DataSourceSearch: TDataSource;
    edTags: TDBEdit;
    DBGridDir: TDBGrid;
    DBGridDirTxt: TDBGrid;
    DBGridSplitter: TSplitter;
    Edit1: TEdit;
    EdSQLSearch: TEdit;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    lblFilterImg: TLabel;
    Label4: TLabel;
    lblNotes: TLabel;
    lblTags: TLabel;
    lblOpenWith: TLabel;
    lblSearch: TLabel;
    lblFilterPath: TLabel;
    lblFilterExt: TLabel;
    lblSec: TLabel;
    lblSource: TLabel;
    lblTrack: TLabel;
    LstBxDirectoryPETSCII: TListBox;
    LstBxDirectoryTXT: TListBox;
    MainMenu1: TMainMenu;
    memInfo: TDBMemo;
    LstBAM: TMemo;
    Database_OpenDialog: TOpenDialog;
    lstBoxPETSCII: TMemo;
    lstBoxSectors: TMemo;
    MemoBAMHint: TMemo;
    mnuViewLocation: TMenuItem;
    mnuViewDateImported: TMenuItem;
    mnuView: TMenuItem;
    mnuViewColumns: TMenuItem;
    mnuViewDateLast: TMenuItem;
    mnuRecent: TMenuItem;
    mnuDelTemp: TMenuItem;
    Separator11: TMenuItem;
    mnuProperties: TMenuItem;
    mnuDatabase: TMenuItem;
    mnuSync: TMenuItem;
    Separator10: TMenuItem;
    Separator12: TMenuItem;
    Separator9: TMenuItem;
    mnuOpenFileBrowser: TMenuItem;
    mnuManual: TMenuItem;
    Separator8: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    mnuDeleteRec: TMenuItem;
    Separator7: TMenuItem;
    mnuCorruptRec: TMenuItem;
    mnuFavouriteRec: TMenuItem;
    Separator6: TMenuItem;
    mnuOpenLocationRec: TMenuItem;
    mnuOpenRec: TMenuItem;
    mnuRecord: TMenuItem;
    mnuDelete: TMenuItem;
    Separator5: TMenuItem;
    Separator4: TMenuItem;
    mnuFavourite: TMenuItem;
    mnuCorrupt: TMenuItem;
    mnuOpenImage: TMenuItem;
    mnuOpenExplorer: TMenuItem;
    mnuExtras: TMenuItem;
    mnuOptions: TMenuItem;
    mnuAbout: TMenuItem;
    mnuHelp: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    pnTagsNotes: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pnDBView: TPanel;
    pnDirView: TPanel;
    mnuKontextDBGridDir: TPopupMenu;
    Separator3: TMenuItem;
    mnuImport: TMenuItem;
    Separator2: TMenuItem;
    mnuClose: TMenuItem;
    Separator1: TMenuItem;
    mnuFile: TMenuItem;
    LstBrowse: TShellListView;
    ShellTreeView1: TShellTreeView;
    Splitter1: TSplitter;
    DBTagsNotesSplitter: TSplitter;
    SplitterDB: TSplitter;
    SQLQueryDir: TSQLQuery;
    SQLQueryDB: TSQLQuery;
    SQLQueryTrks: TSQLQuery;
    SQLQuerySearch: TSQLQuery;
    SQLQueryFP: TSQLQuery;
    SQLQueryDirTxt: TSQLQuery;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TgCShift: TToggleBox;
    TgScratch: TToggleBox;
    procedure BtSQLSearchClick(Sender: TObject);
    procedure cbDBFilePathChange(Sender: TObject);
    procedure cbDBFileNameExtChange(Sender: TObject);
    procedure cbFilterCaseChange(Sender: TObject);
    procedure cbFilterCorruptChange(Sender: TObject);
    procedure cbFilterFavChange(Sender: TObject);
    procedure cbSectorChange(Sender: TObject);
    procedure cbSQLSearchChange(Sender: TObject);
    procedure cbTrackChange(Sender: TObject);
    procedure Convert_G64NIB(aImageName : String);
    procedure DBGridDirCellClick(Column: TColumn);
    procedure DBGridDirDblClick(Sender: TObject);
    procedure DBGridDirEnter(Sender: TObject);
    procedure DBGridDirExit(Sender: TObject);
    procedure DBGridDirKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDirMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DBGridDirTitleClick(Column: TColumn);
    procedure DBGridDirSearch(Column: TColumn);
    procedure DBGridDirTxtCellClick(Column: TColumn);
    procedure DBGridDirTxtDblClick(Sender: TObject);
    procedure DBGridDirTxtKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDirTxtMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DBGridDirTxtTitleClick(Column: TColumn);
    procedure EdSQLSearchChange(Sender: TObject);
    procedure edTagsEditingDone(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LstBrowseKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LstBxDirectoryPETSCIIDblClick(Sender: TObject);
    procedure memInfoEditingDone(Sender: TObject);
    procedure mnuCorruptRecClick(Sender: TObject);
    procedure mnuFavouriteRecClick(Sender: TObject);
    procedure mnuViewDateImportedClick(Sender: TObject);
    procedure mnuViewDateLastClick(Sender: TObject);
    procedure mnuDelTempClick(Sender: TObject);
    procedure mnuPropertiesClick(Sender: TObject);
    procedure mnuDeleteRecClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuCorruptClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure mnuFavouriteClick(Sender: TObject);
    procedure mnuManualClick(Sender: TObject);
    procedure mnuNewClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuOpenExplorerClick(Sender: TObject);
    procedure mnuOpenFileBrowserClick(Sender: TObject);
    procedure mnuOpenImageClick(Sender: TObject);
    procedure mnuOpenLocationRecClick(Sender: TObject);
    procedure mnuOpenRecClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuImportClick(Sender: TObject);
    procedure DBFilter;
    procedure DBGridDir_ReadEntry(aImageName : String);
    procedure DBGridDirTxt_ReadEntry;
    procedure DBSearch;
    procedure Init_FilePath;
    procedure mnuSyncClick(Sender: TObject);
    procedure mnuViewLocationClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    Procedure ReadDirEntries_D64;
    Procedure ReadDirEntries_D71;
    Procedure ReadDirEntries_D81;
    procedure LoadBAM_D64(aFileName : String; aFileSizeImg : String);
    procedure LoadBAM_D71(aFileName : String);
    procedure LoadBAM_D81(aFileName : String);
    procedure LoadTS(aFileName : String);
    procedure Init_TrkSec_HexDropdown(aImageName : String);
    procedure UnpackFileFullContainsPipe(aFileFull : String);
    procedure LoadDir;
    procedure Init_SectorsHexDropDown;
    procedure LstBrowseClick(Sender: TObject);
    procedure TgCShiftChange(Sender: TObject);
    procedure TgScratchChange(Sender: TObject);
    Procedure OpenDatabase(aFileName : String);
  private
    nibProcess: TProcess;
    RecentFiles: TStringList;
    procedure AddToRecentFiles(const aFileName: string);
    procedure UpdateRecentFilesMenu;
    procedure RecentFileClick(Sender: TObject);
    procedure SaveRecentFiles;
    procedure LoadRecentFiles;
  public

  end;

procedure GetDirectoryImage(aFileFull : String; aScratch : Boolean; aLower: Boolean);
Procedure OpenEmu(aEmu: string; aParam: string);
var
  Form1: TForm1;
  Dev_mode : boolean;
  DB_RecCount : Integer;
  sAppPath, sAppVersion, sAppCaption, sAppDate: String;
  FileFull : String; // Global, check if field contains pipe "|"
  IniFluff : TInifile;
  arrStr: array of array of String;
  arrD64 : array [01..40, 0..20] of String;
  arrD71 : array [01..70, 0..20] of String;
  arrD81 : array [01..80, 0..39] of String;
  dbGridSorted : String; // ASC or DESC
  SQlSearch_Click : boolean;
  FLastColumn: TColumn; //store mnuViewDateLast grid column we sorted on


  Function Init_ArrD64(aImageName : String): Boolean;
  Function Init_ArrD71(aImageName : String): Boolean;
  Function Init_ArrD81(aImageName : String): Boolean;
  Function GetArrayDir_PETSCII(arrTrackSector : String; aPosition : Integer; aLength : Integer; aTGCScratched : Boolean; aTGCShift : Boolean) : String;
implementation
{$R *.lfm}
uses unit2, unit3, unit4, unit5, unit6, unit8, FFFunctions, GetPETSCII;

const
  MaxRecentFiles = 5;

{ TForm1 }


function Init_ArrD64(aImageName : String): Boolean;  // Read D64 image into array
var
  BA : TByteArr;
  trk, sec, secPos : integer;
  s, ImageSize : String;
Begin
 result := false;
 // Images read into array arrD64
  BA := LoadByteArray(aImageName);
  s := ByteArraytoHexString(BA);
  ImageSize := ByteArrayToHexString(BA);
  secPos := 1;
  for trk := 01 to 17 do  // ----------------------------------------------01-17
   begin
    for sec := 0 to 20 do  // 21 sec
      begin
       arrD64[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 18 to 24 do  // ----------------------------------------------18-24
   begin
    for sec := 0 to 18 do  // 19 sec
      begin
       arrD64[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 25 to 30 do  // ----------------------------------------------25-30
   begin
    for sec := 0 to 17 do
      begin
       arrD64[trk, sec] := copy(s,secPos,512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
  end;
  for trk := 31 to 40 do  // ----------------------------------------------31-40
   begin
    for sec := 0 to 16 do
      begin
       arrD64[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
       if (trk = 35) and ((length(ImageSize) div 2) <= 175531) then
        begin
           result := true;
           exit // 35 tracks only
        end;
      end;
   end;
  result := true;
end;

function Init_ArrD71(aImageName : String): Boolean;  // Read D71 image into array
var
  BA : TByteArr;
  trk, sec, secPos : integer;
  s : String;
Begin
 result := false;
 // Images read into array arrD71
  BA := LoadByteArray(aImageName);
  s := ByteArraytoHexString(BA);

  secPos := 1;
  for trk := 01 to 17 do  // ----------------------------------------------01-17
   begin
    for sec := 0 to 20 do  // 21 sec
      begin
       arrD71[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 18 to 24 do  // ----------------------------------------------18-24
   begin
    for sec := 0 to 18 do  // 19 sec
      begin
       arrD71[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 25 to 30 do  // ----------------------------------------------25-30
   begin
    for sec := 0 to 17 do
      begin
       arrD71[trk, sec] := copy(s,secPos,512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
  end;
  for trk := 31 to 35 do  // ----------------------------------------------31-40
   begin
    for sec := 0 to 16 do
      begin
       arrD71[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 36 to 52 do  // ----------------------------------------------36-52
   begin
    for sec := 0 to 20 do  // 21 sec
      begin
       arrD71[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 53 to 59 do  // ----------------------------------------------53-59
   begin
    for sec := 0 to 18 do  // 19 sec
      begin
       arrD71[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  for trk := 60 to 65 do  // ----------------------------------------------60-65
   begin
    for sec := 0 to 17 do
      begin
       arrD71[trk, sec] := copy(s,secPos,512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
  end;
  for trk := 66 to 70 do  // ----------------------------------------------66-70
   begin
    for sec := 0 to 16 do
      begin
       arrD71[trk, sec] := copy(s,secPos, 512);  // 256bytes per sector
       secPos := secPos + 512;
      end;
   end;
  result := true;
end;

function Init_ArrD81(aImageName : String): Boolean;  // Read D81 image into array
var
  BA : TByteArr;
  trk, sec, secPos : integer;
  s : String;
begin
 result := false;
 if fileexists(aImageName) then
  begin
   BA := LoadByteArray(aImageName);
   s := ByteArrayToHexString(BA);
   secPos := 1;
   for trk := 1 to 80 do    // 80 tracks
    begin
     for sec := 0 to 39 do  // 40 sectors/track
      begin
       arrD81[trk,sec] := Copy(s, secPos, 512);
       secPos := secPos + 512;
      end;
    end;
   result := true;
  end;
end;

procedure ReverseBytes(Source, Dest: Pointer; Size: Integer);
var
  Index: Integer;
begin
  for Index := 0 to Size - 1 do
    Move(Pointer(LongInt(Source) + Index)^,
        Pointer(LongInt(Dest) + (Size - Index - 1))^ , 1);
end;

procedure TForm1.AddToRecentFiles(const aFileName: string);
var
  Index: Integer;
begin
  Index := RecentFiles.IndexOf(aFileName);
  if Index >= 0 then
    RecentFiles.Delete(Index);
  RecentFiles.Insert(0, aFileName);

  while RecentFiles.Count > MaxRecentFiles do
    RecentFiles.Delete(RecentFiles.Count - 1);

  UpdateRecentFilesMenu;
end;

procedure TForm1.UpdateRecentFilesMenu;
var
  i: Integer;
  Item: TMenuItem;
begin
  mnuRecent.Clear;
  for i := 0 to RecentFiles.Count - 1 do
  begin
    Item := TMenuItem.Create(mnuRecent);
    Item.Caption := RecentFiles[i];
    Item.Tag := i;
    Item.OnClick := @RecentFileClick;
    mnuRecent.Add(Item);
  end;
end;

procedure TForm1.RecentFileClick(Sender: TObject);
var
  answer : Integer;
begin
  if Sender is TMenuItem then
   if fileexists(TMenuItem(Sender).Caption) = true then
    begin
     OpenDatabase(TMenuItem(Sender).Caption);
    end
  else
  begin
   answer := MessageDlg('Database not found!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      exit;
     end;
  end;
end;

procedure TForm1.SaveRecentFiles;
var
  i: Integer;
begin
  try
    IniFluff.EraseSection('RecentFiles');
    for i := 0 to RecentFiles.Count - 1 do IniFluff.WriteString('RecentFiles', 'File' + IntToStr(i), RecentFiles[i]);
  finally

  end;
end;

procedure TForm1.LoadRecentFiles;
var
  i: Integer;
  FileName: string;
begin
  RecentFiles.Clear;
  try
    for i := 0 to MaxRecentFiles - 1 do
    begin
      FileName := IniFluff.ReadString('RecentFiles', 'File' + IntToStr(i), '');
      if FileName <> '' then RecentFiles.Add(FileName);
    end;
  finally

  end;
  UpdateRecentFilesMenu;
end;

procedure OpenEmu(aEmu: string; aParam: string);
var
  Process: TProcess;
begin
  Process := TProcess.Create(nil);
  try
    //showmessage(aEmu + ' --' + aParam);
    Process.Executable := '"' + aEmu + '"';
    Process.Parameters.Add(aParam);
    Process.ShowWindow := swoShow;
    Process.Options := Process.Options + [poWaitOnExit];
    Process.Execute;
  finally
    Process.Free;
  end;
end;

procedure TForm1.UnpackFileFullContainsPipe(aFileFull : String);
var
 tmpPath, tmpImg : String;
 ArchivePath1, ArchivePath2 : String;
 ImageFileArray : TStringArray;
 i : Integer;
begin
 If aFileFull.Contains('|') = true then  // check if path locates an archive
  begin
   ImageFileArray := aFileFull.Split('|');
   tmpPath := IncludeTrailingPathDelimiter(IniFluff.ReadString('Options', 'FolderTemp', ''));
   FileFull := tmpPath + ExtractFileName(ImageFileArray[0]) + ImageFileArray[1]; //location of D64 in tmp folder  "c:\temp\mops.zip\123.d64"
   // check if zip archive exists
   if fileexists(ImageFileArray[0]) = false then
    begin
     exit;
    end;
   // check if archive already unpacked
   if fileexists(FileFull) = false then
    begin
     If DirectoryExists(tmpPath + ExtractFileName(ImageFileArray[0])) = false then
      begin
       CreateDir(tmpPath + ExtractFileName(ImageFileArray[0])); // folder to temporarly unzip archive
      end;
     tmpImg := ExtractFileName(ImageFileArray[1]);
     ArchivePath1 := TrimLeadingBackslash(ImageFileArray[1]);
     ArchivePath2 := StringReplace(ArchivePath1, PathDelim, '/', [rfReplaceAll]);
     if UnpackFile(ImageFileArray[0], ArchivePath2, tmpPath + ExtractFileName(ImageFileArray[0])) = false then
      begin
       exit;
      end;
    end;
   end
 else FileFull := aFileFull;
end;

procedure TForm1.FormShow(Sender: TObject);
var
 GetDB : String;
begin
 Dev_mode := false;
 sAppCaption := 'FluffyFloppy64 ';
 sAppVersion := 'v0.87';
 sAppDate    := '2025-07-05';
 Form1.Caption:= sAppCaption + sAppVersion;
 sAppPath := ExtractFilePath(ParamStr(0));
 SQlSearch_Click := false;
 dbGridSorted := 'ASC';

 // Folder
 If Dev_Mode = true then Showmessage('[Dev_Mode] - Create folders');
 If DirectoryExists(IncludeTrailingPathDelimiter(sAppPath + 'temp')) = false then CreateDir(IncludeTrailingPathDelimiter(sAppPath + 'temp'));
 If DirectoryExists(IncludeTrailingPathDelimiter(sAppPath + 'nibtools')) = false then CreateDir(IncludeTrailingPathDelimiter(sAppPath + 'nibtools'));

 // INI
 if FileExists(sAppPath + 'fluffyfloppy64.ini') = False then
  try
   IniFluff := TINIFile.Create(sAppPath + 'fluffyfloppy64.ini');
   IniFluff.WriteString('FluffyFloppy64', 'Version', sAppVersion);
   InIFluff.WriteString('FluffyFloppy64', 'Language', 'English');
   IniFluff.WriteInteger('FluffyFloppy64', 'DBModulo', 50);
   InIFluff.WriteBool('FluffyFloppy64', 'Dev_Mode', false);
   IniFluff.WriteBool('Start', 'OpenDatabase', true);
   IniFluff.WriteBool('Database', 'Column1', true);
   IniFluff.WriteBool('Database', 'Column2', true);
   IniFluff.WriteBool('Database', 'Column3', true);
   IniFluff.WriteBool('Database', 'Column4', true);
     mnuViewDateLast.Checked:=true;
   IniFluff.WriteBool('Database', 'Column5', true);
     mnuViewDateImported.Checked:=true;
   IniFluff.WriteBool('Database', 'Column6', true);
   IniFluff.WriteBool('Database', 'Column7', true);
   IniFluff.WriteBool('Database', 'Column8', true);
     mnuViewLocation.Checked:=true;
   IniFluff.WriteString('Options', 'FolderTemp', IncludeTrailingPathDelimiter(sAppPath + 'temp\'));
   IniFluff.WriteBool('Options', 'Scratched', false);
   IniFluff.WriteBool('Options', 'Shifted', false);
   IniFluff.WriteBool('Options', 'IncludeT18T19', false);
   IniFluff.WriteBool('Options', 'cbPETSCII1819', false);
   IniFluff.WriteInteger('Options', 'DirFontSize', 12);
   IniFluff.WriteString('Options', 'DirFont', '$00F9B775');
   IniFluff.WriteString('Options', 'DirFontBackground', '$00DB3F1E');
   If FileExists(IncludeTrailingPathDelimiter(sAppPath + 'nibtools\') + 'nibconv.exe') = true then IniFluff.WriteString('NibConv', 'Location', IncludeTrailingPathDelimiter(sAppPath + 'nibtools\') + 'nibconv.exe');
   IniFluff.WriteInteger('Emulators', 'Select', 2);
   IniFluff.WriteString('CCS64', 'Location', '');
   IniFluff.WriteString('Denise', 'Location', '');
   IniFluff.WriteString('Hoxs64', 'Location', '');
   IniFluff.WriteString('VICE', 'Location', '');
  finally
 end;

 IniFluff := TINIFile.Create(sAppPath + 'fluffyfloppy64.ini');

 // Recent
 LoadRecentFiles;

 // Clean temp folder
 DeleteDirectory(IniFluff.ReadString('Options', 'FolderTemp', ''),true);

 // Dev_Mode ?
 Dev_Mode :=  IniFluff.ReadBool('FluffyFloppy64', 'Dev_Mode', false);
 Dev_mode := false; // public version!
 If Dev_Mode = true then Form1.Caption:= sAppCaption + sAppVersion + ' [Dev_Mode]';

 // Font
 If fileexists(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf') = false then
  begin
   Showmessage('Font not found: ' + chr(13) + PChar(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf'));
  end
  else
   begin
    AddFontResource(PChar(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf'));
    If Dev_Mode = true then Showmessage('[Dev_Mode] - Font found: ' + chr(13) + PChar(IncludeTrailingPathDelimiter(sAppPath))+'C64_Pro_Mono-STYLE.ttf');
   end;

 If Dev_Mode = true then Showmessage('[Dev_Mode] - ClientWidth & ClientHeight');
 Form1.ClientWidth := IniFluff.ReadInteger('Application', 'ClientWidth', 1000);
 Form1.ClientHeight := IniFluff.ReadInteger('Application', 'ClientHeight', 600);
 pnDirView.Width := IniFluff.ReadInteger('Application', 'SplitterPos', 470);
 pnTagsNotes.Height := IniFluff.ReadInteger('Application', 'SplitterPosTN', 200);
 Form1.Left := (Form1.Monitor.Width  - Form1.Width)  div 2;
 Form1.Top  := (Form1.Monitor.Height - Form1.Height) div 2;

 If Dev_Mode = true then Showmessage('[Dev_Mode] - Get options');
 TgScratch.Checked := IniFluff.ReadBool('Options', 'Scratched', false);
 TgCShift.Checked := IniFluff.ReadBool('Options', 'Shifted', false);
 cbEmulator.ItemIndex := IniFluff.ReadInteger('Emulators', 'Select', 2);
 //
 LstBxDirectoryPETSCII.Font.Size := IniFluff.ReadInteger('Options', 'DirFontSize', 12);
 LstBxDirectoryPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
 LstBxDirectoryPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
 LstBAM.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
 LstBAM.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
 LstBoxSectors.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
 LstBoxSectors.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
 LstBoxPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
 LstBoxPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
 //


 If Dev_Mode = true then Showmessage('[Dev_Mode] - Check if database exists and load if autostart selected');
 GetDB := IniFluff.ReadString('Database', 'Location', ''); // location of database
 If fileexists(GetDB) then
  begin
   If IniFluff.ReadBool('Start', 'OpenDatabase', true) = true then
    begin
     OpenDatabase(GetDB);
     Database_OpenDialog.FileName := GetDB;
     if SQLQueryDir.RecordCount = 0 then exit;
     if SQLQueryDir.RecordCount > 0 then
      begin
       If FileExists(FileFull) then
        begin
         // UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
         // GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
         // Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
        end
       else
       begin
        LstBxDirectoryPETSCII.Clear;
        LstBxDirectoryPETSCII.Items.Add('File not found!');
       end;

      // Columns
      mnuViewDateLast.Checked := IniFluff.ReadBool('Database', 'Column4', true);
      DBGridDir.Columns[4].Visible:= mnuViewDateLast.Checked;
      mnuViewDateImported.Checked := IniFluff.ReadBool('Database', 'Column5', true);
      DBGridDir.Columns[5].Visible:= mnuViewDateImported.Checked;
      mnuViewLocation.Checked := IniFluff.ReadBool('Database', 'Column8', true);
      DBGridDir.Columns[8].Visible:= mnuViewLocation.Checked;

      EdSQLSearch.Enabled:=true;
      cbSQLSearch.Enabled:=true;
      TgScratch.Enabled:=true;
      TgCShift.Enabled:=true;
      Statusbar1.Panels[0].Text := ' ' + IntToStr(SQLQueryDir.RecNo) + '/' + IntToStr(SQLQueryDir.RecordCount);
    end;
    end;
  end;

end;

procedure TForm1.LstBrowseKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 FileSizeImg, FileNameExt : String;
 BA : TByteArr;
 s, ImageSize : String;
begin
 FileFull    := ShellTreeView1.Path + LstBrowse.Selected.caption;
 FileNameExt := ExtractFileExt(FileFull);

 BA := LoadByteArray(FileFull);
 s := ByteArraytoHexString(BA);
 ImageSize := ByteArrayToHexString(BA);
 FileSizeImg := IntToStr(length(ImageSize) div 2);

 if (length(FileNameExt)>0) and (FileNameExt[1]='.') then delete(FileNameExt,1,1); // d64 ohne Punkt

 GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);

 if PageControl2.Pages[1].Visible = true then
  begin
   // PRG
   If (lowercase(FileNameExt) = 'prg') then LstBAM.Clear;
   // D64/G64/NIB
   If (lowercase(FileNameExt) = 'd64') or (lowercase(FileNameExt) = 'g64') or (lowercase(FileNameExt) = 'nib') then LoadBAM_D64(ShellTreeView1.Path + LstBrowse.Selected.caption, FileSizeImg);
   // D71
   If lowercase(FileNameExt) = 'd71' then LoadBAM_D71(ShellTreeView1.Path + LstBrowse.Selected.caption);
   // D81
   If lowercase(FileNameExt) = 'd81' then LoadBAM_D81(ShellTreeView1.Path + LstBrowse.Selected.caption);
  end;
  if PageControl2.Pages[2].Visible = true then
  begin
   LoadTS(FileFull);
  end;
  if PageControl2.Pages[3].Visible = true then
  begin
   LstBxDirectoryTxt.Clear;
  end;
end;

procedure TForm1.LstBxDirectoryPETSCIIDblClick(Sender: TObject);
var
  i, answer : Integer;
  s : string;
  img_file : string; // File Browser
begin

 UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);

  // CCS64###################################################################
  If cbEmulator.Text = 'CCS64' then
   begin
    if fileexists(IniFluff.ReadString('CCS64', 'Location', '')) = false then
     begin
      answer := MessageDlg('CCS64 not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg('CCS64 does not support nib images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    If lowercase(ExtractFileExt(FileFull)) = '.d81' then
     begin
      answer := MessageDlg('CCS64 does not support d81 images!',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
     end;
    If lowercase(ExtractFileExt(FileFull)) = '.d71' then
     begin
      answer := MessageDlg('CCS64 does not support d71 images!',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
     end;
    DBGridDirTxt_ReadEntry;
    if LstBxDirectoryPETSCII.ItemIndex = 0 then
     begin
      OpenEmu(IniFluff.ReadString('CCS64', 'Location', ''),'"' + FileFull + '" -autorun');
     end;
    if LstBxDirectoryPETSCII.ItemIndex > 0 then
     begin
      i := LstBxDirectoryPETSCII.ItemIndex;
      s := lowercase(LstBxDirectoryTXT.Items[i-1]);
      OpenEmu(IniFluff.ReadString('CCS64', 'Location', ''),'"' + FileFull + ',' + IntToStr(i-1) + '"');
     end;
   end;
  // CCS64 mount only ########################################################
  If cbEmulator.Text = 'CCS64 (mount only)' then
   begin
    if fileexists(IniFluff.ReadString('CCS64', 'Location', '')) = false then
     begin
      answer := MessageDlg('CCS64 not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
    If lowercase(ExtractFileExt(FileFull)) = '.d81' then
     begin
      answer := MessageDlg('CCS64 does not support d81 images!',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
     end;
    If lowercase(ExtractFileExt(FileFull)) = '.d71' then
     begin
      answer := MessageDlg('CCS64 does not support d71 images!',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
     end;
    OpenEmu(IniFluff.ReadString('CCS64', 'Location', ''),'"' + FileFull + ',-1"');
   end;

  // Denise #################################################################
  If cbEmulator.Text = 'Denise' then
   begin
    if fileexists(IniFluff.ReadString('Denise', 'Location', '')) = false then
     begin
      answer := MessageDlg('Denise not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg('Denise does not support d81 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg('Denise does not support d71 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    DBGridDirTxt_ReadEntry;
    if LstBxDirectoryPETSCII.ItemIndex = 0 then
     begin
      OpenEmu(IniFluff.ReadString('Denise', 'Location', ''),'"' + FileFull + '" -autostart-prg 2');
     end;
    if LstBxDirectoryPETSCII.ItemIndex > 0 then
     begin
      i := LstBxDirectoryPETSCII.ItemIndex;
      s := lowercase(LstBxDirectoryTXT.Items[i-1]);
      OpenEmu(IniFluff.ReadString('Denise', 'Location', ''), ' -autostart "' + FileFull + ':' + s + '"');
     end;
   end;
  // Denise mount only ######################################################
  If cbEmulator.Text = 'Denise (mount only)' then
   begin
    if fileexists(IniFluff.ReadString('Denise', 'Location', '')) = false then
     begin
      answer := MessageDlg('Denise not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg('Denise does not support d81 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg('Denise does not support d71 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    OpenEmu(IniFluff.ReadString('Denise', 'Location', ''), ' -attach8 "' + FileFull + '"');
   end;

  // Emu64 #################################################################
  If cbEmulator.Text = 'Emu64 ("*")' then
   begin
    if fileexists(IniFluff.ReadString('Emu64', 'Location', '')) = false then
     begin
      answer := MessageDlg('Emu64 not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
   If lowercase(ExtractFileExt(FileFull)) = '.nib' then
    begin
     answer := MessageDlg('EMu64 does not support nib images!',mtWarning, [mbOK], 0);
     if answer = mrOk then
      begin
       exit;
      end;
    end;
  DBGridDirTxt_ReadEntry;
    if LstBxDirectoryPETSCII.ItemIndex = 0 then
     begin
      OpenEmu(IniFluff.ReadString('Emu64', 'Location', ''), ' -a "' + FileFull + '"');
     end;
    if LstBxDirectoryPETSCII.ItemIndex > 0 then
     begin
      //i := LstBxDirectoryPETSCII.ItemIndex;
      //s := lowercase(LstBxDirectoryTXT.Items[i-1]);
      OpenEmu(IniFluff.ReadString('Emu64', 'Location', ''), ' -a "' + FileFull + '"');
      //OpenEmu(IniFluff.ReadString('Emu64', 'Location', ''), ' -a ' + '"' + FileFull + '":"' + s + '"');
     end;
   end;

   // Emu64 mount only ######################################################
  If cbEmulator.Text = 'Emu64 (mount only)' then
   begin
    if fileexists(IniFluff.ReadString('Emu64', 'Location', '')) = false then
     begin
      answer := MessageDlg('Emu64 not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
    OpenEmu(IniFluff.ReadString('Emu64', 'Location', ''), ' -m 8 "' + FileFull + '"');
   end;

  // Hoxs64 #################################################################
  If cbEmulator.Text = 'Hoxs64' then
   begin
    if fileexists(IniFluff.ReadString('Hoxs64', 'Location', '')) = false then
     begin
      answer := MessageDlg('Hoxs64 not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg('Hoxs64 does not support d81 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg('Hoxs64 does not support d71 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    DBGridDirTxt_ReadEntry;
    if LstBxDirectoryPETSCII.ItemIndex = 0 then
     begin
      OpenEmu(IniFluff.ReadString('Hoxs64', 'Location', ''),' -autoload "' + FileFull + '"');
     end;
    if LstBxDirectoryPETSCII.ItemIndex > 0 then
     begin
      i := LstBxDirectoryPETSCII.ItemIndex;
      s := lowercase(LstBxDirectoryTXT.Items[i-1]);
      OpenEmu(IniFluff.ReadString('Hoxs64', 'Location', ''),' -autoload "' + FileFull + '" #' + IntToStr(i-1) + '');
     end;
   end;
  // Hoxs64 mount only #######################################################
  If cbEmulator.Text = 'Hoxs64 (mount only)' then
   begin
    if fileexists(IniFluff.ReadString('Hoxs64', 'Location', '')) = false then
     begin
      answer := MessageDlg('Hoxs64 not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg('Hoxs64 does not support d81 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg('Hoxs64 does not support d71 images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    OpenEmu(IniFluff.ReadString('Hoxs64', 'Location', ''),' -mountdisk "' + FileFull + '"');
   end;

  // Vice ###################################################################
  If cbEmulator.Text = 'Vice' then
   begin
    if fileexists(IniFluff.ReadString('VICE', 'Location', '')) = false then
     begin
      answer := MessageDlg('VICE not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;

     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg('VICE does not support nib images!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;

    // FileBrowser
    If PageControl1.Pages[1].Visible = true then
     begin
      img_file := ShellTreeView1.Selected.GetTextPath + '\' + LstBrowse.Selected.Caption;
      if LstBxDirectoryPETSCII.ItemIndex = 0 then
       begin
        OpenEmu(IniFluff.ReadString('VICE', 'Location', ''), ' -autostart "' + img_file + '"');
       end;
      if LstBxDirectoryPETSCII.ItemIndex > 0 then
       begin
        i := LstBxDirectoryPETSCII.ItemIndex;
        s := lowercase(LstBxDirectoryTXT.Items[i-1]);
        OpenEmu(IniFluff.ReadString('VICE', 'Location', ''), ' -autostart "' + img_file + ':' + s + '"');
       end;
      exit;
     end;

    // Database
    DBGridDirTxt_ReadEntry;
    if LstBxDirectoryPETSCII.ItemIndex = 0 then
     begin
      OpenEmu(IniFluff.ReadString('VICE', 'Location', ''), ' -autostart "' + FileFull + '"');
     end;
    if LstBxDirectoryPETSCII.ItemIndex > 0 then
     begin
      i := LstBxDirectoryPETSCII.ItemIndex;
      s := lowercase(LstBxDirectoryTXT.Items[i-1]);
      OpenEmu(IniFluff.ReadString('VICE', 'Location', ''), ' -autostart "' + FileFull + ':' + s + '"');
     end;
   end;

  // Vice mount only #########################################################
  If cbEmulator.Text = 'Vice (mount only)' then
   begin
    if fileexists(IniFluff.ReadString('VICE', 'Location', '')) = false then
     begin
      answer := MessageDlg('VICE not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
    OpenEmu(IniFluff.ReadString('VICE', 'Location', ''), ' -8 "' + FileFull + '"');
   end;

  // DirMaster ##############################################################
  If cbEmulator.Text = 'DirMaster' then
   begin
    if fileexists(IniFluff.ReadString('DirMaster', 'Location', '')) = false then
     begin
      answer := MessageDlg('DirMaster not found!',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
    OpenEmu(IniFluff.ReadString('DirMaster', 'Location', ''), ' "' + FileFull + '"');
   end;

  // Save DateLast opened
  if ATransaction.Active then
   begin
     SQlQueryDir.Edit;
     SQlQueryDir.FieldByName('DateLast').AsString := DateTimeTostr(now);
     SQlQueryDir.Post;
     SQlQueryDir.ApplyUpdates;
   end;

end;


procedure TForm1.memInfoEditingDone(Sender: TObject);
begin
  if ATransaction.Active then
   begin
     SQlQueryDir.Edit;
     SQlQueryDir.FieldByName('Info').AsString := memInfo.Lines.Text;
     SQlQueryDir.Post;
     SQlQueryDir.ApplyUpdates;
   end;
end;

procedure TForm1.mnuFavouriteRecClick(Sender: TObject);
begin
  if EdSQLSearch.Focused = false then
   begin
     if SQLQueryDir.RecordCount < 1 then exit;
     if ATransaction.Active then
      begin
       if SQLQueryDir.FieldByName('Favourite').AsBoolean = true then
        begin
         SQlQueryDir.Edit;
         SQlQueryDir.FieldByName('Favourite').AsBoolean := false;
         SQlQueryDir.Post;
         SQlQueryDir.ApplyUpdates;
         exit;
        end;
       if SQLQueryDir.FieldByName('Favourite').AsBoolean = false  then
        begin
         SQlQueryDir.Edit;
         SQlQueryDir.FieldByName('Favourite').AsBoolean := true;
         SQlQueryDir.Post;
         SQlQueryDir.ApplyUpdates;
        end;
      end;
   end;
end;

procedure TForm1.mnuCorruptRecClick(Sender: TObject);
begin
  if EdSQLSearch.Focused = false then
   begin
     if SQLQueryDir.RecordCount < 1 then exit;
     if ATransaction.Active then
      begin
       if SQLQueryDir.FieldByName('Corrupt').AsBoolean = true then
        begin
         SQlQueryDir.Edit;
         SQlQueryDir.FieldByName('Corrupt').AsBoolean := false;
         SQlQueryDir.Post;
         SQlQueryDir.ApplyUpdates;
         exit;
        end;
       if SQLQueryDir.FieldByName('Corrupt').AsBoolean = false  then
        begin
         SQlQueryDir.Edit;
         SQlQueryDir.FieldByName('Corrupt').AsBoolean := true;
         SQlQueryDir.Post;
         SQlQueryDir.ApplyUpdates;
        end;
      end;
   end;
end;

procedure TForm1.mnuViewDateLastClick(Sender: TObject);
begin
 // DateLast
 if DBGridDir.Columns[4].Visible = true then
  begin
   DBGridDir.Columns[4].Visible:= false;
   mnuViewDateLast.Checked:=false;
   IniFluff.WriteBool('Database', 'Column4', false);
  end
  else
   begin
    DBGridDir.Columns[4].Visible:= true;
    mnuViewDateLast.Checked:=true;
    IniFluff.WriteBool('Database', 'Column4', true);
   end;
end;

procedure TForm1.mnuViewDateImportedClick(Sender: TObject);
begin
 // Imported
 if DBGridDir.Columns[5].Visible = true then
  begin
   DBGridDir.Columns[5].Visible:= false;
   mnuViewDateImported.Checked:=false;
   IniFluff.WriteBool('Database', 'Column5', false);
  end
  else
   begin
    DBGridDir.Columns[5].Visible:= true;
    mnuViewDateImported.Checked:=true;
    IniFluff.WriteBool('Database', 'Column5', true);
   end;
end;

procedure TForm1.mnuViewLocationClick(Sender: TObject);
begin
 // Location
 if DBGridDir.Columns[8].Visible = true then
  begin
   DBGridDir.Columns[8].Visible:= false;
   mnuViewLocation.Checked:=false;
   IniFluff.WriteBool('Database', 'Column8', false);
  end
  else
   begin
    DBGridDir.Columns[8].Visible:= true;
    mnuViewLocation.Checked:=true;
    IniFluff.WriteBool('Database', 'Column8', true);
   end;
end;

procedure TForm1.mnuDelTempClick(Sender: TObject);
var
  tmpPathArch : TStringList;
  i : Integer;
begin
 // Clean tmp folder
 If MessageDlg('Are you sure you want to clear the temporary folder?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   try
    CleanTmp; // Clean tmp folder;
   except
   On E : Exception do
    begin
     ShowMessage(E.Message + ' - Unable to clear temporary folder! Please check files for "readonly" attribute.');
    end;
   end;
  end;
end;

procedure TForm1.mnuPropertiesClick(Sender: TObject);
begin
 Form2.showmodal;
end;

procedure TForm1.mnuDeleteRecClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   frmDel.ShowModal;
  end;
end;

procedure TForm1.mnuCloseClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.mnuCorruptClick(Sender: TObject);
begin
 mnuCorruptRec.Click;
end;

procedure TForm1.mnuDeleteClick(Sender: TObject);
begin
 mnuDeleteRec.Click;
end;

procedure TForm1.mnuFavouriteClick(Sender: TObject);
begin
  mnuFavouriteRec.Click;
end;

procedure TForm1.mnuManualClick(Sender: TObject);
begin
  Form5.ShowModal;
end;

procedure TForm1.mnuNewClick(Sender: TObject);
var
 answer : integer;
begin
 Database_OpenDialog.Title:='Create new database';
 if Database_OpenDialog.Execute then
 begin
  if FileExists(Database_OpenDialog.FileName) then
   begin
    answer := MessageDlg('Database already exists! Unable to create!',mtWarning, [mbOK], 0);
     if answer = mrOk then
      begin
       exit;
      end;
   end;
  try
    // Database_Create
    If Dev_Mode = true then Showmessage('[Dev_Mode] - Create database - Step 1');
    ATransaction.Active:=false;
    //AConnection.Close;
    AConnection := TSQLite3Connection.Create(nil);
    AConnection.DatabaseName := Database_OpenDialog.FileName;
    ATransaction := TSQLTransaction.Create(AConnection);
    AConnection.Transaction := ATransaction;
    AConnection.Open;
    ATransaction.StartTransaction;
    AConnection.ExecuteDirect('CREATE TABLE "DB"('+
                ' "idDB" Integer PRIMARY KEY,'+
                ' "DBVersion" String,'+
                ' "DBCreated" String,'+
                ' "DBComment" Char(1024));');
    // Table FileImage
    AConnection.ExecuteDirect('CREATE TABLE "FileImage"('+
                ' "idx" Integer PRIMARY KEY,'+
                ' "idxImg" Integer,'+
                ' "DateImport" String,'+
                ' "DateLast" String,'+
                ' "FilePath" Char(512),'+
                ' "FileName" Char(255),'+
                ' "FileNameExt" Char(3),'+
                ' "FileSizeImg" Integer,'+
                ' "FileDateTime" DateTime,'+
                ' "FileFull" Char(512) NOT NULL UNIQUE,'+
                ' "FileArchType" Char(16),'+
                ' "DiskName" Char(16),'+
                ' "DiskIDTxt" Char(3),'+
                ' "DOSTypeTxt" Char(2),'+
                ' "Favourite" Boolean,'+
                ' "Corrupt" Boolean,'+
                ' "Tags" Char(255),'+
                ' "Info" Char(255),'+
                ' "BlocksFreeTxt" Char(5));');
    // Index
    AConnection.ExecuteDirect('CREATE UNIQUE INDEX "Data_id_idx" ON "FileImage"( "idxImg" );');
    // Table FilePath
    AConnection.ExecuteDirect('CREATE TABLE "FilePath"('+
                ' "idFp" Integer PRIMARY KEY,'+
                ' "FilePath" Char(512) UNIQUE);');
    // Table Tracks
    AConnection.ExecuteDirect('CREATE TABLE "Tracks"('+
                ' "idx" Integer PRIMARY KEY,'+
                ' "idxTrks" Integer,'+
                ' "T18" Char(9728),'+   // D64 Dir
                ' "T19" Char(9728),'+   // D64 Dir extended
                ' "T40" Char(20780),'+  // D81 Dir
                ' "T53" Char(512));');  // D71 BAM
    // Table DirectoryTxt
    AConnection.ExecuteDirect('CREATE TABLE "DirectoryTXT"('+
                ' "idx" Integer PRIMARY KEY,'+
                ' "idxTxt" Integer,'+
                ' "FileSizeTxt" Char(5),'+
                ' "FileNameTxt" Char(16),'+
                ' "FileTypeTxt" Char(3),'+
                ' FOREIGN KEY (idxTxt) REFERENCES FileImage(idxImg));');
    // Version, Created
    AConnection.ExecuteDirect('insert into DB (idDB,DBVersion,DBCreated) values (1,''110'', ''' + DateToStr(now) + ''');');
    ATransaction.Commit;
    If Dev_Mode = true then Showmessage('[Dev_Mode] - Create database - Step 2');
  except
    answer := MessageDlg('Unable to create new Database!',mtWarning, [mbOK], 0);
     if answer = mrOk then
      begin
       ATransaction.Active:=false;
      end;
  end;

  AddToRecentFiles(Database_OpenDialog.FileName);

  mnuImport.Enabled:=true;
  mnuOpenRec.Enabled:=false;
  mnuOpenLocationRec.Enabled:=false;
  mnuFavouriteRec.Enabled:=false;
  mnuFavouriteRec.Enabled:=false;
  mnuCorruptRec.Enabled:=false;
  mnuDeleteRec.Enabled:=false;
  edTags.Enabled:=false;
  memInfo.Enabled:=false;
  mnuOpenImage.Enabled:=false;
  mnuOpenFileBrowser.Enabled:=false;
  mnuOpenExplorer.Enabled:=false;
  mnuFavourite.Enabled:=false;
  mnuCorrupt.Enabled:=false;
  mnuSync.Enabled:=false;
  mnuDelete.Enabled:=false;
  edTags.Enabled:=false;
  memInfo.Enabled:=false;
  StatusBar1.Panels[0].Text:= '0/0';
  StatusBar1.Panels[1].Text:= '';
  StatusBar1.Panels[2].Text:= '';
  StatusBar1.Panels[3].Text:= '';
  LstBxDirectoryPETSCII.Clear;
  LstBxDirectoryPETSCII.Items.Add('File not found!');
  MemoBAMHint.Clear;
  Form1.Caption:= sAppCaption + sAppVersion + ' [' + ExtractFileName(Database_OpenDialog.FileName) + ']';
  IniFluff.WriteString('Database', 'Location', Database_OpenDialog.FileName);
  answer := MessageDlg('Succesfully created database!',mtInformation, [mbOK], 0);
   if answer = mrOk then
    begin
     //
    end;
   Init_FilePath;
   if ATransaction.Active then
    begin
     ATransaction.Commit;
    end;
   If Dev_Mode = true then Showmessage('[Dev_Mode] - Create database - End');
  end;
end;

procedure TForm1.mnuOpenClick(Sender: TObject);
begin
 Database_OpenDialog.Title:='Open database';
 if Database_OpenDialog.Execute then
  begin
   if fileexists(Database_OpenDialog.FileName) = true then
    begin
     OpenDatabase(Database_OpenDialog.FileName);
     AddToRecentFiles(Database_OpenDialog.FileName);
    end;
  end;
end;

procedure TForm1.mnuOpenExplorerClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   SysUtils.ExecuteProcess(UTF8ToSys('explorer.exe'), '/select,'+'"'+ FileFull +'"', []);
  end;
end;

procedure TForm1.mnuOpenFileBrowserClick(Sender: TObject);
begin
 //PageControl1.Pages[1].Show;
 //ShellTreeView1.Path := SQLQueryDir.FieldByName('FilePath').Text;
 //LstBrowse.Refresh;
 //LstBrowse.ItemIndex:= SQLQueryDir.RecNo-1;
 //LstBrowse.SetFocus;
end;

procedure TForm1.mnuOpenImageClick(Sender: TObject);
begin
 OpenDocument(IncludeTrailingPathDelimiter(SQLQueryDir.FieldByName('FilePath').DisplayText) + SQLQueryDir.FieldByName('FileName').DisplayText + '.' + SQLQueryDir.FieldByName('FileNameExt').DisplayText);
end;

procedure TForm1.mnuOpenLocationRecClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   SysUtils.ExecuteProcess(UTF8ToSys('explorer.exe'), '/select,'+'"'+ FileFull +'"', []);
  end;
end;

procedure TForm1.mnuOpenRecClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then OpenDocument(IncludeTrailingPathDelimiter(SQLQueryDir.FieldByName('FilePath').DisplayText) + SQLQueryDir.FieldByName('FileName').DisplayText + '.' + SQLQueryDir.FieldByName('FileNameExt').DisplayText);
end;

procedure TForm1.mnuOptionsClick(Sender: TObject);
begin
  Form4.Showmodal;
end;

procedure TForm1.mnuAboutClick(Sender: TObject);
begin
 Form3.lblVersion.Caption := sAppVersion + ' - ' + sAppDate;
 If Dev_Mode = true then Form3.lblVersion.Caption := sAppCaption + sAppVersion + ' [Dev_Mode]';
 Form3.Showmodal;
end;

procedure TForm1.mnuImportClick(Sender: TObject);
var
 StrSQL : String;
begin
 // Reset if search
 If EdSQLSearch.Text <> '' then
  begin
   StrSQL := '';
   EdSQLSearch.Text:='';  // Field reacts OnChange
   AConnection.ExecuteDirect('DROP Table IF EXISTS Search');
   If (cbDBFilePath.Text = 'All') AND (cbDBFileNameExt.Text = 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where idxImg in (SELECT idxTXT FROM DirectoryTXT';
    end;
   If (cbDBFilePath.Text = 'All') AND (cbDBFileNameExt.Text <> 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileNameExt = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT';
    end;
   if (cbDBFilePath.Text <> 'All') AND (cbDBFileNameExt.Text = 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT';
    end;
   if (cbDBFilePath.Text <> 'All') AND (cbDBFileNameExt.Text <> 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
    end;

   If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
    else
   If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
    else
   If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
   SQLQueryDir.SQL.Add(StrSQL);
   SQLQueryDir.Active := True;
   SQLQueryDir.First;
   DBFilter;
  end;

 //
 If SQLQueryDir.RecordCount > 0 then
  begin
   mnuOpenRec.Enabled:=true;
   mnuOpenLocationRec.Enabled:=true;
   mnuFavouriteRec.Enabled:=true;
   mnuFavouriteRec.Enabled:=true;
   mnuCorruptRec.Enabled:=true;
   mnuDeleteRec.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
   mnuOpenImage.Enabled:=true;
   mnuOpenFileBrowser.Enabled:=true;
   mnuOpenExplorer.Enabled:=true;
   mnuFavourite.Enabled:=true;
   mnuCorrupt.Enabled:=true;
   mnuSync.Enabled:=false;
   mnuDelete.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
  end
 else
  begin
   mnuOpenRec.Enabled:=false;
   mnuOpenLocationRec.Enabled:=false;
   mnuFavouriteRec.Enabled:=false;
   mnuFavouriteRec.Enabled:=false;
   mnuCorruptRec.Enabled:=false;
   mnuDeleteRec.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
   mnuOpenImage.Enabled:=false;
   mnuOpenFileBrowser.Enabled:=false;
   mnuOpenExplorer.Enabled:=false;
   mnuFavourite.Enabled:=false;
   mnuCorrupt.Enabled:=false;
   mnuSync.Enabled:=false;
   mnuDelete.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
  end;
  frmImport.Showmodal;
end;

Procedure TForm1.Init_FilePath;
var
  Str_FP : TStringlist;
  x : Integer;
  fp : String;
begin
    Str_FP := TStringList.Create;
    Str_FP.Sorted:=true;

    // Fill FileFull dropdown
    SQLQueryFP.DataBase := AConnection;
    SQLQueryFP.SQL.Clear;
    SQLQueryFP.SQL.Add('Select FilePath from FilePath ORDER BY FilePath ASC');
    SQLQueryFP.Active:=true;
    SQLQueryFP.First;
    cbDBFilePath.Clear;
    cbDBFilePath.Items.Add('All');
    while not SQLQueryFP.EOF do
     begin
     fp := SQLQueryFP.FieldByName('FilePath').Text;
      cbDBFilePath.Items.Add(fp);
      Str_FP.Add(fp);
      SQLQueryFP.Next;
     end;
    if Str_FP.Find(IniFluff.ReadString('Database', 'FilePathLast', cbDBFilePath.Text),x) = true then
     begin
      cbDBFilePath.Text:=IniFluff.ReadString('Database', 'FilePathLast', cbDBFilePath.Text);
     end
    else cbDBFilePath.ItemIndex:=0;
    SQLQueryFP.Active:=false;
end;

procedure TForm1.mnuSyncClick(Sender: TObject);
begin
 // frmImport.Init_str_FindAllImages_Sync;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  If PageControl1.Pages[1].Visible = true then
   begin
    LstBxDirectoryPETSCII.Clear;
    MemoBAMHint.Clear;
    LstBxDirectoryTXT.Clear;
    LstBAM.Clear;
    LstBoxSectors.Clear;
    lstBoxPETSCII.Clear;
   end;
end;

procedure TForm1.PageControl2Change(Sender: TObject);
var
 FileNameExt, FileSizeImg : String;
 BA : TByteArr;
 s, ImageSize : String;
begin
 if SQLQueryDir.Active then
  begin

 // Database
 If PageControl1.Pages[0].Visible = true then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text); // FileFull
   FileSizeImg := SQLQueryDir.FieldByName('FileSizeImg').Text;
   FileNameExt := lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString);
   if PageControl2.Pages[1].Visible = true then
    begin
     // TAP
     If (lowercase(FileNameExt) = 'tap') then LstBAM.Clear;
     // PRG
     If (lowercase(FileNameExt) = 'prg') then LstBAM.Clear;
     // D64/G64/NIB
     If (lowercase(FileNameExt) = 'd64') or (lowercase(FileNameExt) = 'g64') or (lowercase(FileNameExt) = 'nib') then LoadBAM_D64(FileFull, FileSizeImg);
     // D71
     If lowercase(FileNameExt) = 'd71' then LoadBAM_D71(FileFull);
     // D81
     If lowercase(FileNameExt) = 'd81' then LoadBAM_D81(FileFull);
    end;
   if PageControl2.Pages[2].Visible = true then
    begin
     Init_TrkSec_HexDropdown(FileFull);
     Init_SectorsHexDropDown;
     LoadTS(FileFull);
    end;
   exit;
  end;

  // FileBrowser
  //If PageControl1.Pages[1].Visible = true then
  // begin
  //  If LstBrowse.SelCount < 1 then Exit;
  //  FileFull := ShellTreeView1.Path + LstBrowse.Selected.caption;
  //  BA := LoadByteArray(FileFull);
  //  s := ByteArraytoHexString(BA);
  //  ImageSize := ByteArrayToHexString(BA);
  //  FileSizeImg := IntToStr(length(ImageSize) div 2);
  //  FileNameExt := ExtractFileExt(FileFull);
  //  if (length(FileNameExt)>0) and (FileNameExt[1]='.') then delete(FileNameExt,1,1); // d64 ohne Punkt
  //  GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
  //
  //  if PageControl2.Pages[1].Visible = true then
  //   begin
  //    // PRG
  //    If (lowercase(FileNameExt) = 'prg') then LstBAM.Clear;
  //    // D64/G64/NIB
  //    If (lowercase(FileNameExt) = 'd64') or (Lowercase(FileNameExt) = 'g64' or (lowercase(FileNameExt) = 'nib') then LoadBAM_D64(FileFull, FileSizeImg);
  //    // D71
  //    If lowercase(FileNameExt) = 'd71' then LoadBAM_D71(FileFull);
  //    // D81
  //    If lowercase(FileNameExt) = 'd81' then LoadBAM_D81(FileFull);
  //   end;
  //   if PageControl2.Pages[2].Visible = true then
  //   begin
  //    Init_TrkSec_HexDropdown(FileFull);
  //    Init_SectorsHexDropDown;
  //    LoadTS(FileFull);
  //   end;
  //   if PageControl2.Pages[3].Visible = true then
  //    begin
  //     LstBxDirectoryTxt.Clear;
  //    end;
  // end;

  end;
end;

procedure TForm1.LstBrowseClick(Sender: TObject);
var
 FileFull, FileSizeImg, FileNameExt : String;
 BA : TByteArr;
 s, ImageSize : String;
Begin
 If LstBrowse.SelCount < 1 then Exit;
 If FileExists(ShellTreeView1.Path + LstBrowse.Selected.caption) = true then
  begin
   FileFull    := ShellTreeView1.Path + LstBrowse.Selected.caption;
   FileNameExt := ExtractFileExt(FileFull);
   BA := LoadByteArray(FileFull);
   s := ByteArraytoHexString(BA);
   ImageSize := ByteArrayToHexString(BA);
   FileSizeImg := IntToStr(length(ImageSize) div 2);
   if (length(FileNameExt)>0) and (FileNameExt[1]='.') then delete(FileNameExt,1,1); // d64 ohne Punkt
   GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);

   if PageControl2.Pages[1].Visible = true then
    begin
     // TAP
     If (lowercase(FileNameExt) = 'tap') then LstBAM.Clear;
     // PRG
     If (lowercase(FileNameExt) = 'prg') then LstBAM.Clear;
     // D64/G64/NIB
     If (lowercase(FileNameExt) = 'd64') or (lowercase(FileNameExt) = 'g64') or (lowercase(FileNameExt) = 'nib') then LoadBAM_D64(FileFull, FileSizeImg);
     // D71
     If lowercase(FileNameExt) = 'd71' then LoadBAM_D71(FileFull);
     // D81
     If lowercase(FileNameExt) = 'd81' then LoadBAM_D81(FileFull);
    end;
    if PageControl2.Pages[2].Visible = true then
    begin
     LoadTS(FileFull);
    end;
    if PageControl2.Pages[3].Visible = true then
    begin
     LstBxDirectoryTxt.Clear;
    end;
  end;

end;

Procedure TForm1.OpenDatabase(aFileName : String);
var
 sTVersion : Integer;
 answer : Integer;
begin
 If Dev_Mode = true then Showmessage('[Dev_Mode] - Start OpenDatabase procedure');
 StatusBar1.Panels[0].Text:= '0/0';
 StatusBar1.Panels[1].Text:= '';
 StatusBar1.Panels[2].Text:= '';
 StatusBar1.Panels[3].Text:= '';
 MemoBAMHint.Clear;
 If Atransaction.Active then
  begin
   SQLQueryDir.Active:=false;
   ATransaction.Active:=false;
   AConnection.Close;
  end;
 AConnection := TSQLite3Connection.Create(nil);
 AConnection.DatabaseName := aFileName;
 ATransaction := TSQLTransaction.Create(AConnection);
 AConnection.Transaction := ATransaction;
 AConnection.Open;

 // Check version
 SQLQueryDB.DataBase := AConnection;
 SQLQueryDB.SQL.Clear;
 SQLQueryDB.SQL.Add('Select * from DB');
 SQLQueryDB.Active:=true;
 sTVersion := SQLQueryDB.FieldByName('DBVersion').AsInteger;
 If Dev_Mode = true then Showmessage('[Dev_Mode] - DB version: ' + IntToStr(sTVersion));

 If sTVersion < 107 then
  begin
   answer := MessageDlg('The database "' + aFileName + '" version "' + IntToStr(sTVersion) + '" is older than expected!' + chr(13) + 'Database will be converted!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      AConnection.ExecuteDirect('ALTER TABLE "DB" ADD "DBComment" Char(512);');
      AConnection.ExecuteDirect('ALTER TABLE "FileImage" ADD "FileArchPath" Char(512);');   // inside archive
      AConnection.ExecuteDirect('ALTER TABLE "FileImage" ADD "FileArchType" Char(16);');     // archive type e.g. zip
      SQlQueryDB.Edit;
      SQlQueryDB.FieldByName('DBVersion').AsString := '107';
      SQlQueryDB.Post;
      SQlQueryDB.ApplyUpdates;
      ATransaction.Commit;
     end;
  end;

  If sTVersion < 110 then
  begin
   answer := MessageDlg('The database "' + aFileName + '" version "' + IntToStr(sTVersion) + '" is older than expected!' + chr(13) + 'Database will be converted!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      If sTVersion < 107 then
       begin
        AConnection.ExecuteDirect('ALTER TABLE "DB" ADD "DBComment" Char(512);');
        AConnection.ExecuteDirect('ALTER TABLE "FileImage" ADD "FileArchPath" Char(512);');   // inside archive
        AConnection.ExecuteDirect('ALTER TABLE "FileImage" ADD "FileArchType" Char(16);');     // archive type e.g. zip
       end;

      AConnection.ExecuteDirect('ALTER TABLE FileImage RENAME TO FileImage_old;');
      // Table FileImage
      AConnection.ExecuteDirect('CREATE TABLE "FileImage"('+
                  ' "idx" Integer PRIMARY KEY,'+
                  ' "idxImg" Integer,'+
                  ' "DateImport" String,'+
                  ' "DateLast" String,'+
                  ' "FilePath" Char(512),'+
                  ' "FileName" Char(255),'+
                  ' "FileNameExt" Char(3),'+
                  ' "FileSizeImg" Integer,'+
                  ' "FileDateTime" DateTime,'+
                  ' "FileFull" Char(512) NOT NULL UNIQUE,'+
                  ' "FileArchType" Char(16),'+
                  ' "DiskName" Char(16),'+
                  ' "DiskIDTxt" Char(3),'+
                  ' "DOSTypeTxt" Char(2),'+
                  ' "Favourite" Boolean,'+
                  ' "Corrupt" Boolean,'+
                  ' "Tags" Char(255),'+
                  ' "Info" Char(255),'+
                  ' "BlocksFreeTxt" Char(5));');
      AConnection.ExecuteDirect('INSERT INTO FileImage (idx, idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeImg, FileDateTime, FileFull, FileArchType, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)' +
       ' SELECT idx, idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeImg, FileDateTime, FileFull, FileArchType, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt FROM FileImage_old;');
      AConnection.ExecuteDirect('DROP TABLE FileImage_old;');

      SQlQueryDB.Edit;
      SQlQueryDB.FieldByName('DBVersion').AsString := '110';
      SQlQueryDB.Post;
      SQlQueryDB.ApplyUpdates;
      ATransaction.Commit;
     end;
  end;

 If Dev_Mode = true then Showmessage('[Dev_Mode] - Database filter');
 DBFilter;

 // Last
 If Dev_Mode = true then Showmessage('[Dev_Mode] - Start Init_FilePath procedure');
 If aFileName <> IniFluff.ReadString('Database', 'Location', '') then IniFluff.ReadString('Database', 'FilePathLast', '');
 Init_FilePath;
 CleanTmp;
 DBFilter;

 Form1.Caption:= sAppCaption + sAppVersion + ' - [' + ExtractFileName(aFileName) + ']';
 If Dev_Mode = true then
  begin
   Form1.Caption:= sAppCaption + sAppVersion + ' [Dev_Mode] - [' + ExtractFileName(aFileName) + ']';
  end;
 IniFluff.WriteString('Database', 'Location', aFileName);
 mnuImport.Enabled:=true;

 If SQLQueryDir.RecordCount > 0 then
  begin
   Statusbar1.Panels[0].Text := ' ' + IntToStr(SQLQueryDir.RecNo) + '/' + IntToStr(SQLQueryDir.RecordCount);
   mnuOpenRec.Enabled:=true;
   mnuOpenLocationRec.Enabled:=true;
   mnuFavouriteRec.Enabled:=true;
   mnuFavouriteRec.Enabled:=true;
   mnuCorruptRec.Enabled:=true;
   mnuDeleteRec.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
   mnuOpenImage.Enabled:=true;
   mnuOpenFileBrowser.Enabled:=true;
   mnuOpenExplorer.Enabled:=true;
   mnuFavourite.Enabled:=true;
   mnuCorrupt.Enabled:=true;
   mnuSync.Enabled:=false;
   mnuDelete.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
  end
 else
  begin
   if SQLQueryDir.RecordCount < 1 then Statusbar1.Panels[0].Text := ' -/- ';
   mnuOpenRec.Enabled:=false;
   mnuOpenLocationRec.Enabled:=false;
   mnuFavouriteRec.Enabled:=false;
   mnuFavouriteRec.Enabled:=false;
   mnuCorruptRec.Enabled:=false;
   mnuDeleteRec.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
   mnuOpenImage.Enabled:=false;
   mnuOpenFileBrowser.Enabled:=false;
   mnuOpenExplorer.Enabled:=false;
   mnuFavourite.Enabled:=false;
   mnuCorrupt.Enabled:=false;
   mnuSync.Enabled:=false;
   mnuDelete.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
  end;
end;

procedure TForm1.Convert_G64NIB(aImageName: String);
var
 aImageNameD64 : String;
 answer : Integer;
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
    if IniFluff.ReadString('Options', 'FolderTemp', '') <> '' then
     begin
      if DirectoryExists(IniFluff.ReadString('Options', 'FolderTemp', '')) = false then
       begin
        answer := MessageDlg('Defined temporary folder does not exist! Please go to settings...',mtWarning, [mbOK], 0);
         if answer = mrOk then
          begin
           exit;
          end;
       end;
     end;

    // NibConv G64 or NIB to D64
    aImageNameD64 := ExtractFileName(ChangeFileExt(aImageName,'.d64'));
    nibProcess := TProcess.Create(nil);
    try
     nibProcess.Executable := '"' + IniFluff.ReadString('NibConv', 'Location', '') + '" ';
     nibProcess.Parameters.Add('"' + aImageName + '"');
     nibProcess.Parameters.Add(IncludeTrailingPathDelimiter(IniFluff.ReadString('Options', 'FolderTemp', '')) + aImageNameD64);
     nibProcess.ShowWindow := swoHide;
     nibProcess.Options := nibProcess.Options + [poWaitOnExit];
     nibProcess.Execute;
     except
      on E: Exception do frmImport.memoImportErr.Lines.Add('A convert exception was raised: ' + E.Message + '- File: ' + aImageName);
    end;
    nibProcess.Free;
end;

procedure TForm1.DBSearch;
var
 StrSQL : String;
begin
 StrSQL := '';
 if BtSQLSearch.Caption ='Reset' then
  begin
   EdSQLSearch.Text:='';  // Field reacts OnChange
   AConnection.ExecuteDirect('DROP Table IF EXISTS Search');
   If (cbDBFilePath.Text = 'All') AND (cbDBFileNameExt.Text = 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where idxImg in (SELECT idxTXT FROM DirectoryTXT';
    end;
   If (cbDBFilePath.Text = 'All') AND (cbDBFileNameExt.Text <> 'All') then
    begin
     if cbFilterCase.Checked = true then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileNameExt = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT';
     if cbFilterCase.Checked = false then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileNameExt COLLATE NOCASE = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT';
    end;
   if (cbDBFilePath.Text <> 'All') AND (cbDBFileNameExt.Text = 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT';
    end;
   if (cbDBFilePath.Text <> 'All') AND (cbDBFileNameExt.Text <> 'All') then
    begin
     StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
    end;

   If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
    else
   If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
    else
   If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
   SQLQueryDir.SQL.Add(StrSQL);
   SQLQueryDir.Active := True;
   SQLQueryDir.First;
   DBFilter;
   exit;
  end;

  if BtSQLSearch.Caption ='Search' then
   begin
    SQLQueryDirTXT.DataBase := AConnection;

    if cbSQLSearch.Text = 'Directory entry' then
     begin
      if BtSQLSearch.Caption ='Search' then  // Start Search
       begin
        AConnection.ExecuteDirect('CREATE TEMP TABLE "Search"('+
            ' "idx" Integer PRIMARY KEY,'+
            ' "idxSearch" Integer,'+
            ' "FileSizeTxt" Char(5),'+
            ' "FileNameTxt" Char(16),'+
            ' "FileTypeTxt" Char(3),'+
            ' "FilePath" String,'+
            ' "FileFull" String);');
        DBGridDirTxt.Clear;
        SQLQueryDirTxt.Close;
        SQLQueryDirTxt.SQL.Clear;
        SQLQueryDirTxt.SQL.Add('SELECT * FROM DirectoryTXT WHERE FileNameTxt Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"');
        SQLQueryDirTxt.Active := True;

        SQLQueryDir.Close;
        SQLQueryDir.SQL.Clear;
        DBGridDir.DataSource.DataSet.DisableControls;

        If (cbDBFilePath.Text = 'All') AND (cbDBFileNameExt.Text = 'All') then
         begin
          StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
         end;
        If (cbDBFilePath.Text = 'All') AND (cbDBFileNameExt.Text <> 'All') then
         begin
          if cbFilterCase.Checked = true then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileNameExt = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
          if cbFilterCase.Checked = false then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileNameExt COLLATE NOCASE = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
         end;
        if (cbDBFilePath.Text <> 'All') AND (cbDBFileNameExt.Text = 'All') then
         begin
          StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
         end;
        if (cbDBFilePath.Text <> 'All') AND (cbDBFileNameExt.Text <> 'All') then
         begin
          if cbFilterCase.Checked = true then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND FileNameExt = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
          if cbFilterCase.Checked = false then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND FileNameExt COLLATE NOCASE = "' + cbDBFileNameExt.Text + '" AND idxImg in (SELECT idxTXT FROM DirectoryTXT WHERE FileNameTxt like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '")';
         end;
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        SQLQueryDir.Active := True;
        SQLQueryDir.First;

        While not SQLQueryDir.EOF do
         begin
          SQlQueryDirTxt.Locate('idxTxt', SQLQueryDir.FieldByName('idxImg').Text, []);
          AConnection.ExecuteDirect('insert into Search (idxSearch, FileSizeTxt, FileNameTxt, FileTypeTxt, FileFull)'+
          ' values('+
          ' ''' + SQLQueryDirTxt.FieldByName('idxTxt').AsString + ''','+
          ' ''' + SQLQueryDirTxt.FieldByName('FileSizeTxt').AsString + ''','+
          ' ' + QuotedStr(SQLQueryDirTxt.FieldByName('FileNameTxt').AsString) + ','+
          ' ''' + SQLQueryDirTxt.FieldByName('FileTypeTxt').AsString + ''','+
          //' ' + QuotedStr(SQLQueryDir.FieldByName('FilePath').AsString) + ','+
          ' ' + QuotedStr(SQLQueryDir.FieldByName('FileFull').AsString)+');');
          SQLQueryDir.Next;
         end;
        DBGridDir.DataSource.DataSet.EnableControls;
        SQLQuerySearch.Close;
        SQLQuerySearch.DataBase := AConnection;
        SQLQuerySearch.SQL.Clear;
        SQLQuerySearch.SQL.Add('Select idxSearch, FileSizeTxt, FileNameTxt, FileTypeTxt, FileFull from Search');
        SQLQuerySearch.Active:=true;
        DBGridDirTxt.Visible:=true;
        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=true;
        DBGridSplitter.Visible:=true;

        If SQLQueryDir.RecordCount > 0 then SQLQueryDir.First;
        LoadDir;

        exit;
     end;
    end;

    if cbSQLSearch.Text = 'Diskname' then
     begin
      if BtSQLSearch.Caption ='Search' then  // Start Search
       begin
        DBGridDirTxt.Clear;

        Form1.SQLQueryDir.Close;
        Form1.SQLQueryDir.SQL.Clear;
        StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where DiskName Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        Form1.SQLQueryDir.Active := True;

        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=false;
        DBGridSplitter.Visible:=false;

        If Form1.SQLQueryDir.RecordCount > 0 then
         begin
          Form1.Statusbar1.Panels[0].Text := ' ' + IntToStr(Form1.SQLQueryDir.RecNo) + '/' + IntToStr(Form1.SQLQueryDir.RecordCount);
          UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
          GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
          Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
         end;
        If Form1.SQLQueryDir.RecordCount < 1 then    // Kein Suchergebnis
         begin
          LstBxDirectoryPETSCII.Clear;
          Statusbar1.Panels[0].Text := ' 0/0';
          Statusbar1.Panels[1].Text := 'No entries found';
          Statusbar1.Panels[2].Text := '';
          Statusbar1.Panels[3].Text := '';
          Statusbar1.Panels[4].Text := '';
         end;
        exit;
       end;
     end;

    if cbSQLSearch.Text = 'Image filename' then
     begin
      if BtSQLSearch.Caption ='Search' then  // Start Search
       begin
        DBGridDirTxt.Clear;

        Form1.SQLQueryDir.Close;
        Form1.SQLQueryDir.SQL.Clear;
        StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileName Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        Form1.SQLQueryDir.Active := True;

        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=false;
        DBGridSplitter.Visible:=false;

        If Form1.SQLQueryDir.RecordCount > 0 then
         begin
          Form1.Statusbar1.Panels[0].Text := ' ' + IntToStr(Form1.SQLQueryDir.RecNo) + '/' + IntToStr(Form1.SQLQueryDir.RecordCount);
          UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
          GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
          Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
         end;
        If Form1.SQLQueryDir.RecordCount < 1 then    // Kein Suchergebnis
         begin
          LstBxDirectoryPETSCII.Clear;
          Statusbar1.Panels[0].Text := ' 0/0';
          Statusbar1.Panels[1].Text := 'No entries found';
          Statusbar1.Panels[2].Text := '';
          Statusbar1.Panels[3].Text := '';
          Statusbar1.Panels[4].Text := '';
         end;
        exit;
       end;
      end;

    if cbSQLSearch.Text = 'Tags' then
     begin
      if BtSQLSearch.Caption ='Search' then  // Start Search
       begin
        DBGridDirTxt.Clear;

        Form1.SQLQueryDir.Close;
        Form1.SQLQueryDir.SQL.Clear;
        StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where Tags Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        Form1.SQLQueryDir.Active := True;

        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=false;
        DBGridSplitter.Visible:=false;

        If Form1.SQLQueryDir.RecordCount > 0 then
         begin
          Form1.Statusbar1.Panels[0].Text := ' ' + IntToStr(Form1.SQLQueryDir.RecNo) + '/' + IntToStr(Form1.SQLQueryDir.RecordCount);
          UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
          GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
          Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
         end;
        If Form1.SQLQueryDir.RecordCount < 1 then    // Kein Suchergebnis
         begin
          LstBxDirectoryPETSCII.Clear;
          Statusbar1.Panels[0].Text := ' 0/0';
          Statusbar1.Panels[1].Text := 'No entries found';
          Statusbar1.Panels[2].Text := '';
          Statusbar1.Panels[3].Text := '';
          Statusbar1.Panels[4].Text := '';
         end;
        exit;
       end;
      end;

    end;
end;

procedure TForm1.BtSQLSearchClick(Sender: TObject);
begin
 DBSearch;
end;

procedure TForm1.DBFilter;
var
 StrSQL : String;
begin
 StrSQL := '';
 SQLQueryDir.Close;
 SQLQueryDir.DataBase := AConnection;
 SQLQueryDir.SQL.Clear;

 If edSQLSearch.Text = '' then
  begin
   If cbDBFilePath.ItemIndex = 0 then  // All
    begin
     If cbDBFileNameExt.ItemIndex = 0 then // All
      begin
       StrSQL := 'Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, DateLast, DateImport, FilePath, Favourite, Corrupt, Tags, Info from FileImage';
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' WHERE Favourite = true'
       else
       If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' WHERE Corrupt = true'
       else
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' WHERE Favourite = true AND Corrupt = true';
      end
     else
      begin
       if cbFilterCase.Checked = true then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, DateLast, DateImport, FilePath, Favourite, Corrupt, Tags, Info FROM FileImage Where FileNameExt = "' + cbDBFileNameExt.Text + '"';
       if cbFilterCase.Checked = false then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, DateLast, DateImport, FilePath, Favourite, Corrupt, Tags, Info FROM FileImage Where FileNameExt COLLATE NOCASE = "' + cbDBFileNameExt.Text + '"';
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
       else
       If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
       else
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
      end;
     SQlQueryDir.SQL.Add(StrSQL);
     SQLQueryDir.Active:=true;
     LoadDir;
     exit;
    end;

   If cbDBFileNameExt.ItemIndex = 0 then
    begin
     If cbDBFilePath.ItemIndex = 0 then
      begin
       StrSQL := 'Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, FilePath, Favourite, Corrupt, Tags, Info from FileImage';
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' WHERE Favourite = true'
       else
       If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' WHERE Corrupt = true'
       else
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' WHERE Favourite = true AND Corrupt = true';
      end
     else
      begin
       StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, FilePath, Favourite, Corrupt, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
       else
       If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
       else
       If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
      end;
     SQLQueryDir.SQL.Add(StrSQL);
     SQLQueryDir.Active:=true;
     LoadDir;
     exit;
    end;

   // ELSE:
   if cbFilterCase.Checked = true then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, FilePath, Favourite, Corrupt, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND FileNameExt = "' + cbDBFileNameExt.Text + '"';
   if cbFilterCase.Checked = false then StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, FilePath, Favourite, Corrupt, Tags, Info FROM FileImage Where FilePath Like "' + StringReplace(cbDBFilePath.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '" AND FileNameExt COLLATE NOCASE = "' + cbDBFileNameExt.Text + '"';
   If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
   else
   If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
   else
   If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
   SQLQueryDir.SQL.Add(StrSQL);
   SQLQueryDir.Active:=true;
   LoadDir;
   exit;
  end;

 // #########################################################################################

 If edSQLSearch.Text <> '' then
  begin
   BtSQlSearch.Caption:='Search';
   AConnection.ExecuteDirect('DROP Table IF EXISTS Search');
   DBSearch;
   exit;
  end;
end;

procedure TForm1.cbDBFilePathChange(Sender: TObject);
begin
 CleanTmp;
 DBFilter;
end;

procedure TForm1.cbDBFileNameExtChange(Sender: TObject);
begin
 CleanTmp;
 DBFilter;
end;

procedure TForm1.cbFilterCaseChange(Sender: TObject);
begin
 CleanTmp;
 DBFilter;
end;

procedure TForm1.cbFilterCorruptChange(Sender: TObject);
begin
 CleanTmp;
 DBFilter;
end;

procedure TForm1.cbFilterFavChange(Sender: TObject);
begin
 CleanTmp;
 DBFilter;
end;

procedure TForm1.cbSectorChange(Sender: TObject);
begin
 If PageControl1.Pages[0].Visible = true then
  begin
   LoadTS(FileFull);
  end;
 If PageControl1.Pages[1].Visible = true then
  begin
   If LstBrowse.SelCount < 1 then Exit;
   LoadTS(ShellTreeView1.Path + LstBrowse.Selected.caption);
  end;
end;

procedure TForm1.cbSQLSearchChange(Sender: TObject);
begin
    If EdSQLSearch.Text = '' then
     begin
      BtSQLSearch.ImageIndex:=2;
      BtSQLSearch.Caption:='Search';
      BtSQLSearch.Enabled:=false;
      BtSQLSearch.Default:=false;
      DBGridDir.Visible:=true;
      DBGridDirTxt.Visible:=false;
      DBGridSplitter.Visible:=false;
      exit;
     end;

    If EdSQLSearch.Text <> '' then
     begin
      if BtSQLSearch.Caption <>'Reset' then
       begin
        BtSQLSearch.ImageIndex:=2;
        BtSQLSearch.Caption:='Search';
        BtSQLSearch.Enabled:=true;
        BtSQLSearch.Default:=true;
       end;
      if BtSQLSearch.Caption = 'Reset' then
       begin
        AConnection.ExecuteDirect('DROP Table IF EXISTS Search');
        DBGridDir.Visible:=true;
        BtSQLSearch.ImageIndex:=2;
        BtSQLSearch.Caption:='Search';
        BtSQLSearch.Enabled:=true;
        BtSQLSearch.Default:=true;
       end;
     end;
end;

procedure TForm1.cbTrackChange(Sender: TObject);
begin
 If PageControl1.Pages[1].Visible = true then
  begin
   If LstBrowse.SelCount < 1 then Exit;
  end;
 If PageControl1.Pages[0].Visible = true then
  begin
   Init_SectorsHexDropDown;
   LoadTS(FileFull);
  end;
 If PageControl1.Pages[1].Visible = true then
  begin
   If LstBrowse.SelCount < 1 then Exit;
   Init_SectorsHexDropDown;
   LoadTS(ShellTreeView1.Path + LstBrowse.Selected.caption);
  end;
end;

procedure TForm1.DBGridDirCellClick(Column: TColumn);
begin
 if DBGridDirTxt.Visible = true then
  begin
   if SQlQuerySearch.RecordCount > 0 then SQlQuerySearch.Locate('idxSearch', SQLQueryDir.FieldByName('idxImg').Text, []);
  end;
 if SQLQueryDir.RecordCount > 0 then
  begin
   if ATransaction.Active then
    begin
     SQlQueryDir.ApplyUpdates;
    end;
   CleanTmp;
   LoadDir;
  end;
end;

procedure TForm1.TgCShiftChange(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
  end;
end;

procedure TForm1.TgScratchChange(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   GetDirectoryImage(FileFull, TgScratch.Checked, TgCShift.Checked);
  end;
end;

procedure GetDirectoryImage(aFileFull : String; aScratch : Boolean; aLower: Boolean);
var
  fstream : TFileStream;
  filesizeImg, aImageNameD64 : String;
  aImageName : PChar;
Begin
  Form1.LstBxDirectoryPETSCII.Clear;
  Form1.Statusbar1.Panels[1].text := '';
  aImageNameD64 := '';
  // Check if g64 or nib
  If (Lowercase(ExtractFileExt(aFileFull)) = '.g64') or (Lowercase(ExtractFileExt(aFileFull)) = '.nib') then
   begin
    Form1.Convert_G64NIB(aFileFull);
    aImageNameD64 := ExtractFileNameOnly(aFileFull)+'.d64';
    aFileFull := IncludeTrailingPathDelimiter(IniFluff.ReadString('Options', 'FolderTemp', ''))+aImageNameD64;
   end; // G64/NIB END
  case LowerCase(ExtractFileExt(aFileFull)) of
   '.tap':
     begin
      Form1.SQLQueryDirTXT.DataBase := Form1.AConnection;
      Form1.SQLQueryDirTxt.Close;
      Form1.SQLQueryDirTxt.SQL.Clear;
      Form1.SQLQueryDirTxt.SQL.Add('SELECT * FROM DirectoryTXT WHERE idxTXT = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
      Form1.SQLQueryDirTxt.Active := True;
      Form1.SQLQueryDirTxt.First;
      Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%', [Form1.SQLQueryDirTXT.FieldByName('FileSizeTxt').Text, Form1.SQLQueryDirTXT.FieldByName('FileNameTxt').Text]));
      Form1.Statusbar1.Panels[1].text := '';
      Form1.Statusbar1.Panels[2].Text := 'Tape file (TAP)';
     end;
   '.prg':
     begin
      Form1.SQLQueryDirTXT.DataBase := Form1.AConnection;
      Form1.SQLQueryDirTxt.Close;
      Form1.SQLQueryDirTxt.SQL.Clear;
      Form1.SQLQueryDirTxt.SQL.Add('SELECT * FROM DirectoryTXT WHERE idxTXT = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
      Form1.SQLQueryDirTxt.Active := True;
      Form1.SQLQueryDirTxt.First;
      Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%', [Form1.SQLQueryDirTXT.FieldByName('FileSizeTxt').Text, Form1.SQLQueryDirTXT.FieldByName('FileNameTxt').Text]));
      Form1.Statusbar1.Panels[1].text := '';
      Form1.Statusbar1.Panels[2].Text := 'Program file (PRG)';
     end;

   '.d64':
     begin
      // Check if T18/T19 from db is needed and available
      If (IniFluff.ReadBool('Options', 'cbPETSCIITracks', false) = true) then
       begin
        Form1.SQLQueryTrks.DataBase := Form1.AConnection;
        Form1.SQLQueryTrks.Close;
        Form1.SQLQueryTrks.SQL.Clear;
        Form1.SQLQueryTrks.SQL.Add('SELECT * FROM Tracks WHERE idxTrks = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
        Form1.SQLQueryTrks.Active := True;
        Form1.SQLQueryTrks.First;
        Form1.Statusbar1.Panels[3].Text := 'Database';
        if (Form1.SQlQueryTrks.RecordCount = 1) then  // Saved in db?
         begin
          arrD64[18,0] := Form1.SQLQueryTrks.FieldByName('T18').AsString;
          arrD64[19,0] := Form1.SQLQueryTrks.FieldByName('T19').AsString;
          Form1.ReadDirEntries_D64;
          filesizeImg := Form1.SQlQueryDir.FieldByName('filesizeImg').AsString;
         end;
        end
      else      // From file
       begin
        Form1.Statusbar1.Panels[3].Text := 'File';
        fstream:= TFileStream.Create(aFileFull, fmShareCompat or fmOpenRead);
        filesizeImg := FloatToStr(fstream.Size);
        fstream.Free;
        Init_ArrD64(aFileFull);
        Form1.ReadDirEntries_D64;
       end;
      case (filesizeImg) of
       ''       : Form1.Statusbar1.Panels[1].text := 'Directory not stored in database';
       '174848' : Form1.Statusbar1.Panels[1].text := '35 tracks, no error bytes';
       '175531' : Form1.Statusbar1.Panels[1].text := '35 tracks, 683 error bytes';
       '196608' : Form1.Statusbar1.Panels[1].text := '40 tracks, no error bytes';
       '197376' : Form1.Statusbar1.Panels[1].text := '40 tracks, 768 error bytes';
       '205312' : Form1.Statusbar1.Panels[1].text := '42 tracks, no error bytes';
       '206114' : Form1.Statusbar1.Panels[1].text := '42 tracks, 802 error bytes';
      otherwise
       Form1.Statusbar1.Panels[1].text := 'unknown tracks, unknown error bytes';
      end;

      // tmp d64 delete (source was g64/nib file)
      If aImageNameD64 <>'' then
       begin
        //aImageName := PChar(IncludeTrailingPathDelimiter(IniFluff.ReadString('Options', 'FolderTemp', ''))+ aImageNameD64);
        aImageName := PChar(IniFluff.ReadString('Options', 'FolderTemp', '')+ aImageNameD64);
        If fileexists(aImageName) then DeleteFileUtf8(aImageName);
       end;
     end;

   '.d71':
      begin
       // Check if T18/T53 from db is needed and available
       If (IniFluff.ReadBool('Options', 'cbPETSCIITracks', false) = true) then
        begin
         Form1.SQLQueryTrks.DataBase := Form1.AConnection;
         Form1.SQLQueryTrks.Close;
         Form1.SQLQueryTrks.SQL.Clear;
         Form1.SQLQueryTrks.SQL.Add('SELECT * FROM Tracks WHERE idxTrks = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
         Form1.SQLQueryTrks.Active := True;
         Form1.SQLQueryTrks.First;
         Form1.Statusbar1.Panels[3].Text := 'Database';
         if (Form1.SQlQueryTrks.RecordCount = 1) then  // Saved in db?
          begin
           arrD71[18,0] := Form1.SQLQueryTrks.FieldByName('T18').AsString;
           arrD71[53,0] := Form1.SQLQueryTrks.FieldByName('T53').AsString;
           Form1.ReadDirEntries_D64;
           filesizeImg := Form1.SQlQueryDir.FieldByName('filesizeImg').AsString;
          end;
         end
       else      // From file
        begin
         Form1.Statusbar1.Panels[3].Text := 'File';
         fstream:= TFileStream.Create(aFileFull, fmShareCompat or fmOpenRead);
         filesizeImg := FloatToStr(fstream.Size);
         fstream.Free;
         Init_ArrD71(aFileFull);
         Form1.ReadDirEntries_D71;
        end;
       case (filesizeImg) of
        ''       : Form1.Statusbar1.Panels[1].text := 'Directory not stored in database';
        '349696' : Form1.Statusbar1.Panels[1].text := '70 tracks, no error bytes';
        '351062' : Form1.Statusbar1.Panels[1].text := '70 tracks, 1366 error bytes';
       otherwise
        Form1.Statusbar1.Panels[1].text := 'unknown tracks, unknown error bytes';
       end;
      end;

   '.d81':
      begin
       // Check if T40 from db is needed and available
       If (IniFluff.ReadBool('Options', 'cbPETSCIITracks', false) = true) then
        begin
         Form1.SQLQueryTrks.DataBase := Form1.AConnection;
         Form1.SQLQueryTrks.Close;
         Form1.SQLQueryTrks.SQL.Clear;
         Form1.SQLQueryTrks.SQL.Add('SELECT * FROM Tracks WHERE idxTrks = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
         Form1.SQLQueryTrks.Active := True;
         Form1.SQLQueryTrks.First;
         Form1.Statusbar1.Panels[3].Text := 'Database';
         if (Form1.SQlQueryTrks.RecordCount = 1) then  // Saved in db?
          begin
           arrD81[40,0] := Form1.SQLQueryTrks.FieldByName('T40').AsString;
           Form1.ReadDirEntries_D81;
           filesizeImg := Form1.SQlQueryDir.FieldByName('filesizeImg').AsString;
          end;
         end
       else      // From file
        begin
         Form1.Statusbar1.Panels[3].Text := 'File';
         fstream:= TFileStream.Create(aFileFull, fmShareCompat or fmOpenRead);
         filesizeImg := FloatToStr(fstream.Size);
         fstream.Free;
         Init_ArrD81(aFileFull);
         Form1.ReadDirEntries_D81;
        end;
       case (filesizeImg) of
        ''       : Form1.Statusbar1.Panels[1].text := 'Directory not stored in database';
        '819200' : Form1.Statusbar1.Panels[1].text := '80 tracks, no error bytes';
        '822400' : Form1.Statusbar1.Panels[1].text := '80 tracks, 3200 error bytes';
       otherwise
        Form1.Statusbar1.Panels[1].text := 'unknown tracks, unknown error bytes';
       end;
      end;

  end;
end;


Function GetArrayDir_PETSCII(arrTrackSector : String; aPosition : Integer; aLength : Integer; aTGCScratched : Boolean; aTGCShift : Boolean) : String;
Var
  sb : String;
  a, z : Integer;
Begin
  // e.g. arrTrackSector = arrD64[18,0]
  a := 1;
  sb := Copy(arrTrackSector, aPosition, aLength);
  For z := 1 to (aLength div 2) do
   Begin
    result := result + GetUTF8('$' + Copy(sb, a, 2), aTGCScratched, aTGCShift);
    // “A0” problem really a problem ? ImageTitle
    a := a + 2;
   End;
End;

Procedure TForm1.ReadDirEntries_D64;
var
  sb : String;
  ImgTitle, ImgDiskID, ImgDOSVersion, ImgDOSType, ImgBAMInfo, FileType, FileName, FileBlocks, imgBlocksfree : String;
  a, b, bf, bf2, g, t, x, z, repeated, track, sector, sectorcount, sectorpos, TrackNext, SectorNext : Integer;
  arrSec: array[0..19] of Byte;
begin
   // Read out of ArrD64 #######################################################

   // Directory title floppy
   ImgTitle := GetArrayDir_PETSCII(arrD64[18,0], 289, 32, true, Form1.TgCShift.Checked);
   // Directory DiskID // 20
   ImgDiskID := GetArrayDir_PETSCII(arrD64[18,0], 325, 6, true, Form1.TgCShift.Checked);
   //Disk DOS version type $41 ("A")
   ImgDOSVersion := GetArrayDir_PETSCII(arrD64[18,0], 5, 2, true, Form1.TgCShift.Checked);
   If (Copy(arrD64[18,0], 5, 2) = '41') or (Copy(arrD64[18,0], 5, 2) = '00') then
    begin
     Form1.Statusbar1.Panels[2].Text := 'DOS version type: ' + Copy(arrD64[18,0], 5, 2);
    end
   else Form1.Statusbar1.Panels[2].Text := 'Soft write protection';
   // Directory imgDOSType //   A5-A6: DOS type, usually "2A"
   ImgDOSType := GetArrayDir_PETSCII(arrD64[18,0], 331, 4, true, Form1.TgCShift.Checked);

   Form1.LstBxDirectoryPETSCII.Items.Add('0 ' + GetUTF8('$22', true, Form1.TgCShift.Checked) + imgTitle + GetUTF8('$22', true, Form1.TgCShift.Checked) + GetUTF8('$20', true, Form1.TgCShift.Checked) + ImgDiskID + ImgDOSType);

   // Directory BAM memInfo
   ImgBAMInfo := GetArrayDir_PETSCII(arrD64[18,0], 335, 178, false, Form1.TgCShift.Checked);
   Form1.MemoBAMHint.Clear;
   Form1.MemoBAMHint.Lines.Add(ImgBAMInfo);

   //Repeat  // ###############################################################

    // Clear arrSec
    for z := 0 to 19 do
     begin
      arrSec[z] := 0;
     end;

    t := 0;       // Repeat until t = 1
    track := 18;
    sector := 1;
    SectorCount := 1;
    repeated := 0;
    arrSec[repeated] := sector;   // 0=1

    // Buggy directories avoid error message
    If (Hex2Dec(Copy(arrD64[track,sector], 1, 2)) = 18) or (Hex2Dec(Copy(arrD64[track,sector], 1, 2)) = 19) then
     begin
      //
     end
     else
     begin
      t := 1;
      Statusbar1.Panels[2].Text := 'Not valid';
     end;

    Repeat  // #################################################################
     SectorPos := 0;    // 18.01 1st position of sector 01
     if (Hex2Dec(Copy(arrD64[track,sector], 3, 2)) > 19) AND (Hex2Dec(Copy(arrD64[track,sector], 3, 2)) <> 255) then t := 1; // bspw. "52"
     if (Hex2Dec(Copy(arrD64[track,sector], 3, 2)) = 00) then t :=1;
     For x := 1 to 8 do // 8 entries/sector
      Begin
       // FileType
       sb := Copy(arrD64[track,sector], SectorPos + 5, 2);    // e.g. ‘82’ = PRG
       FileType := ' ??? ';
       if sb = '00' then FileType := '*DEL ';
       if sb = '01' then FileType := '*SEQ ';
       if sb = '02' then FileType := '*PRG ';
       if sb = '03' then FileType := '*USR ';
       if sb = '04' then FileType := '*REL ';
       if sb = '40' then FileType := '*DEL<';
       if sb = '41' then FileType := '*SEQ<';
       if sb = '42' then FileType := '*PRG<';
       if sb = '43' then FileType := '*USR<';
       if sb = '44' then FileType := '*REL<';
       if sb = '80' then FileType := ' DEL ';
       if sb = '81' then FileType := ' SEQ ';
       if sb = '82' then FileType := ' PRG ';
       if sb = '83' then FileType := ' USR ';
       if sb = '84' then FileType := ' REL ';
       if sb = 'C0' then FileType := ' DEL<';
       if sb = 'C1' then FileType := ' SEQ<';
       if sb = 'C2' then FileType := ' PRG<';
       if sb = 'C3' then FileType := ' USR<';
       if sb = 'C4' then FileType := ' REL<';

       // FileName
       sb := Copy(arrD64[track,sector], SectorPos + 11, 32); // 16 character filename (in PETASCII, padded with $A0)
       if Copy(arrD64[track,sector], 1, 2) = '13' then Sector := Hex2Dec(Copy(arrD64[19,sector], SectorPos + 11, 32)); // e.g. “04”
      // if Copy(sectors_t18[0], 1, 2) = '13' then sb := Copy(sectors_t19[Sector], SectorPos + 11, 32);  // 16 character filename (in PETASCII, padded with $A0)
       a := 1;
       FileName := '"';
       g := 0;
       for z := 1 to 16 do
        begin
         if Copy(sb, a, 2) <> 'A0' then
          begin
           FileName := FileName + GetUTF8('$'+Copy(sb, a, 2),false,Form1.TgCShift.Checked);
           if g <> 1 then
            begin
             if z = 16 then FileName := FileName + '"';
            end;
          end;
         if Copy(sb, a, 2) = 'A0' then
          begin
           if g = 0 then
            begin
             FileName := FileName + '"';  // einmalig " am Filename Ende
             g := 1;
            end;
           FileName := FileName + ' '; // Leerstelle nach Gänsefüßchen
          end;
         a := a + 2;
        end;

       // FileSize (blocks)
       // $1E-$1F File size in sectors, low/high byte order ($1E+$1F*256). The approx. filesize in bytes is <= #sectors * 254
       //sb := Copy(sectors_t18[Sector], SectorPos + 61, 4);
       sb := Copy(arrD64[track,sector], SectorPos + 61, 4);
       a := Hex2Dec(Copy(sb, 1, 2));
       b := Hex2Dec(Copy(sb, 3, 2));
       FileBlocks := IntToStr(a + (b*256));

       if Copy(arrD64[track,sector], 1, 2) = '13' then // Track 19
        begin
         sb := Copy(arrD64[19,sector], SectorPos + 61, 4);
         a := Hex2Dec(Copy(sb, 1, 2));
         b := Hex2Dec(Copy(sb, 3, 2));
         FileBlocks := IntToStr(a + (b*256));
        end;

        SectorPos := SectorPos + 64; // 20-3F: Second dir entry - 40-5F: Third dir entry
       // List Directory entry in PETASCII
       if Form1.TgScratch.checked = true then // include deleted
        begin
         Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
        end;
       if Form1.TgScratch.checked = false then
        begin
         if FileType <> '*DEL ' then Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
        end;
       End; // 1 to 8

      If Hex2Dec(Copy(arrD64[track,sector], 1, 2)) = 19 then Showmessage ('Directory reached track 19!');

      // Next track/sector
      TrackNext := Hex2Dec(Copy(arrD64[track,sector], 1, 2)); // 18
      SectorNext := Hex2Dec(Copy(arrD64[track,sector], 3, 2)); // e.g. “04”
      if Copy(arrD64[track,sector], 1, 2) = '13' then SectorNext := Hex2Dec(Copy(arrD64[19,sector], 3, 2)); // e.g. “06”
      if TrackNext = 00 then t := 1;   // 00
      if SectorNext = 255 then t := 1; // FF

      // circular ausschließen
      if track = 18 then
       begin
        If repeated = 18 then t := 1; // Max 18 Durchgänge im track 18 dann t := 1 // Track 19 howto?
        for z := 0 to 19 do
         begin
          if arrSec[z] <> 0 then
           begin
            if arrSec[z] = SectorNext then t := 1;
           end;
         end;
       end;

     repeated := repeated + 1;
     arrSec[repeated] := SectorNext;  // 1 = e.g. 4
     Track := TrackNext;   // for repeat
     Sector := SectorNext; // for repeat
     SectorCount := SectorCount + 1;  // check if extended
    Until t = 1;  // ###########################################################

    If SectorCount > 18 then Statusbar1.Panels[2].Text := 'Extended directory';

    // Clear arrSec
    for z := 0 to 19 do
     begin
      arrSec[z] := 0;
     end;
    // ##########################################################################
    // Blocks free
     ImgBlocksFree := '';
     bf := 0; // blocksfree
     sb := Copy(arrD64[18,0],9,280+1); // 35x8=280
     //sb := Copy(arrD64[18,0],9,512+1); // für 40T
     a := 1;
     for z := 1 to 35 do
     begin
       bf2 := Hex2Dec(Copy(sb, a, 2));  // a beginning position 9
       If z <> 18 then bf := bf + bf2;
       a := a + 8;
      end;
     //a := a + 96;
     //for z := 36 to 40 do
     //begin
     //  bf2 := Hex2Dec(Copy(sb, a, 2));  // a beginning position 9
     //  If z <> 18 then bf := bf + bf2;
     //  a := a + 8;
     // end;
     ImgBlocksFree := ImgBlocksFree + IntToStr(bf);
     Form1.LstBxdirectoryPETSCII.Items.Add(ImgBlocksFree + ' BLOCKS FREE');

end;

Procedure TForm1.ReadDirEntries_D71;
var
  sb : String;
  ImgTitle, ImgDiskID, ImgDOSVersion, ImgDOSType, ImgBAMInfo, FileType, FileName, FileBlocks, imgBlocksfree : String;
  a, b, bf, bf2, g, t, x, z, repeated, track, sector, sectorcount, sectorpos, TrackNext, SectorNext : Integer;
  arrSec: array[0..19] of Byte;
begin
   // Read out of ArrD71 #######################################################
   // Directory title floppy
   ImgTitle := GetArrayDir_PETSCII(arrD71[18,0], 289, 32, true, Form1.TgCShift.Checked);
   // Directory DiskID // 20
   ImgDiskID := GetArrayDir_PETSCII(arrD71[18,0], 325, 6, true, Form1.TgCShift.Checked);
   //Disk DOS version type $41 ("A")
   ImgDOSVersion := GetArrayDir_PETSCII(arrD71[18,0], 5, 2, true, Form1.TgCShift.Checked);
   Form1.Statusbar1.Panels[2].Text := 'Dos type: ' + ImgDOSVersion;
   // Directory imgDOSType //   A5-A6: DOS type, usually "2A"
   ImgDOSType := GetArrayDir_PETSCII(arrD71[18,0], 331, 4, true, Form1.TgCShift.Checked);

   Form1.LstBxDirectoryPETSCII.Items.Add('0 ' + GetUTF8('$22', true, Form1.TgCShift.Checked) + imgTitle + GetUTF8('$22', true, Form1.TgCShift.Checked) + GetUTF8('$20', true, Form1.TgCShift.Checked) + ImgDiskID + ImgDOSType);

   // Directory BAM memInfo
   ImgBAMInfo := GetArrayDir_PETSCII(arrD71[18,0], 335, 178, false, Form1.TgCShift.Checked);
   Form1.MemoBAMHint.Clear;
   Form1.MemoBAMHint.Lines.Add(ImgBAMInfo);

   //Repeat  // ###############################################################
    // Clear arrSec
    for z := 0 to 19 do
     begin
      arrSec[z] := 0;
     end;

    t := 0;       // Repeat until t = 1
    track := 18;
    sector := 1;
    SectorCount := 1;
    repeated := 0;
    arrSec[repeated] := sector;   // 0=1
    Repeat  // #################################################################
     SectorPos := 0;    // 18.01 1st position of sector 01
     if (Hex2Dec(Copy(arrD71[track,sector], 3, 2)) > 18) AND (Hex2Dec(Copy(arrD71[track,sector], 3, 2)) <> 255) then t := 1; // bspw. "52"
     For x := 1 to 8 do // 8 entries/sector
      Begin
       // FileType
       sb := Copy(arrD71[track,sector], SectorPos + 5, 2);    // e.g. ‘82’ = PRG
       FileType := ' ??? ';
       if sb = '00' then FileType := '*DEL ';
       if sb = '01' then FileType := '*SEQ ';
       if sb = '02' then FileType := '*PRG ';
       if sb = '03' then FileType := '*USR ';
       if sb = '04' then FileType := '*REL ';
       if sb = '40' then FileType := '*DEL<';
       if sb = '41' then FileType := '*SEQ<';
       if sb = '42' then FileType := '*PRG<';
       if sb = '43' then FileType := '*USR<';
       if sb = '44' then FileType := '*REL<';
       if sb = '80' then FileType := ' DEL ';
       if sb = '81' then FileType := ' SEQ ';
       if sb = '82' then FileType := ' PRG ';
       if sb = '83' then FileType := ' USR ';
       if sb = '84' then FileType := ' REL ';
       if sb = 'C0' then FileType := ' DEL<';
       if sb = 'C1' then FileType := ' SEQ<';
       if sb = 'C2' then FileType := ' PRG<';
       if sb = 'C3' then FileType := ' USR<';
       if sb = 'C4' then FileType := ' REL<';

       // FileName
       sb := Copy(arrD71[track,sector], SectorPos + 11, 32); // 16 character filename (in PETASCII, padded with $A0)
       a := 1;
       FileName := '"';
       g := 0;
       for z := 1 to 16 do
        begin
         if Copy(sb, a, 2) <> 'A0' then
          begin
           FileName := FileName + GetUTF8('$'+Copy(sb, a, 2),false,Form1.TgCShift.Checked);
           if g <> 1 then
            begin
             if z = 16 then FileName := FileName + '"';
            end;
          end;
         if Copy(sb, a, 2) = 'A0' then
          begin
           if g = 0 then
            begin
             FileName := FileName + '"';  // einmalig " am Filename Ende
             g := 1;
            end;
           FileName := FileName + ' '; // Leerstelle nach Gänsefüßchen
          end;
         a := a + 2;
        end;

       // FileSize (blocks)
       // $1E-$1F File size in sectors, low/high byte order ($1E+$1F*256). The approx. filesize in bytes is <= #sectors * 254
       //sb := Copy(sectors_t18[Sector], SectorPos + 61, 4);
       sb := Copy(arrD71[track,sector], SectorPos + 61, 4);
       a := Hex2Dec(Copy(sb, 1, 2));
       b := Hex2Dec(Copy(sb, 3, 2));
       FileBlocks := IntToStr(a + (b*256));

       if Copy(arrD71[track,sector], 1, 2) = '13' then // Track 19
        begin
         sb := Copy(arrD71[19,sector], SectorPos + 61, 4);
         a := Hex2Dec(Copy(sb, 1, 2));
         b := Hex2Dec(Copy(sb, 3, 2));
         FileBlocks := IntToStr(a + (b*256));
        end;

        SectorPos := SectorPos + 64; // 20-3F: Second dir entry - 40-5F: Third dir entry
       // List Directory entry in PETASCII
       if Form1.TgScratch.checked = true then
        begin
         Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
        end;
       if Form1.TgScratch.checked = false then
        begin
         if FileType <> '*DEL ' then Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
        end;
       End; // 1 to 8

      // Next track/sector
      TrackNext := Hex2Dec(Copy(arrD71[track,sector], 1, 2)); // 18
      SectorNext := Hex2Dec(Copy(arrD71[track,sector], 3, 2)); // e.g. “04”
      if TrackNext = 00 then t := 1;   // 00
      if SectorNext = 255 then t := 1; // FF

      // circular ausschließen
      if track = 18 then
       begin
        If repeated = 18 then t := 1; // Max 18 Durchgänge im track 18 dann t := 1 // Track 19 howto?
        for z := 0 to 19 do
         begin
          if arrSec[z] <> 0 then
           begin
            if arrSec[z] = SectorNext then t := 1;
           end;
         end;
       end;

     repeated := repeated + 1;
     arrSec[repeated] := SectorNext;  // 1 = e.g. 4
     Track := TrackNext;   // for repeat
     Sector := SectorNext; // for repeat
     SectorCount := SectorCount + 1;  // check if extended
    Until t = 1;  // ###########################################################

     // Clear arrSec
     for z := 0 to 19 do
      begin
       arrSec[z] := 0;
      end;

    // ##########################################################################
    // Blocks free
    ImgBlocksFree := '';
    bf := 0; // blocksfree
    sb := Copy(arrD71[18,0],9,280+1); // 35x8=280
    a := 1;
    for z := 1 to 35 do
    begin
      bf2 := Hex2Dec(Copy(sb, a, 2));  // a beginning position 9
      If z <> 18 then bf := bf + bf2;
      a := a + 8;
     end;
    a := 1;
    sb := Copy(arrD71[18,0], 443, 70);
    for z := 1 to 35 do
      begin
       bf2 := Hex2Dec(Copy(sb, a, 2));
       bf := bf + bf2;
       a := a + 2;
      end;
    ImgBlocksFree := ImgBlocksFree + IntToStr(bf);
    Form1.LstBxdirectoryPETSCII.Items.Add(ImgBlocksFree + ' BLOCKS FREE');
    // Blocks free ENDE
end;

Procedure TForm1.ReadDirEntries_D81;
var
  a, b, bf, bf2, g, x, z, t, Track, Sector, TrackNext, SectorNext, SectorPos, SectorCount : Integer;
  sb : String;
  ImgTitle, imgDiskID, imgDOSType, FileType, FileName, FileBlocks, BlocksFree : String;
begin

  a := 1;
  // Directory title floppy
  sb := Copy(arrD81[40,0],a+8,32);
  ImgTitle := '';
  a := 1;
  for z := 1 to 16 do
    begin
     if Copy(sb, a, 2) <> 'A0' then
      begin
       ImgTitle := ImgTitle + GetUTF8('$'+Copy(sb, a, 2), true, Form1.TgCShift.Checked);
      end;
     if Copy(sb, a, 2) = 'A0' then ImgTitle := ImgTitle + GetUTF8('$A0', true, Form1.TgCShift.Checked);
    a := a + 2;
    end;
  // Directory title floppy ENDE

  // Directory DiskID // 20
  sb := Copy(arrD81[40,0],1+36,6);
  imgDiskID := '';
  a := 1;
   for z := 1 to 3 do
     begin
      ImgDiskID := ImgDiskID + GetUTF8('$'+Copy(sb, a, 2), true, Form1.TgCShift.Checked);
      a := a +2;
     end;
   // Directory DiskID // 20

   // Directory DOSType // 2A
   sb := Copy(arrD81[40,0],1+42,4);
   imgDOSType := '';
   a := 1;
   for z := 1 to 2 do
     begin
      imgDOSType := imgDOSType + GetUTF8('$'+Copy(sb, a, 2), true, Form1.TgCShift.Checked);
      a := a +2;
     end;
   Form1.Statusbar1.Panels[2].Text := 'Dos type: ' + imgDOSType;
   // Directory DOSType // 2A

   Form1.LstBxDirectoryPETSCII.Items.Add('0 ' + GetUTF8('$22', true, Form1.TgCShift.Checked) + imgTitle + GetUTF8('$22', true, Form1.TgCShift.Checked) + GetUTF8('$20', true, Form1.TgCShift.Checked) + ImgDiskID + imgDOSType);

   // Directory BAM memInfo
   Form1.MemoBAMHint.Clear;
   // Directory BAM memInfo Ende

    t := 0;  // Repeat until t = 1
    Track := 40;
    Sector := 3; // “40 03”
    SectorCount := 3;  // Check if extended outside track 40, beginngin 3-39
    Repeat  // ##################################################################
     SectorPos := 0;    // 40.01 1st position of sector 01
     if track = 00 then t := 1;
     if sector = 255 then t := 1;
     For x := 1 to 8 do // 8 entries/sector
      Begin
       // FileType
       sb := Copy(arrD81[track,sector], SectorPos + 5, 2);    // e.g. ‘82’ = PRG
       FileType := ' ??? ';
       if sb = '00' then FileType := '*DEL ';
       if sb = '01' then FileType := '*SEQ ';
       if sb = '02' then FileType := '*PRG ';
       if sb = '03' then FileType := '*USR ';
       if sb = '04' then FileType := '*REL ';
       if sb = '40' then FileType := '*DEL<';
       if sb = '41' then FileType := '*SEQ<';
       if sb = '42' then FileType := '*PRG<';
       if sb = '43' then FileType := '*USR<';
       if sb = '44' then FileType := '*REL<';
       if sb = '80' then FileType := ' DEL ';
       if sb = '81' then FileType := ' SEQ ';
       if sb = '82' then FileType := ' PRG ';
       if sb = '83' then FileType := ' USR ';
       if sb = '84' then FileType := ' REL ';
       if sb = 'C0' then FileType := ' DEL<';
       if sb = 'C1' then FileType := ' SEQ<';
       if sb = 'C2' then FileType := ' PRG<';
       if sb = 'C3' then FileType := ' USR<';
       if sb = 'C4' then FileType := ' REL<';

       // FileName
       sb := Copy(arrD81[track,sector], SectorPos + 11, 32);  // 16 character filename (in PETASCII, padded with $A0)
       a := 1;
       FileName := '"';
       g := 0;
       for z := 1 to 16 do
        begin
         if Copy(sb, a, 2) <> 'A0' then
          begin
           FileName := FileName + GetUTF8('$'+Copy(sb, a, 2),false,Form1.TgCShift.Checked);
           if g <> 1 then
            begin
             if z = 16 then FileName := FileName + '"';
            end;
          end;
         if Copy(sb, a, 2) = 'A0' then
          begin
           if g = 0 then
            begin
             FileName := FileName + '"';  // einmalig " am Filename Ende
             g := 1;
            end;
           FileName := FileName + ' '; // Leerstelle nach Gänsefüßchen
          end;
         a := a + 2;
        end;

       // FileSize (blocks)
       sb := Copy(arrD81[track,sector], SectorPos + 61, 4);
       a := Hex2Dec(Copy(sb, 1, 2));
       b := Hex2Dec(Copy(sb, 3, 2));
       FileBlocks := IntToStr(a + (b*256));

       SectorPos := SectorPos + 64;
        // List Directory entry in PETASCII
        if Form1.TgScratch.checked = true then
         begin
          Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
         end;
        if Form1.TgScratch.checked = false then
         begin
          if FileType <> '*DEL ' then Form1.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
         end;
       End; // 1 to 8

      // Next track/sector
      TrackNext := Hex2Dec(Copy(arrD81[track,sector], 1, 2)); // 40
      SectorNext := Hex2Dec(Copy(arrD81[track,sector], 3, 2)); // e.g. “04”
      if TrackNext = 00 then t := 1;   // 00
      if SectorNext = 255 then t := 1; // FF
      Track := TrackNext;
      Sector := SectorNext;
      SectorCount := SectorCount + 1; // check if extended
     Until t = 1;

     If SectorCount > 39 then Statusbar1.Panels[2].Text := 'Extended directory';

   // ##########################################################################
   // Blocks free
   bf := 0;
   bf2 := 0;
   a := 1;
   for z := 1 to 39 do
    begin
     bf2 := Hex2Dec(Copy(arrD81[40,1],a+32,2)); // 40.1 + 32 Stellen, da 10-15 BAM entry for track 1
     bf := bf + bf2;
     a := a + 12;
    end;
   a := 1;
   for z := 41 to 80 do
    begin
     bf2 := Hex2Dec(Copy(arrD81[40,2],a+32,2)); // 40.2 + 32 Stellen, da 10-15 BAM entry for track 1
     bf := bf + bf2;
     a := a + 12;
    end;
    blocksfree := IntToStr(bf);
    bf := 0;
    bf2 := 0;
   Form1.LstBxDirectoryPETSCII.Items.Add(BlocksFree + ' BLOCKS FREE.');
   // Blocks free ENDE

end;


procedure TForm1.DBGridDirDblClick(Sender: TObject);
begin
if SQlQueryDir.RecordCount > 0 then
 begin
  CleanTmp;
  UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
  If OpenDocument(FileFull) = true then
   begin
    // Save DateLast opened
    if ATransaction.Active then
     begin
       SQlQueryDir.Edit;
       SQlQueryDir.FieldByName('DateLast').AsString := DateTimeTostr(now);
       SQlQueryDir.Post;
       SQlQueryDir.ApplyUpdates;
     end;
   end;
 end;
end;
procedure TForm1.DBGridDirEnter(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   mnuOpenRec.Enabled:=true;
   mnuOpenLocationRec.Enabled:=true;
   mnuFavouriteRec.Enabled:=true;
   mnuCorruptRec.Enabled:=true;
   mnuDeleteRec.Enabled:=true;
  end;
end;

procedure TForm1.DBGridDirExit(Sender: TObject);
begin
 mnuOpenRec.Enabled:=false;
 mnuOpenLocationRec.Enabled:=false;
 mnuFavouriteRec.Enabled:=false;
 mnuCorruptRec.Enabled:=false;
 mnuDeleteRec.Enabled:=false;
end;

procedure TForm1.DBGridDirKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_UP) or (Key = VK_NEXT) or (Key = VK_PRIOR) or (Key = VK_HOME) or (Key = VK_END) then
   begin
    if SQLQueryDir.RecordCount > 0 then
     begin
      if DBGridDirTxt.Visible = true then
       begin
        if SQlQuerySearch.RecordCount > 0 then SQlQuerySearch.Locate('idxSearch', SQLQueryDir.FieldByName('idxImg').Text, []);
       end;
      CleanTmp;
      LoadDir;
     end;
   end;
end;
function GetNumScrollLines: Integer;
begin
  SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 1, @Result, 0);
end;
procedure TForm1.DBGridDirMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
   with TDBGrid(Sender) do
   begin
    If DBGridDir.Focused = true then
     begin
     if Assigned(DataSource) and Assigned(DataSource.DataSet) then
      begin
        if WheelDelta > 0 then
          SQLQueryDir.Prior
        else
          SQLQueryDir.Next;
      end;
     Handled := True;
     Invalidate;
    if DBGridDirTxt.Visible = true then
     begin
      if SQlQuerySearch.RecordCount > 0 then SQlQuerySearch.Locate('idxSearch', SQLQueryDir.FieldByName('idxImg').Text, []);
     end;
     CleanTmp;
     LoadDir;
   end;
  end;
end;

procedure TForm1.DBGridDirTitleClick(Column: TColumn);
begin
  // remove image on already selected column
  if dbGridSorted = 'ASC' then
   begin
    dbGridSorted := 'DESC';
    Form1.SQLQueryDir.IndexFieldNames := Column.FieldName + ' DESC';
    Column.Title.ImageIndex:=1; // Down
    // Remove the sort arrow from the previous column we sorted
    if (FLastColumn <> nil) and (FlastColumn <> Column) then
      FLastColumn.Title.ImageIndex:=-1;
    FLastColumn:=column;
    exit;
   end;
  if dbGridSorted = 'DESC' then
   begin
    dbGridSorted := 'ASC';
    Form1.SQLQueryDir.IndexFieldNames := Column.FieldName;
    Column.Title.ImageIndex:=0; // Up
    // Remove the sort arrow from the previous column we sorted
    if (FLastColumn <> nil) and (FlastColumn <> Column) then
      FLastColumn.Title.ImageIndex:=-1;
    FLastColumn:=column;
    Exit;
   end;
end;

procedure TForm1.DBGridDirSearch(Column: TColumn);
begin
  if SQLQueryDir.RecordCount > 0 then
   begin
    SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
    LoadDir;
   end;
end;

procedure TForm1.DBGridDirTxtCellClick(Column: TColumn);
begin
  if SQLQueryDir.RecordCount > 0 then
   begin
    SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
    LoadDir;
   end;
end;

procedure TForm1.DBGridDirTxtDblClick(Sender: TObject);
begin
  if SQLQueryDir.RecordCount > 0 then
   begin
    UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
    If OpenDocument(FileFull) = true then
     begin
      // Save DateLast opened
      if ATransaction.Active then
       begin
        SQlQueryDir.Edit;
        SQlQueryDir.FieldByName('DateLast').AsString := DateTimeTostr(now);
        SQlQueryDir.Post;
        SQlQueryDir.ApplyUpdates;
       end;
     end;
   end;
end;

procedure TForm1.DBGridDirTxtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_UP) or (Key = VK_NEXT) or (Key = VK_PRIOR) or (Key = VK_HOME) or (Key = VK_END) then
   begin
    if SQLQueryDir.RecordCount > 0 then
     begin
      SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
      CleanTmp;
      LoadDir;
     end;
   end;
end;

procedure TForm1.DBGridDirTxtMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  with TDBGrid(Sender) do
  begin
   If DBGridDirTxt.Focused = true then
   begin
    if Assigned(DataSource) and Assigned(DataSource.DataSet) then
     begin
       if WheelDelta > 0 then
         SQLQuerySearch.Prior
       else
         SQLQuerySearch.Next;
     end;
    Handled := True;
    Invalidate;
   if DBGridDirTxt.Visible = true then
    begin
    if SQLQueryDir.RecordCount > 0 then
     begin
      SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
     end;
    end;
    LoadDir;
  end;

  end;
end;

procedure TForm1.DBGridDirTxtTitleClick(Column: TColumn);
begin
  // remove image on already selected column
  if dbGridSorted = 'ASC' then
   begin
    dbGridSorted := 'DESC';
    Form1.SQLQuerySearch.IndexFieldNames := Column.FieldName + ' DESC';
    Column.Title.ImageIndex:=1; // Down
    // Remove the sort arrow from the previous column we sorted
    if (FLastColumn <> nil) and (FlastColumn <> Column) then
      FLastColumn.Title.ImageIndex:=-1;
    FLastColumn:=column;
    exit;
   end;
  if dbGridSorted = 'DESC' then
   begin
    dbGridSorted := 'ASC';
    Form1.SQLQuerySearch.IndexFieldNames := Column.FieldName;
    Column.Title.ImageIndex:=0; // Up
    // Remove the sort arrow from the previous column we sorted
    if (FLastColumn <> nil) and (FlastColumn <> Column) then
      FLastColumn.Title.ImageIndex:=-1;
    FLastColumn:=column;
    Exit;
   end;
end;

procedure TForm1.EdSQLSearchChange(Sender: TObject);
var
  StrSQL : String;
begin
  If EdSQLSearch.Text = '' then
   begin
    BtSQLSearch.ImageIndex:=2;
    BtSQLSearch.Caption:='Search';
    BtSQLSearch.Enabled:=false;
    BtSQLSearch.Default:=false;
    DBGridDir.Visible:=true;
    DBGridDirTxt.Visible:=false;
    DBGridSplitter.Visible:=false;
    AConnection.ExecuteDirect('DROP Table IF EXISTS Search');
    SQLQueryDirTxt.Close;
    SQLQueryDirTxt.Active := false;
    DBGridDirTxt.Clear;
    SQLQueryDir.Close;
    SQLQueryDir.SQL.Clear;
    if cbDBFilePath.Text = 'All' then
     begin
      StrSQL := 'Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, FilePath, Favourite, Corrupt, Tags, Info from FileImage';
      If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' WHERE Favourite = true'
       else
      If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' WHERE Corrupt = true'
       else
      If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' WHERE Favourite = true AND Corrupt = true';
      SQLQueryDir.SQL.Add(StrSQL);
     end;
    if cbDBFilePath.Text <> 'All' then
     begin
      StrSQL := 'Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, FilePath, Favourite, Corrupt, Tags, Info from FileImage WHERE FilePath = "' + cbDBFilePath.Text + '"';
      If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
       else
      If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
       else
      If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
      SQLQueryDir.SQL.Add(StrSQL);
     end;
    SQLQueryDir.Active := True;
    SQLQueryDir.First;
    LoadDir;
    exit;
   end;

  If EdSQLSearch.Text <> '' then
   begin
    if BtSQLSearch.Caption <>'Reset' then
     begin
      BtSQLSearch.ImageIndex:=2;
      BtSQLSearch.Caption:='Search';
      BtSQLSearch.Enabled:=true;
      BtSQLSearch.Default:=true;
     end;
    if BtSQLSearch.Caption = 'Reset' then
     begin
      AConnection.ExecuteDirect('DROP Table IF EXISTS Search');
      DBGridDir.Visible:=true;
      BtSQLSearch.ImageIndex:=2;
      BtSQLSearch.Caption:='Search';
      BtSQLSearch.Enabled:=true;
      BtSQLSearch.Default:=true;
     end;
    Statusbar1.Panels[0].Text := ' ' + IntToStr(SQLQueryDir.RecNo) + '/' + IntToStr(SQLQueryDir.RecordCount);
    Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
   end;
end;

procedure TForm1.edTagsEditingDone(Sender: TObject);
begin
  if ATransaction.Active then
   begin
     SQlQueryDir.Edit;
     SQlQueryDir.FieldByName('Tags').AsString := edtags.Text;
     SQlQueryDir.Post;
     SQlQueryDir.ApplyUpdates;
   end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 SaveRecentFiles;
 RecentFiles.Free;
 try
  CleanTmp;
 except
 On E : Exception do
  ShowMessage(E.Message + ' - Unable to clear temporary folder! Please check files for "readonly" attribute.');
 end;
 IniFluff.WriteString('Database', 'FilePathLast', IncludeTrailingPathDelimiter(cbDBFilePath.Text));
 IniFluff.WriteBool('Options', 'Scratched', TgScratch.Checked);
 IniFluff.WriteBool('Options', 'Shifted', TgCShift.Checked);
 IniFluff.WriteInteger('Application', 'ClientWidth', ClientWidth);
 IniFluff.WriteInteger('Application', 'ClientHeight', ClientHeight);
 IniFluff.WriteInteger('Application', 'SplitterPos', pnDirView.Width);
 IniFluff.WriteInteger('Application', 'SplitterPosTN', pnTagsNotes.Height);
 IniFluff.WriteInteger('Emulators', 'Select', cbEmulator.ItemIndex);
 IniFluff.Free;

 if ATransaction.Active then
  begin
   SQlQueryDir.ApplyUpdates;
   ATransaction.Commit;
  end;
 AConnection.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 RecentFiles := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  If Dev_Mode = true then Showmessage('[Dev_Mode] - Start RemoveFontRessource procedure');
  If fileexists(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf') = true then
   begin
    RemoveFontResource(PChar(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf'));
   end;
end;

procedure TForm1.DBGridDirTxt_ReadEntry;
var
  imgName: String;
begin
  if SQLQueryDir.RecordCount < 1 then
   begin
    EdSQLSearch.Enabled:=false;
    cbSQLSearch.Enabled:=false;
    TgScratch.Enabled:=false;
    TgCShift.Enabled:=false;
    LstBxDirectoryTXT.Clear;
    LstBxDirectoryTXT.Items.Add('File not found!');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := 'No entries found';
    Statusbar1.Panels[2].Text := '';
    Statusbar1.Panels[3].Text := '';
    Statusbar1.Panels[4].Text := '';
    exit;
   end;

  LstBxDirectoryTXT.Clear;
  SQLQueryDirTXT.DataBase := AConnection;
  SQLQueryDirTxt.Close;
  SQLQueryDirTxt.SQL.Clear;
  SQLQueryDirTxt.SQL.Add('SELECT * FROM DirectoryTXT WHERE idxTXT = ' + SQLQueryDir.FieldByName('idxImg').Text + '');
  SQLQueryDirTxt.Active := True;
  SQLQueryDirTxt.Locate('idxTXT', SQLQueryDir.FieldByName('idxImg').Text, []);
  SQLQueryDirTxt.First;
  While not SQLQueryDirTxt.EOF do
   begin
    imgName := SQLQueryDirTXT.FieldByName('FileNameTXT').Text;
    LstBxDirectoryTXT.Items.Add(imgName);
    SQLQueryDirTxt.Next;
   end;
end;

procedure TForm1.DBGridDir_ReadEntry(aImageName : String);
begin

  If Dev_Mode = true then Showmessage('[Dev_Mode] - Start DBGridDir_ReadEntry procedure');
  If PageControl1.Pages[0].Visible = true then
   begin
    if SQLQueryDir.RecordCount < 1 then
     begin
      EdSQLSearch.Enabled:=false;
      cbSQLSearch.Enabled:=false;
      TgScratch.Enabled:=false;
      TgCShift.Enabled:=false;
      LstBxDirectoryPETSCII.Clear;
      LstBxDirectoryPETSCII.Items.Add('File or archive not found!');
      memInfo.Enabled:=false;
      Statusbar1.Panels[0].Text := ' 0/0';
      Statusbar1.Panels[1].Text := 'No entries found';
      Statusbar1.Panels[2].Text := '';
      Statusbar1.Panels[3].Text := '';
      Statusbar1.Panels[4].Text := '';
      exit;
     end;
    if SQLQueryDir.RecordCount > 0 then
     begin
      If FileExists(aImageName) then
       begin
        GetDirectoryImage(aImageName, TgScratch.Checked, TgCShift.Checked);
        Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
       end
      else
      begin
       LstBxDirectoryPETSCII.Clear;
       LstBxDirectoryPETSCII.Items.Add('File or archive not found!');
      end;
     EdSQLSearch.Enabled:=true;
     cbSQLSearch.Enabled:=true;
     TgScratch.Enabled:=true;
     TgCShift.Enabled:=true;
     Statusbar1.Panels[0].Text := ' ' + IntToStr(SQLQueryDir.RecNo) + '/' + IntToStr(SQLQueryDir.RecordCount);
   end;
  end;
   If Dev_Mode = true then Showmessage('[Dev_Mode] - End DBGridDir_ReadEntry procedure');
end;

procedure TForm1.LoadBAM_D64(aFileName : String; aFileSizeImg : String);
var
   trk, a, b, c : Integer;
   err : integer;
   i,k : Int64;
   s : AnsiString;
   bits, TrkRow : String;
begin
  LstBAM.Clear;
  if SQLQueryDir.RecordCount < 1 then
   begin
    EdSQLSearch.Enabled:=false;
    cbSQLSearch.Enabled:=false;
    TgScratch.Enabled:=false;
    TgCShift.Enabled:=false;
    LstBxDirectoryPETSCII.Clear;
    //LstBxDirectoryPETSCII.Items.Add('File not found!');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := 'No entries found';
    Statusbar1.Panels[2].Text := '';
    Statusbar1.Panels[3].Text := '';
    Statusbar1.Panels[4].Text := '';
    exit;
   end;

  i := 0;
  k := 0;
  s := '';

  if FileExists(aFileName) = false then   // realtime check
   begin
    LstBAM.Lines.Add('File not found!');
    LstBAM.SelStart:=0;
    exit;
   end;

  LstBAM.Visible:=false;
  LstBAM.Lines.Add('    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20');
  LstBAM.Lines.Add('');
  b := 11; // Startpunkt

 for trk := 1 to 17 do
  begin
   // track 1-17 - 21 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD64[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 21 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';
    end;
   if trk < 10 then LstBAM.Lines.Add(IntToStr(trk)+ '   ' + TrkRow);
   if trk > 9  then LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;

 for trk := 18 to 24 do
  begin
   // track 18-24 19 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD64[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 19 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;

 for trk := 25 to 30 do
  begin
   // track 25-30 18 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD64[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 18 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;

  case aFileSizeImg of
   '174848':
     a := 35;
   '175531':
     a := 35;
   '196608':
     a := 40;
   '197376':
     a := 40;
   '205312':
     a := 42;
   '206114':
     a := 42;
  else
    a := 35;
  end;

   for trk := 31 to a do
    begin
     // track 31-35/40 17 Sektoren
     if trk > 35 then b := b + 88; // BAM 36+ beginnt bei byte "AD"

     bits := '';
     val ('%1',i,err);
     for c := 1 to 3 do
      begin
       val ('$' + Copy(ArrD64[18,0], b, 2),k,err);
       s :=  BinStr(i*k,8);
       s := ReverseString(s);
       bits := bits + s;
       b := b + 2;
      end;
     TrkRow := '';
     for c := 1 to 17 do
      begin
       if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
       if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
      end;
     LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
     b := b + 2;
    end;
 LstBAM.SelStart:=0;
 LstBAM.Visible:=true;

end;

procedure TForm1.LoadBAM_D71(aFileName : String);
var
   trk, b, c : Integer;
   err : integer;
   i,k : Int64;
   s : AnsiString;
   bits, TrkRow : String;
begin
  LstBAM.Clear;
  if SQLQueryDir.RecordCount < 1 then
   begin
    EdSQLSearch.Enabled:=false;
    cbSQLSearch.Enabled:=false;
    TgScratch.Enabled:=false;
    TgCShift.Enabled:=false;
    LstBxDirectoryPETSCII.Clear;
    //LstBxDirectoryPETSCII.Items.Add('File not found!');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := 'No entries found';
    Statusbar1.Panels[2].Text := '';
    Statusbar1.Panels[3].Text := '';
    Statusbar1.Panels[4].Text := '';
    exit;
   end;

   i := 0;
   k := 0;
   s := '';

   if FileExists(aFileName) = false then   // realtime check
   begin
    LstBAM.Lines.Add('File not found!');
    LstBAM.SelStart:=0;
    exit;
   end;
   LstBAM.Visible:=false;

 LstBAM.Lines.Add('    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20');
 LstBAM.Lines.Add('');
 b := 11; // Startpunkt

 for trk := 1 to 17 do
  begin
   // track 1-17 - 21 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 21 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';
    end;
   if trk < 10 then LstBAM.Lines.Add(IntToStr(trk)+ '   ' + TrkRow);
   if trk > 9  then LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;

 for trk := 18 to 24 do
  begin
   // track 18-24 19 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 19 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;

 for trk := 25 to 30 do
  begin
   // track 25-30 18 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 18 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;

 for trk := 31 to 35 do
  begin
   // track 31-35 17 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[18,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 17 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;
 b := 1;
 for trk := 36 to 52 do
  begin
   // track 36-52 21 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[53,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 21 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
  end;
 for trk := 53 to 59 do
  begin
   // track 53-59 19 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[53,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 19 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
  end;
 for trk := 60 to 65 do
  begin
   // track 60-65 18 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[53,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 18 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
  end;
 for trk := 66 to 70 do
  begin
   // track 66-70 17 Sektoren
   bits := '';
   val ('%1',i,err);
   for c := 1 to 3 do
    begin
     val ('$' + Copy(ArrD71[53,0], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 17 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';;
    end;
   LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
  end;
  LstBAM.SelStart:=0;
  LstBAM.Visible:=true;
end;

procedure TForm1.LoadBAM_D81(aFileName : String);
var
   trk, b, c : Integer;
   err : integer;
   i,k : Int64;
   s : AnsiString;
   bits, TrkRow : String;
begin
  LstBAM.Clear;
  if SQLQueryDir.RecordCount < 1 then
   begin
    EdSQLSearch.Enabled:=false;
    cbSQLSearch.Enabled:=false;
    TgScratch.Enabled:=false;
    TgCShift.Enabled:=false;
    LstBxDirectoryPETSCII.Clear;
    //LstBxDirectoryPETSCII.Items.Add('File not found!');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := 'No entries found';
    Statusbar1.Panels[2].Text := '';
    Statusbar1.Panels[3].Text := '';
    Statusbar1.Panels[4].Text := '';
    exit;
   end;

  i := 0;
  k := 0;
  s := '';

  if FileExists(aFileName) = false then   // realtime check
   begin
    LstBAM.Lines.Add('File not found!');
    LstBAM.SelStart:=0;
    exit;
   end;

  LstBAM.Visible:=false;
  LstBAM.Lines.Add('    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39');
  LstBAM.Lines.Add('');
  b := 35; // Startpunkt
  for trk := 1 to 40 do
  begin
   bits := '';
   val ('%1',i,err);
   for c := 1 to 5 do
    begin
     val ('$' + Copy(ArrD81[40,1], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 40 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';
    end;
   if trk < 10 then LstBAM.Lines.Add(IntToStr(trk)+ '   ' + TrkRow);
   if trk > 9  then LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;
  b := 35;
  for trk := 41 to 80 do
  begin
   bits := '';
   val ('%1',i,err);
   for c := 1 to 5 do
    begin
     val ('$' + Copy(ArrD81[40,2], b, 2),k,err);
     s :=  BinStr(i*k,8);
     s := ReverseString(s);
     bits := bits + s;
     b := b + 2;
    end;
   TrkRow := '';
   for c := 1 to 40 do
    begin
     if Copy(bits, c, 1) = '1' then TrkRow := TrkRow + ' - ';
     if Copy(bits, c, 1) = '0' then TrkRow := TrkRow + ' # ';
    end;
   if trk < 10 then LstBAM.Lines.Add(IntToStr(trk)+ '   ' + TrkRow);
   if trk > 9  then LstBAM.Lines.Add(IntToStr(trk)+ '  ' + TrkRow);
   b := b + 2;
  end;
  LstBAM.SelStart:=0;
  LstBAM.Visible:=true;
end;

procedure TForm1. Init_TrkSec_HexDropdown(aImageName : String);
var
  a : Integer;
begin
  a := 1;

 // D64 / G64 / NIB
 if (Lowercase(ExtractFileExt(aImageName)) = '.d64') or (Lowercase(ExtractFileExt(aImageName)) = '.g64') or (Lowercase(ExtractFileExt(aImageName)) = '.nib') then
  begin
    cbTrack.Clear;
    for a := 1 to 40 do
     begin
      cbTrack.Items.Add(IntToStr(a));
     end;
    cbTrack.ItemIndex:=17; // Track 18
    exit;
  end; // D64 END

 // D71
 if (Lowercase(ExtractFileExt(aImageName)) = '.d71') then
  begin
    cbTrack.Clear;
    for a := 1 to 70 do
     begin
      cbTrack.Items.Add(IntToStr(a));
     end;
    cbTrack.ItemIndex:=17; // Track 18
    exit;
  end; // D71 END

 // D81
  if (Lowercase(ExtractFileExt(aImageName)) = '.d81') then
   begin
    cbTrack.Clear;
    for a := 1 to 80 do
     begin
      cbTrack.Items.Add(IntToStr(a));
     end;
    cbTrack.ItemIndex:=39; // Track 40
   end; // D81 END
end;
procedure TForm1.LoadTS(aFileName : String);
var
  a, b, c: Integer;
  sec : String;
begin
 lstBoxSectors.Clear;
 lstBoxPETSCII.Clear;
 lstBoxSectors.Lines.Add('     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F');
 lstBoxSectors.Lines.Add('     -----------------------------------------------');
 lstBoxPETSCII.Lines.Add('');
 lstBoxPETSCII.Lines.Add('----------------');

 if lowercase(ExtractFileExt(aFileName)) = '.prg' then exit;

 b := 1;
 for a := 1 to 16 do // 16 Zeilen
  begin
   sec := '';
   edit1.Text := '';
   for c := 1 to 16 do // 16 Zeichen pro Zeile
    begin
     if (lowercase(ExtractFileExt(aFileName)) = '.d64') or (lowercase(ExtractFileExt(aFileName)) = '.g64') or (Lowercase(ExtractFileExt(aFileName)) = '.nib') then
      begin
       sec := sec + Copy(arrD64[StrToInt(cbTrack.Text),StrToInt(cbSector.Text)], b, 2) + ' ';
       edit1.Text := edit1.Text + GetUTF8('$' + Copy(arrD64[StrToInt(cbTrack.Text),StrToInt(cbSector.Text)], b, 2), false, false);
       b := b + 2;
      end;
     if lowercase(ExtractFileExt(aFileName)) = '.d71' then
      begin
       sec := sec + Copy(arrD71[StrToInt(cbTrack.Text),StrToInt(cbSector.Text)], b, 2) + ' ';
       edit1.Text := edit1.Text + GetUTF8('$' + Copy(arrD71[StrToInt(cbTrack.Text),StrToInt(cbSector.Text)], b, 2), false, false);
       b := b + 2;
      end;
     if lowercase(ExtractFileExt(aFileName)) = '.d81' then
      begin
       sec := sec + Copy(arrD81[StrToInt(cbTrack.Text),StrToInt(cbSector.Text)], b, 2) + ' ';
       edit1.Text := edit1.Text + GetUTF8('$' + Copy(arrD81[StrToInt(cbTrack.Text),StrToInt(cbSector.Text)], b, 2), false, false);
       b := b + 2;
      end;
    end;
    if a = 01 then lstBoxSectors.Lines.Add('00 | ' + sec);
    if a = 02 then lstBoxSectors.Lines.Add('10 | ' + sec);
    if a = 03 then lstBoxSectors.Lines.Add('20 | ' + sec);
    if a = 04 then lstBoxSectors.Lines.Add('30 | ' + sec);
    if a = 05 then lstBoxSectors.Lines.Add('40 | ' + sec);
    if a = 06 then lstBoxSectors.Lines.Add('50 | ' + sec);
    if a = 07 then lstBoxSectors.Lines.Add('60 | ' + sec);
    if a = 08 then lstBoxSectors.Lines.Add('70 | ' + sec);
    if a = 09 then lstBoxSectors.Lines.Add('80 | ' + sec);
    if a = 10 then lstBoxSectors.Lines.Add('90 | ' + sec);
    if a = 11 then lstBoxSectors.Lines.Add('A0 | ' + sec);
    if a = 12 then lstBoxSectors.Lines.Add('B0 | ' + sec);
    if a = 13 then lstBoxSectors.Lines.Add('C0 | ' + sec);
    if a = 14 then lstBoxSectors.Lines.Add('D0 | ' + sec);
    if a = 15 then lstBoxSectors.Lines.Add('E0 | ' + sec);
    if a = 16 then lstBoxSectors.Lines.Add('F0 | ' + sec);

    // ASCII
    lstBoxPETSCII.Lines.Add(edit1.Text);
  end;
end;

procedure TForm1.LoadDir;
var
 FileNameExt, FileSizeImg : String;
begin
 if SQLQueryDir.RecordCount < 1 then
  begin
   EdSQLSearch.Enabled:=false;
   cbSQLSearch.Enabled:=false;
   TgScratch.Enabled:=false;
   TgCShift.Enabled:=false;
   LstBxDirectoryPETSCII.Clear;
   memInfo.Enabled:=false;
   Statusbar1.Panels[0].Text := ' 0/0';
   Statusbar1.Panels[1].Text := 'No entries found';
   Statusbar1.Panels[2].Text := '';
   Statusbar1.Panels[3].Text := '';
   Statusbar1.Panels[4].Text := '';
   exit;
  end;
 if SQLQueryDir.RecordCount > 0 then
  begin
   Statusbar1.Panels[0].Text := ' ' + IntToStr(Form1.SQLQueryDir.RecNo) + '/' + IntToStr(Form1.SQLQueryDir.RecordCount);
   Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;

   try
    UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text); // FileFull
   finally
   end;

   FileSizeImg := SQLQueryDir.FieldByName('FileSizeImg').Text;
   FileNameExt := lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString);

   // Read directory
   DBGridDir_ReadEntry(FileFull);

   if PageControl2.Pages[1].Visible = true then
    begin
     // TAP
     If (lowercase(FileNameExt) = 'tap') then LstBAM.Clear;
     // PRG
     If (lowercase(FileNameExt) = 'prg') then LstBAM.Clear;
     // D64/G64/NIB
     If (lowercase(FileNameExt) = 'd64') or (lowercase(FileNameExt) = 'g64') or (lowercase(FileNameExt) = 'nib') then LoadBAM_D64(FileFull, FileSizeImg);
     // D71
     If lowercase(FileNameExt) = 'd71' then LoadBAM_D71(FileFull);
     // D81
     If lowercase(FileNameExt) = 'd81' then LoadBAM_D81(FileFull);
    end;

   if PageControl2.Pages[2].Visible = true then
    begin
     Init_TrkSec_HexDropdown(FileFull);
     Init_SectorsHexDropDown;
     LoadTS(FileFull);
    end;
  end;
end;

procedure TForm1.Init_SectorsHexDropDown;
var
  a, trk : Integer;
begin
 // D64/G64/NIB
 if (lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString) = 'd64') or (lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString) = 'g64') or (lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString) = 'nib') then
  begin
   cbSector.Clear;
   trk := StrToInt(cbTrack.Text);
   if (trk >= 01) and (trk <= 17) then // 21 sectors
    begin
     for a := 0 to 20 do
     begin
      cbSector.Items.Add(IntToStr(a));
     end;
    end;
   if (trk >= 18) and (trk <= 24)  then // 19 sectors
    begin
     for a := 0 to 18 do
     begin
      cbSector.Items.Add(IntToStr(a));
     end;
    end;
   if (trk >= 25) and (trk <= 30) then // 18 sectors
    begin
     for a := 0 to 17 do
      begin
      cbSector.Items.Add(IntToStr(a));
     end;
    end;
   if (trk >= 31) and (trk <= 40) then // 17 sectors
    begin
     for a := 0 to 16 do
     begin
      cbSector.Items.Add(IntToStr(a));
     end;
    end;
   cbSector.ItemIndex:=0;
   exit;
  end;

  // D71
  if lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString) = 'd71' then
   begin
    cbSector.Clear;
    trk := StrToInt(cbTrack.Text);
    if (trk >= 01) and (trk <= 17) then // 21 sectors
     begin
      for a := 0 to 20 do
      begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 18) and (trk <= 24)  then // 19 sectors
     begin
      for a := 0 to 18 do
      begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 25) and (trk <= 30) then // 18 sectors
     begin
      for a := 0 to 17 do
       begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 31) and (trk <= 35) then // 17 sectors
     begin
      for a := 0 to 16 do
      begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 36) and (trk <= 52) then // 21 sectors
     begin
      for a := 0 to 20 do
      begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 53) and (trk <= 59)  then // 19 sectors
     begin
      for a := 0 to 18 do
      begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 60) and (trk <= 65) then // 18 sectors
     begin
      for a := 0 to 17 do
       begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    if (trk >= 66) and (trk <= 70) then // 17 sectors
     begin
      for a := 0 to 16 do
      begin
       cbSector.Items.Add(IntToStr(a));
      end;
     end;
    cbSector.ItemIndex:=0;
    exit;
   end;

  // D81
  if lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString) = 'd81' then
   begin
    cbSector.Clear;
    for a := 0 to 39 do
     begin
      cbSector.Items.Add(IntToStr(a));
     end;
    cbSector.ItemIndex:=0;
    exit;
   end;
end;

end.


