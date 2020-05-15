require "Common/functions"



CtrlNames = {
	Prompt = "PromptCtrl",
	Message = "MessageCtrl",
	MyBuilds="MyBuildsCtrl",
}

PanelNames = {
	"PromptPanel",	
	"MessagePanel",
	"MyBuildsPanel",
}

--协议类型--
ProtocalType = {
	BINARY = 0,
	PB_LUA = 1,
	PBC = 2,
	SPROTO = 3,
}
--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY;

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;

EventManager = require "Module/Manager/EventManager"

UIEventListen=UIEventListen.New();	--非静态类记得new实例化一下
resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
networkMgr = LuaHelper.GetNetManager();

PeriodCallBackMng=LuaFramework.PeriodCallBackManager.New();
CallBackEnum=LuaFramework.PeriodCallBackManager.CallBackEnum

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;