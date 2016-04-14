//Flat Color Shader
//by the dude
//
//
Shader "dudeShaders/Flat Color Shader"		//declaring a 'Shader' and giving it a name (Flat Color Shader), and a subfolder (dudeShaders)
{

	//declaring all properties that can be altered in the Unity editor by the designer
	Properties
	{

		//creates the property called 'Color' that will allow you to use a color picker to set the value of the property _Color... starts with default value of white
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)

	}

	//declaring a subshader that the platform will try to call in order to render the material
	//these can be specific to a target platform like PS4, PC, or mobile
	//the game will try all the shaders till it can find the one that works on the platform it's being run on
	SubShader
	{

		//declaring a pass that will be run with specific instructions
		//a shader might have several passes in order to get the desired effect (i.e. a diffuse + specular + subsurface scattering)
		Pass
		{

			//flag to tell Unity that the following code will be written in CG (NVIDIA) instructions
			CGPROGRAM

			//---pragmas
			//tells Unity that our vertex shader function will be calle 'vert'
			#pragma vertex vert
			//assigns 'frag' as the name of our fragment shader function for Unity to call
			#pragma fragment frag

			//---user defined variables
			//the variable for color that the shaders will pass to eachother, manipulate and output back to Unity for rendering
			uniform float4 _Color;

			//---base input structs

			//data type for the vertices going into the vertex shader
			struct vertexInput
			{

				//assigning the Unity object 'semantic' POSITION to our variable 'vertex'
				float4 vertex : POSITION;

			};

			//data type for the processed vertices going into the fragment shader from the vertex shader
			struct vertexOutput
			{

				//need to take the vertex position and have Unity translate it into something that it understands in its own coordinate space
				//this is necessary because the object is processed by the GPU and then that data it generates needs to still be read by Unity
				float4 pos : SV_POSITION;

			};
			//---vertex function
			//call a function named 'vert' that takes the input data from 'vertexInput' (and assigns it to 'v')
			//all of this data is assigned/written to the data type 'vertexOutput'
			vertexOutput vert(vertexInput v)
			{

				//creating a variable, 'o', of data type 'vertexOutput' that we will store the information to
				vertexOutput o;

				//translates the position of the object by multiplying the vertex information from the GPU by the Unity Viewing Matrix in order for it to be able to understand the data
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				//return 'o' and assign its data to 'vertexOutput'
				return o;

			}

			//---fragment function
			//creates a new function called 'frag' with input data from 'vertexOutput'
			//assigns the output to 'i'
			float4 frag(vertexOutput i) : COLOR
			{

				//simply returns the value of the color
				return _Color;

			}

			//---flag to tell Unity to return to the Shader Lab language instructions
			ENDCG

		}

	}

	//fallback commented out during development
	//will run this default shader if no other shaders will work
	//Fallback "Diffuse"

}