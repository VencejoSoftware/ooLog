{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit uLog.Template_test;

interface

uses
  SysUtils, DateUtils, Forms,
  ooText.Match.Insensitive,
  ooOS.ComputerName, ooOS.LocalIP, ooOS.UserName,
  ooLogger.Intf, ooLog.Template.Intf, ooLog.Template, ooScapeTranslate,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TLogTemplateTest = class(TTestCase)
  published
    procedure TestWeekYear;
    procedure TestWeekMonth;
    procedure TestDate;
    procedure TestTime;
    procedure TestDateTime;
    procedure TestDay;
    procedure TestMonth;
    procedure TestYear;
    procedure TestHour;
    procedure TestMinute;
    procedure TestSecond;
    procedure TestMiliSecond;
    procedure TestApp;
    procedure TestLogLevel;
    procedure TestPC;
    procedure TestUser;
    procedure TestIP;
    procedure TestAppPath;
    procedure TestUpperText;
    procedure TestLowerText;
    procedure TestText;
    procedure TestTextCrLf;
    procedure TestAnotherScape;
  end;

implementation

procedure TLogTemplateTest.TestWeekYear;
begin
  CheckEquals(Format('%.2d', [WeekOfTheYear(Date)]), TLogTemplate.New('{WeekYear}',
      TTextMatchInsensitive.New).Build(EmptyStr, Info));
end;

procedure TLogTemplateTest.TestWeekMonth;
begin
  CheckEquals(Format('%.2d', [WeekOfTheMonth(Date)]), TLogTemplate.New('{WeekMonth}',
      TTextMatchInsensitive.New).Build(EmptyStr, Info));
end;

procedure TLogTemplateTest.TestDate;
begin
  CheckEquals(FormatDateTime('DD/MM/YYYY', Date), TLogTemplate.New('{Date}',
      TTextMatchInsensitive.New).Build(EmptyStr, Info));
end;

procedure TLogTemplateTest.TestTime;
begin
  CheckEquals(Copy(TLogTemplate.New('{Time}', TTextMatchInsensitive.New).Build(EmptyStr, Info), 1, 11),
    Copy(FormatDateTime('HH:NN:SS.ZZZ', Time), 1, 11));
end;

procedure TLogTemplateTest.TestDateTime;
begin
  CheckEquals(Copy(TLogTemplate.New('{DateTime}', TTextMatchInsensitive.New).Build(EmptyStr, Info), 1, 22),
    Copy(FormatDateTime('DD/MM/YYYY HH:NN:SS.ZZZ', Now), 1, 22));
end;

procedure TLogTemplateTest.TestDay;
begin
  CheckEquals(FormatDateTime('DD', Date), TLogTemplate.New('{Day}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestMonth;
begin
  CheckEquals(FormatDateTime('MM', Date), TLogTemplate.New('{Month}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestYear;
begin
  CheckEquals(FormatDateTime('YYYY', Date), TLogTemplate.New('{Year}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestHour;
begin
  CheckEquals(FormatDateTime('HH', Time), TLogTemplate.New('{Hour}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestMinute;
begin
  CheckEquals(FormatDateTime('NN', Time), TLogTemplate.New('{Minute}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestSecond;
begin
  CheckEquals(FormatDateTime('SS', Time), TLogTemplate.New('{Second}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestMiliSecond;
begin
  CheckEquals(Copy(FormatDateTime('ZZZ', Time), 1, 2),
    Copy(TLogTemplate.New('{MiliSecond}', TTextMatchInsensitive.New).Build(EmptyStr, Info), 1,
      2));
end;

procedure TLogTemplateTest.TestApp;
begin
  CheckEquals(Application.Title, TLogTemplate.New('{App}', TTextMatchInsensitive.New).Build(EmptyStr, Info));
end;

procedure TLogTemplateTest.TestLogLevel;
const
  LEVEL_TEXT: array [TLogLevel] of string = ('DEBUG', 'INFO', 'WARNING', 'ERROR');
begin
  CheckEquals('DEBUG', TLogTemplate.New('{LogLevel}', TTextMatchInsensitive.New).Build(EmptyStr, Debug));
  CheckEquals('INFO', TLogTemplate.New('{LogLevel}', TTextMatchInsensitive.New).Build(EmptyStr, Info));
  CheckEquals('WARNING', TLogTemplate.New('{LogLevel}', TTextMatchInsensitive.New).Build(EmptyStr, Warning));
  CheckEquals('ERROR', TLogTemplate.New('{LogLevel}', TTextMatchInsensitive.New).Build(EmptyStr, Error));
end;

procedure TLogTemplateTest.TestPC;
begin
  CheckEquals(TOSComputerName.New.Value, TLogTemplate.New('{PC}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestUser;
begin
  CheckEquals(TOSUserName.New.Value, TLogTemplate.New('{User}', TTextMatchInsensitive.New).Build(EmptyStr,
      Info));
end;

procedure TLogTemplateTest.TestIP;
begin
  CheckEquals(TOSLocalIP.New.Value, TLogTemplate.New('{IP}', TTextMatchInsensitive.New).Build(EmptyStr, Info));
end;

procedure TLogTemplateTest.TestAppPath;
begin
  CheckEquals(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)),
    TLogTemplate.New('{AppPath}', TTextMatchInsensitive.New).Build(EmptyStr, Info));
end;

procedure TLogTemplateTest.TestUpperText;
begin
  CheckEquals('LOG INFO UPPERED', TLogTemplate.New('{UpperText}',
      TTextMatchInsensitive.New).Build('Log info uppered', Info));
end;

procedure TLogTemplateTest.TestLowerText;
begin
  CheckEquals('log info lowered', TLogTemplate.New('{LowerText}',
      TTextMatchInsensitive.New).Build('Log info LOWERED', Info));
end;

procedure TLogTemplateTest.TestText;
begin
  CheckEquals('Log info NoRmAl', TLogTemplate.New('{Text}', TTextMatchInsensitive.New).Build('Log info NoRmAl',
      Info));
end;

procedure TLogTemplateTest.TestTextCrLf;
begin
  CheckEquals('First line{#13}{#10}Second line{#13}{#10}Third line', TLogTemplate.New('{Text}',
      TTextMatchInsensitive.New).Build('First line' + sLineBreak + 'Second line' + sLineBreak + 'Third line', Info));
end;

procedure TLogTemplateTest.TestAnotherScape;
var
  LogTemplate: ILogTemplate;
begin
  LogTemplate := TLogTemplate.New('{Text}', TTextMatchInsensitive.New);
  LogTemplate.ScapeList.Add(TScapeTranslate.New(Chr(9), '{TAB}'));
  CheckEquals('One text{TAB}two text', LogTemplate.Build('One text' + Chr(9) + 'two text', Info));
end;

initialization

RegisterTest(TLogTemplateTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
