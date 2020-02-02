{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
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
  Classes, SysUtils, SyncObjs,
  Log;

type

{$REGION 'documentation'}
{
  @abstract(Log filename builder)
  Interface to build the log file name
  @member(
    Build Makes the log filename
    @return(String with path)
  )
}
{$ENDREGION}
  ILogFileNameFactory = interface
    ['{3A1A74CC-BE52-47D1-AEF8-E77FA9C8DE1B}']
    function Build: String;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILogFileNameFactory))
  Simple file path holder
  @member(Build @seealso(ILogFileNameFactory.Build))
  @member(
    Create Object constructor
    @param(FilePath File name path)
  )
  @member(
    New Create a new @classname as interface
    @param(FilePath File name path)
  )
}
{$ENDREGION}

  TLogFileNameFactory = class sealed(TInterfacedObject, ILogFileNameFactory)
  strict private
    _FilePath: String;
  public
    function Build: String;
    constructor Create(const FilePath: String);
    class function New(const FilePath: String): ILogFileNameFactory;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILog))
  Object to store data log in a plain text file, checking the concurency
  @member(Filter @seealso(ILog.Filter))
  @member(ChangeFilter @seealso(ILog.ChangeFilter))
  @member(Write @seealso(ILog.Write))
  @member(
    WriteInFile Internal method to write in file
    @param(Text String to write in log)
    @param(Severity Event severity mark)
  )
  @member(
    ParsedTextToWrite Replaces incomprensible characters to file-compatible values, used when ParseTextCallback is not setted
    @param(Text String to sanitize)
    @return(Sanitized string)
  )
  @member(
    Create Object constructor, preparing critical section
    @param(FilePath File path to use)
    @param(ParseTextCallback Callback method called after write text to parse it)
    @param(ParseTextCallbackOfObject Tricky for free pascal anonymous function debt)
  )
  @member(
    Destroy Object destructor, free critical section
  )
  @member(
    New Create a new @classname as interface
    @param(FileNameFactory File name callback which resolve the path)
    @param(ParseTextCallback Callback method called after write text to parse it)
  )
  @member(
    NewOfObject Create a new @classname as interface, tricky for free pascal anonymous function debt
    @param(FileNameFactory File name callback which resolve the path)
    @param(ParseTextCallback Callback method called after write text to parse it)
  )
}
{$ENDREGION}

  TTextFileLog = class sealed(TInterfacedObject, ILog)
  strict private
    _Filter: TLogSeverityFilter;
    _CriticalSection: TCriticalSection;
    _FileNameFactory: ILogFileNameFactory;
    _ParseTextCallback: TLogParseTextCallback;
{$IFDEF FPC}
    _ParseTextCallbackOfObject: TLogParseTextCallbackOfObject;
{$ENDIF}
  private
    function ParsedTextToWrite(const Text: string; const Severity: TLogSeverity): String;
    procedure WriteInFile(const Text: String);
  public
    function Filter: TLogSeverityFilter;
    procedure ChangeFilter(const Filter: TLogSeverityFilter);
    procedure Write(const Text: string; const Severity: TLogSeverity);
    constructor Create(const FileNameFactory: ILogFileNameFactory; const ParseTextCallback: TLogParseTextCallback
{$IFDEF FPC}; const ParseTextCallbackOfObject: TLogParseTextCallbackOfObject{$ENDIF} );
    destructor Destroy; override;
    class function New(const FileNameFactory: ILogFileNameFactory;
      const ParseTextCallback: TLogParseTextCallback = nil): ILog;
{$IFDEF FPC}
    class function NewOfObject(const FileNameFactory: ILogFileNameFactory;
      const ParseTextCallbackOfObject: TLogParseTextCallbackOfObject): ILog;
{$ENDIF}
  end;

implementation

function TTextFileLog.Filter: TLogSeverityFilter;
begin
  Result := _Filter;
end;

procedure TTextFileLog.ChangeFilter(const Filter: TLogSeverityFilter);
begin
  _Filter := Filter;
end;

procedure TTextFileLog.WriteInFile(const Text: string);
{$IFDEF FPC}
var
  FileStream: TextFile;
  FileName: String;
begin
  FileName := _FileNameFactory.Build;
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
begin
  FileStream := TStreamWriter.Create(_FileNameFactory.Build, True);
  try
    FileStream.AutoFlush := True;
    FileStream.NewLine := sLineBreak;
    FileStream.Write(Text);
  finally
    FileStream.Free;
  end;
{$ENDIF}
end;

function TTextFileLog.ParsedTextToWrite(const Text: string; const Severity: TLogSeverity): String;
begin
  Result := Format('%s[%s]%s', [FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', Now), Severity.ToString, Text]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
  Result := Trim(Result) + sLineBreak;
end;

procedure TTextFileLog.Write(const Text: string; const Severity: TLogSeverity);
var
  ErrorCount: integer;
begin
  if not (Severity in _Filter) then
    Exit;
  _CriticalSection.Enter;
  try
    ErrorCount := 0;
    repeat
      try
{$IFDEF FPC}
        if Assigned(_ParseTextCallback) then
          WriteInFile(_ParseTextCallback(Text, Severity))
        else
          WriteInFile(_ParseTextCallbackOfObject(Text, Severity));
{$ELSE}
        WriteInFile(_ParseTextCallback(Text, Severity));
{$ENDIF}
      except
        Inc(ErrorCount);
        Sleep(500);
      end;
    until (ErrorCount <= 10);
  finally
    _CriticalSection.Leave;
  end;
end;

constructor TTextFileLog.Create(const FileNameFactory: ILogFileNameFactory;
  const ParseTextCallback: TLogParseTextCallback
{$IFDEF FPC}; const ParseTextCallbackOfObject: TLogParseTextCallbackOfObject{$ENDIF} );
begin
  _CriticalSection := TCriticalSection.Create;
  ChangeFilter([Debug, Info, Warning, Error]);
  _FileNameFactory := FileNameFactory;
  if not Assigned(_FileNameFactory) then
    raise Exception.Create('FileNameFactory must be setted!');
  _ParseTextCallback := ParseTextCallback;
{$IFDEF FPC}
  if not Assigned(_ParseTextCallbackOfObject) then
    _ParseTextCallbackOfObject := ParsedTextToWrite;
  _ParseTextCallback := ParseTextCallback;
{$ELSE}
  if not Assigned(_ParseTextCallback) then
    _ParseTextCallback := ParsedTextToWrite;
{$ENDIF}
end;

destructor TTextFileLog.Destroy;
begin
  _CriticalSection.Enter;
  _CriticalSection.Leave;
  _CriticalSection.Free;
  inherited;
end;

class function TTextFileLog.New(const FileNameFactory: ILogFileNameFactory;
  const ParseTextCallback: TLogParseTextCallback): ILog;
begin
  Result := TTextFileLog.Create(FileNameFactory, ParseTextCallback{$IFDEF FPC}, nil{$ENDIF});
end;

{$IFDEF FPC}

class function TTextFileLog.NewOfObject(const FileNameFactory: ILogFileNameFactory;
  const ParseTextCallbackOfObject: TLogParseTextCallbackOfObject): ILog;
begin
  Result := TTextFileLog.Create(FileNameFactory, nil, ParseTextCallbackOfObject);
end;

{$ENDIF}
{ TLogFileNameFactory }

function TLogFileNameFactory.Build: String;
begin
  Result := _FilePath;
end;

constructor TLogFileNameFactory.Create(const FilePath: String);
begin
  _FilePath := FilePath;
end;

class function TLogFileNameFactory.New(const FilePath: String): ILogFileNameFactory;
begin
  Result := TLogFileNameFactory.Create(FilePath);
end;

end.
