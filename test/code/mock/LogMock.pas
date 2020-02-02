{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit LogMock;

interface

uses
  Classes, SysUtils,
  Log,
  TemplateLog;

type
  TLogMock = class sealed(TInterfacedObject, ILog)
  strict private
    _Strings: TStringList;
    _TemplateLog: ITemplateLog;
    _Filter: TLogSeverityFilter;
  public
    function Filter: TLogSeverityFilter;
    function Strings: TStringList;
    procedure ChangeFilter(const Filter: TLogSeverityFilter);
    procedure Write(const Text: string; const Severity: TLogSeverity); virtual;
    constructor Create(const TemplateLog: ITemplateLog); virtual;
    destructor Destroy; override;
    class function New(const TemplateLog: ITemplateLog): ILog;
  end;

implementation

function TLogMock.Strings: TStringList;
begin
  Result := _Strings;
end;

function TLogMock.Filter: TLogSeverityFilter;
begin
  Result := _Filter;
end;

procedure TLogMock.Write(const Text: string; const Severity: TLogSeverity);
begin
  if Severity in _Filter then
    _Strings.Add(_TemplateLog.Build(Text, Severity));
end;

procedure TLogMock.ChangeFilter(const Filter: TLogSeverityFilter);
begin
  _Filter := Filter;
end;

constructor TLogMock.Create(const TemplateLog: ITemplateLog);
begin
  inherited Create;
  _Strings := TStringList.Create;
  _TemplateLog := TemplateLog;
  ChangeFilter([Debug, Info, Warning, Error]);
end;

destructor TLogMock.Destroy;
begin
  _Strings.Free;
  inherited;
end;

class function TLogMock.New(const TemplateLog: ITemplateLog): ILog;
begin
  Result := TLogMock.Create(TemplateLog);
end;

end.
