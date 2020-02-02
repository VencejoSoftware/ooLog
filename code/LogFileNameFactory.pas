{$REGION 'documentation'}
{
  Copyright (c) 2020, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Text log filename builder
  @created(02/02/2020)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit LogFileNameFactory;

interface

uses
  SysUtils;

type
{$REGION 'documentation'}
{
  @abstract(Filename builder error object)
}
{$ENDREGION}
  ELogFileNameFactory = class sealed(Exception)

  end;

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

implementation

function TLogFileNameFactory.Build: String;
begin
  Result := _FilePath;
end;

constructor TLogFileNameFactory.Create(const FilePath: String);
begin
  _FilePath := Trim(FilePath);
  if Length(_FilePath) < 1 then
    raise ELogFileNameFactory.Create('File path can not be empty');
end;

class function TLogFileNameFactory.New(const FilePath: String): ILogFileNameFactory;
begin
  Result := TLogFileNameFactory.Create(FilePath);
end;

end.
