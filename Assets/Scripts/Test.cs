/*************************************************************************************
 *
 * 文 件 名:   Test.cs
 * 描    述: 
 * 
 * 创 建 者：  洪金敏 
 * 创建时间：  2023-02-05 12:02:39
*************************************************************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;

public class Test : MonoBehaviour
{
    [SerializeField]
    private GameObject[] characters;

    private static readonly int OutlineFactor = Shader.PropertyToID("_OutlineFactor");

    /// <summary>
    /// 可莉 multi_compile
    /// </summary>
    /// <param name="selectedIndex"></param>
    public void OnDropValueChanged_可莉_multi_compile(int selectedIndex)
    {
        var character = characters[0];
        SetOutline(character, selectedIndex == 0);
    }

    /// <summary>
    /// 空 shader_feature
    /// </summary>
    /// <param name="selectedIndex"></param>
    public void OnDropValueChanged_空_shader_feature(int selectedIndex)
    {
        var character = characters[2];
        SetOutline(character, selectedIndex == 0);
    }

    private void SetOutline(GameObject character, bool redOrGreen)
    {
        character.GetComponentsInChildren<Renderer>()
            .Select(r => r.materials)
            .ToList().ForEach(m =>
            {
                foreach (var material in m)
                {
                    material.SetFloat(OutlineFactor, 1.05f);
                    if (redOrGreen)
                    {
                        material.EnableKeyword("OUTLINE_RED");
                        material.DisableKeyword("OUTLINE_GREEN");
                    }
                    else
                    {
                        material.EnableKeyword("OUTLINE_GREEN");
                        material.DisableKeyword("OUTLINE_RED");
                    }
                }
            });
    }
}