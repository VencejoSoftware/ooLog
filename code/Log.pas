{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Logger object
  @created(18/12/2017)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit Log;

interface

type
{$REGION 'documentation'}
{
  Enum for log level
  @value Debug log level
  @value Info Ascending log level
  @value Warning Descending log level
  @value Error Descending log level
}
{$ENDREGION}
  TLogLevel = (Debug, Info, Warning, Error);
{$REGION 'documentation'}
{
  @abstract(Log level filters)
}
{$ENDREGION}
  TLogLevelFilter = set of TLogLevel;

{$REGION 'documentation'}
{
  @abstract(Logger object)
  Object to log text in a storage
  @member(
    Filter Log level filter to store
    @return(@link(TLogLevelFilter Level filter))
  )
  @member(
    ChangeFilter Set the current level filter
    @param(Filter @link(TLogLevelFilter Level filter))
  )
  @member(
    Write Try to store the log text
    @param(Text Text to log)
    @param(Filter @link(TLogLevelFilter Level filter))
  )
}
{$ENDREGION}

  ILog = interface
    ['{8C88DA51-EC30-42AD-8CEE-B0731926E110}']
    function Filter: TLogLevelFilter;
    procedure ChangeFilter(const Filter: TLogLevelFilter);
    procedure Write(const Text: String; const Level: TLogLevel);
  end;

implementation

end.
