unit BasicInterface;

interface

uses
  System.SysUtils, System.Classes;

type
  ISimpleInterface = interface
  end;

  TSimpleClass = class(TInterfacedObject, ISimpleInterface)
  private
    FName: String;
  public
    constructor Create(AName: String); virtual;
    destructor Destroy; override;
  end;

implementation

constructor TSimpleClass.Create(AName: String);
begin
  FName := AName;
  WriteLn(String.Format('Creating %s', [FName]));
end;

destructor TSimpleClass.Destroy;
begin
  var LExceptionPointer := AcquireExceptionObject;
  if nil <> LExceptionPointer then
    WriteLn(String.Format('Got Exception Pointer in destructor. Destroying %s', [FName]))
  else
     WriteLn(String.Format('DID NOT GET EXCEPTION POINTER IN DESTRUCTOR!!! Destroying %s', [FName]));
  inherited Destroy;
end;

end.
