{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to encapsulta the log actions
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit LogActor;

interface

uses
  SysUtils,
  Log;

type
{$REGION 'documentation'}
{
  @abstract(Object to encapsulta the log actions)
  @member(
    LogEnabled Checks if log is assigned to use
  )
  @member(
    Log Master log object
    @return(@link(ILog Log object))
  )
  @member(
    LogDebug Log text in debug level
    @param(Text Text to write)
  )
  @member(
    LogInfo Log text in info level
    @param(Text Text to write)
  )
  @member(
    LogError Write error text based on exception object
    @param(Error Exception object)
    @param(RaiseException Raise exception after log)
  )
  @member(
    LogErrorText Log text in error level
    @param(Text Text to write)
  )
  @member(
    LogWarning Log text in warning level
    @param(Text Text to write)
  )
}
{$ENDREGION}
  ILogActor = interface
    ['{8C88DA51-EC30-42AD-8CEE-B0731926E110}']
    function LogEnabled: Boolean;
    function Log: ILog;
    procedure LogDebug(const Text: String);
    procedure LogInfo(const Text: String);
    procedure LogError(const Error: Exception; const RaiseException: Boolean);
    procedure LogErrorText(const Text: String);
    procedure LogWarning(const Text: String);
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILogActor))
  @member(LogEnabled @seealso(ILogActor.LogEnabled))
  @member(Log @seealso(ILogActor.Log))
  @member(LogDebug @seealso(ILogActor.LogDebug))
  @member(LogInfo @seealso(ILogActor.LogInfo))
  @member(LogError @seealso(ILogActor.LogError))
  @member(LogErrorText @seealso(ILogActor.LogErrorText))
  @member(LogWarning @seealso(ILogActor.LogWarning))
  @member(
    WriteLog Parse and write log text
    @param(Text Text to log)
    @param(LogLevel Level of log)
  )
  @member(
    Create Object constructor
    @param(@link(ILog Log object))
  )
  @member(
    New Create a new @classname as interface
    @param(@link(ILog Log object))
  )
}
{$ENDREGION}
  TLogActor = class(TInterfacedObject, ILogActor)
  strict private
    _Logger: ILog;
  private
    procedure WriteLog(const Text: String; const LogLevel: TLogLevel);
  public
    function LogEnabled: Boolean;
    function Log: ILog;
    procedure LogDebug(const Text: String);
    procedure LogInfo(const Text: String);
    procedure LogError(const Error: Exception; const RaiseException: Boolean);
    procedure LogErrorText(const Text: String);
    procedure LogWarning(const Text: String);
    constructor Create(const Log: ILog); virtual;
    class function New(const Log: ILog): ILogActor;
  end;

implementation

function TLogActor.Log: ILog;
begin
  Result := _Logger;
end;

function TLogActor.LogEnabled: Boolean;
begin
  Result := Log <> nil;
end;

procedure TLogActor.WriteLog(const Text: String; const LogLevel: TLogLevel);
begin
  if LogEnabled then
    Log.Write(Text, LogLevel);
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

procedure TLogActor.LogErrorText(const Text: String);
begin
  WriteLog(Text, TLogLevel.Error);
end;

constructor TLogActor.Create(const Log: ILog);
begin
  _Logger := Log;
end;

class function TLogActor.New(const Log: ILog): ILogActor;
begin
  Result := TLogActor.Create(Log);
end;

end.
