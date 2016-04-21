Shader "dudeShaders/Specular Shader/Fragment Based"
{

	Properties
	{

		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", Float) = 10

	}

		SubShader
	{

		Pass
	{

		//TAGS
		Tags{ "LightMode" = "ForwardBase" }		//tells Unity which light model we will use... helps correct for the inverted lighting you see

		CGPROGRAM

		//PRAGMAS
#pragma vertex vert
#pragma fragment frag

		//USER DEFINED VARIABLES
		uniform float4 _Color;
	uniform float4 _SpecColor;
	uniform float _Shininess;

	//UNITY DEFINED VARIABLES
	uniform float4 _LightColor0;		//unity will pass us the color of the light so we can use it in the shaders

										//BASE INPUT STRUCTS
	struct vertexInput
	{

		float4 vertex : POSITION;
		float3 normal : NORMAL;		//storing the normals for use with lighting

	};

	struct vertexOutput
	{
		float4 pos : SV_POSITION;
		float4 posWorld : TEXCOORD0;	//overwriting texture coordinates with data from world position and normal direction
		float3 normalDir : TEXCOORD1;
	};

	//VERTEX FUNCTION
	vertexOutput vert(vertexInput v)
	{
		vertexOutput o;

		o.posWorld = mul(_Object2World, v.vertex);
		o.normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		return o;
	}

	//FRAGMENT FUNCTION
	float4 frag(vertexOutput i) : COLOR
	{
		//vectors
		float3 normalDirection = i.normalDir;
		float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

		//lighting
		float atten = 1.0;
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
		float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
		float3 specularReflection = atten * _SpecColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
		float3 lightFinal = diffuseReflection + specularReflection; //+ UNITY_LIGHTMODEL_AMBIENT;

		return float4(lightFinal * _Color.rgb, 1.0);

	}

		ENDCG

	}

	}

		//Fallback "Diffuse

}