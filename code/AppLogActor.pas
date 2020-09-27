unit AppLogActor;

interface

uses
  SysUtils,
  Log, LogActor;

type
  TAppLogActor = class sealed(TInterfacedObject, ILogActor)
  strict private
    _LogActor: ILogActor;
    _AppID: String;
  public
    function LogEnabled: Boolean;
    function Log: ILog;
    procedure WriteDebug(const Text: String; const Action: String = '');
    procedure WriteInfo(const Text: String; const Action: String = '');
    procedure WriteException(const Error: Exception; const RaiseException: Boolean; const Action: String = '');
    procedure WriteError(const Text: String; const Action: String = '');
    procedure WriteWarning(const Text: String; const Action: String = '');
    constructor Create(const LogActor: ILogActor; const AppID: String);
    class function New(const LogActor: ILogActor; const AppID: String): ILogActor;
  end;

implementation

function TAppLogActor.LogEnabled: Boolean;
begin
  Result := _LogActor.LogEnabled;
end;

function TAppLogActor.Log: ILog;
begin
  Result := _LogActor.Log;
end;

procedure TAppLogActor.WriteDebug(const Text: String; const Action: String = '');
begin
  if Length(Action) < 1 then
    _LogActor.WriteDebug(Text, _AppID)
  else
    _LogActor.WriteDebug(Text, Action);
end;

procedure TAppLogActor.WriteInfo(const Text: String; const Action: String = '');
begin
  if Length(Action) < 1 then
    _LogActor.WriteInfo(Text, _AppID)
  else
    _LogActor.WriteInfo(Text, Action);
end;

procedure TAppLogActor.WriteException(const Error: Exception; const RaiseException: Boolean; const Action: String = '');
begin
  if Length(Action) < 1 then
    _LogActor.WriteException(Error, RaiseException, _AppID)
  else
    _LogActor.WriteException(Error, RaiseException, Action);
end;

procedure TAppLogActor.WriteError(const Text: String; const Action: String = '');
begin
  if Length(Action) < 1 then
    _LogActor.WriteError(Text, _AppID)
  else
    _LogActor.WriteError(Text, Action);
end;

procedure TAppLogActor.WriteWarning(const Text: String; const Action: String = '');
begin
  if Length(Action) < 1 then
    _LogActor.WriteWarning(Text, _AppID)
  else
    _LogActor.WriteWarning(Text, Action);
end;

constructor TAppLogActor.Create(const LogActor: ILogActor; const AppID: String);
begin
  _LogActor := LogActor;
  _AppID := AppID;
end;

class function TAppLogActor.New(const LogActor: ILogActor; const AppID: String): ILogActor;
begin
  Result := TAppLogActor.Create(LogActor, AppID);
end;

end.
