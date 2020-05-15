using LuaInterface;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace LuaFramework
{
    /// <summary>
    /// 分发碰撞回调到Lua
    /// </summary>
    /// 
    public static class DictExtenison
    {
        /// <summary>
        /// 字典扩展 获取value值
        /// </summary>
        /// <typeparam name="Tkey"></typeparam>
        /// <typeparam name="Tvalue"></typeparam>
        /// <param name="dict"></param>
        /// <param name="tkey"></param>
        /// <returns></returns>
        public static Tvalue FGetValue<Tkey, Tvalue>(this Dictionary<Tkey, Tvalue> dict, Tkey tkey)
        {
            Tvalue value;
            dict.TryGetValue(tkey, out value);
            return value;
        }

        /// <summary>
        ///  字典扩展  判断是否有对应的value值
        /// </summary>
        /// <typeparam name="Tkey"></typeparam>
        /// <typeparam name="Tvalue"></typeparam>
        /// <param name="dict"></param>
        /// <param name="tkey"></param>
        /// <returns></returns>
        public static bool FTryGetValue<Tkey, Tvalue>(this Dictionary<Tkey, Tvalue> dict, Tkey tkey)
        {
            Tvalue value;
            return dict.TryGetValue(tkey, out value);
        }

    }


    public  class PeriodCallBackManager : SingletonManager<PeriodCallBackManager>
    {

        public  enum CallBackEnum
        {
            Awake,
            Start,
            TriggerEnter,
            TriggerExit,
            CollisionEnter,
            CollisionExit,
        }


        public PeriodCallBackManager() { }


        public static Dictionary<CallBackEnum, Dictionary<string, LuaFunction>> PeriodDic = new Dictionary<CallBackEnum, Dictionary<string, LuaFunction>>();

    
        /// <summary>
        /// 执行回调事件
        /// </summary>
        /// <param name="FunName">要添加的Unity函数 枚举</param>
        /// <param name="obj">给对应物体添加回调</param>
        /// <param name="arg">传递的回调参数</param>
        public void CallBack(CallBackEnum FunName, GameObject obj, params object[] arg)
        {
            
            if (PeriodDic.Count == 0) return; //字典为空直接返回
            if (PeriodDic.FTryGetValue(FunName))
            {

                if(PeriodDic[FunName].FTryGetValue(obj.GetInstanceID().ToString()))
                {
                    PeriodDic[FunName][obj.GetInstanceID().ToString()].Call(arg);
                }
            }

        }


        /// <summary>
        /// 添加某个Unity函数回调的指定方法
        /// </summary>
        /// <param name="FunName">要添加的Unity函数 枚举</param>
        /// <param name="obj">给对应物体添加回调</param>
        /// <param name="func">lua层回调的方法</param>
        public void AddCallBack(CallBackEnum FunName, GameObject obj, LuaFunction func)
        {
            try
            {
                if ( !PeriodDic.FTryGetValue(FunName))
                {
                    Dictionary<string, LuaFunction> dic = new Dictionary<string, LuaFunction>();
                    dic.Add(obj.GetInstanceID().ToString(), func);
                    PeriodDic.Add(FunName, dic);
                } 
                else
                {
                    if( !PeriodDic[FunName].FTryGetValue(obj.GetInstanceID().ToString()))
                    {
                        PeriodDic[FunName].Add(obj.GetInstanceID().ToString(), func);
                    }
                    else
                    {
                        PeriodDic[FunName][obj.GetInstanceID().ToString()] = func;
                    }

                }
            }
            catch (Exception e)
            {
                Debugger.LogError(e);
            }
        }

        /// <summary>
        /// 清除某个Unity函数回调的指定方法
        /// </summary>
        /// <param name="FunName">要清除的Unity函数 枚举</param>
        /// <param name="obj">添加回调的对应物体</param>
        public void RemoveCallBack(CallBackEnum FunName, GameObject obj)
        {
            try
            {
                if (PeriodDic.Count == 0 || !PeriodDic.FTryGetValue(FunName)) return; //字典为空或者没有对应函数的注册直接返回

                if(PeriodDic[FunName].FTryGetValue(obj.GetInstanceID().ToString()))
                {
                    PeriodDic[FunName].Remove(obj.GetInstanceID().ToString());
                }
            }
            catch (Exception e)
            {
                Debugger.LogError(e);
            }
        }

        
        /// <summary>
        /// 清除全部的回调方法    慎用 
        /// </summary>
        public void RemoveAll()
        {
            PeriodDic.Clear(); //清空字典
        }

        /// <summary>
        /// 取消该物体的所有注册回调
        /// </summary>
        /// <param name="obj">对应的物体</param>
        public void Destroy(GameObject obj)
        {
            RemoveCallBack(CallBackEnum.Awake, obj);
            RemoveCallBack(CallBackEnum.Start, obj);
            RemoveCallBack(CallBackEnum.TriggerEnter, obj);
            RemoveCallBack(CallBackEnum.TriggerExit, obj);
            RemoveCallBack(CallBackEnum.CollisionEnter, obj);
            RemoveCallBack(CallBackEnum.CollisionExit, obj);
        }

        public LuaFunction GetObjCallBack(CallBackEnum FunName,GameObject obj)
        {
            if (PeriodDic.Count == 0 || !PeriodDic.FTryGetValue(FunName) || !PeriodDic[FunName].FTryGetValue(obj.GetInstanceID().ToString()))
            {
                return null; //字典为空或者没有对应函数的注册直接返回
            }
            return PeriodDic[FunName][obj.GetInstanceID().ToString()];
        }

        public Dictionary<string, LuaFunction> GetObjAllCallBack(GameObject obj)
        {
            Dictionary<string, LuaFunction> directory = new Dictionary<string, LuaFunction>();
            directory.Add("Awake", GetObjCallBack(CallBackEnum.Awake, obj));
            directory.Add("Start", GetObjCallBack(CallBackEnum.Start, obj));
            directory.Add("TriggerEnter", GetObjCallBack(CallBackEnum.TriggerEnter, obj));
            directory.Add("TriggerExit", GetObjCallBack(CallBackEnum.TriggerExit, obj));
            directory.Add("CollisionEnter", GetObjCallBack(CallBackEnum.CollisionEnter, obj));
            directory.Add("CollisionExit", GetObjCallBack(CallBackEnum.CollisionExit, obj));
            
            return directory;
        }

    }
}
