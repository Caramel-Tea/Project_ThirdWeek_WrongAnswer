#include "Light.hlsli"

Texture2D g_Texture;
SamplerState g_Sampler;

float4 PS(VertexOut pIn) : SV_Target
{
    // 标准化法向量
    pIn.normalW = normalize(pIn.normalW);

    // 顶点指向眼睛的向量
    float3 toEyeW = normalize(g_EyePosW.xyz - pIn.posW);

    // 初始化为0 
    float4 ambient, diffuse, spec;
    float4 A, D, S;
    ambient = diffuse = spec = A = D = S = float4(0.0f, 0.0f, 0.0f, 0.0f);

    ComputeDirectionalLight(g_Material, g_DirLight, pIn.normalW, toEyeW, A, D, S);
    ambient += A;
    diffuse += D;
    spec += S;

    ComputePointLight(g_Material, g_PointLight, pIn.posW, pIn.normalW, toEyeW, A, D, S);
    ambient += A;
    diffuse += D;
    spec += S;

    ComputeSpotLight(g_Material, g_SpotLight, pIn.posW, pIn.normalW, toEyeW, A, D, S);
    ambient += A;
    diffuse += D;
    spec += S;

    // 使用纹理采样器
    float4 texColor = g_Texture.Sample(g_Sampler, pIn.tex);

    float4 litColor = texColor * (ambient + diffuse) + spec;
    
    litColor.a = g_Material.diffuse.a * pIn.color.a;
    
    return litColor;
}
