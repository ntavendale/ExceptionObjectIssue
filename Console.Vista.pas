unit Console.Vista;

interface

uses
  System.SysUtils, WinApi.Windows;


type
  PConsoleFontInfoEx = ^TConsoleFontInfoEx;
  TConsoleFontInfoEx = record
    cbSize: ULONG;
    nFont: DWORD;
    dwFontSize: TCoord;
    FontFamily: UINT;
    FontWeight: UINT;
    FaceName: array [0..(LF_FACESIZE-1)] of Char;
  end;

function SetCurrentConsoleFontEx(ConsoleOutput: THandle; MaximumWindow: BOOL;
  ConsoleInfo: PConsoleFontInfoEx): BOOL; stdcall;
  external kernel32 name 'SetCurrentConsoleFontEx';
function GetCurrentConsoleFontEx(ConsoleOutput: THandle; MaximumWindow: BOOL;
  ConsoleInfo: PConsoleFontInfoEx): BOOL; stdcall;
  external kernel32 name 'GetCurrentConsoleFontEx';

implementation

end.
