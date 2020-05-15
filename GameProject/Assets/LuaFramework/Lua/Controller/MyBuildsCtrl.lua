require "Common/define"


MyBuildsCtrl={}

local this=MyBuildsCtrl

local transform;
local gameObject;
local behaviour;

function MyBuildsCtrl.New()
    return MyBuildsCtrl
end

function MyBuildsCtrl.Awake()
    print("MyBuildsCtrl.Awake is open")
    panelMgr:CreatePanel('test/MyBuilds', this.OnCreate);
end



function MyBuildsCtrl.Start()
    print(" MyBuildsCtrl.Start is open")
end

function MyBuildsCtrl.OnCreate(obj)
    transform=obj.transform;
    gameObject=obj;
    print(tostring(child(gameObject,'btnLogin').name))
    -- behaviour=transform:GetComponent('LuaBehaviour'); 
    -- behaviour:AddClick(MyBuildsPanel.transform:Find("btnLogin").gameObject,this.OnClick);
    -- print(transform:Find("imgBackground").gameObject.name);
    print(tostring(transform:Find("btnLogin").gameObject.name))
    UIEventListen:AddClick(transform:Find("btnLogin").gameObject,this.OnClick);
    resMgr:LoadPrefab("test/MyBuilds",{"MyBuildsItem"},this.InitPanel)


end


--注册碰撞事件
-- EventManager.AddEventCallBack("OnCollisionEnter",function(myObj,otherObj)
--     LuaFramework.Util.LogError(myObj.name.."        "..otherObj.name)
-- end)

function ActionEvent()
    ---接收消息回调
    EventManager.AddEventCallBack("TestEventCallBack",function(str)
        print(str.."111111111111111")
    -- EventManager.RemoveEventCallBack("TestEventCallBack") --移除这个事件的回调
    end)

    EventManager.AddEventCallBack("TestEventCallBack",Test)

    EventManager.AddEventCallBack("TestEventCallBack2",function()
        print(" TestEventCallBack2  is  open")
    end)

    -- local Player=UnityEngine.GameObject.Find("Player")
    -- local Player1=UnityEngine.GameObject.Find("Player1")
    -- local Player2=UnityEngine.GameObject.Find("Player2")
    -- local Player3=UnityEngine.GameObject.Find("Player3")
    -- local Player4=UnityEngine.GameObject.Find("Player4")
    
    -- PeriodCallBackMng:AddCallBack(CallBackEnum.CollisionEnter,Player,function(obj)
    --     print(obj[0].name.." CollisionEnter is invoke  Collistion obj is"..obj[1].name)
    -- end)
    -- PeriodCallBackMng:AddCallBack(CallBackEnum.CollisionEnter,Player1,function(obj)
    --     print(obj[0].name.." CollisionEnter is invoke  Collistion obj is"..obj[1].name)
    -- end)
    -- PeriodCallBackMng:AddCallBack(CallBackEnum.CollisionEnter,Player2,function(obj)
    --     print(obj[0].name.." CollisionEnter is invoke  Collistion obj is"..obj[1].name)
    -- end)
    -- PeriodCallBackMng:AddCallBack(CallBackEnum.CollisionEnter,Player3,function(obj)
    --     print(obj[0].name.." CollisionEnter is invoke  Collistion obj is"..obj[1].name)
    -- end)
    -- PeriodCallBackMng:AddCallBack(CallBackEnum.CollisionEnter,Player4,function(obj)
    --     print(obj[0].name.." CollisionEnter is invoke  Collistion obj is"..obj[1].name)
    -- end)
    -- Player:AddComponent(typeof(LuaFramework.LuaBehaviour))
    -- Player1:AddComponent(typeof(LuaFramework.LuaBehaviour))
    -- Player2:AddComponent(typeof(LuaFramework.LuaBehaviour))
    -- Player3:AddComponent(typeof(LuaFramework.LuaBehaviour))
    -- Player4:AddComponent(typeof(LuaFramework.LuaBehaviour))
    -- local dic=periodCallBackMng:GetObjAllCallBack(Player1)
    -- local iter = dic:GetEnumerator()
    -- while iter:MoveNext() do
    --     local v = iter.Current.Value
    --     print("key = "..iter.Current.Key);    
    --     print("Value = "..tostring(v))                        
    -- end

end

function Test(str)
    print(str.."22222222222")
    --EventManager.RemoveEventCallBack("TestEventCallBack",Test) --移除这个事件类型的这个handle回调
    --EventManager.RemoveAllEventCallBack('TestEventCallBack'); --移除这个事件类型下添加的所有handle回调
    --EventManager.RemoveAllEvent()--移除全部事件监听
end


function MyBuildsCtrl.InitPanel(objs)
    local count=8
    for i=1,count,1 do
        local go=newObject(objs[0])
        PeriodCallBackMng:AddCallBack(CallBackEnum.Awake,go,function()
            print("Awake callback is invoke")
        end)
        go:AddComponent(typeof(LuaFramework.LuaBehaviour))
        go.name=objs[0].name..i
        go.transform:Find('txtItemName'):GetComponent("Text").text=objs[0].name..i
        go.transform:SetParent(transform:Find("imgBackground"))
        UIEventListen:AddClick(go,this.OnItemClick)
    end
end


function MyBuildsCtrl.OnItemClick(obj)
    ---测试发送消息
    EventManager.DispenseEvent("TestEventCallBack","发送事件成功！！")
    EventManager.DispenseEvent("TestEventCallBack2")

   
    
    print(obj.name..">>>>>>>>>>>>>>>>>>>>>>>>>>OnItemClick is click")
    obj.transform:Find('txtItemName'):GetComponent("Text").text=math.random(0,10000);
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Message);
    buffer:WriteByte(ProtocalType.BINARY);
    buffer:WriteString(obj.name);
    buffer:WriteInt(200);
    networkMgr:SendMessage(buffer);

    -- local tim=Timer.New(MyBuildsCtrl.timerTest,1,-1,false)
    -- tim:Start()

end

function MyBuildsCtrl.timerTest()
    print("Test Timer Method Print")
end


function MyBuildsCtrl.OnClick(obj)
    print(obj.name..">>>>>>>>>>>>  btnLogin is click")

    UIEventListen:RemoveAllClick()
    --UIEventListen:RemoveClick(transform:Find("btnLogin").gameObject);
    UIEventListen:DebugAction()

    FixedUpdateBeat:Connect(this.Update2)

    coroutine.start(function()
        coroutine.wait(3)
        -- UpdateBeat:RemoveListener(updatHandle1)
        -- UpdateBeat:RemoveListener(updatHandle2)
        --UpdateBeat:Clear()
        FixedUpdateBeat:DisConnect(this.Update2)
        -- UpdateBeat:DisConnect(this.Update2)
    end)
end

function MyBuildsCtrl.Update1()
    print("每帧调用1111111111111111111");
end
function MyBuildsCtrl.Update2()
    print("每帧调用2222222222222");
end

ActionEvent() --注册事件回调

return MyBuildsCtrl 
