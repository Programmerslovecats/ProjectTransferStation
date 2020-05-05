using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework {
    public class LuaBehaviour : View {
        private string data = null;
        private Dictionary<string, LuaFunction> buttons = new Dictionary<string, LuaFunction>();

        protected void Awake() {
            Util.CallMethod(name, "Awake", gameObject);
            //Util.CallMethod(gameObject.GetInstanceID().ToString(), "Awake", gameObject);
        }

        protected void Start() {
            Util.CallMethod(name, "Start");
        }

        protected void OnTriggerEnter(Collider other)
        {
            Debugger.Log(other.gameObject.name);
            //触发器回调
            Util.CallMethod(name, "OnTriggerEnter",other.gameObject);
        }
        protected void OnTriggerExit(Collider other)
        {
            //离开触发器回调
            Util.CallMethod(name, "OnTriggerExit", gameObject, other.gameObject);
        }

        protected void OnCollisionEnter(Collision collision)
        {
            //进入碰撞回调
            Util.CallMethod(name, "OnCollisionEnter", gameObject,collision.gameObject);
        }

        protected void OnCollisionExit(Collision collision)
        {
            //离开碰撞回调
            Util.CallMethod(name, "OnCollisionExit", gameObject, collision.gameObject);
        }

       

        protected void OnClick() {
            Util.CallMethod(name, "OnClick");   
        }

        protected void OnClickEvent(GameObject go) {
            Util.CallMethod(name, "OnClick", go);
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null || luafunc == null) return;
            buttons.Add(go.name, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate() {
                    luafunc.Call(go);
                }
            );
        }

        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go.name, out luafunc)) {
                luafunc.Dispose();
                luafunc = null;
                buttons.Remove(go.name);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
           
            buttons.Clear();
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            ClearClick();
#if ASYNC_MODE
            string abName = name.ToLower().Replace("panel", "");
            ResManager.UnloadAssetBundle(abName + AppConst.ExtName);
#endif
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}