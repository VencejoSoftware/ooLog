{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to store a list of dynamic tags
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TemplateTagListLog;

interface

uses
  Classes, SysUtils, Forms, DateUtils,
  IterableList,
  OSComputerName, OSUserName, OSLocalIP,
  Log,
  ParserConstant,
  ParserCallback,
  ParserVariable,
  ParserElement, ParserElementList;

type
{$REGION 'documentation'}
{
  @abstract(Object to store a list of dynamic tags)
  @member(
    UpdateDynamicTags Apply dynamic tags to text
    @param(Text Text to update)
    @param(LogLevel Log level of data log)
    @return(Text updated)
  )
}
{$ENDREGION}
  ITemplateTagListLog = interface(IParserElementList<IParserElement>)
    ['{CFEB68E0-FFFB-4E32-8A84-442CD96ECC7E}']
    procedure UpdateDynamicTags(const Text: String; const LogLevel: TLogLevel);
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ITemplateTagListLog))
  @member(UpdateDynamicTags @seealso(ITemplateTagListLog.UpdateDynamicTags))
  @member(FindByName @seealso(IParserElementList.FindByName))
  @member(GetTagAppTitle Callback to resolve tag info about application title)
  @member(GetTagApp Callback to resolve tag info about application name)
  @member(GetTagAppPath Callback to resolve tag info about current application path)
  @member(GetTagDate Callback to resolve tag info about current date)
  @member(GetTagDateTime Callback to resolve tag info about current date-time)
  @member(GetTagDay Callback to resolve tag info about current day)
  @member(GetTagHour Callback to resolve tag info about current hour)
  @member(GetTagIP Callback to resolve tag info about current OS PC IP address)
  @member(GetTagMiliSecond Callback to resolve tag info about current seconds)
  @member(GetTagMinute Callback to resolve tag info about current minutes)
  @member(GetTagMonth Callback to resolve tag info about current month)
  @member(GetTagPC Callback to resolve tag info about current OS PC name)
  @member(GetTagSecond Callback to resolve tag info about current second)
  @member(GetTagTime Callback to resolve tag info about current time)
  @member(GetTagUser Callback to resolve tag info about current OS username)
  @member(GetTagWeekMonth Callback to resolve tag info about current week month)
  @member(GetTagWeekYear Callback to resolve tag info about current week year)
  @member(GetTagYear Callback to resolve tag info about current year)
  @member(CreateTags Creates all supported tags)
  @member(LoadOSInfo Load only once the OS info tags)
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}
  TTemplateTagListLog = class sealed(TIterableList<IParserElement>, ITemplateTagListLog)
  strict private
  const
    DATE_FORMAT = 'DD/MM/YYYY';
    TIME_FORMAT = 'HH:NN:SS.ZZZ';
    DATE_TIME_FORMAT = DATE_FORMAT + ' ' + TIME_FORMAT;
    TAG_UPPER = 'UpperText';
    TAG_LOWER = 'LowerText';
    TAG_TEXT = 'Text';
    TAG_LEVEL = 'LogLevel';
  strict private
    _ComputerName, _UserName, _LocalIP: String;
  private
    function GetTagAppTitle(const Callback: IParserCallback): String;
    function GetTagApp(const Callback: IParserCallback): String;
    function GetTagAppPath(const Callback: IParserCallback): String;
    function GetTagDate(const Callback: IParserCallback): String;
    function GetTagDateTime(const Callback: IParserCallback): String;
    function GetTagDay(const Callback: IParserCallback): String;
    function GetTagHour(const Callback: IParserCallback): String;
    function GetTagIP(const Callback: IParserCallback): String;
    function GetTagMiliSecond(const Callback: IParserCallback): String;
    function GetTagMinute(const Callback: IParserCallback): String;
    function GetTagMonth(const Callback: IParserCallback): String;
    function GetTagPC(const Callback: IParserCallback): String;
    function GetTagSecond(const Callback: IParserCallback): String;
    function GetTagTime(const Callback: IParserCallback): String;
    function GetTagUser(const Callback: IParserCallback): String;
    function GetTagWeekMonth(const Callback: IParserCallback): String;
    function GetTagWeekYear(const Callback: IParserCallback): String;
    function GetTagYear(const Callback: IParserCallback): String;
    procedure CreateTags;
    procedure LoadOSInfo;
  public
    function FindByName(const Name: string): IParserElement;
    procedure UpdateDynamicTags(const Text: String; const LogLevel: TLogLevel);
    constructor Create; override;
    class function New: ITemplateTagListLog;
  end;

implementation

function TTemplateTagListLog.FindByName(const Name: string): IParserElement;
var
  Element: IParserElement;
begin
  Result := nil;
  for Element in Self do
    if CompareText(Element.Name, Name) = 0 then
      Exit(Element);
end;

function TTemplateTagListLog.GetTagWeekYear(const Callback: IParserCallback): String;
begin
  Result := Format('%.2d', [WeekOfTheYear(Date)]);
end;

function TTemplateTagListLog.GetTagWeekMonth(const Callback: IParserCallback): String;
begin
  Result := Format('%.2d', [WeekOfTheMonth(Date)]);
end;

function TTemplateTagListLog.GetTagDate(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime(DATE_FORMAT, Date);
end;

function TTemplateTagListLog.GetTagTime(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime(TIME_FORMAT, Time);
end;

function TTemplateTagListLog.GetTagDateTime(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime(DATE_TIME_FORMAT, Now);
end;

function TTemplateTagListLog.GetTagDay(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('DD', Date);
end;

function TTemplateTagListLog.GetTagMonth(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('MM', Date);
end;

function TTemplateTagListLog.GetTagYear(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('YYYY', Date);
end;

function TTemplateTagListLog.GetTagHour(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('HH', Time);
end;

function TTemplateTagListLog.GetTagMinute(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('NN', Time);
end;

function TTemplateTagListLog.GetTagSecond(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('SS', Time);
end;

function TTemplateTagListLog.GetTagMiliSecond(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('ZZZ', Time);
end;

function TTemplateTagListLog.GetTagAppTitle(const Callback: IParserCallback): String;
begin
  Result := Application.Title;
end;

function TTemplateTagListLog.GetTagApp(const Callback: IParserCallback): String;
begin
  Result := Application.Name;
end;

function TTemplateTagListLog.GetTagPC(const Callback: IParserCallback): String;
begin
  Result := _ComputerName;
end;

function TTemplateTagListLog.GetTagUser(const Callback: IParserCallback): String;
begin
  Result := _UserName;
end;

function TTemplateTagListLog.GetTagIP(const Callback: IParserCallback): String;
begin
  Result := _LocalIP;
end;

function TTemplateTagListLog.GetTagAppPath(const Callback: IParserCallback): String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

procedure TTemplateTagListLog.UpdateDynamicTags(const Text: String; const LogLevel: TLogLevel);
const
  LEVEL_TEXT: array [TLogLevel] of string = ('DEBUG', 'INFO', 'WARNING', 'ERROR');
begin
  IParserVariable(FindByName(TAG_UPPER)).ChangeValue(UpperCase(Text));
  IParserVariable(FindByName(TAG_LOWER)).ChangeValue(LowerCase(Text));
  IParserVariable(FindByName(TAG_TEXT)).ChangeValue(Text);
  IParserVariable(FindByName(TAG_LEVEL)).ChangeValue(LEVEL_TEXT[LogLevel]);
end;

procedure TTemplateTagListLog.LoadOSInfo;
begin
  _ComputerName := TOSComputerName.New.Value;
  _UserName := TOSUserName.New.Value;
  _LocalIP := TOSLocalIP.New.Value;
end;

procedure TTemplateTagListLog.CreateTags;
begin
  LoadOSInfo;
  Add(TParserVariable.New('WeekYear', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagWeekYear)));
  Add(TParserVariable.New('WeekMonth', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagWeekMonth)));
  Add(TParserVariable.New('Date', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagDate)));
  Add(TParserVariable.New('Time', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagTime)));
  Add(TParserVariable.New('DateTime', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagDateTime)));
  Add(TParserVariable.New('Day', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagDay)));
  Add(TParserVariable.New('Month', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagMonth)));
  Add(TParserVariable.New('Year', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagYear)));
  Add(TParserVariable.New('Hour', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagHour)));
  Add(TParserVariable.New('Minute', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagMinute)));
  Add(TParserVariable.New('Second', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagSecond)));
  Add(TParserVariable.New('MiliSecond', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagMiliSecond)));
  Add(TParserVariable.New('App', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagApp)));
  Add(TParserVariable.New('AppTitle', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagAppTitle)));
  Add(TParserVariable.New('PC', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagPC)));
  Add(TParserVariable.New('User', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagUser)));
  Add(TParserVariable.New('IP', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagIP)));
  Add(TParserVariable.New('AppPath', TParserCallback.{$IFDEF FPC}NewOfObject{$ELSE}New{$ENDIF}(GetTagAppPath)));
  Add(TParserVariable.New(TAG_UPPER, nil));
  Add(TParserVariable.New(TAG_LOWER, nil));
  Add(TParserVariable.New(TAG_TEXT, nil));
  Add(TParserVariable.New(TAG_LEVEL, nil));
end;

constructor TTemplateTagListLog.Create;
begin
  inherited;
  LoadOSInfo;
  CreateTags;
end;

class function TTemplateTagListLog.New: ITemplateTagListLog;
begin
  Result := TTemplateTagListLog.Create;
end;

end.
