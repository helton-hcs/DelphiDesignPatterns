program TestDesignPatterns;

uses
  GUITestRunner,
  DesignPatternsTests in 'DesignPatternsTests.pas',
  Structural.Decorator.Classes.Example2 in '..\Design Patterns Classes\Structural\Decorator\Structural.Decorator.Classes.Example2.pas',
  Structural.Decorator.Classes.Example1 in '..\Design Patterns Classes\Structural\Decorator\Structural.Decorator.Classes.Example1.pas',
  Behavioral.Strategy.Classes.Example1 in '..\Design Patterns Classes\Behavioral\Strategy\Behavioral.Strategy.Classes.Example1.pas',
  Creational.Singleton.Classes.Example1 in '..\Design Patterns Classes\Creational\Singleton\Creational.Singleton.Classes.Example1.pas',
  Behavioral.Observer.Classes.Example1 in '..\Design Patterns Classes\Behavioral\Observer\Behavioral.Observer.Classes.Example1.pas',
  Creational.Factory.Classes.Example1 in '..\Design Patterns Classes\Creational\Factory\Creational.Factory.Classes.Example1.pas',
  Creational.Builder.Classes.Example1 in '..\Design Patterns Classes\Creational\Builder\Creational.Builder.Classes.Example1.pas',
  Creational.Prototype.Classes.Example1 in '..\Design Patterns Classes\Creational\Prototype\Creational.Prototype.Classes.Example1.pas',
  SmartPointer.Classes in '..\Utils\SmartPointer.Classes.pas',
  ObjectHelper.Classes in '..\Utils\ObjectHelper.Classes.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  TGUITestRunner.runRegisteredTests;
end.
