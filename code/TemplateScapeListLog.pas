{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  List of log template scape symbols
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TemplateScapeListLog;

interface

uses
  SysUtils,
  List,
  ScapeTranslate, ScapeTranslateList;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IScapeTranslateList))
  Prepare a list of symbols for a template log scape
  @member(
    Apply Replace all symbols in list in the text parameter
    @param(Text Text to parse)
    @return(Text parsed with the scape list)
  )
  @member(
    Add Add a new scape translate object
    @param(Item Scape translate object)
    @return(Index of added item)
  )
  @member(
    Create Object constructor
  )
  @member(
    New Create a new @classname as interface
  )
}
{$ENDREGION}
  TTemplateScapeListLog = class sealed(TInterfacedObject, IScapeTranslateList)
  strict private
    _ScapeTranslateList: IScapeTranslateList;
  public
    function Apply(const Text: string): String;
    function Add(const Item: IScapeTranslate): TIntegerIndex;
    constructor Create;
    class function New: IScapeTranslateList;
  end;

implementation

function TTemplateScapeListLog.Add(const Item: IScapeTranslate): TIntegerIndex;
begin
  Result := _ScapeTranslateList.Add(Item);
end;

function TTemplateScapeListLog.Apply(const Text: string): String;
begin
  Result := _ScapeTranslateList.Apply(Text);
end;

constructor TTemplateScapeListLog.Create;
begin
  _ScapeTranslateList := TScapeTranslateList.New;
  Add(TScapeTranslate.New(#13, '{#13}'));
  Add(TScapeTranslate.New(#10, '{#10}'));
end;

class function TTemplateScapeListLog.New: IScapeTranslateList;
begin
  Result := TTemplateScapeListLog.Create;
end;

end.
