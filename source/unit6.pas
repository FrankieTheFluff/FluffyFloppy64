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
Import/Sync
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
    btImport: TButton;
    cbImgD64: TCheckBox;
    cbImgD81: TCheckBox;
    cbImgD71: TCheckBox;
    cbImgPRG: TCheckBox;
    cbImgG64: TCheckBox;
    cbImgTAP: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    cbArcZIP: TCheckBox;
    DirImport: TDirectoryEdit;
    grImportProgress: TGroupBox;
    grImportFrom: TGroupBox;
    lblFileArc: TLabel;
    lblFileSel: TLabel;
    lblFileProgress: TLabel;
    lblFileImg: TLabel;
    lblImport1: TLabel;
    lblImportCount: TStaticText;
    lblImportCountErr: TStaticText;
    lblImportFoundImg: TStaticText;
    lblImportFoundArc: TStaticText;
    memoImport: TMemo;
    memoImportErr: TMemo;
    memoProgressBar: TProgressBar;
    lblImportFound: TStaticText;
    procedure btCloseClick(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure cbArcZIPChange(Sender: TObject);
    procedure cbImgD64Change(Sender: TObject);
    procedure cbImgD71Change(Sender: TObject);
    procedure cbImgD81Change(Sender: TObject);
    procedure cbImgG64Change(Sender: TObject);
    procedure cbImgPRGChange(Sender: TObject);
    procedure cbImgTAPChange(Sender: TObject);
    procedure DirImportChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Import;
    procedure Init_DirImport;
    procedure Init_str_FindAllImages(aFileFull: String; aPathArchive: String);
    Procedure Init_str_FindAllImagesArchive(aPathArchive: String);
    procedure Init_str_FindAllImages_Sync;
  private

  public

  end;

var
  frmImport: TfrmImport;
  str_FindAllImages : TStringList;
  str_FindAllFilesArchive, str_FindAllImagesArchive : TStringlist;
  Terminate : Boolean;
  ImageFileArray : TStringArray; // Needed to check if archive
  ImgAdd, ImageCount, ImageCountA, ImageCountA2, ImgCountErr : Integer;  // Images/archives

implementation

{$R *.lfm}

uses
  unit1, FFFunctions;

{ TfrmImport }

function Unpack_Archive(aArchiveName : String):boolean;
var
 tmpPath, tmpPathArc : String;
 answer : Integer;
begin
 result := false;
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
  tmpPath := DirCheck(IniFluff.ReadString('Options', 'FolderTemp', ''));
  tmpPathArc := '';

  // ZIP files known image files
  CreateDir(tmpPath + ExtractFileName(aArchiveName));   // Archive unzipped
  tmpPathArc := DirCheck(tmpPath + ExtractFileName(aArchiveName));
  UnPackFiles(aArchiveName, '', tmpPathArc); // : Integer;  // result=1 (success)
  FindAllFiles(str_FindAllImagesArchive, tmpPathArc, '*.d64;*.prg;*.g64;*.d71;*.d81', true);
  result := true;
End;

function Database_Ins_D64(aArchiveImage: String; aImageName: String; aImg : Integer): boolean;
  // aFileName      = Database (sl3)
  // aImageName     = C:\...\filename.d64 or .g64...

var
  bf, bf2, a, b, z : Integer;
  BA : TByteArr;
  sb, t18, t19 : String;
  DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageSize, ImageExt, ImgBlocksFree : String;
  arrSec: array[0..19] of Byte;
  t, x, Sector, SectorNext, SectorPos : Integer;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage.Contains('|') then
   begin
    FileFullA := StringReplace(aArchiveImage, DirCheck(IniFluff.ReadString('Options', 'FolderTemp',''))+ ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage.Contains('|') = false then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  // Images read - check if g64
  If Lowercase(ExtractFileExt(aImageName)) = '.g64' then
   begin
    BA := LoadByteArray(aImageName);  // g64
    ImageSize := ByteArrayToHexString(BA);
    BA := LoadByteArray(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ExtractFileName(ChangeFileExt(aImageName,'.d64'))); // Vom d64
    Init_ArrD64(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ExtractFileName(ChangeFileExt(aImageName,'.d64')));
   end
  else
   begin
    BA := LoadByteArray(aImageName);
    ImageSize := ByteArrayToHexString(BA);
    Init_ArrD64(aImageName);
   end;
  ImageExt := ExtractFileExt(aImageName);

  // Blocks free
  ImgBlocksFree := '';
  bf := 0; // blocksfree
  sb := Copy(arrD64[18,0],9,280+1); // 35x8=280
  a := 1;
  for z := 1 to 35 do
  begin
    bf2 := Hex2Dec(Copy(sb, a, 2));  // a beginning position 9
    If z <> 18 then bf := bf + bf2;
    a := a + 8;
   end;
  ImgBlocksFree := ImgBlocksFree + IntToStr(bf);
  // Blocks free ENDE

  // Directory title floppy
  sb := Copy(arrD64[18,0], 289, 32);
  DiskNameTxt := '';
  a := 1;
  for z := 1 to 16 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DiskNameTxt := DiskNameTxt + '@';
      '27':
         DiskNameTxt := DiskNameTxt + '''';    // Hochkomma !!
      'A0':
         DiskNameTxt := DiskNameTxt + '';      // Leer
      else
        DiskNameTxt := DiskNameTxt + HexToString(Copy(sb, a, 2));
     end;
    a := a + 2;
    end;
  // Directory title floppy ENDE

  // Directory DiskID // 20
  sb := Copy(arrD64[18,0], 325, 6);
  DiskIDTxt := '';
  a := 1;
  for z := 1 to 3 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DiskIDTxt := DiskIDTxt + '@';
      '27':
         DiskIDTxt := DiskIDTxt + '''';    // Hochkomma !!
      'A0':
         DiskIDTxt := DiskIDTxt + '';      // Leer
      else
        DiskIDTxt := DiskIDTxt + HexToString(Copy(sb, a, 2));
     end;
     a := a +2;
    end;
  // Directory DiskID // 20

  // Directory DOSType // 2A
  sb := Copy(arrD64[18,0], 331, 4);
  DosTypeTxt := '';
  a := 1;
  for z := 1 to 2 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DosTypeTxt := DosTypeTxt + '@';
      '27':
         DosTypeTxt := DosTypeTxt + '''';    // Hochkomma !!
      'A0':
         DosTypeTxt := DosTypeTxt + '';      // Leer
      else
        DosTypeTxt := DosTypeTxt + HexToString(Copy(sb, a, 2));
     end;
     a := a +2;
    end;
  // Directory DOSType // 2A

  // Read T18/T19 into Array
  t18 := '';
  t19 := '';
  for z := 0 to 18 do
    begin
     t18 := t18 + arrD64[18,z];
    end;
  for z := 0 to 18 do
    begin
     t19 := t19 + arrD64[19,z];
    end;

  if IniFluff.ReadBool('Options', 'IncludeT18T19', false) = true then
   begin
    Form1.AConnection.ExecuteDirect('insert into Tracks (idxTrks, T18, T19)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+  //IdxTrks;
    ' ''' + t18 + ''','+             //Track 18
    ' ''' + t19 + ''');');           //Track 19
   end;

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d64 ohne Punkt

  try
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' '''','+                                                                                  //DateLast
    ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + ImageExt + ''','+                                                                  //FileNameExt
    ' ''' + IntToStr(length(ImageSize) div 2) + ''','+                                         //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
    ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
    ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
    ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
    ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' '''','+                                                                                  //Info
    ' ''' + ImgBlocksFree + ''');');                                                           //BlocksFreeTxt
  except
   Form1.ATransaction.Active:=false;
   result := false;
   exit;
   // Check if file exists and Sync is active
   If (FileExists(aImageName) = true) then
    begin
     //showmessage(DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))));
    end;
   //Form1.AConnection.close;
  end;

  for z := 0 to 19 do // Init arrSec
   begin
    arrSec[z] := 0;
   end;

  aImageName := '';

   // Write table DirectoryTXT
   t := 0;
   Sector := 1;
   SectorNext := 0;
   Repeat
    SectorPos := 0;    // 18.01 1st position of sector 01
    if Hex2Dec(Copy(arrD64[18,Sector], 1, 2)) = 00 then t := 1; // Track 18  "00"
    if Hex2Dec(Copy(arrD64[18,Sector], 3, 2)) = 01 then t := 1; // Track 18  "01"  (normal 4)
    if Hex2Dec(Copy(arrD64[18,Sector], 3, 2)) = 255 then t := 1; // Track 18 "FF"
    if (Hex2Dec(Copy(arrD64[18,Sector], 3, 2)) > 18) AND (Hex2Dec(Copy(arrD64[18,Sector], 3, 2)) <> 255) then t := 1; // bspw. "52"
    If SectorNext = 18 then t := 1;// 18 runtimes per track

    For x := 1 to 8 do // 8 entries/sector
     Begin
      // FileTypeTXT
      sb := Copy(arrD64[18,Sector], SectorPos + 5, 2);    // e.g. ‘82’ = PRG
      FileTypeTXT := ' ??? ';
      if sb = '00' then FileTypeTXT := '*DEL ';
      if sb = '01' then FileTypeTXT := '*SEQ ';
      if sb = '02' then FileTypeTXT := '*PRG ';
      if sb = '03' then FileTypeTXT := '*USR ';
      if sb = '04' then FileTypeTXT := '*REL ';
      if sb = '40' then FileTypeTXT := '*DEL<';
      if sb = '41' then FileTypeTXT := '*SEQ<';
      if sb = '42' then FileTypeTXT := '*PRG<';
      if sb = '43' then FileTypeTXT := '*USR<';
      if sb = '44' then FileTypeTXT := '*REL<';
      if sb = '80' then FileTypeTXT := ' DEL ';
      if sb = '81' then FileTypeTXT := ' SEQ ';
      if sb = '82' then FileTypeTXT := ' PRG ';
      if sb = '83' then FileTypeTXT := ' USR ';
      if sb = '84' then FileTypeTXT := ' REL ';
      if sb = 'C0' then FileTypeTXT := ' DEL<';
      if sb = 'C1' then FileTypeTXT := ' SEQ<';
      if sb = 'C2' then FileTypeTXT := ' PRG<';
      if sb = 'C3' then FileTypeTXT := ' USR<';
      if sb = 'C4' then FileTypeTXT := ' REL<';
      // FileNameTXT
      sb := Copy(arrD64[18,Sector], SectorPos + 11, 32);  // 16 character filename (in PETASCII, padded with $A0)
      a := 1;
      FileNameTXT := '';
      for z := 1 to 16 do
       begin
          case Copy(sb, a, 2) of
           '00':
              FileNameTXT := FileNameTXT + '@';
           '27':
              FileNameTXT := FileNameTXT + '''';    // Hochkomma !!
           'A0':
              FileNameTXT := FileNameTXT + '';      // Leer
           else
             FileNameTXT := FileNameTXT + HexToString(Copy(sb, a, 2));
          end;
        a := a + 2;
       end;

       // FileSizeTXT (blocks)
       sb := Copy(arrD64[18,Sector], SectorPos + 61, 4);   // 1E-1F: File size in sectors, low/high byte  order  ($1E+$1F*256).
       a := 1;
       b := 0;
       for z := 1 to 2 do
        begin
         b := b + Hex2Dec(Copy(sb, a, 2));
         a := a + 2;
        end;
       SectorPos := SectorPos + 64; // 20-3F: Second dir entry - 40-5F: Third dir entry
       FileSizeTxt := IntToStr(b);
       Form1.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
       ' values('+
       ' ''' + IntToStr(aImg) + ''','+         //IdxTXT;
       ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
       ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
       ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
      End;
     // Next sector
     Sector := Hex2Dec(Copy(arrD64[18,Sector], 3, 2)); // e.g. “04”
     // circular ausschließen
     for z := 0 to 19 do
      begin
       if arrSec[z] <> 0 then
        begin
         if arrSec[z] = Sector then t := 1;
        end;
      end;
     SectorNext := SectorNext + 1; // Max 18 Durchgänge dann t := 1 // Track 19 howto?
     arrSec[SectorNext] := Sector;
    Until t = 1;
  // Read T18/T19 into Array ENDE
  Form1.ATransaction.Commit;
  // Write dataset END
  Form1.ATransaction.Active:=false;
  result := true;
end;

function Database_Ins_D71(aArchiveImage: String; aImageName: String; aImg : Integer): boolean;
  // aFileName      = Database (sl3)
  // aImageName     = C:\...\filename.d71
var
  bf, bf2, a, b, z : Integer;
  BA : TByteArr;
  sb, t18, t19, t53 : String;
  DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageSize, ImageExt, ImgBlocksFree : String;
  arrSec: array[0..19] of Byte;
  t, x, Track, Sector, TrackNext, SectorNext, SectorPos, SectorCount, repeated : Integer;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

  BA := LoadByteArray(aImageName);
  ImageSize := ByteArrayToHexString(BA);
  Init_ArrD71(aImageName);
  ImageExt := ExtractFileExt(aImageName);

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
  // Blocks free ENDE

  // Directory title floppy
  sb := Copy(arrD71[18,0], 289, 32);
  DiskNameTxt := '';
  a := 1;
  for z := 1 to 16 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DiskNameTxt := DiskNameTxt + '@';
      '27':
         DiskNameTxt := DiskNameTxt + '''';    // Hochkomma !!
      'A0':
         DiskNameTxt := DiskNameTxt + '';      // Leer
      else
        DiskNameTxt := DiskNameTxt + HexToString(Copy(sb, a, 2));
     end;
    a := a + 2;
    end;
  // Directory title floppy ENDE

  // Directory DiskID // 20
  sb := Copy(arrD71[18,0], 325, 6);
  DiskIDTxt := '';
  a := 1;
  for z := 1 to 3 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DiskIDTxt := DiskIDTxt + '@';
      '27':
         DiskIDTxt := DiskIDTxt + '''';    // Hochkomma !!
      'A0':
         DiskIDTxt := DiskIDTxt + '';      // Leer
      else
        DiskIDTxt := DiskIDTxt + HexToString(Copy(sb, a, 2));
     end;
     a := a +2;
    end;
  // Directory DiskID // 20

  // Directory DOSType // 2A
  sb := Copy(arrD71[18,0], 331, 4);
  DosTypeTxt := '';
  a := 1;
  for z := 1 to 2 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DosTypeTxt := DosTypeTxt + '@';
      '27':
         DosTypeTxt := DosTypeTxt + '''';    // Hochkomma !!
      'A0':
         DosTypeTxt := DosTypeTxt + '';      // Leer
      else
        DosTypeTxt := DosTypeTxt + HexToString(Copy(sb, a, 2));
     end;
     a := a +2;
    end;
  // Directory DOSType // 2A

  // Read T18/T19/T53 into Array
  t18 := '';
  t19 := '';
  t53 := '';
  for z := 0 to 18 do
    begin
     t18 := t18 + arrD71[18,z];
    end;
  for z := 0 to 18 do
    begin
     t19 := t19 + arrD71[19,z];
    end;
  for z := 0 to 18 do
    begin
     t53 := t53 + arrD71[53,z];
    end;

  if IniFluff.ReadBool('Options', 'IncludeT18T53', false) = true then
   begin
    Form1.AConnection.ExecuteDirect('insert into Tracks (idxTrks, T18, T53)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+  //IdxTrks;
    ' ''' + t18 + ''','+             //Track 18
    ' ''' + t53 + ''');');           //Track 53
   end;

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage.Contains('|') then
   begin
    FileFullA := StringReplace(aArchiveImage, DirCheck(IniFluff.ReadString('Options', 'FolderTemp',''))+ ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage.Contains('|') = false then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d71 ohne Punkt

  try
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
    ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + ImageExt + ''','+                                                                  //FileNameExt
    ' ''' + IntToStr(length(ImageSize) div 2) + ''','+                                         //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
    ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
    ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
    ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
    ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' '''','+                                                                                  //Info
    ' ''' + ImgBlocksFree + ''');');                                                           //BlocksFreeTxt
  except
   Form1.ATransaction.Active:=false;
   result := false;
   exit;
   // Check if file exists and Sync is active
   If (FileExists(aImageName) = true) then
    begin
     //showmessage(DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))));
    end;
  end;

  for z := 0 to 19 do // Init arrSec
   begin
    arrSec[z] := 0;
   end;

  aImageName := '';

   // Write table DirectoryTXT
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
      sb := Copy(arrD71[track,Sector], SectorPos + 5, 2);    // e.g. ‘82’ = PRG
      FileTypeTXT := ' ??? ';
      if sb = '00' then FileTypeTXT := '*DEL ';
      if sb = '01' then FileTypeTXT := '*SEQ ';
      if sb = '02' then FileTypeTXT := '*PRG ';
      if sb = '03' then FileTypeTXT := '*USR ';
      if sb = '04' then FileTypeTXT := '*REL ';
      if sb = '40' then FileTypeTXT := '*DEL<';
      if sb = '41' then FileTypeTXT := '*SEQ<';
      if sb = '42' then FileTypeTXT := '*PRG<';
      if sb = '43' then FileTypeTXT := '*USR<';
      if sb = '44' then FileTypeTXT := '*REL<';
      if sb = '80' then FileTypeTXT := ' DEL ';
      if sb = '81' then FileTypeTXT := ' SEQ ';
      if sb = '82' then FileTypeTXT := ' PRG ';
      if sb = '83' then FileTypeTXT := ' USR ';
      if sb = '84' then FileTypeTXT := ' REL ';
      if sb = 'C0' then FileTypeTXT := ' DEL<';
      if sb = 'C1' then FileTypeTXT := ' SEQ<';
      if sb = 'C2' then FileTypeTXT := ' PRG<';
      if sb = 'C3' then FileTypeTXT := ' USR<';
      if sb = 'C4' then FileTypeTXT := ' REL<';
      // FileNameTXT
      sb := Copy(arrD71[track,Sector], SectorPos + 11, 32);  // 16 character filename (in PETASCII, padded with $A0)
      a := 1;
      FileNameTXT := '';
      for z := 1 to 16 do
       begin
          case Copy(sb, a, 2) of
           '00':
              FileNameTXT := FileNameTXT + '@';
           '27':
              FileNameTXT := FileNameTXT + '''';    // Hochkomma !!
           'A0':
              FileNameTXT := FileNameTXT + '';      // Leer
           else
             FileNameTXT := FileNameTXT + HexToString(Copy(sb, a, 2));
          end;
        a := a + 2;
       end;

       // FileSizeTXT (blocks)
       sb := Copy(arrD71[track,Sector], SectorPos + 61, 4);   // 1E-1F: File size in sectors, low/high byte  order  ($1E+$1F*256).
       a := 1;
       b := 0;
       for z := 1 to 2 do
        begin
         b := b + Hex2Dec(Copy(sb, a, 2));
         a := a + 2;
        end;
       SectorPos := SectorPos + 64; // 20-3F: Second dir entry - 40-5F: Third dir entry
       FileSizeTxt := IntToStr(b);

       Form1.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
       ' values('+
       ' ''' + IntToStr(aImg) + ''','+         //IdxTXT;
       ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
       ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
       ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
      End;

     // Next sector
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
  Until t = 1;

  Form1.ATransaction.Commit;
  Form1.ATransaction.Active:=false;
  result := true;
end;


Function Database_Ins_D81(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  sb, t40, ImageSize, FileFullA, FilePathA, sp, FileArchType : String;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageExt, FileSizeTxt, FileNameTXT, FileTypeTXT : String;
  a, b, z, bf, bf2, t, x, track, sector, sectorpos, TrackNext, SectorNext : Integer;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

  Init_ArrD81(aImageName);   // Image to array
  BA := LoadByteArray(aImageName);
  ImageSize := ByteArrayToHexString(BA);
  ImageExt := ExtractFileExt(aImageName);

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
   // Blocks free ENDE

  // Directory title floppy
  a := 1;
  sb := Copy(arrD81[40,0],a+8,32);
  DiskNameTxt := '';
  a := 1;
  for z := 1 to 16 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DiskNameTxt := DiskNameTxt + '@';
      '27':
         DiskNameTxt := DiskNameTxt + '''';    // Hochkomma !!
      'A0':
         DiskNameTxt := DiskNameTxt + '';      // Leer
      else
        DiskNameTxt := DiskNameTxt + HexToString(Copy(sb, a, 2));
     end;
    a := a + 2;
    end;
  // Directory title floppy ENDE

  // Directory DiskID
  sb := Copy(arrD81[40,0],1+36,6);
  DiskIDTxt := '';
  a := 1;
  for z := 1 to 3 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DiskIDTxt := DiskIDTxt + '@';
      '27':
         DiskIDTxt := DiskIDTxt + '''';    // Hochkomma !!
      'A0':
         DiskIDTxt := DiskIDTxt + '';      // Leer
      else
         DiskIDTxt := DiskIDTxt + HexToString(Copy(sb, a, 2));
     end;
     a := a + 2;
    end;
  // Directory DiskID

  // Directory DOSType
  sb := Copy(arrD81[40,0],1+42,4);
  DosTypeTxt := '';
  a := 1;
  for z := 1 to 2 do
    begin
     case Copy(sb, a, 2) of
      '00':
         DosTypeTxt := DosTypeTxt + '@';
      '27':
         DosTypeTxt := DosTypeTxt + '''';    // Hochkomma !!
      'A0':
         DosTypeTxt := DosTypeTxt + '';      // Leer
      else
        DosTypeTxt := DosTypeTxt + HexToString(Copy(sb, a, 2));
     end;
     a := a + 2;
    end;

  // Read T40 into Array
  if IniFluff.ReadBool('Options', 'IncludeT40', false) = true then
   begin
    t40 := '';
    for z := 0 to 39 do
      begin
       t40 := t40 + Copy(arrD81[40,z],1,512);
      end;
    Form1.AConnection.ExecuteDirect('insert into Tracks (idxTrks, T40)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+  //IdxTrks;
    ' ''' + t40 + ''');');           //Track 40
    t40 := '';
   end;

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage.Contains('|') then
   begin
    FileFullA := StringReplace(aArchiveImage, DirCheck(IniFluff.ReadString('Options', 'FolderTemp',''))+ ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage.Contains('|') = false then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d81 ohne Punkt

  // --------------------------
  Try
  Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
   ' values('+
   ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
   ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
   ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
   ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
   ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
   ' ''' + ImageExt + ''','+                                                                  //FileNameExt
   ' ''' + IntToStr(length(ImageSize) div 2) + ''','+                                         //FileSizeImg
   ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
   ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
   ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
   ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
   ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
   ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
   ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
   ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
   ' '''','+                                                                                  //Tags
   ' '''','+                                                                                  //Info
   ' ''' + blocksfree + ''');');                                                              //BlocksFreeTxt
  except
   Form1.ATransaction.Active:=false;
   result := false;
   exit;
  end;

  // Write table DirectoryTXT
  t := 0;
  track := 40;
  Sector := 3; // Hex2Dec(Copy(sectors_t40[1], 3, 2));  // bspw. "01" - “12 01”
  SectorNext := 0;
  Repeat
   SectorPos := 0;    // 40.01 1st position of sector 01
   if Track = 00 then t := 1;
   if Sector = 255 then t := 1;
   For x := 1 to 8 do // 8 entries/sector
    Begin
     // FileTypeTXT
     sb := Copy(arrD81[track,sector], SectorPos + 5, 2);    // e.g. ‘82’ = PRG
     FileTypeTXT := ' ??? ';
     if sb = '00' then FileTypeTXT := '*DEL ';
     if sb = '01' then FileTypeTXT := '*SEQ ';
     if sb = '02' then FileTypeTXT := '*PRG ';
     if sb = '03' then FileTypeTXT := '*USR ';
     if sb = '04' then FileTypeTXT := '*REL ';
     if sb = '40' then FileTypeTXT := '*DEL<';
     if sb = '41' then FileTypeTXT := '*SEQ<';
     if sb = '42' then FileTypeTXT := '*PRG<';
     if sb = '43' then FileTypeTXT := '*USR<';
     if sb = '44' then FileTypeTXT := '*REL<';
     if sb = '80' then FileTypeTXT := ' DEL ';
     if sb = '81' then FileTypeTXT := ' SEQ ';
     if sb = '82' then FileTypeTXT := ' PRG ';
     if sb = '83' then FileTypeTXT := ' USR ';
     if sb = '84' then FileTypeTXT := ' REL ';
     if sb = 'C0' then FileTypeTXT := ' DEL<';
     if sb = 'C1' then FileTypeTXT := ' SEQ<';
     if sb = 'C2' then FileTypeTXT := ' PRG<';
     if sb = 'C3' then FileTypeTXT := ' USR<';
     if sb = 'C4' then FileTypeTXT := ' REL<';
     // FileNameTXT
     sb := Copy(arrD81[track,sector], SectorPos + 11, 32);  // 16 character filename (in PETASCII, padded with $A0)
     a := 1;
     FileNameTXT := '';
     for z := 1 to 16 do
      begin
         case Copy(sb, a, 2) of
          '00':
             FileNameTXT := FileNameTXT + '@';
          '27':
             FileNameTXT := FileNameTXT + '''';    // Hochkomma !!
          'A0':
             FileNameTXT := FileNameTXT + '';      // Leer
          else
            FileNameTXT := FileNameTXT + HexToString(Copy(sb, a, 2));
         end;
       a := a + 2;
      end;
      // FileSizeTXT (blocks)
      sb := Copy(arrD81[track,sector], SectorPos + 61, 4);   // 1E-1F: File size in sectors, low/high byte  order  ($1E+$1F*256).
      a := 1;
      b := 0;
      for z := 1 to 2 do
       begin
        b := b + Hex2Dec(Copy(sb, a, 2));
        a := a + 2;
       end;
      SectorPos := SectorPos + 64; // 20-3F: Second dir entry - 40-5F: Third dir entry
      FileSizeTxt := IntToStr(b);
      Form1.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
      ' values('+
      ' ''' + IntToStr(aImg) + ''','+         //IdxTXT;
      ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
      ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
      ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
     End;
    // Next track/sector
    TrackNext := Hex2Dec(Copy(arrD81[track,sector], 1, 2)); // 40
    SectorNext := Hex2Dec(Copy(arrD81[track,sector], 3, 2)); // e.g. “04”
    Track := TrackNext;
    Sector := SectorNext;
   Until t = 1;
 // Read T40 into Array ENDE

  Form1.ATransaction.Commit;
  // Write dataset END
  Form1.ATransaction.Active:=false;
  result := true;
end;

Function Database_Ins_PRG(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  s, Img_FileExt : String;
  fstream : TFileStream;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt : String;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

  // PRG
  BA := LoadByteArray('"' + aImageName + '"');
  s := ByteArrayToHexString(BA);
  Img_FileExt := ExtractFileExt(aImageName);
  if (length(Img_FileExt)>0) and (Img_FileExt[1]='.') then delete(Img_FileExt,1,1); // d64 ohne Punkt
  DiskNameTxt := '';
  DiskIDTxt := '';
  DosTypeTxt := '';
  blocksfree := IntToStr(length(s) div 2);

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage.Contains('|') then
   begin
    FileFullA := StringReplace(aArchiveImage, DirCheck(IniFluff.ReadString('Options', 'FolderTemp',''))+ ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage.Contains('|') = false then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  Try
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
    ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + Img_FileExt + ''','+                                                               //FileNameExt
    ' ''' + IntToStr(FileSize(aImageName)) + ''','+                                            //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
    ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
    ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
    ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
    ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' '''','+                                                                                  //Info
    ' ''' + blocksfree + ''');');                                                              //BlocksFreeTxt
  except
   Form1.ATransaction.Active:=false;
   result := false;
   exit;
  end;

  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  FileSizeTxt := IntToStr(fstream.Size div 252);
  FileNameTXT := ExtractFileName(aImageName);
  FileTypeTXT := 'PRG';
  Form1.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
  ' values('+
  ' ''' + IntToStr(aImg) + ''','+         //idxTxt (Index manuell)
  ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
  ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
  ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
  fstream.Free;
  Form1.ATransaction.Commit;
  Form1.ATransaction.Active:=false;
  result := true;
end;

Function Database_Ins_TAP(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  s, Img_FileExt : String;
  fstream : TFileStream;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt : String;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

  // TAP
  BA := LoadByteArray('"' + aImageName + '"');
  s := ByteArrayToHexString(BA);
  Img_FileExt := ExtractFileExt(aImageName);
  if (length(Img_FileExt)>0) and (Img_FileExt[1]='.') then delete(Img_FileExt,1,1); // d64 ohne Punkt
  DiskNameTxt := '';
  DiskIDTxt := '';
  DosTypeTxt := '';
  blocksfree := IntToStr(length(s) div 2);

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage.Contains('|') then
   begin
    FileFullA := StringReplace(aArchiveImage, DirCheck(IniFluff.ReadString('Options', 'FolderTemp',''))+ ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage.Contains('|') = false then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  Try
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
    ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + Img_FileExt + ''','+                                                               //FileNameExt
    ' ''' + IntToStr(FileSize(aImageName)) + ''','+                                            //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
    ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
    ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
    ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
    ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' '''','+                                                                                  //Info
    ' ''' + blocksfree + ''');');                                                              //BlocksFreeTxt
  except
   Form1.ATransaction.Active:=false;
   result := false;
   exit;
  end;

  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  FileSizeTxt := IntToStr(fstream.Size div 252);
  FileNameTXT := ExtractFileName(aImageName);
  FileTypeTXT := 'TAP';
  Form1.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
  ' values('+
  ' ''' + IntToStr(aImg) + ''','+         //idxTxt (Index manuell)
  ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
  ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
  ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
  fstream.Free;
  Form1.ATransaction.Commit;
  Form1.ATransaction.Active:=false;
  result := true;
end;


procedure TfrmImport.Import;
var
  fstream : TFileStream;
  ImageFile, ImageFileA : String;
  ImgCount, img, dbMod : Integer;
begin
  Form1.cbDBFilePath.ItemIndex:=0;
  Form1.cbDBFileNameExt.ItemIndex:=0;
  Form1.DBFilter;
  Form1.LstBxDirectoryPETSCII.Clear;
  Form1.LstBAM.Clear;
  Form1.lstBoxSectors.Clear;
  Form1.lstBoxPETSCII.Clear;
  Form1.LstBxDirectoryTXT.Clear;
  Form1.MemoBAMHint.Clear;
  Form1.StatusBar1.Panels[1].Text:= 'Importing...';
  Form1.Statusbar1.Panels[2].Text := '';
  Form1.Statusbar1.Panels[3].Text := '';
  Form1.Statusbar1.Panels[4].Text := '';
  Form1.Statusbar1.Refresh;

  memoImport.Clear;
  ImgCount := 0;
  lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';

 // Images
 if str_FindAllImages.Count > 0 then
  begin
   Form1.SQLQueryDir.Last;
   ImgCount := Form1.SQLQueryDir.FieldByName('idxImg').AsInteger;  // Check idxImg no duplicates
   Form1.SQLQueryDir.Active:=false;

   // accept only valid files to stringlist str_Images
   for img := 0 to str_FindAllImages.count-1 do
    begin
     try
     Application.ProcessMessages;
     memoProgressBar.Position := img+1;
     ImageFile := str_FindAllImages.Strings[img]; // e.g. ....d64

     // Split, check if image is in archive
     If ImageFile.Contains('|')then
      begin
       ImageFileArray := str_FindAllImages.Strings[img].Split('|');
       ImageFileA := str_FindAllImages.Strings[img];  // Archive ZIP | Image location inside of archive
       ImageFile  := ImageFileArray[1];               // image location in tmp folder
      end
     else
      begin
       ImageFileA := '';           // Archive ZIP
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
           memoImportErr.Lines.Add('No import (already exists): ' + ImageFile);
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
            memoImportErr.Lines.Add('No import (already exists): ' + ImageFile);
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

     //D64 - filesize check if valid file
     if cbImgD64.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.d64' then
        begin
         fstream:= TFileStream.Create(ImageFile, fmShareCompat or fmOpenRead);
         if  (fstream.Size = 174848) or  (fstream.Size = 175531) or (fstream.Size = 196608) or  (fstream.Size = 197376) or (fstream.Size = 205312) or  (fstream.Size = 206114) or  (fstream.Size = 210483) then
          begin
           ImgCount := ImgCount + 1;
           fstream.Free;
           if Database_Ins_D64(ImageFileA, ImageFile, ImgCount) = false then
             begin
              ImgCount := ImgCount - 1;
              ImgCountErr := ImgCountErr + 1;
              lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
              memoImportErr.Lines.Add('No import (already exists): ' + ImageFile);
             end
           else
             begin
              ImgAdd := ImgAdd + 1;
              lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
              memoImport.Lines.Clear;
              memoImport.Lines.Add(ImageFile);
             end;
          end
         else
         begin
          ImgCountErr := ImgCountErr + 1;
          lblImportCountErr.Caption := IntToStr(ImgCountErr);
          memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + ImageFile);
          fstream.Free;
         end;
        end;
      end;

     //D71 - filesize check if valid file
     if cbImgD71.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.d71' then
        begin
         fstream:= TFileStream.Create(ImageFile, fmShareCompat or fmOpenRead);
         if  (fstream.Size = 349696) or (fstream.Size = 351062) then
          begin
           ImgCount := ImgCount + 1;
           fstream.Free;
           if Database_Ins_D71(ImageFileA, ImageFile, ImgCount) = false then
             begin
              ImgCount := ImgCount - 1;
              ImgCountErr := ImgCountErr + 1;
              lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
              memoImportErr.Lines.Add('No import (already exists): ' + ImageFile);
             end
           else
             begin
              ImgAdd := ImgAdd + 1;
              lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
              memoImport.Lines.Clear;
              memoImport.Lines.Add(ImageFile);
             end;
          end
         else
          begin
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + ImageFile);
           fstream.Free;
          end;
        end;
      end;

     //D81 - filesize check if valid file
     if cbImgD81.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.d81' then
        begin
         fstream:= TFileStream.Create(ImageFile, fmShareCompat or fmOpenRead);
         if  (fstream.Size = 819200) or (fstream.Size = 822400) then
          begin
           ImgCount := ImgCount + 1;
           fstream.Free;
           if Database_Ins_D81(ImageFileA, ImageFile, ImgCount) = false then
            begin
             ImgCount := ImgCount - 1;
             ImgCountErr := ImgCountErr + 1;
             lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
             memoImportErr.Lines.Add('No import (already exists): ' + ImageFile);
            end
           else
             begin
              ImgAdd := ImgAdd + 1;
              lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
              memoImport.Lines.Clear;
              memoImport.Lines.Add(ImageFile);
             end;
          end
         else
          begin
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + ImageFile);
           fstream.Free;
          end;
        end;
      end;

     // G64
     if cbImgG64.Checked = true then
      begin
       if lowercase(ExtractFileExt(ImageFile)) = '.g64' then
        begin
         btClose.Enabled:=false;
         Form1.Convert_G64(ImageFile);
         // Checking if convert failed
         If filesize(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ChangeFileExt(ExtractFileName(ImageFile),'.d64')) = 0 then
          begin
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add('Convert g64 to d64 failed - not imported: ' + ImageFile);
          end  // end checking if convert failed
         else
          begin
          fstream:= TFileStream.Create(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ChangeFileExt(ExtractFileName(ImageFile),'.d64'), fmShareCompat or fmOpenRead);
          if  (fstream.Size = 174848) or  (fstream.Size = 175531) or (fstream.Size = 196608) or  (fstream.Size = 197376) or (fstream.Size = 205312) or  (fstream.Size = 206114) or  (fstream.Size = 210483) then
           begin
            ImgCount := ImgCount + 1;
            fstream.Free;
            if Database_Ins_D64(ImageFileA, ImageFile, ImgCount) = false then
             begin
              ImgCount := ImgCount - 1;
              ImgCountErr := ImgCountErr + 1;
              lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
              memoImportErr.Lines.Add('No import (already exists): ' + ImageFile);
             end
            else
              begin
               ImgAdd := ImgAdd + 1;
               lblImportCount.Caption:=IntTostr(ImgAdd) + ' ';
               memoImport.Lines.Clear;
               memoImport.Lines.Add(ImageFile);
              end;
           end
          else
           begin
            If fstream.Size <> 0 then fstream.Free; // If Convert fails
            ImgCount := ImgCount - 1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + ImageFile);
            fstream.Free;
           end;
           end;
          DeleteFileUTF8(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ChangeFileExt(ExtractFileName(ImageFile),'.d64'));
         end;
      end;  // Ende g64

     // Commit every e.g. 50 entries (In case of a application crash to avoid database goes corrupt)
     dbMod := IniFluff.ReadInteger('FluffyFloppy64', 'DBModulo', 50); // Default 50
     if ImgAdd >= dbMod then
      begin
       if (ImgAdd mod dbMod = 0) then
        begin
         If Dev_Mode = true then Showmessage('[Dev_Mode] - DBModula: ' + IntToStr(ImgAdd));
         if Form1.ATransaction.Active then
          begin
           Form1.ATransaction.Commit;
          end;
        end;
      end;
     except
      on E: Exception do memoImportErr.Lines.Add(E.Message + '- File: ' + ImageFile);
     end; // accept only valid files to import

    // Cancel
    if terminate = true then
     begin
      memoImport.Lines.Add('Import cancelled!');
      if Form1.ATransaction.Active then
       begin
        Form1.ATransaction.Commit;
       end;
      lblImportFound.Caption:= '0 ';
      memoImport.Lines.Add('Clearing...');
      str_FindAllImages.Clear;
      Form1.SQLQueryDir.SQL.Clear;
      Form1.SQLQueryDir.SQL.Add('Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, DiskIDTxt, DOSTypeTxt, FilePath, Favourite, Corrupt, Tags, Info from FileImage');
      Form1.SQLQueryDir.Active:=true;
      memoImport.Lines.Add('Done.');
      Form1.DBGridDir_ReadEntry(Form1.SQLQueryDir.FieldByName('FileFull').Text);
      Form1.Init_FilePath;
      btImport.Caption := 'Import';
      btImport.Enabled := false;
      btClose.Enabled :=true;
      btClose.SetFocus;
      memoProgressBar.Position := ImageCount + ImageCountA2; // 100% progressbar
      DeleteDirectory(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')),true);
      exit;
     end;

   end;  // accept only valid files

   memoProgressBar.Position := ImageCount + ImageCountA2; // 100% progressbar
  end;  // > 0

  btImport.Caption := 'Import';
  btImport.Enabled := false;
  btClose.Enabled:=true;
  btClose.SetFocus;
end;

procedure TfrmImport.btCloseClick(Sender: TObject);
begin
 Form1.DBFilter;
 close;
end;

procedure TfrmImport.btImportClick(Sender: TObject);
var
  answer, img, i, j, start, group : integer;
  GroupImg : TStringList;
  dirTmp : String;
begin
 if (DirImport.Directory = '') or (DirectoryExists(DirImport.Directory) = false) then
  begin
   answer := MessageDlg('Directory not found!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      btClose.Enabled:=true;
      exit;
     end;
  end;

 // Check if temp directory exists
 dirTmp := DirCheck(IniFluff.ReadString('Options', 'FolderTemp', ''));
 if (dirTmp = '') or (DirectoryExists(dirTmp) = false) then
 begin
  answer := MessageDlg('Temporary directory not found! Please check settings...',mtWarning, [mbOK], 0);
   if answer = mrOk then
    begin
     btClose.Enabled:=true;
     exit;
    end;
 end;

 //Check if nibtools available?
 If cbImgG64.Checked = true then
  begin
   If FileExists(DirCheck(IniFluff.ReadString('NibConv', 'Location', ''))) = false then
    begin
     answer := MessageDlg('G64 cannot be imported because NibConv not found! Please check settings first or deselect G64...',mtWarning, [mbOK], 0);
      if answer = mrOk then
       begin
        btClose.Enabled:=true;
        exit;
       end;
    end;
  end;

 // Stop import
 if btImport.Caption = 'Cancel' then
  begin
   Terminate := true;
    answer := MessageDlg('Import cancelled!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      DirImport.Text := '';
      memoProgressbar.Position:=1;
      btImport.Caption:= 'Import';
      btClose.Enabled:=true;
      Form1.DBGridDir.DataSource := Form1.DataSourceDir;
      exit;
     end;
   exit;
  end;

 // Start import
 Terminate := false;
 btImport.Caption:= 'Cancel';
 Form1.DBGridDir.DataSource := nil;

 // Import images (D64...)
 if str_FindAllImages.Count > 0 then
  begin
   Import;
  end;

 // Import archives (ZIP)
 if str_FindAllFilesArchive.Count > 0 then  // After "select directory": "Init_str_FindAllFilesArchive" collected ZIPs
  begin
   for img := 0 to str_FindAllFilesArchive.Count-1 do
    begin
     If Unpack_Archive(str_FindAllFilesArchive[img]) = true then  //  one archive after the other...
      begin
       lblImportfound.Caption := ' Collecting archive files... Please wait.';
       Application.ProcessMessages;
       Init_str_FindAllImages(IniFluff.ReadString('Options', 'FolderTemp', ''),str_FindAllFilesArchive[img]);
       Import;  // Import directory of the image
      end
     else memoImportErr.Lines.Add('Unable to unpack "' + str_FindAllFilesArchive[img] + '"');
     DeleteDirectory(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')),true); // Delete unpacked directory
    end;
  end;

  str_FindAllFilesArchive.Clear;

  memoImport.Lines.Add('Import finished! (duplicates ignored)');
  memoImport.Lines.Add('Clearing...');
  str_FindAllImages.Clear;
  Form1.SQLQueryDir.SQL.Clear;
  Form1.SQLQueryDir.SQL.Add('Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, DiskIDTxt, DOSTypeTxt, FilePath, Favourite, Corrupt, Tags, Info from FileImage');
  Form1.SQLQueryDir.Active:=true;
  memoImport.Lines.Add('Done.');
  Form1.DBGridDir.DataSource := Form1.DataSourceDir;
  Form1.DBGridDir_ReadEntry(Form1.SQLQueryDir.FieldByName('FileFull').Text);
  Form1.Init_FilePath;

end;

procedure TfrmImport.cbArcZIPChange(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.cbImgD64Change(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.cbImgD71Change(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.cbImgD81Change(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.cbImgG64Change(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.cbImgPRGChange(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.cbImgTAPChange(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.DirImportChange(Sender: TObject);
begin
 Init_DirImport;
end;

procedure TfrmImport.Init_DirImport;
begin
 ImgAdd := 0;
 ImageCountA2 := 0;
 memoImport.Clear;
 memoImportErr.Clear;
 ImgCountErr := 0;
 lblImportFoundImg.Caption := '0 ';
 lblImportFoundArc.Caption := '0 ';
 lblImportCount.Caption := '0 ';
 lblImportCountErr.Caption := '0 ';
 btImport.Caption:= 'Import';
 btImport.Enabled := false;
 Terminate := false;

 If DirImport.Directory = '' then exit;
  // Images
 Init_str_FindAllImages(DirImport.Directory,'');
 // Archives
 If cbArcZIP.Checked = true then Init_str_FindAllImagesArchive(DirImport.Directory);

 memoProgressbar.Position:=1;
 memoProgressBar.Max := ImageCount;
 If str_FindAllImages.count > 0 then   btImport.Enabled := true;
 If str_FindAllFilesArchive.count > 0 then btImport.Enabled := true;
 btClose.SetFocus;

end;

procedure TfrmImport.Init_str_FindAllImages(aFileFull : String; aPathArchive : String);
var
  str_FindAllImagesTmp : TStringList;
  i : integer;
begin
 // aFileFull = path to the image e.g. also \temp
 // aPathArchive = path to the archive also ...\temp123.zip
 // ImageCountA2 = found images in archive

 str_FindAllImages.Clear;
 str_FindAllImagesTmp := TStringList.Create;
 lblImportfound.Caption := ' Collecting files... Please wait.';

 Application.ProcessMessages;
 str_FindAllImagesTmp.Clear;

 // Known images files without archives
 FindAllFiles(str_FindAllImagesTmp, DirCheck(aFileFull), '*.tap;*.prg;*.d64;*.g64;*d71;*.d81', true);

 If aPathArchive = '' then // running this procedure without archives
  begin
   str_FindAllImages.Text := str_FindAllImagesTmp.Text;
   ImageCount := str_FindAllImages.Count;
  end;

  If aPathArchive <> '' then // running this procedure with archives
   begin
   for i := 0 to str_FindAllImagesTmp.Count-1 do
    begin
     str_FindAllImages.Add(aPathArchive + '|' + str_FindAllImagesTmp[i]);
    end;
   ImageCountA2 := ImageCountA2 + str_FindAllImages.Count; // add all images inside archive(s)
   memoProgressBar.Max := ImageCount + ImageCountA2; // 100% progressbar
  end;

 if (ImageCount + ImageCountA2) = 0 then
   begin
    memoImport.Lines.Add('No image(s) to import!');
    ImageCount  := 0;
   end else memoImport.Lines.Add(IntToStr(ImageCount + ImageCountA2) + ' image(s) found.');

  str_FindAllImagesTmp.Destroy;
  lblImportFoundImg.Caption := ' ' + IntToStr(ImageCount + ImageCountA2) + ' ';
  lblImportfound.Caption := ' Collect finished';

end;

procedure TfrmImport.Init_str_FindAllImagesArchive(aPathArchive : String);
begin
 // aPathArchive = path to the archive
 str_FindAllFilesArchive.Clear;
 lblImportfound.Caption := ' Collecting archive files... Please wait.';
 Application.ProcessMessages;

 // Known images files
 FindAllFiles(str_FindAllFilesArchive, DirCheck(aPathArchive), '*.zip', true);
 if str_FindAllFilesArchive.Count = 0 then
   begin
    ImageCountA := 0;
    lblImportfound.Caption := '0 ';
   end;
 If str_FindAllFilesArchive.Count > 0 then
  begin
   ImageCountA := str_FindAllFilesArchive.Count;
  end;

 // Count images
 ImageCountA := str_FindAllFilesArchive.Count;
 lblImportFoundArc.Caption := ' ' + IntToStr(ImageCountA) + ' ';
 if str_FindAllFilesArchive.Count = 0 then  // pre then "Init_str_FindAllImages" checks also
   begin
    memoImport.Lines.Add('No archive(s) to import!');
   end else
   begin
    memoImport.Lines.Add(IntToStr(str_FindAllFilesArchive.Count) + ' archive(s) found.');
   end;

 lblImportfound.Caption := ' Collect finished';

end;

procedure TfrmImport.Init_str_FindAllImages_Sync;
var
  ImgCount : Integer;
begin
 exit; // Sync unfinished
 str_FindAllImages.Clear;
 str_FindAllImages.Add(Form1.SQlQueryDir.FieldByName('FileFull').Text);
 if str_FindAllImages.Count = 1 then
   begin
    // Delete
    DeleteFileUtf8(Form1.SQLQueryDir.FieldByName('FileFull').Text);
    Form1.AConnection.ExecuteDirect('DELETE from DirectoryTXT WHERE idxTXT = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
    Form1.AConnection.ExecuteDirect('DELETE from Tracks WHERE idxTrks = ' + Form1.SQLQueryDir.FieldByName('idxImg').Text + '');
    Form1.SQLQueryDir.Delete;
    Form1.SQLQueryDir.ApplyUpdates;
    Form1.ATransaction.CommitRetaining;

   //if Form1.DBGridDirTxt.Visible = true then
   // begin
   //  if Form1.SQlQuerySearch.RecordCount > 0 then Form1.SQlQuerySearch.Locate('idxSearch', Form1.SQLQueryDir.FieldByName('idxImg').Text, []);
   // end;
    //Form1.DBGridDir_ReadEntry;
    //Form1.DBGridDirTxt_ReadEntry;
    //Form1.LoadBAM_D64(Form1.SQLQueryDir.FieldByName('FileFull').Text,Form1.SQLQueryDir.FieldByName('FileSizeImg').Text );
    //Form1.LoadTS(Form1.SQLQueryDir.FieldByName('FileFull').Text);

    // Sync
    Form1.SQLQueryDir.SQL.Clear;
    Form1.SQLQueryDir.SQL.Add('SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DateLast, DateImport, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage');
    Form1.SQLQueryDir.Active := True;
    Form1.SQLQueryDir.Last;

    //ImgCount := Form1.SQLQueryDir.FieldByName('idxImg').AsInteger;  // idxImg, idxTxt Zähler
    ImgCount := Form1.SQLQueryDir.RecNo;

    Form1.SQLQueryDir.Active:=false;
    //Showmessage(str_FindAllImages.Strings[0]);
    //Showmessage(IntToStr(ImgCount));
    if Database_Ins_D64('', str_FindAllImages.Strings[0], ImgCount) = false then
     begin
      showmessage('buggy');
     end;
   end;
 Form1.SQLQueryDir.ApplyUpdates;
 Form1.ATransaction.CommitRetaining;
 str_FindAllImages.Free;
end;

procedure TfrmImport.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 str_FindAllImages.Free;
 str_FindAllImagesArchive.Free;
 str_FindAllFilesArchive.Free;
 DeleteDirectory(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')),true);
 close;
end;

procedure TfrmImport.FormShow(Sender: TObject);
begin
 str_FindAllImages := TStringList.Create;
 str_FindAllImagesArchive := TStringList.Create;
 str_FindAllFilesArchive := TStringList.Create;
 DirImport.Text := '';
 memoProgressbar.Position:=1;
 memoImport.Clear;
 memoImportErr.Clear;
 memoImport.Lines.Add('Nothing to import!');
 ImgCountErr := 0;
 lblImportCount.Caption := '0 ';
 lblImportFound.Caption := ' No folder selected! ';
 lblImportFoundImg.Caption := '0 ';
 lblImportFoundArc.Caption := '0 ';
 lblImportCountErr.Caption := '0 ';
 btImport.Caption:= 'Import';
 btImport.Enabled := false;
 Terminate := false;
end;

end.

