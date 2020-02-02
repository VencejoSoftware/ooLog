{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Text file logger object based in parsed templates
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TemplateTextFileLog;

interface

uses
  Log,
  TextFileLog,
  TemplateLog;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILogFileNameFactory))
  File path name resolver based in template
  @member(Build @seealso(ILogFileNameFactory.Build))
  @member(
    Create Object constructor
    @param(FileNameTemplate @link(ITemplateLog Template))
  )
  @member(
    New Create a new @classname as interface
    @param(FileNameTemplate @link(ITemplateLog Template))
  )
}
{$ENDREGION}
  TLogFileTemplatedNameFactory = class sealed(TInterfacedObject, ILogFileNameFactory)
  strict private
    _FileNameTemplate: ITemplateLog;
  public
    function Build: String;
    constructor Create(const FileNameTemplate: ITemplateLog);
    class function New(const FileNameTemplate: ITemplateLog): ILogFileNameFactory;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILog))
  Define a logger with storage logs in text file, checking the concurency
  @member(Filter @seealso(ILog.Filter))
  @member(ChangeFilter @seealso(ILog.ChangeFilter))
  @member(Write @seealso(ILog.Write))
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

  TTemplateTextFileLog = class sealed(TInterfacedObject, ILog)
  strict private
    _Log: ILog;
    _TemplateLog: ITemplateLog;
  private
    function OnParseText(const Text: String; const Severity: TLogSeverity): String;
  public
    function Filter: TLogSeverityFilter;
    procedure ChangeFilter(const Filter: TLogSeverityFilter);
    procedure Write(const Text: string; const Severity: TLogSeverity); virtual;
    constructor Create(const FileNameTemplate, TemplateLog: ITemplateLog); virtual;
    class function New(const FileNameTemplate, TemplateLog: ITemplateLog): ILog;
  end;

implementation

function TTemplateTextFileLog.Filter: TLogSeverityFilter;
begin
  Result := _Log.Filter;
end;

procedure TTemplateTextFileLog.ChangeFilter(const Filter: TLogSeverityFilter);
begin
  _Log.ChangeFilter(Filter);
end;

procedure TTemplateTextFileLog.Write(const Text: string; const Severity: TLogSeverity);
begin
  _Log.Write(Text, Severity);
end;

function TTemplateTextFileLog.OnParseText(const Text: String; const Severity: TLogSeverity): String;
begin
  Result := _TemplateLog.Build(Text, Severity) + sLineBreak;
end;

constructor TTemplateTextFileLog.Create(const FileNameTemplate, TemplateLog: ITemplateLog);
begin
  inherited Create;
  _TemplateLog := TemplateLog;
{$IFDEF FPC}
  _Log := TTextFileLog.NewOfObject(TLogFileTemplatedNameFactory.New(FileNameTemplate), OnParseText);
{$ELSE}
  _Log := TTextFileLog.New(TLogFileTemplatedNameFactory.New(FileNameTemplate), OnParseText);
{$ENDIF}
end;

class function TTemplateTextFileLog.New(const FileNameTemplate, TemplateLog: ITemplateLog): ILog;
begin
  Result := TTemplateTextFileLog.Create(FileNameTemplate, TemplateLog);
end;

{ TLogFileTemplatedNameFactory }

function TLogFileTemplatedNameFactory.Build: String;
begin
  Result := _FileNameTemplate.Build;
end;

constructor TLogFileTemplatedNameFactory.Create(const FileNameTemplate: ITemplateLog);
begin
  _FileNameTemplate := FileNameTemplate;
end;

class function TLogFileTemplatedNameFactory.New(const FileNameTemplate: ITemplateLog): ILogFileNameFactory;
begin
  Result := TLogFileTemplatedNameFactory.Create(FileNameTemplate);
end;

end.
