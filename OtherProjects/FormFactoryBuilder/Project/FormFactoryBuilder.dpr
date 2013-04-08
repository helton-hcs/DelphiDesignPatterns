program FormFactoryBuilder;

uses
  FMX.Forms,
  FormDecorator.Classes in '..\Source\FormDecorator.Classes.pas',
  Main.Form in '..\Source\Main.Form.pas' {Form1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
