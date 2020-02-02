{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TemplateScapeListLog_test;

interface

uses
  SysUtils,
  ScapeTranslate, ScapeTranslateList,
  TemplateScapeListLog,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TemplateScapeListLogTest = class sealed(TTestCase)
  published
    procedure ApplyForTextReturnCRLFSymbols;
    procedure NewScapeTranslateReturnBSymbol;
  end;

implementation

procedure TemplateScapeListLogTest.ApplyForTextReturnCRLFSymbols;
var
  ScapeListLog: IScapeTranslateList;
begin
  ScapeListLog := TTemplateScapeListLog.New;
  CheckEquals('{#13}Test{#13}{#10}', ScapeListLog.Apply(#13'Test'#13#10));
end;

procedure TemplateScapeListLogTest.NewScapeTranslateReturnBSymbol;
var
  ScapeListLog: IScapeTranslateList;
begin
  ScapeListLog := TTemplateScapeListLog.New;
  ScapeListLog.Add(TScapeTranslate.New(#9, '{#9}'));
  CheckEquals('{#13}Test{#9}{#13}{#10}', ScapeListLog.Apply(#13'Test'#9#13#10));
end;

initialization

RegisterTest(TemplateScapeListLogTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
