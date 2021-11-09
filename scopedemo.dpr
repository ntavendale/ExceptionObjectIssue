//Delphi 11 Cosole Aplication.

program scopedemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  WinApi.Windows,
  BasicInterface in 'BasicInterface.pas',
  Console.Vista in 'Console.Vista.pas';

var
  FEvent: THandle;
  cConstInteger : Integer = 5;

procedure SetUpConsole(AFontSize: DWORD);
begin
  // Must be vista or higer
  if NOT CheckWin32Version(6) then
    EXIT;

  var ci: TConsoleFontInfoEx;
  FillChar(ci, SizeOf(TConsoleFontInfoEx), 0);
  ci.cbSize := SizeOf(TConsoleFontInfoEx);

  var ch: THandle := GetStdHandle(STD_OUTPUT_HANDLE);
  GetCurrentConsoleFontEx(ch, FALSE, @ci); // AV Here!

  ci.FontFamily := FF_DONTCARE;
  ci.FaceName := 'Consolas';
  ci.dwFontSize.X := 0;
  ci.dwFontSize.Y := AFontSize;
  ci.FontWeight := FW_BOLD;
  SetCurrentConsoleFontEx(ch, FALSE, @ci);
end;

function ConsoleEventProc(CtrlType: DWORD): BOOL; stdcall;
begin
  if (CTRL_CLOSE_EVENT = CtrlType) or (CTRL_C_EVENT = CtrlType) then
  begin
    SetEvent(FEvent);
  end;
  Result := True;
end;

procedure InterfaceScope;
var
  Alan: ISimpleInterface;
begin
  Alan := TSimpleClass.Create('Alan');
end;

procedure DestructionOrderDemo;
var
  Alan, Susan: ISimpleInterface;
begin
  Susan := TSimpleClass.Create('Susan');
  Alan := TSimpleClass.Create('Alan');
  WriteLn(' '); //put in break
end;

procedure RaisedExceptionDemo;
var
  LList: TStrings;
begin
  var Susan: ISimpleInterface := TSimpleClass.Create('Susan');
  WriteLn(' '); //
  WriteLn((LList.Count));
end;

procedure ExceptionDemo(AInput: Integer);
begin
  var Susan: ISimpleInterface := TSimpleClass.Create('Susan');
  WriteLn(' '); //
  WriteLn((1/AInput)); //Output Should Be: Destroying Susan.
end;

procedure LocalizeScopeDemo;
begin
  // Just use a begin..end block to drop scope in anywhere and ensure
  // Interface implmentations are freed
  begin
    var Lois: ISimpleInterface := TSimpleClass.Create('Lois');
  end; //Lois goes out of scope and will be destroyed

  WriteLn(' '); //
  var Frank: ISimpleInterface := TSimpleClass.Create('Frank');
end;

begin
  SetUpConsole(20);
  SetConsoleCtrlHandler(@ConsoleEventProc, True);
  FEvent := CreateEvent(nil, TRUe, FALSE, nil);

  WriteLn('Run code that gives EAccessViloation:');
  try
    try
       RaisedExceptionDemo;
    except
      on E: Exception do
      begin
        var LExceptionPointer := AcquireExceptionObject;
        if nil <> LExceptionPointer then
        begin
          Writeln('Got Exception Pointer In ExceptionHandler');
        end;
        Writeln(E.ClassName, ': ', E.Message);
      end;
    end;

    WriteLn('');
    WriteLn('');
    WriteLn('Run code that divides by zero:');
    try
       ExceptionDemo(0);
    except
      on E: Exception do
      begin
        var LExceptionPointer := AcquireExceptionObject;
        if nil <> LExceptionPointer then
        begin
          Writeln('Got Exception Pointer In ExceptionHandler');
        end;
        Writeln(E.ClassName, ': ', E.Message);
      end;
    end;
    WaitForSingleObject(FEvent, INFINITE);

  finally
    CloseHandle(FEvent);
  end;
end.



