unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, Menus,
  StdCtrls, LazUTF8
  //, fgl
  , Generics.Collections
  ;

type
  TActAttr = packed record
    CatName: String;
    ActName: String;
    ActIndex: SizeInt;
  end;

  TActAttrList = specialize TList<TActAttr>;


  { TForm1 }

  TForm1 = class(TForm)
    act1_1: TAction;
    act1_2: TAction;
    act1_3: TAction;
    act2_1: TAction;
    act2_2: TAction;
    act2_3: TAction;
    act2_4: TAction;
    actlist: TActionList;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    ppMnu: TPopupMenu;
    rbAct1: TRadioButton;
    rbAct2: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure rbAct1Change(Sender: TObject);
  private
    FActAttrList: TActAttrList;
    procedure GetActListByCatName(var aName: String; acList: TActionList; out ResultList: TStringList);
  public
    property ActAttrList: TActAttrList read FActAttrList;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.rbAct1Change(Sender: TObject);
const
  act1 = 'act1';
  act2 = 'act2';
var
  CatName: String = '';
  i: Integer = -1;
  ppMnuItem: TMenuItem = nil;
begin

  if (rbAct1.State = cbChecked) then CatName:= act1 else CatName:= act2;
  ppMnu.Items.Clear;


  for i := 0 to Pred(actlist.ActionCount) do
    if (actlist.Actions[i].Category = CatName) then
    begin
      ppMnuItem:= TMenuItem.Create(ppMnu);
      ppMnuItem.Name:= 'ppMnuItem' + TAction(actlist.Actions[i]).Name;
      ppMnuItem.Caption:= TAction(actlist.Actions[i]).Caption;
      ppMnuItem.Action:= TAction(actlist.Actions[i]);
      ppMnu.Items.Add(ppMnuItem);
    end;

end;

procedure TForm1.GetActListByCatName(var aName: String; acList: TActionList;
  out ResultList: TStringList);
var
  tmpName: String = '';
  i: Integer = -1;
begin
  if Assigned(ResultList) then ResultList.Clear;
  if (UTF8Trim(aName) = '') then Exit;

  for i := 0 to Pred(acList.ActionCount) do
  begin
    tmpName:= UTF8Trim(acList.Actions[i].Category);
    if ((tmpName <> '') and (ResultList.IndexOf(tmpName) = -1)) then ResultList.Add(tmpName);
  end;
end;

procedure TForm1.Memo1Click(Sender: TObject);
var
  i: Integer = -1;
  ActAttr: TActAttr;
  CategoryName: String = '';
begin
  FActAttrList.Clear;

  for i := 0 to Pred(actlist.ActionCount) do
  begin
    ActAttr.CatName:= actlist.Actions[i].Category;
    ActAttr.ActName:= actlist.Actions[i].Name;
    ActAttr.ActIndex:= actlist.Actions[i].Index;
    FActAttrList.Add(ActAttr);
  end;

  Memo1.Clear;
  Memo1.Lines.Add('');

  for i := 0 to Pred(FActAttrList.Count) do
  begin
    CategoryName:= FActAttrList[i].CatName;

    if (CategoryName = FActAttrList[i].CatName) then
    Memo1.Lines.Add(Format('%s: %s[index #%d]',[ActAttrList[i].CatName, ActAttrList[i].ActName,ActAttrList[i].ActIndex]));
  end;

  rbAct1Change(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FActAttrList:= TActAttrList.Create;
  FActAttrList.Capacity:= 100;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FActAttrList.Free;
end;

end.

