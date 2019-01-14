// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterMat"
{
	Properties
	{
		_Metalness("Metalness", Float) = 0
		_NoiseScale("Noise Scale", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 0
		_Power("Power", Float) = 0
		_WaterColor1("Water Color 1", Color) = (0,0,0,0)
		_WaterColor2("Water Color 2", Color) = (0,0,0,0)
		_NormalNoiseScale("Normal Noise Scale", Float) = 0
		_NormalScale("Normal Scale", Float) = 0
		_WorldSpaceCameraOffset("WorldSpaceCameraOffset", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow exclude_path:forward vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _WorldSpaceCameraOffset;
		uniform float _NoiseScale;
		uniform sampler2D _TextureSample0;
		uniform float _NormalScale;
		uniform sampler2D _TextureSample1;
		uniform float _NormalNoiseScale;
		uniform float4 _WaterColor2;
		uniform float4 _WaterColor1;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _Metalness;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform66 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float temp_output_153_0 = ( transform66.x + _WorldSpaceCameraOffset );
			float4 appendResult32 = (float4(temp_output_153_0 , transform66.z , 0.0 , 0.0));
			float2 panner54 = ( 1.0 * _Time.y * float2( 0,0.1 ) + ( appendResult32 * _NoiseScale ).xy);
			float simplePerlin3D51 = snoise( float3( panner54 ,  0.0 ) );
			float4 appendResult52 = (float4(0.0 , cos( ( simplePerlin3D51 * UNITY_PI ) ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult52.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform66 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float temp_output_153_0 = ( transform66.x + _WorldSpaceCameraOffset );
			float4 appendResult32 = (float4(temp_output_153_0 , transform66.z , 0.0 , 0.0));
			float4 temp_output_151_0 = ( appendResult32 * _NormalScale );
			float2 panner114 = ( 1.0 * _Time.y * float2( 0,0.1 ) + temp_output_151_0.xy);
			float2 panner115 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + ( temp_output_151_0 + float4( 0.111,0.112,0,0 ) ).xy);
			float4 appendResult117 = (float4(( temp_output_153_0 * _NormalNoiseScale ) , ( transform66.z * _NormalNoiseScale ) , _Time.y , 0.0));
			float simplePerlin3D116 = snoise( appendResult117.xyz );
			float3 lerpResult113 = lerp( UnpackScaleNormal( tex2D( _TextureSample0, panner114 ), 0.1 ) , UnpackScaleNormal( tex2D( _TextureSample1, panner115 ), 0.1 ) , simplePerlin3D116);
			o.Normal = lerpResult113;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV102 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode102 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV102, _Power ) );
			float clampResult110 = clamp( fresnelNode102 , 0.0 , 1.0 );
			float4 lerpResult109 = lerp( _WaterColor2 , _WaterColor1 , clampResult110);
			float4 clampResult111 = clamp( lerpResult109 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Albedo = clampResult111.rgb;
			o.Metallic = _Metalness;
			o.Smoothness = 1.0;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
2567;-483;1906;1130;1248.946;193.2983;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;31;-3377.17,-171.9615;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;66;-3145.402,-173.2223;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;-3253.232,-362.6245;Float;False;Property;_WorldSpaceCameraOffset;WorldSpaceCameraOffset;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-2909.882,-184.1895;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-2654.767,-144.3684;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1571.125,509.9277;Float;False;Property;_NoiseScale;Noise Scale;1;0;Create;True;0;0;False;0;0;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-2581.382,-366.7049;Float;False;Property;_NormalScale;Normal Scale;10;0;Create;True;0;0;False;0;0;0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1396.905,491.8286;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1095.903,-356.277;Float;False;Property;_Power;Power;6;0;Create;True;0;0;False;0;0;9.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-1092.903,-504.2769;Float;False;Property;_Bias;Bias;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;54;-1253.318,492.0197;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1094.903,-430.277;Float;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;0;1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1933.71,186.6897;Float;False;Property;_NormalNoiseScale;Normal Noise Scale;9;0;Create;True;0;0;False;0;0;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-2450.081,-152.2049;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;51;-1067.615,487.1388;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1671.105,121.3527;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1672.362,215.5888;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;-2313.987,-8.751015;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.111,0.112,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;118;-1684.236,343.5248;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;63;-1043.912,711.1748;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;102;-766.8331,-528.4287;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;106;-502.3753,-701.8043;Float;False;Property;_WaterColor2;Water Color 2;8;0;Create;True;0;0;False;0;0,0,0,0;0,0.0722186,0.3490566,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;114;-2157.154,-202.2962;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;115;-2167.707,-8.38163;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;107;-503.3752,-872.9897;Float;False;Property;_WaterColor1;Water Color 1;7;0;Create;True;0;0;False;0;0,0,0,0;0,0.3705048,0.3764706,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;110;-444.5295,-527.9545;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-859.9127,492.1747;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;117;-1432.418,191.3714;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;116;-1281.75,188.733;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;109;-204.2218,-668.9774;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CosOpNode;64;-714.9128,491.1747;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-1288.236,-227.0239;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;2dfd6882d66328b43b89566e350fc413;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;112;-1290.619,-34.27941;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;2dfd6882d66328b43b89566e350fc413;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;52;-483.6172,466.1388;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;2;9.772457,48.41292;Float;False;Property;_Metalness;Metalness;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;111;-12.39461,-329.0097;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;113;-853.3094,-94.88379;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-103.3512,121.97;Float;False;Constant;_Smoothness;Smoothness;11;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;325.032,-32.78378;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;WaterMat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;DeferredOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;31;0
WireConnection;153;0;66;1
WireConnection;153;1;155;0
WireConnection;32;0;153;0
WireConnection;32;1;66;3
WireConnection;55;0;32;0
WireConnection;55;1;56;0
WireConnection;54;0;55;0
WireConnection;151;0;32;0
WireConnection;151;1;152;0
WireConnection;51;0;54;0
WireConnection;119;0;153;0
WireConnection;119;1;121;0
WireConnection;120;0;66;3
WireConnection;120;1;121;0
WireConnection;122;0;151;0
WireConnection;102;1;103;0
WireConnection;102;2;104;0
WireConnection;102;3;105;0
WireConnection;114;0;151;0
WireConnection;115;0;122;0
WireConnection;110;0;102;0
WireConnection;62;0;51;0
WireConnection;62;1;63;0
WireConnection;117;0;119;0
WireConnection;117;1;120;0
WireConnection;117;2;118;0
WireConnection;116;0;117;0
WireConnection;109;0;106;0
WireConnection;109;1;107;0
WireConnection;109;2;110;0
WireConnection;64;0;62;0
WireConnection;100;1;114;0
WireConnection;112;1;115;0
WireConnection;52;1;64;0
WireConnection;111;0;109;0
WireConnection;113;0;100;0
WireConnection;113;1;112;0
WireConnection;113;2;116;0
WireConnection;0;0;111;0
WireConnection;0;1;113;0
WireConnection;0;3;2;0
WireConnection;0;4;95;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=1D3459FC93388A4138CDD6C6E39C945527D0B864