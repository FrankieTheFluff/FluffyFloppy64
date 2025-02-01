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
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TfrmDel, frmDel);
  Application.CreateForm(TfrmImport, frmImport);
  Application.CreateForm(TForm5, Form5);
  Application.Run;

end.

