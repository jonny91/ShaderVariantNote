# Shader Variants

## 变体的由来

渲染效果 = 正常渲染代码 + 附加效果代码 （死亡溶解、外发光。。）

那么就需要对每个效果都写一个shader文件:

死亡溶解.shader = <font color=yellow>正常渲染代码 </font>+ 死亡溶解效果

外发光.shader =  <font color=yellow>正常渲染代码 </font> + 外发光效果

由此看出  <font color=yellow>正常渲染代码 </font> 是重复代码。

由此衍生出一个想法，能否只写一个Shader来承接需要的效果，美术同学仅仅通过开关就能切换看效果。(`Uber Shader`)

## 解决方案

1. 静态分支

   ```glsl
   #if
   #else
   #elif
   #endif
   ```

   

2. 动态分支

   ```glsl
   if
   else
   ```

   

3. 着色器变体

   ```glsl
   #pragma
   ```

   

### 如果选择三种方案？

1. 静态分支

   编译时生效，编译的时候已经决定了走哪个分支。如果需要不同开启，那就要存成不同的shader文件。

   没有走的分支在编译的时候就会被剪裁掉

   ```glsl
   #define I_AM_RED
   float4 frag(v2f i): SV_TARGET
   {
       #if defined(I_AM_RED)
       	return float4(1,0,0,1);
       #else
           return float4(0,0,0,1);
       #endif
   }
   ```

   

2. 动态分支

   运行时决定走哪个分支的代码。

   <font color=red>性能问题</font>  => 和着色器变体相比 是一种时间换空间的方式。

   ```glsl
   bool I_AM_RED;
   float4 frag(v2f i): SV_TARGET
   {
       if(I_AM_RED)
       {
           return float4(1,0,0,1);
       }
       else
       {
           return float4(0,0,0,1);
       }
   }
   ```

   

3. 着色器变体

   编译时生成多个静态分支的shader，运行时来决定用哪个。

   会增加运行时候的内存使用，是一种空间换时间的解决方案。

   可以理解成是静态分支的++++版本。

   ```glsl
   //版本1.shader
   float4 frag(v2f i): SV_TARGET
   {
     	return float4(1,0,0,1);
   }
   
   //版本2.shader
   float4 frag(v2f i): SV_TARGET
   {
       return float4(0,0,0,1);
   }
   ```

变体的集合成为 **Shader Variants**



## 使用变体

```glsl
Shader "VariantsTest"
{
    Properties
    {
        [Toggle]Light("Light Toggle", int ) = 0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma multi_compile LIGHT_OFF LIGHT_ON

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD1;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            float4 frag(v2f i):SV_Target
            {
                #ifdef LIGHT_ON
                    return float4(255.0/255,176.0/255,69.0/255,1);
                #else
                    return float4(0, 0, 0, 1);
                #endif
            }
            ENDCG
        }
    }
}
```

![](./pic/1.png)

## shader变体的两种类型

| 类型             |                                                |
| ---------------- | ---------------------------------------------- |
| `multi_compile`  | 总是包含所有的shader变体组合，不管是不是启用了 |
| `shader_feature` | 材质设定中，不被启用的变体会被裁剪掉           |



### 变体的组合

```glsl
#pragma multi_compile A B
#pragma multi_compile C D  
```

最后生成的变体： AC AD BC BD

所以变体会造成代码几何倍数的增加。