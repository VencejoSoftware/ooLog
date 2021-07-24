{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Multiple logger object
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit MultipleLog;

interface

uses
  IterableList,
  Log;

type
{$REGION 'documentation'}
{
  @abstract(Log list interface)
}
{$ENDREGION}
  ILogList = interface(IIterableList<ILog>)
  end;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILogList))
  @member(New Create a new @classname as interface)
}
{$ENDREGION}
  TLogList = class sealed(TIterableList<ILog>, ILogList)
  public
    class function New: ILogList;
  end;

{$REGION 'documentation'}
{
  @abstract(Multiple log interface)
  @member(
    Logs @link(ILogList Log list object)
  )
}
{$ENDREGION}

  IMultipleLog = interface(ILog)
    ['{CC7205B2-06D1-4E3B-A20F-49B681718059}']
    function Logs: ILogList;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IMultipleLog))
  @member(Filter @seealso(ILog.Filter))
  @member(ChangeFilter @seealso(ILog.ChangeFilter))
  @member(
    Write Call write for each log in loglist
    @seealso(ILog.Write)
  )
  @member(Logs @seealso(IMultipleLog.Logs))
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}

  TMultipleLog = class sealed(TInterfacedObject, IMultipleLog, ILog)
  strict private
    _Filter: TLogSeverityFilter;
    _Logs: ILogList;
  public
    function Filter: TLogSeverityFilter;
    function Logs: ILogList;
    procedure ChangeFilter(const Filter: TLogSeverityFilter);
    procedure Write(const Text: String; const Severity: TLogSeverity);
    constructor Create;
    class function New: IMultipleLog;
  end;

implementation

function TMultipleLog.Filter: TLogSeverityFilter;
begin
  Result := _Filter;
end;

function TMultipleLog.Logs: ILogList;
begin
  Result := _Logs;
end;

procedure TMultipleLog.ChangeFilter(const Filter: TLogSeverityFilter);
var
  Log: ILog;
begin
  _Filter := Filter;
  for Log in _Logs do
    Log.ChangeFilter(Filter);
end;

procedure TMultipleLog.Write(const Text: String; const Severity: TLogSeverity);
var
  Log: ILog;
begin
  if not (Severity in _Filter) then
    Exit;
  for Log in _Logs do
    Log.Write(Text, Severity);
end;

constructor TMultipleLog.Create;
begin
  _Logs := TLogList.New;
  ChangeFilter([Debug, Info, Warning, Error]);
end;

class function TMultipleLog.New: IMultipleLog;
begin
  Result := TMultipleLog.Create;
end;

{ TLogList }

class function TLogList.New: ILogList;
begin
  Result := TLogList.Create;
end;

end.
