{
  Copyright (c) 2020, Vencejo Software
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
    gbSeverityFilter: TGroupBox;
    chkSeverityLog: TCheckBox;
    chkSeverityInfo: TCheckBox;
    chkSeverityWarning: TCheckBox;
    chkSeverityError: TCheckBox;
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
    procedure WriteDebug(const Text: String);
    procedure WriteInfo(const Text: String);
    procedure WriteException(const Error: Exception; const RaiseException: Boolean);
    procedure WriteError(const Text: String);
    procedure WriteWarning(const Text: String);
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

procedure TMainForm.WriteDebug(const Text: String);
begin
  _LogActor.WriteDebug(Text);
end;

function TMainForm.LogEnabled: Boolean;
begin
  Result := _LogActor.LogEnabled;
end;

procedure TMainForm.WriteException(const Error: Exception; const RaiseException: Boolean);
begin
  _LogActor.WriteException(Error, RaiseException);
end;

procedure TMainForm.WriteError(const Text: String);
begin
  _LogActor.WriteError(Text);
end;

function TMainForm.Log: ILog;
begin
  Result := _Log;
end;

procedure TMainForm.WriteInfo(const Text: String);
begin
  _LogActor.WriteInfo(Text);
end;

procedure TMainForm.WriteWarning(const Text: String);
begin
  _LogActor.WriteWarning(Text);
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
  WriteDebug('Something to debug');
end;

procedure TMainForm.btnErrorClick(Sender: TObject);
var
  Err: Exception;
begin
  Err := Exception.Create('Error founded');
  try
    WriteException(Err, False);
  finally
    Err.Free;
  end
end;

procedure TMainForm.btnLogClick(Sender: TObject);
begin
  WriteInfo('Info line to ignore');
end;

procedure TMainForm.btnWarningClick(Sender: TObject);
begin
  WriteWarning('Warning Log!!!');
end;

procedure TMainForm.ControlsToFilterSet;
var
  SeverityFilter: TLogSeverityFilter;
begin
  SeverityFilter := [];
  if chkSeverityLog.Checked then
    Include(SeverityFilter, Debug);
  if chkSeverityInfo.Checked then
    Include(SeverityFilter, Info);
  if chkSeverityWarning.Checked then
    Include(SeverityFilter, Warning);
  if chkSeverityError.Checked then
    Include(SeverityFilter, Error);
  _Log.ChangeFilter(SeverityFilter);
end;

procedure TMainForm.FilterSetToControls;
begin
  chkSeverityLog.Checked := Debug in _Log.Filter;
  chkSeverityInfo.Checked := Info in _Log.Filter;
  chkSeverityWarning.Checked := Warning in _Log.Filter;
  chkSeverityError.Checked := Error in _Log.Filter;
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
