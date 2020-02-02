{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TemplateLog_test;

interface

uses
  SysUtils,
  InsensitiveTextMatch,
  ScapeTranslate,
  Log,
  TemplateLog,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TemplateLogTest = class sealed(TTestCase)
  published
    procedure TestSeverity;
    procedure TestTextCrLf;
    procedure TestAnotherScape;
    procedure TestLowerText;
    procedure TestText;
    procedure TestUpperText;
  end;

implementation

procedure TemplateLogTest.TestSeverity;
const
  SEVERITY_TEXT: array [TLogSeverity] of string = ('DEBUG', 'INFO', 'WARNING', 'ERROR');
begin
  CheckEquals('DEBUG', TTemplateLog.New('{Severity}', TInsensitiveTextMatch.New).Build(EmptyStr, Debug));
  CheckEquals('INFO', TTemplateLog.New('{Severity}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
  CheckEquals('WARNING', TTemplateLog.New('{Severity}', TInsensitiveTextMatch.New).Build(EmptyStr, Warning));
  CheckEquals('ERROR', TTemplateLog.New('{Severity}', TInsensitiveTextMatch.New).Build(EmptyStr, Error));
end;

procedure TemplateLogTest.TestTextCrLf;
begin
  CheckEquals('First line{#13}{#10}Second line{#13}{#10}Third line',
    TTemplateLog.New('{Text}', TInsensitiveTextMatch.New).Build('First line' + sLineBreak + 'Second line' + sLineBreak +
    'Third line', Info));
end;

procedure TemplateLogTest.TestUpperText;
begin
  CheckEquals('LOG INFO UPPERED', TTemplateLog.New('{UpperText}', TInsensitiveTextMatch.New)
    .Build('Log info uppered', Info));
end;

procedure TemplateLogTest.TestLowerText;
begin
  CheckEquals('log info lowered', TTemplateLog.New('{LowerText}', TInsensitiveTextMatch.New)
    .Build('Log info LOWERED', Info));
end;

procedure TemplateLogTest.TestText;
begin
  CheckEquals('Log info NoRmAl', TTemplateLog.New('{Text}', TInsensitiveTextMatch.New).Build('Log info NoRmAl', Info));
end;

procedure TemplateLogTest.TestAnotherScape;
var
  TemplateLog: ITemplateLog;
begin
  TemplateLog := TTemplateLog.New('{Text}', TInsensitiveTextMatch.New);
  TemplateLog.ScapeList.Add(TScapeTranslate.New(Chr(9), '{TAB}'));
  CheckEquals('One text{TAB}two text', TemplateLog.Build('One text' + Chr(9) + 'two text', Info));
end;

initialization

RegisterTest(TemplateLogTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
