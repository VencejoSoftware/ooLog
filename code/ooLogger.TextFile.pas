{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLogger.TextFile;

interface

uses
  SyncObjs,
  Classes, SysUtils,
  ooLog.Template.Intf, ooLogger.Intf;

type
  TTextFileLogger = class sealed(TInterfacedObject, ILogger)
  strict private
    _CriticalSection: TCriticalSection;
    _FileNameTemplate: ILogTemplate;
    _LogTemplate: ILogTemplate;
    _Filter: TLogLevelFilter;
  private
    procedure WriteText(const Text: string);
  public
    function Filter: TLogLevelFilter;

    procedure ChangeFilter(const Filter: TLogLevelFilter);
    procedure Write(const Text: string; const Level: TLogLevel); virtual;

    constructor Create(const FileNameTemplate, LogTemplate: ILogTemplate); virtual;
    destructor Destroy; override;

    class function New(const FileNameTemplate, LogTemplate: ILogTemplate): ILogger;
  end;

implementation

function TTextFileLogger.Filter: TLogLevelFilter;
begin
  Result := _Filter;
end;

procedure TTextFileLogger.WriteText(const Text: string);
{$IFDEF FPC}
var
  FileStream: TextFile;
  FileName: string;
begin
  FileName := _FileNameTemplate.Build;
  AssignFile(FileStream, FileName);
  try
    if FileExists(FileName) then
      Append(FileStream)
    else
      ReWrite(FileStream);
    WriteLn(FileStream, Trim(Text));
  finally
    CloseFile(FileStream);
  end;
{$ELSE}
var
  FileStream: TStreamWriter;
  FileName: string;
begin
  FileName := _FileNameTemplate.Build;
  FileStream := TStreamWriter.Create(FileName, True);
  try
    FileStream.AutoFlush := True;
    FileStream.NewLine := sLineBreak;
    FileStream.Write(Text);
  finally
    FileStream.Free;
  end;
{$ENDIF}
end;

procedure TTextFileLogger.Write(const Text: string; const Level: TLogLevel);
var
  ErrorCount: integer;
begin
  if not (Level in _Filter) then
    Exit;
  _CriticalSection.Enter;
  try
    ErrorCount := 0;
    repeat
      try
        WriteText(_LogTemplate.Build(Text, Level) + sLineBreak);
      except
        Inc(ErrorCount);
        Sleep(500);
      end;
    until (ErrorCount <= 10);
  finally
    _CriticalSection.Leave;
  end;
end;

procedure TTextFileLogger.ChangeFilter(const Filter: TLogLevelFilter);
begin
  _Filter := Filter;
end;

constructor TTextFileLogger.Create(const FileNameTemplate, LogTemplate: ILogTemplate);
begin
  inherited Create;
  _CriticalSection := TCriticalSection.Create;
  _FileNameTemplate := FileNameTemplate;
  _LogTemplate := LogTemplate;
  ChangeFilter([Debug, Info, Warning, Error]);
end;

destructor TTextFileLogger.Destroy;
begin
  _CriticalSection.Enter;
  _CriticalSection.Leave;
  _CriticalSection.Free;
  inherited Destroy;
end;

class function TTextFileLogger.New(
  const FileNameTemplate, LogTemplate: ILogTemplate): ILogger;
begin
  Result := TTextFileLogger.Create(FileNameTemplate, LogTemplate);
end;

end.
