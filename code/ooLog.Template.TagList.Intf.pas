{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLog.Template.TagList.Intf;

interface

uses
  ooTemplateParser.Tag.List,
  ooLogger.Intf;

type
  ILogTemplateTagList = interface(ITemplateTagList)
    ['{CFEB68E0-FFFB-4E32-8A84-442CD96ECC7E}']
    procedure UpdateDynamicTags(const Text: String; const LogLevel: TLogLevel);
  end;

implementation

end.
