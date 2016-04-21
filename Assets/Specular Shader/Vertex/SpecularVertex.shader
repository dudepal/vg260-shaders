Shader "dudeShaders/Specular Shader/Vertex Based"
{

	Properties
	{

		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Float) = 10

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
			float4 col : COLOR;			//writing to the vertex color data

		};

		//VERTEX FUNCTION
		vertexOutput vert(vertexInput v)
		{
			vertexOutput o;

			//vectors
			float3 normalDirection = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
			float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - mul(_Object2World, v.vertex).xyz));		//finds view direction by subtracting the world space camera position by the vertex position

			//lighting
			float atten = 1.0;
			float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
			float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
			float3 specularReflection = atten * _SpecColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
			//1. reflects the light vector across the normal of the surface
			//2. 
			//calculate the final lighting by adding all the reflections and ambient together
			float3 lightFinal = diffuseReflection + specularReflection; //+ UNITY_LIGHTMODEL_AMBIENT;

			o.col = float4(lightFinal * _Color.rgb, 1.0);
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			return o;
		}

		//FRAGMENT FUNCTION
		float4 frag(vertexOutput i) : COLOR
		{
			return i.col;
		}

		ENDCG

	}

	}

		//Fallback "Diffuse

}