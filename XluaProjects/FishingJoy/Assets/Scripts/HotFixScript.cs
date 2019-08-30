using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
/// <summary>
/// 建立项目与lua的代码的连接。使得项目可以进行热更新hotfix
/// </summary>
public class HotFixScript : MonoBehaviour {

    
    private LuaEnv luaEnv;
	// Use this for initialization
	void Start () {
        luaEnv = new LuaEnv();        //开启lua虚拟机
        luaEnv.AddLoader(MyLoader);   //添加自己的loader
        
        luaEnv.DoString("require 'Fish'");  //根据自定义的loader找到对应模块名的文件


	}
	
	private byte[] MyLoader(ref string filePath)
    {
        string absPath = @"G:\GitHub Projects\LearnXluaExample\XluaProjects\PlayerGamePackage\HotFix\"+filePath+".lua";   //绝对路径
        //string absPath = "./HotFix/Fish.lua";   //相对路径
        return System.Text.Encoding.UTF8.GetBytes(File.ReadAllText(absPath));    //将读到的所有内容转换成bytes返回
    }

    private void OnDisable()
    {
        luaEnv.DoString("require 'FishDispose'");
    }

    private void OnDestroy()
    {
        luaEnv.Dispose();  //关闭lua虚拟机
    }
}
