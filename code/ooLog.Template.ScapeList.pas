{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLog.Template.ScapeList;

interface

uses
  SysUtils,
  ooScapeTranslate, ooScapeTranslate.List;

type
  TLogTemplateScapeList = class sealed(TInterfacedObject, IScapeTranslateList)
  strict private
    _ScapeTranslateList: IScapeTranslateList;
  public
    function Apply(const Text: string): String;
    function Add(const Item: IScapeTranslate): Integer;

    constructor Create;

    class function New: IScapeTranslateList;
  end;

implementation

function TLogTemplateScapeList.Add(const Item: IScapeTranslate): Integer;
begin
  Result := _ScapeTranslateList.Add(Item);
end;

function TLogTemplateScapeList.Apply(const Text: string): String;
begin
  Result := _ScapeTranslateList.Apply(Text);
end;

constructor TLogTemplateScapeList.Create;
begin
  _ScapeTranslateList := TScapeTranslateList.New;
  Add(TScapeTranslate.New(#13, '{#13}'));
  Add(TScapeTranslate.New(#10, '{#10}'));
end;

class function TLogTemplateScapeList.New: IScapeTranslateList;
begin
  Result := TLogTemplateScapeList.Create;
end;

end.
