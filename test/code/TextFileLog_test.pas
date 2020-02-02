{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TextFileLog_test;

interface

uses
  Classes, SysUtils,
  LogMock,
  Log,
  LogFileNameFactory,
  TextFileLog,
{$IFDEF FPC}
  fpcunit, testregistry,
  RegExpr
{$ELSE}
  TestFramework,
  RegularExpressions
{$ENDIF};

type
  TTextFileLogTest = class sealed(TTestCase)
  const
    DATE_TIME_REGEX = '(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2}).(\d{3})';
  strict private
    _Log: ILog;
    _FileTemp: String;
  private
    function FileLine(const Index: Byte): String;
    function CountLines: Byte;
  public
    procedure SetUp; override;
    destructor Destroy; override;
  published
    procedure WriteDebugReturnFileLine1;
    procedure WriteInfoReturnFileLine2;
    procedure WriteWarningReturnFileLine3;
    procedure WriteErroReturnFileLine4;
    procedure ChangeFilterToErrorNotLogInFile;
    procedure RemoveInfoReturnDebugErrorWarningFilter;
  end;

implementation

function TTextFileLogTest.FileLine(const Index: Byte): String;
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    Strings.LoadFromFile(_FileTemp);
    Result := Strings[Index];
  finally
    Strings.Free;
  end;
end;

function TTextFileLogTest.CountLines: Byte;
var
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    Strings.LoadFromFile(_FileTemp);
    Result := Pred(Strings.Count);
  finally
    Strings.Free;
  end;
end;

procedure TTextFileLogTest.WriteDebugReturnFileLine1;
begin
  _Log.Write('Debug text', Debug);
{$IFDEF FPC}
  CheckTrue(TRegExpr.Create(DATE_TIME_REGEX + '\[DEBUG\]Debug text').Exec(FileLine(0)));
{$ELSE}
  CheckTrue(TRegEx.Create(DATE_TIME_REGEX + '\[DEBUG\]Debug text').IsMatch(FileLine(0)));
{$ENDIF}
end;

procedure TTextFileLogTest.WriteInfoReturnFileLine2;
begin
  _Log.Write('Info text', Info);
{$IFDEF FPC}
  CheckTrue(TRegExpr.Create(DATE_TIME_REGEX + '\[INFO\]Info text').Exec(FileLine(1)));
{$ELSE}
  CheckTrue(TRegEx.Create(DATE_TIME_REGEX + '\[INFO\]Info text').IsMatch(FileLine(1)));
{$ENDIF}
end;

procedure TTextFileLogTest.WriteWarningReturnFileLine3;
begin
  _Log.Write('Warning text', Warning);
{$IFDEF FPC}
  CheckTrue(TRegExpr.Create(DATE_TIME_REGEX + '\[WARNING\]Warning text').Exec(FileLine(2)));
{$ELSE}
  CheckTrue(TRegEx.Create(DATE_TIME_REGEX + '\[WARNING\]Warning text').IsMatch(FileLine(2)));
{$ENDIF}
end;

procedure TTextFileLogTest.WriteErroReturnFileLine4;
begin
  _Log.Write('Error text', Error);
{$IFDEF FPC}
  CheckTrue(TRegExpr.Create(DATE_TIME_REGEX + '\[ERROR\]Error text').Exec(FileLine(3)));
{$ELSE}
  CheckTrue(TRegEx.Create(DATE_TIME_REGEX + '\[ERROR\]Error text').IsMatch(FileLine(3)));
{$ENDIF}
end;

procedure TTextFileLogTest.ChangeFilterToErrorNotLogInFile;
begin
  _Log.ChangeFilter([Error]);
  _Log.Write('Debug skipped', Debug);
  _Log.Write('Info skipped', Info);
  _Log.Write('Warning skipped', Warning);
  CheckEquals(3, CountLines);
  _Log.Write('Error not skipped', Error);
  CheckEquals(4, CountLines);
end;

procedure TTextFileLogTest.RemoveInfoReturnDebugErrorWarningFilter;
begin
  _Log.ChangeFilter([Error, Warning, Debug]);
  CheckTrue(Error in _Log.Filter);
  CheckTrue(Debug in _Log.Filter);
  CheckTrue(Warning in _Log.Filter);
  CheckFalse(Info in _Log.Filter);
end;

procedure TTextFileLogTest.SetUp;
begin
  inherited;
  _Log := TTextFileLog.New(TLogFileNameFactory.New('.\error.log'));
  _FileTemp := '.\error.log';
end;

destructor TTextFileLogTest.Destroy;
begin
  if FileExists(_FileTemp) then
    DeleteFile(_FileTemp);
  inherited;
end;

initialization

RegisterTest(TTextFileLogTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
