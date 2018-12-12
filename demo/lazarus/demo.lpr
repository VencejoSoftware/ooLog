{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program demo;

uses
  Forms,
  Interfaces,
  InsensitiveTextMatch,
  TemplateLog,
  TextFileLog,
  MainForm in '..\code\form\MainForm.pas';

{$R *.res}

begin
{$ifopt D+}
  SetHeapTraceOutput('heaptrace.log');
{$endif}
  Application.Initialize;
  NewMainForm := TMainForm.New(TTextFileLog.New(TTemplateLog.New('{AppPath}demo_{Month}{Year}.log',
    TInsensitiveTextMatch.New), TTemplateLog.New('{IP}:{PC}-{User}-{App}[{LogLevel}]>>{DateTime} {TEXT}',
    TInsensitiveTextMatch.New)));
  NewMainForm.ShowModal;
  Application.Run;

end.
