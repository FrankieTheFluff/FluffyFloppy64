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
    lbFontFolder: TLabel;
    lbFontFolder2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbHoxs64Location: TLabel;
    lblCCS64Location: TLabel;
    lblDenise: TLabel;
    lblEmu64: TLabel;
    lblDirMaster: TLabel;
    lblFontBackground: TLabel;
    lblFontColor: TLabel;
    lblFontSize: TLabel;
    lbNibConvLocation: TLabel;
    lbNibConvLocation1: TLabel;
    lbVICELocation: TLabel;
    lbVICELocation1: TLabel;
    spFontSize: TSpinEdit;
    TabSheet1: TTabSheet;
    tbImport: TTabSheet;
    tbSettings: TPageControl;
    tbSetting: TTabSheet;
    tbVICE: TTabSheet;
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
  IniFluff.WriteBool('Start', 'OpenDatabase', cbStartOpenDB.Checked);
  IniFluff.WriteBool('Options', 'cbPETSCIITracks', cbPETSCIITracks.Checked);
  IniFluff.WriteBool('Options', 'IncludeT18T19', cbImportT18T19.Checked);
  IniFluff.WriteBool('Options', 'IncludeT18T53', cbImportT18T53.Checked);
  IniFluff.WriteBool('Options', 'IncludeT40', cbImportT40.Checked);
  IniFluff.WriteString('Options', 'FolderTemp', Dircheck(folderTemp.Directory));
  IniFluff.WriteString('DirMaster', 'Location', fileDirMaster.FileName);
  IniFluff.WriteInteger('Options', 'DirFontSize', spFontSize.Value);
  IniFluff.WriteString('Options', 'DirFont', ColorToString(clbFont.Selected));
  IniFluff.WriteString('Options', 'DirFontBackground', ColorToString(clbBackground.Selected));
  IniFluff.WriteString('CCS64', 'Location', fileCCS64.FileName);
  IniFluff.WriteString('Denise', 'Location', fileDenise.FileName);
  IniFluff.WriteString('Emu64', 'Location', fileEmu64.FileName);
  IniFluff.WriteString('Hoxs64', 'Location', fileHoxs64.FileName);
  IniFluff.WriteString('VICE', 'Location', fileVICE.FileName);
  IniFluff.WriteString('DirMaster', 'Location', fileDirMaster.FileName);
  Form1.LstBxDirectoryPETSCII.Font.Size := IniFluff.ReadInteger('Options', 'DirFontSize', 12);
  Form1.LstBxDirectoryPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  Form1.LstBxDirectoryPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  Form1.LstBAM.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  Form1.LstBAM.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  Form1.LstBoxSectors.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  Form1.LstBoxSectors.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  Form1.lstBoxPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  Form1.lstBoxPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  close;
end;

procedure TForm4.btCopyFontClick(Sender: TObject);
begin
  If fileexists(DirCheck(sAppPath)+'C64_Pro_Mono-STYLE.ttf') = false then
   begin
    Showmessage('Font not found: ' + chr(13) + PChar(DirCheck(sAppPath)+'C64_Pro_Mono-STYLE.ttf'));
   end
   else
    begin
     FileUtil.CopyFile(PChar(DirCheck(sAppPath)+'C64_Pro_Mono-STYLE.ttf'), SHGetFolderPathUTF8(20)+'C64_Pro_Mono-STYLE.ttf');
     Showmessage('Font successfully copied!' + chr(13) + 'Please restart the application to make the changes take effect...');
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
end;


end.

