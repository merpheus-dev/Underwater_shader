Shader "Custom/DisplacementImgEff"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplacementTex("Diplacement",2D) = "white" {}
		_Magnitude("Magnitude",Range(0,1)) =0
		_SeaColor("SeaColor",Color) = (1,1,1,1)
		_Speed("Speed",Range(0,1)) = 1
	}
	SubShader
	{
		Pass
		{
			Cull Off ZWrite Off ZTest Always
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			sampler2D _DisplacementTex;
			float _Magnitude;
			fixed4 _SeaColor;
			float _Speed;
			fixed4 frag (v2f i) : SV_Target
			{
				float4 duv = float4(i.uv.r,i.uv.g,0,1);
				duv.y*=0.2;
				duv.x*=0.1;
				duv.y+=_Time*_Speed;
				duv.x+_Time;
				fixed4 disp = tex2D(_DisplacementTex,duv);
				float2 dispUV = ((disp*2)-1) *_Magnitude;
				fixed4 col = tex2D(_MainTex, i.uv+dispUV)*_SeaColor;
				return col;
			}
			ENDCG
		}
	}
}
