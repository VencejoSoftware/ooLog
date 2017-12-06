{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program demo;

uses
  Forms,
  ooText.Match.Insensitive,
  ooLogger.TextFile,
  ooLog.Template,
  MainForm in '..\code\form\MainForm.pas' {MainForm};
{$R *.res}

begin
{$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
{$WARN SYMBOL_PLATFORM ON}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  NewMainForm := TMainForm.New(TTextFileLogger.New(TLogTemplate.New('{AppPath}demo_{Month}{Year}.log',
        TTextMatchInsensitive.New), TLogTemplate.New('{IP}:{PC}-{User}-{App}[{LogLevel}]>>{DateTime} {TEXT}',
        TTextMatchInsensitive.New)));
  NewMainForm.ShowModal;
  Application.Run;

end.
