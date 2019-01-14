// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SkyboxShader"
{
	Properties
	{
		[HDR]_SunColoratSunset("Sun Color at Sunset", Color) = (0.7490196,0.1686275,0.09019608,1)
		_SunSkyboxPower("Sun Skybox Power", Range( 0 , 5)) = 0
		[HDR]_SunContrastColor("Sun Contrast Color", Color) = (0,0,0,0)
		[HDR]_SkySunrise("Sky Sunrise", Color) = (0,0,0,0)
		[HDR]_SkyNoon("Sky Noon", Color) = (0,0,0,0)
		[HDR]_SkySunset("Sky Sunset", Color) = (1,0.04397481,0,1)
		_StarDensity("Star Density", Range( 0 , 1)) = 0.8823523
		_NightSkyColor("Night Sky Color", Color) = (1,0,0.7741938,0)
		_CelestialCloudColor1("Celestial Cloud Color 1", Color) = (0.3959684,0,1,0)
		_CelestialCloudColor2("Celestial Cloud Color 2", Color) = (0,0.7239275,1,0)
		_BlendPower("BlendPower", Range( 0 , 10)) = 6.696574
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform float4 _SunColoratSunset;
			uniform float4 _SkySunrise;
			uniform float _BlendPower;
			uniform float4 _SkyNoon;
			uniform float4 _SkySunset;
			uniform float4 _SunContrastColor;
			uniform float _SunSkyboxPower;
			uniform float _StarDensity;
			uniform float4 _NightSkyColor;
			uniform float4 _CelestialCloudColor1;
			uniform float4 _CelestialCloudColor2;
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
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(ase_worldPos);
				float dotResult87 = dot( ase_worldViewDir , worldSpaceLightDir );
				float dotResult151 = dot( worldSpaceLightDir , float3(0,0,-1) );
				float clampResult169 = clamp( dotResult151 , 0.0 , 1.0 );
				float dotResult157 = dot( worldSpaceLightDir , float3(0,1,0) );
				float clampResult170 = clamp( dotResult157 , 0.0 , 1.0 );
				float dotResult135 = dot( worldSpaceLightDir , float3(0,0,1) );
				float clampResult171 = clamp( dotResult135 , 0.0 , 1.0 );
				#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 lerpResult7 = lerp( float4( ase_lightColor.rgb , 0.0 ) , _SunContrastColor , pow( (1.0 + (dotResult151 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) , _SunSkyboxPower ));
				float4 screenPos = i.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos/screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float cos46 = cos( 0.01 * _Time.y );
				float sin46 = sin( 0.01 * _Time.y );
				float2 rotator46 = mul( ase_screenPosNorm.xy - float2( 1,0 ) , float2x2( cos46 , -sin46 , sin46 , cos46 )) + float2( 1,0 );
				float simplePerlin2D39 = snoise( ( rotator46 * 100 ) );
				float4 color44 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float4 ifLocalVar42 = 0;
				if( simplePerlin2D39 <= _StarDensity )
				ifLocalVar42 = _NightSkyColor;
				else
				ifLocalVar42 = color44;
				float simplePerlin2D49 = snoise( ( rotator46 * 1 ) );
				float4 lerpResult52 = lerp( _CelestialCloudColor1 , _CelestialCloudColor2 , simplePerlin2D49);
				float simplePerlin2D58 = snoise( (rotator46*2.0 + 2.13) );
				float4 lerpResult56 = lerp( lerpResult52 , float4( 0,0,0,0 ) , simplePerlin2D58);
				float dotResult159 = dot( worldSpaceLightDir , float3(0,-1,0) );
				float4 lerpResult64 = lerp( lerpResult7 , ( ifLocalVar42 + ( lerpResult56 * 0.2 ) ) , pow( (0.0 + (dotResult159 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , 10.0 ));
				float4 color27 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 color28 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
				float4 clampResult25 = clamp( ( ( _SkySunrise * pow( clampResult169 , _BlendPower ) ) + ( _SkyNoon * pow( clampResult170 , _BlendPower ) ) + ( _SkySunset * pow( clampResult171 , _BlendPower ) ) + lerpResult64 ) , color27 , color28 );
				float4 ifLocalVar30 = 0;
				if( ( 1.0 - (0.0 + (dotResult87 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) ) <= 0.9999 )
				ifLocalVar30 = clampResult25;
				else
				ifLocalVar30 = _SunColoratSunset;
				
				
				finalColor = ifLocalVar30;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16100
2567;-477;1906;1124;5323.177;4424.717;3.813652;True;False
Node;AmplifyShaderEditor.CommentaryNode;66;-3980.621,-2946.052;Float;False;2351.254;1531.051;Continuously rotating noise driven stars and celestial clouds;7;55;67;68;70;71;69;48;Starry Night Rotating;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-3939.198,-2854.817;Float;False;472.7168;257;Centralized rotation to drive whole sky;2;46;40;Rotating Screen Space Reference;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;40;-3889.199,-2804.818;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;68;-3405.41,-2834.002;Float;False;205.9644;1392.956;Offsets;3;59;50;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;46;-3679.482,-2799.891;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;74;-5965.358,-2629.921;Float;False;1629.6;1516.002;Directional light source reference;5;92;87;3;10;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleNode;50;-3395.504,-2045.749;Float;False;1;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;133;-5862.484,-2108.601;Float;False;1468.813;943.708;V2;17;160;155;161;156;163;157;135;151;159;134;162;154;158;169;170;171;172;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;70;-3173.543,-2187.356;Float;False;498.7173;504.7908;Celestial dust;4;52;49;53;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;71;-2636.986,-2030.158;Float;False;561.1379;265.3328;Celestial dust masking;2;58;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;154;-5384.266,-2039.083;Float;False;Constant;_SR;SR;6;0;Create;True;0;0;False;0;0,0,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;59;-3391.651,-1577.634;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2.13;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;54;-3154.384,-1966.449;Float;False;Property;_CelestialCloudColor2;Celestial Cloud Color 2;9;0;Create;True;0;0;False;0;0,0.7239275,1,0;0.6037736,0.1517382,0.04841581,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;49;-3112.454,-1796.468;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-5808.105,-2331.696;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;53;-3159.684,-2138.45;Float;False;Property;_CelestialCloudColor1;Celestial Cloud Color 1;8;0;Create;True;0;0;False;0;0.3959684,0,1,0;0.4150943,0.1272695,0.2984085,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;134;-5376.325,-1611.687;Float;False;Constant;_SS;SS;6;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleNode;41;-3391.41,-2792.001;Float;False;100;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;158;-5378.309,-1827.579;Float;False;Constant;_HN;HN;6;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;72;-1465.145,-3695.052;Float;False;1247.323;1241.497;Sky Color Control;8;105;14;103;164;165;166;168;109;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;52;-2818.303,-1986.028;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;69;-3175.789,-2785.146;Float;False;740.7944;584.8713;Stars vs blanks sky;5;42;44;45;39;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;58;-2610.772,-1849.042;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;162;-5376.824,-1397.253;Float;False;Constant;_MN;MN;6;0;Create;True;0;0;False;0;0,-1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;151;-5187.266,-2057.083;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-2426.176,-3562.846;Float;False;799.6808;555.798;Directional lighting contribution to skybox;6;22;21;9;7;23;176;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;135;-5179.325,-1629.688;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;39;-3058.587,-2728.775;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;157;-5181.309,-1845.58;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-1302.063,-2874.763;Float;False;688.8569;303;Star Controls;3;64;98;174;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;56;-2231.869,-1980.157;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2408.042,-3205.401;Float;False;Property;_SunSkyboxPower;Sun Skybox Power;1;0;Create;True;0;0;False;0;0;0.2941177;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;-3057.954,-2574.702;Float;False;Constant;_StarColor;Star Color;4;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-3125.789,-2652.568;Float;False;Property;_StarDensity;Star Density;6;0;Create;True;0;0;False;0;0.8823523;0.803;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-3058.228,-2407.275;Float;False;Property;_NightSkyColor;Night Sky Color;7;0;Create;True;0;0;False;0;1,0,0.7741938,0;0.09313812,0.1963406,0.2169811,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;176;-2404.379,-3387.117;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;159;-5179.824,-1415.254;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-5836.006,-2046.597;Float;False;Property;_BlendPower;BlendPower;10;0;Create;True;0;0;False;0;6.696574;2.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;170;-4928.109,-1839.772;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;171;-4928.106,-1623.749;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;174;-1279.48,-2779.389;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;169;-4924.906,-2055.796;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;42;-2683.214,-2451.114;Float;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;23;-2012.927,-3515.848;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;21;-2085.666,-3224.056;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;55;-2035.543,-1978.526;Float;False;0.2;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-2070.671,-3395.19;Float;False;Property;_SunContrastColor;Sun Contrast Color;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-1101.255,-3519.741;Float;False;Property;_SkySunrise;Sky Sunrise;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.6627451,0.5921569,0.4588235,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;103;-1102.379,-3308.709;Float;False;Property;_SkyNoon;Sky Noon;4;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.993681,1.367988,1.45283,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;98;-1073.166,-2781.238;Float;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-1103.027,-3100.593;Float;False;Property;_SkySunset;Sky Sunset;5;1;[HDR];Create;True;0;0;False;0;1,0.04397481,0,1;1.490566,0.7857557,0.6679423,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;160;-4743.079,-1842.145;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;156;-4743.867,-2055.255;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;155;-4741.096,-1626.253;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1829.264,-2439.07;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;3;-5755.803,-2478.797;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;7;-1786.572,-3493.111;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-809.2985,-3304.736;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-810.5314,-3514.437;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;64;-878.2078,-2824.763;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-808.2756,-3094.953;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;73;140.5542,-3281.373;Float;False;556.416;543.1909;Skybox color clamp;3;27;28;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;87;-5432.333,-2356.636;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;190.5541,-3099.607;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-477.7397,-3235.149;Float;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;92;-5168.043,-2355.254;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;190.5541,-2929.606;Float;False;Constant;_Color1;Color 1;4;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;223.1843,-3761.151;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0.9999;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;100;207.2832,-3898.229;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;496.7472,-3655.885;Float;False;Property;_SunColoratSunset;Sun Color at Sunset;0;1;[HDR];Create;True;0;0;False;0;0.7490196,0.1686275,0.09019608,1;2.996078,0.6745098,0.3607843,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;25;528.2006,-3231.373;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;161;-4737.771,-1412.079;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;30;864.8489,-3762.059;Float;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;172;-4929.707,-1410.926;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1154.572,-3763.397;Float;False;True;2;Float;ASEMaterialInspector;0;1;SkyboxShader;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;46;0;40;0
WireConnection;50;0;46;0
WireConnection;59;0;46;0
WireConnection;49;0;50;0
WireConnection;41;0;46;0
WireConnection;52;0;53;0
WireConnection;52;1;54;0
WireConnection;52;2;49;0
WireConnection;58;0;59;0
WireConnection;151;0;10;0
WireConnection;151;1;154;0
WireConnection;135;0;10;0
WireConnection;135;1;134;0
WireConnection;39;0;41;0
WireConnection;157;0;10;0
WireConnection;157;1;158;0
WireConnection;56;0;52;0
WireConnection;56;2;58;0
WireConnection;176;0;151;0
WireConnection;159;0;10;0
WireConnection;159;1;162;0
WireConnection;170;0;157;0
WireConnection;171;0;135;0
WireConnection;174;0;159;0
WireConnection;169;0;151;0
WireConnection;42;0;39;0
WireConnection;42;1;43;0
WireConnection;42;2;44;0
WireConnection;42;3;45;0
WireConnection;42;4;45;0
WireConnection;21;0;176;0
WireConnection;21;1;22;0
WireConnection;55;0;56;0
WireConnection;98;0;174;0
WireConnection;160;0;170;0
WireConnection;160;1;163;0
WireConnection;156;0;169;0
WireConnection;156;1;163;0
WireConnection;155;0;171;0
WireConnection;155;1;163;0
WireConnection;48;0;42;0
WireConnection;48;1;55;0
WireConnection;7;0;23;1
WireConnection;7;1;9;0
WireConnection;7;2;21;0
WireConnection;165;0;103;0
WireConnection;165;1;160;0
WireConnection;164;0;14;0
WireConnection;164;1;156;0
WireConnection;64;0;7;0
WireConnection;64;1;48;0
WireConnection;64;2;98;0
WireConnection;166;0;105;0
WireConnection;166;1;155;0
WireConnection;87;0;3;0
WireConnection;87;1;10;0
WireConnection;168;0;164;0
WireConnection;168;1;165;0
WireConnection;168;2;166;0
WireConnection;168;3;64;0
WireConnection;92;0;87;0
WireConnection;100;0;92;0
WireConnection;25;0;168;0
WireConnection;25;1;27;0
WireConnection;25;2;28;0
WireConnection;161;0;172;0
WireConnection;161;1;163;0
WireConnection;30;0;100;0
WireConnection;30;1;33;0
WireConnection;30;2;38;0
WireConnection;30;3;25;0
WireConnection;30;4;25;0
WireConnection;172;0;159;0
WireConnection;1;0;30;0
ASEEND*/
//CHKSM=E047702915CE2D9E61A1AE0AFDC84B4A43BF4360