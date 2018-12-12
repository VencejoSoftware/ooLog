{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MainForm;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, StrUtils, ExtCtrls,
  InsensitiveTextMatch,
  TemplateLog,
  Log, LogActor;

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
    Timer1: TTimer;
    procedure OnUpdateFilterSet(Sender: TObject);
    procedure btnLogClick(Sender: TObject);
    procedure btnWarningClick(Sender: TObject);
    procedure btnDebugClick(Sender: TObject);
    procedure btnErrorClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    _Log: ILog;
    _LogActor: ILogActor;
    procedure FilterSetToControls;
    procedure ControlsToFilterSet;
  public
    function LogEnabled: Boolean;
    function Log: ILog;
    procedure LogDebug(const Text: String);
    procedure LogInfo(const Text: String);
    procedure LogError(const Error: Exception; const RaiseException: Boolean);
    procedure LogErrorText(const Text: String);
    procedure LogWarning(const Text: String);
    constructor Create(AOwner: TComponent; const Log: ILog); reintroduce;
    class function New(const Log: ILog): TMainForm;
  end;

var
  NewMainForm: TMainForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

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

function TMainForm.Log: ILog;
begin
  Result := _Log;
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

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  FileName, Content, Line: String;
  TextStream: TextFile;
begin
  FileName := TTemplateLog.New('{AppPath}demo_{Month}{Year}.log', TInsensitiveTextMatch.New).Build;
  if not FileExists(FileName) then
    Exit;
  Content := EmptyStr;
  AssignFile(TextStream, FileName);
  try
    Reset(TextStream);
    while not Eof(TextStream) do
    begin
      Readln(TextStream, Line);
      Content := Content + Line + sLineBreak;
    end;
  finally
    CloseFile(TextStream);
  end;
  LogMemo.Text := Content;
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
  LogWarning('Warning Log!!!');
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
  _Log.ChangeFilter(LevelFilter);
end;

procedure TMainForm.FilterSetToControls;
begin
  chkLevelLog.Checked := Debug in _Log.Filter;
  chkLevelInfo.Checked := Info in _Log.Filter;
  chkLevelWarning.Checked := Warning in _Log.Filter;
  chkLevelError.Checked := Error in _Log.Filter;
end;

constructor TMainForm.Create(AOwner: TComponent; const Log: ILog);
begin
  inherited Create(AOwner);
  _Log := Log;
  _LogActor := TLogActor.Create(Log);
  LogMemo.Clear;
  FilterSetToControls;
end;

class function TMainForm.New(const Log: ILog): TMainForm;
begin
  Result := TMainForm.Create(Application, Log);
end;

end.
