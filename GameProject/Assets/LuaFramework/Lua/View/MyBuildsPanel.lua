

MyBuildsPanel={}
local this=MyBuildsPanel

function MyBuildsPanel.Awake(obj)
    this.gameObject=obj;
    this.transform=obj.transform;
    this.InitPanel();
end

function MyBuildsPanel.InitPanel()
end


function MyBuildsPanel.OnDestroy()
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   MyBuildsPanel.OnDestroy")
end

return MyBuildsPanel;
