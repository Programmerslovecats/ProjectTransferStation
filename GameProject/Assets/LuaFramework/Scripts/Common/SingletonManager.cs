using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine.SocialPlatforms;

public class SingletonManager<T> where T:new() //where T : new()为泛型约束，通俗来说就是确保T类型是可以被new的
{
    private static readonly T _instance = (T)Activator.CreateInstance(typeof(T), true);
    private static object _lock = new object();
    public static T GetInstance()
    {
        lock(_lock)
        {
            return _instance;
        }
     }
}

