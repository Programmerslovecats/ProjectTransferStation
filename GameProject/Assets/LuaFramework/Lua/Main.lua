

------------------------------luaDebugger----------------------------------
local BreakInfoFun,XPCalllFun = require("luadebugjit")("localhost", 7003)
local timer = Timer.New(function() 
BreakInfoFun() end, 1, -1, false)
timer:Start();
---------------------------------------------------------------------------

--主入口函数。从这里开始lua逻辑
function Main()					
	print("logic start");
	-- cube=UnityEngine.GameObject.CreatePrimitive(UnityEngine.PrimitiveType.Cube);
	-- cube.name="MyCube";
	--cube.transform:DOMove()
	--获取专属delegate
	--event:Get()
	
	
end




--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end

--[[function()
		return cube.transform.Position
	end,function(x)
		cube.transform.Position=x
	end,Vector3(100,100,100),10]]