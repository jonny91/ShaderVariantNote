using System.Collections.Generic;
using UnityEditor.Build;
using UnityEditor.Rendering;
using UnityEngine;

namespace Editor
{
    public class ProcessShader : IPreprocessShaders
    {
        public void OnProcessShader(Shader shader, ShaderSnippetData snippet, IList<ShaderCompilerData> data)
        {
            Debug.Log(shader.name + " 变体数量: " + data.Count);
        }

        public int callbackOrder { get; }
    }
}