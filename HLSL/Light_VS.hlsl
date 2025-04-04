#include "Light.hlsli"

VertexOut VS(VertexIn vIn)
{
    VertexOut vOut;
    matrix viewProj = mul(g_View, g_Proj);
    float4 posW = mul(float4(vIn.posL, 1.0f), g_World);

    vOut.posH = mul(posW, viewProj);
    vOut.posW = posW.xyz;
    vOut.normalW = mul(vIn.normalL, (float3x3) g_WorldInvTranspose);
    vOut.tex = mul(float4(vIn.tex, 0.0f, 1.0f), g_TexRotation).xy; // 应用纹理旋转矩阵
    vOut.color = vIn.color;
    return vOut;
}
