{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
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
  LogMock in '..\code\mock\LogMock.pas';

{R *.RES}

begin
  Run;

end.
