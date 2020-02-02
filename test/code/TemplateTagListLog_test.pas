{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TemplateTagListLog_test;

interface

uses
  SysUtils, DateUtils, Forms,
  InsensitiveTextMatch,
  OSComputerName, OSLocalIP, OSUserName,
  Log, TemplateLog,
  ScapeTranslate,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TemplateTagListLogTest = class sealed(TTestCase)
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
    procedure TestAppTitle;
    procedure TestPC;
    procedure TestUser;
    procedure TestIP;
    procedure TestAppPath;
  end;

implementation

procedure TemplateTagListLogTest.TestWeekYear;
begin
  CheckEquals(Format('%.2d', [WeekOfTheYear(Date)]), TTemplateLog.New('{WeekYear}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestWeekMonth;
begin
  CheckEquals(Format('%.2d', [WeekOfTheMonth(Date)]), TTemplateLog.New('{WeekMonth}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestDate;
begin
  CheckEquals(FormatDateTime('DD/MM/YYYY', Date), TTemplateLog.New('{Date}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestTime;
begin
  CheckEquals(Copy(TTemplateLog.New('{Time}', TInsensitiveTextMatch.New).Build(EmptyStr, Info), 1, 11),
    Copy(FormatDateTime('HH:NN:SS.ZZZ', Time), 1, 11));
end;

procedure TemplateTagListLogTest.TestDateTime;
begin
  CheckEquals(Copy(TTemplateLog.New('{DateTime}', TInsensitiveTextMatch.New).Build(EmptyStr, Info), 1, 22),
    Copy(FormatDateTime('DD/MM/YYYY HH:NN:SS.ZZZ', Now), 1, 22));
end;

procedure TemplateTagListLogTest.TestDay;
begin
  CheckEquals(FormatDateTime('DD', Date), TTemplateLog.New('{Day}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestMonth;
begin
  CheckEquals(FormatDateTime('MM', Date), TTemplateLog.New('{Month}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestYear;
begin
  CheckEquals(FormatDateTime('YYYY', Date), TTemplateLog.New('{Year}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestHour;
begin
  CheckEquals(FormatDateTime('HH', Time), TTemplateLog.New('{Hour}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestMinute;
begin
  CheckEquals(FormatDateTime('NN', Time), TTemplateLog.New('{Minute}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestSecond;
begin
  CheckEquals(FormatDateTime('SS', Time), TTemplateLog.New('{Second}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestMiliSecond;
begin
  CheckEquals(Copy(FormatDateTime('ZZZ', Time), 1, 2), Copy(TTemplateLog.New('{MiliSecond}', TInsensitiveTextMatch.New)
    .Build(EmptyStr, Info), 1, 2));
end;

procedure TemplateTagListLogTest.TestAppTitle;
begin
  CheckEquals(Application.Title, TTemplateLog.New('{AppTitle}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestPC;
begin
  CheckEquals(TOSComputerName.New.Value, TTemplateLog.New('{PC}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestUser;
begin
  CheckEquals(TOSUserName.New.Value, TTemplateLog.New('{User}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestIP;
begin
  CheckEquals(TOSLocalIP.New.Value, TTemplateLog.New('{IP}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

procedure TemplateTagListLogTest.TestAppPath;
begin
  CheckEquals(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)),
    TTemplateLog.New('{AppPath}', TInsensitiveTextMatch.New).Build(EmptyStr, Info));
end;

initialization

RegisterTest(TemplateTagListLogTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
