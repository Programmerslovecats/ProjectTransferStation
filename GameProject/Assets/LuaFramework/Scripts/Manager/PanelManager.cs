using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;

namespace LuaFramework {
    public class PanelManager : Manager {
        private Transform parent;
        
        ///存储创建过的Panel  
        private Dictionary<string, GameObject> UIDic = new Dictionary<string, GameObject>(); 
        
        Transform Parent {
            get {
                if (parent == null)
                {
                    GameObject go = GameObject.FindWithTag("GuiCamera");
                    if (go != null)
                    {
                        parent = go.transform;
                    }
                    else
                    {
                        go = new GameObject("UIManager");
                        go.layer = LayerMask.NameToLayer("GuiCamera");
                        parent = go.transform;
                    }
                    DontDestroyOnLoad(go);
                }
                return parent;
            }
        }

        /// <summary>
        /// 创建panel 从Assets包中解压
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, LuaFunction func = null) {

            string[] str = name.Split('/');
            string assetName = str[str.Length-1]+ "Panel";
            string abName = name.ToLower() + AppConst.ExtName;
            if (Parent.Find(name) != null) return;

#if ASYNC_MODE
            ResManager.LoadPrefab(abName, assetName, delegate(UnityEngine.Object[] objs) {
                if (objs.Length == 0) return;
                GameObject prefab = objs[0] as GameObject;
                if (prefab == null) return;

                GameObject go = Instantiate(prefab) as GameObject;
                go.name = assetName;
                go.layer = LayerMask.NameToLayer("Default");
                go.transform.SetParent(Parent);
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.zero;
                go.AddComponent<LuaBehaviour>();

                if (func != null) func.Call(go);
                Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
            });
#else
            GameObject prefab = ResManager.LoadAsset<GameObject>(name, assetName);
            if (prefab == null) return;

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            go.layer = LayerMask.NameToLayer("UI");
            go.transform.SetParent(Parent);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            go.AddComponent<LuaBehaviour>();

            UIDic.Add(assetName, go);
            if (func != null) func.Call(go);
            Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
#endif
        }

        /// <summary>
        /// 删除Panel
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(string name) {
            var panelName = name + "Panel";
            var panelObj = Parent.Find(panelName);
            if (panelObj == null) return;
            UIDic.Remove(panelName);
            Destroy(panelObj.gameObject);
        }
        /// <summary>
        /// 获取panel
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public GameObject GetPanel(string name)
        {
            return UIDic.ContainsKey(name) ? UIDic[name] : null;
        }

        /// <summary>
        /// 判断panel是否创建过
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public bool isContainsPanel(string name)
        {
            return UIDic.ContainsKey(name);
        }

        /// <summary>
        /// 关闭全部UI界面
        /// </summary>
        public void CloseAllPanel()
        {
            foreach (var panel in UIDic)
            {
                panel.Value.SetActive(false);
            }
        }

        /// <summary>
        /// 删除全部UI界面
        /// </summary>
        public void DestroyAllPanel()
        {
            foreach (var panel in UIDic)
            {
                ClosePanel(panel.Key);
            }

        }
        

    }
}