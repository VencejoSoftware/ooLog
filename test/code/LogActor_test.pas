{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LogActor_test;

interface

uses
  SysUtils,
  InsensitiveTextMatch,
  LogMock,
  ScapeTranslate,
  Log,
  TemplateLog,
  LogActor,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TLogActorTest = class sealed(TTestCase)
  strict private
    _Log: ILog;
  public
    procedure SetUp; override;
  published
    procedure NotAssignedReturnLogEnabledFalse;
    procedure AssignedReturnObject;
    procedure LogDebugReturnLineText;
    procedure LogInfoReturnLineText;
    procedure LogErrorReturnExceptionMessage;
    procedure LogErrorWithRaiseReturnException;
    procedure LogErrorTextReturnLineText;
    procedure LogWarningReturnLineText;
  end;

implementation

procedure TLogActorTest.NotAssignedReturnLogEnabledFalse;
begin
  CheckFalse(TLogActor.New(nil).LogEnabled);
end;

procedure TLogActorTest.AssignedReturnObject;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  CheckTrue(Assigned(LogActor.Log));
end;

procedure TLogActorTest.LogDebugReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.LogDebug('Debug test');
  CheckEquals('[DEBUG]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Debug test', Trim(TLogMock(_Log).Strings.Text));
end;

procedure TLogActorTest.LogInfoReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.LogInfo('Info test');
  CheckEquals('[INFO]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Info test', Trim(TLogMock(_Log).Strings.Text));
end;

procedure TLogActorTest.LogErrorReturnExceptionMessage;
var
  LogActor: ILogActor;
  Error: Exception;
begin
  LogActor := TLogActor.New(_Log);
  Error := Exception.Create('Exception 1');
  try
    LogActor.LogError(Error, False);
  finally
    Error.Free;
  end;
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Exception 1', Trim(TLogMock(_Log).Strings.Text));
end;

procedure TLogActorTest.LogErrorWithRaiseReturnException;
var
  Failed: Boolean;
  LogActor: ILogActor;
  Error: Exception;
begin
  LogActor := TLogActor.New(_Log);
  Error := Exception.Create('Exception 1');
  try
    Failed := False;
    try
      LogActor.LogError(Error, True);
    except
      Failed := True;
    end;
    CheckTrue(Failed);
  finally
    Error.Free;
  end;
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Exception 1', Trim(TLogMock(_Log).Strings.Text));
end;

procedure TLogActorTest.LogErrorTextReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.LogErrorText('Error text test');
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Error text test', Trim(TLogMock(_Log).Strings.Text));
end;

procedure TLogActorTest.LogWarningReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.LogWarning('Warning test');
  CheckEquals('[WARNING]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Warning test', Trim(TLogMock(_Log).Strings.Text));
end;

procedure TLogActorTest.SetUp;
begin
  inherited;
  _Log := TLogMock.New(TTemplateLog.New('{App}[{LogLevel}]>>{Date} {TEXT}', TInsensitiveTextMatch.New));
end;

initialization

RegisterTest(TLogActorTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
