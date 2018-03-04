{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MainForm;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, StrUtils,
  ooLogger.Intf, ooLog.Actor;

type
  TMainForm = class(TForm, ILogActor)
    btnLog: TButton;
    btnError: TButton;
    btnDebug: TButton;
    btnWarning: TButton;
    gbLevelFilter: TGroupBox;
    chkLevelLog: TCheckBox;
    chkLevelInfo: TCheckBox;
    chkLevelWarning: TCheckBox;
    chkLevelError: TCheckBox;
    LogMemo: TMemo;
    procedure OnUpdateFilterSet(Sender: TObject);
    procedure btnLogClick(Sender: TObject);
    procedure btnWarningClick(Sender: TObject);
    procedure btnDebugClick(Sender: TObject);
    procedure btnErrorClick(Sender: TObject);
  private
    _Logger: ILogger;
    _LogActor: TLogActor;
    procedure FilterSetToControls;
    procedure ControlsToFilterSet;
  public
    function LogEnabled: Boolean;
    function Logger: ILogger;
    procedure LogDebug(const Text: String);
    procedure LogInfo(const Text: String);
    procedure LogError(const Error: Exception; const RaiseException: Boolean);
    procedure LogErrorText(const Text: String);
    procedure LogWarning(const Text: String);
    constructor Create(AOwner: TComponent; const Logger: ILogger); reintroduce;
    destructor Destroy; override;
    class function New(const Logger: ILogger): TMainForm;
  end;

var
  NewMainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.LogDebug(const Text: String);
begin
  _LogActor.LogDebug(Text);
end;

function TMainForm.LogEnabled: Boolean;
begin
  Result := _LogActor.LogEnabled;
end;

procedure TMainForm.LogError(const Error: Exception; const RaiseException: Boolean);
begin
  _LogActor.LogError(Error, RaiseException);
end;

procedure TMainForm.LogErrorText(const Text: String);
begin
  _LogActor.LogErrorText(Text);
end;

function TMainForm.Logger: ILogger;
begin
  Result := _Logger;
end;

procedure TMainForm.LogInfo(const Text: String);
begin
  _LogActor.LogInfo(Text);
end;

procedure TMainForm.LogWarning(const Text: String);
begin
  _LogActor.LogWarning(Text);
end;

procedure TMainForm.OnUpdateFilterSet(Sender: TObject);
begin
  ControlsToFilterSet;
end;

procedure TMainForm.btnDebugClick(Sender: TObject);
begin
  LogDebug('Something to debug');
end;

procedure TMainForm.btnErrorClick(Sender: TObject);
var
  Err: Exception;
begin
  Err := Exception.Create('Error founded');
  try
    LogError(Err, False);
  finally
    Err.Free;
  end
end;

procedure TMainForm.btnLogClick(Sender: TObject);
begin
  LogInfo('Info line to ignore');
end;

procedure TMainForm.btnWarningClick(Sender: TObject);
begin
  LogWarning('Warning Logger!!!');
end;

procedure TMainForm.ControlsToFilterSet;
var
  LevelFilter: TLogLevelFilter;
begin
  LevelFilter := [];
  if chkLevelLog.Checked then
    Include(LevelFilter, Debug);
  if chkLevelInfo.Checked then
    Include(LevelFilter, Info);
  if chkLevelWarning.Checked then
    Include(LevelFilter, Warning);
  if chkLevelError.Checked then
    Include(LevelFilter, Error);
  _Logger.ChangeFilter(LevelFilter);
end;

procedure TMainForm.FilterSetToControls;
begin
  chkLevelLog.Checked := Debug in _Logger.Filter;
  chkLevelInfo.Checked := Info in _Logger.Filter;
  chkLevelWarning.Checked := Warning in _Logger.Filter;
  chkLevelError.Checked := Error in _Logger.Filter;
end;

constructor TMainForm.Create(AOwner: TComponent; const Logger: ILogger);
begin
  inherited Create(AOwner);
  _Logger := Logger;
  _LogActor := TLogActor.Create(Logger);
  LogMemo.Clear;
  FilterSetToControls;
end;

destructor TMainForm.Destroy;
begin
  _LogActor.Free;
  inherited;
end;

class function TMainForm.New(const Logger: ILogger): TMainForm;
begin
  Result := TMainForm.Create(Application, Logger);
end;

end.
