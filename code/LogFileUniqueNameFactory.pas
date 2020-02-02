{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Text file log name based in a formatted time
  @created(02/02/2020)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit LogFileUniqueNameFactory;

interface

uses
  SysUtils,
  LogFileNameFactory;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ILogFileNameFactory))
  File path name resolver based in the current datetime
  @member(Build @seealso(ILogFileNameFactory.Build))
  @member(
    Create Object constructor
    @param(BaseName Base name to use)
    @param(Mask Datetime mask to use when build name)
  )
  @member(
    New Create a new @classname as interface
    @param(BaseName Base name to use)
    @param(Mask Datetime mask to use when build name)
  )
}
{$ENDREGION}
  TLogFileTemplatedNameFactory = class sealed(TInterfacedObject, ILogFileNameFactory)
  const
    USE_DATE = '_dd_mm_yyyy';
    USE_DATE_TIME = USE_DATE + '_hh_nn_ss';
    USE_DATE_TIME_MS = USE_DATE_TIME + '_zzz';
  strict private
    _Mask, _BaseName: String;
  public
    function Build: String;
    constructor Create(const BaseName: String; const Mask: String);
    class function New(const BaseName: String; const Mask: String = USE_DATE): ILogFileNameFactory;
  end;

implementation

function TLogFileTemplatedNameFactory.Build: String;
begin
  Result := Format('%s%s%s', [ChangeFileExt(ExtractFileName(_BaseName), EmptyStr), FormatDateTime(_Mask, Now),
    ExtractFileExt(_BaseName)]);
end;

constructor TLogFileTemplatedNameFactory.Create(const BaseName: String; const Mask: String);
begin
  _BaseName := BaseName;
  _Mask := Mask;
end;

class function TLogFileTemplatedNameFactory.New(const BaseName: String; const Mask: String): ILogFileNameFactory;
begin
  Result := TLogFileTemplatedNameFactory.Create(BaseName, Mask);
end;

end.
