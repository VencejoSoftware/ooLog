{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  Forms,
  RunTest,
  Log in '..\..\code\Log.pas',
  LogActor in '..\..\code\LogActor.pas',
  TextFileLog in '..\..\code\TextFileLog.pas',
  TemplateLog in '..\..\code\TemplateLog.pas',
  TemplateScapeListLog in '..\..\code\TemplateScapeListLog.pas',
  TemplateTagListLog in '..\..\code\TemplateTagListLog.pas',
  TemplateLog_test in '..\code\TemplateLog_test.pas',
  TemplateScapeListLog_test in '..\code\TemplateScapeListLog_test.pas',
  LogActor_test in '..\code\LogActor_test.pas',
  TextFileLog_test in '..\code\TextFileLog_test.pas',
  TemplateTagListLog_test in '..\code\TemplateTagListLog_test.pas',
  LogMock in '..\code\mock\LogMock.pas',
  TemplateTextFileLog in '..\..\code\TemplateTextFileLog.pas',
  TemplateTextFileLog_test in '..\code\TemplateTextFileLog_test.pas',
  ConsoleLog in '..\..\code\ConsoleLog.pas',
  MultipleLog in '..\..\code\MultipleLog.pas';

{R *.RES}

begin
  Run;

end.
