using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using UnityEngine.UI;
using LuaFramework;
using System;

/// <summary>
/// 管理UI的Click事件
/// </summary>
public class UIEventListen 
{

    private Dictionary<GameObject, UnityEngine.Events.UnityAction> ClickDic = new Dictionary<GameObject, UnityEngine.Events.UnityAction>();

    public void AddClick(GameObject go, LuaFunction func)
    {
        if (go == null || func == null)
        {
            Debugger.Log("请检查参数是否传递正确!!");
            return;
        }

        ClickDic.Add(go, delegate
        {
            func.Call(go);
        });
        go.GetComponent<Button>().onClick.AddListener(ClickDic[go]);
    }

    public void RemoveClick(GameObject go)
    {
        Debug.Log(go.name);
        if (ClickDic.FTryGetValue(go) == false)
        {
            Debugger.Log(go+"是否存在于字典："+ ClickDic.FTryGetValue(go));
            return;
        }
        go.GetComponent<Button>().onClick.RemoveListener(ClickDic[go]);
        ClickDic.Remove(go);
    }

    public void RemoveAllClick()
    {
        List<GameObject> list = new List<GameObject>();
        foreach (var item in ClickDic)
        {
            list.Add(item.Key);
        }

        for (int i = 0; i < list.Count; i++)
        {
            RemoveClick(list[i]);
        }
        
    }

    public void DebugAction()
    {
        if (ClickDic.Count <= 0)
        {
            Debugger.Log("OnClick Dictionary is Null ");
            return;
        }
       var dic  = ClickDic.GetEnumerator();
        while(dic.MoveNext())
        {
            Debugger.Log(dic.Current.Key.name + "                 " + dic.Current.Value.ToString());
        }

    }

    

}
