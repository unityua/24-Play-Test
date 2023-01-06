// Toony Colors Pro+Mobile 2
// (c) 2014-2020 Jean Moreno

Shader "Toony Colors Pro 2/Hybrid Shader Bend"
{
	Properties
	{
		[Enum(Front, 2, Back, 1, Both, 0)] _Cull ("Render Face", Float) = 2.0
		[TCP2ToggleNoKeyword] _ZWrite ("Depth Write", Float) = 1.0
		[Toggle(_ALPHATEST_ON)] _UseAlphaTest ("Alpha Clipping", Float) = 0
	//# IF_KEYWORD _ALPHATEST_ON
		_Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
	//# END_IF
 
	//# Bend
        _UpDir ("Up Dir", Vector) = (1,0,0,0)
        _MeshTop ("Mesh Top", float) = 0.5
        _RollDir ("Roll Dir", Vector) = (0,1,0,0)
        _Radius ("Radius", float) = 0
        _Deviation ("Deviation", float) = 0.5
        _PointX ("PointX", float) = 0
        _PointY ("PointY", float) = 0
	//#	

	//# ========================================================
	//# Base
		[MainColor] _BaseColor ("Color", Color) = (1,1,1,1)
		[MainTexture] _BaseMap ("Albedo", 2D) = "white" {}
		[TCP2ColorNoAlpha] _HColor ("Highlight Color", Color) = (1,1,1,1)
		[TCP2ColorNoAlpha] _SColor ("Shadow Color", Color) = (0.2,0.2,0.2,1)
		[Toggle(TCP2_SHADOW_TEXTURE)] _UseShadowTexture ("Enable Shadow Albedo Texture", Float) = 0
	//# IF_KEYWORD TCP2_SHADOW_TEXTURE
		[NoScaleOffset] _ShadowBaseMap ("Shadow Albedo", 2D) = "gray" {}
	//# END_IF

	//# ========================================================

	//# Ramp Shading
		[TCP2MaterialKeywordEnumNoPrefix(Default,_,Crisp,TCP2_RAMP_CRISP,Bands,TCP2_RAMP_BANDS,Bands Crisp,TCP2_RAMP_BANDS_CRISP,Texture,TCP2_RAMPTEXT)] _RampType ("Ramp Type", Float) = 0
	//# IF_KEYWORD TCP2_RAMPTEXT
		[TCP2Gradient] _Ramp ("Ramp Texture (RGB)", 2D) = "gray" {}
		_RampScale ("Scale", Float) = 1.0
		_RampOffset ("Offset", Float) = 0.0
	//# ELSE
		[PowerSlider(0.415)] _RampThreshold ("Threshold", Range(0.01,1)) = 0.75
	//# END_IF
	//# IF_KEYWORD !TCP2_RAMPTEXT && !TCP2_RAMP_CRISP
		_RampSmoothing ("Smoothing", Range(0,1)) = 0.1
	//# END_IF
	//# IF_KEYWORD TCP2_RAMP_BANDS || TCP2_RAMP_BANDS_CRISP
		[IntRange] _RampBands ("Bands Count", Range(1,20)) = 4
	//# END_IF
	//# IF_KEYWORD TCP2_RAMP_BANDS
		_RampBandsSmoothing ("Bands Smoothing", Range(0,1)) = 0.1
	//# END_IF

	//# ========================================================

		[TCP2HeaderToggle(_NORMALMAP)] _UseNormalMap ("Normal Mapping", Float) = 0
	//# IF_KEYWORD _NORMALMAP
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("Scale", Range(-1,1)) = 1
	//# END_IF
	//# ========================================================

		[TCP2HeaderToggle(TCP2_SPECULAR)] _UseSpecular ("Specular", Float) = 0
	//# IF_KEYWORD TCP2_SPECULAR
		[TCP2MaterialKeywordEnumNoPrefix(GGX,_,Stylized,TCP2_SPECULAR_STYLIZED,Crisp,TCP2_SPECULAR_CRISP)] _SpecularType ("Type", Float) = 0
		[TCP2ColorNoAlpha] [HDR] _SpecularColor ("Color", Color) = (0.75,0.75,0.75,1)
	//# IF_KEYWORD TCP2_SPECULAR_STYLIZED || TCP2_SPECULAR_CRISP
		[PowerSlider(5.0)] _SpecularToonSize ("Size", Range(0.001,1)) = 0.25
	//# IF_KEYWORD TCP2_SPECULAR_STYLIZED
		_SpecularToonSmoothness ("Smoothing", Range(0,1)) = 0.05
	//# END_IF
	//# ELSE
		_SpecularRoughness ("Roughness", Range(0,1)) = 0.5
	//# END_IF
	//# IF_KEYWORD_DISABLE !TCP2_MOBILE
		[Enum(Disabled,0,Albedo Alpha,1,Custom R,2,Custom G,3,Custom B,4,Custom A,5)] _SpecularMapType ("Specular Map#Specular Map (A)", Float) = 0
	//# END_IF_DISABLE
	//# IF_PROPERTY _SpecularMapType >= 2 || _UseMobileMode == 1
		[NoScaleOffset] _SpecGlossMap ("Specular Texture", 2D) = "white" {}
	//# END_IF
	//# END_IF
	//# ========================================================

		[TCP2HeaderToggle(_EMISSION)] _UseEmission ("Emission", Float) = 0
	//# IF_KEYWORD _EMISSION
	//# IF_KEYWORD_DISABLE !TCP2_MOBILE
		[Enum(No Texture,5,R,0,G,1,B,2,A,3,RGB,4)] _EmissionChannel ("Texture Channel", Float) = 4
	//# END_IF_DISABLE
	//# IF_PROPERTY _EmissionChannel < 5 || _UseMobileMode == 1
		_EmissionMap ("Texture#Texture (A)", 2D) = "white" {}
	//# END_IF
		[TCP2ColorNoAlpha] [HDR] _EmissionColor ("Color", Color) = (1,1,0,1)
	//# END_IF
	//# ========================================================

		[TCP2HeaderToggle(TCP2_RIM_LIGHTING)] _UseRim ("Rim Lighting", Float) = 0
	//# IF_KEYWORD TCP2_RIM_LIGHTING
		[TCP2ColorNoAlpha] [HDR] _RimColor ("Color", Color) = (0.8,0.8,0.8,0.5)
		_RimMin ("Min", Range(0,2)) = 0.5
		_RimMax ("Max", Range(0,2)) = 1
		[Toggle(TCP2_RIM_LIGHTING_LIGHTMASK)] _UseRimLightMask ("Light-based Mask", Float) = 1
	//# END_IF
	//# ========================================================

		[TCP2HeaderToggle(TCP2_MATCAP)] _UseMatCap ("MatCap", Float) = 0
	//# IF_KEYWORD TCP2_MATCAP
	//# IF_KEYWORD_DISABLE !TCP2_MOBILE
		[Enum(Additive,0,Replace,1)] _MatCapType ("MatCap Blending", Float) = 0
	//# END_IF_DISABLE
		[NoScaleOffset] _MatCapTex ("Texture", 2D) = "black" {}
		[HDR] [TCP2ColorNoAlpha] _MatCapColor ("Color", Color) = (1,1,1,1)
		[Toggle(TCP2_MATCAP_MASK)] _UseMatCapMask ("Enable Mask", Float) = 0
	//# IF_KEYWORD TCP2_MATCAP_MASK
		[NoScaleOffset] _MatCapMask ("Mask Texture#Mask Texture (A)", 2D) = "black" {}
	//# IF_KEYWORD_DISABLE !TCP2_MOBILE
		[Enum(R,0,G,1,B,2,A,3)] _MatCapMaskChannel ("Texture Channel", Float) = 0
	//# END_IF_DISABLE
	//# END_IF
	//# END_IF
	//# ========================================================

	//# Global Illumination
	//# 

	//# Indirect Diffuse
		_IndirectIntensity ("Strength", Range(0,1)) = 1
	//# IF_PROPERTY _IndirectIntensity > 0
		[TCP2ToggleNoKeyword] _SingleIndirectColor ("Single Indirect Color", Float) = 0
	//# END_IF
	//# 

		[TCP2HeaderToggle(TCP2_REFLECTIONS)] _UseReflections ("Indirect Specular (Environment Reflections)", Float) = 0
	//# IF_KEYWORD TCP2_REFLECTIONS
		[TCP2ColorNoAlpha] _ReflectionColor ("Color", Color) = (1,1,1,1)
		_ReflectionSmoothness ("Smoothness", Range(0,1)) = 0.5
	//# IF_KEYWORD_DISABLE !TCP2_MOBILE
		[TCP2Enum(Disabled,0,Albedo Alpha (Smoothness),1,Custom R (Smoothness),2,Custom G (Smoothness),3,Custom B (Smoothness),4,Custom A (Smoothness),5,Albedo Alpha (Mask),6,Custom R (Mask),7,Custom G (Mask),8,Custom B (Mask),9,Custom A (Mask),10)]
		_ReflectionMapType ("Reflection Map", Float) = 0
	//# END_IF_DISABLE
	//# IF_PROPERTY (_ReflectionMapType != 0 && _ReflectionMapType != 1 && _ReflectionMapType != 6) || _UseMobileMode == 1
		[NoScaleOffset] _ReflectionTex ("Reflection Texture#Reflection Texture (A)", 2D) = "white" {}
	//# END_IF
		[Toggle(TCP2_REFLECTIONS_FRESNEL)] _UseFresnelReflections ("Fresnel Reflections", Float) = 1
	//# IF_KEYWORD TCP2_REFLECTIONS_FRESNEL
		_FresnelMin ("Fresnel Min", Range(0,2)) = 0
		_FresnelMax ("Fresnel Max", Range(0,2)) = 1.5
	//# END_IF
	//# END_IF
	//# 

		[TCP2HeaderToggle(TCP2_OCCLUSION)] _UseOcclusion ("Occlusion", Float) = 0
	//# IF_KEYWORD TCP2_OCCLUSION
		_OcclusionStrength ("Strength", Range(0.0, 1.0)) = 1.0
	//# IF_PROPERTY _OcclusionChannel >= 1 || _UseMobileMode == 1
		[NoScaleOffset] _OcclusionMap ("Texture#Texture (A)", 2D) = "white" {}
	//# END_IF
	//# IF_KEYWORD_DISABLE !TCP2_MOBILE
		[Enum(Albedo Alpha,0,Custom R,1,Custom G,2,Custom B,3,Custom A,4)] _OcclusionChannel ("Texture Channel", Float) = 0
	//# END_IF_DISABLE
	//# END_IF
	//# 

	//# ========================================================

		[TCP2HeaderToggle] _UseOutline ("Outline", Float) = 0
	//# IF_PROPERTY _UseOutline > 0
		[HDR] _OutlineColor ("Color", Color) = (0,0,0,1)
		[TCP2MaterialKeywordEnumNoPrefix(Disabled,_,Vertex Shader,TCP2_OUTLINE_TEXTURED_VERTEX,Pixel Shader,TCP2_OUTLINE_TEXTURED_FRAGMENT)] _OutlineTextureType ("Texture", Float) = 0
	//# IF_PROPERTY _OutlineTextureType >= 1
		_OutlineTextureLOD ("Texture LOD", Range(0,8)) = 5
	//# END_IF
	//# 
		_OutlineWidth ("Width", Range(0,10)) = 1
		[TCP2MaterialKeywordEnumNoPrefix(Disabled,_,Constant,TCP2_OUTLINE_CONST_SIZE,Minimum,TCP2_OUTLINE_MIN_SIZE)] _OutlinePixelSizeType ("Pixel Size", Float) = 0
	//# IF_KEYWORD TCP2_OUTLINE_MIN_SIZE
		_OutlineMinWidth ("Minimum Width (Pixels)", Float) = 1
	//# END_IF
	//# 
		[TCP2MaterialKeywordEnumNoPrefix(Normal, _, Vertex Colors, TCP2_COLORS_AS_NORMALS, Tangents, TCP2_TANGENT_AS_NORMALS, UV1, TCP2_UV1_AS_NORMALS, UV2, TCP2_UV2_AS_NORMALS, UV3, TCP2_UV3_AS_NORMALS, UV4, TCP2_UV4_AS_NORMALS)]
		_NormalsSource ("Outline Normals Source", Float) = 0
	//# IF_PROPERTY_DISABLE _NormalsSource > 2
		[TCP2MaterialKeywordEnumNoPrefix(Full XYZ, TCP2_UV_NORMALS_FULL, Compressed XY, _, Compressed ZW, TCP2_UV_NORMALS_ZW)]
		_NormalsUVType ("UV Data Type", Float) = 0
	//# END_IF_DISABLE
	//# 

	//# IF_URP
		[TCP2MaterialKeywordEnumNoPrefix(Disabled,_,Main Directional Light,TCP2_OUTLINE_LIGHTING_MAIN,All Lights,TCP2_OUTLINE_LIGHTING_ALL,Indirect Only, TCP2_OUTLINE_LIGHTING_INDIRECT)] _OutlineLightingTypeURP ("Lighting", Float) = 0
	//# ELSE
		[TCP2MaterialKeywordEnumNoPrefix(Disabled,_,Main Directional Light,TCP2_OUTLINE_LIGHTING_MAIN,Indirect Only, TCP2_OUTLINE_LIGHTING_INDIRECT)] _OutlineLightingType ("Lighting", Float) = 0
	//# END_IF
	//#
	//# IF_KEYWORD TCP2_OUTLINE_LIGHTING_MAIN || TCP2_OUTLINE_LIGHTING_ALL || TCP2_OUTLINE_LIGHTING_INDIRECT
	//# IF_KEYWORD TCP2_OUTLINE_LIGHTING_MAIN || TCP2_OUTLINE_LIGHTING_ALL
		_DirectIntensityOutline ("Direct Strength", Range(0,1)) = 1
	//# END_IF
		_IndirectIntensityOutline ("Indirect Strength", Range(0,1)) = 0
	//# END_IF
	//# END_IF

	//# ========================================================

	//# Options
		[ToggleOff(_RECEIVE_SHADOWS_OFF)] _ReceiveShadowsOff ("Receive Shadows", Float) = 1

		[HideInInspector] _RenderingMode ("rendering mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("blending source", Float) = 1.0
		[HideInInspector] _DstBlend ("blending destination", Float) = 0.0
		[HideInInspector] _UseMobileMode ("Mobile mode", Float) = 0
	}

	//================================================================================================================================
	//
	// UNIVERSAL RENDER PIPELINE
	//
	//================================================================================================================================

	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}

		Blend [_SrcBlend] [_DstBlend]
		ZWrite [_ZWrite]
		Cull [_Cull]

		HLSLINCLUDE
		#if defined(TCP2_HYBRID_URP)

			#define fixed half
			#define fixed2 half2
			#define fixed3 half3
			#define fixed4 half4

			#define UNITY_PASS_FORWARDBASE

			// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			// This would cause a compilation error if URP isn't installed, so instead we use the dedicated
			// "URP Support" file which contains all needed .hlslinc files embedded within a single file.

			#include "TCP2 Hybrid URP Support.cginc"
			#include "TCP2 Hybrid Include.cginc"

		#endif
		ENDHLSL

		Pass
		{
			Name "Main"
			Tags { "LightMode" = "UniversalForward" }

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard SRP library
			// All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"    
			#include "CustomTessellation.hlsl" 

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 3.0

			#pragma vertex VertexBend
			#pragma fragment Fragment

			#pragma multi_compile_fog
			#pragma multi_compile_instancing

			// -------------------------------------
			// Material keywords
			#pragma shader_feature _ _RECEIVE_SHADOWS_OFF

			// -------------------------------------
			// Universal Render Pipeline keywords
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

			// -------------------------------------
			// Unity keywords
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			//--------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local TCP2_MOBILE
			#pragma shader_feature_local _ TCP2_RAMPTEXT TCP2_RAMP_CRISP TCP2_RAMP_BANDS TCP2_RAMP_BANDS_CRISP
			#pragma shader_feature_local TCP2_SHADOW_TEXTURE
			#pragma shader_feature_local TCP2_SPECULAR
			#pragma shader_feature_local _ TCP2_SPECULAR_STYLIZED TCP2_SPECULAR_CRISP
			#pragma shader_feature_local TCP2_RIM_LIGHTING
			#pragma shader_feature_local TCP2_RIM_LIGHTING_LIGHTMASK
			#pragma shader_feature_local TCP2_REFLECTIONS
			#pragma shader_feature_local TCP2_REFLECTIONS_FRESNEL
			#pragma shader_feature_local TCP2_MATCAP
			#pragma shader_feature_local TCP2_MATCAP_MASK
			#pragma shader_feature_local TCP2_OCCLUSION
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _ALPHATEST_ON
			#pragma shader_feature_local _EMISSION

			// This is actually using an existing keyword to separate fade/transparent behaviors
			#pragma shader_feature_local _ _ALPHAPREMULTIPLY_ON

			// Force URP keyword to differentiate from built-in code
			#pragma multi_compile TCP2_HYBRID_URP

			float4 _UpDir;
	        float _MeshTop;
			float4 _RollDir;
			half _Radius;
			half _Deviation;
	        half _PointX;
	        half _PointY;

			            // pre tesselation vertex program
		    ControlPoint TessellationVertexProgram(Attributes v)
		    {
		        ControlPoint p;
		 
		        p.vertex = v.vertex;
		        p.texcoord0 = v.texcoord0;
		        p.normal = v.normal;
		        p.tangent = v.tangent;
		 
		        return p;
		    }

		    Varyings2 vert2(Attributes input)
		    {
		        Varyings2 output;
		        //float Noise = tex2Dlod(_Noise, float4(input.uv, 0, 0)).r;
		 
		        input.vertex.xyz += (input.normal) *  0.5 * 1;
		        output.pos = TransformObjectToHClip(input.vertex.xyz);
		        output.normal = input.normal;
		        output.worldPos = input.texcoord0;
		        return output;
		    }

			Varyings VertexBend(Attributes input)
			{
				Varyings output = (Varyings)0;

				float3 v0 = input.vertex.xyz;

	            float3 upDir = normalize(_UpDir);
	            float3 rollDir = normalize(_RollDir);

				//float y = UNITY_ACCESS_INSTANCED_PROP(Props, _PointY);
	            float y = _PointY;
	            float dP = dot(v0 - upDir * y, upDir);
	            dP = max(0, dP);
	            float3 fromInitialPos = upDir * dP;
	            v0 -= fromInitialPos;

	            float pi = 3.1415926535897932384626433832795;

	            float radius = _Radius + _Deviation * max(0, -(y - _MeshTop));
	            float length = 2 * pi * (radius - _Deviation * max(0, -(y - _MeshTop)) / 2);
	            float r = dP / max(0, length);
	            float a = 2 * r * pi;
	            
	            float s = sin(a);
	            float c = cos(a);
	            float one_minus_c = 1.0 - c;

	            float3 axis = normalize(cross(upDir, rollDir));
	            float3x3 rot_mat = 
	            {   one_minus_c * axis.x * axis.x + c, one_minus_c * axis.x * axis.y - axis.z * s, one_minus_c * axis.z * axis.x + axis.y * s,
	                one_minus_c * axis.x * axis.y + axis.z * s, one_minus_c * axis.y * axis.y + c, one_minus_c * axis.y * axis.z - axis.x * s,
	                one_minus_c * axis.z * axis.x - axis.y * s, one_minus_c * axis.y * axis.z + axis.x * s, one_minus_c * axis.z * axis.z + c
	            };
	            float3 cycleCenter = rollDir * _PointX + rollDir * radius + upDir * y;

	            float3 fromCenter = v0.xyz - cycleCenter;
	            float3 shiftFromCenterAxis = cross(axis, fromCenter);
	            shiftFromCenterAxis = cross(shiftFromCenterAxis, axis);
	            shiftFromCenterAxis = normalize(shiftFromCenterAxis);
	            fromCenter -= shiftFromCenterAxis * _Deviation * dP;// * ;

	            v0.xyz = mul(rot_mat, fromCenter) + cycleCenter;

				input.vertex.xyz = v0;

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				// Texture Coordinates
				output.texcoords.xy = input.texcoord0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				output.texcoords.zw = input.texcoord0.xy;

				#if defined(TCP2_HYBRID_URP)
					OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUV);

					VertexPositionInputs vertexInput = GetVertexPositionInputs(input.vertex.xyz);
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						output.shadowCoord = GetShadowCoord(vertexInput);
					#endif
					float3 positionWS = vertexInput.positionWS;
					float4 positionCS = vertexInput.positionCS;
					output.pos = positionCS;

					VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normal, input.tangent);
					float3 normalWS = vertexNormalInput.normalWS;
					#if defined(_NORMALMAP)
						float3 tangentWS = vertexNormalInput.tangentWS;
						float3 bitangentWS = vertexNormalInput.bitangentWS;
					#endif
					
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						// Vertex lighting
						output.vertexLights = VertexLighting(positionWS, normalWS);
					#endif
				#else
					#ifdef LIGHTMAP_ON
						output.lmap.xy = input.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
						output.lmap.zw = 0;
					#endif
					#ifdef DYNAMICLIGHTMAP_ON
						output.lmap.zw = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif

					float3 positionWS = mul(unity_ObjectToWorld, input.vertex).xyz;
					float4 positionCS = UnityWorldToClipPos(positionWS);
					output.pos = positionCS;
					
					half sign = half(input.tangent.w) * half(unity_WorldTransformParams.w);
					float3 normalWS = UnityObjectToWorldNormal(input.normal);
					#if defined(_NORMALMAP)
						float3 tangentWS = UnityObjectToWorldDir(input.tangent.xyz);
						float3 bitangentWS = cross(normalWS, tangentWS) * sign;
					#endif
					
					// This Unity macro expects the vertex input to be named 'v'
					#define v input
					UNITY_TRANSFER_LIGHTING(output, input.texcoord1.xy);
				#endif

				// world position
				output.worldPos = float4(positionWS.xyz, 0);

				// Compute fog factor
				#if defined(TCP2_HYBRID_URP)
					output.worldPos.w = ComputeFogFactor(positionCS.z);
				#else
					UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(output, positionCS);
				#endif

				// normal
				output.normal = normalWS;

				// tangent
				#if defined(_NORMALMAP) || (defined(TCP2_MOBILE) && (defined(TCP2_RIM_LIGHTING) || (defined(TCP2_REFLECTIONS) && defined(TCP2_REFLECTIONS_FRESNEL)))) // if mobile + rim or fresnel
					output.tangentWS = float4(0, 0, 0, 0);
				#endif
				#if defined(_NORMALMAP)
					output.tangentWS.xyz = tangentWS;
					output.bitangentWS.xyz = bitangentWS;
				#endif
				#if defined(TCP2_MOBILE) && (defined(TCP2_RIM_LIGHTING) || (defined(TCP2_REFLECTIONS) && defined(TCP2_REFLECTIONS_FRESNEL))) // if mobile + rim or fresnel
					// Calculate ndv in vertex shader
					#if defined(TCP2_HYBRID_URP)
						half3 viewDirWS = TCP2_SafeNormalize(GetCameraPositionWS() - positionWS);
					#else
						half3 viewDirWS = TCP2_SafeNormalize(_WorldSpaceCameraPos.xyz - positionWS);
					#endif
					output.tangentWS.w = 1 - max(0, dot(viewDirWS, normalWS));
				#endif

				#if defined(TCP2_MATCAP) && !defined(_NORMALMAP)
					// MatCap
					float3 worldNorm = normalize(unity_WorldToObject[0].xyz * input.normal.x + unity_WorldToObject[1].xyz * input.normal.y + unity_WorldToObject[2].xyz * input.normal.z);
					worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
					float4 screenPos = ComputeScreenPos(positionCS);
					float3 perspectiveOffset = (screenPos.xyz / screenPos.w) - 0.5;
					worldNorm.xy -= (perspectiveOffset.xy * perspectiveOffset.z) * 0.5;
					output.matcap.xy = worldNorm.xy * 0.5 + 0.5;
				#endif

				return output;
			}

 
			ENDHLSL
		}

		//--------------------------------------------------------------------------------------------------------------------------------

		// Outline : Enabled in the "Outline" version of the shader
		/*
		Pass
		{
			Name "Outline"
			Tags { "LightMode" = "Outline" }
			Cull Front

			HLSLPROGRAM
			#pragma target 3.0

			#pragma vertex vertex_outline
			#pragma fragment fragment_outline

			#pragma multi_compile_instancing
			#pragma multi_compile_fog

			// -------------------------------------
			// Material keywords
			//#pragma shader_feature _ALPHATEST_ON
			#pragma shader_feature _ _RECEIVE_SHADOWS_OFF

			// -------------------------------------
			// Universal Render Pipeline keywords
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

			// -------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma shader_feature_local _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW
			#pragma shader_feature_local _ TCP2_OUTLINE_CONST_SIZE TCP2_OUTLINE_MIN_SIZE
			#pragma shader_feature_local _ TCP2_OUTLINE_TEXTURED_VERTEX TCP2_OUTLINE_TEXTURED_FRAGMENT
			#pragma shader_feature_local _ TCP2_OUTLINE_LIGHTING_MAIN TCP2_OUTLINE_LIGHTING_ALL TCP2_OUTLINE_LIGHTING_INDIRECT
			#pragma shader_feature_local _ TCP2_SHADOW_TEXTURE

			// Force URP keyword to differentiate from built-in code
			#pragma multi_compile TCP2_HYBRID_URP

			ENDHLSL
		}
		*/

		//--------------------------------------------------------------------------------------------------------------------------------

		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On
			ZTest LEqual
			Cull [_Cull]

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment

			#pragma multi_compile_instancing

			#pragma multi_compile SHADOW_CASTER_PASS
			#pragma multi_compile TCP2_HYBRID_URP

			float3 _LightDirection;

			struct Attributes_Shadow
			{
				float4 positionOS   : POSITION;
				float3 normalOS     : NORMAL;
				float2 texcoord     : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings_Shadow
			{
				float2 uv           : TEXCOORD0;
				float4 positionCS   : SV_POSITION;
			};

			float4 GetShadowPositionHClip(Attributes_Shadow input)
			{
				float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
				float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

			#if UNITY_REVERSED_Z
				positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
			#else
				positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
			#endif

				return positionCS;
			}

			Varyings_Shadow ShadowPassVertex(Attributes_Shadow input)
			{
				Varyings_Shadow output = (Varyings_Shadow)0;
				UNITY_SETUP_INSTANCE_ID(input);

				output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
				output.positionCS = GetShadowPositionHClip(input);
				return output;
			}

			half4 ShadowPassFragment(Varyings_Shadow input) : SV_TARGET
			{
				half4 albedo = tex2D(_BaseMap, input.uv.xy).rgba;
				albedo.rgb *= _BaseColor.rgb;
				half alpha = albedo.a * _BaseColor.a;

				#if defined(_ALPHATEST_ON)
					clip(alpha - _Cutoff);
				#endif

				return 0;
			}

			ENDHLSL
		}

		//--------------------------------------------------------------------------------------------------------------------------------

		Pass
		{
			Name "DepthOnly"
			Tags { "LightMode" = "DepthOnly" }

			ZWrite On
			ColorMask 0
			Cull [_Cull]

			HLSLPROGRAM

			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0

			#pragma vertex DepthOnlyVertex
			#pragma fragment DepthOnlyFragment

			#pragma multi_compile_instancing

			#pragma shader_feature_local _ALPHATEST_ON

			#pragma multi_compile DEPTH_ONLY_PASS
			#pragma multi_compile TCP2_HYBRID_URP

			struct Attributes_Depth
			{
				float4 position     : POSITION;
				float2 texcoord     : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings_Depth
			{
				float2 uv           : TEXCOORD0;
				float4 positionCS   : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			Varyings_Depth DepthOnlyVertex(Attributes_Depth input)
			{
				Varyings_Depth output = (Varyings_Depth)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
				output.positionCS = TransformObjectToHClip(input.position.xyz);
				return output;
			}

			half4 DepthOnlyFragment(Varyings_Depth input) : SV_TARGET
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				half4 albedo = tex2D(_BaseMap, input.uv.xy).rgba;
				albedo.rgb *= _BaseColor.rgb;
				half alpha = albedo.a * _BaseColor.a;

				#if defined(_ALPHATEST_ON)
					clip(alpha - _Cutoff);
				#endif

				return 0;
			}

			ENDHLSL
		}

		// Depth prepass
		// UsePass "Universal Render Pipeline/Lit/DepthOnly"

	}

	//================================================================================================================================
	//
	// BUILT-IN RENDER PIPELINE
	//
	//================================================================================================================================

	SubShader
	{
		Tags
		{
			// "RenderPipeline" = "UniversalPipeline"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}

		Blend [_SrcBlend] [_DstBlend]
		ZWrite [_ZWrite]
		Cull [_Cull]

		HLSLINCLUDE
		#if !defined(TCP2_HYBRID_URP)

			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"
			#include "UnityStandardUtils.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			#include "TCP2 Hybrid Include.cginc"

		#endif
		ENDHLSL

		Pass
		{
			Name "Main"
			Tags { "LightMode"="ForwardBase" }

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard SRP library
			// All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 3.0

			#pragma vertex Vertex
			#pragma fragment Fragment

			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdbase noshadowmask nodynlightmap nolightmap

			// -------------------------------------
			// Material keywords
			#pragma shader_feature _ _RECEIVE_SHADOWS_OFF

			// -------------------------------------
			// Unity keywords
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON

			//--------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local TCP2_MOBILE
			#pragma shader_feature_local _ TCP2_RAMPTEXT TCP2_RAMP_CRISP TCP2_RAMP_BANDS TCP2_RAMP_BANDS_CRISP
			#pragma shader_feature_local TCP2_SHADOW_TEXTURE
			#pragma shader_feature_local TCP2_SPECULAR
			#pragma shader_feature_local _ TCP2_SPECULAR_STYLIZED TCP2_SPECULAR_CRISP
			#pragma shader_feature_local TCP2_RIM_LIGHTING
			#pragma shader_feature_local TCP2_RIM_LIGHTING_LIGHTMASK
			#pragma shader_feature_local TCP2_REFLECTIONS
			#pragma shader_feature_local TCP2_REFLECTIONS_FRESNEL
			#pragma shader_feature_local TCP2_MATCAP
			#pragma shader_feature_local TCP2_MATCAP_MASK
			#pragma shader_feature_local TCP2_OCCLUSION
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _ALPHATEST_ON
			#pragma shader_feature_local _EMISSION

			// This is actually using an existing keyword to separate fade/transparent behaviors
			#pragma shader_feature_local _ _ALPHAPREMULTIPLY_ON

			// Force URP keyword to differentiate from built-in code
			/// #pragma multi_compile TCP2_HYBRID_URP

			#define UNITY_INSTANCED_SH
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"

			//Shader does not support lightmap thus we always want to fallback to SH.
			#undef UNITY_SHOULD_SAMPLE_SH
			#define UNITY_SHOULD_SAMPLE_SH (!defined(UNITY_PASS_FORWARDADD) && !defined(UNITY_PASS_PREPASSBASE) && !defined(UNITY_PASS_SHADOWCASTER) && !defined(UNITY_PASS_META))
			#include "AutoLight.cginc"

			#pragma multi_compile UNITY_PASS_FORWARDBASE

			ENDHLSL
		}

		Pass
		{
			Name "Main"
			Tags { "LightMode"="ForwardAdd" }

			Blend [_SrcBlend] One
			Fog { Color (0,0,0,0) } // in additive pass fog should be black
			ZWrite Off
			ZTest LEqual

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard SRP library
			// All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 3.0

			#pragma vertex Vertex
			#pragma fragment Fragment

			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdadd

			// -------------------------------------
			// Material keywords
			#pragma shader_feature _ _RECEIVE_SHADOWS_OFF

			//--------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local TCP2_MOBILE
			#pragma shader_feature_local _ TCP2_RAMPTEXT TCP2_RAMP_CRISP TCP2_RAMP_BANDS TCP2_RAMP_BANDS_CRISP
			#pragma shader_feature_local TCP2_SHADOW_TEXTURE
			#pragma shader_feature_local TCP2_SPECULAR
			#pragma shader_feature_local _ TCP2_SPECULAR_STYLIZED TCP2_SPECULAR_CRISP
			#pragma shader_feature_local TCP2_RIM_LIGHTING
			#pragma shader_feature_local TCP2_RIM_LIGHTING_LIGHTMASK
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _ALPHATEST_ON
			#pragma shader_feature_local _EMISSION

			// This is actually using an existing keyword to separate fade/transparent behaviors
			#pragma shader_feature_local _ _ALPHAPREMULTIPLY_ON

			// Force URP keyword to differentiate from built-in code
			/// #pragma multi_compile TCP2_HYBRID_URP

			#define UNITY_INSTANCED_SH
			#include "UnityShaderVariables.cginc"
			#include "UnityShaderUtilities.cginc"
			#include "AutoLight.cginc"

			#pragma multi_compile UNITY_PASS_FORWARDADD

			ENDHLSL
		}

		// ShadowCaster & Depth Pass
		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			CGPROGRAM
			#pragma vertex vertex_shadow
			#pragma fragment fragment_shadow
			#pragma target 2.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"

			struct Varyings_Shadow
			{
				V2F_SHADOW_CASTER;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			Varyings_Shadow vertex_shadow (appdata_base v)
			{
				Varyings_Shadow o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 fragment_shadow (Varyings_Shadow i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}

		// Outline : Enabled in the "Outline" version of the shader
		/*
		Pass
		{
			Name "Outline"
			Tags { "LightMode"="ForwardBase" }
			Cull Front

			HLSLPROGRAM
			#pragma target 3.0

			#pragma vertex vertex_outline
			#pragma fragment fragment_outline

			#pragma multi_compile_instancing
			#pragma multi_compile_fog

			// -------------------------------------
			// Material keywords
			//#pragma shader_feature _ALPHATEST_ON
			#pragma shader_feature _ _RECEIVE_SHADOWS_OFF

			// -------------------------------------
			// Toony Colors Pro 2 keywords
			#pragma shader_feature_local _ TCP2_COLORS_AS_NORMALS TCP2_TANGENT_AS_NORMALS TCP2_UV1_AS_NORMALS TCP2_UV2_AS_NORMALS TCP2_UV3_AS_NORMALS TCP2_UV4_AS_NORMALS
			#pragma shader_feature_local _ TCP2_UV_NORMALS_FULL TCP2_UV_NORMALS_ZW
			#pragma shader_feature_local _ TCP2_OUTLINE_CONST_SIZE TCP2_OUTLINE_MIN_SIZE
			#pragma shader_feature_local _ TCP2_OUTLINE_TEXTURED_VERTEX TCP2_OUTLINE_TEXTURED_FRAGMENT
			#pragma shader_feature_local _ TCP2_OUTLINE_LIGHTING_MAIN TCP2_OUTLINE_LIGHTING_INDIRECT
			#pragma shader_feature_local _ TCP2_SHADOW_TEXTURE

			// Force URP keyword to differentiate from built-in code
			// #pragma multi_compile TCP2_HYBRID_URP

			ENDHLSL
		}
		*/
	}

	FallBack "Hidden/InternalErrorShader"
	CustomEditor "ToonyColorsPro.ShaderGenerator.MaterialInspector_Hybrid"
}