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
Some usefull functions
v1.02 - 2025-06-30

Parts of it:
-
Thank you goes to askingbox.com
Tutorial by Stefan Trost | Last update on 2023-02-18 |
-
ZIP functionality (EndPathCP866ToUTF8) & (UnPackFiles):
https://wiki.lazarus.freepascal.org/paszlib
-----------------------------------------------------------------
}
unit FFFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Zipper, LConvEncoding, LazUTF8, FileUtil;
type
  TByteArr = array of Byte;


function FileWithReadAttr(aFileName : String) : Boolean;
function HexStrToStr(const HexStr: string): string;
function LoadByteArray(const AFileName: string): TByteArr;
function ByteArrayToHexString(AByteArray: TByteArr; ASep: string = ''): string;
function HexToString(Hexy: string): string;
function HexToASCII(mnuHexView:string):string;
function EndPathCP866ToUTF8(AText:string):string;
function TrimLeadingBackslash(const S: string): string;
function UnpackFile(const aArchiveName, aImageFile, UnpackPath: string) : Boolean;
function UnPackFiles(aArchivename, aImageFilename, UnPackPath: String): Boolean;

implementation
uses Unit1;

function FileWithReadAttr(aFileName : String) : Boolean;
Var
  F : Longint;
begin
  result := false;
  If (F and faReadOnly)<>0 then result := true;
end;

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

function EndPathCP866ToUTF8(AText:string):string;
var
  c,i:integer;
  s,s1,s2,chr:string;
begin
  s:='';
  i:=0;
  c:=UTF8Length(AText);
  for i:=c downto 1 do
   begin
       chr:=UTF8Copy(AText,i,1);
       if ((not(chr='/')) and (not(chr='\')))or(i=c) then
       begin
            s:=UTF8Copy(AText,i,1)+s;
       end
       else begin
            s:=UTF8Copy(AText,i,1)+s;
            break;
       end;
   end;
  dec(i);
  s1:=UTF8Copy(AText,1,i);
  s2:=CP866ToUTF8(s);
  Result:=s1+s2;
end;

function TrimLeadingBackslash(const S: string): string;
begin
  if (S <> '') and (S[1] = '\') then
    Result := Copy(S, 2, Length(S) - 1)
  else
    Result := S;
end;


function UnpackFile(const aArchiveName, aImageFile, UnpackPath: string) : Boolean;
var
  UnZipper: TUnZipper;
begin
  result := false;

  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := aArchiveName;
    UnZipper.OutputPath := IncludeTrailingPathDelimiter(UnpackPath);
    UnZipper.Files.Clear;
    UnZipper.Files.Add(aImageFile);
    UnZipper.UnZipFile(aImageFile);
  finally
    UnZipper.Free;
  end;
  result := true;
end;

function UnPackFiles(aArchiveName, aImageFilename, UnPackPath: String): Boolean;
var
  UnZipper : TUnZipper;
  UnPackFileDir, ADiskFileName, ANewDiskFileName, AArchiveFileName  :String;
  i : integer;
begin
  Result:= false;
  UnPackFileDir :=SysUtils.IncludeTrailingPathDelimiter(UnPackPath);
  UnZipper      :=TUnZipper.Create;
  try
  try
   UnZipper.FileName   := aArchiveName;
   UnZipper.OutputPath := UnPackPath;
   UnZipper.Examine;

   if aImageFileName = '' then UnZipper.UnZipAllFiles;  // Alle entpacken
   if aImageFileName <> '' then
    begin
     Unzipper.Unzip(aImageFilename);
    end;

   for i:=UnZipper.Entries.Count-1 downto 0 do
    begin
     AArchiveFileName:=UnZipper.Entries.Entries[i].ArchiveFileName;
     AArchiveFileName:=EndPathCP866ToUTF8(AArchiveFileName);
     AArchiveFileName:=UTF8ToSys(AArchiveFileName);
     ANewDiskFileName:=UnPackFileDir+AArchiveFileName;
     ADiskFileName   :=UnPackFileDir+UnZipper.Entries.Entries[i].DiskFileName;
     if FileExists(ADiskFileName) then
      begin
       RenameFile(ADiskFileName, ANewDiskFileName);
      end
     else if DirectoryExists(ADiskFileName) then
      begin
       ADiskFileName    :=SysUtils.IncludeTrailingPathDelimiter(ADiskFileName);
       ANewDiskFileName :=SysUtils.IncludeTrailingPathDelimiter(ANewDiskFileName);
       RenameFile(ADiskFileName, ANewDiskFileName);
      end;
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

end.

