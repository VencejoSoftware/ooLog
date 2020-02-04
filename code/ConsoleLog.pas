{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Console log interface
  @created(02/01/2020)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ConsoleLog;

interface

uses
  SysUtils, SyncObjs,
  Console, ConsoleColor,
  Log;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILog))
  Object to display data log in a console/terminal
  @member(
    WriteInFile Internal method to write in file
    @param(Text String to write in log)
    @param(Severity Event severity mark)
  )
  @member(
    SanitizeText Replaces incomprensible characters to file-compatible values
    @param(Text String to sanitize)
    @return(Sanitized string)
  )
  @member(
    OnApplyConsoleTextTagStyle Console callback when tag founded to set style
    @param(Text Full text)
    @param(Tag Tag content founded)
    @param(TextColor Pointer to text color to change)
    @param(BackColor Pointer to background color to change)
  )
  @member(
    Create Object constructor
    @param(FilePath File path to use)
  )
  @member(
    New Create a new @classname as interface
    @param(FilePath File path to use)
  )
}
{$ENDREGION}
  TConsoleLog = class sealed(TInterfacedObject, ILog)
  strict private
    _Filter: TLogSeverityFilter;
    _Console: IConsole;
    _OnApplyConsoleTextTagStyle: TOnApplyConsoleTextTagStyle;
{$IFDEF FPC}
    _OnApplyConsoleTextTagStyleOfObject: TOnApplyConsoleTextTagStyleOfObject;
{$ENDIF}
  private
    function SanitizeText(const Text: String): String;
    procedure OnApplyConsoleTextTagStyle(const Text: String; var Tag: String; var TextColor, BackColor: TConsoleColor);
  public
    function Filter: TLogSeverityFilter;
    procedure ChangeFilter(const Filter: TLogSeverityFilter);
    procedure Write(const Text: String; const Severity: TLogSeverity = Info);
    constructor Create(const OnApplyConsoleTextTagStyle: TOnApplyConsoleTextTagStyle
{$IFDEF FPC}; const OnStyleOfObject: TOnApplyConsoleTextTagStyleOfObject{$ENDIF});
    class function New(const OnApplyConsoleTextTagStyle: TOnApplyConsoleTextTagStyle
{$IFDEF FPC}; const OnStyleOfObject: TOnApplyConsoleTextTagStyleOfObject{$ENDIF}): ILog;
  end;

implementation

function TConsoleLog.Filter: TLogSeverityFilter;
begin
  Result := _Filter;
end;

procedure TConsoleLog.ChangeFilter(const Filter: TLogSeverityFilter);
begin
  _Filter := Filter;
end;

function TConsoleLog.SanitizeText(const Text: String): String;
begin
  Result := Text;
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\n', [rfReplaceAll]);
  Result := Result + sLineBreak;
end;

procedure TConsoleLog.OnApplyConsoleTextTagStyle(const Text: String; var Tag: String;
  var TextColor, BackColor: TConsoleColor);
const
  SEVERITY_COLOR: array [TLogSeverity] of TConsoleColor = (Green, Magenta, Brown, Red);
var
  Severity: TLogSeverity;
begin
  if Assigned(_OnApplyConsoleTextTagStyle) then
    _OnApplyConsoleTextTagStyle(Text, Tag, TextColor, BackColor);
  for Severity := Low(TLogSeverity) to High(TLogSeverity) do
    if Severity.ToString = Tag then
    begin
      TextColor := SEVERITY_COLOR[Severity];
      Break;
    end;
end;

procedure TConsoleLog.Write(const Text: String; const Severity: TLogSeverity);
begin
  if not (Severity in _Filter) then
    Exit;
  _Console.WriteStyledText(FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now), DarkGray, Null);
{$IFDEF FPC}
  _Console.WriteTaggedText(Format('[%s]%s', [Severity.ToString, SanitizeText(Text)]), '[', ']', nil,
    OnApplyConsoleTextTagStyle);
{$ELSE}
  _Console.WriteTaggedText(Format('[%s]%s', [Severity.ToString, SanitizeText(Text)]), '[', ']',
    OnApplyConsoleTextTagStyle);
{$ENDIF}
end;

constructor TConsoleLog.Create(const OnApplyConsoleTextTagStyle: TOnApplyConsoleTextTagStyle
{$IFDEF FPC}; const OnStyleOfObject: TOnApplyConsoleTextTagStyleOfObject{$ENDIF});
begin
  _Console := TConsole.New;
  ChangeFilter([Debug, Info, Warning, Error]);
  _OnApplyConsoleTextTagStyle := OnApplyConsoleTextTagStyle;
{$IFDEF FPC}
  _OnApplyConsoleTextTagStyleOfObject := OnStyleOfObject;
{$ENDIF}
end;

class function TConsoleLog.New(const OnApplyConsoleTextTagStyle: TOnApplyConsoleTextTagStyle
{$IFDEF FPC}; const OnStyleOfObject: TOnApplyConsoleTextTagStyleOfObject{$ENDIF}): ILog;
begin
  Result := TConsoleLog.Create(OnApplyConsoleTextTagStyle {$IFDEF FPC}, OnStyleOfObject{$ENDIF});
end;

end.
