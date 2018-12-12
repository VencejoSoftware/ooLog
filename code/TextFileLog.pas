{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Text file logger object
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TextFileLog;

interface

uses
  SyncObjs,
  Classes, SysUtils,
  Log,
  TemplateLog;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILog))
  Define a logger with storage logs in text file, checking the concurency
  @member(Filter @seealso(ILog.Filter))
  @member(ChangeFilter @seealso(ILog.ChangeFilter))
  @member(Write @seealso(ILog.Write))
  @member(
    WriteText Write text checking concurrency
    @param(Text Text to write in file)
  )
  @member(
    Create Object constructor
    @param(FileNameTemplate @link(ITemplateLog Log template for info))
    @param(TemplateLog @link(ITemplateLog Template to resolve file name dynamically))
  )
  @member(
    Destroy Object destructor
  )
  @member(
    New Create a new @classname as interface
    @param(FileNameTemplate @link(ITemplateLog Log template for info))
    @param(TemplateLog @link(ITemplateLog Template to resolve file name dynamically))
  )
}
{$ENDREGION}
  TTextFileLog = class sealed(TInterfacedObject, ILog)
  strict private
    _CriticalSection: TCriticalSection;
    _FileNameTemplate: ITemplateLog;
    _TemplateLog: ITemplateLog;
    _Filter: TLogLevelFilter;
  private
    procedure WriteText(const Text: string);
  public
    function Filter: TLogLevelFilter;
    procedure ChangeFilter(const Filter: TLogLevelFilter);
    procedure Write(const Text: string; const Level: TLogLevel); virtual;
    constructor Create(const FileNameTemplate, TemplateLog: ITemplateLog); virtual;
    destructor Destroy; override;
    class function New(const FileNameTemplate, TemplateLog: ITemplateLog): ILog;
  end;

implementation

function TTextFileLog.Filter: TLogLevelFilter;
begin
  Result := _Filter;
end;

procedure TTextFileLog.WriteText(const Text: string);
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

procedure TTextFileLog.Write(const Text: string; const Level: TLogLevel);
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
        WriteText(_TemplateLog.Build(Text, Level) + sLineBreak);
      except
        Inc(ErrorCount);
        Sleep(500);
      end;
    until (ErrorCount <= 10);
  finally
    _CriticalSection.Leave;
  end;
end;

procedure TTextFileLog.ChangeFilter(const Filter: TLogLevelFilter);
begin
  _Filter := Filter;
end;

constructor TTextFileLog.Create(const FileNameTemplate, TemplateLog: ITemplateLog);
begin
  inherited Create;
  _CriticalSection := TCriticalSection.Create;
  _FileNameTemplate := FileNameTemplate;
  _TemplateLog := TemplateLog;
  ChangeFilter([Debug, Info, Warning, Error]);
end;

destructor TTextFileLog.Destroy;
begin
  _CriticalSection.Enter;
  _CriticalSection.Leave;
  _CriticalSection.Free;
  inherited Destroy;
end;

class function TTextFileLog.New(const FileNameTemplate, TemplateLog: ITemplateLog): ILog;
begin
  Result := TTextFileLog.Create(FileNameTemplate, TemplateLog);
end;

end.
