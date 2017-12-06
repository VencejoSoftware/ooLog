{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLog.Template.Intf;

interface

uses
  ooScapeTranslate.List,
  ooLog.Template.TagList.Intf,
  ooLogger.Intf;

type
  ILogTemplate = interface
    ['{0D2A8B86-5BEC-4E9E-8131-67F55CDFE46B}']
    function Build(const Template: String; const LogLevel: TLogLevel): String; overload;
    function Build: String; overload;
    function TagList: ILogTemplateTagList;
    function ScapeList: IScapeTranslateList;
  end;

implementation

end.
