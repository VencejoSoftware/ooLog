{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooLogger.Intf;

interface

type
  TLogLevel = (Debug, Info, Warning, Error);
  TLogLevelFilter = set of TLogLevel;

  ILogger = interface
    ['{8C88DA51-EC30-42AD-8CEE-B0731926E110}']
    function Filter: TLogLevelFilter;

    procedure ChangeFilter(const Filter: TLogLevelFilter);
    procedure Write(const Text: String; const Level: TLogLevel);
  end;

implementation

end.
