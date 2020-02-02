{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Text file log name based in parsed templates
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit LogFileTemplatedNameFactory;

interface

uses
  LogFileNameFactory,
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

implementation

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
