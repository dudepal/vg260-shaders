Shader "dudeShaders/Ambient Shader"
{

	Properties
	{

		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)

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

		float3 normalDirection = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);		//getting normal directions in object space and normalizing them into unit vectors
		float3 lightDirection;
		float atten = 1.0;		//used later for light falloff/attenuation

		lightDirection = normalize(_WorldSpaceLightPos0.xyz);		//calculating the light direction vectors on the model

		float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));		//calulate the diffuse lighting based on the projection of the surface normal vector onto the light direction vector... +1 = fully lit & -1 = unlit... max gets rid of the values less than zero... LightColor is used to tint the object based on the light color... and the color of the of the object is mixed with the light color to give the final tint
		float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;		//adds the diffuse plus the Unity built in ambient light model to get the final lighting for the object

		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.col = float4(lightFinal * _Color.rgb, 1.0);		//set the surface color component equal to the diffuse reflection we calculated above

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