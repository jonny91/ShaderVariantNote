/*************************************************************************************
 *
 * 文 件 名:   Launcher.cs
 * 描    述: 
 * 
 * 创 建 者：  洪金敏 
 * 创建时间：  2023-02-05 14:12:56
*************************************************************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.SceneManagement;

public class Launcher : MonoBehaviour
{
    private void Start()
    {
        Addressables.InitializeAsync().Completed += handle =>
        {
            Addressables.UpdateCatalogs().Completed += h =>
            {
                Addressables.LoadSceneAsync("Assets/Scenes/TestScene.unity");
            };
        };
    }
}