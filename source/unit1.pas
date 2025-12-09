{
-----------------------------------------------------------------
FluffyFloppy64
v0.xx
-----------------------------------------------------------------
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
  Classes, SysUtils, StrUtils, Process, SQLite3Conn, SQLDB, DB, Forms, Controls, Printers,
  Graphics, Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, Buttons, DBGrids, Zipper,
  ShellCtrls, LazUtils, FileUtil, Inifiles, LCLIntf, DBCtrls, LazUTF8, LazFileUtils, Windows, Grids;

type
  TByteArr = array of Byte;

  { TfrmMain }

  TfrmMain = class(TForm)
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
    grbFilterSearch: TGroupBox;
    ImageList1: TImageList;
    lblBAMInfo: TLabel;
    lblBAM: TLabel;
    lblFilterImg: TLabel;
    lblText: TLabel;
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
    mnuRecPrint: TMenuItem;
    Separator14: TMenuItem;
    mnuRecRefresh: TMenuItem;
    Separator13: TMenuItem;
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
    mnuRefresh: TMenuItem;
    Separator10: TMenuItem;
    Separator12: TMenuItem;
    Separator9: TMenuItem;
    mnuOpenFileBrowser: TMenuItem;
    mnuManual: TMenuItem;
    Separator8: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    mnuRecDelete: TMenuItem;
    Separator7: TMenuItem;
    mnuRecCorrupt: TMenuItem;
    mnuRecFavourite: TMenuItem;
    Separator6: TMenuItem;
    mnuRecOpenLocation: TMenuItem;
    mnuRecOpen: TMenuItem;
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
    PC1: TPageControl;
    PC2: TPageControl;
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
    tbDB: TTabSheet;
    TabSheet2: TTabSheet;
    tbDir: TTabSheet;
    tbText: TTabSheet;
    tbBAM: TTabSheet;
    tbSectors: TTabSheet;
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
    procedure mnuRecCorruptClick(Sender: TObject);
    procedure mnuRecFavouriteClick(Sender: TObject);
    procedure mnuRecPrintClick(Sender: TObject);
    procedure mnuRecRefreshClick(Sender: TObject);
    procedure mnuViewDateImportedClick(Sender: TObject);
    procedure mnuViewDateLastClick(Sender: TObject);
    procedure mnuDelTempClick(Sender: TObject);
    procedure mnuPropertiesClick(Sender: TObject);
    procedure mnuRecDeleteClick(Sender: TObject);
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
    procedure mnuRecOpenLocationClick(Sender: TObject);
    procedure mnuRecOpenClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuImportClick(Sender: TObject);
    procedure GetLng(aLngFile : String);
    procedure DBFilter;
    procedure DBGridDir_ReadEntry(aImageName : String);
    procedure DBGridDirTxt_ReadEntry;
    procedure DBSearch;
    procedure Init_FilePath;
    procedure mnuSyncClick(Sender: TObject);
    procedure mnuViewLocationClick(Sender: TObject);
    procedure PC1Change(Sender: TObject);
    procedure PC2Change(Sender: TObject);
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
    procedure PrintListBox(ListBox: TListBox);
    procedure AddToRecentFiles(const aFileName: string);
    procedure UpdateRecentFilesMenu;
    procedure RecentFileClick(Sender: TObject);
    procedure SaveRecentFiles;
    procedure LoadRecentFiles;
  public

  end;

procedure GetDirectoryImage(aFileFull, aTmpPath : String; aScratch : Boolean; aLower: Boolean);
procedure OpenEmu(aEmu: string; aParam: string);

var
  frmMain: TfrmMain;
  Dev_mode : boolean;
  DB_RecCount : Integer;
  sAppPath, sAppVersion, sAppCaption, sAppDate,  sAppTmpPath : String;
  FileFull : String; // Global, check if field contains pipe "|"
  IniFluff, IniLng : TInifile;
  arrStr: array of array of String;
  arrD64 : array [01..40, 0..20] of String;
  arrD71 : array [01..70, 0..20] of String;
  arrD81 : array [01..80, 0..39] of String;
  Str_Dir, Str_DirAll : TStringList;
  dbGridSorted : String; // ASC or DESC
  SQlSearch_Click : boolean;
  FLastColumn: TColumn; //store mnuViewDateLast grid column we sorted on

implementation
{$R *.lfm}
uses unit2, unit3, unit4, unit5, unit6, unit8, FFFunctions, GetPETSCII;

const
  FR_PRIVATE  = $00000010;

  function AddFontResourceExW(name: LPCWSTR; fl: DWORD; res: PVOID): LongInt; stdcall external 'gdi32.dll';
  function RemoveFontResourceExW(name: LPCWSTR; fl: DWORD; pdv: PVOID): BOOL; stdcall external 'gdi32.dll';

const
  MaxRecentFiles = 5;

{ TfrmMain }

procedure ReverseBytes(Source, Dest: Pointer; Size: Integer);
var
  Index: Integer;
begin
  for Index := 0 to Size - 1 do
    Move(Pointer(LongInt(Source) + Index)^,
        Pointer(LongInt(Dest) + (Size - Index - 1))^ , 1);
end;

Procedure TfrmMain.PrintListBox(ListBox: TListBox);
Var
  I,LinesPerPage,Count,FontHeight:Cardinal;
Begin
  With Printer do Begin
    Canvas.Font.Assign(ListBox.Font);
    FontHeight:=Canvas.TextHeight('X');
    LinesPerPage:=PageHeight div FontHeight;
    BeginDoc;
      Count:=0;
      For I:=0 to ListBox.Items.Count-1 do Begin
        Canvas.TextOut(0,Count*FontHeight,ListBox.Items[I]);
        Inc(Count);
        If Count=LinesPerPage then Begin
          Count:=0;
          NewPage;
        End;
      End;
    EndDoc;
  End;
End;

Procedure TfrmMain.GetLng(aLngFile : String);
begin
  aLngFile := aLngFile + '.ini';
  // Init
  If DirectoryExists(IncludeTrailingPathDelimiter(sAppPath + 'lng')) = false then CreateDir(IncludeTrailingPathDelimiter(sAppPath + 'lng'));
  if FileExists(IncludeTrailingPathDelimiter(sAppPath + 'lng') + 'English.ini') = False then
   try
    IniLng := TINIFile.Create(IncludeTrailingPathDelimiter(sAppPath + 'lng') + 'English.ini');
    IniLng.WriteString('FluffyFloppy64', 'LNG', 'English');
    IniLng.WriteString('FluffyFloppy64', 'Version', '0.89');
    IniLng.WriteString('MNU', 'mnuFile', '&File');
    IniLng.WriteString('MNU', 'mnuDatabase', '&Database...');
    IniLng.WriteString('MNU', 'mnuNew', '&New');
    IniLng.WriteString('MNU', 'mnuOpen', '&Open');
    IniLng.WriteString('MNU', 'mnuRecent', 'Open &recent...');
    IniLng.WriteString('MNU', 'mnuRecentDBNF', 'Database not found');
    IniLng.WriteString('MNU', 'mnuImport', '&Import');
    IniLng.WriteString('MNU', 'mnuProperties', '&Properties');
    IniLng.WriteString('MNU', 'mnuClose', '&Close');
    IniLng.WriteString('MNU', 'mnuRecord', '&Record');
    IniLng.WriteString('MNU', 'mnuRecOpen', '&Open');
    IniLng.WriteString('MNU', 'mnuRecOpenLocation', '&Open location');
    IniLng.WriteString('MNU', 'mnuRecRefresh', '&Refresh');
    IniLng.WriteString('MNU', 'mnuRecFavourite', 'Mark as favourite');
    IniLng.WriteString('MNU', 'mnuRecCorrupt', 'Mark as corrupt');
    IniLng.WriteString('MNU', 'mnuRecDelete', 'Delete');
    IniLng.WriteString('MNU', 'mnuView', '&View');
    IniLng.WriteString('MNU', 'mnuViewColumns', '&Colums');
    IniLng.WriteString('MNU', 'mnuViewDateLast', 'Recently opened');
    IniLng.WriteString('MNU', 'mnuViewDateImported', 'Imported');
    IniLng.WriteString('MNU', 'mnuViewLocation', 'Location');
    IniLng.WriteString('MNU', 'mnuExtras', '&Extras');
    IniLng.WriteString('MNU', 'mnuOptions', 'Options');
    IniLng.WriteString('MNU', 'mnuDelTemp', '&Clear temp folder');
    IniLng.WriteString('MNU', 'mnuHelp', '&Help');
    IniLng.WriteString('MNU', 'mnuManual', '&Manual');
    IniLng.WriteString('MNU', 'mnuAbout', '&About');
    IniLng.WriteString('MNU', 'mnuOpenImage', 'Open');
    IniLng.WriteString('MNU', 'mnuOpenFileBrowser', 'Open with File-Browser');
    IniLng.WriteString('MNU', 'mnuOpenExplorer', 'Go to location');
    IniLng.WriteString('MNU', 'mnuFavourite', 'Mark as favourite');
    IniLng.WriteString('MNU', 'mnuCorrupt', 'Mark as corrupt');
    IniLng.WriteString('MNU', 'mnuRefresh', 'Refresh');
    IniLng.WriteString('MNU', 'mnuDelete', 'Delete');
    IniLng.WriteString('About', 'Title', 'About');
    IniLng.WriteString('About', 'lblFree', 'You can use this software completly free!');
    IniLng.WriteString('About', 'lblLiability', 'There is no liability for misuse or damage...');
    IniLng.WriteString('About', 'lblLic', 'License:');
    IniLng.WriteString('About', 'lblUses', 'Uses:');
    IniLng.WriteString('About', 'lblDB', 'Database:');
    IniLng.WriteString('About', 'lblFont', 'Font:');
    IniLng.WriteString('Manual', 'Title', 'Manual');
    IniLng.WriteString('DB', 'Database_OpenDialogFilter', 'FluffyFloppy64 Database|*.sl3');
    IniLng.WriteString('DB', 'lblVersion', 'Version:');
    IniLng.WriteString('DB', 'lblCreated', 'Created:');
    IniLng.WriteString('DB', 'lblLocation', 'Location:');
    IniLng.WriteString('DB', 'lblComment', 'Comment:');
    IniLng.WriteString('DB', 'title0', 'Filename');
    IniLng.WriteString('DB', 'title1', 'Ext');
    IniLng.WriteString('DB', 'title2', 'Filesize');
    IniLng.WriteString('DB', 'title3', 'Diskname');
    IniLng.WriteString('DB', 'title4', 'Recently opened');
    IniLng.WriteString('DB', 'title5', 'Imported');
    IniLng.WriteString('DB', 'title6', 'Favourite');
    IniLng.WriteString('DB', 'title7', 'Corrupt');
    IniLng.WriteString('DB', 'title8', 'Location');
    IniLng.WriteString('Del', 'Title', 'Delete');
    IniLng.WriteString('Del', 'lblDel', 'Are you sure you want to delete the selected database entry?');
    IniLng.WriteString('Del', 'cbDelFile', 'Delete file on data storage too');
    IniLng.WriteString('Del', 'btYes', 'Yes');
    IniLng.WriteString('Del', 'btNo', 'No');
    IniLng.WriteString('PC1', 'tbDBTitle', 'Database');
    IniLng.WriteString('PC1', 'grbFilterSearch', 'Filter/Search (Use *):');
    IniLng.WriteString('PC1', 'lblFilterPath', 'Path:');
    IniLng.WriteString('PC1', 'cbDBFilePathHint', 'Filter: Path to the images');
    IniLng.WriteString('PC1', 'lblFilterExt', 'Extension:');
    IniLng.WriteString('PC1', 'cbDBFileNameExtHint', 'Filter: File extensions');
    IniLng.WriteString('PC1', 'cbFilterCase', 'Case-sensitive');
    IniLng.WriteString('PC1', 'cbFilterCaseHint', 'Filter: Case-sensitive extension');
    IniLng.WriteString('PC1', 'lblFilterImg', 'Image:');
    IniLng.WriteString('PC1', 'cbFilterFav', 'Favourite');
    IniLng.WriteString('PC1', 'cbFilterFavHint', 'Filter: Show favorites');
    IniLng.WriteString('PC1', 'cbFilterCorrupt', 'Corrupt');
    IniLng.WriteString('PC1', 'cbFilterCorruptHint', 'Filter: Show corrupt');
    IniLng.WriteString('PC1', 'lblSearch', 'Search:');
    IniLng.WriteString('PC1', 'EdSQLSearchHint', 'Search database...');
    IniLng.WriteString('PC1', 'EdSQLSearchTextHint', 'Search database...');
    IniLng.WriteString('PC1', 'cbSQLSearch', 'Directory entry');
    IniLng.WriteString('PC1', 'cbSQLSearchHint', 'Select field');
    IniLng.WriteString('PC1', 'BtSQLSearch', 'Search');
    IniLng.WriteString('PC1', 'BtSQLSearchHint', 'Search');
    IniLng.WriteString('PC1', 'lblTags', 'Tags:');
    IniLng.WriteString('PC1', 'edTags', 'Tags divided with comma');
    IniLng.WriteString('PC1', 'lblNotes', 'Notes:');
    IniLng.WriteString('PC2', 'tbDirTitle', 'Directory');
    IniLng.WriteString('PC2', 'TgScratch', 'Scratched');
    IniLng.WriteString('PC2', 'TgScratchHint', 'Show scratched entries');
    IniLng.WriteString('PC2', 'TgCShift', 'C=-Shift');
    IniLng.WriteString('PC2', 'TgCShiftHint', 'Show shifted');
    IniLng.WriteString('PC2', 'lblOpenWith', 'Select emulator:');
    IniLng.WriteString('PC2', 'lblBAMInfo', 'BAM Info:');
    IniLng.WriteString('PC2', 'tbBAMTitle', 'BAM');
    IniLng.WriteString('PC2', 'lblBAM', 'BAM (Block Availability Map)');
    IniLng.WriteString('PC2', 'tbSectorsTitle', 'Sectors (Hex)');
    IniLng.WriteString('PC2', 'lblTrack', 'Track:');
    IniLng.WriteString('PC2', 'lblSec', 'Sector:');
    IniLng.WriteString('PC2', 'lblSource', 'Source:');
    IniLng.WriteString('PC2', 'tbTextTitle', 'Text');
    IniLng.WriteString('PC2', 'lblText', 'Directory (TXT entries in database):');
    IniLng.WriteString('Import', 'grImportFrom', 'Select:');
    IniLng.WriteString('Import', 'DirImportTextHint', 'Select directory...');
    IniLng.WriteString('Import', 'lblFileSel', 'File(s) found:');
    IniLng.WriteString('Import', 'lblImportFound', ' No folder selected!');
    IniLng.WriteString('Import', 'lblFileImg', 'Images:');
    IniLng.WriteString('Import', 'lblFileArc', 'Archives:');
    IniLng.WriteString('Import', 'grImportProgress', 'Progress:');
    IniLng.WriteString('Import', 'lblFileProgress', 'File(s) imported:');
    IniLng.WriteString('Import', 'lblArchiveProgress', 'Archive(s) imported:');
    IniLng.WriteString('Import', 'lblImportHintsErrors', 'Hints/Errors:');
    IniLng.WriteString('Import', 'btClose', 'Close');
    IniLng.WriteString('Import', 'btCancel', 'Cancel');
    IniLng.WriteString('Import', 'btImport', 'Import');
    IniLng.WriteString('Import', 'btSaveHints', 'Save hints');
    IniLng.WriteString('MSG', 'msgDB01', 'Create new database');
    IniLng.WriteString('MSG', 'msgDB02', 'Database already exists! Unable to create!');
    IniLng.WriteString('MSG', 'msgDB03', 'Unable to create new database');
    IniLng.WriteString('MSG', 'msgDB04', 'Database successfully created');
    IniLng.WriteString('MSG', 'msgDB05', 'Image not found');
    IniLng.WriteString('MSG', 'msgImp01', 'Importing...');
    IniLng.WriteString('MSG', 'msgImp02', 'No import (already exists):');
    IniLng.WriteString('MSG', 'msgImp03', 'No import (filesize = "0"):');
    IniLng.WriteString('MSG', 'msgImp04', 'Import "g64" failed (directory sector not found):');
    IniLng.WriteString('MSG', 'msgImp05', 'Import "nib" failed (directory sector not found):');
    IniLng.WriteString('MSG', 'msgImp06', 'Import failed:');
    IniLng.WriteString('MSG', 'msgImp01', 'Importing...');
    IniLng.WriteString('MSG', 'msgImp02', 'No import (already exists):');
    IniLng.WriteString('MSG', 'msgImp03', 'No import (filesize = "0"):');
    IniLng.WriteString('MSG', 'msgImp04', 'Import "G64" failed (directory sector not found):');
    IniLng.WriteString('MSG', 'msgImp05', 'Import "NIB" failed (directory sector not found):');
    IniLng.WriteString('MSG', 'msgImp06', 'Import failed:');
    IniLng.WriteString('MSG', 'msgImp07', 'Directory not found!');
    IniLng.WriteString('MSG', 'msgImp08', 'Temporary directory not found! Please check settings...');
    IniLng.WriteString('MSG', 'msgImp09', 'G64 cannot be imported because NibConv not found! Please check settings first or deselect G64...');
    IniLng.WriteString('MSG', 'msgImp10', 'NIB cannot be imported because NibConv not found! Please check settings first or deselect NIB...');
    IniLng.WriteString('MSG', 'msgImp11', 'Files found in archive');
    IniLng.WriteString('MSG', 'msgImp12', 'Unable to unpack');
    IniLng.WriteString('MSG', 'msgImp13', 'Clearing...');
    IniLng.WriteString('MSG', 'msgImp14', 'Collecting images and archives... Please wait!');
    IniLng.WriteString('MSG', 'msgImp15', 'Collect finished');
    IniLng.WriteString('MSG', 'msgImp16', 'No image(s) to import!');
    IniLng.WriteString('MSG', 'msgImp17', 'image(s) found.');
    IniLng.WriteString('MSG', 'msgImp18', 'archive(s) found.');
    IniLng.WriteString('MSG', 'msgImp19', 'Nothing to import!');
    IniLng.WriteString('MSG', 'msgImp20', 'No folder selected!');
    IniLng.WriteString('MSG', 'msgDir01', 'Directory not stored in database');
    IniLng.WriteString('MSG', 'msgDir02', 'unknown tracks, unknown error bytes');
    IniLng.WriteString('MSG', 'msgDir03', 'Tape file (TAP)');
    IniLng.WriteString('MSG', 'msgDir04', 'Program file (PRG)');
    IniLng.WriteString('MSG', 'msgDir05', 'Database');
    IniLng.WriteString('MSG', 'msgDir06', 'Image');
    IniLng.WriteString('MSG', 'msgDir07', '35 tracks, no error bytes');
    IniLng.WriteString('MSG', 'msgDir08', '35 tracks, 683 error bytes');
    IniLng.WriteString('MSG', 'msgDir09', '40 tracks, no error bytes');
    IniLng.WriteString('MSG', 'msgDir10', '40 tracks, 768 error bytes');
    IniLng.WriteString('MSG', 'msgDir11', '42 tracks, no error bytes');
    IniLng.WriteString('MSG', 'msgDir12', '42 tracks, 802 error bytes');
    IniLng.WriteString('MSG', 'msgDir13', '70 tracks, no error bytes');
    IniLng.WriteString('MSG', 'msgDir14', '70 tracks, 1366 error bytes');
    IniLng.WriteString('MSG', 'msgDir15', '80 tracks, no error bytes');
    IniLng.WriteString('MSG', 'msgDir16', '80 tracks, 3200 error bytes');
    IniLng.WriteString('MSG', 'msgDir17', 'No entries found');
    IniLng.WriteString('MSG', 'msgDir18', 'Not valid');
    IniLng.WriteString('MSG', 'msgDir19', 'DOS version type:');
    IniLng.WriteString('MSG', 'msgEmu01', 'CCS64 not found!');
    IniLng.WriteString('MSG', 'msgEmu02', 'CCS64 does not support nib images!');
    IniLng.WriteString('MSG', 'msgEmu03', 'CCS64 does not support d71 images!');
    IniLng.WriteString('MSG', 'msgEmu04', 'CCS64 does not support d81 images!');
    IniLng.WriteString('MSG', 'msgEmu05', 'Denise not found!');
    IniLng.WriteString('MSG', 'msgEmu06', 'Denise does not support nib images!');
    IniLng.WriteString('MSG', 'msgEmu07', 'Denise does not support d71 images!');
    IniLng.WriteString('MSG', 'msgEmu08', 'Denise does not support d81 images!');
    IniLng.WriteString('MSG', 'msgEmu09', 'Emu64 not found!');
    IniLng.WriteString('MSG', 'msgEmu10', 'Emu64 does not support nib images!');
    IniLng.WriteString('MSG', 'msgEmu11', 'Emu64 does not support d71 images!');
    IniLng.WriteString('MSG', 'msgEmu12', 'Emu64 does not support d81 images!');
    IniLng.WriteString('MSG', 'msgEmu13', 'Hoxs not found!');
    IniLng.WriteString('MSG', 'msgEmu14', 'Hoxs does not support nib images!');
    IniLng.WriteString('MSG', 'msgEmu15', 'Hoxs does not support d71 images!');
    IniLng.WriteString('MSG', 'msgEmu16', 'Hoxs does not support d81 images!');
    IniLng.WriteString('MSG', 'msgEmu17', 'VICE not found!');
    IniLng.WriteString('MSG', 'msgEmu18', 'VICE does not support nib images!');
    IniLng.WriteString('MSG', 'msgEmu19', 'VIVE does not support d71 images!');
    IniLng.WriteString('MSG', 'msgEmu20', 'VICE does not support d81 images!');
    IniLng.WriteString('MSG', 'msgDM01', 'DirMaster not found!');
    IniLng.WriteString('SET', 'msgSet01', 'Cancel');
    IniLng.WriteString('SET', 'msgSet02', 'OK');
    IniLng.WriteString('SET', 'msgSet03', 'Font not found:');
    IniLng.WriteString('SET', 'msgSet04', 'Font successfully copied!');
    IniLng.WriteString('SET', 'msgSet05', 'Please restart the application to make the changes take effect...');
    IniLng.WriteString('SET', 'msgSet10', 'Settings');
    IniLng.WriteString('SET', 'msgSet11', 'Start:');
    IniLng.WriteString('SET', 'msgSet12', 'Open recent used database (default)');
    IniLng.WriteString('SET', 'msgSet13', 'Locations:');
    IniLng.WriteString('SET', 'msgSet14', 'Temporary folder:');
    IniLng.WriteString('SET', 'msgSet15', 'NibConv:');
    IniLng.WriteString('SET', 'msgSet16', 'Database:');
    IniLng.WriteString('SET', 'msgSet17', 'Load PETSCII directory if tracks (18,19,40 or 53) were fully imported into database, instead from image file');
    IniLng.WriteString('SET', 'msgSet18', 'HINT: If checked but not stored in database you will not see it - Statusbar will show "Directory not stored in database"');
    IniLng.WriteString('SET', 'msgSet19', 'Not recommended! See Import settings first!');
    IniLng.WriteString('SET', 'msgSet20', 'Import');
    IniLng.WriteString('SET', 'msgSet21', 'Import D64, G64, NIB:');
    IniLng.WriteString('SET', 'msgSet22', 'Import also track 18/19 to database (fully usage of database without images)');
    IniLng.WriteString('SET', 'msgSet23', 'Not recommended! Could go slow, needs more storage');
    IniLng.WriteString('SET', 'msgSet24', 'Import D71:');
    IniLng.WriteString('SET', 'msgSet25', 'Import also track 18/53 to database (fully usage of database without images)');
    IniLng.WriteString('SET', 'msgSet26', 'Import D81:');
    IniLng.WriteString('SET', 'msgSet27', 'Import also track 40 to database (fully usage of database without images)');
    IniLng.WriteString('SET', 'msgSet30', 'Open with...');
    IniLng.WriteString('SET', 'msgSet31', 'Emulator:');
    IniLng.WriteString('SET', 'msgSet32', 'CCS64:');
    IniLng.WriteString('SET', 'msgSet33', 'Denise:');
    IniLng.WriteString('SET', 'msgSet34', 'Emu64:');
    IniLng.WriteString('SET', 'msgSet35', 'Hoxs64:');
    IniLng.WriteString('SET', 'msgSet36', 'Vice:');
    IniLng.WriteString('SET', 'msgSet38', 'Tools:');
    IniLng.WriteString('SET', 'msgSet39', 'DirMaster:');
    IniLng.WriteString('SET', 'msgSet40', 'PETSCII Font');
    IniLng.WriteString('SET', 'msgSet41', 'Options:');
    IniLng.WriteString('SET', 'msgSet42', 'Font size (directory):');
    IniLng.WriteString('SET', 'msgSet43', 'Font color:');
    IniLng.WriteString('SET', 'msgSet44', 'Background color:');
    IniLng.WriteString('SET', 'msgSet45', 'Default');
    IniLng.WriteString('SET', 'msgSet46', 'Location:');
    IniLng.WriteString('SET', 'msgSet47', 'Copy "~APPLICATIONPATH\C64_Pro_Mono-STYLE.ttf" to default operating system "~\fonts\" folder');
    IniLng.WriteString('SET', 'msgSet48', 'Needs a restart of the application to make the changes take effect...');
    IniLng.WriteString('SET', 'msgSet49', 'Copy2Fonts');
    IniLng.WriteString('SET', 'msgSet50', 'Language:');
   finally
   end;

  // Select lng
  IniLng := TINIFile.Create(IncludeTrailingPathDelimiter(sAppPath + 'lng') + aLngFile);

  // Get lng
  mnuFile.Caption := IniLng.ReadString('MNU', 'mnuFile', '&File');
  mnuDatabase.Caption := IniLng.ReadString('MNU', 'mnuDatabase', '&Database...');
  mnuNew.Caption := IniLng.ReadString('MNU', 'mnuNew', '&New');
  mnuOpen.Caption := IniLng.ReadString('MNU', 'mnuOpen', '&Open');
  mnuRecent.Caption := IniLng.ReadString('MNU', 'mnuRecent', 'Open &recent...');
  mnuImport.Caption := IniLng.ReadString('MNU', 'mnuImport', '&Import');
  mnuProperties.Caption := IniLng.ReadString('MNU', 'mnuProperties', '&Properties');
  mnuClose.Caption := IniLng.ReadString('MNU', 'mnuClose', '&Close');
  mnuRecord.Caption := IniLng.ReadString('MNU', 'mnuRecord', '&Record');
  mnuRecOpen.Caption := IniLng.ReadString('MNU', 'mnuRecOpen', '&Open');
  mnuRecOpenLocation.Caption := IniLng.ReadString('MNU', 'mnuRecOpenLocation', '&Open location');
  mnuRecRefresh.Caption := IniLng.ReadString('MNU', 'mnuRecRefresh', '&Refresh');
  mnuRecFavourite.Caption := IniLng.ReadString('MNU', 'mnuRecFavourite', 'Mark as favourite');
  mnuRecCorrupt.Caption := IniLng.ReadString('MNU', 'mnuRecCorrupt', 'Mark as corrupt');
  mnuRecDelete.Caption := IniLng.ReadString('MNU', 'mnuRecDelete', 'Delete');
  mnuView.Caption := IniLng.ReadString('MNU', 'mnuView', '&View');
  mnuViewColumns.Caption := IniLng.ReadString('MNU', 'mnuViewColumns', '&Colums');
  mnuViewDateLast.Caption := IniLng.ReadString('MNU', 'mnuViewDateLast', 'Recently opened');
  mnuViewDateImported.Caption := IniLng.ReadString('MNU', 'mnuViewDateImported', 'Imported');
  mnuViewLocation.Caption := IniLng.ReadString('MNU', 'mnuViewLocation', 'Location');
  mnuExtras.Caption := IniLng.ReadString('MNU', 'mnuExtras', '&Extras');
  mnuOptions.Caption := IniLng.ReadString('MNU', 'mnuOptions', 'Options');
  mnuDelTemp.Caption := IniLng.ReadString('MNU', 'mnuDelTemp', '&Clear temp folder');
  mnuHelp.Caption := IniLng.ReadString('MNU', 'mnuHelp', '&Help');
  mnuManual.Caption := IniLng.ReadString('MNU', 'mnuManual', '&Manual');
  mnuAbout.Caption := IniLng.ReadString('MNU', 'mnuAbout', '&About');
  mnuOpenImage.Caption := IniLng.ReadString('MNU', 'mnuOpenImage', 'Open');
  mnuOpenFileBrowser.Caption := IniLng.ReadString('MNU', 'mnuOpenFileBrowser', 'Open with File-Browser');
  mnuOpenExplorer.Caption := IniLng.ReadString('MNU', 'mnuOpenExplorer', 'Go to location');
  mnuFavourite.Caption := IniLng.ReadString('MNU', 'mnuFavourite', 'Mark as favourite');
  mnuCorrupt.Caption := IniLng.ReadString('MNU', 'mnuCorrupt', 'Mark as corrupt');
  mnuRefresh.Caption := IniLng.ReadString('MNU', 'mnuRefresh', 'Refresh');
  mnuDelete.Caption := IniLng.ReadString('MNU', 'mnuDelete', 'Delete');
  Database_OpenDialog.Filter := IniLng.ReadString('DB', 'Database_OpenDialogFilter', 'FluffyFloppy64 Database|*.sl3');
  DBGridDir.Columns[0].Title.Caption := IniLng.ReadString('DB', 'title0', 'Filename');
  DBGridDir.Columns[1].Title.Caption := IniLng.ReadString('DB', 'title1', 'Ext');
  DBGridDir.Columns[2].Title.Caption := IniLng.ReadString('DB', 'title2', 'Filesize');
  DBGridDir.Columns[3].Title.Caption := IniLng.ReadString('DB', 'title3', 'Diskname');
  DBGridDir.Columns[4].Title.Caption := IniLng.ReadString('DB', 'title4', 'Recently opened');
  DBGridDir.Columns[5].Title.Caption := IniLng.ReadString('DB', 'title5', 'Imported');
  DBGridDir.Columns[6].Title.Caption := IniLng.ReadString('DB', 'title6', 'Favourite');
  DBGridDir.Columns[7].Title.Caption := IniLng.ReadString('DB', 'title7', 'Corrupt');
  DBGridDir.Columns[8].Title.Caption := IniLng.ReadString('DB', 'title8', 'Location');
  frmAbout.Caption := IniLng.ReadString('About', 'Title', 'About');
  frmAbout.lblFree.Caption := IniLng.ReadString('About', 'lblFree', 'You can use this software completly free!');
  frmAbout.lblLiability.Caption := IniLng.ReadString('About', 'lblLiability', 'There is no liability for misuse or damage...');
  frmAbout.lblLic.Caption := IniLng.ReadString('About', 'lblLic', 'License:');
  frmAbout.lblUses.Caption := IniLng.ReadString('About', 'lblUses', 'Uses:');
  frmAbout.lblDB.Caption := IniLng.ReadString('About', 'lblDB', 'Database:');
  frmAbout.lblFont.Caption := IniLng.ReadString('About', 'lblFont', 'Font:');
  frmManual.Caption := IniLng.ReadString('Manual', 'Title', 'Manual');
  frmDB.lblVersion.Caption := IniLng.ReadString('DB', 'lblVersion', 'Version:');
  frmDb.lblCreated.Caption := IniLng.ReadString('DB', 'lblCreated', 'Created:');
  frmDb.lblLocation.Caption := IniLng.ReadString('DB', 'lblLocation', 'Location:');
  frmDb.lblComment.Caption := IniLng.ReadString('DB', 'lblComment', 'Comment:');
  frmDel.Caption := IniLng.ReadString('Del', 'Title', 'Delete');
  frmDel.lblDel.Caption := IniLng.ReadString('Del', 'lblDel', 'Are you sure you want to delete the selected database entry?');
  frmDel.cbDelFile.Caption := IniLng.ReadString('Del', 'cbDelFile', 'Delete file on data storage too');
  frmDel.btYes.Caption := IniLng.ReadString('Del', 'btYes', 'Yes');
  frmDel.btNo.Caption := IniLng.ReadString('Del', 'btNo', 'No');
  tbDB.Caption := IniLng.ReadString('PC1', 'tbDBTitle', 'Database');
  grbFilterSearch.Caption := IniLng.ReadString('PC1', 'grbFilterSearch', 'Filter/Search (Use *):');
  lblFilterPath.Caption := IniLng.ReadString('PC1', 'lblFilterPath', 'Path:');
  cbDBFilePath.Hint := IniLng.ReadString('PC1', 'cbDBFilePathHint', 'Filter: Path to the images');
  lblFilterExt.Caption := IniLng.ReadString('PC1', 'lblFilterExt', 'Extension:');
  cbDBFileNameExt.Hint := IniLng.ReadString('PC1', 'cbDBFileNameExtHint', 'Filter: File extensions');
  cbFilterCase.Caption := IniLng.ReadString('PC1', 'cbFilterCase', 'Case-sensitive');
  cbFilterCase.Hint := IniLng.ReadString('PC1', 'cbFilterCaseHint', 'Filter: Case-sensitive extension');
  lblFilterImg.Caption := IniLng.ReadString('PC1', 'lblFilterImg', 'Image:');
  cbFilterFav.Caption := IniLng.ReadString('PC1', 'cbFilterFav', 'Favourite');
  cbFilterFav.Hint := IniLng.ReadString('PC1', 'cbFilterFavHint', 'Filter: Show favorites');
  cbFilterCorrupt.Caption := IniLng.ReadString('PC1', 'cbFilterCorrupt', 'Corrupt');
  cbFilterCorrupt.Hint := IniLng.ReadString('PC1', 'cbFilterCorruptHint', 'Filter: Show corrupt');
  lblSearch.Caption := IniLng.ReadString('PC1', 'lblSearch', 'Search:');
  EdSQLSearch.Hint := IniLng.ReadString('PC1', 'EdSQLSearchHint', 'Search database...');
  EdSQLSearch.TextHint := IniLng.ReadString('PC1', 'EdSQLSearchTextHint', 'Search database...');
  cbSQLSearch.Caption := IniLng.ReadString('PC1', 'cbSQLSearch', 'Directory entry');
  cbSQLSearch.Hint := IniLng.ReadString('PC1', 'cbSQLSearchHint', 'Select field');
  BtSQLSearch.Caption := IniLng.ReadString('PC1', 'BtSQLSearch', 'Search');
  BtSQLSearch.Hint := IniLng.ReadString('PC1', 'BtSQLSearchHint', 'Search');
  lblTags.Caption := IniLng.ReadString('PC1', 'lblTags', 'Tags:');
  edTags.Hint := IniLng.ReadString('PC1', 'edTags', 'Tags divided with comma');
  lblNotes.Caption := IniLng.ReadString('PC1', 'lblNotes', 'Notes:');
  tbDir.Caption := IniLng.ReadString('PC2', 'tbDirTitle', 'Directory');
  TgScratch.Caption := IniLng.ReadString('PC2', 'TgScratch', 'Scratched');
  TgScratch.Hint := IniLng.ReadString('PC2', 'TgScratchHint', 'Show scratched entries');
  TgCShift.Caption := IniLng.ReadString('PC2', 'TgCShift', 'C=-Shift');
  TgCShift.Hint := IniLng.ReadString('PC2', 'TgCShiftHint', 'Show shifted');
  lblOpenWith.Caption := IniLng.ReadString('PC2', 'lblOpenWith', 'Select emulator:');
  lblBAMInfo.Caption := IniLng.ReadString('PC2', 'lblBAMInfo', 'BAM Info:');
  tbBAM.Caption := IniLng.ReadString('PC2', 'tbBAMTitle', 'BAM');
  lblBAM.Caption := IniLng.ReadString('PC2', 'lblBAM', 'BAM (Block Availability Map)');
  tbSectors.Caption := IniLng.ReadString('PC2', 'tbSectorsTitle', 'Sectors (Hex)');
  lblTrack.Caption := IniLng.ReadString('PC2', 'lblTrack', 'Track:');
  lblSec.Caption := IniLng.ReadString('PC2', 'lblSec', 'Sector:');
  lblSource.Caption := IniLng.ReadString('PC2', 'lblSource', 'Source:');
  tbText.Caption := IniLng.ReadString('PC2', 'tbTextTitle', 'Text');
  lblText.Caption := IniLng.ReadString('PC2', 'lblText', 'Directory (TXT entries in database):');
  frmImport.grImportFrom.Caption := IniLng.ReadString('Import', 'grImportFrom', 'Select:');
  frmImport.DirImport.TextHint := IniLng.ReadString('Import', 'DirImportTextHint', 'Select directory...');
  frmImport.lblFileSel.Caption := IniLng.ReadString('Import', 'lblFileSel', 'File(s) found:');
  frmImport.lblImportFound.Caption := IniLng.ReadString('Import', 'lblImportFound', ' No folder selected!');
  frmImport.lblFileImg.Caption := IniLng.ReadString('Import', 'lblFileImg', 'Images:');
  frmImport.lblFileArc.Caption := IniLng.ReadString('Import', 'lblFileArc', 'Archives:');
  frmImport.grImportProgress.Caption := IniLng.ReadString('Import', 'grImportProgress', 'Progress:');
  frmImport.lblFileProgress.Caption := IniLng.ReadString('Import', 'lblFileProgress', 'File(s) imported:');
  frmImport.lblArchiveProgress.Caption := IniLng.ReadString('Import', 'lblArchiveProgress', 'Archive(s) imported:');
  frmImport.lblImportHintsErrors.Caption := IniLng.ReadString('Import', 'lblImportHintsErrors', 'Hints/Errors:');
  frmImport.btClose.Caption := IniLng.ReadString('Import', 'btClose', 'Close');
  frmImport.btCancel.Caption := IniLng.ReadString('Import', 'btCancel', 'Cancel');
  frmImport.btImport.Caption := IniLng.ReadString('Import', 'btImport', 'Import');
  frmImport.btSaveHints.Caption := IniLng.ReadString('Import', 'btSaveHints', 'Save hints');
end;

procedure TfrmMain.AddToRecentFiles(const aFileName: string);
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

procedure TfrmMain.UpdateRecentFilesMenu;
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

procedure TfrmMain.RecentFileClick(Sender: TObject);
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
   answer := MessageDlg(IniLng.ReadString('MSG', 'mnuRecentDBNF', 'Database not found'),mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      exit;
     end;
  end;
end;

procedure TfrmMain.SaveRecentFiles;
var
  i: Integer;
begin
  try
    IniFluff.EraseSection('RecentFiles');
    for i := 0 to RecentFiles.Count - 1 do IniFluff.WriteString('RecentFiles', 'File' + IntToStr(i), RecentFiles[i]);
  finally

  end;
end;

procedure TfrmMain.LoadRecentFiles;
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

procedure TfrmMain.UnpackFileFullContainsPipe(aFileFull : String);
var
 tmpImg, ArchivePath1, ArchivePath2 : String;
 ImageFileArray : TStringArray;
 i, answer : Integer;
begin
 If aFileFull.Contains('|') = true then  // check if path locates an archive
  begin
   ImageFileArray := aFileFull.Split('|');
   // Temp folder
   if DirectoryExists(sAppTmpPath) = false then
    begin
     answer := MessageDlg(IniLng.ReadString('MSG', 'msgImp08', 'Temporary directory not found! Please check settings...'),mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
    end;

   FileFull := sAppTmpPath + ExtractFileName(ImageFileArray[0]) + ImageFileArray[1]; //location of D64 in tmp folder  "c:\temp\mops.zip\123.d64"
   // check if zip archive exists
   if fileexists(ImageFileArray[0]) = false then
    begin
     exit;
    end;
   // check if archive already unpacked
   if fileexists(FileFull) = false then
    begin
     If DirectoryExists(sAppTmpPath + ExtractFileName(ImageFileArray[0])) = false then
      begin
       CreateDir(sAppTmpPath + ExtractFileName(ImageFileArray[0])); // folder to temporarly unzip archive
      end;
     tmpImg := ExtractFileName(ImageFileArray[1]);
     ArchivePath1 := TrimLeadingBackslash(ImageFileArray[1]);
     ArchivePath2 := StringReplace(ArchivePath1, PathDelim, '/', [rfReplaceAll]);
     if UnpackFile(ImageFileArray[0], ArchivePath2, sAppTmpPath + ExtractFileName(ImageFileArray[0])) = false then
      begin
       exit;
      end;
    end;
   end
 else FileFull := aFileFull;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
 GetDB : String;
begin
 Dev_mode := false;
 sAppCaption := 'FluffyFloppy64 ';
 sAppVersion := 'v0.89';
 sAppDate    := '2025-12-09';
 sAppPath    := ExtractFilePath(ParamStr(0));
 frmMain.Caption:= sAppCaption + sAppVersion;
 SQlSearch_Click := false;
 dbGridSorted := 'ASC';

 // Default Folders
 If Dev_Mode = true then Showmessage('[Dev_Mode] - Create folders');
 If DirectoryExists(IncludeTrailingPathDelimiter(sAppPath + 'temp')) = false then CreateDir(IncludeTrailingPathDelimiter(sAppPath + 'temp\'));
 If DirectoryExists(IncludeTrailingPathDelimiter(sAppPath + 'nibtools')) = false then CreateDir(IncludeTrailingPathDelimiter(sAppPath + 'nibtools\'));

 // INI
 if FileExists(sAppPath + 'fluffyfloppy64.ini') = False then
  try
   IniFluff := TINIFile.Create(sAppPath + 'fluffyfloppy64.ini');
   IniFluff.WriteString('FluffyFloppy64', 'Version', sAppVersion);
   IniFluff.WriteString('FluffyFloppy64', 'Language', 'English');
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
   IniFluff.WriteString('NibConv', 'Location', IncludeTrailingPathDelimiter(sAppPath + 'nibtools\'));
   IniFluff.WriteBool('Options', 'Scratched', false);
   IniFluff.WriteBool('Options', 'Shifted', false);
   IniFluff.WriteBool('Options', 'IncludeT18T19', false);
   IniFluff.WriteBool('Options', 'cbPETSCII1819', false);
   IniFluff.WriteInteger('Options', 'DirFontSize', 12);
   IniFluff.WriteString('Options', 'DirFont', '$00F9B775');
   IniFluff.WriteString('Options', 'DirFontBackground', '$00DB3F1E');
   IniFluff.WriteInteger('Emulators', 'Select', 2);
   IniFluff.WriteString('CCS64', 'Location', '');
   IniFluff.WriteString('Denise', 'Location', '');
   IniFluff.WriteString('Hoxs64', 'Location', '');
   IniFluff.WriteString('VICE', 'Location', '');
  finally
 end;

 IniFluff := TINIFile.Create(sAppPath + 'fluffyfloppy64.ini');

 // Temp folder
 sAppTmpPath := IncludeTrailingPathDelimiter(IniFluff.ReadString('Options', 'FolderTemp', ''));
 DeleteDirectory(sAppTmpPath,true);  // Clean temp folder

 // Language
 GetLNG(IniFluff.ReadString('FluffyFloppy64', 'Language', 'English'));

 // Recent
 LoadRecentFiles;

 // Dev_Mode ?
 Dev_Mode :=  IniFluff.ReadBool('FluffyFloppy64', 'Dev_Mode', false);
 Dev_mode := false; // public version!
 If Dev_Mode = true then frmMain.Caption:= sAppCaption + sAppVersion + ' [Dev_Mode]';

 // Font
 If fileexists(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf') = false then
  begin
   Showmessage('Font not found: ' + chr(13) + PChar(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf'));
  end
  else
   begin
    If Dev_Mode = true then Showmessage('[Dev_Mode] - Font found: ' + chr(13) + PChar(IncludeTrailingPathDelimiter(sAppPath))+'C64_Pro_Mono-STYLE.ttf');
   end;

 If Dev_Mode = true then Showmessage('[Dev_Mode] - ClientWidth & ClientHeight');
 frmMain.ClientWidth := IniFluff.ReadInteger('Application', 'ClientWidth', 1000);
 frmMain.ClientHeight := IniFluff.ReadInteger('Application', 'ClientHeight', 600);
 pnDirView.Width := IniFluff.ReadInteger('Application', 'SplitterPos', 470);
 pnTagsNotes.Height := IniFluff.ReadInteger('Application', 'SplitterPosTN', 200);
 frmMain.Left := (frmMain.Monitor.Width  - frmMain.Width)  div 2;
 frmMain.Top  := (frmMain.Monitor.Height - frmMain.Height) div 2;

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

 // Temp folder
 If DirectoryExists(sAppTmpPath) = false then
  begin
   IniFluff.WriteString('Options', 'FolderTemp', IncludeTrailingPathDelimiter(sAppPath + 'temp\')); // default
  end;

 // Nibtools
 If DirectoryExists(ExtractFilePath(IniFluff.ReadString('NibConv', 'Location', IncludeTrailingPathDelimiter(sAppPath + 'nibtools\')))) = false then
  begin
   IniFluff.WriteString('NibConv', 'Location', '');
  end;
 If FileExists(IniFluff.ReadString('NibConv', 'Location', IncludeTrailingPathDelimiter(sAppPath + 'nibtools\') + 'nibconv.exe')) = false then
  begin
   IniFluff.WriteString('NibConv', 'Location', '');
  end;

 // Database
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
        LstBxDirectoryPETSCII.Items.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found')  );
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

procedure TfrmMain.LstBrowseKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 FileSizeImg, FileNameExt : String;
 BA : TByteArr;
 s, ImageSize, aTmpPath : String;
 answer : Integer;
begin
 FileFull    := ShellTreeView1.Path + LstBrowse.Selected.caption;
 FileNameExt := ExtractFileExt(FileFull);

 BA := LoadByteArray(FileFull);
 s := ByteArraytoHexString(BA);
 ImageSize := ByteArrayToHexString(BA);
 FileSizeImg := IntToStr(length(ImageSize) div 2);

 if (length(FileNameExt)>0) and (FileNameExt[1]='.') then delete(FileNameExt,1,1); // d64 ohne Punkt

 // Temp folder
 if DirectoryExists(sAppTmpPath) = false then
  begin
   answer := MessageDlg(IniLng.ReadString('MSG', 'msgImp08', 'Temporary directory not found! Please check settings...'),mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      exit;
     end;
  end;

 GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);

 if PC2.Pages[1].Visible = true then
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
  if PC2.Pages[2].Visible = true then
  begin
   LoadTS(FileFull);
  end;
  if PC2.Pages[3].Visible = true then
  begin
   LstBxDirectoryTxt.Clear;
  end;
end;

procedure TfrmMain.LstBxDirectoryPETSCIIDblClick(Sender: TObject);
var
  i, answer : Integer;
  s : string;
  img_file : string; // File Browser
  msgEmu01, msgEmu02, msgEmu03, msgEmu04, msgEmu05, msgEmu06, msgEmu07, msgEmu08 : String;
  msgEmu09, msgEmu10, msgEmu11, msgEmu12, msgEmu13, msgEmu14, msgEmu15, msgEmu16 : String;
  msgEmu17, msgEmu18, msgEmu19, msgEmu20, msgDM01 : String;
begin
 msgEmu01 := IniLng.ReadString('MSG', 'msgEmu01', 'CCS64 not found!');
 msgEmu02 := IniLng.ReadString('MSG', 'msgEmu02', 'CCS64 does not support nib images!');
 msgEmu03 := IniLng.ReadString('MSG', 'msgEmu03', 'CCS64 does not support d71 images!');
 msgEmu04 := IniLng.ReadString('MSG', 'msgEmu04', 'CCS64 does not support d81 images!');
 msgEmu05 := IniLng.ReadString('MSG', 'msgEmu05', 'Denise not found!');
 msgEmu06 := IniLng.ReadString('MSG', 'msgEmu06', 'Denise does not support nib images!');
 msgEmu07 := IniLng.ReadString('MSG', 'msgEmu07', 'Denise does not support d71 images!');
 msgEmu08 := IniLng.ReadString('MSG', 'msgEmu08', 'Denise does not support d81 images!');
 msgEmu09 := IniLng.ReadString('MSG', 'msgEmu09', 'Emu64 not found!');
 msgEmu10 := IniLng.ReadString('MSG', 'msgEmu10', 'Emu64 does not support nib images!');
 msgEmu11 := IniLng.ReadString('MSG', 'msgEmu11', 'Emu64 does not support d71 images!');
 msgEmu12 := IniLng.ReadString('MSG', 'msgEmu12', 'Emu64 does not support d81 images!');
 msgEmu13 := IniLng.ReadString('MSG', 'msgEmu13', 'Hoxs not found!');
 msgEmu14 := IniLng.ReadString('MSG', 'msgEmu14', 'Hoxs does not support nib images!');
 msgEmu15 := IniLng.ReadString('MSG', 'msgEmu15', 'Hoxs does not support d71 images!');
 msgEmu16 := IniLng.ReadString('MSG', 'msgEmu16', 'Hoxs does not support d81 images!');
 msgEmu17 := IniLng.ReadString('MSG', 'msgEmu17', 'VICE not found!');
 msgEmu18 := IniLng.ReadString('MSG', 'msgEmu18', 'VICE does not support nib images!');
 msgEmu19 := IniLng.ReadString('MSG', 'msgEmu19', 'VIVE does not support d71 images!');
 msgEmu20 := IniLng.ReadString('MSG', 'msgEmu20', 'VICE does not support d81 images!');
 msgDM01 := IniLng.ReadString('MSG', 'msgDM01', 'DirMaster not found!');

 UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);

  // CCS64###################################################################
  If cbEmulator.Text = 'CCS64' then
   begin
    if fileexists(IniFluff.ReadString('CCS64', 'Location', '')) = false then
     begin
      answer := MessageDlg(msgEmu01,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg(msgEmu02,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    If lowercase(ExtractFileExt(FileFull)) = '.d71' then
     begin
      answer := MessageDlg(msgEmu03,mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
     end;
    If lowercase(ExtractFileExt(FileFull)) = '.d81' then
     begin
      answer := MessageDlg(msgEmu04,mtWarning, [mbOK], 0);
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
      If tgScratch.Checked = false then OpenEmu(IniFluff.ReadString('CCS64', 'Location', ''),'"' + FileFull + ',' + IntToStr(i-1) + '"');
      If tgScratch.Checked = true then
       begin
        s := lowercase(LstBxDirectoryTXT.Items[i-1]);
        OpenEmu(IniFluff.ReadString('CCS64', 'Location', ''),'"' + FileFull + ',' + IntToStr(Str_Dir.IndexOf(s)) + '"');
       end;
     end;
   end;
  // CCS64 mount only ########################################################
  If cbEmulator.Text = 'CCS64 (mount)' then
   begin
    if fileexists(IniFluff.ReadString('CCS64', 'Location', '')) = false then
     begin
      answer := MessageDlg(msgEmu01,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg(msgEmu02,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg(msgEmu03,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
    If lowercase(ExtractFileExt(FileFull)) = '.d81' then
     begin
      answer := MessageDlg(msgEmu04,mtWarning, [mbOK], 0);
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
      answer := MessageDlg(msgEmu05,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg(msgEmu07,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg(msgEmu08,mtWarning, [mbOK], 0);
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
  If cbEmulator.Text = 'Denise (mount)' then
   begin
    if fileexists(IniFluff.ReadString('Denise', 'Location', '')) = false then
     begin
      answer := MessageDlg(msgEmu05,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg(msgEmu07,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg(msgEmu08,mtWarning, [mbOK], 0);
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
      answer := MessageDlg(msgEmu09,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
   If lowercase(ExtractFileExt(FileFull)) = '.nib' then
    begin
     answer := MessageDlg(msgEmu10,mtWarning, [mbOK], 0);
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
  If cbEmulator.Text = 'Emu64 (mount)' then
   begin
    if fileexists(IniFluff.ReadString('Emu64', 'Location', '')) = false then
     begin
      answer := MessageDlg(msgEmu09,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg(msgEmu10,mtWarning, [mbOK], 0);
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
      answer := MessageDlg(msgEmu13,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg(msgEmu15,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg(msgEmu16,mtWarning, [mbOK], 0);
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
      If tgScratch.Checked = false then OpenEmu(IniFluff.ReadString('Hoxs64', 'Location', ''),' -autoload "' + FileFull + '" @' + IntToStr(i-1) + '');
      If tgScratch.Checked = true then
       begin
        s := lowercase(LstBxDirectoryTXT.Items[i-1]);
        OpenEmu(IniFluff.ReadString('Hoxs64', 'Location', ''),' -autoload "' + FileFull + '" @' + IntToStr(Str_Dir.IndexOf(s)) + '');
       end;
     end;
   end;
  // Hoxs64 mount only #######################################################
  If cbEmulator.Text = 'Hoxs64 (mount)' then
   begin
    if fileexists(IniFluff.ReadString('Hoxs64', 'Location', '')) = false then
     begin
      answer := MessageDlg(msgEmu13,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.d71' then
      begin
       answer := MessageDlg(msgEmu15,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;
     If lowercase(ExtractFileExt(FileFull)) = '.d81' then
      begin
       answer := MessageDlg(msgEmu16,mtWarning, [mbOK], 0);
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
      answer := MessageDlg(msgEmu17,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg(msgEmu18,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
      end;

    // FileBrowser
    If PC1.Pages[1].Visible = true then
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
  If cbEmulator.Text = 'Vice (mount)' then
   begin
    if fileexists(IniFluff.ReadString('VICE', 'Location', '')) = false then
     begin
      answer := MessageDlg(msgEmu17,mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     If lowercase(ExtractFileExt(FileFull)) = '.nib' then
      begin
       answer := MessageDlg(msgEmu18,mtWarning, [mbOK], 0);
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
      answer := MessageDlg(msgDM01,mtWarning, [mbOK], 0);
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


procedure TfrmMain.memInfoEditingDone(Sender: TObject);
begin
  if ATransaction.Active then
   begin
     SQlQueryDir.Edit;
     SQlQueryDir.FieldByName('Info').AsString := memInfo.Lines.Text;
     SQlQueryDir.Post;
     SQlQueryDir.ApplyUpdates;
   end;
end;

procedure TfrmMain.mnuRecFavouriteClick(Sender: TObject);
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

procedure TfrmMain.mnuRecPrintClick(Sender: TObject);
begin
 //PrintListBox(LstBxDirectoryPETSCII);
end;

procedure TfrmMain.mnuRecRefreshClick(Sender: TObject);
begin
 frmImport.Init_str_FindAllImages_Sync;
end;

procedure TfrmMain.mnuRecCorruptClick(Sender: TObject);
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

procedure TfrmMain.mnuViewDateLastClick(Sender: TObject);
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

procedure TfrmMain.mnuViewDateImportedClick(Sender: TObject);
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

procedure TfrmMain.mnuViewLocationClick(Sender: TObject);
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

procedure TfrmMain.mnuDelTempClick(Sender: TObject);
var
  tmpPathArch : TStringList;
  i : Integer;
begin
 // Clean tmp folder
 If MessageDlg('Are you sure you want to clear the temporary folder?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   try
    CleanTmp(sAppTmpPath); // Clean tmp folder;
   except
   On E : Exception do
    begin
     ShowMessage(E.Message + ' - Unable to clear temporary folder! Please check files for "readonly" attribute.');
    end;
   end;
  end;
end;

procedure TfrmMain.mnuPropertiesClick(Sender: TObject);
begin
 frmDB.showmodal;
end;

procedure TfrmMain.mnuRecDeleteClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   frmDel.ShowModal;
  end;
end;

procedure TfrmMain.mnuCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.mnuCorruptClick(Sender: TObject);
begin
 mnuRecCorrupt.Click;
end;

procedure TfrmMain.mnuDeleteClick(Sender: TObject);
begin
 mnuRecDelete.Click;
end;

procedure TfrmMain.mnuFavouriteClick(Sender: TObject);
begin
  mnuRecFavourite.Click;
end;

procedure TfrmMain.mnuManualClick(Sender: TObject);
begin
  frmManual.ShowModal;
end;

procedure TfrmMain.mnuNewClick(Sender: TObject);
var
 answer : integer;
begin
 Database_OpenDialog.Title:= IniLng.ReadString('MSG', 'msgDB01', 'Create new database');
 if Database_OpenDialog.Execute then
 begin
  if FileExists(Database_OpenDialog.FileName) then
   begin
    answer := MessageDlg(IniLng.ReadString('MSG', 'msgDB02', 'Database already exists! Unable to create!'),mtWarning, [mbOK], 0);
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
    answer := MessageDlg(IniLng.ReadString('MSG', 'msgDB03', 'Unable to create new database'),mtWarning, [mbOK], 0);
     if answer = mrOk then
      begin
       ATransaction.Active:=false;
      end;
  end;

  AddToRecentFiles(Database_OpenDialog.FileName);

  mnuImport.Enabled:=true;
  mnuRecOpen.Enabled:=false;
  mnuRecOpenLocation.Enabled:=false;
  mnuRecFavourite.Enabled:=false;
  mnuRecFavourite.Enabled:=false;
  mnuRecCorrupt.Enabled:=false;
  mnuRecDelete.Enabled:=false;
  edTags.Enabled:=false;
  memInfo.Enabled:=false;
  mnuOpenImage.Enabled:=false;
  mnuOpenFileBrowser.Enabled:=false;
  mnuOpenExplorer.Enabled:=false;
  mnuFavourite.Enabled:=false;
  mnuCorrupt.Enabled:=false;
  mnuRefresh.Enabled:=false;
  mnuDelete.Enabled:=false;
  edTags.Enabled:=false;
  memInfo.Enabled:=false;
  StatusBar1.Panels[0].Text:= '0/0';
  StatusBar1.Panels[1].Text:= '';
  StatusBar1.Panels[2].Text:= '';
  StatusBar1.Panels[3].Text:= '';
  LstBxDirectoryPETSCII.Clear;
  LstBxDirectoryPETSCII.Items.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found'));
  MemoBAMHint.Clear;
  frmMain.Caption:= sAppCaption + sAppVersion + ' [' + ExtractFileName(Database_OpenDialog.FileName) + ']';
  IniFluff.WriteString('Database', 'Location', Database_OpenDialog.FileName);
  answer := MessageDlg(IniLng.ReadString('MSG', 'msgDB04', 'Database successfully created!'),mtInformation, [mbOK], 0);
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

procedure TfrmMain.mnuOpenClick(Sender: TObject);
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

procedure TfrmMain.mnuOpenExplorerClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   SysUtils.ExecuteProcess(UTF8ToSys('explorer.exe'), '/select,'+'"'+ FileFull +'"', []);
  end;
end;

procedure TfrmMain.mnuOpenFileBrowserClick(Sender: TObject);
begin
 //PC1.Pages[1].Show;
 //ShellTreeView1.Path := SQLQueryDir.FieldByName('FilePath').Text;
 //LstBrowse.Refresh;
 //LstBrowse.ItemIndex:= SQLQueryDir.RecNo-1;
 //LstBrowse.SetFocus;
end;

procedure TfrmMain.mnuOpenImageClick(Sender: TObject);
begin
 OpenDocument(IncludeTrailingPathDelimiter(SQLQueryDir.FieldByName('FilePath').DisplayText) + SQLQueryDir.FieldByName('FileName').DisplayText + '.' + SQLQueryDir.FieldByName('FileNameExt').DisplayText);
end;

procedure TfrmMain.mnuRecOpenLocationClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   SysUtils.ExecuteProcess(UTF8ToSys('explorer.exe'), '/select,'+'"'+ FileFull +'"', []);
  end;
end;

procedure TfrmMain.mnuRecOpenClick(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then OpenDocument(IncludeTrailingPathDelimiter(SQLQueryDir.FieldByName('FilePath').DisplayText) + SQLQueryDir.FieldByName('FileName').DisplayText + '.' + SQLQueryDir.FieldByName('FileNameExt').DisplayText);
end;

procedure TfrmMain.mnuOptionsClick(Sender: TObject);
begin
  Form4.Showmodal;
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
 frmAbout.lblVersion.Caption := sAppVersion + ' - ' + sAppDate;
 If Dev_Mode = true then frmAbout.lblVersion.Caption := sAppCaption + sAppVersion + ' [Dev_Mode]';
 frmAbout.Showmodal;
end;

procedure TfrmMain.mnuImportClick(Sender: TObject);
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
   mnuRecOpen.Enabled:=true;
   mnuRecOpenLocation.Enabled:=true;
   mnuRecFavourite.Enabled:=true;
   mnuRecFavourite.Enabled:=true;
   mnuRecCorrupt.Enabled:=true;
   mnuRecDelete.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
   mnuOpenImage.Enabled:=true;
   mnuOpenFileBrowser.Enabled:=true;
   mnuOpenExplorer.Enabled:=true;
   mnuFavourite.Enabled:=true;
   mnuCorrupt.Enabled:=true;
   mnuRefresh.Enabled:=false;
   mnuDelete.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
  end
 else
  begin
   mnuRecOpen.Enabled:=false;
   mnuRecOpenLocation.Enabled:=false;
   mnuRecFavourite.Enabled:=false;
   mnuRecFavourite.Enabled:=false;
   mnuRecCorrupt.Enabled:=false;
   mnuRecDelete.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
   mnuOpenImage.Enabled:=false;
   mnuOpenFileBrowser.Enabled:=false;
   mnuOpenExplorer.Enabled:=false;
   mnuFavourite.Enabled:=false;
   mnuCorrupt.Enabled:=false;
   mnuRefresh.Enabled:=false;
   mnuDelete.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
  end;
  frmImport.Showmodal;
end;

Procedure TfrmMain.Init_FilePath;
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

procedure TfrmMain.mnuSyncClick(Sender: TObject);
begin
 // frmImport.Init_str_FindAllImages_Sync;
end;

procedure TfrmMain.PC1Change(Sender: TObject);
begin
  If PC1.Pages[1].Visible = true then
   begin
    LstBxDirectoryPETSCII.Clear;
    MemoBAMHint.Clear;
    LstBxDirectoryTXT.Clear;
    LstBAM.Clear;
    LstBoxSectors.Clear;
    lstBoxPETSCII.Clear;
   end;
end;

procedure TfrmMain.PC2Change(Sender: TObject);
var
 FileNameExt, FileSizeImg : String;
 BA : TByteArr;
 s, ImageSize : String;
begin
 if SQLQueryDir.Active then
  begin

 // Database
 If PC1.Pages[0].Visible = true then
  begin
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text); // FileFull
   FileSizeImg := SQLQueryDir.FieldByName('FileSizeImg').Text;
   FileNameExt := lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString);
   if PC2.Pages[1].Visible = true then
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
   if PC2.Pages[2].Visible = true then
    begin
     Init_TrkSec_HexDropdown(FileFull);
     Init_SectorsHexDropDown;
     LoadTS(FileFull);
    end;
   exit;
  end;

  // FileBrowser
  //If PC1.Pages[1].Visible = true then
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
  //  if PC2.Pages[1].Visible = true then
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
  //   if PC2.Pages[2].Visible = true then
  //   begin
  //    Init_TrkSec_HexDropdown(FileFull);
  //    Init_SectorsHexDropDown;
  //    LoadTS(FileFull);
  //   end;
  //   if PC2.Pages[3].Visible = true then
  //    begin
  //     LstBxDirectoryTxt.Clear;
  //    end;
  // end;

  end;
end;

procedure TfrmMain.LstBrowseClick(Sender: TObject);
var
 FileFull, FileSizeImg, FileNameExt : String;
 BA : TByteArr;
 s, ImageSize : String;
 answer : Integer;
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

   // Temp folder
   if DirectoryExists(sAppTmpPath) = false then
    begin
     answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
    end;
   GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);

   if PC2.Pages[1].Visible = true then
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
    if PC2.Pages[2].Visible = true then
    begin
     LoadTS(FileFull);
    end;
    if PC2.Pages[3].Visible = true then
    begin
     LstBxDirectoryTxt.Clear;
    end;
  end;

end;

Procedure TfrmMain.OpenDatabase(aFileName : String);
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
 CleanTmp(sAppTmpPath);
 DBFilter;

 frmMain.Caption:= sAppCaption + sAppVersion + ' - [' + ExtractFileName(aFileName) + ']';
 If Dev_Mode = true then
  begin
   frmMain.Caption:= sAppCaption + sAppVersion + ' [Dev_Mode] - [' + ExtractFileName(aFileName) + ']';
  end;
 IniFluff.WriteString('Database', 'Location', aFileName);
 mnuImport.Enabled:=true;

 If SQLQueryDir.RecordCount > 0 then
  begin
   Statusbar1.Panels[0].Text := ' ' + IntToStr(SQLQueryDir.RecNo) + '/' + IntToStr(SQLQueryDir.RecordCount);
   mnuRecOpen.Enabled:=true;
   mnuRecOpenLocation.Enabled:=true;
   mnuRecFavourite.Enabled:=true;
   mnuRecFavourite.Enabled:=true;
   mnuRecCorrupt.Enabled:=true;
   mnuRecDelete.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
   mnuOpenImage.Enabled:=true;
   mnuOpenFileBrowser.Enabled:=true;
   mnuOpenExplorer.Enabled:=true;
   mnuFavourite.Enabled:=true;
   mnuCorrupt.Enabled:=true;
   mnuRefresh.Enabled:=false;
   mnuDelete.Enabled:=true;
   edTags.Enabled:=true;
   memInfo.Enabled:=true;
  end
 else
  begin
   if SQLQueryDir.RecordCount < 1 then Statusbar1.Panels[0].Text := ' -/- ';
   mnuRecOpen.Enabled:=false;
   mnuRecOpenLocation.Enabled:=false;
   mnuRecFavourite.Enabled:=false;
   mnuRecFavourite.Enabled:=false;
   mnuRecCorrupt.Enabled:=false;
   mnuRecDelete.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
   mnuOpenImage.Enabled:=false;
   mnuOpenFileBrowser.Enabled:=false;
   mnuOpenExplorer.Enabled:=false;
   mnuFavourite.Enabled:=false;
   mnuCorrupt.Enabled:=false;
   mnuRefresh.Enabled:=false;
   mnuDelete.Enabled:=false;
   edTags.Enabled:=false;
   memInfo.Enabled:=false;
  end;
end;

procedure TfrmMain.Convert_G64NIB(aImageName: String);
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
   if DirectoryExists(sAppTmpPath) = false then
    begin
     answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
    end;

    // NibConv G64 or NIB to D64
    aImageNameD64 := ExtractFileName(ChangeFileExt(aImageName,'.d64'));
    nibProcess := TProcess.Create(nil);
    try
     nibProcess.Executable := '"' + IniFluff.ReadString('NibConv', 'Location', '') + '" ';
     nibProcess.Parameters.Add('"' + aImageName + '"');
     nibProcess.Parameters.Add(IncludeTrailingPathDelimiter(sAppTmpPath) + aImageNameD64);
     nibProcess.ShowWindow := swoHide;
     nibProcess.Options := nibProcess.Options + [poWaitOnExit];
     nibProcess.Execute;
     except
      on E: Exception do frmImport.memoImportErr.Lines.Add('A convert exception was raised: ' + E.Message + '- File: ' + aImageName);
    end;
    nibProcess.Free;
end;

procedure TfrmMain.DBSearch;
var
 StrSQL : String;
 answer : Integer;
begin
 StrSQL := '';

 // Temp folder
 if DirectoryExists(sAppTmpPath) = false then
  begin
   answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      exit;
     end;
  end;

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

        frmMain.SQLQueryDir.Close;
        frmMain.SQLQueryDir.SQL.Clear;
        StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where DiskName Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        frmMain.SQLQueryDir.Active := True;

        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=false;
        DBGridSplitter.Visible:=false;

        If frmMain.SQLQueryDir.RecordCount > 0 then
         begin
          frmMain.Statusbar1.Panels[0].Text := ' ' + IntToStr(frmMain.SQLQueryDir.RecNo) + '/' + IntToStr(frmMain.SQLQueryDir.RecordCount);
          UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
          GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);
          Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
         end;
        If frmMain.SQLQueryDir.RecordCount < 1 then    // Kein Suchergebnis
         begin
          LstBxDirectoryPETSCII.Clear;
          Statusbar1.Panels[0].Text := ' 0/0';
          Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
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

        frmMain.SQLQueryDir.Close;
        frmMain.SQLQueryDir.SQL.Clear;
        StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where FileName Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        frmMain.SQLQueryDir.Active := True;

        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=false;
        DBGridSplitter.Visible:=false;

        If frmMain.SQLQueryDir.RecordCount > 0 then
         begin
          frmMain.Statusbar1.Panels[0].Text := ' ' + IntToStr(frmMain.SQLQueryDir.RecNo) + '/' + IntToStr(frmMain.SQLQueryDir.RecordCount);
          UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
          GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);
          Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
         end;
        If frmMain.SQLQueryDir.RecordCount < 1 then    // Kein Suchergebnis
         begin
          LstBxDirectoryPETSCII.Clear;
          Statusbar1.Panels[0].Text := ' 0/0';
          Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
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

        frmMain.SQLQueryDir.Close;
        frmMain.SQLQueryDir.SQL.Clear;
        StrSQL := 'SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage Where Tags Like "' + StringReplace(EdSQLSearch.Text, '*', '%', [rfReplaceAll, rfIgnoreCase]) + '"';
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked = false) then StrSQL := StrSQL + ' AND Favourite = true'
         else
        If (cbFilterCorrupt.Checked) AND (cbFilterFav.Checked = false) then StrSQL := StrSQL + ' AND Corrupt = true'
         else
        If (cbFilterFav.Checked) AND (cbFilterCorrupt.Checked) then StrSQL := StrSQL + ' AND Favourite = true AND Corrupt = true';
        SQLQueryDir.SQL.Add(StrSQL);
        frmMain.SQLQueryDir.Active := True;

        BtSQLSearch.Caption:='Reset';
        BtSQLSearch.ImageIndex:=3;
        BtSQLSearch.Default:=false;
        DBGridDirTxt.Visible:=false;
        DBGridSplitter.Visible:=false;

        If frmMain.SQLQueryDir.RecordCount > 0 then
         begin
          frmMain.Statusbar1.Panels[0].Text := ' ' + IntToStr(frmMain.SQLQueryDir.RecNo) + '/' + IntToStr(frmMain.SQLQueryDir.RecordCount);
          UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
          GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);
          Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;
         end;
        If frmMain.SQLQueryDir.RecordCount < 1 then    // Kein Suchergebnis
         begin
          LstBxDirectoryPETSCII.Clear;
          Statusbar1.Panels[0].Text := ' 0/0';
          Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
          Statusbar1.Panels[2].Text := '';
          Statusbar1.Panels[3].Text := '';
          Statusbar1.Panels[4].Text := '';
         end;
        exit;
       end;
      end;

    end;
end;

procedure TfrmMain.BtSQLSearchClick(Sender: TObject);
begin
 DBSearch;
end;

procedure TfrmMain.DBFilter;
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

procedure TfrmMain.cbDBFilePathChange(Sender: TObject);
begin
 CleanTmp(sAppTmpPath);
 DBFilter;
end;

procedure TfrmMain.cbDBFileNameExtChange(Sender: TObject);
begin
 CleanTmp(sAppTmpPath);
 DBFilter;
end;

procedure TfrmMain.cbFilterCaseChange(Sender: TObject);
begin
 CleanTmp(sAppTmpPath);
 DBFilter;
end;

procedure TfrmMain.cbFilterCorruptChange(Sender: TObject);
begin
 CleanTmp(sAppTmpPath);
 DBFilter;
end;

procedure TfrmMain.cbFilterFavChange(Sender: TObject);
begin
 CleanTmp(sAppTmpPath);
 DBFilter;
end;

procedure TfrmMain.cbSectorChange(Sender: TObject);
begin
 If PC1.Pages[0].Visible = true then
  begin
   LoadTS(FileFull);
  end;
 If PC1.Pages[1].Visible = true then
  begin
   If LstBrowse.SelCount < 1 then Exit;
   LoadTS(ShellTreeView1.Path + LstBrowse.Selected.caption);
  end;
end;

procedure TfrmMain.cbSQLSearchChange(Sender: TObject);
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

procedure TfrmMain.cbTrackChange(Sender: TObject);
begin
 If PC1.Pages[1].Visible = true then
  begin
   If LstBrowse.SelCount < 1 then Exit;
  end;
 If PC1.Pages[0].Visible = true then
  begin
   Init_SectorsHexDropDown;
   LoadTS(FileFull);
  end;
 If PC1.Pages[1].Visible = true then
  begin
   If LstBrowse.SelCount < 1 then Exit;
   Init_SectorsHexDropDown;
   LoadTS(ShellTreeView1.Path + LstBrowse.Selected.caption);
  end;
end;

procedure TfrmMain.DBGridDirCellClick(Column: TColumn);
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
   CleanTmp(sAppTmpPath);
   LoadDir;
  end;
end;

procedure TfrmMain.TgCShiftChange(Sender: TObject);
var
 answer : Integer;
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   // Temp folder
   if DirectoryExists(sAppTmpPath) = false then
    begin
     answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
    end;
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);
  end;
end;

procedure TfrmMain.TgScratchChange(Sender: TObject);
var
 answer : Integer;
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   // Temp folder
   if DirectoryExists(sAppTmpPath) = false then
    begin
     answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        exit;
       end;
    end;
   UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text);
   GetDirectoryImage(FileFull, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);
   DBGridDirTxt_ReadEntry;
  end;
end;

procedure GetDirectoryImage(aFileFull, aTmpPath : String; aScratch : Boolean; aLower: Boolean);
var
  fstream : TFileStream;
  filesizeImg, aImageNameD64 : String;
  aImageName : PChar;
  msgDir01, msgDir02, msgDir03, msgDir04, msgDir05, msgDir06, msgDir07, msgDir08 : String;
  msgDir09, msgDir10, msgDir11, msgDir12, msgDir13, msgDir14, msgDir15, msgDir16 : String;
Begin
  msgDir01 := IniLng.ReadString('MSG', 'msgDir01', 'Directory not stored in database');
  msgDir02 := IniLng.ReadString('MSG', 'msgDir02', 'unknown tracks, unknown error bytes');
  msgDir03 := IniLng.ReadString('MSG', 'msgDir03', 'Tape file (TAP)');
  msgDir04 := IniLng.ReadString('MSG', 'msgDir04', 'Program file (PRG)');
  msgDir05 := IniLng.ReadString('MSG', 'msgDir05', 'Database');
  msgDir06 := IniLng.ReadString('MSG', 'msgDir06', 'File');
  msgDir07 := IniLng.ReadString('MSG', 'msgDir07', '35 tracks, no error bytes');
  msgDir08 := IniLng.ReadString('MSG', 'msgDir08', '35 tracks, 683 error bytes');
  msgDir09 := IniLng.ReadString('MSG', 'msgDir09', '40 tracks, no error bytes');
  msgDir10 := IniLng.ReadString('MSG', 'msgDir10', '40 tracks, 768 error bytes');
  msgDir11 := IniLng.ReadString('MSG', 'msgDir11', '42 tracks, no error bytes');
  msgDir12 := IniLng.ReadString('MSG', 'msgDir12', '42 tracks, 802 error bytes');
  msgDir13 := IniLng.ReadString('MSG', 'msgDir13', '70 tracks, no error bytes');
  msgDir14 := IniLng.ReadString('MSG', 'msgDir14', '70 tracks, 1366 error bytes');
  msgDir15 := IniLng.ReadString('MSG', 'msgDir15', '80 tracks, no error bytes');
  msgDir16 := IniLng.ReadString('MSG', 'msgDir16', '80 tracks, 3200 error bytes');
  frmMain.LstBxDirectoryPETSCII.Clear;
  frmMain.Statusbar1.Panels[1].text := '';
  aImageNameD64 := '';
  // Check if g64 or nib
  If (Lowercase(ExtractFileExt(aFileFull)) = '.g64') or (Lowercase(ExtractFileExt(aFileFull)) = '.nib') then
   begin
    frmMain.Convert_G64NIB(aFileFull);
    aImageNameD64 := ExtractFileNameOnly(aFileFull)+'.d64';
    aFileFull := IncludeTrailingPathDelimiter(aTmpPath)+aImageNameD64;
   end; // G64/NIB END
  case LowerCase(ExtractFileExt(aFileFull)) of
   '.tap':
     begin
      frmMain.SQLQueryDirTXT.DataBase := frmMain.AConnection;
      frmMain.SQLQueryDirTxt.Close;
      frmMain.SQLQueryDirTxt.SQL.Clear;
      frmMain.SQLQueryDirTxt.SQL.Add('SELECT * FROM DirectoryTXT WHERE idxTXT = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
      frmMain.SQLQueryDirTxt.Active := True;
      frmMain.SQLQueryDirTxt.First;
      frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%', [frmMain.SQLQueryDirTXT.FieldByName('FileSizeTxt').Text, frmMain.SQLQueryDirTXT.FieldByName('FileNameTxt').Text]));
      frmMain.Statusbar1.Panels[1].text := '';
      frmMain.Statusbar1.Panels[2].Text := msgDir03;
     end;
   '.prg':
     begin
      frmMain.SQLQueryDirTXT.DataBase := frmMain.AConnection;
      frmMain.SQLQueryDirTxt.Close;
      frmMain.SQLQueryDirTxt.SQL.Clear;
      frmMain.SQLQueryDirTxt.SQL.Add('SELECT * FROM DirectoryTXT WHERE idxTXT = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
      frmMain.SQLQueryDirTxt.Active := True;
      frmMain.SQLQueryDirTxt.First;
      frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%', [frmMain.SQLQueryDirTXT.FieldByName('FileSizeTxt').Text, frmMain.SQLQueryDirTXT.FieldByName('FileNameTxt').Text]));
      frmMain.Statusbar1.Panels[1].text := '';
      frmMain.Statusbar1.Panels[2].Text := msgDir04;
     end;

   '.d64':
     begin
      // Check if T18/T19 from db is needed and available
      If (IniFluff.ReadBool('Options', 'cbPETSCIITracks', false) = true) then
       begin
        frmMain.SQLQueryTrks.DataBase := frmMain.AConnection;
        frmMain.SQLQueryTrks.Close;
        frmMain.SQLQueryTrks.SQL.Clear;
        frmMain.SQLQueryTrks.SQL.Add('SELECT * FROM Tracks WHERE idxTrks = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
        frmMain.SQLQueryTrks.Active := True;
        frmMain.SQLQueryTrks.First;
        frmMain.Statusbar1.Panels[3].Text := msgDir05;
        if (frmMain.SQlQueryTrks.RecordCount = 1) then  // Saved in db?
         begin
          arrD64[18,0] := frmMain.SQLQueryTrks.FieldByName('T18').AsString;
          arrD64[19,0] := frmMain.SQLQueryTrks.FieldByName('T19').AsString;
          frmMain.ReadDirEntries_D64;
          filesizeImg := frmMain.SQlQueryDir.FieldByName('filesizeImg').AsString;
         end;
        end
      else      // From file
       begin
        frmMain.Statusbar1.Panels[3].Text := msgDir06;
        fstream:= TFileStream.Create(aFileFull, fmShareCompat or fmOpenRead);
        filesizeImg := FloatToStr(fstream.Size);
        fstream.Free;
        Init_ArrD64(aFileFull);
        frmMain.ReadDirEntries_D64;
       end;
      case (filesizeImg) of
       ''       : frmMain.Statusbar1.Panels[1].text := msgDir01;
       '174848' : frmMain.Statusbar1.Panels[1].text := msgDir07;
       '175531' : frmMain.Statusbar1.Panels[1].text := msgDir08;
       '196608' : frmMain.Statusbar1.Panels[1].text := msgDir09;
       '197376' : frmMain.Statusbar1.Panels[1].text := msgDir10;
       '205312' : frmMain.Statusbar1.Panels[1].text := msgDir11;
       '206114' : frmMain.Statusbar1.Panels[1].text := msgDir12;
      otherwise
       frmMain.Statusbar1.Panels[1].text := msgDir02;
      end;

      // tmp d64 delete (source was g64/nib file)
      If aImageNameD64 <>'' then
       begin
        //aImageName := PChar(IncludeTrailingPathDelimiter(aTmpPath)+ aImageNameD64);
        aImageName := PChar(sAppTmpPath + aImageNameD64);
        If fileexists(aImageName) then DeleteFileUtf8(aImageName);
       end;
     end;

   '.d71':
      begin
       // Check if T18/T53 from db is needed and available
       If (IniFluff.ReadBool('Options', 'cbPETSCIITracks', false) = true) then
        begin
         frmMain.SQLQueryTrks.DataBase := frmMain.AConnection;
         frmMain.SQLQueryTrks.Close;
         frmMain.SQLQueryTrks.SQL.Clear;
         frmMain.SQLQueryTrks.SQL.Add('SELECT * FROM Tracks WHERE idxTrks = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
         frmMain.SQLQueryTrks.Active := True;
         frmMain.SQLQueryTrks.First;
         frmMain.Statusbar1.Panels[3].Text := msgDir05;
         if (frmMain.SQlQueryTrks.RecordCount = 1) then  // Saved in db?
          begin
           arrD71[18,0] := frmMain.SQLQueryTrks.FieldByName('T18').AsString;
           arrD71[53,0] := frmMain.SQLQueryTrks.FieldByName('T53').AsString;
           frmMain.ReadDirEntries_D64;
           filesizeImg := frmMain.SQlQueryDir.FieldByName('filesizeImg').AsString;
          end;
         end
       else      // From file
        begin
         frmMain.Statusbar1.Panels[3].Text := msgDir06;
         fstream:= TFileStream.Create(aFileFull, fmShareCompat or fmOpenRead);
         filesizeImg := FloatToStr(fstream.Size);
         fstream.Free;
         Init_ArrD71(aFileFull);
         frmMain.ReadDirEntries_D71;
        end;
       case (filesizeImg) of
        ''       : frmMain.Statusbar1.Panels[1].text := msgDir01;
        '349696' : frmMain.Statusbar1.Panels[1].text := msgDir13;
        '351062' : frmMain.Statusbar1.Panels[1].text := msgDir14;
       otherwise
        frmMain.Statusbar1.Panels[1].text := msgDir02;
       end;
      end;

   '.d81':
      begin
       // Check if T40 from db is needed and available
       If (IniFluff.ReadBool('Options', 'cbPETSCIITracks', false) = true) then
        begin
         frmMain.SQLQueryTrks.DataBase := frmMain.AConnection;
         frmMain.SQLQueryTrks.Close;
         frmMain.SQLQueryTrks.SQL.Clear;
         frmMain.SQLQueryTrks.SQL.Add('SELECT * FROM Tracks WHERE idxTrks = ' + frmMain.SQLQueryDir.FieldByName('idxImg').Text + '');
         frmMain.SQLQueryTrks.Active := True;
         frmMain.SQLQueryTrks.First;
         frmMain.Statusbar1.Panels[3].Text := msgDir05;
         if (frmMain.SQlQueryTrks.RecordCount = 1) then  // Saved in db?
          begin
           arrD81[40,0] := frmMain.SQLQueryTrks.FieldByName('T40').AsString;
           frmMain.ReadDirEntries_D81;
           filesizeImg := frmMain.SQlQueryDir.FieldByName('filesizeImg').AsString;
          end;
         end
       else      // From file
        begin
         frmMain.Statusbar1.Panels[3].Text := msgDir06;
         fstream:= TFileStream.Create(aFileFull, fmShareCompat or fmOpenRead);
         filesizeImg := FloatToStr(fstream.Size);
         fstream.Free;
         Init_ArrD81(aFileFull);
         frmMain.ReadDirEntries_D81;
        end;
       case (filesizeImg) of
        ''       : frmMain.Statusbar1.Panels[1].text := msgDir01;
        '819200' : frmMain.Statusbar1.Panels[1].text := msgDir15;
        '822400' : frmMain.Statusbar1.Panels[1].text := msgDir16;
       otherwise
        frmMain.Statusbar1.Panels[1].text := msgDir02;
       end;
      end;

  end;
end;

Procedure TfrmMain.ReadDirEntries_D64;
var
  sb : String;
  ImgTitle, ImgDiskID, ImgDOSVersion, ImgDOSType, ImgBAMInfo, FileType, FileName, FileBlocks, imgBlocksfree : String;
  a, b, bf, bf2, g, t, x, z, repeated, track, sector, sectorcount, sectorpos, TrackNext, SectorNext : Integer;
  arrSec: array[0..19] of Byte;
begin
   // Read out of ArrD64 #######################################################

   // Directory title floppy
   ImgTitle := GetArrayDir_PETSCII(arrD64[18,0], 289, 32, true, frmMain.TgCShift.Checked);
   // Directory DiskID // 20
   ImgDiskID := GetArrayDir_PETSCII(arrD64[18,0], 325, 6, true, frmMain.TgCShift.Checked);
   //Disk DOS version type $41 ("A")
   ImgDOSVersion := GetArrayDir_PETSCII(arrD64[18,0], 5, 2, true, frmMain.TgCShift.Checked);
   If (Copy(arrD64[18,0], 5, 2) = '41') or (Copy(arrD64[18,0], 5, 2) = '00') then
    begin
     frmMain.Statusbar1.Panels[2].Text := IniLng.ReadString('MSG', 'msgDir19', 'DOS version type:') + ' ' + Copy(arrD64[18,0], 5, 2);
    end
   else frmMain.Statusbar1.Panels[2].Text := 'Soft write protection';
   // Directory imgDOSType //   A5-A6: DOS type, usually "2A"
   ImgDOSType := GetArrayDir_PETSCII(arrD64[18,0], 331, 4, true, frmMain.TgCShift.Checked);

   frmMain.LstBxDirectoryPETSCII.Items.Add('0 ' + GetUTF8('$22', true, frmMain.TgCShift.Checked) + imgTitle + GetUTF8('$22', true, frmMain.TgCShift.Checked) + GetUTF8('$20', true, frmMain.TgCShift.Checked) + ImgDiskID + ImgDOSType);

   // Directory BAM memInfo
   ImgBAMInfo := GetArrayDir_PETSCII(arrD64[18,0], 335, 178, false, frmMain.TgCShift.Checked);
   frmMain.MemoBAMHint.Clear;
   frmMain.MemoBAMHint.Lines.Add(ImgBAMInfo);

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
      Statusbar1.Panels[2].Text := IniLng.ReadString('MSG', 'msgDir18', 'Not valid');
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
           FileName := FileName + GetUTF8('$'+Copy(sb, a, 2),false,frmMain.TgCShift.Checked);
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
       if frmMain.TgScratch.checked = true then // include deleted
        begin
         frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
        end;
       if frmMain.TgScratch.checked = false then
        begin
         if FileType <> '*DEL ' then frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
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
     frmMain.LstBxdirectoryPETSCII.Items.Add(ImgBlocksFree + ' BLOCKS FREE');

end;

Procedure TfrmMain.ReadDirEntries_D71;
var
  sb : String;
  ImgTitle, ImgDiskID, ImgDOSVersion, ImgDOSType, ImgBAMInfo, FileType, FileName, FileBlocks, imgBlocksfree : String;
  a, b, bf, bf2, g, t, x, z, repeated, track, sector, sectorcount, sectorpos, TrackNext, SectorNext : Integer;
  arrSec: array[0..19] of Byte;
begin
   // Read out of ArrD71 #######################################################
   // Directory title floppy
   ImgTitle := GetArrayDir_PETSCII(arrD71[18,0], 289, 32, true, frmMain.TgCShift.Checked);
   // Directory DiskID // 20
   ImgDiskID := GetArrayDir_PETSCII(arrD71[18,0], 325, 6, true, frmMain.TgCShift.Checked);
   //Disk DOS version type $41 ("A")
   ImgDOSVersion := GetArrayDir_PETSCII(arrD71[18,0], 5, 2, true, frmMain.TgCShift.Checked);
   frmMain.Statusbar1.Panels[2].Text := IniLng.ReadString('MSG', 'msgDir19', 'DOS version type:') + ' ' + ImgDOSVersion;
   // Directory imgDOSType //   A5-A6: DOS type, usually "2A"
   ImgDOSType := GetArrayDir_PETSCII(arrD71[18,0], 331, 4, true, frmMain.TgCShift.Checked);

   frmMain.LstBxDirectoryPETSCII.Items.Add('0 ' + GetUTF8('$22', true, frmMain.TgCShift.Checked) + imgTitle + GetUTF8('$22', true, frmMain.TgCShift.Checked) + GetUTF8('$20', true, frmMain.TgCShift.Checked) + ImgDiskID + ImgDOSType);

   // Directory BAM memInfo
   ImgBAMInfo := GetArrayDir_PETSCII(arrD71[18,0], 335, 178, false, frmMain.TgCShift.Checked);
   frmMain.MemoBAMHint.Clear;
   frmMain.MemoBAMHint.Lines.Add(ImgBAMInfo);

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
           FileName := FileName + GetUTF8('$'+Copy(sb, a, 2),false,frmMain.TgCShift.Checked);
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
       if frmMain.TgScratch.checked = true then
        begin
         frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
        end;
       if frmMain.TgScratch.checked = false then
        begin
         if FileType <> '*DEL ' then frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
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
    frmMain.LstBxdirectoryPETSCII.Items.Add(ImgBlocksFree + ' BLOCKS FREE');
    // Blocks free ENDE
end;

Procedure TfrmMain.ReadDirEntries_D81;
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
       ImgTitle := ImgTitle + GetUTF8('$'+Copy(sb, a, 2), true, frmMain.TgCShift.Checked);
      end;
     if Copy(sb, a, 2) = 'A0' then ImgTitle := ImgTitle + GetUTF8('$A0', true, frmMain.TgCShift.Checked);
    a := a + 2;
    end;
  // Directory title floppy ENDE

  // Directory DiskID // 20
  sb := Copy(arrD81[40,0],1+36,6);
  imgDiskID := '';
  a := 1;
   for z := 1 to 3 do
     begin
      ImgDiskID := ImgDiskID + GetUTF8('$'+Copy(sb, a, 2), true, frmMain.TgCShift.Checked);
      a := a +2;
     end;
   // Directory DiskID // 20

   // Directory DOSType // 2A
   sb := Copy(arrD81[40,0],1+42,4);
   imgDOSType := '';
   a := 1;
   for z := 1 to 2 do
     begin
      imgDOSType := imgDOSType + GetUTF8('$'+Copy(sb, a, 2), true, frmMain.TgCShift.Checked);
      a := a +2;
     end;
   frmMain.Statusbar1.Panels[2].Text := 'Dos type: ' + imgDOSType;
   // Directory DOSType // 2A

   frmMain.LstBxDirectoryPETSCII.Items.Add('0 ' + GetUTF8('$22', true, frmMain.TgCShift.Checked) + imgTitle + GetUTF8('$22', true, frmMain.TgCShift.Checked) + GetUTF8('$20', true, frmMain.TgCShift.Checked) + ImgDiskID + imgDOSType);

   // Directory BAM memInfo
   frmMain.MemoBAMHint.Clear;
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
           FileName := FileName + GetUTF8('$'+Copy(sb, a, 2),false,frmMain.TgCShift.Checked);
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
        if frmMain.TgScratch.checked = true then
         begin
          frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
         end;
        if frmMain.TgScratch.checked = false then
         begin
          if FileType <> '*DEL ' then frmMain.LstBxDirectoryPETSCII.Items.Add(Format('%-5s%-16s%s', [FileBlocks, FileName, FileType]));
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
   frmMain.LstBxDirectoryPETSCII.Items.Add(BlocksFree + ' BLOCKS FREE.');
   // Blocks free ENDE

end;


procedure TfrmMain.DBGridDirDblClick(Sender: TObject);
var
  answer : Integer;
begin
if SQlQueryDir.RecordCount > 0 then
 begin
  // Temp folder
  if DirectoryExists(sAppTmpPath) = false then
   begin
    answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
     if answer = mrOk then
      begin
       exit;
      end;
   end;
  CleanTmp(sAppTmpPath);
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
procedure TfrmMain.DBGridDirEnter(Sender: TObject);
begin
 if SQLQueryDir.RecordCount > 0 then
  begin
   mnuRecOpen.Enabled:=true;
   mnuRecOpenLocation.Enabled:=true;
   mnuRecFavourite.Enabled:=true;
   mnuRecCorrupt.Enabled:=true;
   mnuRecDelete.Enabled:=true;
  end;
end;

procedure TfrmMain.DBGridDirExit(Sender: TObject);
begin
 mnuRecOpen.Enabled:=false;
 mnuRecOpenLocation.Enabled:=false;
 mnuRecFavourite.Enabled:=false;
 mnuRecCorrupt.Enabled:=false;
 mnuRecDelete.Enabled:=false;
end;

procedure TfrmMain.DBGridDirKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  answer : Integer;
begin
  if (Key = VK_DOWN) or (Key = VK_UP) or (Key = VK_NEXT) or (Key = VK_PRIOR) or (Key = VK_HOME) or (Key = VK_END) then
   begin
    if SQLQueryDir.RecordCount > 0 then
     begin
      if DBGridDirTxt.Visible = true then
       begin
        if SQlQuerySearch.RecordCount > 0 then SQlQuerySearch.Locate('idxSearch', SQLQueryDir.FieldByName('idxImg').Text, []);
       end;
      // Temp folder
      if DirectoryExists(sAppTmpPath) = false then
       begin
        answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
         if answer = mrOk then
          begin
           exit;
          end;
       end;
      CleanTmp(sAppTmpPath);
      LoadDir;
     end;
   end;
end;
function GetNumScrollLines: Integer;
begin
  SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 1, @Result, 0);
end;
procedure TfrmMain.DBGridDirMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  answer : Integer;
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
    // Temp folder
    if DirectoryExists(sAppTmpPath) = false then
     begin
      answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
       if answer = mrOk then
        begin
         exit;
        end;
     end;
     CleanTmp(sAppTmpPath);
     LoadDir;
   end;
  end;
end;

procedure TfrmMain.DBGridDirTitleClick(Column: TColumn);
begin
  // remove image on already selected column
  if dbGridSorted = 'ASC' then
   begin
    dbGridSorted := 'DESC';
    frmMain.SQLQueryDir.IndexFieldNames := Column.FieldName + ' DESC';
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
    frmMain.SQLQueryDir.IndexFieldNames := Column.FieldName;
    Column.Title.ImageIndex:=0; // Up
    // Remove the sort arrow from the previous column we sorted
    if (FLastColumn <> nil) and (FlastColumn <> Column) then
      FLastColumn.Title.ImageIndex:=-1;
    FLastColumn:=column;
    Exit;
   end;
end;

procedure TfrmMain.DBGridDirSearch(Column: TColumn);
begin
  if SQLQueryDir.RecordCount > 0 then
   begin
    SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
    LoadDir;
   end;
end;

procedure TfrmMain.DBGridDirTxtCellClick(Column: TColumn);
begin
  if SQLQueryDir.RecordCount > 0 then
   begin
    SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
    LoadDir;
   end;
end;

procedure TfrmMain.DBGridDirTxtDblClick(Sender: TObject);
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

procedure TfrmMain.DBGridDirTxtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  answer : Integer;
begin
  if (Key = VK_DOWN) or (Key = VK_UP) or (Key = VK_NEXT) or (Key = VK_PRIOR) or (Key = VK_HOME) or (Key = VK_END) then
   begin
    if SQLQueryDir.RecordCount > 0 then
     begin
      // Temp folder
      if DirectoryExists(sAppTmpPath) = false then
       begin
        answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
         if answer = mrOk then
          begin
           exit;
          end;
       end;
      SQlQueryDir.Locate('idxImg', SQLQuerySearch.FieldByName('idxSearch').Text, []);
      CleanTmp(sAppTmpPath);
      LoadDir;
     end;
   end;
end;

procedure TfrmMain.DBGridDirTxtMouseWheel(Sender: TObject; Shift: TShiftState;
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

procedure TfrmMain.DBGridDirTxtTitleClick(Column: TColumn);
begin
  // remove image on already selected column
  if dbGridSorted = 'ASC' then
   begin
    dbGridSorted := 'DESC';
    frmMain.SQLQuerySearch.IndexFieldNames := Column.FieldName + ' DESC';
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
    frmMain.SQLQuerySearch.IndexFieldNames := Column.FieldName;
    Column.Title.ImageIndex:=0; // Up
    // Remove the sort arrow from the previous column we sorted
    if (FLastColumn <> nil) and (FlastColumn <> Column) then
      FLastColumn.Title.ImageIndex:=-1;
    FLastColumn:=column;
    Exit;
   end;
end;

procedure TfrmMain.EdSQLSearchChange(Sender: TObject);
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

procedure TfrmMain.edTagsEditingDone(Sender: TObject);
begin
  if ATransaction.Active then
   begin
     SQlQueryDir.Edit;
     SQlQueryDir.FieldByName('Tags').AsString := edtags.Text;
     SQlQueryDir.Post;
     SQlQueryDir.ApplyUpdates;
   end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 SaveRecentFiles;
 RecentFiles.Free;
 try
  CleanTmp(sAppTmpPath);
 except
 On E : Exception do
  ShowMessage(E.Message + ' - Unable to clear temporary folder! Please check files for e.g. "readonly" attribute.');
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
 IniLng.Free;

 if ATransaction.Active then
  begin
   SQlQueryDir.ApplyUpdates;
   ATransaction.Commit;
  end;
 AConnection.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 RecentFiles := TStringList.Create;
 Str_Dir := TStringList.Create;
 Str_DirAll := TStringList.Create;

 AddFontResourceExW(PWideChar('C64_Pro_Mono-STYLE.ttf'),FR_PRIVATE,nil);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  If Dev_Mode = true then Showmessage('[Dev_Mode] - Start RemoveFontRessource procedure');
  If fileexists(IncludeTrailingPathDelimiter(sAppPath)+'C64_Pro_Mono-STYLE.ttf') = true then
   begin
    RemoveFontResourceExW(PWideChar('C64_Pro_Mono-STYLE.ttf'),FR_PRIVATE,nil);
   end;
end;

procedure TfrmMain.DBGridDirTxt_ReadEntry;
var
  imgName: String;
begin
  Str_Dir.Clear;
  Str_DirAll.Clear;

  if SQLQueryDir.RecordCount < 1 then
   begin
    EdSQLSearch.Enabled:=false;
    cbSQLSearch.Enabled:=false;
    TgScratch.Enabled:=false;
    TgCShift.Enabled:=false;
    LstBxDirectoryTXT.Clear;
    LstBxDirectoryTXT.Items.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found'));
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
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

  // Fill to compare / regular dir
  SQLQueryDirTxt.First;
  While not SQLQueryDirTxt.EOF do
   begin
    imgName := SQLQueryDirTXT.FieldByName('FileNameTXT').Text;
    If SQLQueryDirTXT.FieldByName('FileTypeTxt').Text <> '*DEL ' then Str_Dir.Add(imgName);
    SQLQueryDirTxt.Next;
   end;
  // Fill to compare / full dir (incl DEL)
  SQLQueryDirTxt.First;
  While not SQLQueryDirTxt.EOF do
   begin
    imgName := SQLQueryDirTXT.FieldByName('FileNameTXT').Text;
    Str_DirAll.Add(imgName);
    SQLQueryDirTxt.Next;
   end;

  SQLQueryDirTxt.First;
  While not SQLQueryDirTxt.EOF do
   begin
    imgName := SQLQueryDirTXT.FieldByName('FileNameTXT').Text;
    If tgScratch.checked = false then
     begin
      If SQLQueryDirTXT.FieldByName('FileTypeTxt').Text <> '*DEL ' then LstBxDirectoryTXT.Items.Add(imgName);
     end;
    If tgScratch.checked = true then
     begin
      LstBxDirectoryTXT.Items.Add(imgName);
     end;
    SQLQueryDirTxt.Next;
   end;
end;

procedure TfrmMain.DBGridDir_ReadEntry(aImageName : String);
var
  answer : Integer;
begin
  If Dev_Mode = true then Showmessage('[Dev_Mode] - Start DBGridDir_ReadEntry procedure');
  If PC1.Pages[0].Visible = true then
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
      Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
      Statusbar1.Panels[2].Text := '';
      Statusbar1.Panels[3].Text := '';
      Statusbar1.Panels[4].Text := '';
      exit;
     end;
    if SQLQueryDir.RecordCount > 0 then
     begin
      If FileExists(aImageName) then
       begin
        // Temp folder
        if DirectoryExists(sAppTmpPath) = false then
         begin
          answer := MessageDlg('Temporary folder not found! Please go to settings...',mtWarning, [mbOK], 0);
           if answer = mrOk then
            begin
             exit;
            end;
         end;
        GetDirectoryImage(aImageName, sAppTmpPath, TgScratch.Checked, TgCShift.Checked);
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

procedure TfrmMain.LoadBAM_D64(aFileName : String; aFileSizeImg : String);
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
    //LstBxDirectoryPETSCII.Items.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
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
    LstBAM.Lines.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found'));
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

procedure TfrmMain.LoadBAM_D71(aFileName : String);
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
    //LstBxDirectoryPETSCII.Items.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
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
    LstBAM.Lines.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found'));
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

procedure TfrmMain.LoadBAM_D81(aFileName : String);
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
    //LstBxDirectoryPETSCII.Items.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found');
    memInfo.Enabled:=false;
    Statusbar1.Panels[0].Text := ' 0/0';
    Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
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
    LstBAM.Lines.Add(IniLng.ReadString('MSG', 'msgDB05', 'Image not found'));
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

procedure TfrmMain. Init_TrkSec_HexDropdown(aImageName : String);
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
procedure TfrmMain.LoadTS(aFileName : String);
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

procedure TfrmMain.LoadDir;
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
   Statusbar1.Panels[1].Text := IniLng.ReadString('MSG', 'msgDir17', 'No entries found');
   Statusbar1.Panels[2].Text := '';
   Statusbar1.Panels[3].Text := '';
   Statusbar1.Panels[4].Text := '';
   exit;
  end;
 if SQLQueryDir.RecordCount > 0 then
  begin
   Statusbar1.Panels[0].Text := ' ' + IntToStr(frmMain.SQLQueryDir.RecNo) + '/' + IntToStr(frmMain.SQLQueryDir.RecordCount);
   Statusbar1.Panels[4].Text := SQLQueryDir.FieldByName('FileFull').AsString;

   try
    UnpackFileFullContainsPipe(SQLQueryDir.FieldByName('FileFull').Text); // FileFull
   finally
   end;

   FileSizeImg := SQLQueryDir.FieldByName('FileSizeImg').Text;
   FileNameExt := lowercase(SQLQueryDir.FieldByName('FileNameExt').AsString);

   // Read directory
   DBGridDir_ReadEntry(FileFull);

   if PC2.Pages[1].Visible = true then
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

   if PC2.Pages[2].Visible = true then
    begin
     Init_TrkSec_HexDropdown(FileFull);
     Init_SectorsHexDropDown;
     LoadTS(FileFull);
    end;
  end;
end;

procedure TfrmMain.Init_SectorsHexDropDown;
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


