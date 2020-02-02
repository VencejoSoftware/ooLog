{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LogFileUniqueNameFactory_test;

interface

uses
  Classes, SysUtils,
  LogFileUniqueNameFactory,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TLogFileUniqueNameFactoryTest = class sealed(TTestCase)
  published
    procedure FilePathIsLog_Txt;
  end;

implementation

procedure TLogFileUniqueNameFactoryTest.FilePathIsLog_Txt;
begin
  CheckEquals('log_' + FormatDateTime('dd_mm_yyyy', Date) + '.txt', TLogFileTemplatedNameFactory.New('log.txt').Build);
end;

initialization

RegisterTests('LogFileFileFactory', [TLogFileUniqueNameFactoryTest {$IFNDEF FPC}.Suite {$ENDIF}]);

end.
