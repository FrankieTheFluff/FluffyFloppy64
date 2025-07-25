program ff64;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2, GetPETSCII, Unit3, Unit4, Unit5, Unit6, FFFunctions,
  Unit8;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDB, frmDB);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TfrmDel, frmDel);
  Application.CreateForm(TfrmImport, frmImport);
  Application.CreateForm(TfrmManual, frmManual);
  Application.Run;

end.

