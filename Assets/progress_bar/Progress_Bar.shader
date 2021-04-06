// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifiShader/progress_bar"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_progressing_control("progressing_control", Range( 0 , 1)) = 0.8828041
		_WaterLevel("WaterLevel", 2D) = "white" {}
		_WaterColor("WaterColor", 2D) = "white" {}
		_Wave("Wave", 2D) = "white" {}
		_Bubble("Bubble", 2D) = "white" {}
		_TextureInside("TextureInside", 2D) = "white" {}
		_Hit("Hit", Float) = 0
		_Shield("Shield", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord2 : TEXCOORD2;
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float _Shield;
			uniform sampler2D _Wave;
			uniform sampler2D _Texture0;
			float4 _Texture0_TexelSize;
			uniform float _Hit;
			uniform float _progressing_control;
			uniform sampler2D _Bubble;
			uniform sampler2D _WaterColor;
			uniform float4 _WaterColor_ST;
			uniform sampler2D _WaterLevel;
			uniform sampler2D _TextureInside;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				OUT.ase_texcoord2 = IN.vertex;
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float4 color364 = IsGammaSpace() ? float4(1,0.9319459,0.4764151,0) : float4(1,0.852115,0.192857,0);
				float2 appendResult354 = (float2(0.0 , -0.51));
				float2 texCoord353 = IN.texcoord.xy * float2( 1,1 ) + appendResult354;
				float2 panner352 = ( 1.0 * _Time.y * float2( 0.24,0 ) + texCoord353);
				float2 texCoord132 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_131_0 = texCoord132.y;
				float4 lerpResult362 = lerp( float4( 0,0,0,0 ) , ( color364 * tex2D( _Wave, panner352 ) ) , temp_output_131_0);
				float temp_output_433_0 = sin( ( _Time.y * 10.78 ) );
				float clampResult472 = clamp( temp_output_433_0 , 0.0 , 0.25 );
				float4 transform478 = mul(unity_ObjectToWorld,float4( IN.ase_texcoord2.xyz , 0.0 ));
				float2 texCoord460 = IN.texcoord.xy * float2( 1,1 ) + ( (( _ScreenParams * transform478 * _Texture0_TexelSize )).xyzw + float4( ( float2( 0,0.2 ) * _Time.y ), 0.0 , 0.0 ) ).xy;
				float blendOpSrc470 = clampResult472;
				float blendOpDest470 = tex2D( _Texture0, texCoord460 ).r;
				float lerpBlendMode470 = lerp(blendOpDest470,(( blendOpSrc470 > 0.5 )? ( blendOpDest470 + 2.0 * blendOpSrc470 - 1.0 ) : ( blendOpDest470 + 2.0 * ( blendOpSrc470 - 0.5 ) ) ),0.3);
				float4 color455 = IsGammaSpace() ? float4(0,0.7722802,1,1) : float4(0,0.5579053,1,1);
				float4 color452 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float clampResult447 = clamp( (-2.43 + (texCoord132.x - 0.0) * (1.0 - -2.43) / (1.0 - 0.0)) , 0.0 , 1.0 );
				float4 temp_cast_3 = (( 0.25 * clampResult447 )).xxxx;
				float2 _Vector4 = float2(0.04,0.24);
				float2 texCoord279 = IN.texcoord.xy * float2( 20.64,60 ) + ( float2( 0,-1 ) * _Time.y );
				float simplePerlin2D275 = snoise( texCoord279 );
				float smoothstepResult281 = smoothstep( 0.55 , 3.74 , simplePerlin2D275);
				float2 texCoord273 = IN.texcoord.xy * ( float2( 5,5 ) * (1.0 + (_SinTime.w - 0.0) * (3.0 - 1.0) / (10.0 - 0.0)) ) + ( float2( 0.5,0 ) * _Time.y );
				float simplePerlin2D270 = snoise( texCoord273 );
				float temp_output_180_0 = ( 1.2 * ( ( sin( ( 1.0 * 6.28318548202515 ) ) * 0.5 ) + _Time.y ) );
				float2 temp_cast_4 = (temp_output_180_0).xx;
				float2 texCoord204 = IN.texcoord.xy * float2( 4.54,10.08 ) + temp_cast_4;
				float simplePerlin2D190 = snoise( texCoord204 );
				float smoothstepResult197 = smoothstep( 0.0 , ( 0.35 / -0.5 ) , simplePerlin2D190);
				float lerpResult319 = lerp( simplePerlin2D270 , 0.0 , smoothstepResult197);
				float lerpResult289 = lerp( smoothstepResult281 , 0.0 , lerpResult319);
				float smoothstepResult309 = smoothstep( _Vector4.x , _Vector4.y , lerpResult289);
				float2 texCoord327 = IN.texcoord.xy * float2( 400,400 ) + ( float2( -0.31,-0.4 ) * _Time.y );
				float simplePerlin2D326 = snoise( texCoord327 );
				float smoothstepResult334 = smoothstep( 0.39 , 3.74 , simplePerlin2D326);
				float lerpResult333 = lerp( smoothstepResult334 , 0.0 , simplePerlin2D270);
				float2 appendResult403 = (float2(0.0 , -0.15));
				float2 panner143 = ( 1.0 * _Time.y * appendResult403 + ( temp_output_131_0 * texCoord132 ));
				float temp_output_137_0 = (-0.14 + (sin( ( 3.12 * temp_output_131_0 ) ) - -1.46) * (0.68 - -0.14) / (6.48 - -1.46));
				float4 lerpResult148 = lerp( float4( 0,0,0,0 ) , tex2D( _Bubble, panner143 ) , pow( temp_output_137_0 , 0.57 ));
				float2 uv_WaterColor = IN.texcoord.xy * _WaterColor_ST.xy + _WaterColor_ST.zw;
				float4 tex2DNode60 = tex2D( _WaterColor, uv_WaterColor );
				float2 texCoord191 = IN.texcoord.xy * float2( 150,150 ) + ( float2( 0,-2 ) * _Time.y );
				float simplePerlin2D196 = snoise( texCoord191 );
				float smoothstepResult199 = smoothstep( -0.62 , 0.57 , simplePerlin2D196);
				float smoothstepResult194 = smoothstep( ( 0.35 * _SinTime.w * 6.28318548202515 ) , 1.0 , simplePerlin2D190);
				float4 lerpResult209 = lerp( ( tex2DNode60 + ( smoothstepResult199 + ( smoothstepResult194 - smoothstepResult197 ) ) ) , tex2DNode60 , 1.05);
				float2 appendResult380 = (float2(( 0.07 * _Time.y ) , 0.0));
				float2 appendResult13 = (float2(appendResult380.x , ( ( _progressing_control * ( -0.5 - 0.5 ) ) + 0.5 )));
				float2 texCoord6 = IN.texcoord.xy * float2( 1,1 ) + appendResult13;
				float2 panner82 = ( 1.0 * _Time.y * float2( 0.2,0 ) + texCoord6);
				float4 tex2DNode72 = tex2D( _Wave, panner82 );
				float4 temp_cast_6 = (tex2DNode72.a).xxxx;
				float4 temp_cast_7 = (tex2DNode72.a).xxxx;
				float2 panner5 = ( temp_output_180_0 * float2( 0.1,0 ) + texCoord6);
				float4 tex2DNode3 = tex2D( _WaterLevel, panner5 );
				float4 blendOpSrc57 = temp_cast_7;
				float4 blendOpDest57 = tex2DNode3;
				float4 blendOpSrc86 = temp_cast_6;
				float4 blendOpDest86 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc57 ) * ( 1.0 - blendOpDest57 ) ) ));
				float4 lerpBlendMode86 = lerp(blendOpDest86,( 1.0 - ( 1.0 - blendOpSrc86 ) * ( 1.0 - blendOpDest86 ) ),0.23);
				float4 blendOpSrc61 = lerpResult209;
				float4 blendOpDest61 = ( saturate( lerpBlendMode86 ));
				float4 temp_output_61_0 = ( saturate( (( blendOpDest61 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest61 ) * ( 1.0 - blendOpSrc61 ) ) : ( 2.0 * blendOpDest61 * blendOpSrc61 ) ) ));
				float4 blendOpSrc121 = lerpResult148;
				float4 blendOpDest121 = temp_output_61_0;
				float4 lerpBlendMode121 = lerp(blendOpDest121,( 1.0 - ( 1.0 - blendOpSrc121 ) * ( 1.0 - blendOpDest121 ) ),tex2DNode3.a);
				float4 temp_output_121_0 = ( saturate( lerpBlendMode121 ));
				float4 blendOpSrc359 = lerpResult362;
				float4 blendOpDest359 = temp_output_121_0;
				float4 color314 = IsGammaSpace() ? float4(1,0.6249812,0,0) : float4(1,0.3484872,0,0);
				float4 blendOpSrc316 = ( ( pow( smoothstepResult309 , 0.03 ) + pow( lerpResult333 , 0.47 ) ) + ( saturate( ( 1.0 - ( 1.0 - blendOpSrc359 ) * ( 1.0 - blendOpDest359 ) ) )) );
				float4 blendOpDest316 = color314;
				float4 lerpBlendMode316 = lerp(blendOpDest316,max( blendOpSrc316, blendOpDest316 ),tex2DNode3.a);
				float4 temp_output_316_0 = ( saturate( lerpBlendMode316 ));
				float2 texCoord101 = IN.texcoord.xy * float2( 1,1 ) + appendResult13;
				float2 panner150 = ( _Time.y * float2( -0.08,-0.08 ) + texCoord101);
				float4 lerpResult151 = lerp( float4( texCoord101, 0.0 , 0.0 ) , tex2D( _TextureInside, panner150 ) , 0.05);
				float lerpResult170 = lerp( 0.0 , tex2D( _Wave, lerpResult151.rg ).a , temp_output_137_0);
				float4 color440 = IsGammaSpace() ? float4(1,0.6313252,0.2688679,0) : float4(1,0.3563412,0.05875937,0);
				float4 clampResult449 = clamp( ( color440 * temp_output_433_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 color427 = IsGammaSpace() ? float4(0.2735849,0,0,0) : float4(0.06083427,0,0,0);
				float4 blendOpSrc438 = clampResult449;
				float4 blendOpDest438 = color427;
				float4 lerpBlendMode438 = lerp(blendOpDest438,max( blendOpSrc438, blendOpDest438 ),0.5);
				float4 blendOpSrc428 = color427;
				float4 blendOpDest428 = temp_output_61_0;
				float4 lerpBlendMode428 = lerp(blendOpDest428,(( blendOpDest428 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest428 ) * ( 1.0 - blendOpSrc428 ) ) : ( 2.0 * blendOpDest428 * blendOpSrc428 ) ),tex2DNode3.a);
				float4 blendOpSrc436 = ( saturate( lerpBlendMode438 ));
				float4 blendOpDest436 = ( saturate( lerpBlendMode428 ));
				float4 lerpBlendMode436 = lerp(blendOpDest436,max( blendOpSrc436, blendOpDest436 ),tex2DNode3.a);
				float4 blendOpSrc443 = temp_cast_3;
				float4 blendOpDest443 =  ( _progressing_control - float4( 0,0,0,0 ) > 0.6 ? temp_output_316_0 : _progressing_control - float4( 0,0,0,0 ) <= 0.6 && _progressing_control + float4( 0,0,0,0 ) >= 0.6 ? temp_output_316_0 : (( _progressing_control >= 0.3 && _progressing_control <= 0.6 ) ? ( lerpResult170 + temp_output_121_0 ) :  ( saturate( lerpBlendMode436 )) ) ) ;
				float4 lerpBlendMode443 = lerp(blendOpDest443,max( blendOpSrc443, blendOpDest443 ),tex2DNode3.a);
				
				half4 color = ( _Shield == 1.0 ? ( lerpResult362 + ( ( saturate( lerpBlendMode470 )) + color455 ) ) : ( ( _Hit == 1.0 ? color452 : float4( 0,0,0,0 ) ) + ( saturate( lerpBlendMode443 )) ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
2253;547;1920;1019;-1495.225;504.5698;1;True;False
Node;AmplifyShaderEditor.TauNode;171;-2308.328,1442.82;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-2273.094,1279.326;Float;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-1970.156,1479.994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;176;-1686.156,1476.994;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1955.961,1161.589;Float;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3259.317,1178.505;Float;False;Constant;_Float45;Float 45;6;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-3101.67,1618.73;Float;False;Constant;_Float44;Float 44;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-1320.755,1449.311;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;175;-2243.981,1697.734;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;397;-3033.698,230.5049;Float;False;Constant;_Float28;Float 28;6;0;Create;True;0;0;0;False;0;False;0.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-1022.666,1619.768;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-849.3586,1297.02;Float;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-2885.026,1228.403;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2421.455,135.7653;Float;False;Property;_progressing_control;progressing_control;0;0;Create;True;0;0;0;False;0;False;0.8828041;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;396;-3015.788,438.6035;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;381;-2749.915,687.2469;Float;False;Constant;_Float33;Float 33;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;398;-2693.462,446.778;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2613.533,936.1014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;206;-1712.676,-2176.011;Float;False;Constant;_Vector3;Vector 3;6;0;Create;True;0;0;0;False;0;False;4.54,10.08;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;183;-1016.785,-2855.826;Float;False;Constant;_Vector10;Vector 10;4;0;Create;True;0;0;0;False;0;False;0,-2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-1254.182,1050.486;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;182;-1024.785,-2706.826;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-755.785,-2833.826;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TauNode;211;-749.5498,-1965.732;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-2368.556,1100.445;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;296;-1006.646,-4974.386;Float;False;Constant;_Float25;Float 25;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;295;-1014.646,-5057.485;Float;False;Constant;_Float24;Float 24;7;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;292;-1007.835,-5311.948;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;294;-1021.746,-5145.986;Float;False;Constant;_Float21;Float 21;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;204;-1599.678,-2408.744;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-735.4736,-1847.6;Float;False;Constant;_Float19;Float 19;4;0;Create;True;0;0;0;False;0;False;0.35;0;0.28;0.35;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-1015.946,-4880.889;Float;False;Constant;_Float26;Float 26;7;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;184;-1011.68,-2451.035;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;380;-2387.354,585.9882;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-394.7786,-1953.177;Float;False;Constant;_Float31;Float 31;4;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;185;-922.8199,-2999.24;Float;False;Constant;_Vector9;Vector 9;4;0;Create;True;0;0;0;False;0;False;150,150;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;288;-982.2042,-4208.323;Float;False;Constant;_Vector13;Vector 13;7;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;13;-2130.76,918.9042;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;286;-998.2041,-4000.324;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;284;-1015.18,-4449.525;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;293;-738.3467,-5092.688;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;282;-1005.18,-4659.526;Float;False;Constant;_Vector12;Vector 12;7;0;Create;True;0;0;0;False;0;False;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;272;-726.1985,-4840.329;Float;False;Constant;_Vector7;Vector 7;7;0;Create;True;0;0;0;False;0;False;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;190;-881.5768,-2645.57;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-698.6798,-2395.035;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;189;-219.3303,-1900.305;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;191;-767.765,-3132.333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;132;-2400.047,-1538.368;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;193;30.50021,-2691.069;Float;False;Constant;_Float23;Float 23;7;0;Create;True;0;0;0;False;0;False;0.57;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;131;-1800.551,-1528.241;Inherit;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;195;46.50021,-2781.069;Float;False;Constant;_Float22;Float 22;7;0;Create;True;0;0;0;False;0;False;-0.62;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-790.2043,-4144.323;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;329;-1049.24,-3717.243;Float;False;Constant;_Vector6;Vector 6;7;0;Create;True;0;0;0;False;0;False;-0.31,-0.4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;-803.1804,-4581.526;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;276;-998.2041,-4336.324;Float;False;Constant;_Vector11;Vector 11;7;0;Create;True;0;0;0;False;0;False;20.64,60;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;134;-1646.797,-1844.576;Float;False;Constant;_Float6;Float 6;5;0;Create;True;0;0;0;False;0;False;3.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;194;-457.0436,-2697.537;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;511.5511,-2885.395;Float;False;Constant;_Float27;Float 27;6;0;Create;True;0;0;0;False;0;False;-0.51;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;331;-1012.035,-3347.92;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;83;-1644.665,72.99557;Float;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;0.2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-462.2004,-4897.706;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;12;-1769.268,832.2424;Float;False;Constant;_Vector5;Vector 5;9;0;Create;True;0;0;0;False;0;False;0.1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;197;-425.7139,-3109.36;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;196;37.52819,-3179.972;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1833.557,434.2043;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;279;-530.2043,-4411.324;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;82;-1168.479,169.3225;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1390.297,-1598.676;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;354;745.3273,-2804.624;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;198;139.5035,-2402.218;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-969.0662,373.6239;Float;True;Property;_WaterLevel;WaterLevel;1;0;Create;True;0;0;0;False;0;False;efc27c14ce034c646a14edcee1190a04;efc27c14ce034c646a14edcee1190a04;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;5;-1109.818,672.2102;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;104;-801.8413,-451.6303;Float;True;Property;_Wave;Wave;3;0;Create;True;0;0;0;False;0;False;a38392873d7aedd47be4267bc5ec4e17;a38392873d7aedd47be4267bc5ec4e17;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;-794.2397,-3668.243;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;330;-1002.24,-3860.243;Float;False;Constant;_Vector8;Vector 8;7;0;Create;True;0;0;0;False;0;False;400,400;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;199;346.1917,-2838.507;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;273;-540.6741,-4652.385;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;405;-1296.533,-617.962;Float;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;-0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;404;-1327.496,-770.9728;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1042.37,-1239.233;Float;False;Constant;_Float10;Float 10;5;0;Create;True;0;0;0;False;0;False;0.68;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;270;-252.2717,-4657.211;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;353;804.1609,-2943.965;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;2032.825,-751.0199;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;a38392873d7aedd47be4267bc5ec4e17;a38392873d7aedd47be4267bc5ec4e17;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;278;-248.7114,-4173.376;Float;False;Constant;_Float20;Float 20;7;0;Create;True;0;0;0;False;0;False;0.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-1409.922,-1247.374;Float;False;Constant;_Float8;Float 8;5;0;Create;True;0;0;0;False;0;False;6.48;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-2172.129,-607.5939;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;418;-940.5735,-885.6444;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;430;2504.234,-818.5817;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;432;2522.638,-628.0218;Inherit;False;Constant;_Float32;Float 32;7;0;Create;True;0;0;0;False;0;False;10.78;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-245.5151,-4058.063;Float;False;Constant;_Float18;Float 18;7;0;Create;True;0;0;0;False;0;False;3.74;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;-277.075,-169.7097;Inherit;True;Property;_WaterColor;WaterColor;2;0;Create;True;0;0;0;False;0;False;-1;26c3b3959c61cc5438ba199150a2e4d5;26c3b3959c61cc5438ba199150a2e4d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;327;-538.2397,-3828.243;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;275;-254.2042,-4420.324;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;159;-2263.538,-104.857;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;161;-1012.464,-1594.305;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1037.481,-1328.026;Float;False;Constant;_Float7;Float 7;5;0;Create;True;0;0;0;False;0;False;-1.46;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-1313.359,-1133.96;Float;False;Constant;_Float9;Float 9;5;0;Create;True;0;0;0;False;0;False;-0.14;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;355;754.9029,-2611.529;Float;False;Constant;_Vector14;Vector 14;6;0;Create;True;0;0;0;False;0;False;0.24,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;200;485.9819,-2352.382;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;1646.431,-2522.398;Inherit;True;Property;_TextureSample11;Texture Sample 11;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;403;-944.5982,-612.8218;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;153;-2370.689,-259.514;Float;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;-0.08,-0.08;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PosVertexDataNode;473;3139.961,-4320.733;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;431;2811.84,-729.1205;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;150;-1843.114,-233.7347;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenParams;474;3166.396,-4062.045;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;210;596.8842,-1559.506;Float;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;0;False;0;False;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;326;-266.2397,-3940.243;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;336;-253.9544,-3407.744;Float;False;Constant;_Float16;Float 16;7;0;Create;True;0;0;0;False;0;False;3.74;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;319;252.2039,-4809.597;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;482;2852.217,-3600.175;Inherit;True;Property;_Texture0;Texture 0;8;0;Create;True;0;0;0;False;0;False;None;f3989d7d8be5c8647a2f51a4cae6d14b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;352;482.6981,-3181.774;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;281;263.8388,-4590.644;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;137;-558.4486,-1447.198;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-478.2486,-1133.438;Float;False;Constant;_Float13;Float 13;6;0;Create;True;0;0;0;False;0;False;0.57;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;203;916.0988,-2083.017;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-247.3549,-3699.381;Float;False;Constant;_Float15;Float 15;7;0;Create;True;0;0;0;False;0;False;0.39;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;143;-348.1545,-795.5202;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;57;2391.687,-303.1335;Inherit;True;Screen;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1.08;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;109;188.5258,-814.2158;Inherit;True;Property;_Bubble;Bubble;4;0;Create;True;0;0;0;False;0;False;-1;14e6c9ef2ad9e1246ad85e1b31454784;14e6c9ef2ad9e1246ad85e1b31454784;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;334;130.2433,-3962.725;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;478;3755.838,-4144.807;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;475;3610.468,-3906.314;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;160;-2630.836,-2756.517;Inherit;True;Property;_TextureInside;TextureInside;5;0;Create;True;0;0;0;False;0;False;-1;36e7b7df94b46ed4da20af04da6e948c;36e7b7df94b46ed4da20af04da6e948c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;289;583.5192,-4632.924;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;364;884.427,-3379.201;Float;False;Constant;_Color1;Color 1;6;0;Create;True;0;0;0;False;0;False;1,0.9319459,0.4764151,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;440;2856.663,-1016.865;Inherit;False;Constant;_Color3;Color 3;7;0;Create;True;0;0;0;False;0;False;1,0.6313252,0.2688679,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;157;-1492.062,4.368059;Float;False;Constant;_Float11;Float 11;6;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;162;-176.9331,-1206.417;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;433;3908.881,-3062.477;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;320;609.5998,-4197.33;Float;False;Constant;_Vector4;Vector 4;6;0;Create;True;0;0;0;False;0;False;0.04,0.24;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendOpsNode;86;871.7543,220.1083;Inherit;True;Screen;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.23;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;341;1026.703,-2432.667;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;a38392873d7aedd47be4267bc5ec4e17;a38392873d7aedd47be4267bc5ec4e17;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;209;1239.407,-1729.792;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexelSizeNode;476;3300.975,-3736.397;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;439;3270.649,-1061.133;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;333;496.23,-3956.376;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;461;3173.743,-3393.982;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;0,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;363;1240.05,-3295.074;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;3707.968,-3845.935;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;464;3193.205,-3242.885;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;148;1438.225,-1056.05;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;151;-1144.098,-233.2849;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;309;860.8157,-4626.27;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;529.6818,-3439.989;Float;False;Constant;_Float17;Float 17;6;0;Create;True;0;0;0;False;0;False;0.47;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;61;1806.818,-1577.036;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;323;885.4332,-4073.552;Float;False;Constant;_Float14;Float 14;6;0;Create;True;0;0;0;False;0;False;0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;449;3542.434,-1088.566;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;479;3713.633,-3586.164;Inherit;True;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;427;2264.318,-1418.982;Inherit;False;Constant;_Color2;Color 2;7;0;Create;True;0;0;0;False;0;False;0.2735849,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;321;1180.13,-4609.937;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;362;1421.651,-3117.056;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;121;2497.164,-1751.923;Inherit;True;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;94;-115.2542,-445.8455;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;a38392873d7aedd47be4267bc5ec4e17;a38392873d7aedd47be4267bc5ec4e17;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;337;855.5422,-3874.166;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;465;3502.205,-3188.885;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;480;3789.144,-3227.798;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;170;390.2273,-546.0063;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;441;2950.092,-1731.622;Inherit;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;428;2804.845,-1574.595;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;438;3043.507,-1325.03;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;332;1304.731,-4081.835;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;359;1838.949,-3268.752;Inherit;True;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;426;3007.208,-2653.588;Inherit;False;Constant;_Float30;Float 30;7;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;314;1699.951,-2955.428;Float;False;Constant;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;1,0.6249812,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;165;2733.732,-2346.572;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;436;3351.943,-1505.488;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.85;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;307;2115.578,-3485.977;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;445;3298.043,-1761.736;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-2.43;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;460;3958.547,-3348.742;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;425;2993.208,-2743.588;Inherit;False;Constant;_Float29;Float 29;7;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;447;3658.417,-1581.549;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;3119.856,-2237.53;Float;False;Constant;_Float12;Float 12;6;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;472;4124.48,-3213.931;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;458;4163.595,-3546.091;Inherit;True;Property;_Full_energy;Full_energy;8;0;Create;True;0;0;0;False;0;False;-1;None;f3989d7d8be5c8647a2f51a4cae6d14b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;316;2376.404,-3115.624;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;424;3392.285,-2544.279;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;454;4080.95,-2651.965;Inherit;False;Property;_Hit;Hit;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;470;4417.791,-3308.735;Inherit;True;LinearLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;455;4125.375,-3000.248;Float;False;Constant;_Color5;Color 5;6;0;Create;True;0;0;0;False;0;False;0,0.7722802,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;444;3807.029,-1760.204;Inherit;True;2;2;0;FLOAT;0.25;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;216;3469.302,-2994.061;Inherit;True;6;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;452;4086.095,-2548.128;Inherit;False;Constant;_Color4;Color 4;7;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;443;4112.819,-2115.331;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.3;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;453;4462.852,-2628.276;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;459;4622.496,-3120.122;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;450;4694.561,-2438.344;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;483;4921.545,-3200.695;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;457;4054.708,-2761.397;Inherit;False;Property;_Shield;Shield;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;456;4996.744,-2770.622;Inherit;True;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;468;3506.329,-3402.178;Inherit;False;Constant;_Vector15;Vector 15;9;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;55;5582.074,-2477.413;Float;False;True;-1;2;ASEMaterialInspector;0;6;AmplifiShader/progress_bar;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;2;False;-1;True;True;True;True;True;0;True;-9;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;174;0;172;0
WireConnection;174;1;171;0
WireConnection;176;0;174;0
WireConnection;177;0;176;0
WireConnection;177;1;178;0
WireConnection;179;0;177;0
WireConnection;179;1;175;2
WireConnection;17;0;19;0
WireConnection;17;1;18;0
WireConnection;398;0;397;0
WireConnection;398;1;396;2
WireConnection;16;0;23;0
WireConnection;16;1;17;0
WireConnection;180;0;181;0
WireConnection;180;1;179;0
WireConnection;187;0;183;0
WireConnection;187;1;182;0
WireConnection;15;0;16;0
WireConnection;15;1;18;0
WireConnection;204;0;206;0
WireConnection;204;1;180;0
WireConnection;380;0;398;0
WireConnection;380;1;381;0
WireConnection;13;0;380;0
WireConnection;13;1;15;0
WireConnection;293;0;292;4
WireConnection;293;1;294;0
WireConnection;293;2;295;0
WireConnection;293;3;296;0
WireConnection;293;4;297;0
WireConnection;190;0;204;0
WireConnection;192;0;186;0
WireConnection;192;1;184;4
WireConnection;192;2;211;0
WireConnection;189;0;186;0
WireConnection;189;1;188;0
WireConnection;191;0;185;0
WireConnection;191;1;187;0
WireConnection;131;0;132;2
WireConnection;287;0;288;0
WireConnection;287;1;286;0
WireConnection;285;0;282;0
WireConnection;285;1;284;0
WireConnection;194;0;190;0
WireConnection;194;1;192;0
WireConnection;291;0;272;0
WireConnection;291;1;293;0
WireConnection;197;0;190;0
WireConnection;197;2;189;0
WireConnection;196;0;191;0
WireConnection;6;1;13;0
WireConnection;279;0;276;0
WireConnection;279;1;287;0
WireConnection;82;0;6;0
WireConnection;82;2;83;0
WireConnection;133;0;134;0
WireConnection;133;1;131;0
WireConnection;354;1;357;0
WireConnection;198;0;194;0
WireConnection;198;1;197;0
WireConnection;5;0;6;0
WireConnection;5;2;12;0
WireConnection;5;1;180;0
WireConnection;328;0;329;0
WireConnection;328;1;331;0
WireConnection;199;0;196;0
WireConnection;199;1;195;0
WireConnection;199;2;193;0
WireConnection;273;0;291;0
WireConnection;273;1;285;0
WireConnection;270;0;273;0
WireConnection;353;1;354;0
WireConnection;72;0;104;0
WireConnection;72;1;82;0
WireConnection;101;1;13;0
WireConnection;418;0;131;0
WireConnection;418;1;132;0
WireConnection;327;0;330;0
WireConnection;327;1;328;0
WireConnection;275;0;279;0
WireConnection;161;0;133;0
WireConnection;200;0;199;0
WireConnection;200;1;198;0
WireConnection;3;0;4;0
WireConnection;3;1;5;0
WireConnection;403;0;404;0
WireConnection;403;1;405;0
WireConnection;431;0;430;0
WireConnection;431;1;432;0
WireConnection;150;0;101;0
WireConnection;150;2;153;0
WireConnection;150;1;159;0
WireConnection;326;0;327;0
WireConnection;319;0;270;0
WireConnection;319;2;197;0
WireConnection;352;0;353;0
WireConnection;352;2;355;0
WireConnection;281;0;275;0
WireConnection;281;1;278;0
WireConnection;281;2;277;0
WireConnection;137;0;161;0
WireConnection;137;1;138;0
WireConnection;137;2;139;0
WireConnection;137;3;140;0
WireConnection;137;4;141;0
WireConnection;203;0;60;0
WireConnection;203;1;200;0
WireConnection;143;0;418;0
WireConnection;143;2;403;0
WireConnection;57;0;72;4
WireConnection;57;1;3;0
WireConnection;109;1;143;0
WireConnection;334;0;326;0
WireConnection;334;1;335;0
WireConnection;334;2;336;0
WireConnection;478;0;473;0
WireConnection;475;0;474;0
WireConnection;160;1;150;0
WireConnection;289;0;281;0
WireConnection;289;2;319;0
WireConnection;162;0;137;0
WireConnection;162;1;163;0
WireConnection;433;0;431;0
WireConnection;86;0;72;4
WireConnection;86;1;57;0
WireConnection;341;0;104;0
WireConnection;341;1;352;0
WireConnection;209;0;203;0
WireConnection;209;1;60;0
WireConnection;209;2;210;0
WireConnection;476;0;482;0
WireConnection;439;0;440;0
WireConnection;439;1;433;0
WireConnection;333;0;334;0
WireConnection;333;2;270;0
WireConnection;363;0;364;0
WireConnection;363;1;341;0
WireConnection;477;0;475;0
WireConnection;477;1;478;0
WireConnection;477;2;476;0
WireConnection;148;1;109;0
WireConnection;148;2;162;0
WireConnection;151;0;101;0
WireConnection;151;1;160;0
WireConnection;151;2;157;0
WireConnection;309;0;289;0
WireConnection;309;1;320;1
WireConnection;309;2;320;2
WireConnection;61;0;209;0
WireConnection;61;1;86;0
WireConnection;449;0;439;0
WireConnection;479;0;477;0
WireConnection;321;0;309;0
WireConnection;321;1;323;0
WireConnection;362;1;363;0
WireConnection;362;2;131;0
WireConnection;121;0;148;0
WireConnection;121;1;61;0
WireConnection;121;2;3;4
WireConnection;94;0;104;0
WireConnection;94;1;151;0
WireConnection;337;0;333;0
WireConnection;337;1;338;0
WireConnection;465;0;461;0
WireConnection;465;1;464;0
WireConnection;480;0;479;0
WireConnection;480;1;465;0
WireConnection;170;1;94;4
WireConnection;170;2;137;0
WireConnection;441;0;132;1
WireConnection;428;0;427;0
WireConnection;428;1;61;0
WireConnection;428;2;3;4
WireConnection;438;0;449;0
WireConnection;438;1;427;0
WireConnection;332;0;321;0
WireConnection;332;1;337;0
WireConnection;359;0;362;0
WireConnection;359;1;121;0
WireConnection;165;0;170;0
WireConnection;165;1;121;0
WireConnection;436;0;438;0
WireConnection;436;1;428;0
WireConnection;436;2;3;4
WireConnection;307;0;332;0
WireConnection;307;1;359;0
WireConnection;445;0;441;0
WireConnection;460;1;480;0
WireConnection;447;0;445;0
WireConnection;472;0;433;0
WireConnection;458;0;482;0
WireConnection;458;1;460;0
WireConnection;316;0;307;0
WireConnection;316;1;314;0
WireConnection;316;2;3;4
WireConnection;424;0;23;0
WireConnection;424;1;425;0
WireConnection;424;2;426;0
WireConnection;424;3;165;0
WireConnection;424;4;436;0
WireConnection;470;0;472;0
WireConnection;470;1;458;1
WireConnection;444;1;447;0
WireConnection;216;0;23;0
WireConnection;216;1;217;0
WireConnection;216;2;316;0
WireConnection;216;3;316;0
WireConnection;216;4;424;0
WireConnection;443;0;444;0
WireConnection;443;1;216;0
WireConnection;443;2;3;4
WireConnection;453;0;454;0
WireConnection;453;2;452;0
WireConnection;459;0;470;0
WireConnection;459;1;455;0
WireConnection;450;0;453;0
WireConnection;450;1;443;0
WireConnection;483;0;362;0
WireConnection;483;1;459;0
WireConnection;456;0;457;0
WireConnection;456;2;483;0
WireConnection;456;3;450;0
WireConnection;55;0;456;0
ASEEND*/
//CHKSM=4B1401C131E96ECE024B5C0E632ED9DA671ECC6F