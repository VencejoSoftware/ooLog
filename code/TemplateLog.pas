{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to evaluate and parse a log line
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TemplateLog;

interface

uses
  TextMatch,
  TagSubstitute,
  TemplateTagListLog,
  ScapeTranslateList,
  TemplateScapeListLog,
  Log;

type
{$REGION 'documentation'}
{
  @abstract(Object to evaluate and parse a log line)
  @member(
    Build Parse all dynamic tags and return a static text
    @param(Template Text template to evaluate)
    @param(Severity Log severity of data log)
    @return(Text parsed)
  )
  @member(
    Build Parse all dynamic tags and return a static text
    @return(Text parsed)
  )
  @member(
    TagList List of dynamic tags symbols using when parse
    @return(@link(ITemplateTagListLog List of tags))
  )
  @member(
    ScapeList List of scape symbols
    @return(@link(IScapeTranslateList List of scape symbols))
  )
}
{$ENDREGION}
  ITemplateLog = interface
    ['{0D2A8B86-5BEC-4E9E-8131-67F55CDFE46B}']
    function Build(const Template: String; const Severity: TLogSeverity): String; overload;
    function Build: String; overload;
    function TagList: ITemplateTagListLog;
    function ScapeList: IScapeTranslateList;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ITemplateLog))
  @member(Build @seealso(ITemplateLog.Build))
  @member(Build @seealso(ITemplateLog.Build))
  @member(TagList @seealso(ITemplateLog.TagList))
  @member(ScapeList @seealso(ITemplateLog.ScapeList))
  @member(
    Create Object constructor
    @param(Template Base template text for data log)
    @param(TextMatch @link(ITextMatch Object to match each words when parse))
  )
  @member(
    New Create a new @classname as interface
    @param(Template Base template text for data log)
    @param(TextMatch @link(ITextMatch Object to match each words when parse))
  )
}
{$ENDREGION}

  TTemplateLog = class sealed(TInterfacedObject, ITemplateLog)
  const
    TAG_BEGIN = '{';
    TAG_END = '}';
  strict private
    _Template: String;
    _TagList: ITemplateTagListLog;
    _ScapeList: IScapeTranslateList;
    _TextMatch: ITextMatch;
  public
    function Build(const Template: String; const Severity: TLogSeverity): String; overload;
    function Build: String; overload;
    function TagList: ITemplateTagListLog;
    function ScapeList: IScapeTranslateList;
    constructor Create(const Template: String; const TextMatch: ITextMatch);
    class function New(const Template: String; const TextMatch: ITextMatch): ITemplateLog;
  end;

implementation

function TTemplateLog.TagList: ITemplateTagListLog;
begin
  Result := _TagList;
end;

function TTemplateLog.ScapeList: IScapeTranslateList;
begin
  Result := _ScapeList;
end;

function TTemplateLog.Build: String;
begin
  Result := TTagSubstitute.New(TAG_BEGIN, TAG_END, _TagList, _TextMatch).Evaluate(_Template);
end;

function TTemplateLog.Build(const Template: String; const Severity: TLogSeverity): String;
begin
  TagList.UpdateDynamicTags(_ScapeList.Apply(Template), Severity);
  Result := Build;
end;

constructor TTemplateLog.Create(const Template: String; const TextMatch: ITextMatch);
begin
  _ScapeList := TTemplateScapeListLog.New;
  _TagList := TTemplateTagListLog.New;
  _TextMatch := TextMatch;
  _Template := Template;
end;

class function TTemplateLog.New(const Template: String; const TextMatch: ITextMatch): ITemplateLog;
begin
  Result := TTemplateLog.Create(Template, TextMatch);
end;

end.
