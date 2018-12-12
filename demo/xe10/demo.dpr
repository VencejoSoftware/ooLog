{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program demo;

uses
  Forms,
  InsensitiveTextMatch,
  TemplateLog,
  TextFileLog,
  MainForm in '..\code\form\MainForm.pas' {MainForm};

{$R *.res}

begin
{$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
{$WARN SYMBOL_PLATFORM ON}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.MainFormOnTaskbar := True;
  NewMainForm := TMainForm.New(TTextFileLog.New(TTemplateLog.New('{AppPath}demo_{Month}{Year}.log',
    TInsensitiveTextMatch.New), TTemplateLog.New('{IP}:{PC}-{User}-{App}[{LogLevel}]>>{DateTime} {TEXT}',
    TInsensitiveTextMatch.New)));
  NewMainForm.ShowModal;
  Application.Run;

end.
