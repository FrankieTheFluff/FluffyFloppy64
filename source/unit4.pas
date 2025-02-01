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
  EditBtn, ColorBox;

type

  { TForm4 }

  TForm4 = class(TForm)
    btOK: TButton;
    btCancel: TButton;
    btDefaultFont: TButton;
    btDefaultBackground: TButton;
    cbImportT18T19: TCheckBox;
    cbImportT18T53: TCheckBox;
    cbImportT40: TCheckBox;
    cbStartOpenDB: TCheckBox;
    cbPETSCIITracks: TCheckBox;
    clbFont: TColorBox;
    clbBackground: TColorBox;
    fileDenise: TFileNameEdit;
    fileHoxs64: TFileNameEdit;
    fileDirMaster: TFileNameEdit;
    folderTemp: TDirectoryEdit;
    fileCCS64: TFileNameEdit;
    fileNibConv: TFileNameEdit;
    Form4: TCheckBox;
    fileVICE: TFileNameEdit;
    grbImport: TGroupBox;
    grbStart: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblDirMaster: TLabel;
    lblCCS64Location: TLabel;
    lblDenise: TLabel;
    lbVICELocation: TLabel;
    lbNibConvLocation: TLabel;
    lbVICELocation1: TLabel;
    lbHoxs64Location: TLabel;
    TabSheet1: TTabSheet;
    tbImport: TTabSheet;
    tbSettings: TPageControl;
    tbSetting: TTabSheet;
    tbVICE: TTabSheet;
    procedure btCancelClick(Sender: TObject);
    procedure btDefaultBackgroundClick(Sender: TObject);
    procedure btDefaultFontClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
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
  IniFluff.WriteString('Options', 'DirFont', ColorToString(clbFont.Selected));
  IniFluff.WriteString('Options', 'DirFontBackground', ColorToString(clbBackground.Selected));
  IniFluff.WriteString('CCS64', 'Location', fileCCS64.FileName);
  IniFluff.WriteString('Denise', 'Location', fileDenise.FileName);
  IniFluff.WriteString('DirMaster', 'Location', fileDirMaster.FileName);
  IniFluff.WriteString('Hoxs64', 'Location', fileHoxs64.FileName);
  IniFluff.WriteString('VICE', 'Location', fileVICE.FileName);
  IniFluff.WriteString('NibConv', 'Location', fileNibConv.FileName);
  Form1.LstBxDirectoryPETSCII.Font.Color := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  Form1.LstBxDirectoryPETSCII.Color := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  close;
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

procedure TForm4.FormShow(Sender: TObject);
begin
  cbStartOpenDB.Checked := IniFluff.ReadBool('Start', 'OpenDatabase', true);
  cbPETSCIITracks.Checked := IniFluff.ReadBool('Options', 'cbPETSCIITracks', false);
  cbImportT18T19.Checked := IniFluff.ReadBool('Options', 'IncludeT18T19', false);
  cbImportT18T53.Checked := IniFluff.ReadBool('Options', 'IncludeT18T53', false);
  cbImportT40.Checked := IniFluff.ReadBool('Options', 'IncludeT40', false);
  folderTemp.Directory := IniFluff.ReadString('Options', 'FolderTemp', '');
  clbFont.Selected := StringToColor(IniFluff.ReadString('Options', 'DirFont', '$00F9B775'));
  clbBackground.Selected := StringToColor(IniFluff.ReadString('Options', 'DirFontBackground', '$00DB3F1E'));
  fileCCS64.FileName := IniFluff.ReadString('CCS64', 'Location', '');
  fileDenise.FileName := IniFluff.ReadString('Denise', 'Location', '');
  fileDirMaster.FileName := IniFluff.ReadString('DirMaster', 'Location', '');
  fileHoxs64.FileName := IniFluff.ReadString('Hoxs64', 'Location', '');
  fileVICE.FileName := IniFluff.ReadString('VICE', 'Location', '');
  fileNibConv.FileName := IniFluff.ReadString('NibConv', 'Location', '');
end;

end.

