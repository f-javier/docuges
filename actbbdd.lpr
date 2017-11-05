program actbbdd;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LResources, ActualizaBBDD, funciones, zcomponent;

{$IFDEF WINDOWS}{$R actbbdd.rc}{$ENDIF}

begin
  {$I actbbdd.lrs}
  Application.Initialize;
  Application.CreateForm(TFActualizaBBDD, FActualizaBBDD);
  Application.Run;
end.

