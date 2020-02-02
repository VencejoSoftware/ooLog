{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LogFileNameFactory_test;

interface

uses
  Classes, SysUtils,
  LogFileNameFactory,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TLogFileNameFactoryTest = class sealed(TTestCase)
  published
    procedure EmptyFilePathRaiseError;
    procedure FilePathIsLog_Txt;
  end;

implementation

procedure TLogFileNameFactoryTest.EmptyFilePathRaiseError;
var
  Failed: Boolean;
begin
  Failed := False;
  try
    CheckEquals('.\log.txt', TLogFileNameFactory.New(' ').Build);
  except
    on E: Exception do
    begin
      CheckEquals('File path can not be empty', E.Message);
      Failed := True;
    end;
  end;
  CheckTrue(Failed);
end;

procedure TLogFileNameFactoryTest.FilePathIsLog_Txt;
begin
  CheckEquals('.\log.txt', TLogFileNameFactory.New('.\log.txt').Build);
end;

initialization

RegisterTests('LogFileFileFactory', [TLogFileNameFactoryTest {$IFNDEF FPC}.Suite {$ENDIF}]);

end.
