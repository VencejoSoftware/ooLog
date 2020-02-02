{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Logger object
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit Log;

interface

uses
  SysUtils;

type
{$REGION 'documentation'}
{
  Enum for log severity
  @value Debug log severity
  @value Info Ascending log severity
  @value Warning Descending log severity
  @value Error Descending log severity
}
{$ENDREGION}
  TLogSeverity = (Debug, Info, Warning, Error);
{$REGION 'documentation'}
{
  @abstract(Log severity filters)
}
{$ENDREGION}
  TLogSeverityFilter = set of TLogSeverity;

{$REGION 'documentation'}
{
  @abstract(Logger object)
  Object to log text in a storage
  @member(
    Filter Log severity filter to store
    @return(@link(TLogSeverityFilter Severity filter))
  )
  @member(
    ChangeFilter Set the current severity filter
    @param(Filter @link(TLogSeverityFilter Severity filter))
  )
  @member(
    Write Try to store the log text
    @param(Text Text to log)
    @param(Filter @link(TLogSeverityFilter Severity filter))
  )
}
{$ENDREGION}

  ILog = interface
    ['{8C88DA51-EC30-42AD-8CEE-B0731926E110}']
    function Filter: TLogSeverityFilter;
    procedure ChangeFilter(const Filter: TLogSeverityFilter);
    procedure Write(const Text: String; const Severity: TLogSeverity);
  end;

{$REGION 'documentation'}
{
  @abstract(Severity helper for cast data types)
  @member(ToString Cast severity enum to string)
  @member(
    FromString Tries to get enum value from string. Raise error if not match
    @param(Text String to convert)
  )
}
{$ENDREGION}

  TLogSeverityHelper = record helper for TLogSeverity
  strict private
  const
    SEVERITY_TEXT: array [TLogSeverity] of string = ('DEBUG', 'INFO', 'WARNING', 'ERROR');
  public
    function ToString: string;
    procedure FromString(const Text: String);
  end;

{$REGION 'documentation'}
{
  @abstract(Callback to log server actions)
  @param(Text String to log)
  @param(Severity Event severity)
}
{$ENDREGION}
{$IFDEF FPC}

  TLogCallback = procedure(const Text: String; const Severity: TLogSeverity = Info);
  TLogCallbackOfObject = procedure(const Text: String; const Severity: TLogSeverity = Info) of object;
{$ELSE}
  TLogCallback = reference to procedure(const Text: String; const Severity: TLogSeverity = Info);
{$ENDIF}
{$REGION 'documentation'}
{
  @abstract(Callback executed before text is written in log to parse it if need)
  @param(Text String to log)
  @param(Severity Event severity)
  @return(Text With string to write parsed)
}
{$ENDREGION}
{$IFDEF FPC}
  TLogParseTextCallback = function(const Text: String; const Severity: TLogSeverity = Info): String;
  TLogParseTextCallbackOfObject = function(const Text: String; const Severity: TLogSeverity = Info): String of object;
{$ELSE}
  TLogParseTextCallback = reference to function(const Text: String; const Severity: TLogSeverity = Info): String;
{$ENDIF}

implementation

{ TLogSeverityHelper }

procedure TLogSeverityHelper.FromString(const Text: String);
var
  Item: TLogSeverity;
begin
  for Item := Low(TLogSeverity) to High(TLogSeverity) do
    if SameText(Text, SEVERITY_TEXT[Item]) then
    begin
      Self := Item;
      Exit;
    end;
  raise Exception.Create(Format('Invalid severity value: "%s"', [Text]));
end;

function TLogSeverityHelper.ToString: string;
begin
  Result := SEVERITY_TEXT[Self];
end;

end.
