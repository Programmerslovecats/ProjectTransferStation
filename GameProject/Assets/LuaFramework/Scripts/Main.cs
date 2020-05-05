using UnityEngine;
using System.Collections;
using DG.Tweening;
using UnityEngine.SceneManagement;


namespace LuaFramework {

    /// <summary>
    /// </summary>
    public class Main : MonoBehaviour {

        void Start() {
            AppFacade.Instance.StartUp();   //启动游戏
        }
    }
}