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
Functions for FluffyFloppy64
v1.09 - 2026-01-01

Parts of it:
-
Thank you goes to askingbox.com
Tutorial by Stefan Trost | Last update on 2023-02-18 |
-----------------------------------------------------------------
}
unit FFFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Zipper, LConvEncoding, LazUTF8, FileUtil,
  LazFileUtils, LazUtils;
type
  TByteArr = array of Byte;

function HexStrToStr(const HexStr: string): string;
function LoadByteArray(const AFileName: string): TByteArr;
function ByteArrayToHexString(AByteArray: TByteArr; ASep: string = ''): string;
function HexToString(Hexy: string): string;
function HexToASCII(mnuHexView:string):string;
function TrimLeadingBackslash(const S: string): string;
function RemoveReadOnlyRecursive(const aFolder: String):Boolean;
function CleanTmp(aTmpPath : string):Boolean;
function UnpackArchive(const aArchiveName, aTmpPath, aCP : string):boolean;
function UnpackFile(const aArchiveName, aImageFile, ExtractPath, aCP: string): boolean;
function UnPackFiles(aArchivename, ExtractPath, aCP : String): Boolean;
function Init_ArrD64(aImageName : String): Boolean;
function Init_ArrD71(aImageName : String): Boolean;
function Init_ArrD81(aImageName : String): Boolean;
function GetArrayDir_PETSCII(arrTrackSector : String; aPosition : Integer; aLength : Integer; aTGCScratched : Boolean; aTGCShift : Boolean) : String;
function Database_Ins_D64(aArchiveImage: String; aImageName: String; aImg : Integer): boolean;
function Database_Ins_D71(aArchiveImage: String; aImageName: String; aImg : Integer): boolean;
function Database_Ins_D81(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
function Database_Ins_PRG(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
function Database_Ins_TAP(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
function Database_Ins_TXT(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
function Database_Ins_NFO(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
 ImageFileArray : TStringArray;

implementation
uses Unit1, GetPETSCII;

function HexStrToStr(const HexStr: string): string;
var
  ResultLen: Integer;
begin
  ResultLen := Length(HexStr) div 2;
  SetLength(Result, ResultLen);
  if ResultLen > 0 then
    SetLength(Result, HexToBin(Pointer(HexStr), Pointer(Result), ResultLen));
end;

function LoadByteArray(const AFileName: string): TByteArr;
var
  AStream: TStream;
  ADataLeft: Integer;
begin
  SetLength(result, 0);
  if not FileExists(AFileName) then exit;
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
     AStream.Position := 0;
     ADataLeft := AStream.Size;
     SetLength(result, ADataLeft div SizeOf(Byte));
     //showmessage(inttostr(ADataLeft div SizeOf(Byte)));    // = 175531 bytes
     AStream.Read(PByte(result)^, ADataLeft);
  finally
     AStream.Free;
  end;
end;

function ByteArrayToHexString(AByteArray: TByteArr; ASep: string = ''): string;
var
  i, k: integer;
begin
  result := '';
  if ASep = '' then begin
     for i := low(AByteArray) to high(AByteArray) do
       result := result + IntToHex(AByteArray[i], 2);
  end else
   begin
     k := high(AByteArray);
     for i := low(AByteArray) to k do begin
        result := result + IntToHex(AByteArray[i], 2);
        if k <> i then result := result + ASep;
     end;
   end;
end;

function HexToString(Hexy: string): string;
var
i: Integer;
begin
  Result:= '';
  for i := 1 to length(Hexy) div 2 do
  Result:= Result + Char(StrToInt('$' + Copy(Hexy,(I-1)*2+1,2)));
end;

function HexToASCII(mnuHexView:string):string;
var i,j:integer;
    conc:string;
    a:byte;
begin
  conc := '';
  Result:= '';
  for i:= 1 to (length(mnuHexView) div (2) ) do
  begin
  j:=(i*2)-1;
  a:=byte(Hex2Dec(copy(mnuHexView, j ,2) ) );
  conc := conc + char(a);
  end;
  result:= conc;
end;

function CleanTmp(aTmpPath : string):Boolean;
begin
 Result := False;
 try
  if aTmpPath <> '' then
   begin
    RemoveReadOnlyRecursive(aTmpPath); // In case smth is there
    DeleteDirectory(IncludeTrailingPathDelimiter(aTmpPath),true);
   end;
 except
  on E: Exception do
   begin
    Result := False;
   end;
 end;
 result := true;
end;

function TrimLeadingBackslash(const S: string): string;
begin
  if (S <> '') and (S[1] = '\') then
    Result := Copy(S, 2, Length(S) - 1)
  else
    Result := S;
end;

function RemoveReadOnlyRecursive(const aFolder: String) : Boolean;
var
  SR: TSearchRec;
  FilePath: String;
begin
  result := false;
  if FindFirst(IncludeTrailingPathDelimiter(aFolder) + '*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name = '.') or (SR.Name = '..') then
       Continue;
       FilePath := IncludeTrailingPathDelimiter(aFolder) + SR.Name;
      if (SR.Attr and faDirectory) <> 0 then
       RemoveReadOnlyRecursive(FilePath)
      else
        FileSetAttr(FilePath, 0); // Attribute zurücksetzen
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
  result := true;
end;

function UnpackArchive(const aArchiveName, aTmpPath, aCP : string):boolean;
begin
 // Create tmp folder named like the archive and unpack
 result := false;
  try
  try
   CreateDir(IncludeTrailingPathDelimiter(aTmpPath) + ExtractFileName(aArchiveName));
   UnPackFiles(aArchiveName, IncludeTrailingPathDelimiter(aTmpPath) + ExtractFileName(aArchiveName), aCP);
   result := true;
  except
   on E: Exception do
    begin
     Result := False;
    end;
  end;
 finally
  //
 end;
End;

function UnpackFile(const aArchiveName, aImageFile, ExtractPath, aCP: string) : Boolean;
var
  UnZipper: TUnZipper;
  i : integer;
  Extpath, entry : String;
begin
  result := false;
  UnZipper := TUnZipper.Create;
  try
  try
   UnZipper.FileName := aArchiveName;
   UnZipper.OutputPath := ExtractPath;

   Extpath := IncludeTrailingPathDelimiter(ExtractPath);
   Unzipper.Examine;
   entry := aImageFile;
   if (aCP = '') or (aCP = 'System') then SetCodePage(RawByteString(entry), DefaultSystemCodePage, true);
   if aCP = '437' then SetCodePage(RawByteString(entry), 437, true);
   UnZipper.UnzipFile(entry);

   for i := 0 to UnZipper.Entries.Count-1 do begin
    entry := UnZipper.Entries.Entries[i].ArchiveFileName;
    if (aCP = '') or (aCP = 'System') then SetCodePage(RawByteString(entry), DefaultSystemCodePage, true);
    if aCP = '437' then SetCodePage(RawByteString(entry), 437, false);
    Renamefile(Extpath+UnZipper.Entries.Entries[i].ArchiveFileName, Extpath+entry);
   end;
   Result:= true;
   except
    on E: Exception do
     begin
      Result := False;
     end;
   end;
  finally
   UnZipper.Free;
  end;
end;


function UnPackFiles(aArchiveName, ExtractPath, aCP: String): Boolean;
var
  UnZipper : TUnZipper;
  i : integer;
  Extpath, entry, cpFilename : String;
begin
  Result:= false;
  UnZipper      := TUnZipper.Create;
  try
  try
   UnZipper.FileName   := aArchiveName;
   UnZipper.OutputPath := ExtractPath;
   Extpath := IncludeTrailingPathDelimiter(ExtractPath);
   UnZipper.Examine;
   Unzipper.UnZipAllFiles;
   for i := 0 to UnZipper.Entries.Count-1 do begin
    entry := UnZipper.Entries.Entries[i].ArchiveFileName;
    if (aCP = '') or (aCP = 'System') then SetCodePage(RawByteString(entry), DefaultSystemCodePage, true);
    if aCP = '437' then SetCodePage(RawByteString(entry), 437, false);
    Renamefile(Extpath+UnZipper.Entries.Entries[i].ArchiveFileName, Extpath+entry);
   end;
   Result:= true;
   except
    on E: Exception do
     begin
      Result := False;
     end;
   end;
  finally
   UnZipper.Free;
 end;
end;

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

function GetArrayDir_PETSCII(arrTrackSector : String; aPosition : Integer; aLength : Integer; aTGCScratched : Boolean; aTGCShift : Boolean) : String;
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

function Database_Ins_D64(aArchiveImage: String; aImageName: String; aImg : Integer): boolean;
  // aFileName      = Database (sl3)
  // aImageName     = C:\...\filename.d64 or .g64 or .nib

var
  bf, bf2, a, b, z : Integer;
  BA : TByteArr;
  sb, t18, t19 : String;
  DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageSize, ImageExt, ImgBlocksFree : String;
  arrSec: array[0..19] of Byte;
  t, x, Sector, SectorNext, SectorPos : Integer;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
 If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
 If aArchiveImage = '' then
   begin
   FileFullA := aImageName;
   FilePathA := aImageName;
   frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  // Images read - check if g64 or nib
  If (Lowercase(ExtractFileExt(aImageName)) = '.g64') or (Lowercase(ExtractFileExt(aImageName)) = '.nib') then
   begin
    BA := LoadByteArray(aImageName);  // g64, nib
    ImageSize := ByteArrayToHexString(BA);
    BA := LoadByteArray(IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ChangeFileExt(aImageName,'.d64'))); // Vom d64
    Init_ArrD64(IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ChangeFileExt(aImageName,'.d64')));
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
    frmMain.AConnection.ExecuteDirect('insert into Tracks (idxTrks, T18, T19)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+  //IdxTrks;
    ' ''' + t18 + ''','+             //Track 18
    ' ''' + t19 + ''');');           //Track 19
   end;

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d64 ohne Punkt

  try
   frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
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
   frmMain.ATransaction.Active:=false;
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
       frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
       ' values('+
       ' ''' + IntToStr(aImg) + ''','+         //IdxTXT;
       ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
       ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
       ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
      End;

    // Next sector
     Sector := Hex2Dec(Copy(arrD64[18,Sector], 3, 2)); // e.g. “04”
     if Sector = 1 then t := 1; // Track 18  "01"  (normal 4)
     if Sector = 255 then t := 1; // Track 18 "FF"
     if (Sector > 18) AND (Sector <> 255) then t := 1; // bspw. "52"

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
     if Hex2Dec(Copy(arrD64[18,1], 1, 2)) <> 18 then t := 1; // Not valid Track 18.1 <> "12 04" Hex12=Dec18
     If SectorNext = 18 then t := 1;// max 18 per track
    Until t = 1;

  // Read T18/T19 into Array ENDE
  frmMain.ATransaction.Commit;
  // Write dataset END
  frmMain.ATransaction.Active:=false;
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
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

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
    frmMain.AConnection.ExecuteDirect('insert into Tracks (idxTrks, T18, T53)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+  //IdxTrks;
    ' ''' + t18 + ''','+             //Track 18
    ' ''' + t53 + ''');');           //Track 53
   end;

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage = '' then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d71 ohne Punkt

  try
   frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
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
   frmMain.ATransaction.Active:=false;
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

       frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
       ' values('+
       ' ''' + IntToStr(aImg) + ''','+         //IdxTXT;
       ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
       ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
       ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
      End;

     // Next sector
     TrackNext := Hex2Dec(Copy(arrD71[track,sector], 1, 2)); // 18
     SectorNext := Hex2Dec(Copy(arrD71[track,sector], 3, 2)); // e.g. “04”
     if Hex2Dec(Copy(arrD71[18,1], 1, 2)) <> 18 then t := 1; // Not valid Track 18.1 <> "12 04" Hex12=Dec18
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
    if TrackNext = 00 then t := 1;   // 00
    if SectorNext = 255 then t := 1; // FF
  Until t = 1;

  frmMain.ATransaction.Commit;
  frmMain.ATransaction.Active:=false;
  result := true;
end;

function Database_Ins_D81(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  sb, t40, ImageSize, FileFullA, FilePathA, sp, FileArchType : String;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt, ImageExt, FileSizeTxt, FileNameTXT, FileTypeTXT : String;
  a, b, z, bf, bf2, t, x, track, sector, sectorpos, TrackNext, SectorNext : Integer;
begin
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

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
    frmMain.AConnection.ExecuteDirect('insert into Tracks (idxTrks, T40)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+  //IdxTrks;
    ' ''' + t40 + ''');');           //Track 40
    t40 := '';
   end;

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage = '' then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  // Write table FileImage
  if (length(ImageExt)>0) and (ImageExt[1]='.') then delete(ImageExt,1,1); // d81 ohne Punkt

  // --------------------------
  Try
  frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
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
   ' ''' + blocksfree + ''');');                                                              //BlocksFreeTxt
  except
   frmMain.ATransaction.Active:=false;
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
      frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
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
    if Track = 0 then t := 1;
    if Sector = 255 then t := 1;  // FF
   Until t = 1;
  // Read T40 into Array ENDE
  frmMain.ATransaction.Commit;
  // Write dataset END
  frmMain.ATransaction.Active:=false;
  result := true;
end;

function Database_Ins_PRG(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  s, Img_FileExt : String;
  fstream : TFileStream;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt : String;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

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
  If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');                           // FilePath
   end;
  If aArchiveImage = '' then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');                             // FilePath
   end;

  Try
   frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' '''','+                                                                                  //DateLast
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
   frmMain.ATransaction.Active:=false;
   result := false;
   exit;
  end;

  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  FileSizeTxt := IntToStr(fstream.Size div 252);
  FileNameTXT := ExtractFileName(aImageName);
  FileTypeTXT := 'PRG';
  frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
  ' values('+
  ' ''' + IntToStr(aImg) + ''','+         //idxTxt (Index manuell)
  ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
  ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
  ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
  fstream.Free;
  frmMain.ATransaction.Commit;
  frmMain.ATransaction.Active:=false;
  result := true;
end;

function Database_Ins_TAP(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  BA : TByteArr;
  s, Img_FileExt : String;
  fstream : TFileStream;
  blocksfree, DiskNameTxt, DiskIDTxt, DosTypeTxt : String;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

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
  If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');        // FilePath
   end;
  If aArchiveImage = '' then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');       // FilePath
   end;

  Try
   frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, DiskName, DiskIDTxt, DOSTypeTxt, Favourite, Corrupt, Tags, Info, BlocksFreeTxt)'+
    ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
        ' '''','+                                                                              //DateLast
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
   frmMain.ATransaction.Active:=false;
   result := false;
   exit;
  end;

  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  FileSizeTxt := IntToStr(fstream.Size div 252);
  FileNameTXT := ExtractFileName(aImageName);
  FileTypeTXT := 'TAP';
  frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
  ' values('+
  ' ''' + IntToStr(aImg) + ''','+         //idxTxt (Index manuell)
  ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
  ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
  ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
  fstream.Free;
  frmMain.ATransaction.Commit;
  frmMain.ATransaction.Active:=false;
  result := true;
end;

function Database_Ins_TXT(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  Img_FileExt, StrM : String;
  FileTXTCont : TStringList;
  fstream : TFileStream;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  FileTXTCont := TStringList.Create;
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

  // TXT

  Img_FileExt := ExtractFileExt(aImageName);
  if (length(Img_FileExt)>0) and (Img_FileExt[1]='.') then delete(Img_FileExt,1,1); // d64 ohne Punkt

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');       // FilePath
   end;
  If aArchiveImage = '' then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');      // FilePath
   end;

  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  Try
    FileSizeTxt := IntToStr(fstream.Size);
    FileTXTCont.LoadFromStream(fstream);
    StrM:=ConvertEncoding(FileTXTCont.Text, GuessEncoding(FileTXTCont.Text), 'UTF-8');
  finally
    fstream.Free;
  end;

  Try
   frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, Favourite, Corrupt, Tags, Info)'+
   ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' '''','+                                                                                  //DateLast
    ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + Img_FileExt + ''','+                                                               //FileNameExt
    ' ''' + IntToStr(FileSize(aImageName)) + ''','+                                            //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
    ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' ' + QuotedStr(StrM) + ');');                                                             //Info
  except
   frmMain.ATransaction.Active:=false;
   result := false;
   FileTXTCont.Free;
   exit;
  end;

  FileNameTXT := ExtractFileName(aImageName);
  FileTypeTXT := 'TXT';
  frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
  ' values('+
  ' ''' + IntToStr(aImg) + ''','+         //idxTxt (Index manuell)
  ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
  ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
  ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
  frmMain.ATransaction.Commit;
  frmMain.ATransaction.Active:=false;
  FileTXTCont.Free;
  result := true;
end;

function Database_Ins_NFO(aArchiveImage: String; aImageName: String; aImg : Integer): Boolean;
var
  Img_FileExt, StrM : String;
  FileTXTCont : TStringList;
  fstream : TFileStream;
  FileSizeTXT, FileNameTXT, FileTypeTXT, FileFullA, FilePathA, sp, FileArchType : String;
begin
  FileTXTCont := TStringList.Create;
  frmMain.ATransaction.Active:=false;
  frmMain.ATransaction.StartTransaction;

  // NFO

  Img_FileExt := ExtractFileExt(aImageName);
  if (length(Img_FileExt)>0) and (Img_FileExt[1]='.') then delete(Img_FileExt,1,1); // d64 ohne Punkt

  // Write FilePath (for dropdown) and flag if archive
  FileArchType := '';
  If aArchiveImage <> '' then
   begin
    FileFullA := StringReplace(aArchiveImage, IncludeTrailingPathDelimiter(sAppTmpPath) + ExtractFileName(ImageFileArray[0]),'', [rfReplaceAll, rfIgnoreCase]);
    FilePathA := ImageFileArray[0];    // location of archive
    sp := ExtractFileExt(ImageFileArray[0]);
    while (Length(sp) > 0) and (sp[1] = '.') do Delete(sp, 1, 1);
    FileArchType := sp;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(FilePathA)) +');');       // FilePath
   end;
  If aArchiveImage = '' then
   begin
    FileFullA := aImageName;
    FilePathA := aImageName;
    frmMain.AConnection.ExecuteDirect('insert or ignore into FilePath (FilePath)'+
      ' values('+
      ' ' + QuotedStr(ExtractFilePath(aImageName)) +');');      // FilePath
   end;

  fstream:= TFileStream.Create(aImageName, fmShareCompat or fmOpenRead);
  Try
    FileSizeTxt := IntToStr(fstream.Size);
    FileTXTCont.LoadFromStream(fstream);
    StrM:=ConvertEncoding(FileTXTCont.Text, GuessEncoding(FileTXTCont.Text), 'UTF-8');
  finally
    fstream.Free;
  end;

  Try
   frmMain.AConnection.ExecuteDirect('insert into FileImage (idxImg, DateImport, DateLast, FilePath, FileName, FileNameExt, FileSizeIMG, FileDateTime, FileFull, FileArchType, Favourite, Corrupt, Tags, Info)'+
   ' values('+
    ' ''' + IntToStr(aImg) + ''','+                                                            //idxImg (Index manuell)
    ' ''' + DateTimeToStr(now) + ''','+                                                        //DateImport
    ' '''','+                                                                                  //DateLast
    ' ' + QuotedStr(ExtractFilePath(FilePathA)) + ','+                                         //FilePath
    ' ' + QuotedStr(ExtractFileNameOnly(ExtractFileName(aImageName))) + ','+                   //FileName
    ' ''' + Img_FileExt + ''','+                                                               //FileNameExt
    ' ''' + IntToStr(FileSize(aImageName)) + ''','+                                            //FileSizeImg
    ' ''' + DateTimeToStr(FileDateTodateTime(FileAgeUTF8(aImageName))) + ''','+                //FileDateTime
    ' ' + QuotedStr(FileFullA) + ','+                                                          //FileFull
    ' ' + QuotedStr(FileArchType) + ','+                                                       //FileArchType
    ' ''' + BoolToStr(false) + ''','+                                                          //Favourite
    ' ''' + BoolToStr(false) + ''','+                                                          //Corrupt
    ' '''','+                                                                                  //Tags
    ' ' + QuotedStr(StrM) + ');');                                                             //Info
  except
   frmMain.ATransaction.Active:=false;
   result := false;
   FileTXTCont.Free;
   exit;
  end;

  FileNameTXT := ExtractFileName(aImageName);
  FileTypeTXT := 'NFO';
  frmMain.AConnection.ExecuteDirect('insert into DirectoryTXT (idxTxt, FileSizeTxt, FileNameTxt, FileTypeTxt)'+
  ' values('+
  ' ''' + IntToStr(aImg) + ''','+         //idxTxt (Index manuell)
  ' ''' + FileSizeTxt + ''','+            //FileSizeTxt
  ' ' + QuotedStr(FileNameTXT) + ','+     //FileNameTxt
  ' ''' + FileTypeTXT + ''');');          //FileTypeTxt
  frmMain.ATransaction.Commit;
  frmMain.ATransaction.Active:=false;
  FileTXTCont.Free;
  result := true;
end;

end.

