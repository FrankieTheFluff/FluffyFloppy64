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
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DirImport: TDirectoryEdit;
    grImportProgress: TGroupBox;
    grImportFrom: TGroupBox;
    lblFileSel: TLabel;
    lblFileProgress: TLabel;
    lblImport1: TLabel;
    lblImportCount: TStaticText;
    lblImportCountErr: TStaticText;
    memoImport: TMemo;
    memoImportErr: TMemo;
    memoProgressBar: TProgressBar;
    lblImportFound: TStaticText;
    procedure btCloseClick(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure DirImportAcceptDirectory(Sender: TObject; var Value: String);
    procedure DirImportChange(Sender: TObject);
    procedure DirImportEditingDone(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Import;
    procedure Init_str_FindAllImages;
    procedure Init_str_FindAllImages_Sync;
  private

  public

  end;

var
  frmImport: TfrmImport;
  str_FindAllImages : TStringList;
  Terminate : Boolean;

implementation

{$R *.lfm}

uses
  unit1, FFFunctions;

{ TfrmImport }

function Database_Ins_D64(aFileName: String; aImageName: String; aImg : Integer): boolean;
  // aFileName      = Database (sl3)
  // aImageName     = C:\...\filename.d64 or .g64...
var
  bf, bf2, a, b, z : Integer;
  BA : TByteArr;
  sb, t18, t19 : String;
  DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageSize, ImageExt, ImgBlocksFree : String;
  arrSec: array[0..19] of Byte;
  t, x, Sector, SectorNext, SectorPos : Integer;
  FileSizeTXT, FileNameTXT, FileTypeTXT : String;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

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

  // Write FilePath (for dropdown)
  Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
    ' values('+
    ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d64 ohne Punkt

  try
    //Form1.SQlQueryDir.SQL.Text := 'insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileFull, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Info, BlocksFreeTxt) values (:idxImg, :DateImport, :DateLast, :FilePath, :FileName, :FileNameExt, :FileSizeIMG, :FileFull, :DiskName, :DiskIDTxt, :DOSTypeTxt, :Favourite, :Corrupt, :Info, :BlocksFreeTxt);';
    ////Form1.SQlQueryDir.Edit;
    //Form1.SQLQueryDir.Prepare;
    //Form1.SQLQueryDir.Params.ParamByName('idxImg').AsInteger:= aImg;
    //Form1.SQLQueryDir.Params.ParamByName('DateImport').AsDate:= now;
    //Form1.SQLQueryDir.Params.ParamByName('DateLast').AsDate:= now;
    //Form1.SQLQueryDir.Params.ParamByName('FilePath').AsString:= ExtractFilePath(aImageName);
    //Form1.SQLQueryDir.Params.ParamByName('FileName').AsString:= ExtractFileName_WithoutExt(ExtractFileName(aImageName));
    //Form1.SQLQueryDir.Params.ParamByName('FileNameExt').AsString:= ImageExt;
    //Form1.SQLQueryDir.Params.ParamByName('FileSizeImg').AsInteger:= length(ImageSize) div 2;
    //Form1.SQLQueryDir.Params.ParamByName('FileFull').AsString:= aImageName;
    //Form1.SQLQueryDir.Params.ParamByName('DiskName').AsString:= DiskNameTxt;
    //Form1.SQLQueryDir.Params.ParamByName('DiskIDTxt').AsString:= DiskIDTxt;
    //Form1.SQLQueryDir.Params.ParamByName('DOSTypeTxt').AsString:= DOSTypeTxt;
    //Form1.SQLQueryDir.Params.ParamByName('Favourite').AsBoolean:= false;
    //Form1.SQLQueryDir.Params.ParamByName('Corrupt').AsBoolean:= false;
    //Form1.SQLQueryDir.Params.ParamByName('Info').AsString:= '';
    //Form1.SQLQueryDir.Params.ParamByName('BlocksFreeTxt').AsString := blocksfree;
    //Form1.SQlQueryDir.ExecSQL;

   // --------------------------
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
    ' ' + QuotedStr(ExtractFilePath(aImageName)) + ','+                                        //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + ImageExt + ''','+                                                                  //FileNameExt
    ' ''' + IntToStr(length(ImageSize) div 2) + ''','+                                         //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(aImageName) + ','+                                                         //FileFull
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

function Database_Ins_D71(aFileName: String; aImageName: String; aImg : Integer): boolean;
  // aFileName      = Database (sl3)
  // aImageName     = C:\...\filename.d71
var
  bf, bf2, a, b, z : Integer;
  BA : TByteArr;
  sb, t18, t19, t53 : String;
  DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageSize, ImageExt, ImgBlocksFree : String;
  arrSec: array[0..19] of Byte;
  t, x, Track, Sector, TrackNext, SectorNext, SectorPos, SectorCount, repeated : Integer;
  FileSizeTXT, FileNameTXT, FileTypeTXT : String;
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

  // Write FilePath (for dropdown)
  Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
    ' values('+
    ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d71 ohne Punkt

  try
    //Form1.SQlQueryDir.SQL.Text := 'insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileFull, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Info, BlocksFreeTxt) values (:idxImg, :DateImport, :DateLast, :FilePath, :FileName, :FileNameExt, :FileSizeIMG, :FileFull, :DiskName, :DiskIDTxt, :DOSTypeTxt, :Favourite, :Corrupt, :Info, :BlocksFreeTxt);';
    ////Form1.SQlQueryDir.Edit;
    //Form1.SQLQueryDir.Prepare;
    //Form1.SQLQueryDir.Params.ParamByName('idxImg').AsInteger:= aImg;
    //Form1.SQLQueryDir.Params.ParamByName('DateImport').AsDate:= now;
    //Form1.SQLQueryDir.Params.ParamByName('DateLast').AsDate:= now;
    //Form1.SQLQueryDir.Params.ParamByName('FilePath').AsString:= ExtractFilePath(aImageName);
    //Form1.SQLQueryDir.Params.ParamByName('FileName').AsString:= ExtractFileName_WithoutExt(ExtractFileName(aImageName));
    //Form1.SQLQueryDir.Params.ParamByName('FileNameExt').AsString:= ImageExt;
    //Form1.SQLQueryDir.Params.ParamByName('FileSizeImg').AsInteger:= length(ImageSize) div 2;
    //Form1.SQLQueryDir.Params.ParamByName('FileFull').AsString:= aImageName;
    //Form1.SQLQueryDir.Params.ParamByName('DiskName').AsString:= DiskNameTxt;
    //Form1.SQLQueryDir.Params.ParamByName('DiskIDTxt').AsString:= DiskIDTxt;
    //Form1.SQLQueryDir.Params.ParamByName('DOSTypeTxt').AsString:= DOSTypeTxt;
    //Form1.SQLQueryDir.Params.ParamByName('Favourite').AsBoolean:= false;
    //Form1.SQLQueryDir.Params.ParamByName('Corrupt').AsBoolean:= false;
    //Form1.SQLQueryDir.Params.ParamByName('Info').AsString:= '';
    //Form1.SQLQueryDir.Params.ParamByName('BlocksFreeTxt').AsString := blocksfree;
    //Form1.SQlQueryDir.ExecSQL;

   // --------------------------
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
    ' ' + QuotedStr(ExtractFilePath(aImageName)) + ','+                                        //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + ImageExt + ''','+                                                                  //FileNameExt
    ' ''' + IntToStr(length(ImageSize) div 2) + ''','+                                         //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(aImageName) + ','+                                                         //FileFull
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


Function Database_Ins_D81(aFileName: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  sb, t40, ImageSize : String;
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

  // Write FilePath (for dropdown)
  Form1.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
    ' values('+
    ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d81 ohne Punkt

  // --------------------------
  Try
  Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
   ' values('+
   ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
   ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
   ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
   ' ' + QuotedStr(ExtractFilePath(aImageName)) + ','+                                        //FilePath
   ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
   ' ''' + ImageExt + ''','+                                                                  //FileNameExt
   ' ''' + IntToStr(length(ImageSize) div 2) + ''','+                                         //FileSizeImg
   ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
   ' ' + QuotedStr(aImageName) + ','+                                                         //FileFull
   ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
   ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
   ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
   ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
   ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
   ' '''','+                                                                                  //Tags
   ' '''','+                                                                                  //Info
   ' ''' + blocksfree + ''');');                                                              //BlocksFreeTxt
  except
   //showmessage(IntToStr(aImg) + ' - ' + aImageName);
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

Function Database_Ins_PRG(aFileName: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  s, Img_FileExt : String;
  fstream : TFileStream;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt : String;
  FileSizeTXT, FileNameTXT, FileTypeTXT : String;
begin
  Form1.ATransaction.Active:=false;
  Form1.ATransaction.StartTransaction;

  // PRG
  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  BA := LoadByteArray('"' + aImageName + '"');
  s := ByteArrayToHexString(BA);
  Img_FileExt := ExtractFileExt(aImageName);
  if (length(Img_FileExt)>0) and (Img_FileExt[1]='.') then delete(Img_FileExt,1,1); // d64 ohne Punkt
  DiskNameTxt := '';
  DiskIDTxt := '';
  DosTypeTxt := '';
  blocksfree := IntToStr(length(s) div 2);

  Try
   Form1.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateLast
    ' ' + QuotedStr(ExtractFilePath(aImageName)) + ','+                                        //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + Img_FileExt + ''','+                                                               //FileNameExt
    ' ''' + IntToStr(FileSize(aImageName)) + ''','+                                            //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(aImageName) + ','+                                                         //FileFull
    ' ' + QuotedStr(DiskNameTxt) + ','+                                                        //DiskName
    ' ' + QuotedStr(DiskIDTxt) + ','+                                                          //DiskIDTxt
    ' ' + QuotedStr(DosTypeTxt) + ','+                                                         //DOSTypeTxt
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' '''','+                                                                                  //Info
    ' ''' + blocksfree + ''');');                                                              //BlocksFreeTxt
  except
   fstream.Free;
   Form1.ATransaction.Active:=false;
   result := false;
   exit;
  end;

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

procedure TfrmImport.Import;
var
  fstream : TFileStream;
  ImgCount, ImgCountErr , img : Integer;
  vMode : word;
begin
  Form1.cbDBFilePath.ItemIndex:=0;
  Form1.cbDBFileNameExt.ItemIndex:=0;
  Form1.DBFilter;

  Form1.LstBxDirectoryPETSCII.Clear;
  Form1.LstBAM.Clear;
  Form1.lstBoxSectors.Clear;
  Form1.lstBoxASCII.Clear;
  Form1.LstBxDirectoryTXT.Clear;
  Form1.MemoBAMHint.Clear;
  Form1.StatusBar1.Panels[1].Text:= 'Importing...';
  Form1.Statusbar1.Panels[2].Text := '';
  Form1.Statusbar1.Panels[3].Text := '';
  Form1.Statusbar1.Panels[4].Text := '';
  Form1.Statusbar1.Refresh;

  memoProgressbar.Position:=0;
  memoImport.Clear;
  ImgCount := 0;
  ImgCountErr := 0;
  lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';

 if str_FindAllImages.Count > 0 then
  begin
   Application.ProcessMessages;
   memoProgressbar.Min:=1;
   memoProgressBar.Max:=str_FindAllImages.Count;
   Form1.SQLQueryDir.Last;
   ImgCount := Form1.SQLQueryDir.FieldByName('idxImg').AsInteger;  // idxImg, idxTxt Zähler
   Form1.SQLQueryDir.Active:=false;
   //Form1.ATransaction.Active:=false;

   // accept only valid and not existing files to stringlist str_Images
   for img := 0 to str_FindAllImages.count-1 do
    begin
     try

     //PRG - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.prg' then
      begin
       // Add
       ImgCount := ImgCount + 1;
       if Database_Ins_PRG(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then
         begin
          ImgCount := ImgCount - 1;
          Application.ProcessMessages;
          memoProgressBar.Position := img+1;
          ImgCountErr := ImgCountErr + 1;
          lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
          memoImportErr.Lines.Add('No import (already exists): ' + str_FindAllImages.Strings[img]);
         end
       else
         begin
          Application.ProcessMessages;
          memoProgressBar.Position := img+1;
          lblImportCount.Caption:=IntTostr(img+1) + ' ';
          memoImport.Lines.Clear;
          memoImport.Lines.Add(str_FindAllImages.Strings[img]);
         end;
        // Add Ende
      end;

     //D64 - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.d64' then
      begin
       fstream:= TFileStream.Create(str_FindAllImages.Strings[img], fmShareCompat or fmOpenRead);
       if  (fstream.Size = 174848) or  (fstream.Size = 175531) or (fstream.Size = 196608) or  (fstream.Size = 197376) or (fstream.Size = 205312) or  (fstream.Size = 206114) or  (fstream.Size = 210483) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D64(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            Application.ProcessMessages;
            memoProgressBar.Position := img+1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            memoImportErr.Lines.Add('No import (already exists): ' + str_FindAllImages.Strings[img]);
           end
         else
           begin
            Application.ProcessMessages;
            memoProgressBar.Position := img+1;
            lblImportCount.Caption:=IntTostr(img+1) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(str_FindAllImages.Strings[img]);
           end;
        end
       else
       begin
        fstream.Free;
        ImgCountErr := ImgCountErr + 1;
        lblImportCountErr.Caption := IntToStr(ImgCountErr);
        memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + str_FindAllImages.Strings[img]);
       end;
      end;

     //D71 - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.d71' then
      begin
       fstream:= TFileStream.Create(str_FindAllImages.Strings[img], fmShareCompat or fmOpenRead);
       if  (fstream.Size = 349696) or (fstream.Size = 351062) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D71(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            Application.ProcessMessages;
            memoProgressBar.Position := img+1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            memoImportErr.Lines.Add('No import (already exists): ' + str_FindAllImages.Strings[img]);
           end
         else
           begin
            Application.ProcessMessages;
            lblImportCount.Caption:=IntTostr(img+1) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(str_FindAllImages.Strings[img]);
            memoProgressBar.Position := img+1;
           end;
        end
       else
        begin
         fstream.Free;
         ImgCountErr := ImgCountErr + 1;
         lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
         memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + str_FindAllImages.Strings[img]);
        end;
      end;

     //D81 - filesize check if valid file
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.d81' then
      begin
       fstream:= TFileStream.Create(str_FindAllImages.Strings[img], fmShareCompat or fmOpenRead);
       if  (fstream.Size = 819200) or (fstream.Size = 822400) then
        begin
         ImgCount := ImgCount + 1;
         fstream.Free;
         if Database_Ins_D81(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then
          begin
           ImgCount := ImgCount - 1;
           Application.ProcessMessages;
           memoProgressBar.Position := img+1;
           ImgCountErr := ImgCountErr + 1;
           lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
           memoImportErr.Lines.Add('No import (already exists): ' + str_FindAllImages.Strings[img]);
          end
         else
           begin
            Application.ProcessMessages;
            lblImportCount.Caption:=IntTostr(img+1) + ' ';
            memoImport.Lines.Clear;
            memoImport.Lines.Add(str_FindAllImages.Strings[img]);
            memoProgressBar.Position := img+1;
           end;
        end
       else fstream.Free;
      end;

    // G64
     if lowercase(ExtractFileExt(str_FindAllImages.Strings[img])) = '.g64' then
      begin
       btClose.Enabled:=false;
       Form1.Convert_G64(str_FindAllImages.Strings[img]);
       // Checking if convert failed
       If filesize(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ChangeFileExt(ExtractFileName(str_FindAllImages.Strings[img]),'.d64')) = 0 then
        begin
         ImgCountErr := ImgCountErr + 1;
         lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
         memoImportErr.Lines.Add('Convert g64 to d64 failed - not imported: ' + str_FindAllImages.Strings[img]);
        end  // end checking if convert failed
       else
        begin
        fstream:= TFileStream.Create(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ChangeFileExt(ExtractFileName(str_FindAllImages.Strings[img]),'.d64'), fmShareCompat or fmOpenRead);
        if  (fstream.Size = 174848) or  (fstream.Size = 175531) or (fstream.Size = 196608) or  (fstream.Size = 197376) or (fstream.Size = 205312) or  (fstream.Size = 206114) or  (fstream.Size = 210483) then
         begin
          ImgCount := ImgCount + 1;
          fstream.Free;
          if Database_Ins_D64(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[img], ImgCount) = false then
           begin
            ImgCount := ImgCount - 1;
            Application.ProcessMessages;
            memoProgressBar.Position := img+1;
            ImgCountErr := ImgCountErr + 1;
            lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
            memoImportErr.Lines.Add('No import (already exists): ' + str_FindAllImages.Strings[img]);
           end
          else
            begin
             Application.ProcessMessages;
             lblImportCount.Caption:=IntTostr(img+1) + ' ';
             memoImport.Lines.Clear;
             memoImport.Lines.Add(str_FindAllImages.Strings[img]);
             memoProgressBar.Position := img+1;
            end;
         end
        else
         begin
          If fstream.Size <> 0 then fstream.Free; // If Convert fails
          ImgCount := ImgCount - 1;
          Application.ProcessMessages;
          memoProgressBar.Position := img+1;
          ImgCountErr := ImgCountErr + 1;
          lblImportCountErr.Caption := IntToStr(ImgCountErr) + ' ';
          memoImportErr.Lines.Add('Not a valid file (wrong filesize: ' + IntToStr(fstream.Size) + ') ' + str_FindAllImages.Strings[img]);
         end;
         end;
        //Form1.EmptyTemp;
        //DeleteFile(DirCheck(IniFluff.ReadString('Options', 'FolderTemp', '')) + ExtractFileName(ChangeFileExt(str_FindAllImages.Strings[img],'.d64')));
       end; // Ende g64
     //finally
     except
      on E: Exception do memoImportErr.Lines.Add('An exception was raised: ' + E.Message + '- File: ' + str_FindAllImages.Strings[img]);
     // memoImportErr.Lines.Add('An exception during import was raised: - File: ' + str_FindAllImages.Strings[img]);
     // Application.ProcessMessages;
     end;

    Form1.EmptyTemp; // Clean temp folder

    Application.ProcessMessages;

    // Cancel
    if terminate = true then
     begin
      str_FindAllImages.Clear;
      lblImportFound.Caption:= '0 ';
      memoImport.Lines.Add('Import cancelled!');
      Form1.SQLQueryDir.SQL.Clear;
      Form1.SQLQueryDir.SQL.Add('Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, DiskIDTxt, DOSTypeTxt, FilePath, Favourite, Corrupt, Tags, Info from FileImage');
      Form1.SQLQueryDir.Active:=true;
      if Form1.ATransaction.Active then
       begin
        Form1.SQlQueryDir.ApplyUpdates;
        Form1.ATransaction.Commit;
       end;
      Form1.DBGridDir_ReadEntry;
      Form1.Init_FilePath;
      btClose.Enabled :=true;
      btClose.SetFocus;
      btImport.Caption := 'Import';
      btImport.Enabled := false;
      exit;
     end;
   end;

   memoImport.Lines.Clear;
   memoImport.Lines.Add('Import finished! (duplicates ignored)');

   Form1.SQLQueryDir.SQL.Clear;
   Form1.SQLQueryDir.SQL.Add('Select idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, DiskIDTxt, DOSTypeTxt, FilePath, Favourite, Corrupt, Tags, Info from FileImage');
   Form1.SQLQueryDir.Active:=true;

   if Form1.ATransaction.Active then
    begin
     Form1.SQlQueryDir.ApplyUpdates;
     Form1.ATransaction.Commit;
    end;

   Form1.DBGridDir_ReadEntry;
   Form1.Init_FilePath;
  end;
  str_FindAllImages.Clear;
  btClose.Enabled:=true;
  btClose.SetFocus;
  btImport.Caption := 'Import';
  btImport.Enabled := false;
end;

procedure TfrmImport.btCloseClick(Sender: TObject);
begin
 close;
end;

procedure TfrmImport.btImportClick(Sender: TObject);
var
  answer : integer;
begin
 if btImport.Caption = 'Cancel' then
  begin
   Terminate := true;
    answer := MessageDlg('Import cancelled!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      DirImport.Text := '';
      memoProgressbar.Position:=0;
      btClose.Enabled:=true;
      exit;
     end;
   exit;
  end;

 if (DirImport.Directory = '') or (DirectoryExists(DirImport.Directory) = false) then
  begin
   answer := MessageDlg('Directory not found!',mtWarning, [mbOK], 0);
    if answer = mrOk then
     begin
      btClose.Enabled:=true;
      exit;
     end;
  end;
 Terminate := false;
 btImport.Caption:= 'Cancel';
 Import;
end;

procedure TfrmImport.DirImportAcceptDirectory(Sender: TObject; var Value: String
  );
begin
    DirImport.Directory:=Value;
    Init_str_FindAllImages;
end;


procedure TfrmImport.DirImportChange(Sender: TObject);
begin
  btImport.Enabled := true;
end;

procedure TfrmImport.DirImportEditingDone(Sender: TObject);
begin
 Init_str_FindAllImages;
end;

procedure TfrmImport.Init_str_FindAllImages;
begin
 str_FindAllImages.Clear;
 lblImportfound.Caption := ' Collecting files... Please wait.';
 lblImportCount.Caption:= '0 ';
 lblImportCountErr.Caption:= '0 ';
 memoProgressbar.Position:=0;
 memoImport.Clear;
 memoImportErr.Clear;

 Application.ProcessMessages;
 FindAllFiles(str_FindAllImages, DirCheck(DirImport.Directory), '*.d64;*.prg;*.g64;*.d71;*.d81', true);

 if str_FindAllImages.Count = 0 then
   begin
    memoImport.Lines.Clear;
    memoImport.Lines.Add('Nothing to import!');
    lblImportfound.Caption := ' ' + IntToStr(str_FindAllImages.Count) + ' ';
    btClose.SetFocus;
    btImport.Enabled := false;
    exit;
   end;
 if str_FindAllImages.Count > 0 then
   begin
    lblImportfound.Caption := ' ' + IntToStr(str_FindAllImages.Count) + ' ';
    btImport.Enabled := true;
   end;
end;

procedure TfrmImport.Init_str_FindAllImages_Sync;
var
  ImgCount : Integer;
begin
 str_FindAllImages := TStringList.Create;
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
    Form1.SQLQueryDir.SQL.Add('SELECT idxImg, FileName, FileFull, FileNameExt, FileSizeImg, DiskName, Favourite, Corrupt, FilePath, Tags, Info FROM FileImage');
    Form1.SQLQueryDir.Active := True;
    Form1.SQLQueryDir.Last;

    //ImgCount := Form1.SQLQueryDir.FieldByName('idxImg').AsInteger;  // idxImg, idxTxt Zähler
    ImgCount := Form1.SQLQueryDir.RecNo;

    Form1.SQLQueryDir.Active:=false;
    //Showmessage(str_FindAllImages.Strings[0]);
    //Showmessage(IntToStr(ImgCount));
    if Database_Ins_D64(IniFluff.ReadString('Database', 'Location', ''), str_FindAllImages.Strings[0], ImgCount) = false then
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
 close;
end;

procedure TfrmImport.FormShow(Sender: TObject);
begin
 str_FindAllImages := TStringList.Create;
 DirImport.Text := '';
 memoProgressbar.Position:=0;
 memoImport.Clear;
 memoImportErr.Clear;
 lblImportCount.Caption := '0 ';
 lblImportFound.Caption := ' No folder selected! ';
 lblImportCountErr.Caption := '0 ';
 btImport.Caption:= 'Import';
 btImport.Enabled := false;
 Terminate := false;
end;

end.

