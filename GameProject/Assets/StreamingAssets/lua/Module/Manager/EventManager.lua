
require "Common/functions"

EventManager={}

local this=EventManager
this['EventList']={}    --用来记录所有添加的事件

--[[
    @desc: 添加对应的事件回调
    author:{author}
    time:2020-05-05 14:01:24
    --@messageName:事件的名称
	--@handle: 回调的方法
    @return:
]]
function this.AddEventCallBack(messageName,handle)

    assert(IsFunction(handle),
    " Please input call handle , value 2 type is function "
    )
    assert(IsString(messageName),
    "Please input messageName , value 1 type is string "
    )
    --Event.AddListener(messageName,handle)

    if IsTable(this['EventList'][messageName])==false then
        this['EventList'][messageName]={}
    end
    table.insert(this['EventList'][messageName],handle)--事件添加记录
end

--[[
    @desc: 移除对应的事件回调
    author:{author}
    time:2020-05-05 14:01:02
    --@messageName: 事件的名称
    @return:
]]
function this.RemoveEventCallBack(messageName,handle)
    if IsTable(this['EventList'][messageName])==false or next(this['EventList'][messageName])==nil then 
        logWarn(messageName.." events have not been added")
        return 
    end
    --Event.RemoveListener(messageName,this['EventList'][messageName])
    for k,v in pairs(this['EventList'][messageName]) do
        if v==handle then
            this['EventList'][messageName][k]=nil
        end
    end
end

--[[
    @desc: 分发事件
    author:{author}
    time:2020-05-05 14:00:31
    --@messageName:事件名称
	--@args: 事件的参数
    @return:
]]
function this.DispenseEvent(messageName,...)
    if IsTable(this['EventList'][messageName])==false or next(this['EventList'][messageName])==nil then
        logWarn(messageName.." events have not beed added or has been remove")
        return
    end
    --Event.Brocast(messageName,...)
    local currentEventList=this['EventList'][messageName]
    for k,v in pairs(currentEventList) do
        v(...)
    end
end

--[[
    @desc: 移除对应messageName的全部事件监听
    author:{author}
    time:2020-05-05 17:16:37
    --@messageName: 事件监听的名称
    @return:
]]
function this.RemoveAllEventCallBack(messageName)
    if IsTable(this['EventList'][messageName])==false or next(this['EventList'][messageName])==nil then
        logWarn(messageName.." events have not beed added or has been remove")
        return 
    end
    for k,v in pairs(this['EventList'][messageName]) do
        this.RemoveEventCallBack(messageName,v)
    end
    this['EventList'][messageName]={}
end


--[[
    @desc: 移除全部的事件监听
    author:{author}
    time:2020-05-05 17:17:38
    @return:
]]
function this.RemoveAllEvent()
    this['EventList']={}
end

--[[
    @desc: 判断是否添加过这个事件
    author:{author}
    time:2020-05-05 14:19:04
    --@messageName: 事件的名称
    @return: 如果添加过返回 绑定这个事件的函数表，否则返回nil
]]
function this.FindEvent(messageName)
    if IsTable(this['EventList'][messageName])==false or next(this['EventList'][messageName])==nil then
        return nil
    else
        return this['EventList'][messageName]
    end
end

function this.CshapPeriodCallBack(periodName,...)
    print(periodName)
    this.DispenseEvent(periodName,...)
end



return EventManager