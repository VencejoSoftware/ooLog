{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program demo;

uses
  Forms,
  Interfaces,
  ooText.Match.Insensitive,
  ooLogger.TextFile,
  ooLog.Template,
  MainForm in '..\code\form\MainForm.pas';

{$R *.res}

begin
{$ifopt D+}
  SetHeapTraceOutput('heaptrace.log');
{$endif}
  Application.Initialize;
  NewMainForm := TMainForm.New(TTextFileLogger.New(TLogTemplate.New('{AppPath}demo_{Month}{Year}.log',
      TTextMatchInsensitive.New), TLogTemplate.New('{IP}:{PC}-{User}-{App}[{LogLevel}]>>{DateTime} {TEXT}',
      TTextMatchInsensitive.New)));
  NewMainForm.ShowModal;
  NewMainForm.Free;
  Application.Free;

end.
