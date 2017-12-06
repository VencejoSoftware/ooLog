{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLog.Template.TagList;

interface

uses
  Classes, SysUtils, Forms, DateUtils,
  ooOS.ComputerName, ooOS.UserName, ooOS.LocalIP,
  ooLogger.Intf,
  ooParser.Constant,
  ooParser.Callback,
  ooParser.Variable,
  ooParser.Item.List,
  ooLog.Template.TagList.Intf, ooTemplateParser.Tag.List;

type
  TLogTemplateTagList = class sealed(TInterfacedObject, ILogTemplateTagList)
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
    _LogTemplateTagList: ITemplateTagList;
  private
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
    function GetTagUpperText(const Callback: IParserCallback): String;
    function GetTagLowerText(const Callback: IParserCallback): String;
    function GetTagText(const Callback: IParserCallback): String;
    function GetTagLogLevel(const Callback: IParserCallback): String;

    procedure CreateTags;
    procedure LoadOSInfo;
  public
    function FindByName(const Name: string): IParserVariable;
    function Add(const Item: IParserVariable): Integer;
    function Count: Integer;
    function Item(const Index: Integer): IParserVariable;

    procedure Clear;
    procedure UpdateDynamicTags(const Text: String; const LogLevel: TLogLevel);

    constructor Create;

    class function New: ILogTemplateTagList;
  end;

implementation

function TLogTemplateTagList.Item(const Index: Integer): IParserVariable;
begin
  Result := _LogTemplateTagList.Item(Index);
end;

function TLogTemplateTagList.Add(const Item: IParserVariable): Integer;
begin
  Result := _LogTemplateTagList.Add(Item);
end;

procedure TLogTemplateTagList.Clear;
begin
  _LogTemplateTagList.Clear;
end;

function TLogTemplateTagList.Count: Integer;
begin
  Result := _LogTemplateTagList.Count;
end;

function TLogTemplateTagList.FindByName(const Name: string): IParserVariable;
begin
  Result := _LogTemplateTagList.FindByName(Name);
end;

function TLogTemplateTagList.GetTagWeekYear(const Callback: IParserCallback): String;
begin
  Result := Format('%.2d', [WeekOfTheYear(Date)]);
end;

function TLogTemplateTagList.GetTagWeekMonth(const Callback: IParserCallback): String;
begin
  Result := Format('%.2d', [WeekOfTheMonth(Date)]);
end;

function TLogTemplateTagList.GetTagDate(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime(DATE_FORMAT, Date);
end;

function TLogTemplateTagList.GetTagTime(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime(TIME_FORMAT, Time);
end;

function TLogTemplateTagList.GetTagDateTime(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime(DATE_TIME_FORMAT, Now);
end;

function TLogTemplateTagList.GetTagDay(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('DD', Date);
end;

function TLogTemplateTagList.GetTagMonth(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('MM', Date);
end;

function TLogTemplateTagList.GetTagYear(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('YYYY', Date);
end;

function TLogTemplateTagList.GetTagHour(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('HH', Time);
end;

function TLogTemplateTagList.GetTagMinute(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('NN', Time);
end;

function TLogTemplateTagList.GetTagSecond(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('SS', Time);
end;

function TLogTemplateTagList.GetTagMiliSecond(const Callback: IParserCallback): String;
begin
  Result := FormatDateTime('ZZZ', Time);
end;

function TLogTemplateTagList.GetTagApp(const Callback: IParserCallback): String;
begin
  Result := Application.Title;
end;

function TLogTemplateTagList.GetTagPC(const Callback: IParserCallback): String;
begin
  Result := _ComputerName;
end;

function TLogTemplateTagList.GetTagUser(const Callback: IParserCallback): String;
begin
  Result := _UserName;
end;

function TLogTemplateTagList.GetTagIP(const Callback: IParserCallback): String;
begin
  Result := _LocalIP;
end;

function TLogTemplateTagList.GetTagAppPath(const Callback: IParserCallback): String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
end;

function TLogTemplateTagList.GetTagUpperText(const Callback: IParserCallback): String;
begin
  Result := UpperCase(Callback.ParameterList.ValueByName(TAG_TEXT));
end;

function TLogTemplateTagList.GetTagLowerText(const Callback: IParserCallback): String;
begin
  Result := LowerCase(Callback.ParameterList.ValueByName(TAG_TEXT));
end;

function TLogTemplateTagList.GetTagText(const Callback: IParserCallback): String;
begin
  Result := Callback.ParameterList.ValueByName(TAG_TEXT);
end;

function TLogTemplateTagList.GetTagLogLevel(const Callback: IParserCallback): String;
begin
  Result := Callback.ParameterList.ValueByName('LevelText');
end;

procedure TLogTemplateTagList.UpdateDynamicTags(const Text: String; const LogLevel: TLogLevel);
const
  LEVEL_TEXT: array [TLogLevel] of string = ('DEBUG', 'INFO', 'WARNING', 'ERROR');
var
  LogTextParam, LogLevelParam: IParserConstant;
begin
  LogTextParam := TParserConstant.New(TAG_TEXT, Text);
  FindByName(TAG_UPPER).Callback.ParameterList.Clear;
  FindByName(TAG_UPPER).Callback.ParameterList.Add(LogTextParam);
  FindByName(TAG_LOWER).Callback.ParameterList.Clear;
  FindByName(TAG_LOWER).Callback.ParameterList.Add(LogTextParam);
  FindByName(TAG_TEXT).Callback.ParameterList.Clear;
  FindByName(TAG_TEXT).Callback.ParameterList.Add(LogTextParam);
  LogLevelParam := TParserConstant.New('LevelText', LEVEL_TEXT[LogLevel]);
  FindByName(TAG_LEVEL).Callback.ParameterList.Clear;
  FindByName(TAG_LEVEL).Callback.ParameterList.Add(LogLevelParam);
end;

procedure TLogTemplateTagList.LoadOSInfo;
begin
  _ComputerName := TOSComputerName.New.Value;
  _UserName := TOSUserName.New.Value;
  _LocalIP := TOSLocalIP.New.Value;
end;

procedure TLogTemplateTagList.CreateTags;
begin
  LoadOSInfo;
  Add(TParserVariable.New('WeekYear', TParserCallback.New(GetTagWeekYear)));
  Add(TParserVariable.New('WeekMonth', TParserCallback.New(GetTagWeekMonth)));
  Add(TParserVariable.New('Date', TParserCallback.New(GetTagDate)));
  Add(TParserVariable.New('Time', TParserCallback.New(GetTagTime)));
  Add(TParserVariable.New('DateTime', TParserCallback.New(GetTagDateTime)));
  Add(TParserVariable.New('Day', TParserCallback.New(GetTagDay)));
  Add(TParserVariable.New('Month', TParserCallback.New(GetTagMonth)));
  Add(TParserVariable.New('Year', TParserCallback.New(GetTagYear)));
  Add(TParserVariable.New('Hour', TParserCallback.New(GetTagHour)));
  Add(TParserVariable.New('Minute', TParserCallback.New(GetTagMinute)));
  Add(TParserVariable.New('Second', TParserCallback.New(GetTagSecond)));
  Add(TParserVariable.New('MiliSecond', TParserCallback.New(GetTagMiliSecond)));
  Add(TParserVariable.New('App', TParserCallback.New(GetTagApp)));
  Add(TParserVariable.New('PC', TParserCallback.New(GetTagPC)));
  Add(TParserVariable.New('User', TParserCallback.New(GetTagUser)));
  Add(TParserVariable.New('IP', TParserCallback.New(GetTagIP)));
  Add(TParserVariable.New('AppPath', TParserCallback.New(GetTagAppPath)));
  Add(TParserVariable.New(TAG_UPPER, TParserCallback.New(GetTagUpperText)));
  Add(TParserVariable.New(TAG_LOWER, TParserCallback.New(GetTagLowerText)));
  Add(TParserVariable.New(TAG_TEXT, TParserCallback.New(GetTagText)));
  Add(TParserVariable.New(TAG_LEVEL, TParserCallback.New(GetTagLogLevel)));
end;

constructor TLogTemplateTagList.Create;
begin
  _LogTemplateTagList := TTemplateTagList.New;
  LoadOSInfo;
  CreateTags;
end;

class function TLogTemplateTagList.New: ILogTemplateTagList;
begin
  Result := TLogTemplateTagList.Create;
end;

end.
