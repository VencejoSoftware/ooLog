{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LogFileTemplatedNameFactory_test;

interface

uses
  Classes, SysUtils,
  InsensitiveTextMatch,
  TemplateLog,
  LogFileTemplatedNameFactory,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TLogFileTemplatedNameFactoryTest = class sealed(TTestCase)
  published
    procedure FilePathIsLog_Txt;
  end;

implementation

procedure TLogFileTemplatedNameFactoryTest.FilePathIsLog_Txt;
begin
  CheckEquals(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'test.log',
    TLogFileTemplatedNameFactory.New(TTemplateLog.New('{AppPath}test.log', TInsensitiveTextMatch.New)).Build);
end;

initialization

RegisterTests('LogFileFileFactory', [TLogFileTemplatedNameFactoryTest {$IFNDEF FPC}.Suite {$ENDIF}]);

end.
