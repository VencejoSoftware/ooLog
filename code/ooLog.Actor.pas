{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLog.Actor;

interface

uses
  SysUtils,
  ooLogger.Intf;

type
  ILogActor = interface
    ['{8C88DA51-EC30-42AD-8CEE-B0731926E110}']
    function LogEnabled: Boolean;
    function Logger: ILogger;

    procedure LogDebug(const Text: String);
    procedure LogInfo(const Text: String);
    procedure LogError(const Error: Exception; const RaiseException: Boolean);
    procedure LogWarning(const Text: String);
  end;

  TLogActor = class(TInterfacedObject, ILogActor)
  strict private
    _Logger: ILogger;
  private
    procedure WriteLog(const Text: String; const LogLevel: TLogLevel);
  public
    function LogEnabled: Boolean;
    function Logger: ILogger;

    procedure LogDebug(const Text: String);
    procedure LogInfo(const Text: String);
    procedure LogError(const Error: Exception; const RaiseException: Boolean);
    procedure LogWarning(const Text: String);

    constructor Create(const Logger: ILogger); virtual;

    class function New(const Logger: ILogger): ILogActor;
  end;

implementation

function TLogActor.Logger: ILogger;
begin
  Result := _Logger;
end;

function TLogActor.LogEnabled: Boolean;
begin
  Result := Logger <> nil;
end;

procedure TLogActor.WriteLog(const Text: String; const LogLevel: TLogLevel);
begin
  if LogEnabled then
    Logger.Write(Text, LogLevel);
end;

procedure TLogActor.LogInfo(const Text: String);
begin
  WriteLog(Text, Info);
end;

procedure TLogActor.LogDebug(const Text: String);
begin
  WriteLog(Text, Debug);
end;

procedure TLogActor.LogWarning(const Text: String);
begin
  WriteLog(Text, Warning);
end;

procedure TLogActor.LogError(const Error: Exception; const RaiseException: Boolean);
begin
  WriteLog(Error.Message, TLogLevel.Error);
  if RaiseException then
    raise ExceptClass(Error.ClassType).Create(Error.Message);
end;

constructor TLogActor.Create(const Logger: ILogger);
begin
  _Logger := Logger;
end;

class function TLogActor.New(const Logger: ILogger): ILogActor;
begin
  Result := TLogActor.Create(Logger);
end;

end.
