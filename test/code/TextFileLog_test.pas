{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TextFileLog_test;

interface

uses
  Classes, SysUtils,
  InsensitiveTextMatch,
  LogMock,
  ScapeTranslate,
  Log,
  TemplateLog,
  TextFileLog,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TTextFileLogTest = class sealed(TTestCase)
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
  CheckEquals('[DEBUG]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Debug text', FileLine(0));
end;

procedure TTextFileLogTest.WriteInfoReturnFileLine2;
begin
  _Log.Write('Info text', Info);
  CheckEquals('[INFO]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Info text', FileLine(1));
end;

procedure TTextFileLogTest.WriteWarningReturnFileLine3;
begin
  _Log.Write('Warning text', Warning);
  CheckEquals('[WARNING]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Warning text', FileLine(2));
end;

procedure TTextFileLogTest.WriteErroReturnFileLine4;
begin
  _Log.Write('Error text', Error);
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Error text', FileLine(3));
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
var
  TemplateFile, InfoTemplate: ITemplateLog;
begin
  inherited;
  TemplateFile := TTemplateLog.New('{AppPath}test.log', TInsensitiveTextMatch.New);
  InfoTemplate := TTemplateLog.New('{App}[{LogLevel}]>>{Date} {TEXT}', TInsensitiveTextMatch.New);
  _Log := TTextFileLog.New(TemplateFile, InfoTemplate);
  _FileTemp := TemplateFile.Build;
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
