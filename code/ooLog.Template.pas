{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLog.Template;

interface

uses
  ooText.Match.Intf,
  ooTemplateParser,
  ooLog.Template.TagList.Intf, ooLog.Template.TagList,
  ooScapeTranslate.List,
  ooLog.Template.ScapeList,
  ooLogger.Intf, ooLog.Template.Intf;

type
  TLogTemplate = class sealed(TInterfacedObject, ILogTemplate)
  const
    TAG_BEGIN = '{';
    TAG_END = '}';
  strict private
    _Template: String;
    _TagList: ILogTemplateTagList;
    _ScapeList: IScapeTranslateList;
    _TextMatch: ITextMatch;
  public
    function Build(const Template: String; const LogLevel: TLogLevel): String; overload;
    function Build: String; overload;
    function TagList: ILogTemplateTagList;
    function ScapeList: IScapeTranslateList;

    constructor Create(const Template: String; const TextMatch: ITextMatch);

    class function New(const Template: String; const TextMatch: ITextMatch): ILogTemplate;
  end;

implementation

function TLogTemplate.TagList: ILogTemplateTagList;
begin
  Result := _TagList;
end;

function TLogTemplate.ScapeList: IScapeTranslateList;
begin
  Result := _ScapeList;
end;

function TLogTemplate.Build: String;
begin
  Result := TTemplateParser.New(TAG_BEGIN, TAG_END, _TagList, _TextMatch).Evaluate(_Template);
end;

function TLogTemplate.Build(const Template: String; const LogLevel: TLogLevel): String;
begin
  TagList.UpdateDynamicTags(_ScapeList.Apply(Template), LogLevel);
  Result := TTemplateParser.New(TAG_BEGIN, TAG_END, _TagList, _TextMatch).Evaluate(_Template);
end;

constructor TLogTemplate.Create(const Template: String; const TextMatch: ITextMatch);
begin
  _ScapeList := TLogTemplateScapeList.New;
  _TagList := TLogTemplateTagList.New;
  _TextMatch := TextMatch;
  _Template := Template;
end;

class function TLogTemplate.New(const Template: String; const TextMatch: ITextMatch): ILogTemplate;
begin
  Result := TLogTemplate.Create(Template, TextMatch);
end;

end.
