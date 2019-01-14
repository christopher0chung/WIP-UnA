// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TrailShader"
{
	Properties
	{
		[HDR]_First("First", Color) = (0,0,0,0)
		[HDR]_Second("Second", Color) = (0,0,0,0)
		[HDR]_Third("Third", Color) = (0,0,0,0)
		[HDR]_Fourth("Fourth", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float4 _First;
		uniform float4 _Second;
		uniform float4 _Third;
		uniform float4 _Fourth;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime7 = _Time.y * 0.25;
			float temp_output_8_0 = sin( mulTime7 );
			float clampResult10 = clamp( temp_output_8_0 , 0.0 , 1.0 );
			float4 lerpResult25 = lerp( float4( 0,0,0,0 ) , _First , (0.0 + (clampResult10 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)));
			float temp_output_9_0 = cos( mulTime7 );
			float clampResult13 = clamp( temp_output_9_0 , -1.0 , 0.0 );
			float4 lerpResult22 = lerp( float4( 0,0,0,0 ) , _Second , (0.0 + (clampResult13 - 0.0) * (1.0 - 0.0) / (-1.0 - 0.0)));
			float clampResult11 = clamp( temp_output_8_0 , -1.0 , 0.0 );
			float4 lerpResult23 = lerp( float4( 0,0,0,0 ) , _Third , (0.0 + (clampResult11 - 0.0) * (1.0 - 0.0) / (-1.0 - 0.0)));
			float clampResult12 = clamp( temp_output_9_0 , 0.0 , 1.0 );
			float4 lerpResult24 = lerp( float4( 0,0,0,0 ) , _Fourth , (0.0 + (clampResult12 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)));
			o.Emission = ( lerpResult25 + lerpResult22 + lerpResult23 + lerpResult24 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
2567;-483;1906;1130;3835.971;449.0814;1.823919;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;7;-2795.756,387.0131;Float;False;1;0;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-2491.26,348.887;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;9;-2490.26,441.887;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;10;-2252.259,224.887;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;12;-2229.547,877.562;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;11;-2231.371,659.4236;Float;True;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;13;-2223.427,441.7411;Float;True;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;36;-1993.82,442.8152;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;34;-1986.523,670.8035;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1993.817,223.9451;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;-1986.521,887.8486;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-1076.24,738.6746;Float;False;Property;_Fourth;Fourth;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.6623012,0.5667114,0.7578911,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-1079.065,510.9565;Float;False;Property;_Third;Third;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.5667114,0.7578911,0.7578911,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-1072.888,77.23921;Float;False;Property;_First;First;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.7578911,0.5667114,0.5667114,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;28;-1080.36,306.1894;Float;False;Property;_Second;Second;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.6623012,0.7578911,0.5667114,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-853.4717,393.5482;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;-855.7674,619.3915;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;25;-848.6478,176.7043;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;24;-853.6478,827.3484;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-578,328;Float;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;TrailShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;9;0;7;0
WireConnection;10;0;8;0
WireConnection;12;0;9;0
WireConnection;11;0;8;0
WireConnection;13;0;9;0
WireConnection;36;0;13;0
WireConnection;34;0;11;0
WireConnection;33;0;10;0
WireConnection;35;0;12;0
WireConnection;22;1;28;0
WireConnection;22;2;36;0
WireConnection;23;1;29;0
WireConnection;23;2;34;0
WireConnection;25;1;31;0
WireConnection;25;2;33;0
WireConnection;24;1;30;0
WireConnection;24;2;35;0
WireConnection;26;0;25;0
WireConnection;26;1;22;0
WireConnection;26;2;23;0
WireConnection;26;3;24;0
WireConnection;5;2;26;0
ASEEND*/
//CHKSM=F24C4C3F4B199E5443951C05015D52D8B44A9CB1