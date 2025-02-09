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
Some usefull functions
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
  Classes, SysUtils, StrUtils, Zipper, LConvEncoding, LazUTF8;
type
  TByteArr = array of Byte;

function HexStrToStr(const HexStr: string): string;
function DirCheck(const dir:string; add_if_length_is_zero:boolean=false): String;
function LoadByteArray(const AFileName: string): TByteArr;
function ByteArrayToHexString(AByteArray: TByteArr; ASep: string = ''): string;
function HexToString(Hexy: string): string;
function HexToASCII(mnuHexView:string):string;
function EndPathCP866ToUTF8(AText:string):string;
function UnPackFiles(aFilename, aImageFilename, UnPackPath: String): Integer;

implementation
uses Unit1;

function HexStrToStr(const HexStr: string): string;
var
  ResultLen: Integer;
begin
  ResultLen := Length(HexStr) div 2;
  SetLength(Result, ResultLen);
  if ResultLen > 0 then
    SetLength(Result, HexToBin(Pointer(HexStr), Pointer(Result), ResultLen));
end;

function DirCheck(const dir:string; add_if_length_is_zero:boolean=false): String;
  begin
    result := '';
    if length(dir)=0 then begin
      if add_if_length_is_zero then
        result:='\'
      else
        result:='';
      exit;
    end;
    if dir[length(dir)]='\' then
      result:=dir
    else
      result:=dir+'\';
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

function UnPackFiles(aFilename, aImageFilename, UnPackPath: String): Integer;
var
  UnZipper : TUnZipper; //PasZLib
  UnPackFileDir, ADiskFileName, ANewDiskFileName, AArchiveFileName  :String;
  i : integer;
begin
  Result:=-1;
  if FileExists(aFilename)and DirectoryExists(UnPackPath) then
  begin
       UnPackFileDir :=SysUtils.IncludeTrailingPathDelimiter(UnPackPath);
       UnZipper      :=TUnZipper.Create;
       try
          UnZipper.FileName   := aFilename;
          UnZipper.OutputPath := UnPackPath;
          UnZipper.Examine;
          UnZipper.UnZipAllFiles;
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
          Result:=1;
       finally
          UnZipper.Free;
       end;
  end;
end;

end.

