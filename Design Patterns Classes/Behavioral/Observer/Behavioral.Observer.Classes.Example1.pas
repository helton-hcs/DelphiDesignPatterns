unit Behavioral.Observer.Classes.Example1;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Defaults, System.Generics.Collections;

type
  TVideoOperation = (voInsert, voUpdate, voDelete);
  TVideoType      = (vtComedy, vtGame, vtSports);
  TVideoTypes     = set of TVideoType;

  TVideo = class
  strict private
    FVideoName: String;
    FVideoType: TVideoType;
  public
    constructor Create(aVideoName: String; aVideoType: TVideoType); reintroduce;
    property VideoName: String read FVideoName;
    property VideoType: TVideoType read FVideoType;
    function ToString: String; override;
  end;

  IObserver = interface
    ['{6406B5E8-D936-4DA5-8CF1-EF7668216A78}']
    procedure Update(AVideo: TVideo; aVideoOperation: TVideoOperation);
    function GetVideoTypePreferences: TVideoTypes;
  end;

  ISubject = interface
    ['{469A7080-3A7E-4B69-9FEE-FE7B7CB6AB5A}']
    procedure RegisterObserver(aObs: IObserver);
    procedure UnregisterObserver(aObs: IObserver);
    procedure NotifyObservers;
  end;

  TYouTube = class(TSingletonImplementation, ISubject)
  strict private
    FCurrentVideo: TVideo;
    FCurrentVideoOperation: TVideoOperation;
    FObservers: TList<IObserver>;
    FVideosAvailable: TList<TVideo>;
  public
    constructor Create;
    destructor Destroy; override;

    {ISSSubject}
    procedure RegisterObserver(aObs: IObserver);
    procedure UnregisterObserver(aObs: IObserver);
    procedure NotifyObservers;

    function AddVideo(const aVideo: TVideo): Boolean;
    function RemoveVideo(const aVideo: TVideo): Boolean;
    function GetVideosList: String;
    property CurrentVideo: TVideo read FCurrentVideo;
    property CurrentVideoOperation: TVideoOperation read FCurrentVideoOperation;
    property Observers: TList<IObserver> read FObservers;
    property VideosAvailable: TList<TVideo> read FVideosAvailable;
  end;

  TPerson = class(TSingletonImplementation, IObserver)
  strict private
    FName: String;
    FVideos: TList<TVideo>;
    FVideoTypePreferences: TVideoTypes;
  private
    function GetVideoTypePreferences: TVideoTypes;
  public
    constructor Create(aName: String; aVideoTypePreferences: TVideoTypes); reintroduce;
    destructor Destroy; override;

    { ISSObserver }
    procedure Update(AVideo: TVideo; aVideoOperation: TVideoOperation);

    function GetVideosList: String;
    property Name: String read FName;
    property Videos: TList<TVideo> read FVideos;
    property VideoTypePreferences: TVideoTypes read GetVideoTypePreferences;
  end;

implementation

uses
  System.StrUtils, System.TypInfo;

{ TSSYouTube }

constructor TYouTube.Create;
begin
  inherited;
  FObservers       := TList<IObserver>.Create;
  FVideosAvailable := TList<TVideo>.Create;
end;

destructor TYouTube.Destroy;

  procedure ClearVideosList;
  var
    Enumerator: TEnumerator<TVideo>;
  begin
    Enumerator := VideosAvailable.GetEnumerator;
    while Enumerator.MoveNext do
      Enumerator.Current.Free;
    Enumerator.Free;
    VideosAvailable.Clear;
  end;

begin
  FreeAndNil(FObservers);
  ClearVideosList;
  FreeAndNil(FVideosAvailable);
  inherited;
end;

function TYouTube.GetVideosList: String;
var
  Video: TVideo;
begin
  Result := 'YouTube Videos';
  for Video in VideosAvailable do
    Result := Result + IfThen(Trim(Result) <> '', sLineBreak+StringOfChar('=', 10)+sLineBreak, '') + Video.ToString;
end;

function TYouTube.AddVideo(const aVideo: TVideo): Boolean;
begin
  Result := not VideosAvailable.Contains(aVideo);
  if Result then
  begin
    VideosAvailable.Add(aVideo);
    FCurrentVideo          := aVideo;
    FCurrentVideoOperation := voInsert;
    NotifyObservers;
  end;
end;

function TYouTube.RemoveVideo(const aVideo: TVideo): Boolean;
begin
  Result := VideosAvailable.Contains(aVideo);
  if Result then
  begin
    VideosAvailable.Remove(aVideo);
    FCurrentVideo          := aVideo;
    FCurrentVideoOperation := voDelete;
    NotifyObservers;
  end;
end;

procedure TYouTube.NotifyObservers;
var
  Observer: IObserver;
begin
  for Observer in Observers do
  begin
    if CurrentVideo.VideoType in Observer.GetVideoTypePreferences then
      Observer.Update(CurrentVideo, CurrentVideoOperation);
  end;
end;

procedure TYouTube.RegisterObserver(aObs: IObserver);
begin
  if not Observers.Contains(aObs) then
    Observers.Add(aObs);
end;

procedure TYouTube.UnregisterObserver(aObs: IObserver);
begin
  if Observers.Contains(aObs) then
    Observers.Remove(aObs);
end;

{ TSSPerson }

constructor TPerson.Create(aName: String; aVideoTypePreferences: TVideoTypes);
begin
  FName := AName;
  FVideos := TList<TVideo>.Create;
  FVideoTypePreferences := aVideoTypePreferences;
end;

destructor TPerson.Destroy;
begin
  FreeAndNil(FVideos);
  inherited;
end;

function TPerson.GetVideosList: String;
var
  Video: TVideo;
begin
  Result := 'Videos of "'+Name+'"';
  for Video in Videos do
    Result := Result + IfThen(Trim(Result) <> '', sLineBreak+StringOfChar('=', 10)+sLineBreak, '') + Video.ToString;
end;

function TPerson.GetVideoTypePreferences: TVideoTypes;
begin
  Result := FVideoTypePreferences;
end;

procedure TPerson.Update(AVideo: TVideo;
  aVideoOperation: TVideoOperation);
begin
  case aVideoOperation of
    voInsert:
      Videos.Add(AVideo);
//    voUpdate: ;
    voDelete:
      Videos.Remove(AVideo);
  end;

end;

{ TSSVideo }

constructor TVideo.Create(aVideoName: String; aVideoType: TVideoType);
begin
  inherited Create;
  FVideoName := aVideoName;
  FVideoType := aVideoType;
end;

function TVideo.ToString: String;
begin
  Result := Format('Name: %s'+sLineBreak+
                   'VideoType: %s',
                   [VideoName, GetEnumName(TypeInfo(TVideoType), Ord(VideoType))]);
end;

end.
