{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LogActor_test;

interface

{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

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
    procedure WriteDebugReturnLineText;
    procedure WriteInfoReturnLineText;
    procedure WriteExceptionReturnExceptionMessage;
    procedure WriteExceptionWithRaiseReturnException;
    procedure WriteErrorReturnLineText;
    procedure WriteWarningReturnLineText;
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

procedure TLogActorTest.WriteDebugReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.WriteDebug('Debug test');
  CheckEquals('[DEBUG]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Debug test', Trim((_Log as TLogMock).Strings.Text));
end;

procedure TLogActorTest.WriteInfoReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.WriteInfo('Info test');
  CheckEquals('[INFO]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Info test', Trim((_Log as TLogMock).Strings.Text));
end;

procedure TLogActorTest.WriteExceptionReturnExceptionMessage;
var
  LogActor: ILogActor;
  Error: Exception;
begin
  LogActor := TLogActor.New(_Log);
  Error := Exception.Create('Exception 1');
  try
    LogActor.WriteException(Error, False);
  finally
    Error.Free;
  end;
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Exception 1', Trim((_Log as TLogMock).Strings.Text));
end;

procedure TLogActorTest.WriteExceptionWithRaiseReturnException;
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
      LogActor.WriteException(Error, True);
    except
      Failed := True;
    end;
    CheckTrue(Failed);
  finally
    Error.Free;
  end;
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Exception 1', Trim((_Log as TLogMock).Strings.Text));
end;

procedure TLogActorTest.WriteErrorReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.WriteError('Error text test');
  CheckEquals('[ERROR]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Error text test',
    Trim((_Log as TLogMock).Strings.Text));
end;

procedure TLogActorTest.WriteWarningReturnLineText;
var
  LogActor: ILogActor;
begin
  LogActor := TLogActor.New(_Log);
  LogActor.WriteWarning('Warning test');
  CheckEquals('[WARNING]>>' + FormatDateTime('dd/mm/yyyy', Date) + ' Warning test',
    Trim((_Log as TLogMock).Strings.Text));
end;

procedure TLogActorTest.SetUp;
begin
  inherited;
  _Log := TLogMock.New(TTemplateLog.New('{App}[{Severity}]>>{Date} {TEXT}', TInsensitiveTextMatch.New));
end;

initialization

RegisterTest(TLogActorTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
