unit Creational.Prototype.Classes.Example1;

interface

uses
  System.SysUtils,
  System.Generics.Defaults,
  ObjectHelper.Classes;

type
  ICloneableObject = interface
    ['{1366973E-5765-4092-827A-E779C556965B}']
    function GetClone: TObject;
  end;

  TJob = class(TSingletonImplementation, ICloneableObject)
  private
    FJobName: String;
    FJobDepartment: String;
  public
    constructor Create(aJobName, aJobDepartmentName: String); reintroduce;
    function GetClone: TObject;
    function ToString: String; override;
    property JobName: String read FJobName write FJobName;
    property JobDepartment: String read FJobDepartment write FJobDepartment;
  end;

  TEmployee = class(TSingletonImplementation, ICloneableObject)
  private
    FName: String;
    FSurname: String;
    FJob: TJob;
  public
    constructor Create(aFullname: String; aJob: TJob); reintroduce; overload;
    constructor Create(aFullname, aJobName, aJobDepartmentName: String); reintroduce; overload;
    destructor Destroy; override;
    function GetClone: TObject;
    function ToString: String; override;
    property Name: String read FName write FName;
    property Surname: String read FSurname write FSurname;
    property Job: TJob read FJob;
  end;

implementation

{ TEmployee }

constructor TEmployee.Create(aFullname: String; aJob: TJob);
begin
  inherited Create;
  FName    := aFullname.Split([' '])[0];
  FSurname := aFullname.Split([' '])[1];
  FJob     := aJob;
end;

constructor TEmployee.Create(aFullname, aJobName, aJobDepartmentName: String);
begin
  inherited Create;
  Create(aFullName, TJob.Create(aJobName, aJobDepartmentName))
end;

destructor TEmployee.Destroy;
begin
  FJob.Free;
  inherited;
end;

function TEmployee.GetClone: TObject;
begin
  //Result := TEmployee.Create(FName + ' ' + FSurname, TJob(FJob.GetClone));
  //Result := TEmployee(Clone);
  Result := Clone<TEmployee>;
end;

function TEmployee.ToString: String;
begin
  Result := 'Name..........: ' + Name + sLineBreak +
            'Surname.......: ' + Surname + sLineBreak +
            Job.ToString;
end;

{ TJob }

constructor TJob.Create(aJobName, aJobDepartmentName: String);
begin
  inherited Create;
  FJobName       := aJobName;
  FJobDepartment := aJobDepartmentName;
end;

function TJob.GetClone: TObject;
begin
  //Result := TJob.Create(JobName, JobDepartment);
  //Result := TJob(Clone);
  Result := Clone<TJob>;
end;

function TJob.ToString: String;
begin
  Result := 'Job name......: ' + JobName + sLineBreak +
            'Job department: ' + JobDepartment;
end;

end.
