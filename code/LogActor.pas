{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
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
    WriteDebug Log text in debug severity
    @param(Text Text to write)
  )
  @member(
    WriteInfo Log text in info severity
    @param(Text Text to write)
  )
  @member(
    WriteException Write error text based on exception object
    @param(Error Exception object)
    @param(RaiseException Raise exception after log)
  )
  @member(
    WriteError Log text in error severity
    @param(Text Text to write)
  )
  @member(
    WriteWarning Log text in warning severity
    @param(Text Text to write)
  )
}
{$ENDREGION}
  ILogActor = interface
    ['{8C88DA51-EC30-42AD-8CEE-B0731926E110}']
    function LogEnabled: Boolean;
    function Log: ILog;
    procedure WriteDebug(const Text: String);
    procedure WriteInfo(const Text: String);
    procedure WriteException(const Error: Exception; const RaiseException: Boolean);
    procedure WriteError(const Text: String);
    procedure WriteWarning(const Text: String);
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILogActor))
  @member(LogEnabled @seealso(ILogActor.LogEnabled))
  @member(Log @seealso(ILogActor.Log))
  @member(WriteDebug @seealso(ILogActor.WriteDebug))
  @member(WriteInfo @seealso(ILogActor.WriteInfo))
  @member(WriteException @seealso(ILogActor.WriteException))
  @member(WriteError @seealso(ILogActor.WriteError))
  @member(WriteWarning @seealso(ILogActor.WriteWarning))
  @member(
    WriteLog Parse and write log text
    @param(Text Text to log)
    @param(Severity Severity of log)
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
    procedure WriteLog(const Text: String; const Severity: TLogSeverity);
  public
    function LogEnabled: Boolean;
    function Log: ILog;
    procedure WriteDebug(const Text: String);
    procedure WriteInfo(const Text: String);
    procedure WriteException(const Error: Exception; const RaiseException: Boolean);
    procedure WriteError(const Text: String);
    procedure WriteWarning(const Text: String);
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

procedure TLogActor.WriteLog(const Text: String; const Severity: TLogSeverity);
begin
  if LogEnabled then
    Log.Write(Text, Severity);
end;

procedure TLogActor.WriteInfo(const Text: String);
begin
  WriteLog(Text, Info);
end;

procedure TLogActor.WriteDebug(const Text: String);
begin
  WriteLog(Text, Debug);
end;

procedure TLogActor.WriteWarning(const Text: String);
begin
  WriteLog(Text, Warning);
end;

procedure TLogActor.WriteException(const Error: Exception; const RaiseException: Boolean);
begin
  WriteLog(Error.Message, TLogSeverity.Error);
  if RaiseException then
    raise ExceptClass(Error.ClassType).Create(Error.Message);
end;

procedure TLogActor.WriteError(const Text: String);
begin
  WriteLog(Text, TLogSeverity.Error);
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
