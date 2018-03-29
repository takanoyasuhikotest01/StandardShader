Shader "Animated/Built-in/Self-Illumin/Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_PanMT("Pan <Base (RGB)> (Speed(XY))", Vector) = (0,0,0,0)
	_RotMT("Rot <Base (RGB)> (Pivot(XY), Angle Speed(Z), Angle(W))", Vector) = (0.5,0.5,0,0)
	_Illum ("Illumin (A)", 2D) = "white" {}
	_PanIL("Pan <Illumin (A)> (Speed(XY))", Vector) = (0,0,0,0)
	_RotIL("Rot <Illumin (A)> (Pivot(XY), Angle Speed(Z), Angle(W))", Vector) = (0.5,0.5,0,0)
	_EmissionLM ("Emission (Lightmapper)", Float) = 0
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300
	
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 12
//   opengl - ALU: 7 to 67
//   d3d9 - ALU: 7 to 67
//   d3d11 - ALU: 7 to 49, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_Illum_ST]
"3.0-!!ARBvp1.0
# 32 ALU
PARAM c[20] = { { 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R3.w, R3.w;
MAD R0.y, R0.x, R0.x, -R0;
MOV result.texcoord[1].x, R0;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
MUL R1.xyz, R0.y, c[16];
ADD R2.xyz, R2, R3;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R2, R1;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
ADD result.texcoord[3].xyz, -R0, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 4 [_Object2World]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
Vector 18 [_Illum_ST]
"vs_3_0
; 32 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c16.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov o2.x, r0
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, r2, r1
mov o2.z, r2.w
mov o2.y, r3.w
add o4.xyz, -r0, c8
mad o1.zw, v2.xyxy, c18.xyxy, c18
mad o1.xy, v2, c17, c17.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 11 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 29 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedplkaijebnbgcfcemgphgjkcjmhofkpbiabaaaaaabmagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefciaaeaaaaeaaaabaa
caabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_7;
  viewDir_7 = tmpvar_6;
  lowp vec4 c_8;
  highp float nh_9;
  lowp float tmpvar_10;
  tmpvar_10 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_7))));
  nh_9 = tmpvar_11;
  mediump float arg1_12;
  arg1_12 = (_Shininess * 128.0);
  highp float tmpvar_13;
  tmpvar_13 = (pow (nh_9, arg1_12) * tmpvar_3.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_10) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_13)) * 2.0);
  c_8.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_4.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_13));
  c_8.w = tmpvar_15;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_7;
  viewDir_7 = tmpvar_6;
  lowp vec4 c_8;
  highp float nh_9;
  lowp float tmpvar_10;
  tmpvar_10 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_7))));
  nh_9 = tmpvar_11;
  mediump float arg1_12;
  arg1_12 = (_Shininess * 128.0);
  highp float tmpvar_13;
  tmpvar_13 = (pow (nh_9, arg1_12) * tmpvar_3.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_10) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_13)) * 2.0);
  c_8.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_4.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_13));
  c_8.w = tmpvar_15;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 443
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 428
v2f_surf vert_surf( in appdata_full v ) {
    #line 430
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 434
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 438
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 443
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 443
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 447
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 451
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 455
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    #line 459
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
Vector 11 [_Illum_ST]
"3.0-!!ARBvp1.0
# 7 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
Vector 10 [_Illum_ST]
"vs_3_0
; 7 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 192 used size, 12 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_Illum_ST] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 8 instructions, 1 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneajcoeaaogmdkbbeidnmbjjkjgbihaeabaaaaaaaiadaaaaadaaaaaa
cmaaaaaapeaaaaaageabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheogiaaaaaaadaaaaaa
aiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcjmabaaaaeaaaabaaghaaaaaafjaaaaaeegiocaaaaaaaaaaa
amaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaa
ogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaa
ajaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, tmpvar_2) * _Color);
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_4.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  c_1.xyz = (tmpvar_3.xyz * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz));
  c_1.w = tmpvar_3.w;
  c_1.xyz = (c_1.xyz + (tmpvar_3.xyz * texture2D (_Illum, tmpvar_4).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, tmpvar_2) * _Color);
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_4.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c_1.xyz = (tmpvar_3.xyz * ((8.0 * tmpvar_5.w) * tmpvar_5.xyz));
  c_1.w = tmpvar_3.w;
  c_1.xyz = (c_1.xyz + (tmpvar_3.xyz * texture2D (_Illum, tmpvar_4).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 424
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 438
uniform sampler2D unity_Lightmap;
#line 427
v2f_surf vert_surf( in appdata_full v ) {
    #line 429
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 433
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 424
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 438
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 439
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 442
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 446
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 450
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    #line 454
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    c.xyz += o.Emission;
    #line 458
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_Illum_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[13];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[14].w, -vertex.position;
DP3 result.texcoord[2].y, R0, R1;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
Vector 16 [_Illum_ST]
"vs_3_0
; 21 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c12
mov r0.w, c17.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c13.w, -v0
dp3 o3.y, r0, r1
dp3 o3.z, v2, r0
dp3 o3.x, r0, v1
mad o1.zw, v3.xyxy, c16.xyxy, c16
mad o1.xy, v3, c15, c15.zwzw
mad o2.xy, v4, c14, c14.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 192 used size, 12 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 19 instructions, 2 temp regs, 0 temp arrays:
// ALU 18 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfgonmmemmohhodnebbagodcohdhkphcbabaaaaaanaaeaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
emadaaaaeaaaabaandaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaakaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaa
alaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaa
ajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaahhcaabaaaaaaaaaaajgbebaaa
abaaaaaacgbjbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaajgbebaaaacaaaaaa
cgbjbaaaabaaaaaaegacbaiaebaaaaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgbpbaaaabaaaaaadiaaaaajhcaabaaaabaaaaaafgifcaaa
abaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaabaaaaaa
egiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaa
dcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaa
aeaaaaaaegacbaaaabaaaaaaaaaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaa
egiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaa
adaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahbccabaaaadaaaaaa
egbcbaaaabaaaaaaegacbaaaabaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  c_1.w = 0.0;
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_7;
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_6;
  mediump vec3 specColor_9;
  highp float nh_10;
  mediump vec3 scalePerBasisVector_11;
  mediump vec3 lm_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_12 = tmpvar_13;
  lowp vec3 tmpvar_14;
  tmpvar_14 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  scalePerBasisVector_11 = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, normalize((normalize((((scalePerBasisVector_11.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_11.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_11.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_8)).z);
  nh_10 = tmpvar_15;
  highp float tmpvar_16;
  mediump float arg1_17;
  arg1_17 = (_Shininess * 128.0);
  tmpvar_16 = pow (nh_10, arg1_17);
  highp vec3 tmpvar_18;
  tmpvar_18 = (((lm_12 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_16);
  specColor_9 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.xyz = lm_12;
  tmpvar_19.w = tmpvar_16;
  tmpvar_7 = tmpvar_19;
  c_1.xyz = specColor_9;
  mediump vec3 tmpvar_20;
  tmpvar_20 = (c_1.xyz + (tmpvar_4.xyz * tmpvar_7.xyz));
  c_1.xyz = tmpvar_20;
  c_1.w = tmpvar_4.w;
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  c_1.w = 0.0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_LightmapInd, xlv_TEXCOORD1);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_9;
  mediump vec3 viewDir_10;
  viewDir_10 = tmpvar_8;
  mediump vec3 specColor_11;
  highp float nh_12;
  mediump vec3 scalePerBasisVector_13;
  mediump vec3 lm_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  lm_14 = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  scalePerBasisVector_13 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, normalize((normalize((((scalePerBasisVector_13.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_13.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_13.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_10)).z);
  nh_12 = tmpvar_17;
  highp float tmpvar_18;
  mediump float arg1_19;
  arg1_19 = (_Shininess * 128.0);
  tmpvar_18 = pow (nh_12, arg1_19);
  highp vec3 tmpvar_20;
  tmpvar_20 = (((lm_14 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_18);
  specColor_11 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.xyz = lm_14;
  tmpvar_21.w = tmpvar_18;
  tmpvar_9 = tmpvar_21;
  c_1.xyz = specColor_11;
  mediump vec3 tmpvar_22;
  tmpvar_22 = (c_1.xyz + (tmpvar_4.xyz * tmpvar_9.xyz));
  c_1.xyz = tmpvar_22;
  c_1.w = tmpvar_4.w;
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 425
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 443
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 428
v2f_surf vert_surf( in appdata_full v ) {
    #line 430
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 434
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 438
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 425
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 443
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 379
mediump vec4 LightingBlinnPhong_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 viewDir, in bool surfFuncWritesNormal, out mediump vec3 specColor ) {
    #line 381
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    mediump vec3 lightDir = normalize((((scalePerBasisVector.x * xll_matrixindex_mf3x3_i (unity_DirBasis, 0)) + (scalePerBasisVector.y * xll_matrixindex_mf3x3_i (unity_DirBasis, 1))) + (scalePerBasisVector.z * xll_matrixindex_mf3x3_i (unity_DirBasis, 2))));
    #line 385
    mediump vec3 h = normalize((lightDir + viewDir));
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = pow( nh, (s.Specular * 128.0));
    specColor = (((lm * _SpecColor.xyz) * s.Gloss) * spec);
    #line 389
    return vec4( lm, spec);
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 447
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 451
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 455
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    #line 459
    o.Normal = vec3( 0.0, 0.0, 1.0);
    mediump vec3 specColor;
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    #line 463
    mediump vec3 lm = LightingBlinnPhong_DirLightmap( o, lmtex, lmIndTex, normalize(IN.viewDir), false, specColor).xyz;
    c.xyz += specColor;
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    #line 467
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Matrix 5 [_Object2World]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
Vector 20 [_Illum_ST]
"3.0-!!ARBvp1.0
# 37 ALU
PARAM c[21] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[18].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[13];
DP4 R2.y, R1.wxyz, c[12];
DP4 R2.x, R1.wxyz, c[11];
DP4 R1.z, R0, c[16];
DP4 R1.y, R0, c[15];
DP4 R1.x, R0, c[14];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[17];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MOV result.position, R0;
MUL R1.y, R1, c[10].x;
MOV result.texcoord[4].zw, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R1.w;
ADD result.texcoord[3].xyz, -R0, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
END
# 37 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Matrix 4 [_Object2World]
Vector 18 [unity_Scale]
Vector 19 [_MainTex_ST]
Vector 20 [_Illum_ST]
"vs_3_0
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c21, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c18.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c21.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c13
dp4 r2.y, r1.wxyz, c12
dp4 r2.x, r1.wxyz, c11
dp4 r1.z, r0, c16
dp4 r1.y, r0, c15
dp4 r1.x, r0, c14
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c17
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c21.y
mov o0, r0
mul r1.y, r1, c9.x
mov o5.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add o3.xyz, r3, r2
mad o5.xy, r1.z, c10.zwzw, r1
mov o2.z, r2.w
mov o2.y, r3.w
mov o2.x, r1.w
add o4.xyz, -r0, c8
mad o1.zw, v2.xyxy, c20.xyxy, c20
mad o1.xy, v2, c19, c19.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 12 vars
Vector 208 [_MainTex_ST] 4
Vector 224 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 34 instructions, 5 temp regs, 0 temp arrays:
// ALU 29 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedegolocfdjpbnkocdnnmfjoimnehpjbneabaaaaaammagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcbiafaaaaeaaaabaaegabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaa
ogikcaaaaaaaaaaaanaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaaoaaaaaakgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakbcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
bkaabaiaebaaaaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaa
cmaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaabaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
abaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaa
abaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
afaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float tmpvar_6;
  mediump float lightShadowDataX_7;
  highp float dist_8;
  lowp float tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_8 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = _LightShadowData.x;
  lightShadowDataX_7 = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = max (float((dist_8 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_7);
  tmpvar_6 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_13;
  viewDir_13 = tmpvar_12;
  lowp vec4 c_14;
  highp float nh_15;
  lowp float tmpvar_16;
  tmpvar_16 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_13))));
  nh_15 = tmpvar_17;
  mediump float arg1_18;
  arg1_18 = (_Shininess * 128.0);
  highp float tmpvar_19;
  tmpvar_19 = (pow (nh_15, arg1_18) * tmpvar_3.w);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_16) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_19)) * (tmpvar_6 * 2.0));
  c_14.xyz = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = (tmpvar_4.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_19) * tmpvar_6));
  c_14.w = tmpvar_21;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_4 = shlight_1;
  highp vec4 o_24;
  highp vec4 tmpvar_25;
  tmpvar_25 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_25.x;
  tmpvar_26.y = (tmpvar_25.y * _ProjectionParams.x);
  o_24.xy = (tmpvar_26 + tmpvar_25.w);
  o_24.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_24;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  lowp vec4 c_9;
  highp float nh_10;
  lowp float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_8))));
  nh_10 = tmpvar_12;
  mediump float arg1_13;
  arg1_13 = (_Shininess * 128.0);
  highp float tmpvar_14;
  tmpvar_14 = (pow (nh_10, arg1_13) * tmpvar_3.w);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_11) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_14)) * (tmpvar_6.x * 2.0));
  c_9.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (tmpvar_4.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_14) * tmpvar_6.x));
  c_9.w = tmpvar_16;
  c_1.w = c_9.w;
  c_1.xyz = (c_9.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 443
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 447
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 451
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 455
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 459
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 463
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 467
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 471
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_Illum_ST]
"3.0-!!ARBvp1.0
# 12 ALU
PARAM c[13] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 12 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_Illum_ST]
"vs_3_0
; 12 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c13, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c13.x
mul r1.y, r1, c8.x
mad o3.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o3.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.xy, v3, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 13 vars
Vector 208 [unity_LightmapST] 4
Vector 224 [_MainTex_ST] 4
Vector 240 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 13 instructions, 2 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedjejjnpbllnoamhoeemeogkdfhbajhfbgabaaaaaamiadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
eeacaaaaeaaaabaajbaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
dccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaaoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaa
dcaaaaaldccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaanaaaaaa
ogikcaaaaaaaaaaaanaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, tmpvar_2) * _Color);
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_4.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float tmpvar_5;
  mediump float lightShadowDataX_6;
  highp float dist_7;
  lowp float tmpvar_8;
  tmpvar_8 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x;
  dist_7 = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = _LightShadowData.x;
  lightShadowDataX_6 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = max (float((dist_7 > (xlv_TEXCOORD2.z / xlv_TEXCOORD2.w))), lightShadowDataX_6);
  tmpvar_5 = tmpvar_10;
  c_1.xyz = (tmpvar_3.xyz * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((tmpvar_5 * 2.0))));
  c_1.w = tmpvar_3.w;
  c_1.xyz = (c_1.xyz + (tmpvar_3.xyz * texture2D (_Illum, tmpvar_4).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_3;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, tmpvar_2) * _Color);
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_4.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  c_1.xyz = (tmpvar_3.xyz * max (min (tmpvar_7, ((tmpvar_5.x * 2.0) * tmpvar_6.xyz)), (tmpvar_7 * tmpvar_5.x)));
  c_1.w = tmpvar_3.w;
  c_1.xyz = (c_1.xyz + (tmpvar_3.xyz * texture2D (_Illum, tmpvar_4).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
#line 436
v2f_surf vert_surf( in appdata_full v ) {
    #line 438
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 442
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 446
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 451
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 455
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 459
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 463
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    #line 467
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Matrix 9 [_World2Object]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_Illum_ST]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[19] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[13];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[15].w, -vertex.position;
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[14].x;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[16], c[16].zwzw;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Matrix 8 [_World2Object]
Vector 15 [unity_Scale]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_Illum_ST]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c19, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
mov r1.xyz, c12
mov r1.w, c19.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c15.w, -v0
dp3 o3.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c19.y
mul r1.y, r1, c13.x
dp3 o3.z, v2, r2
dp3 o3.x, r2, v1
mad o4.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o4.zw, r0
mad o1.zw, v3.xyxy, c18.xyxy, c18
mad o1.xy, v3, c17, c17.zwzw
mad o2.xy, v4, c16, c16.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 13 vars
Vector 208 [unity_LightmapST] 4
Vector 224 [_MainTex_ST] 4
Vector 240 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 24 instructions, 3 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedekfmjpjkfmppfpmnabneocccmheebcboabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacadaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaa
aaaaaaaaanaaaaaadiaaaaahhcaabaaaabaaaaaajgbebaaaabaaaaaacgbjbaaa
acaaaaaadcaaaaakhcaabaaaabaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaa
egacbaiaebaaaaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgbpbaaaabaaaaaadiaaaaajhcaabaaaacaaaaaafgifcaaaabaaaaaaaeaaaaaa
egiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaacaaaaaaegiccaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaacaaaaaadcaaaaalhcaabaaa
acaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaa
acaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaegiccaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaacaaaaaaegacbaaaacaaaaaapgipcaaaacaaaaaa
beaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahcccabaaaadaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaabaaaaaahbccabaaaadaaaaaaegbcbaaaabaaaaaa
egacbaaaacaaaaaabaaaaaaheccabaaaadaaaaaaegbcbaaaacaaaaaaegacbaaa
acaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaa
afaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadp
aaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaaaaaaaaaa
aaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float tmpvar_6;
  mediump float lightShadowDataX_7;
  highp float dist_8;
  lowp float tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_8 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = _LightShadowData.x;
  lightShadowDataX_7 = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = max (float((dist_8 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_7);
  tmpvar_6 = tmpvar_11;
  c_1.w = 0.0;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_13;
  mediump vec3 viewDir_14;
  viewDir_14 = tmpvar_12;
  mediump vec3 specColor_15;
  highp float nh_16;
  mediump vec3 scalePerBasisVector_17;
  mediump vec3 lm_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_18 = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  scalePerBasisVector_17 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, normalize((normalize((((scalePerBasisVector_17.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_17.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_17.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_14)).z);
  nh_16 = tmpvar_21;
  highp float tmpvar_22;
  mediump float arg1_23;
  arg1_23 = (_Shininess * 128.0);
  tmpvar_22 = pow (nh_16, arg1_23);
  highp vec3 tmpvar_24;
  tmpvar_24 = (((lm_18 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_22);
  specColor_15 = tmpvar_24;
  highp vec4 tmpvar_25;
  tmpvar_25.xyz = lm_18;
  tmpvar_25.w = tmpvar_22;
  tmpvar_13 = tmpvar_25;
  c_1.xyz = specColor_15;
  lowp vec3 tmpvar_26;
  tmpvar_26 = vec3((tmpvar_6 * 2.0));
  mediump vec3 tmpvar_27;
  tmpvar_27 = (c_1.xyz + (tmpvar_4.xyz * min (tmpvar_13.xyz, tmpvar_26)));
  c_1.xyz = tmpvar_27;
  c_1.w = tmpvar_4.w;
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  highp vec4 o_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_10.x;
  tmpvar_11.y = (tmpvar_10.y * _ProjectionParams.x);
  o_9.xy = (tmpvar_11 + tmpvar_10.w);
  o_9.zw = tmpvar_4.zw;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = o_9;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  c_1.w = 0.0;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_LightmapInd, xlv_TEXCOORD1);
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_10;
  mediump vec3 viewDir_11;
  viewDir_11 = tmpvar_9;
  mediump vec3 specColor_12;
  highp float nh_13;
  mediump vec3 scalePerBasisVector_14;
  mediump vec3 lm_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  lm_15 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  scalePerBasisVector_14 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, normalize((normalize((((scalePerBasisVector_14.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_14.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_14.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_11)).z);
  nh_13 = tmpvar_18;
  highp float tmpvar_19;
  mediump float arg1_20;
  arg1_20 = (_Shininess * 128.0);
  tmpvar_19 = pow (nh_13, arg1_20);
  highp vec3 tmpvar_21;
  tmpvar_21 = (((lm_15 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_19);
  specColor_12 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.xyz = lm_15;
  tmpvar_22.w = tmpvar_19;
  tmpvar_10 = tmpvar_22;
  c_1.xyz = specColor_12;
  lowp vec3 arg1_23;
  arg1_23 = ((tmpvar_6.x * 2.0) * tmpvar_7.xyz);
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c_1.xyz + (tmpvar_4.xyz * max (min (tmpvar_10.xyz, arg1_23), (tmpvar_10.xyz * tmpvar_6.x))));
  c_1.xyz = tmpvar_24;
  c_1.w = tmpvar_4.w;
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 455
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 443
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 447
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 451
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 455
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 379
mediump vec4 LightingBlinnPhong_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 viewDir, in bool surfFuncWritesNormal, out mediump vec3 specColor ) {
    #line 381
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    mediump vec3 lightDir = normalize((((scalePerBasisVector.x * xll_matrixindex_mf3x3_i (unity_DirBasis, 0)) + (scalePerBasisVector.y * xll_matrixindex_mf3x3_i (unity_DirBasis, 1))) + (scalePerBasisVector.z * xll_matrixindex_mf3x3_i (unity_DirBasis, 2))));
    #line 385
    mediump vec3 h = normalize((lightDir + viewDir));
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = pow( nh, (s.Specular * 128.0));
    specColor = (((lm * _SpecColor.xyz) * s.Gloss) * spec);
    #line 389
    return vec4( lm, spec);
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 459
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 463
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 467
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    o.Normal = vec3( 0.0, 0.0, 1.0);
    mediump vec3 specColor;
    #line 471
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingBlinnPhong_DirLightmap( o, lmtex, lmIndTex, normalize(IN.viewDir), false, specColor).xyz;
    c.xyz += specColor;
    #line 475
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 5 [_Object2World]
Vector 25 [unity_Scale]
Vector 26 [_MainTex_ST]
Vector 27 [_Illum_ST]
"3.0-!!ARBvp1.0
# 61 ALU
PARAM c[28] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..27] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[11];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[10];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[12];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[13];
ADD R1, R1, c[0].x;
MOV result.texcoord[1].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[20];
DP4 R2.y, R5, c[19];
DP4 R2.x, R5, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[23];
DP4 R5.z, R0, c[22];
DP4 R5.y, R0, c[21];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R5.yzww;
ADD R0.xyz, R2, R0;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[2].xyz, R0, R1;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
ADD result.texcoord[3].xyz, -R3.wxyw, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[27].xyxy, c[27];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 61 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 4 [_Object2World]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
Vector 26 [_Illum_ST]
"vs_3_0
; 61 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c27, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c24.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c10
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c9
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c27.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c11
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c12
add r1, r1, c27.x
mov o2.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c19
dp4 r2.y, r5, c18
dp4 r2.x, r5, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c27.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c22
dp4 r5.z, r0, c21
dp4 r5.y, r0, c20
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add o3.xyz, r0, r1
mov o2.y, r4.z
mov o2.x, r5
add o4.xyz, -r3.wxyw, c8
mad o1.zw, v2.xyxy, c26.xyxy, c26
mad o1.xy, v2, c25, c25.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 11 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 49 instructions, 6 temp regs, 0 temp arrays:
// ALU 46 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedldgbmnmiffoldncncclcbgmccmmiplnoabaaaaaaneaiaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcdiahaaaaeaaaabaa
moabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacagaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaalmccabaaaabaaaaaa
agbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaaaaaaaaaaakaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaa
aaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaa
abaaaaaaegiocaaaacaaaaaacgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaa
abaaaaaaegiocaaaacaaaaaachaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaa
abaaaaaaegiocaaaacaaaaaaciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaa
acaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaa
egiocaaaacaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaa
egiocaaaacaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaa
egiocaaaacaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaaaaaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egiccaaaacaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
hcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaajpcaabaaaadaaaaaa
fgafbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaa
aeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaahpcaabaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaaafaaaaaaagaabaia
ebaaaaaaacaaaaaaegiocaaaacaaaaaaacaaaaaadcaaaaajpcaabaaaaeaaaaaa
egaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaa
adaaaaaaegaobaaaafaaaaaaegaobaaaafaaaaaaegaobaaaadaaaaaaaaaaaaaj
pcaabaaaafaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaaacaaaaaaaeaaaaaa
aaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaacaaaaaaegiccaaaabaaaaaa
aeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaafaaaaaakgakbaaaaaaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaaafaaaaaaegaobaaa
afaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaaacaaaaaa
dcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaaacaaaaaaafaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaacaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaakpcaabaaa
aaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
diaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaak
hcaabaaaacaaaaaaegiccaaaacaaaaaaagaaaaaaagaabaaaaaaaaaaaegacbaaa
acaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
ajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaaadaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_4 = tmpvar_29;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_7;
  viewDir_7 = tmpvar_6;
  lowp vec4 c_8;
  highp float nh_9;
  lowp float tmpvar_10;
  tmpvar_10 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_7))));
  nh_9 = tmpvar_11;
  mediump float arg1_12;
  arg1_12 = (_Shininess * 128.0);
  highp float tmpvar_13;
  tmpvar_13 = (pow (nh_9, arg1_12) * tmpvar_3.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_10) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_13)) * 2.0);
  c_8.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_4.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_13));
  c_8.w = tmpvar_15;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_4 = tmpvar_29;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_7;
  viewDir_7 = tmpvar_6;
  lowp vec4 c_8;
  highp float nh_9;
  lowp float tmpvar_10;
  tmpvar_10 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_7))));
  nh_9 = tmpvar_11;
  mediump float arg1_12;
  arg1_12 = (_Shininess * 128.0);
  highp float tmpvar_13;
  tmpvar_13 = (pow (nh_9, arg1_12) * tmpvar_3.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_10) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_13)) * 2.0);
  c_8.xyz = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = (tmpvar_4.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_13));
  c_8.w = tmpvar_15;
  c_1.w = c_8.w;
  c_1.xyz = (c_8.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 428
v2f_surf vert_surf( in appdata_full v ) {
    #line 430
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 434
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 438
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 443
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 447
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 451
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 455
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 459
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 463
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 5 [_Object2World]
Vector 26 [unity_Scale]
Vector 27 [_MainTex_ST]
Vector 28 [_Illum_ST]
"3.0-!!ARBvp1.0
# 67 ALU
PARAM c[29] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..28] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[26].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[12];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[11];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[13];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[14];
ADD R1, R1, c[0].x;
MOV result.texcoord[1].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[21];
DP4 R2.y, R5, c[20];
DP4 R2.x, R5, c[19];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[16];
MAD R1.xyz, R0.x, c[15], R1;
MAD R0.xyz, R0.z, c[17], R1;
MAD R1.xyz, R0.w, c[18], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[24];
DP4 R5.z, R0, c[23];
DP4 R5.y, R0, c[22];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[25];
ADD R2.xyz, R2, R5.yzww;
ADD R5.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[2].xyz, R5.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[10].x;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[4].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
ADD result.texcoord[3].xyz, -R3.wxyw, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[28].xyxy, c[28];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[27], c[27].zwzw;
END
# 67 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 4 [_Object2World]
Vector 26 [unity_Scale]
Vector 27 [_MainTex_ST]
Vector 28 [_Illum_ST]
"vs_3_0
; 67 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c29, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c26.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c12
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c11
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c29.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c13
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c14
add r1, r1, c29.x
mov o2.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c21
dp4 r2.y, r5, c20
dp4 r2.x, r5, c19
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c29.y
mul r0, r0, r1
mul r1.xyz, r0.y, c16
mad r1.xyz, r0.x, c15, r1
mad r0.xyz, r0.z, c17, r1
mad r1.xyz, r0.w, c18, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c24
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c25
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c29.z
add o3.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c9.x
mov r3.x, r4.w
mov r3.y, r4
mad o5.xy, r2.z, c10.zwzw, r1
mov o0, r0
mov o5.zw, r0
mov o2.y, r4.z
mov o2.x, r5
add o4.xyz, -r3.wxyw, c8
mad o1.zw, v2.xyxy, c28.xyxy, c28
mad o1.xy, v2, c27, c27.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 12 vars
Vector 208 [_MainTex_ST] 4
Vector 224 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 54 instructions, 7 temp regs, 0 temp arrays:
// ALU 49 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedbejoiiiemlgplgahcomilphdiaknealeabaaaaaaieajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcnaahaaaaeaaaabaapeabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaa
ogikcaaaaaaaaaaaanaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaaoaaaaaakgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaafhccabaaaacaaaaaaegacbaaaabaaaaaadgaaaaaf
icaabaaaabaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaa
acaaaaaacgaaaaaaegaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaa
acaaaaaachaaaaaaegaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaa
acaaaaaaciaaaaaaegaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaa
abaaaaaaegakbaaaabaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaa
cjaaaaaaegaobaaaadaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaa
ckaaaaaaegaobaaaadaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaa
claaaaaaegaobaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaaeaaaaaadiaaaaahicaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaa
abaaaaaadcaaaaakicaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
cmaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaadaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaa
adaaaaaaegiocaaaacaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaa
abaaaaaaegaobaaaaeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaa
egaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaa
egiocaaaacaaaaaaacaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaa
agaabaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaaaaaaaaajpcaabaaaagaaaaaa
kgakbaiaebaaaaaaadaaaaaaegiocaaaacaaaaaaaeaaaaaaaaaaaaajhccabaaa
aeaaaaaaegacbaiaebaaaaaaadaaaaaaegiccaaaabaaaaaaaeaaaaaadcaaaaaj
pcaabaaaabaaaaaaegaobaaaagaaaaaakgakbaaaabaaaaaaegaobaaaafaaaaaa
dcaaaaajpcaabaaaadaaaaaaegaobaaaagaaaaaaegaobaaaagaaaaaaegaobaaa
aeaaaaaaeeaaaaafpcaabaaaaeaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaa
adaaaaaaegaobaaaadaaaaaaegiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaaiadpaaaaiadpegaobaaaadaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaaegaobaaaaeaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaaadaaaaaa
fgafbaaaabaaaaaaegiccaaaacaaaaaaahaaaaaadcaaaaakhcaabaaaadaaaaaa
egiccaaaacaaaaaaagaaaaaaagaabaaaabaaaaaaegacbaaaadaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaacaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaa
adaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaaaaaaaaahhccabaaaadaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_4 = tmpvar_29;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float tmpvar_6;
  mediump float lightShadowDataX_7;
  highp float dist_8;
  lowp float tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_8 = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = _LightShadowData.x;
  lightShadowDataX_7 = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = max (float((dist_8 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_7);
  tmpvar_6 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_13;
  viewDir_13 = tmpvar_12;
  lowp vec4 c_14;
  highp float nh_15;
  lowp float tmpvar_16;
  tmpvar_16 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_17;
  tmpvar_17 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_13))));
  nh_15 = tmpvar_17;
  mediump float arg1_18;
  arg1_18 = (_Shininess * 128.0);
  highp float tmpvar_19;
  tmpvar_19 = (pow (nh_15, arg1_18) * tmpvar_3.w);
  highp vec3 tmpvar_20;
  tmpvar_20 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_16) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_19)) * (tmpvar_6 * 2.0));
  c_14.xyz = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = (tmpvar_4.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_19) * tmpvar_6));
  c_14.w = tmpvar_21;
  c_1.w = c_14.w;
  c_1.xyz = (c_14.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_4 = shlight_1;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosX0 - tmpvar_24.x);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosY0 - tmpvar_24.y);
  highp vec4 tmpvar_27;
  tmpvar_27 = (unity_4LightPosZ0 - tmpvar_24.z);
  highp vec4 tmpvar_28;
  tmpvar_28 = (((tmpvar_25 * tmpvar_25) + (tmpvar_26 * tmpvar_26)) + (tmpvar_27 * tmpvar_27));
  highp vec4 tmpvar_29;
  tmpvar_29 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_25 * tmpvar_7.x) + (tmpvar_26 * tmpvar_7.y)) + (tmpvar_27 * tmpvar_7.z)) * inversesqrt(tmpvar_28))) * (1.0/((1.0 + (tmpvar_28 * unity_4LightAtten0)))));
  highp vec3 tmpvar_30;
  tmpvar_30 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_29.x) + (unity_LightColor[1].xyz * tmpvar_29.y)) + (unity_LightColor[2].xyz * tmpvar_29.z)) + (unity_LightColor[3].xyz * tmpvar_29.w)));
  tmpvar_4 = tmpvar_30;
  highp vec4 o_31;
  highp vec4 tmpvar_32;
  tmpvar_32 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_33;
  tmpvar_33.x = tmpvar_32.x;
  tmpvar_33.y = (tmpvar_32.y * _ProjectionParams.x);
  o_31.xy = (tmpvar_33 + tmpvar_32.w);
  o_31.zw = tmpvar_5.zw;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_31;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_8;
  viewDir_8 = tmpvar_7;
  lowp vec4 c_9;
  highp float nh_10;
  lowp float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_8))));
  nh_10 = tmpvar_12;
  mediump float arg1_13;
  arg1_13 = (_Shininess * 128.0);
  highp float tmpvar_14;
  tmpvar_14 = (pow (nh_10, arg1_13) * tmpvar_3.w);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_11) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_14)) * (tmpvar_6.x * 2.0));
  c_9.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (tmpvar_4.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_14) * tmpvar_6.x));
  c_9.w = tmpvar_16;
  c_1.w = c_9.w;
  c_1.xyz = (c_9.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 455
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 443
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 447
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 451
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 455
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 459
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 463
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 467
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    #line 471
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float shadow_6;
  lowp float tmpvar_7;
  tmpvar_7 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_8;
  tmpvar_8 = (_LightShadowData.x + (tmpvar_7 * (1.0 - _LightShadowData.x)));
  shadow_6 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_10;
  viewDir_10 = tmpvar_9;
  lowp vec4 c_11;
  highp float nh_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_10))));
  nh_12 = tmpvar_14;
  mediump float arg1_15;
  arg1_15 = (_Shininess * 128.0);
  highp float tmpvar_16;
  tmpvar_16 = (pow (nh_12, arg1_15) * tmpvar_3.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_13) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_16)) * (shadow_6 * 2.0));
  c_11.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (tmpvar_4.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_16) * shadow_6));
  c_11.w = tmpvar_18;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 443
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 447
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 451
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 455
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 459
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 463
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 467
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 471
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, tmpvar_2) * _Color);
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_4.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float shadow_5;
  lowp float tmpvar_6;
  tmpvar_6 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD2.xyz);
  highp float tmpvar_7;
  tmpvar_7 = (_LightShadowData.x + (tmpvar_6 * (1.0 - _LightShadowData.x)));
  shadow_5 = tmpvar_7;
  c_1.xyz = (tmpvar_3.xyz * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((shadow_5 * 2.0))));
  c_1.w = tmpvar_3.w;
  c_1.xyz = (c_1.xyz + (tmpvar_3.xyz * texture2D (_Illum, tmpvar_4).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
#line 436
v2f_surf vert_surf( in appdata_full v ) {
    #line 438
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 442
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 446
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 433
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 449
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 451
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 455
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 459
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 463
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    #line 467
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float shadow_6;
  lowp float tmpvar_7;
  tmpvar_7 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_8;
  tmpvar_8 = (_LightShadowData.x + (tmpvar_7 * (1.0 - _LightShadowData.x)));
  shadow_6 = tmpvar_8;
  c_1.w = 0.0;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_10;
  mediump vec3 viewDir_11;
  viewDir_11 = tmpvar_9;
  mediump vec3 specColor_12;
  highp float nh_13;
  mediump vec3 scalePerBasisVector_14;
  mediump vec3 lm_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_15 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  scalePerBasisVector_14 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, normalize((normalize((((scalePerBasisVector_14.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_14.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_14.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_11)).z);
  nh_13 = tmpvar_18;
  highp float tmpvar_19;
  mediump float arg1_20;
  arg1_20 = (_Shininess * 128.0);
  tmpvar_19 = pow (nh_13, arg1_20);
  highp vec3 tmpvar_21;
  tmpvar_21 = (((lm_15 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_19);
  specColor_12 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.xyz = lm_15;
  tmpvar_22.w = tmpvar_19;
  tmpvar_10 = tmpvar_22;
  c_1.xyz = specColor_12;
  lowp vec3 tmpvar_23;
  tmpvar_23 = vec3((shadow_6 * 2.0));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (c_1.xyz + (tmpvar_4.xyz * min (tmpvar_10.xyz, tmpvar_23)));
  c_1.xyz = tmpvar_24;
  c_1.w = tmpvar_4.w;
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 455
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 443
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 447
    highp vec3 viewDirForLight = (rotation * ObjSpaceViewDir( v.vertex));
    o.viewDir = viewDirForLight;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 451
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec2 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec2(xl_retval.lmap);
    xlv_TEXCOORD2 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec2 lmap;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 434
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 455
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 379
mediump vec4 LightingBlinnPhong_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 viewDir, in bool surfFuncWritesNormal, out mediump vec3 specColor ) {
    #line 381
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    mediump vec3 lightDir = normalize((((scalePerBasisVector.x * xll_matrixindex_mf3x3_i (unity_DirBasis, 0)) + (scalePerBasisVector.y * xll_matrixindex_mf3x3_i (unity_DirBasis, 1))) + (scalePerBasisVector.z * xll_matrixindex_mf3x3_i (unity_DirBasis, 2))));
    #line 385
    mediump vec3 h = normalize((lightDir + viewDir));
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = pow( nh, (s.Specular * 128.0));
    specColor = (((lm * _SpecColor.xyz) * s.Gloss) * spec);
    #line 389
    return vec4( lm, spec);
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 459
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 463
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 467
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    o.Normal = vec3( 0.0, 0.0, 1.0);
    mediump vec3 specColor;
    #line 471
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingBlinnPhong_DirLightmap( o, lmtex, lmIndTex, normalize(IN.viewDir), false, specColor).xyz;
    c.xyz += specColor;
    #line 475
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec2 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.lmap = vec2(xlv_TEXCOORD1);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = tmpvar_6;
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  highp float vC_10;
  mediump vec3 x3_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_10 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_10);
  x3_11 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_11);
  shlight_1 = tmpvar_8;
  tmpvar_4 = shlight_1;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_6.x) + (tmpvar_25 * tmpvar_6.y)) + (tmpvar_26 * tmpvar_6.z)) * inversesqrt(tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_4 = tmpvar_29;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_2.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2);
  lowp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * _Color);
  highp vec2 tmpvar_5;
  tmpvar_5.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_5.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp float shadow_6;
  lowp float tmpvar_7;
  tmpvar_7 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_8;
  tmpvar_8 = (_LightShadowData.x + (tmpvar_7 * (1.0 - _LightShadowData.x)));
  shadow_6 = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize(xlv_TEXCOORD3);
  mediump vec3 viewDir_10;
  viewDir_10 = tmpvar_9;
  lowp vec4 c_11;
  highp float nh_12;
  lowp float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (xlv_TEXCOORD1, normalize((_WorldSpaceLightPos0.xyz + viewDir_10))));
  nh_12 = tmpvar_14;
  mediump float arg1_15;
  arg1_15 = (_Shininess * 128.0);
  highp float tmpvar_16;
  tmpvar_16 = (pow (nh_12, arg1_15) * tmpvar_3.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = ((((tmpvar_4.xyz * _LightColor0.xyz) * tmpvar_13) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_16)) * (shadow_6 * 2.0));
  c_11.xyz = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = (tmpvar_4.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_16) * shadow_6));
  c_11.w = tmpvar_18;
  c_1.w = c_11.w;
  c_1.xyz = (c_11.xyz + (tmpvar_4.xyz * xlv_TEXCOORD2));
  c_1.xyz = (c_1.xyz + (tmpvar_4.xyz * texture2D (_Illum, tmpvar_5).w));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 455
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 437
v2f_surf vert_surf( in appdata_full v ) {
    #line 439
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 443
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 447
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    #line 451
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 407
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 425
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec3 viewDir;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 401
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 405
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 413
#line 435
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 455
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 413
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 417
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 421
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 455
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 459
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 463
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 467
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingBlinnPhong( o, _WorldSpaceLightPos0.xyz, normalize(IN.viewDir), atten);
    #line 471
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 42 to 71, TEX: 2 to 5
//   d3d9 - ALU: 62 to 92, TEX: 2 to 5
//   d3d11 - ALU: 25 to 55, TEX: 2 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_SpecColor]
Vector 4 [_PanMT]
Vector 5 [_RotMT]
Vector 6 [_PanIL]
Vector 7 [_RotIL]
Vector 8 [_Color]
Float 9 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
"3.0-!!ARBfp1.0
# 61 ALU, 2 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0 },
		{ 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
DP3 R3.y, fragment.texcoord[1], c[1];
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], c[1];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MAX R0.z, R0.x, c[10].w;
MOV R0.x, c[11];
MUL R0.w, R0.x, c[9].x;
MOV R0.y, c[5].w;
MAD R0.y, R0, c[10].x, c[10];
MOV R2.w, c[0].y;
MUL R0.x, R0.y, c[10].z;
MAD R0.x, R2.w, c[5].z, R0;
POW R1.x, R0.z, R0.w;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].y, -c[5].y;
MUL R0.w, R0.x, R0.z;
MUL R1.y, R0, R0.x;
ADD R0.x, fragment.texcoord[0], -c[5];
MAD R0.z, R0.x, R0, R1.y;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[5];
ADD R0.x, -R0, c[5];
MAX R3.z, R3.y, c[10].w;
MOV R3.w, c[7];
MAD R3.y, R3.w, c[10].x, c[10];
MAD R0.y, R2.w, c[4], R0;
MAD R0.x, R2.w, c[4], R0;
TEX R0, R0, texture[0], 2D;
MUL R3.x, R0.w, R1;
MOV R1, c[3];
MUL R0, R0, c[8];
MUL R2.xyz, R0, c[2];
MUL R1.w, R1, c[2];
MUL R2.xyz, R2, R3.z;
MUL R1.xyz, R1, c[2];
MAD R1.xyz, R1, R3.x, R2;
MUL R3.y, R3, c[10].z;
MAD R2.y, R2.w, c[7].z, R3;
MUL R1.xyz, R1, c[11].y;
COS R2.x, R2.y;
ADD R2.z, fragment.texcoord[0].w, -c[7].y;
SIN R3.y, R2.y;
MUL R2.y, R2.z, R3;
MUL R3.z, R2.x, R2;
ADD R2.z, fragment.texcoord[0], -c[7].x;
MAD R2.x, R2.z, R2, -R2.y;
MAD R3.y, R2.z, R3, R3.z;
ADD R2.y, -R3, c[7];
ADD R2.x, -R2, c[7];
MAD R1.xyz, R0, fragment.texcoord[2], R1;
MAD R2.y, R2.w, c[6], R2;
MAD R2.x, R2.w, c[6], R2;
TEX R2.w, R2, texture[1], 2D;
MUL R0.xyz, R0, R2.w;
ADD result.color.xyz, R1, R0;
MAD result.color.w, R3.x, R1, R0;
END
# 61 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_SpecColor]
Vector 4 [_PanMT]
Vector 5 [_RotMT]
Vector 6 [_PanIL]
Vector 7 [_RotIL]
Vector 8 [_Color]
Float 9 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
"ps_3_0
; 86 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c10, 0.00555556, 1.00000000, 3.14159274, 0.00000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 128.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c5.w
mad r0.x, r0, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c5.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r0.x, r0, c11.z, c11.w
sincos r1.xy, r0.x
add r0.z, v0.y, -c5.y
mul r0.x, r0.z, r1.y
add r0.y, v0.x, -c5.x
mad r0.x, r0.y, r1, -r0
mul r0.z, r0, r1.x
mad r0.y, r0, r1, r0.z
add r0.w, -r0.x, c5.x
dp3_pp r1.z, v3, v3
rsq_pp r1.z, r1.z
mov r0.x, c4
mad_pp r2.xyz, r1.z, v3, c1
mad r0.x, c0.y, r0, r0.w
dp3_pp r0.w, r2, r2
rsq_pp r0.z, r0.w
mul_pp r1.xyz, r0.z, r2
dp3_pp r0.z, v1, r1
mov_pp r0.w, c9.x
mul_pp r0.w, c12.x, r0
max_pp r0.z, r0, c10.w
pow r1, r0.z, r0.w
mov r2.x, r1
mov r0.z, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.z, r0
texld r0, r0, s0
mul_pp r1, r0, c8
mul r2.w, r0, r2.x
mov r2.x, c7.w
dp3_pp r0.w, v1, c1
mul_pp r0.xyz, r1, c2
mad r3.x, r2, c10, c10.y
max_pp r0.w, r0, c10
mul_pp r2.xyz, r0, r0.w
mul r0.y, r3.x, c10.z
mov r0.x, c7.z
mad r0.w, c0.y, r0.x, r0.y
mov_pp r0.xyz, c2
mad r0.w, r0, c11.x, c11.y
frc r0.w, r0
mul_pp r0.xyz, c3, r0
mad r0.xyz, r0, r2.w, r2
mul r2.xyz, r0, c12.y
mad r3.x, r0.w, c11.z, c11.w
sincos r0.xy, r3.x
add r0.z, v0.w, -c7.y
mul r0.w, r0.z, r0.y
mul r3.x, r0.z, r0
add r0.z, v0, -c7.x
mad r0.y, r0.z, r0, r3.x
mad r0.z, r0, r0.x, -r0.w
mov r0.x, c6.y
add r0.y, -r0, c7
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c7.x
mov r0.x, c6
mad r0.x, c0.y, r0, r0.z
texld r0.w, r0, s1
mul r0.xyz, r1, r0.w
mad_pp r2.xyz, r1, v2, r2
mov_pp r3.x, c2.w
mul_pp r0.w, c3, r3.x
add_pp oC0.xyz, r2, r0
mad oC0.w, r2, r0, r1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 176 // 132 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
// 50 instructions, 3 temp regs, 0 temp arrays:
// ALU 45 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcokahobgidkdflbnhgbellbjlbihnbniabaaaaaabmaiaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbeahaaaaeaaaaaaamfabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaadpcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaadcaaaaak
bcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaafgiecaia
ebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaaaaaaaaaa
fgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaa
abaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaaaaaaaaaa
egaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaaeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegbcbaaaaeaaaaaaagaabaaaaaaaaaaa
egiccaaaacaaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaa
aaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakccaabaaaaaaaaaaa
dkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalccaabaaa
aaaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaaenaaaaahbcaabaaaabaaaaaabcaabaaaacaaaaaabkaabaaaaaaaaaaa
aaaaaaajgcaabaaaaaaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaa
aeaaaaaadiaaaaahdcaabaaaabaaaaaaagaabaaaabaaaaaajgafbaaaaaaaaaaa
dcaaaaakecaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaia
ebaaaaaaabaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
acaaaaaabkaabaaaabaaaaaaaaaaaaajccaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaabkiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaa
aaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaa
dcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadkaabaaaabaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaaaaaaaaaa
abaaaaaaegiocaaaaaaaaaaaacaaaaaadiaaaaahpcaabaaaacaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaahaaaaaadcaaaaakiccabaaaaaaaaaaadkaabaaaabaaaaaa
dkiacaaaaaaaaaaaahaaaaaadkaabaaaacaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaaiicaabaaaabaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahicaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaa
aaaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_PanMT]
Vector 2 [_RotMT]
Vector 3 [_PanIL]
Vector 4 [_RotIL]
Vector 5 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 42 ALU, 3 TEX
PARAM c[7] = { program.local[0..5],
		{ 0.0055555557, 3.1415927, 1, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[2].w;
MAD R0.x, R0, c[6], c[6].z;
MOV R1.w, c[0].y;
MUL R0.x, R0, c[6].y;
MAD R0.x, R1.w, c[2].z, R0;
COS R2.x, R0.x;
SIN R2.z, R0.x;
ADD R2.w, fragment.texcoord[0].y, -c[2].y;
MUL R0.x, R2.w, R2.z;
ADD R2.y, fragment.texcoord[0].x, -c[2].x;
MAD R1.x, R2.y, R2, -R0;
TEX R0, fragment.texcoord[1], texture[2], 2D;
ADD R3.x, -R1, c[2];
MUL R1.xyz, R0.w, R0;
MUL R0.y, R2.x, R2.w;
MAD R0.y, R2, R2.z, R0;
MOV R0.z, c[4].w;
MAD R0.z, R0, c[6].x, c[6];
MUL R0.z, R0, c[6].y;
MAD R2.x, R1.w, c[4].z, R0.z;
ADD R0.y, -R0, c[2];
COS R2.y, R2.x;
SIN R2.z, R2.x;
ADD R2.x, fragment.texcoord[0].w, -c[4].y;
MAD R0.x, R1.w, c[1], R3;
MAD R0.y, R1.w, c[1], R0;
TEX R0, R0, texture[0], 2D;
MUL R0, R0, c[5];
MUL R2.w, R2.x, R2.z;
MUL R3.x, R2.y, R2;
ADD R2.x, fragment.texcoord[0].z, -c[4];
MAD R2.z, R2.x, R2, R3.x;
MAD R2.x, R2, R2.y, -R2.w;
ADD R2.y, -R2.z, c[4];
ADD R2.x, -R2, c[4];
MAD R2.y, R1.w, c[3], R2;
MAD R2.x, R1.w, c[3], R2;
TEX R1.w, R2, texture[1], 2D;
MUL R2.xyz, R0, R1.w;
MUL R0.xyz, R1, R0;
MAD result.color.xyz, R0, c[6].w, R2;
MOV result.color.w, R0;
END
# 42 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_PanMT]
Vector 2 [_RotMT]
Vector 3 [_PanIL]
Vector 4 [_RotIL]
Vector 5 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_3_0
; 62 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c7, 0.15915491, 0.50000000, 6.28318501, -3.14159298
dcl_texcoord0 v0
dcl_texcoord1 v1.xy
mov r0.x, c2.w
mad r0.x, r0, c6, c6.y
mul r0.y, r0.x, c6.z
mov r0.x, c2.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c7, c7.y
frc r0.x, r0
mad r1.x, r0, c7.z, c7.w
sincos r0.xy, r1.x
add r1.y, v0, -c2
mul r0.w, r1.y, r0.y
add r0.z, v0.x, -c2.x
mad r0.w, r0.z, r0.x, -r0
add r1.x, -r0.w, c2
mov r0.w, c1.x
mul r0.x, r1.y, r0
mad r0.x, r0.z, r0.y, r0
add r0.y, -r0.x, c2
mov r1.z, c4.w
mad r1.x, c0.y, r0.w, r1
mad r0.w, r1.z, c6.x, c6.y
mul r1.y, r0.w, c6.z
mov r0.w, c4.z
mad r0.w, c0.y, r0, r1.y
mad r0.z, r0.w, c7.x, c7.y
frc r0.z, r0
mov r0.x, c1.y
mad r1.y, c0, r0.x, r0
mad r2.x, r0.z, c7.z, c7.w
sincos r0.xy, r2.x
add r0.z, v0.w, -c4.y
texld r1, r1, s0
mul_pp r1, r1, c5
mul r2.x, r0.z, r0
mul r0.w, r0.z, r0.y
add r0.z, v0, -c4.x
mad r0.x, r0.z, r0, -r0.w
mad r0.z, r0, r0.y, r2.x
add r0.y, -r0.x, c4.x
mov r0.x, c3
mad r2.x, c0.y, r0, r0.y
add r0.y, -r0.z, c4
mov r0.x, c3.y
mad r2.y, c0, r0.x, r0
texld r0, v1, s2
texld r2.w, r2, s1
mul_pp r0.xyz, r0.w, r0
mul r2.xyz, r1, r2.w
mul_pp r0.xyz, r0, r1
mad_pp oC0.xyz, r0, c6.w, r2
mov_pp oC0.w, r1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 192 // 128 used size, 12 vars
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
// 32 instructions, 3 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgpbgikjggajoopgbloknahifhpbdgkflabaaaaaameafaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcomaeaaaaeaaaaaaadlabaaaa
fjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadcaaaaakbcaabaaa
aaaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadp
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaal
bcaabaaaaaaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaa
akaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaaabaaaaaaakaabaaa
aaaaaaaaaaaaaaajgcaabaaaaaaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaa
aaaaaaaaaeaaaaaadiaaaaahgcaabaaaabaaaaaaagaabaaaaaaaaaaafgagbaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaaabaaaaaa
bkaabaiaebaaaaaaabaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaajdcaabaaaaaaaaaaaegaabaia
ebaaaaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaaabaaaaaa
bkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaa
abaaaaaaegiocaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
acaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
pgapbaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 65 ALU, 4 TEX
PARAM c[12] = { program.local[0..7],
		{ 0.0055555557, 1, 3.1415927, 8 },
		{ -0.40824828, -0.70710677, 0.57735026, 0 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[3], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].w;
MUL R1.xyz, R0.y, c[11];
MAD R1.xyz, R0.x, c[10], R1;
MAD R1.xyz, R0.z, c[9], R1;
DP3 R0.x, R1, R1;
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
MOV R2.w, c[0].y;
MUL R1.xyz, R0.y, R1;
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[2], R1;
DP3 R0.x, R0, R0;
TEX R1, fragment.texcoord[1], texture[2], 2D;
MUL R1.xyz, R1.w, R1;
RSQ R0.x, R0.x;
MUL R0.x, R0, R0.z;
MAX R0.z, R0.x, c[9].w;
MOV R0.x, c[10].w;
MUL R0.w, R0.x, c[7].x;
MOV R0.y, c[3].w;
MAD R0.x, R0.y, c[8], c[8].y;
MUL R0.x, R0, c[8].z;
MAD R0.x, R2.w, c[3].z, R0;
POW R3.x, R0.z, R0.w;
MOV R1.w, c[5];
MAD R1.w, R1, c[8].x, c[8].y;
MUL R1.w, R1, c[8].z;
MAD R1.w, R2, c[5].z, R1;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].y, -c[3].y;
MUL R0.w, R0.x, R0.z;
MUL R2.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0], -c[3];
MAD R0.z, R0.x, R0, R2.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[3];
MUL R1.xyz, R1, c[8].w;
ADD R0.x, -R0, c[3];
SIN R3.y, R1.w;
ADD R3.z, fragment.texcoord[0].w, -c[5].y;
MAD R0.y, R2.w, c[2], R0;
MAD R0.x, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
MUL R2.xyz, R1, c[1];
MUL R2.xyz, R0.w, R2;
MUL R0, R0, c[6];
MUL R2.xyz, R2, R3.x;
COS R3.x, R1.w;
MUL R1.w, R3.z, R3.y;
MUL R3.w, R3.x, R3.z;
ADD R3.z, fragment.texcoord[0], -c[5].x;
MAD R1.w, R3.z, R3.x, -R1;
MAD R3.y, R3.z, R3, R3.w;
ADD R3.x, -R3.y, c[5].y;
MAD R3.y, R2.w, c[4], R3.x;
ADD R1.w, -R1, c[5].x;
MAD R3.x, R2.w, c[4], R1.w;
TEX R1.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MOV result.color.w, R0;
END
# 65 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_3_0
; 87 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c8, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c9, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c10, -0.40824831, 0.70710677, 0.57735026, 0.00000000
def c11, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c12, -0.40824828, -0.70710677, 0.57735026, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xy
dcl_texcoord2 v2.xyz
texld r0, v1, s3
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.w
mul r1.xyz, r0.y, c10
mad r1.xyz, r0.x, c11, r1
mad r1.xyz, r0.z, c12, r1
dp3 r0.x, r1, r1
rsq r0.y, r0.x
dp3_pp r0.x, v2, v2
mul r1.xyz, r0.y, r1
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v2, r1
dp3_pp r0.x, r0, r0
rsq_pp r0.y, r0.x
mul_pp r0.y, r0, r0.z
mov r0.x, c3.w
max_pp r0.z, r0.y, c10.w
mad r0.x, r0, c8, c8.y
mul r0.y, r0.x, c8.z
mov r0.x, c3.z
mad r0.x, c0.y, r0, r0.y
mov_pp r0.y, c7.x
mul_pp r0.y, c11.w, r0
mad r0.x, r0, c9, c9.y
pow r1, r0.z, r0.y
frc r0.x, r0
mad r1.y, r0.x, c9.z, c9.w
sincos r0.xy, r1.y
add r0.z, v0.y, -c3.y
mov r2.w, r1.x
mul r1.x, r0.z, r0
mul r0.w, r0.z, r0.y
add r0.z, v0.x, -c3.x
mad r0.x, r0.z, r0, -r0.w
mad r0.z, r0, r0.y, r1.x
add r0.y, -r0.x, c3.x
mov r0.x, c2
mad r0.x, c0.y, r0, r0.y
add r0.z, -r0, c3.y
mov r0.y, c2
mad r0.y, c0, r0, r0.z
mov r0.z, c5.w
mad r2.x, r0.z, c8, c8.y
texld r1, r0, s0
mul r2.y, r2.x, c8.z
texld r0, v1, s2
mov r2.x, c5.z
mul_pp r0.xyz, r0.w, r0
mad r2.x, c0.y, r2, r2.y
mad r0.w, r2.x, c9.x, c9.y
mul_pp r2.xyz, r0, c8.w
frc r0.w, r0
mul_pp r0.xyz, r2, c1
mul_pp r3.xyz, r1.w, r0
mad r3.w, r0, c9.z, c9
sincos r0.xy, r3.w
add r0.w, v0, -c5.y
mul r3.xyz, r3, r2.w
mul r2.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r2.w
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r2.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mov_pp oC0.w, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 192 // 132 used size, 12 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [unity_Lightmap] 2D 2
SetTexture 3 [unity_LightmapInd] 2D 3
// 56 instructions, 4 temp regs, 0 temp arrays:
// ALU 48 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddjaaklhifhljhjmcmedjikijjlgdcigaabaaaaaaniaiaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcoiahaaaaeaaaaaaapkabaaaafjaaaaaeegiocaaa
aaaaaaaaajaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaah
bcaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaa
fgafbaaaaaaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaam
hcaabaaaabaaaaaaagaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaadkmnbddp
aaaaaaaaegacbaaaabaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaa
aceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaafbcaabaaa
abaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaadaaaaaa
egbcbaaaadaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaah
ocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
ckaabaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaakccaabaaaaaaaaaaadkiacaaaaaaaaaaaaeaaaaaa
abeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaaabeaaaaanlapejeadcaaaaalccaabaaaaaaaaaaackiacaaaaaaaaaaa
aeaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaenaaaaahbcaabaaa
abaaaaaabcaabaaaacaaaaaabkaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaa
fgbebaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaaeaaaaaadiaaaaahdcaabaaa
abaaaaaaagaabaaaabaaaaaajgafbaaaaaaaaaaadcaaaaakecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaaj
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaacaaaaaabkaabaaaabaaaaaa
aaaaaaajccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaabkiacaaaaaaaaaaa
aeaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaabkiacaaa
abaaaaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaackaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadcaaaaalbcaabaaaabaaaaaa
akiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaafgafbaaaaaaaaaaa
diaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaaaaaaaaaaacaaaaaa
diaaaaahhcaabaaaadaaaaaapgapbaaaabaaaaaaegacbaaaadaaaaaadiaaaaai
pcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaaaaaaaaaaahaaaaaadiaaaaah
hcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_SpecColor]
Vector 4 [_PanMT]
Vector 5 [_RotMT]
Vector 6 [_PanIL]
Vector 7 [_RotIL]
Vector 8 [_Color]
Float 9 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_ShadowMapTexture] 2D
"3.0-!!ARBfp1.0
# 64 ALU, 3 TEX
PARAM c[12] = { program.local[0..9],
		{ 0.0055555557, 1, 3.1415927, 0 },
		{ 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R2, c[3];
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], c[1];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MAX R0.z, R0.x, c[10].w;
MOV R0.x, c[11];
MUL R0.w, R0.x, c[9].x;
MOV R0.y, c[5].w;
MAD R0.y, R0, c[10].x, c[10];
MOV R3.y, c[0];
MUL R0.x, R0.y, c[10].z;
MAD R0.x, R3.y, c[5].z, R0;
POW R1.x, R0.z, R0.w;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].y, -c[5].y;
MUL R0.w, R0.x, R0.z;
MUL R1.y, R0, R0.x;
ADD R0.x, fragment.texcoord[0], -c[5];
MAD R0.z, R0.x, R0, R1.y;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[5];
ADD R0.x, -R0, c[5];
DP3 R3.z, fragment.texcoord[1], c[1];
MAD R0.y, R3, c[4], R0;
MAD R0.x, R3.y, c[4], R0;
TEX R0, R0, texture[0], 2D;
MUL R3.x, R0.w, R1;
MUL R1, R0, c[8];
MAX R0.w, R3.z, c[10];
MUL R0.xyz, R1, c[2];
MUL R0.xyz, R0, R0.w;
MUL R2.xyz, R2, c[2];
MAD R2.xyz, R2, R3.x, R0;
MOV R0.y, c[7].w;
MAD R0.z, R0.y, c[10].x, c[10].y;
TXP R0.x, fragment.texcoord[4], texture[2], 2D;
MUL R0.y, R0.x, c[11];
MUL R2.xyz, R2, R0.y;
MUL R0.z, R0, c[10];
MAD R0.z, R3.y, c[7], R0;
COS R0.y, R0.z;
ADD R3.z, fragment.texcoord[0].w, -c[7].y;
SIN R0.w, R0.z;
MUL R0.z, R3, R0.w;
MUL R3.w, R0.y, R3.z;
ADD R3.z, fragment.texcoord[0], -c[7].x;
MAD R0.y, R3.z, R0, -R0.z;
MAD R0.w, R3.z, R0, R3;
ADD R0.z, -R0.w, c[7].y;
MAD R2.xyz, R1, fragment.texcoord[2], R2;
ADD R0.y, -R0, c[7].x;
MAD R0.w, R3.y, c[6].y, R0.z;
MAD R0.z, R3.y, c[6].x, R0.y;
TEX R0.w, R0.zwzw, texture[1], 2D;
MUL R0.y, R2.w, c[2].w;
MUL R1.xyz, R1, R0.w;
MUL R0.y, R3.x, R0;
ADD result.color.xyz, R2, R1;
MAD result.color.w, R0.x, R0.y, R1;
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_WorldSpaceLightPos0]
Vector 2 [_LightColor0]
Vector 3 [_SpecColor]
Vector 4 [_PanMT]
Vector 5 [_RotMT]
Vector 6 [_PanIL]
Vector 7 [_RotIL]
Vector 8 [_Color]
Float 9 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_ShadowMapTexture] 2D
"ps_3_0
; 88 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c10, 0.00555556, 1.00000000, 3.14159274, 0.00000000
def c11, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c12, 128.00000000, 2.00000000, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
mov r0.x, c5.w
mad r0.x, r0, c10, c10.y
mul r0.y, r0.x, c10.z
mov r0.x, c5.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c11, c11.y
frc r0.x, r0
mad r1.x, r0, c11.z, c11.w
sincos r0.xy, r1.x
add r1.y, v0, -c5
dp3_pp r1.x, v3, v3
rsq_pp r1.z, r1.x
mad_pp r2.xyz, r1.z, v3, c1
mul r0.w, r1.y, r0.y
add r0.z, v0.x, -c5.x
mad r0.w, r0.z, r0.x, -r0
mul r0.x, r1.y, r0
add r1.x, -r0.w, c5
mov r0.w, c4.x
mad r1.x, c0.y, r0.w, r1
dp3_pp r0.w, r2, r2
mad r1.y, r0.z, r0, r0.x
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r2
mov_pp r0.w, c9.x
dp3_pp r0.x, v1, r0
mul_pp r1.w, c12.x, r0
max_pp r1.z, r0.x, c10.w
pow r0, r1.z, r1.w
add r0.z, -r1.y, c5.y
mov r0.y, c4
mad r1.y, c0, r0, r0.z
mov r1.z, r0.x
texld r0, r1, s0
mul_pp r2, r0, c8
mul r3.w, r0, r1.z
dp3_pp r1.x, v1, c1
max_pp r0.w, r1.x, c10
mul_pp r0.xyz, r2, c2
mul_pp r1.xyz, r0, r0.w
mov r0.w, c7
mad r0.w, r0, c10.x, c10.y
mul r1.w, r0, c10.z
mov_pp r0.xyz, c2
mul_pp r0.xyz, c3, r0
mad r1.xyz, r0, r3.w, r1
texldp r0.x, v4, s2
mul_pp r0.z, r0.x, c12.y
mul r3.xyz, r1, r0.z
mov r0.w, c7.z
mad r0.w, c0.y, r0, r1
mad r0.y, r0.w, c11.x, c11
frc r0.y, r0
mad r0.y, r0, c11.z, c11.w
sincos r1.xy, r0.y
add r0.y, v0.w, -c7
mul r0.w, r0.y, r1.x
mul r0.z, r0.y, r1.y
add r0.y, v0.z, -c7.x
mad r0.z, r0.y, r1.x, -r0
mad r0.w, r0.y, r1.y, r0
add r0.z, -r0, c7.x
mov r0.y, c6.x
mad r1.x, c0.y, r0.y, r0.z
add r0.z, -r0.w, c7.y
mov r0.y, c6
mad r1.y, c0, r0, r0.z
mov_pp r0.y, c2.w
texld r0.w, r1, s1
mul_pp r0.y, c3.w, r0
mul r0.y, r3.w, r0
mad_pp r3.xyz, r2, v2, r3
mul r1.xyz, r2, r0.w
add_pp oC0.xyz, r3, r1
mad oC0.w, r0.x, r0.y, r2
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 240 // 196 used size, 12 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanIL] 4
Vector 160 [_RotIL] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_Illum] 2D 2
SetTexture 2 [_ShadowMapTexture] 2D 0
// 53 instructions, 4 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedldenecmdpokodebfcgplfbafkfphjcjmabaaaaaaleaiaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcjeahaaaa
eaaaaaaaofabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
lcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaadcaaaaak
bcaabaaaaaaaaaaadkiacaaaaaaaaaaaakaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaakaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaafgiecaia
ebaaaaaaaaaaaaaaakaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaaaaaaaaaa
fgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaa
abaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaaaaaaaaaa
egaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaakaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaajaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaa
abaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaabaaaaaahbcaabaaaaaaaaaaa
egbcbaaaaeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegbcbaaaaeaaaaaaagaabaaaaaaaaaaa
egiccaaaacaaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaabaaaaaahbcaabaaa
aaaaaaaaegbcbaaaacaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaa
aaaaaaeddiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaa
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakccaabaaaaaaaaaaa
dkiacaaaaaaaaaaaaiaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalccaabaaa
aaaaaaaackiacaaaaaaaaaaaaiaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaaenaaaaahbcaabaaaabaaaaaabcaabaaaacaaaaaabkaabaaaaaaaaaaa
aaaaaaajgcaabaaaaaaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaa
aiaaaaaadiaaaaahdcaabaaaabaaaaaaagaabaaaabaaaaaajgafbaaaaaaaaaaa
dcaaaaakecaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaia
ebaaaaaaabaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaa
acaaaaaabkaabaaaabaaaaaaaaaaaaajccaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaabkiacaaaaaaaaaaaaiaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaa
aaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaaj
ccaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaa
dcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadkaabaaaabaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaa
egiocaaaaaaaaaaaalaaaaaadiaaaaajpcaabaaaacaaaaaaegiocaaaaaaaaaaa
abaaaaaaegiocaaaaaaaaaaaacaaaaaadiaaaaahpcaabaaaacaaaaaaagaabaaa
aaaaaaaaegaobaaaacaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaabaaaaaa
egiccaaaaaaaaaaaabaaaaaabaaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaa
egiccaaaacaaaaaaaaaaaaaadeaaaaahbcaabaaaadaaaaaaakaabaaaadaaaaaa
abeaaaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaaagaabaaa
adaaaaaaegacbaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaabaaaaaa
egbcbaaaadaaaaaaaoaaaaahdcaabaaaadaaaaaaegbabaaaafaaaaaapgbpbaaa
afaaaaaaefaaaaajpcaabaaaadaaaaaaegaabaaaadaaaaaaeghobaaaacaaaaaa
aagabaaaaaaaaaaaaaaaaaahccaabaaaadaaaaaaakaabaaaadaaaaaaakaabaaa
adaaaaaadcaaaaajiccabaaaaaaaaaaadkaabaaaacaaaaaaakaabaaaadaaaaaa
dkaabaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaafgafbaaa
adaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_PanMT]
Vector 2 [_RotMT]
Vector 3 [_PanIL]
Vector 4 [_RotIL]
Vector 5 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 48 ALU, 4 TEX
PARAM c[8] = { program.local[0..5],
		{ 0.0055555557, 3.1415927, 1, 8 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[1], texture[3], 2D;
MUL R0.xyz, R2.w, R2;
MUL R1.xyz, R0, c[6].w;
TXP R0.x, fragment.texcoord[2], texture[2], 2D;
MUL R2.xyz, R2, R0.x;
MOV R0.y, c[2].w;
MAD R0.y, R0, c[6].x, c[6].z;
MUL R2.xyz, R2, c[7].x;
MOV R0.w, c[0].y;
MUL R0.y, R0, c[6];
MAD R0.y, R0.w, c[2].z, R0;
COS R1.w, R0.y;
SIN R3.x, R0.y;
ADD R3.y, fragment.texcoord[0], -c[2];
MIN R2.xyz, R1, R2;
MUL R0.y, R3, R3.x;
ADD R2.w, fragment.texcoord[0].x, -c[2].x;
MAD R0.y, R2.w, R1.w, -R0;
ADD R3.z, -R0.y, c[2].x;
MUL R0.xyz, R1, R0.x;
MAD R1.x, R0.w, c[1], R3.z;
MUL R1.y, R1.w, R3;
MAD R1.y, R2.w, R3.x, R1;
MOV R1.z, c[4].w;
MAD R1.z, R1, c[6].x, c[6];
MUL R1.z, R1, c[6].y;
MAD R3.x, R0.w, c[4].z, R1.z;
ADD R1.y, -R1, c[2];
MAD R1.y, R0.w, c[1], R1;
TEX R1, R1, texture[0], 2D;
MUL R1, R1, c[5];
COS R2.w, R3.x;
ADD R3.z, fragment.texcoord[0].w, -c[4].y;
SIN R3.y, R3.x;
MUL R3.x, R3.z, R3.y;
MUL R3.w, R2, R3.z;
ADD R3.z, fragment.texcoord[0], -c[4].x;
MAD R2.w, R3.z, R2, -R3.x;
MAD R3.y, R3.z, R3, R3.w;
ADD R3.x, -R3.y, c[4].y;
MAD R3.y, R0.w, c[3], R3.x;
ADD R2.w, -R2, c[4].x;
MAD R3.x, R0.w, c[3], R2.w;
TEX R0.w, R3, texture[1], 2D;
MUL R3.xyz, R1, R0.w;
MAX R0.xyz, R2, R0;
MAD result.color.xyz, R1, R0, R3;
MOV result.color.w, R1;
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_PanMT]
Vector 2 [_RotMT]
Vector 3 [_PanIL]
Vector 4 [_RotIL]
Vector 5 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_3_0
; 67 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c6, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c7, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xy
dcl_texcoord2 v2
mov r0.x, c2.w
mad r0.x, r0, c6, c6.y
mul r0.y, r0.x, c6.z
mov r0.x, c2.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c7, c7.y
frc r0.x, r0
mad r1.x, r0, c7.z, c7.w
sincos r0.xy, r1.x
add r1.y, v0, -c2
mov r1.z, c4.w
mad r1.z, r1, c6.x, c6.y
mul r0.z, r1.y, r0.y
add r0.w, v0.x, -c2.x
mad r0.z, r0.w, r0.x, -r0
add r1.x, -r0.z, c2
mov r0.z, c1.x
mad r1.x, c0.y, r0.z, r1
mul r0.x, r1.y, r0
mad r0.x, r0.w, r0.y, r0
add r0.y, -r0.x, c2
mov r0.x, c1.y
mul r1.z, r1, c6
mov r0.z, c4
mad r0.z, c0.y, r0, r1
mad r0.z, r0, c7.x, c7.y
frc r0.z, r0
mad r1.z, r0, c7, c7.w
mad r1.y, c0, r0.x, r0
sincos r0.xy, r1.z
add r0.z, v0.w, -c4.y
mul r0.w, r0.z, r0.y
mul r2.x, r0.z, r0
add r0.z, v0, -c4.x
mad r0.y, r0.z, r0, r2.x
mad r0.z, r0, r0.x, -r0.w
texld r1, r1, s0
mul_pp r2, r1, c5
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0.w, r0, s1
texldp r0.x, v2, s2
mul r3.xyz, r2, r0.w
texld r1, v1, s3
mul_pp r0.yzw, r1.w, r1.xxyz
mul_pp r1.xyz, r1, r0.x
mul_pp r0.yzw, r0, c6.w
mul_pp r4.xyz, r0.yzww, r0.x
mul_pp r1.xyz, r1, c8.x
min_pp r0.xyz, r0.yzww, r1
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r2, r0, r3
mov_pp oC0.w, r2
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 256 // 192 used size, 13 vars
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanIL] 4
Vector 160 [_RotIL] 4
Vector 176 [_Color] 4
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_Illum] 2D 2
SetTexture 2 [_ShadowMapTexture] 2D 0
SetTexture 3 [unity_Lightmap] 2D 3
// 41 instructions, 3 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjfbepnhgmmpmbfkjgbpgclghklbcngoaabaaaaaabiahaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcciagaaaaeaaaaaaaikabaaaafjaaaaaeegiocaaa
aaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadlcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aoaaaaahdcaabaaaaaaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaa
aaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
diaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaadiaaaaah
icaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
abaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaaddaaaaahocaabaaaaaaaaaaa
fgaobaaaaaaaaaaaagajbaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadeaaaaahhcaabaaaaaaaaaaajgahbaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakicaabaaaaaaaaaaadkiacaaaaaaaaaaaakaaaaaa
abeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaanlapejeadcaaaaalicaabaaaaaaaaaaackiacaaaaaaaaaaa
akaaaaaabkiacaaaabaaaaaaaaaaaaaadkaabaaaaaaaaaaaenaaaaahbcaabaaa
abaaaaaabcaabaaaacaaaaaadkaabaaaaaaaaaaaaaaaaaajgcaabaaaabaaaaaa
pgbobaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaakaaaaaadiaaaaahjcaabaaa
abaaaaaaagaabaaaabaaaaaafgajbaaaabaaaaaadcaaaaakicaabaaaaaaaaaaa
ckaabaaaabaaaaaaakaabaaaacaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaaj
bcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaabaaaaaa
aaaaaaajbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaabkiacaaaaaaaaaaa
akaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaajaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaabaaaaaaaaaaaaajicaabaaaaaaaaaaadkaabaia
ebaaaaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaadcaaaaalbcaabaaaabaaaaaa
akiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaaaaaaaaaadkaabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadcaaaaakicaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalicaabaaaaaaaaaaackiacaaaaaaaaaaaaiaaaaaa
bkiacaaaabaaaaaaaaaaaaaadkaabaaaaaaaaaaaenaaaaahbcaabaaaabaaaaaa
bcaabaaaacaaaaaadkaabaaaaaaaaaaaaaaaaaajgcaabaaaabaaaaaafgbebaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaaiaaaaaadiaaaaahgcaabaaaacaaaaaa
agaabaaaabaaaaaafgagbaaaabaaaaaadcaaaaakicaabaaaaaaaaaaackaabaaa
abaaaaaaakaabaaaacaaaaaabkaabaiaebaaaaaaacaaaaaadcaaaaajbcaabaaa
abaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaackaabaaaacaaaaaaaaaaaaaj
bcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaabkiacaaaaaaaaaaaaiaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaabaaaaaaaaaaaaajicaabaaaaaaaaaaadkaabaiaebaaaaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaa
aaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaadkaabaaaaaaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaipcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaaaaaaaaaaalaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaadkaabaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 71 ALU, 5 TEX
PARAM c[12] = { program.local[0..7],
		{ 0.0055555557, 1, 3.1415927, 8 },
		{ 2, -0.40824828, -0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].w;
MUL R1.xyz, R0.y, c[11];
MAD R1.xyz, R0.x, c[10], R1;
MAD R1.xyz, R0.z, c[9].yzww, R1;
DP3 R0.x, R1, R1;
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R0.y, R1;
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[2], R1;
DP3 R0.x, R0, R0;
RSQ R0.y, R0.x;
MOV R0.w, c[3];
MUL R0.y, R0, R0.z;
MOV R0.x, c[10].w;
MUL R0.z, R0.x, c[7].x;
MAX R0.x, R0.y, c[10].y;
POW R3.w, R0.x, R0.z;
TEX R2, fragment.texcoord[1], texture[3], 2D;
MUL R0.xyz, R2.w, R2;
MAD R1.x, R0.w, c[8], c[8].y;
MUL R0.yzw, R0.xxyz, c[8].w;
MOV R2.w, c[0].y;
MUL R0.x, R1, c[8].z;
MAD R1.x, R2.w, c[3].z, R0;
MUL R3.xyz, R0.yzww, c[1];
COS R0.x, R1.x;
ADD R1.z, fragment.texcoord[0].y, -c[3].y;
SIN R1.y, R1.x;
MUL R1.x, R1.z, R1.y;
MUL R1.w, R0.x, R1.z;
ADD R1.z, fragment.texcoord[0].x, -c[3].x;
MAD R0.x, R1.z, R0, -R1;
MAD R1.y, R1.z, R1, R1.w;
ADD R1.x, -R1.y, c[3].y;
ADD R0.x, -R0, c[3];
MAD R1.y, R2.w, c[2], R1.x;
MAD R1.x, R2.w, c[2], R0;
TEX R1, R1, texture[0], 2D;
MUL R3.xyz, R1.w, R3;
MUL R1, R1, c[6];
TXP R0.x, fragment.texcoord[3], texture[2], 2D;
MUL R2.xyz, R2, R0.x;
MUL R3.xyz, R3, R3.w;
MOV R3.w, c[5];
MUL R2.xyz, R2, c[9].x;
MIN R2.xyz, R0.yzww, R2;
MUL R0.xyz, R0.yzww, R0.x;
MAX R0.xyz, R2, R0;
MAD R3.w, R3, c[8].x, c[8].y;
MUL R3.w, R3, c[8].z;
MAD R0.w, R2, c[5].z, R3;
COS R2.x, R0.w;
ADD R2.z, fragment.texcoord[0].w, -c[5].y;
SIN R2.y, R0.w;
MUL R0.w, R2.z, R2.y;
MUL R3.w, R2.x, R2.z;
ADD R2.z, fragment.texcoord[0], -c[5].x;
MAD R0.w, R2.z, R2.x, -R0;
MAD R2.y, R2.z, R2, R3.w;
ADD R2.x, -R2.y, c[5].y;
MAD R2.y, R2.w, c[4], R2.x;
ADD R0.w, -R0, c[5].x;
MAD R2.x, R2.w, c[4], R0.w;
TEX R0.w, R2, texture[1], 2D;
MUL R2.xyz, R1, R0.w;
MAD R0.xyz, R1, R0, R3;
ADD result.color.xyz, R0, R2;
MOV result.color.w, R1;
END
# 71 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 92 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c8, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c9, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c10, 2.00000000, -0.40824831, 0.70710677, 0.57735026
def c11, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c12, -0.40824828, -0.70710677, 0.57735026, 0
dcl_texcoord0 v0
dcl_texcoord1 v1.xy
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
texld r0, v1, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.w
mul r1.xyz, r0.y, c10.yzww
mad r1.xyz, r0.x, c11, r1
mad r1.xyz, r0.z, c12, r1
dp3 r0.x, r1, r1
rsq r0.y, r0.x
mov r2.x, c5.w
mad r3.x, r2, c8, c8.y
dp3_pp r0.x, v2, v2
mul r1.xyz, r0.y, r1
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v2, r1
dp3_pp r0.x, r0, r0
rsq_pp r0.y, r0.x
mul_pp r0.y, r0, r0.z
mov r0.x, c3.w
max_pp r0.z, r0.y, c11.y
mad r0.x, r0, c8, c8.y
mul r0.y, r0.x, c8.z
mov r0.x, c3.z
mad r0.x, c0.y, r0, r0.y
mov_pp r0.y, c7.x
mul_pp r0.y, c11.w, r0
mad r0.x, r0, c9, c9.y
pow r1, r0.z, r0.y
frc r0.x, r0
mad r1.y, r0.x, c9.z, c9.w
sincos r0.xy, r1.y
add r0.z, v0.y, -c3.y
mov r2.w, r1.x
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c3.x
mad r0.y, r0.z, r0, r1.x
mad r0.z, r0, r0.x, -r0.w
texld r1, v1, s3
mul_pp r2.xyz, r1.w, r1
mov r0.x, c2.y
add r0.y, -r0, c3
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c3.x
mov r0.x, c2
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s0
mul_pp r5, r0, c6
add r0.x, v0.w, -c5.y
mul r3.x, r3, c8.z
mov r1.w, c5.z
mad r1.w, c0.y, r1, r3.x
mul_pp r3.xyz, r2, c8.w
mad r1.w, r1, c9.x, c9.y
mul_pp r2.xyz, r3, c1
mul_pp r2.xyz, r0.w, r2
frc r1.w, r1
mul r4.xyz, r2, r2.w
mad r1.w, r1, c9.z, c9
sincos r2.xy, r1.w
mul r0.z, r0.x, r2.x
mul r0.y, r0.x, r2
add r0.x, v0.z, -c5
mad r0.y, r0.x, r2.x, -r0
mad r0.z, r0.x, r2.y, r0
add r0.y, -r0, c5.x
mov r0.x, c4
mad r2.x, c0.y, r0, r0.y
add r0.y, -r0.z, c5
mov r0.x, c4.y
mad r2.y, c0, r0.x, r0
texldp r0.x, v3, s2
mul_pp r1.xyz, r1, r0.x
texld r0.w, r2, s1
mul_pp r1.xyz, r1, c10.x
mul r2.xyz, r5, r0.w
mul_pp r0.xyz, r3, r0.x
min_pp r1.xyz, r3, r1
max_pp r0.xyz, r1, r0
mad_pp r0.xyz, r5, r0, r4
add_pp oC0.xyz, r0, r2
mov_pp oC0.w, r5
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 256 // 196 used size, 13 vars
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 144 [_PanIL] 4
Vector 160 [_RotIL] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_Illum] 2D 2
SetTexture 2 [_ShadowMapTexture] 2D 0
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 64 instructions, 4 temp regs, 0 temp arrays:
// ALU 55 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjhbbkielppjdfbfcklhkcjanhfiocgejabaaaaaaaiakaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcaaajaaaaeaaaaaaaeaacaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaacaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaadiaaaaak
hcaabaaaabaaaaaafgafbaaaaaaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddp
aaaaaaaadcaaaaamlcaabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaaolaffbdp
aaaaaaaaaaaaaaaadkmnbddpegaibaaaabaaaaaadcaaaaamhcaabaaaaaaaaaaa
kgakbaaaaaaaaaaaaceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegadbaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafbcaabaaaabaaaaaaakaabaaa
abaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegbcbaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaackaabaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaaiccaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaed
diaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaaf
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaaoaaaaahgcaabaaaaaaaaaaaagbbbaaa
aeaaaaaapgbpbaaaaeaaaaaaefaaaaajpcaabaaaabaaaaaajgafbaaaaaaaaaaa
eghobaaaacaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaa
abaaaaaaakaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaa
aaaaaaaaagajbaaaacaaaaaadiaaaaahccaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaabaaaaaaagajbaaaacaaaaaafgafbaaa
abaaaaaaddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaafgaobaaaabaaaaaa
diaaaaahhcaabaaaacaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaadiaaaaai
hcaabaaaabaaaaaajgahbaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadeaaaaah
ocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaacaaaaaadcaaaaakicaabaaa
abaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadp
diaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaanlapejeadcaaaaal
icaabaaaabaaaaaackiacaaaaaaaaaaaaiaaaaaabkiacaaaabaaaaaaaaaaaaaa
dkaabaaaabaaaaaaenaaaaahbcaabaaaacaaaaaabcaabaaaadaaaaaadkaabaaa
abaaaaaaaaaaaaajgcaabaaaacaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaa
aaaaaaaaaiaaaaaadiaaaaahjcaabaaaacaaaaaaagaabaaaacaaaaaafgajbaaa
acaaaaaadcaaaaakicaabaaaabaaaaaackaabaaaacaaaaaaakaabaaaadaaaaaa
akaabaiaebaaaaaaacaaaaaadcaaaaajbcaabaaaacaaaaaabkaabaaaacaaaaaa
akaabaaaadaaaaaadkaabaaaacaaaaaaaaaaaaajbcaabaaaacaaaaaaakaabaia
ebaaaaaaacaaaaaabkiacaaaaaaaaaaaaiaaaaaadcaaaaalccaabaaaacaaaaaa
bkiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaacaaaaaa
aaaaaaajicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaaakiacaaaaaaaaaaa
aiaaaaaadcaaaaalbcaabaaaacaaaaaaakiacaaaaaaaaaaaahaaaaaabkiacaaa
abaaaaaaaaaaaaaadkaabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaipcaabaaaadaaaaaa
egaobaaaacaaaaaaegiocaaaaaaaaaaaalaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaapgapbaaaacaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaa
aaaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaadkiacaaa
aaaaaaaaakaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalicaabaaaaaaaaaaa
ckiacaaaaaaaaaaaakaaaaaabkiacaaaabaaaaaaaaaaaaaadkaabaaaaaaaaaaa
enaaaaahbcaabaaaabaaaaaabcaabaaaacaaaaaadkaabaaaaaaaaaaaaaaaaaaj
gcaabaaaabaaaaaapgbobaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaakaaaaaa
diaaaaahjcaabaaaabaaaaaaagaabaaaabaaaaaafgajbaaaabaaaaaadcaaaaak
icaabaaaaaaaaaaackaabaaaabaaaaaaakaabaaaacaaaaaaakaabaiaebaaaaaa
abaaaaaadcaaaaajbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaaacaaaaaa
dkaabaaaabaaaaaaaaaaaaajbcaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaa
bkiacaaaaaaaaaaaakaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaa
ajaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaabaaaaaaaaaaaaajicaabaaa
aaaaaaaadkaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaakaaaaaadcaaaaal
bcaabaaaabaaaaaaakiacaaaaaaaaaaaajaaaaaabkiacaaaabaaaaaaaaaaaaaa
dkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaadaaaaaa
pgapbaaaabaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaa
adaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 14 to 19
//   d3d9 - ALU: 14 to 19
//   d3d11 - ALU: 14 to 23, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedahfobgabnnegkcahdlllfleapjihjhbkabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp float atten_8;
  atten_8 = texture2D (_LightTexture0, vec2(tmpvar_7)).w;
  lowp vec4 c_9;
  highp float nh_10;
  lowp float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_10 = tmpvar_12;
  mediump float arg1_13;
  arg1_13 = (_Shininess * 128.0);
  highp float tmpvar_14;
  tmpvar_14 = (pow (nh_10, arg1_13) * tmpvar_4.w);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_11) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_14)) * (atten_8 * 2.0));
  c_9.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_14) * atten_8));
  c_9.w = tmpvar_16;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp float atten_8;
  atten_8 = texture2D (_LightTexture0, vec2(tmpvar_7)).w;
  lowp vec4 c_9;
  highp float nh_10;
  lowp float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_10 = tmpvar_12;
  mediump float arg1_13;
  arg1_13 = (_Shininess * 128.0);
  highp float tmpvar_14;
  tmpvar_14 = (pow (nh_10, arg1_13) * tmpvar_4.w);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_11) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_14)) * (atten_8 * 2.0));
  c_9.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_14) * atten_8));
  c_9.w = tmpvar_16;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 419
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
#line 397
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 407
#line 429
uniform highp vec4 _MainTex_ST;
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 430
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 433
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    #line 437
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    #line 442
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 419
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
#line 397
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 407
#line 429
uniform highp vec4 _MainTex_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 407
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 411
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 415
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 444
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 446
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 450
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 454
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), (texture( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.0));
    #line 458
    c.w = 0.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 11 [unity_Scale]
Vector 12 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[11].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[2].xyz, c[10];
ADD result.texcoord[3].xyz, -R0, c[9];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 o2.z, r0, c6
dp3 o2.y, r0, c5
dp3 o2.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o3.xyz, c9
add o4.xyz, -r0, c8
mad o1.xy, v2, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 10 vars
Vector 144 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 16 instructions, 2 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcckedhnknmmdnpkpddjlfcohhfpahhhmabaaaaaahmaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoaacaaaaeaaaabaa
liaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaghccabaaaadaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_6;
  highp float nh_7;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_7 = tmpvar_9;
  mediump float arg1_10;
  arg1_10 = (_Shininess * 128.0);
  highp float tmpvar_11;
  tmpvar_11 = (pow (nh_7, arg1_10) * tmpvar_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_11)) * 2.0);
  c_6.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (tmpvar_5.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_11));
  c_6.w = tmpvar_13;
  c_1.xyz = c_6.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_6;
  highp float nh_7;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_7 = tmpvar_9;
  mediump float arg1_10;
  arg1_10 = (_Shininess * 128.0);
  highp float tmpvar_11;
  tmpvar_11 = (pow (nh_7, arg1_10) * tmpvar_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_11)) * 2.0);
  c_6.xyz = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (tmpvar_5.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_11));
  c_6.w = tmpvar_13;
  c_1.xyz = c_6.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 _MainTex_ST;
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 427
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 430
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    #line 434
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    #line 438
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 _MainTex_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 440
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 442
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 446
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 450
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), 1.0);
    #line 454
    c.w = 0.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 19 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].w, R0, c[12];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.w, r0, c11
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedffeaoggeakpeademkkpehaogonjhmiljabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaafaaaaaaegiocaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_8;
  tmpvar_8 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_9;
  atten_9 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_7).w) * texture2D (_LightTextureB0, vec2(tmpvar_8)).w);
  lowp vec4 c_10;
  highp float nh_11;
  lowp float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_11 = tmpvar_13;
  mediump float arg1_14;
  arg1_14 = (_Shininess * 128.0);
  highp float tmpvar_15;
  tmpvar_15 = (pow (nh_11, arg1_14) * tmpvar_4.w);
  highp vec3 tmpvar_16;
  tmpvar_16 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_12) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_15)) * (atten_9 * 2.0));
  c_10.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_15) * atten_9));
  c_10.w = tmpvar_17;
  c_1.xyz = c_10.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_6;
  highp vec2 P_7;
  P_7 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_8;
  tmpvar_8 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_9;
  atten_9 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_7).w) * texture2D (_LightTextureB0, vec2(tmpvar_8)).w);
  lowp vec4 c_10;
  highp float nh_11;
  lowp float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_11 = tmpvar_13;
  mediump float arg1_14;
  arg1_14 = (_Shininess * 128.0);
  highp float tmpvar_15;
  tmpvar_15 = (pow (nh_11, arg1_14) * tmpvar_4.w);
  highp vec3 tmpvar_16;
  tmpvar_16 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_12) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_15)) * (atten_9 * 2.0));
  c_10.xyz = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_15) * atten_9));
  c_10.w = tmpvar_17;
  c_1.xyz = c_10.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 410
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 428
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
#line 406
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 416
#line 438
uniform highp vec4 _MainTex_ST;
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 439
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 442
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    #line 446
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex));
    #line 451
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec4(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 410
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 428
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
#line 406
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 416
#line 438
uniform highp vec4 _MainTex_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 398
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 394
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.5)).w;
}
#line 416
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 420
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 424
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 453
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 455
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 459
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 463
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), (((float((IN._LightCoord.z > 0.0)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.0));
    #line 467
    c.w = 0.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 18 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
add o3.xyz, -r0, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedahfobgabnnegkcahdlllfleapjihjhbkabaaaaaanmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcciaeaaaaeaaaabaaakabaaaafjaaaaae
egiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
hccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
aaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
aaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaa
dcaaaaakhccabaaaacaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaa
egadbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhccabaaaadaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaacaaaaaa
aaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaa
abaaaaaaaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaaaaaaaaaafaaaaaa
kgakbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhccabaaaafaaaaaaegiccaaa
aaaaaaaaagaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp float atten_8;
  atten_8 = (texture2D (_LightTextureB0, vec2(tmpvar_7)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  lowp vec4 c_9;
  highp float nh_10;
  lowp float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_10 = tmpvar_12;
  mediump float arg1_13;
  arg1_13 = (_Shininess * 128.0);
  highp float tmpvar_14;
  tmpvar_14 = (pow (nh_10, arg1_13) * tmpvar_4.w);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_11) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_14)) * (atten_8 * 2.0));
  c_9.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_14) * atten_8));
  c_9.w = tmpvar_16;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp float atten_8;
  atten_8 = (texture2D (_LightTextureB0, vec2(tmpvar_7)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  lowp vec4 c_9;
  highp float nh_10;
  lowp float tmpvar_11;
  tmpvar_11 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_10 = tmpvar_12;
  mediump float arg1_13;
  arg1_13 = (_Shininess * 128.0);
  highp float tmpvar_14;
  tmpvar_14 = (pow (nh_10, arg1_13) * tmpvar_4.w);
  highp vec3 tmpvar_15;
  tmpvar_15 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_11) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_14)) * (atten_8 * 2.0));
  c_9.xyz = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_14) * atten_8));
  c_9.w = tmpvar_16;
  c_1.xyz = c_9.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 402
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 397
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
#line 401
uniform mediump float _Shininess;
#line 408
#line 430
uniform highp vec4 _MainTex_ST;
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 431
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 434
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    #line 438
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    #line 443
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 402
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 420
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
#line 397
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
#line 401
uniform mediump float _Shininess;
#line 408
#line 430
uniform highp vec4 _MainTex_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 408
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 412
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 416
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 445
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 447
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 451
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 455
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), ((texture( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * texture( _LightTexture0, IN._LightCoord).w) * 1.0));
    #line 459
    c.w = 0.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 15 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"3.0-!!ARBvp1.0
# 17 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[15].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[14];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 14 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_3_0
; 17 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c14.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o2.z, r1, c6
dp3 o2.y, r1, c5
dp3 o2.x, r1, c4
mov o3.xyz, c13
add o4.xyz, -r0, c12
mad o1.xy, v2, c15, c15.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Matrix 48 [_LightMatrix0] 4
Vector 208 [_MainTex_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcogdgchabkpckoopffhhemjmonmepgahabaaaaaanaafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaabaaaaaaamadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcbmaeaaaaeaaaabaaahabaaaafjaaaaae
egiocaaaaaaaaaaaaoaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaa
gfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaaegiacaaaaaaaaaaa
aeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaaadaaaaaaagaabaaa
aaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaa
afaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaakmccabaaaabaaaaaa
agiecaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaagaebaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaa
aaaaaaaaanaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaacaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaa
adaaaaaaegiccaaaacaaaaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaa
egacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaaegacbaiaebaaaaaaaaaaaaaa
egiccaaaabaaaaaaaeaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  lightDir_2 = xlv_TEXCOORD2;
  lowp float atten_6;
  atten_6 = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  lowp vec4 c_7;
  highp float nh_8;
  lowp float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_8 = tmpvar_10;
  mediump float arg1_11;
  arg1_11 = (_Shininess * 128.0);
  highp float tmpvar_12;
  tmpvar_12 = (pow (nh_8, arg1_11) * tmpvar_4.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_9) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_12)) * (atten_6 * 2.0));
  c_7.xyz = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_12) * atten_6));
  c_7.w = tmpvar_14;
  c_1.xyz = c_7.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _SpecColor;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_3.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  lowp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * _Color);
  lightDir_2 = xlv_TEXCOORD2;
  lowp float atten_6;
  atten_6 = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  lowp vec4 c_7;
  highp float nh_8;
  lowp float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, lightDir_2));
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (xlv_TEXCOORD1, normalize((lightDir_2 + normalize(xlv_TEXCOORD3)))));
  nh_8 = tmpvar_10;
  mediump float arg1_11;
  arg1_11 = (_Shininess * 128.0);
  highp float tmpvar_12;
  tmpvar_12 = (pow (nh_8, arg1_11) * tmpvar_4.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = ((((tmpvar_5.xyz * _LightColor0.xyz) * tmpvar_9) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_12)) * (atten_6 * 2.0));
  c_7.xyz = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (tmpvar_5.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_12) * atten_6));
  c_7.w = tmpvar_14;
  c_1.xyz = c_7.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 419
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
#line 397
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 407
#line 429
uniform highp vec4 _MainTex_ST;
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 430
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 433
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    #line 437
    o.lightDir = lightDir;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    o.viewDir = viewDirForLight;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xy;
    #line 442
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out lowp vec3 xlv_TEXCOORD1;
out mediump vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec2 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.pack0);
    xlv_TEXCOORD1 = vec3(xl_retval.normal);
    xlv_TEXCOORD2 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD4 = vec2(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 419
struct v2f_surf {
    highp vec4 pos;
    highp vec2 pack0;
    lowp vec3 normal;
    mediump vec3 lightDir;
    mediump vec3 viewDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
#line 397
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 407
#line 429
uniform highp vec4 _MainTex_ST;
#line 360
lowp vec4 LightingBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in mediump vec3 viewDir, in lowp float atten ) {
    mediump vec3 h = normalize((lightDir + viewDir));
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    #line 364
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + ((_LightColor0.xyz * _SpecColor.xyz) * spec)) * (atten * 2.0));
    #line 368
    c.w = (s.Alpha + (((_LightColor0.w * _SpecColor.w) * spec) * atten));
    return c;
}
#line 407
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 411
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 415
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 444
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 446
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 450
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 454
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingBlinnPhong( o, lightDir, normalize(IN.viewDir), (texture( _LightTexture0, IN._LightCoord).w * 1.0));
    #line 458
    c.w = 0.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in lowp vec3 xlv_TEXCOORD1;
in mediump vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec2 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec2(xlv_TEXCOORD0);
    xlt_IN.normal = vec3(xlv_TEXCOORD1);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec2(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 41 to 52, TEX: 1 to 3
//   d3d9 - ALU: 54 to 63, TEX: 1 to 3
//   d3d11 - ALU: 32 to 41, TEX: 1 to 3, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
# 46 ALU, 2 TEX
PARAM c[9] = { program.local[0..6],
		{ 0, 128, 0.0055555557, 1 },
		{ 3.1415927, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, fragment.texcoord[2];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R1.x, fragment.texcoord[1], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MOV R1.w, c[4];
MAD R0.w, R1, c[7].z, c[7];
MAX R1.w, R0.x, c[7].x;
MOV R0.y, c[0];
MUL R0.z, R0.w, c[8].x;
MAD R0.z, R0.y, c[4], R0;
COS R0.w, R0.z;
ADD R0.x, fragment.texcoord[0], -c[4];
SIN R0.z, R0.z;
ADD R2.x, fragment.texcoord[0].y, -c[4].y;
MUL R2.y, R2.x, R0.z;
MUL R2.x, R0.w, R2;
MAD R2.y, R0.x, R0.w, -R2;
MAD R0.z, R0.x, R0, R2.x;
ADD R0.w, -R2.y, c[4].x;
MAD R0.x, R0.y, c[3], R0.w;
ADD R0.w, -R0.z, c[4].y;
MOV R0.z, c[7].y;
MUL R2.x, R0.z, c[6];
MAD R0.y, R0, c[3], R0.w;
TEX R0, R0, texture[0], 2D;
POW R1.w, R1.w, R2.x;
MUL R0.w, R1, R0;
MUL R0.xyz, R0, c[5];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
TEX R1.w, R1.w, texture[1], 2D;
MUL R0.xyz, R0, c[1];
MAX R1.x, R1, c[7];
MUL R1.xyz, R0, R1.x;
MOV R0.xyz, c[2];
MUL R0.xyz, R0, c[1];
MUL R1.w, R1, c[8].y;
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, R1.w;
MOV result.color.w, c[7].x;
END
# 46 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_3_0
; 58 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 0.00000000, 128.00000000, 0.00555556, 1.00000000
def c8, 3.14159274, 0.15915491, 0.50000000, 2.00000000
def c9, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.y, r0.x
dp3_pp r0.x, v3, v3
mul_pp r1.xyz, r0.y, v2
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r1.x, v1, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r0.x, v1, r0
mov r1.w, c4
mad r0.w, r1, c7.z, c7
mul r0.z, r0.w, c8.x
mov r0.y, c4.z
mad r0.y, c0, r0, r0.z
mad r0.z, r0.y, c8.y, c8
frc r0.z, r0
mov_pp r0.y, c6.x
mad r1.w, r0.z, c9.x, c9.y
max_pp r0.x, r0, c7
mul_pp r0.y, c7, r0
pow r2, r0.x, r0.y
sincos r0.xy, r1.w
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.w, r0.z, r0.x
add r0.z, v0.x, -c4.x
mad r0.y, r0.z, r0, r1.w
mad r0.z, r0, r0.x, -r0.w
mov r1.w, r2.x
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s0
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c1
max_pp r1.x, r1, c7
mul_pp r2.xyz, r0, r1.x
dp3 r0.x, v4, v4
mov_pp r1.xyz, c1
mul r0.w, r1, r0
texld r0.x, r0.x, s1
mul_pp r1.w, r0.x, c8
mul_pp r1.xyz, c2, r1
mad r0.xyz, r1, r0.w, r2
mul oC0.xyz, r0, r1.w
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 224 // 196 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
// 41 instructions, 3 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedejdhphehpofgmoieeinekcnkefncmoaaabaaaaaakmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcimafaaaa
eaaaaaaagdabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
baaaaaahccaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaa
aaaaaaaaagbjbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegbcbaaaaeaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaajgahbaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaabaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaabaaaaaahccaabaaa
aaaaaaaaegbcbaaaacaaaaaajgahbaaaaaaaaaaadeaaaaakdcaabaaaaaaaaaaa
egaabaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaaf
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaaiecaabaaaaaaaaaaaakiacaaa
aaaaaaaaamaaaaaaabeaaaaaaaaaaaeddiaaaaahccaabaaaaaaaaaaabkaabaaa
aaaaaaaackaabaaaaaaaaaaabjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakecaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalecaabaaaaaaaaaaackiacaaaaaaaaaaaaiaaaaaabkiacaaa
abaaaaaaaaaaaaaackaabaaaaaaaaaaaenaaaaahbcaabaaaabaaaaaabcaabaaa
acaaaaaackaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaafgbbbaaaabaaaaaa
fgibcaiaebaaaaaaaaaaaaaaaiaaaaaadiaaaaahdcaabaaaabaaaaaaagaabaaa
abaaaaaaogakbaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaadkaabaaaaaaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaaaaaaaaaa
ckaabaaaaaaaaaaaakaabaaaacaaaaaabkaabaaaabaaaaaaaaaaaaajecaabaaa
aaaaaaaackaabaiaebaaaaaaaaaaaaaabkiacaaaaaaaaaaaaiaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaa
ckaabaaaaaaaaaaaaaaaaaajecaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaa
akiacaaaaaaaaaaaaiaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
ahaaaaaabkiacaaaabaaaaaaaaaaaaaackaabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
ccaabaaaaaaaaaaabkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaajhcaabaaa
acaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadiaaaaah
ocaabaaaaaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaa
abaaaaaapgapbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhccabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
"3.0-!!ARBfp1.0
# 41 ALU, 1 TEX
PARAM c[9] = { program.local[0..6],
		{ 0, 128, 0.0055555557, 1 },
		{ 3.1415927, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV R1.xyz, fragment.texcoord[2];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MOV R1.w, c[4];
MAD R0.w, R1, c[7].z, c[7];
MAX R1.w, R0.x, c[7].x;
MOV R0.y, c[0];
MUL R0.z, R0.w, c[8].x;
MAD R0.z, R0.y, c[4], R0;
COS R0.w, R0.z;
ADD R0.x, fragment.texcoord[0], -c[4];
SIN R0.z, R0.z;
ADD R2.x, fragment.texcoord[0].y, -c[4].y;
MUL R2.y, R2.x, R0.z;
MUL R2.x, R0.w, R2;
MAD R2.y, R0.x, R0.w, -R2;
MAD R0.z, R0.x, R0, R2.x;
ADD R0.w, -R2.y, c[4].x;
MAD R0.x, R0.y, c[3], R0.w;
ADD R0.w, -R0.z, c[4].y;
MOV R0.z, c[7].y;
MUL R2.x, R0.z, c[6];
MAD R0.y, R0, c[3], R0.w;
TEX R0, R0, texture[0], 2D;
POW R1.w, R1.w, R2.x;
MUL R0.w, R1, R0;
DP3 R1.w, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[5];
MUL R1.xyz, R0, c[1];
MAX R1.w, R1, c[7].x;
MOV R0.xyz, c[2];
MUL R1.xyz, R1, R1.w;
MUL R0.xyz, R0, c[1];
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, c[8].y;
MOV result.color.w, c[7].x;
END
# 41 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
"ps_3_0
; 54 ALU, 1 TEX
dcl_2d s0
def c7, 0.00000000, 128.00000000, 0.00555556, 1.00000000
def c8, 3.14159274, 0.15915491, 0.50000000, 2.00000000
def c9, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3_pp r0.x, v3, v3
mov_pp r1.xyz, v2
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r0.x, v1, r0
mov r1.x, c4.w
mad r0.w, r1.x, c7.z, c7
mul r0.z, r0.w, c8.x
mov r0.y, c4.z
mad r0.y, c0, r0, r0.z
mad r0.z, r0.y, c8.y, c8
frc r0.z, r0
mov_pp r0.y, c6.x
max_pp r0.x, r0, c7
mul_pp r0.y, c7, r0
pow r1, r0.x, r0.y
mad r2.x, r0.z, c9, c9.y
sincos r0.xy, r2.x
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.y, r0.z, r0.x
add r0.z, v0.x, -c4.x
mad r0.y, r0.z, r0, r1
mad r0.z, r0, r0.x, -r0.w
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s0
mul r0.w, r1.x, r0
mov_pp r1.xyz, v2
dp3_pp r1.w, v1, r1
mul_pp r0.xyz, r0, c5
mul_pp r1.xyz, r0, c1
max_pp r1.w, r1, c7.x
mov_pp r0.xyz, c1
mul_pp r1.xyz, r1, r1.w
mul_pp r0.xyz, c2, r0
mad r0.xyz, r0, r0.w, r1
mul oC0.xyz, r0, c8.w
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 160 // 132 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
// 36 instructions, 3 temp regs, 0 temp arrays:
// ALU 32 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedjjhpclggnedphmkbeogmdiinmheogdedabaaaaaaneafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcmmaeaaaaeaaaaaaaddabaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaaagaabaaaaaaaaaaaegbcbaaa
adaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaaaaaaaeddiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakccaabaaaaaaaaaaadkiacaaaaaaaaaaa
aeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalccaabaaaaaaaaaaackiacaaa
aaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaenaaaaah
bcaabaaaabaaaaaabcaabaaaacaaaaaabkaabaaaaaaaaaaaaaaaaaajgcaabaaa
aaaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaaeaaaaaadiaaaaah
dcaabaaaabaaaaaaagaabaaaabaaaaaajgafbaaaaaaaaaaadcaaaaakecaabaaa
aaaaaaaackaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaiaebaaaaaaabaaaaaa
dcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaacaaaaaabkaabaaa
abaaaaaaaaaaaaajccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaabkiacaaa
aaaaaaaaaeaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaadaaaaaa
bkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaadcaaaaalbcaabaaa
abaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaa
abaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
ahaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
abaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaa
aaaaaaaaacaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaadaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaaj
hcaabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaahhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"3.0-!!ARBfp1.0
# 52 ALU, 3 TEX
PARAM c[9] = { program.local[0..6],
		{ 0, 128, 0.0055555557, 1 },
		{ 3.1415927, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, fragment.texcoord[2];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MOV R1.w, c[4];
MAD R0.w, R1, c[7].z, c[7];
MAX R1.w, R0.x, c[7].x;
MOV R0.y, c[0];
MUL R0.z, R0.w, c[8].x;
MAD R0.z, R0.y, c[4], R0;
COS R0.w, R0.z;
ADD R0.x, fragment.texcoord[0], -c[4];
SIN R0.z, R0.z;
ADD R2.x, fragment.texcoord[0].y, -c[4].y;
MUL R2.y, R2.x, R0.z;
MUL R2.x, R0.w, R2;
MAD R2.y, R0.x, R0.w, -R2;
ADD R0.w, -R2.y, c[4].x;
MAD R0.z, R0.x, R0, R2.x;
MAD R0.x, R0.y, c[3], R0.w;
ADD R0.w, -R0.z, c[4].y;
MOV R0.z, c[7].y;
MUL R2.x, R0.z, c[6];
MAD R0.y, R0, c[3], R0.w;
TEX R0, R0, texture[0], 2D;
POW R1.w, R1.w, R2.x;
MUL R2.x, R1.w, R0.w;
DP3 R0.w, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[5];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
MAX R0.w, R0, c[7].x;
MUL R0.xyz, R0, c[1];
MUL R1.xyz, R0, R0.w;
RCP R0.w, fragment.texcoord[4].w;
MOV R0.xyz, c[2];
MAD R2.zw, fragment.texcoord[4].xyxy, R0.w, c[8].y;
MUL R0.xyz, R0, c[1];
TEX R0.w, R2.zwzw, texture[1], 2D;
SLT R2.y, c[7].x, fragment.texcoord[4].z;
TEX R1.w, R1.w, texture[2], 2D;
MUL R0.w, R2.y, R0;
MUL R0.w, R0, R1;
MUL R0.w, R0, c[8].z;
MAD R0.xyz, R0, R2.x, R1;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, c[7].x;
END
# 52 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_3_0
; 63 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00000000, 128.00000000, 0.00555556, 1.00000000
def c8, 3.14159274, 0.15915491, 0.50000000, 2.00000000
def c9, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
dp3_pp r0.x, v2, v2
rsq_pp r0.y, r0.x
dp3_pp r0.x, v3, v3
mul_pp r1.xyz, r0.y, v2
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r0.x, v1, r0
mov r1.w, c4
mad r0.w, r1, c7.z, c7
mul r0.z, r0.w, c8.x
mov r0.y, c4.z
mad r0.y, c0, r0, r0.z
mad r0.z, r0.y, c8.y, c8
frc r0.z, r0
mov_pp r0.y, c6.x
mad r1.w, r0.z, c9.x, c9.y
max_pp r0.x, r0, c7
mul_pp r0.y, c7, r0
pow r2, r0.x, r0.y
sincos r0.xy, r1.w
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.w, r0.z, r0.x
add r0.z, v0.x, -c4.x
mad r0.y, r0.z, r0, r1.w
mad r0.z, r0, r0.x, -r0.w
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s0
mov r1.w, r2.x
mul r1.w, r1, r0
dp3_pp r0.w, v1, r1
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c1
max_pp r0.w, r0, c7.x
mul_pp r2.xyz, r0, r0.w
rcp r0.x, v4.w
mad r3.xy, v4, r0.x, c8.z
dp3 r0.x, v4, v4
texld r0.w, r3, s1
cmp r0.y, -v4.z, c7.x, c7.w
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s2
mul_pp r0.w, r0.y, r0.x
mov_pp r1.xyz, c1
mul_pp r0.xyz, c2, r1
mul_pp r0.w, r0, c8
mad r0.xyz, r0, r1.w, r2
mul oC0.xyz, r0, r0.w
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 224 // 196 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTexture0] 2D 0
SetTexture 2 [_LightTextureB0] 2D 1
// 47 instructions, 3 temp regs, 0 temp arrays:
// ALU 40 float, 0 int, 1 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedlgacobnopfnhbjejdomknhiofnpdimelabaaaaaaieahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcgeagaaaa
eaaaaaaajjabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaabaaaaaah
ccaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agbjbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegbcbaaaaeaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaa
jgahbaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaacaaaaaajgahbaaaaaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaa
amaaaaaaabeaaaaaaaaaaaeddiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
ckaabaaaaaaaaaaabjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
ecaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalecaabaaaaaaaaaaackiacaaaaaaaaaaaaiaaaaaabkiacaaaabaaaaaa
aaaaaaaackaabaaaaaaaaaaaenaaaaahbcaabaaaabaaaaaabcaabaaaacaaaaaa
ckaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaafgbbbaaaabaaaaaafgibcaia
ebaaaaaaaaaaaaaaaiaaaaaadiaaaaahdcaabaaaabaaaaaaagaabaaaabaaaaaa
ogakbaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaa
acaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaacaaaaaabkaabaaaabaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaabkiacaaaaaaaaaaaaiaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaa
bkiacaaaabaaaaaaaaaaaaaackaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaajhcaabaaaacaaaaaa
egiccaaaaaaaaaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaaoaaaaahdcaabaaa
abaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaaaaaaaaakdcaabaaaabaaaaaa
egaabaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaaaaaaaaa
dbaaaaahicaabaaaaaaaaaaaabeaaaaaaaaaaaaackbabaaaafaaaaaaabaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaiadpdiaaaaahicaabaaa
aaaaaaaadkaabaaaabaaaaaadkaabaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaa
egbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaapaaaaahicaabaaaaaaaaaaa
pgapbaaaaaaaaaaaagaabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaa
aaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"3.0-!!ARBfp1.0
# 48 ALU, 3 TEX
PARAM c[9] = { program.local[0..6],
		{ 0, 128, 0.0055555557, 1 },
		{ 3.1415927, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, fragment.texcoord[2];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MOV R1.w, c[4];
MAD R0.w, R1, c[7].z, c[7];
MAX R1.w, R0.x, c[7].x;
MOV R0.y, c[0];
MUL R0.z, R0.w, c[8].x;
MAD R0.z, R0.y, c[4], R0;
COS R0.w, R0.z;
ADD R0.x, fragment.texcoord[0], -c[4];
SIN R0.z, R0.z;
ADD R2.x, fragment.texcoord[0].y, -c[4].y;
MUL R2.y, R2.x, R0.z;
MUL R2.x, R0.w, R2;
MAD R2.y, R0.x, R0.w, -R2;
MAD R0.z, R0.x, R0, R2.x;
ADD R0.w, -R2.y, c[4].x;
MAD R0.x, R0.y, c[3], R0.w;
ADD R0.w, -R0.z, c[4].y;
MOV R0.z, c[7].y;
MUL R2.x, R0.z, c[6];
MAD R0.y, R0, c[3], R0.w;
TEX R0, R0, texture[0], 2D;
POW R1.w, R1.w, R2.x;
MUL R2.x, R1.w, R0.w;
DP3 R0.w, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[5];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
MAX R0.w, R0, c[7].x;
MUL R0.xyz, R0, c[1];
MUL R1.xyz, R0, R0.w;
MOV R0.xyz, c[2];
MUL R0.xyz, R0, c[1];
TEX R0.w, fragment.texcoord[4], texture[2], CUBE;
TEX R1.w, R1.w, texture[1], 2D;
MUL R0.w, R1, R0;
MUL R0.w, R0, c[8].y;
MAD R0.xyz, R0, R2.x, R1;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, c[7].x;
END
# 48 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_3_0
; 59 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c7, 0.00000000, 128.00000000, 0.00555556, 1.00000000
def c8, 3.14159274, 0.15915491, 0.50000000, 2.00000000
def c9, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dp3_pp r0.x, v2, v2
rsq_pp r0.y, r0.x
dp3_pp r0.x, v3, v3
mul_pp r1.xyz, r0.y, v2
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r0.x, v1, r0
mov r1.w, c4
mad r0.w, r1, c7.z, c7
mul r0.z, r0.w, c8.x
mov r0.y, c4.z
mad r0.y, c0, r0, r0.z
mad r0.z, r0.y, c8.y, c8
frc r0.z, r0
mov_pp r0.y, c6.x
mad r1.w, r0.z, c9.x, c9.y
max_pp r0.x, r0, c7
mul_pp r0.y, c7, r0
pow r2, r0.x, r0.y
sincos r0.xy, r1.w
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.w, r0.z, r0.x
add r0.z, v0.x, -c4.x
mad r0.y, r0.z, r0, r1.w
mad r0.z, r0, r0.x, -r0.w
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s0
mov r1.w, r2.x
mul r1.w, r1, r0
dp3_pp r0.w, v1, r1
mul_pp r0.xyz, r0, c5
mul_pp r0.xyz, r0, c1
max_pp r0.w, r0, c7.x
mul_pp r2.xyz, r0, r0.w
dp3 r0.x, v4, v4
texld r0.x, r0.x, s1
texld r0.w, v4, s2
mul r0.w, r0.x, r0
mov_pp r1.xyz, c1
mul_pp r0.xyz, c2, r1
mul_pp r0.w, r0, c8
mad r0.xyz, r0, r1.w, r2
mul oC0.xyz, r0, r0.w
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 224 // 196 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_LightTextureB0] 2D 1
SetTexture 2 [_LightTexture0] CUBE 0
// 42 instructions, 3 temp regs, 0 temp arrays:
// ALU 36 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedekloonniaoaghndefkeacebcnbkndphfabaaaaaaomagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmafaaaa
eaaaaaaahdabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafidaaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaabaaaaaah
ccaabaaaaaaaaaaaegbcbaaaadaaaaaaegbcbaaaadaaaaaaeeaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agbjbaaaadaaaaaadcaaaaajhcaabaaaabaaaaaaegbcbaaaaeaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaa
jgahbaaaaaaaaaaabaaaaaahccaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaaeeaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaabaaaaaabaaaaaahccaabaaaaaaaaaaa
egbcbaaaacaaaaaajgahbaaaaaaaaaaadeaaaaakdcaabaaaaaaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacpaaaaafccaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaaiecaabaaaaaaaaaaaakiacaaaaaaaaaaa
amaaaaaaabeaaaaaaaaaaaeddiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaa
ckaabaaaaaaaaaaabjaaaaafccaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
ecaabaaaaaaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahecaabaaaaaaaaaaackaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalecaabaaaaaaaaaaackiacaaaaaaaaaaaaiaaaaaabkiacaaaabaaaaaa
aaaaaaaackaabaaaaaaaaaaaenaaaaahbcaabaaaabaaaaaabcaabaaaacaaaaaa
ckaabaaaaaaaaaaaaaaaaaajmcaabaaaaaaaaaaafgbbbaaaabaaaaaafgibcaia
ebaaaaaaaaaaaaaaaiaaaaaadiaaaaahdcaabaaaabaaaaaaagaabaaaabaaaaaa
ogakbaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaa
acaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaacaaaaaabkaabaaaabaaaaaaaaaaaaajecaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaabkiacaaaaaaaaaaaaiaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaackaabaaa
aaaaaaaaaaaaaaajecaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaaakiacaaa
aaaaaaaaaiaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaahaaaaaa
bkiacaaaabaaaaaaaaaaaaaackaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaacaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaadkaabaaaabaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaalaaaaaadiaaaaaihcaabaaaabaaaaaa
egacbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaajhcaabaaaacaaaaaa
egiccaaaaaaaaaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadiaaaaahocaabaaa
aaaaaaaafgafbaaaaaaaaaaaagajbaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaa
egacbaaaabaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaa
pgapbaaaaaaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
acaaaaaaegbcbaaaafaaaaaaeghobaaaacaaaaaaaagabaaaaaaaaaaaapaaaaah
icaabaaaaaaaaaaaagaabaaaabaaaaaapgapbaaaacaaaaaadiaaaaahhccabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
# 43 ALU, 2 TEX
PARAM c[9] = { program.local[0..6],
		{ 0, 128, 0.0055555557, 1 },
		{ 3.1415927, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV R1.xyz, fragment.texcoord[2];
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R1.x, fragment.texcoord[1], R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, fragment.texcoord[1], R0;
MOV R1.w, c[4];
MAD R0.w, R1, c[7].z, c[7];
MAX R1.w, R0.x, c[7].x;
MOV R0.y, c[0];
MUL R0.z, R0.w, c[8].x;
MAD R0.z, R0.y, c[4], R0;
COS R0.w, R0.z;
ADD R0.x, fragment.texcoord[0], -c[4];
SIN R0.z, R0.z;
ADD R2.x, fragment.texcoord[0].y, -c[4].y;
MUL R2.y, R2.x, R0.z;
MUL R2.x, R0.w, R2;
MAD R2.y, R0.x, R0.w, -R2;
MAD R0.z, R0.x, R0, R2.x;
ADD R0.w, -R2.y, c[4].x;
MAD R0.x, R0.y, c[3], R0.w;
ADD R0.w, -R0.z, c[4].y;
MOV R0.z, c[7].y;
MUL R2.x, R0.z, c[6];
MAD R0.y, R0, c[3], R0.w;
TEX R0, R0, texture[0], 2D;
POW R1.w, R1.w, R2.x;
MUL R0.w, R1, R0;
MUL R0.xyz, R0, c[5];
TEX R1.w, fragment.texcoord[4], texture[1], 2D;
MUL R0.xyz, R0, c[1];
MAX R1.x, R1, c[7];
MUL R1.xyz, R0, R1.x;
MOV R0.xyz, c[2];
MUL R0.xyz, R0, c[1];
MUL R1.w, R1, c[8].y;
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, R1.w;
MOV result.color.w, c[7].x;
END
# 43 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_PanMT]
Vector 4 [_RotMT]
Vector 5 [_Color]
Float 6 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_3_0
; 56 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c7, 0.00000000, 128.00000000, 0.00555556, 1.00000000
def c8, 3.14159274, 0.15915491, 0.50000000, 2.00000000
def c9, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
dp3_pp r0.x, v3, v3
mov_pp r1.xyz, v2
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r0.x, v1, r0
mov r1.x, c4.w
mad r0.w, r1.x, c7.z, c7
mul r0.z, r0.w, c8.x
mov r0.y, c4.z
mad r0.y, c0, r0, r0.z
mad r0.z, r0.y, c8.y, c8
frc r0.z, r0
mov_pp r0.y, c6.x
max_pp r0.x, r0, c7
mul_pp r0.y, c7, r0
pow r1, r0.x, r0.y
mad r2.x, r0.z, c9, c9.y
sincos r0.xy, r2.x
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.y, r0.z, r0.x
add r0.z, v0.x, -c4.x
mad r0.y, r0.z, r0, r1
mad r0.z, r0, r0.x, -r0.w
mov r1.w, r1.x
mov_pp r1.xyz, v2
dp3_pp r1.x, v1, r1
mov r0.x, c3.y
add r0.y, -r0, c4
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c4.x
mov r0.x, c3
mad r0.x, c0.y, r0, r0.z
texld r0, r0, s0
mul r0.w, r1, r0
mul_pp r0.xyz, r0, c5
texld r1.w, v4, s1
mul_pp r0.xyz, r0, c1
max_pp r1.x, r1, c7
mul_pp r1.xyz, r0, r1.x
mov_pp r0.xyz, c1
mul_pp r0.xyz, c2, r0
mul_pp r1.w, r1, c8
mad r0.xyz, r0, r0.w, r1
mul oC0.xyz, r0, r1.w
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 224 // 196 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 32 [_SpecColor] 4
Vector 112 [_PanMT] 4
Vector 128 [_RotMT] 4
Vector 176 [_Color] 4
Float 192 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_LightTexture0] 2D 0
// 38 instructions, 3 temp regs, 0 temp arrays:
// ALU 33 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkidlgbdhidpdllkngkmdiijlnhaephalabaaaaaafeagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaakeaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdeafaaaa
eaaaaaaaenabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
aeaaaaaaegbcbaaaaeaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegbcbaaaaeaaaaaaagaabaaaaaaaaaaaegbcbaaa
adaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaai
ccaabaaaaaaaaaaaakiacaaaaaaaaaaaamaaaaaaabeaaaaaaaaaaaeddiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadcaaaaakccaabaaaaaaaaaaadkiacaaaaaaaaaaa
aiaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaabeaaaaanlapejeadcaaaaalccaabaaaaaaaaaaackiacaaa
aaaaaaaaaiaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaenaaaaah
bcaabaaaabaaaaaabcaabaaaacaaaaaabkaabaaaaaaaaaaaaaaaaaajgcaabaaa
aaaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaaiaaaaaadiaaaaah
dcaabaaaabaaaaaaagaabaaaabaaaaaajgafbaaaaaaaaaaadcaaaaakecaabaaa
aaaaaaaackaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaiaebaaaaaaabaaaaaa
dcaaaaajccaabaaaaaaaaaaabkaabaaaaaaaaaaaakaabaaaacaaaaaabkaabaaa
abaaaaaaaaaaaaajccaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaabkiacaaa
aaaaaaaaaiaaaaaadcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaahaaaaaa
bkiacaaaabaaaaaaaaaaaaaabkaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaa
ckaabaiaebaaaaaaaaaaaaaaakiacaaaaaaaaaaaaiaaaaaadcaaaaalbcaabaaa
abaaaaaaakiacaaaaaaaaaaaahaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaaa
abaaaaaadiaaaaaiocaabaaaaaaaaaaaagajbaaaabaaaaaaagijcaaaaaaaaaaa
alaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaaaaaaaaaaagijcaaaaaaaaaaa
abaaaaaadiaaaaajhcaabaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaaegiccaaa
aaaaaaaaacaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaacaaaaaaegbcbaaaadaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadcaaaaaj
hcaabaaaaaaaaaaajgahbaaaaaaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 8 to 8
//   d3d9 - ALU: 8 to 8
//   d3d11 - ALU: 8 to 8, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
"3.0-!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
"vs_3_0
; 8 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 2 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgoflhcgfinoonoplgmdiabihpafgdafabaaaaaaneacaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciaabaaaaeaaaabaagaaaaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
uniform mediump float _Shininess;
void main ()
{
  lowp vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = _Shininess;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
uniform mediump float _Shininess;
void main ()
{
  lowp vec4 res_1;
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = _Shininess;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 423
#line 423
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 427
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 423
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 430
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 432
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 436
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 440
    surf( surfIN, o);
    lowp vec4 res;
    res.xyz = ((o.Normal * 0.5) + 0.5);
    res.w = o.Specular;
    #line 444
    return res;
}
in lowp vec3 xlv_TEXCOORD0;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 0 to 0
//   d3d9 - ALU: 2 to 2
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Float 3 [_Shininess]
"3.0-!!ARBfp1.0
# 2 ALU, 0 TEX
PARAM c[5] = { program.local[0..3],
		{ 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[4].x, c[4].x;
MOV result.color.w, c[3].x;
END
# 2 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_Shininess]
"ps_3_0
; 2 ALU
def c1, 0.50000000, 0, 0, 0
dcl_texcoord0 v0.xyz
mad_pp oC0.xyz, v0, c1.x, c1.x
mov_pp oC0.w, c0.x
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 144 // 132 used size, 9 vars
Float 128 [_Shininess]
BindCB "$Globals" 0
// 3 instructions, 0 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedpmegmkhagfhhiddpfjnbnfpepcnapanaabaaaaaaeiabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiaaaaaa
eaaaaaaaccaaaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaagcbaaaadhcbabaaa
abaaaaaagfaaaaadpccabaaaaaaaaaaadcaaaaaphccabaaaaaaaaaaaegbcbaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaadgaaaaagiccabaaaaaaaaaaaakiacaaaaaaaaaaa
aiaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 21 to 29
//   d3d9 - ALU: 21 to 29
//   d3d11 - ALU: 21 to 24, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_Illum_ST]
"3.0-!!ARBvp1.0
# 29 ALU
PARAM c[20] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_Illum_ST]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c20, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c20.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c20.x
mul r0.y, r0, c8.x
add o3.xyz, r3, r2
mad o2.xy, r0.z, c9.zwzw, r0
mov o0, r1
mov o2.zw, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 192 // 176 used size, 12 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 28 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhpmflagmnhldofekjajhcmpooaghjmmjabaaaaaaleafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
daaeaaaaeaaaabaaamabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaa
ajaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
akaaaaaakgiocaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
acaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaa
aaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaia
ebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_10.w;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_11;
  lowp vec4 c_12;
  lowp float spec_13;
  mediump float tmpvar_14;
  tmpvar_14 = (tmpvar_10.w * tmpvar_5.w);
  spec_13 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_6.xyz * light_3.xyz) + ((light_3.xyz * _SpecColor.xyz) * spec_13));
  c_12.xyz = tmpvar_15;
  c_12.w = (tmpvar_6.w + (spec_13 * _SpecColor.w));
  c_2 = c_12;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_10.w;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_11;
  lowp vec4 c_12;
  lowp float spec_13;
  mediump float tmpvar_14;
  tmpvar_14 = (tmpvar_10.w * tmpvar_5.w);
  spec_13 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_6.xyz * light_3.xyz) + ((light_3.xyz * _SpecColor.xyz) * spec_13));
  c_12.xyz = tmpvar_15;
  c_12.w = (tmpvar_6.w + (spec_13 * _SpecColor.w));
  c_2 = c_12;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 425
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 438
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 427
v2f_surf vert_surf( in appdata_full v ) {
    #line 429
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 433
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 425
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 438
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 371
lowp vec4 LightingBlinnPhong_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    #line 373
    lowp float spec = (light.w * s.Gloss);
    lowp vec4 c;
    c.xyz = ((s.Albedo * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
    c.w = (s.Alpha + (spec * _SpecColor.w));
    #line 377
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 440
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 442
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 446
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 450
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 454
    light = (-log2(light));
    light.xyz += IN.vlight;
    mediump vec4 c = LightingBlinnPhong_PrePass( o, light);
    c.xyz += o.Emission;
    #line 458
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_Illum_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[18] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..17] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_Illum_ST]
"vs_3_0
; 21 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c18.x
mul r1.y, r1, c12.x
mad o2.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c18, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o2.zw, r0
mul o4.xyz, r1, c14.w
mad o1.zw, v1.xyxy, c17.xyxy, c17
mad o1.xy, v1, c16, c16.zwzw
mad o3.xy, v2, c15, c15.zwzw
mul o4.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 14 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 25 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedibmcldoojlddmbnjdpanppdjhmgnlkjoabaaaaaaleafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcbiaeaaaaeaaaabaa
agabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaa
baaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaa
egacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaa
bkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaa
acaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_2.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_2.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_7.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * _Color);
  highp vec2 tmpvar_10;
  tmpvar_10.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_10.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9.xyz * texture2D (_Illum, tmpvar_10).w);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_13.w;
  highp float tmpvar_14;
  tmpvar_14 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull_4 = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect_3 = tmpvar_16;
  light_6.xyz = (tmpvar_13.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_17;
  lowp float spec_18;
  mediump float tmpvar_19;
  tmpvar_19 = (tmpvar_13.w * tmpvar_8.w);
  spec_18 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = ((tmpvar_9.xyz * light_6.xyz) + ((light_6.xyz * _SpecColor.xyz) * spec_18));
  c_17.xyz = tmpvar_20;
  c_17.w = (tmpvar_9.w + (spec_18 * _SpecColor.w));
  c_2 = c_17;
  c_2.xyz = (c_2.xyz + tmpvar_11);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_2.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_2.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_7.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * _Color);
  highp vec2 tmpvar_10;
  tmpvar_10.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_10.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9.xyz * texture2D (_Illum, tmpvar_10).w);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_13.w;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  lmFull_4 = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  lmIndirect_3 = tmpvar_18;
  light_6.xyz = (tmpvar_13.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_19;
  lowp float spec_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_13.w * tmpvar_8.w);
  spec_20 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((tmpvar_9.xyz * light_6.xyz) + ((light_6.xyz * _SpecColor.xyz) * spec_20));
  c_19.xyz = tmpvar_22;
  c_19.w = (tmpvar_9.w + (spec_20 * _SpecColor.w));
  c_2 = c_19;
  c_2.xyz = (c_2.xyz + tmpvar_11);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 443
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 429
v2f_surf vert_surf( in appdata_full v ) {
    #line 431
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 435
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    #line 439
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 443
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 371
lowp vec4 LightingBlinnPhong_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    #line 373
    lowp float spec = (light.w * s.Gloss);
    lowp vec4 c;
    c.xyz = ((s.Albedo * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
    c.w = (s.Alpha + (spec * _SpecColor.w));
    #line 377
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 446
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 448
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 452
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 456
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 460
    light = (-log2(light));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    #line 464
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    #line 468
    mediump vec4 c = LightingBlinnPhong_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Matrix 5 [_World2Object]
Vector 11 [unity_Scale]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
Vector 14 [_Illum_ST]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[15] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[9];
MOV R1.w, c[0].y;
DP4 R2.z, R1, c[7];
DP4 R2.x, R1, c[5];
DP4 R2.y, R1, c[6];
MAD R1.xyz, R2, c[11].w, -vertex.position;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[10].x;
DP3 result.texcoord[3].y, R1, R3;
ADD result.texcoord[1].xy, R2, R2.z;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[12], c[12].zwzw;
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Matrix 4 [_World2Object]
Vector 11 [unity_Scale]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
Vector 14 [_Illum_ST]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c8
mov r1.w, c15.y
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r1.xyz, r2, c11.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c15.x
mul r2.y, r2, c9.x
dp3 o4.y, r1, r3
mad o2.xy, r2.z, c10.zwzw, r2
dp3 o4.z, v2, r1
dp3 o4.x, r1, v1
mov o0, r0
mov o2.zw, r0
mad o1.zw, v3.xyxy, c14.xyxy, c14
mad o1.xy, v3, c13, c13.zwzw
mad o3.xy, v4, c12, c12.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 14 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedpcmdkmpdafnmbkonjamieiejgphkooapabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
diaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaa
bbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
acaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaal
hcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaia
ebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = o_5;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize(xlv_TEXCOORD3);
  mediump vec4 tmpvar_11;
  mediump vec3 viewDir_12;
  viewDir_12 = tmpvar_10;
  highp float nh_13;
  mediump vec3 scalePerBasisVector_14;
  mediump vec3 lm_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_15 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  scalePerBasisVector_14 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, normalize((normalize((((scalePerBasisVector_14.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_14.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_14.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_12)).z);
  nh_13 = tmpvar_18;
  mediump float arg1_19;
  arg1_19 = (_Shininess * 128.0);
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = lm_15;
  tmpvar_20.w = pow (nh_13, arg1_19);
  tmpvar_11 = tmpvar_20;
  mediump vec4 tmpvar_21;
  tmpvar_21 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_11);
  light_3 = tmpvar_21;
  lowp vec4 c_22;
  lowp float spec_23;
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_21.w * tmpvar_5.w);
  spec_23 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_6.xyz * tmpvar_21.xyz) + ((tmpvar_21.xyz * _SpecColor.xyz) * spec_23));
  c_22.xyz = tmpvar_25;
  c_22.w = (tmpvar_6.w + (spec_23 * _SpecColor.w));
  c_2 = c_22;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = o_5;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD3);
  mediump vec4 tmpvar_13;
  mediump vec3 viewDir_14;
  viewDir_14 = tmpvar_12;
  highp float nh_15;
  mediump vec3 scalePerBasisVector_16;
  mediump vec3 lm_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  lm_17 = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_11.w) * tmpvar_11.xyz);
  scalePerBasisVector_16 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, normalize((normalize((((scalePerBasisVector_16.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_16.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_16.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_14)).z);
  nh_15 = tmpvar_20;
  mediump float arg1_21;
  arg1_21 = (_Shininess * 128.0);
  highp vec4 tmpvar_22;
  tmpvar_22.xyz = lm_17;
  tmpvar_22.w = pow (nh_15, arg1_21);
  tmpvar_13 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_13);
  light_3 = tmpvar_23;
  lowp vec4 c_24;
  lowp float spec_25;
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_23.w * tmpvar_5.w);
  spec_25 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_6.xyz * tmpvar_23.xyz) + ((tmpvar_23.xyz * _SpecColor.xyz) * spec_25));
  c_24.xyz = tmpvar_27;
  c_24.w = (tmpvar_6.w + (spec_25 * _SpecColor.w));
  c_2 = c_24;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
#line 443
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 447
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 429
v2f_surf vert_surf( in appdata_full v ) {
    #line 431
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 435
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 439
    o.viewDir = (rotation * ObjSpaceViewDir( v.vertex));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
#line 443
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 447
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 379
mediump vec4 LightingBlinnPhong_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 viewDir, in bool surfFuncWritesNormal, out mediump vec3 specColor ) {
    #line 381
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    mediump vec3 lightDir = normalize((((scalePerBasisVector.x * xll_matrixindex_mf3x3_i (unity_DirBasis, 0)) + (scalePerBasisVector.y * xll_matrixindex_mf3x3_i (unity_DirBasis, 1))) + (scalePerBasisVector.z * xll_matrixindex_mf3x3_i (unity_DirBasis, 2))));
    #line 385
    mediump vec3 h = normalize((lightDir + viewDir));
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = pow( nh, (s.Specular * 128.0));
    specColor = (((lm * _SpecColor.xyz) * s.Gloss) * spec);
    #line 389
    return vec4( lm, spec);
}
#line 371
lowp vec4 LightingBlinnPhong_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    #line 373
    lowp float spec = (light.w * s.Gloss);
    lowp vec4 c;
    c.xyz = ((s.Albedo * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
    c.w = (s.Alpha + (spec * _SpecColor.w));
    #line 377
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 447
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 451
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 455
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 459
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    o.Normal = vec3( 0.0, 0.0, 1.0);
    #line 463
    mediump vec3 specColor;
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingBlinnPhong_DirLightmap( o, lmtex, lmIndTex, normalize(IN.viewDir), false, specColor);
    #line 467
    light += lm;
    mediump vec4 c = LightingBlinnPhong_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_Illum_ST]
"3.0-!!ARBvp1.0
# 29 ALU
PARAM c[20] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_Illum_ST]
"vs_3_0
; 29 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c20, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c20.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c20.x
mul r0.y, r0, c8.x
add o3.xyz, r3, r2
mad o2.xy, r0.z, c9.zwzw, r0
mov o0, r1
mov o2.zw, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 192 // 176 used size, 12 vars
Vector 144 [_MainTex_ST] 4
Vector 160 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 28 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhpmflagmnhldofekjajhcmpooaghjmmjabaaaaaaleafaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
daaeaaaaeaaaabaaamabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaae
egiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaae
egiocaaaadaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaa
ajaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
akaaaaaakgiocaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
acaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
adaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaa
aaaaaaaaabeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaa
cgaaaaaaegaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaa
chaaaaaaegaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaa
ciaaaaaaegaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaa
egakbaaaaaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaa
egaobaaaacaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaa
egaobaaaacaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaa
egaobaaaacaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
adaaaaaadiaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaia
ebaaaaaaaaaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaacaaaaaacmaaaaaa
agaabaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_10.w;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_11;
  lowp vec4 c_12;
  lowp float spec_13;
  mediump float tmpvar_14;
  tmpvar_14 = (tmpvar_10.w * tmpvar_5.w);
  spec_13 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_6.xyz * light_3.xyz) + ((light_3.xyz * _SpecColor.xyz) * spec_13));
  c_12.xyz = tmpvar_15;
  c_12.w = (tmpvar_6.w + (spec_13 * _SpecColor.w));
  c_2 = c_12;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_10.w;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_11;
  lowp vec4 c_12;
  lowp float spec_13;
  mediump float tmpvar_14;
  tmpvar_14 = (tmpvar_10.w * tmpvar_5.w);
  spec_13 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_6.xyz * light_3.xyz) + ((light_3.xyz * _SpecColor.xyz) * spec_13));
  c_12.xyz = tmpvar_15;
  c_12.w = (tmpvar_6.w + (spec_13 * _SpecColor.w));
  c_2 = c_12;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 425
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 438
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 427
v2f_surf vert_surf( in appdata_full v ) {
    #line 429
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 433
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 425
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
#line 438
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 371
lowp vec4 LightingBlinnPhong_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    #line 373
    lowp float spec = (light.w * s.Gloss);
    lowp vec4 c;
    c.xyz = ((s.Albedo * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
    c.w = (s.Alpha + (spec * _SpecColor.w));
    #line 377
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 440
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 442
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 446
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 450
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 454
    light.xyz += IN.vlight;
    mediump vec4 c = LightingBlinnPhong_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.vlight = vec3(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_Illum_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[18] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..17] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_Illum_ST]
"vs_3_0
; 21 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c18, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c18.x
mul r1.y, r1, c12.x
mad o2.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c18, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o2.zw, r0
mul o4.xyz, r1, c14.w
mad o1.zw, v1.xyxy, c17.xyxy, c17
mad o1.xy, v1, c16, c16.zwzw
mad o3.xy, v2, c15, c15.zwzw
mul o4.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 14 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 25 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedibmcldoojlddmbnjdpanppdjhmgnlkjoabaaaaaaleafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcbiaeaaaaeaaaabaa
agabaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaa
baaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaad
dcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaaadaaaaaagfaaaaad
pccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaaiccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaa
agahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaaf
mccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaa
abaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaaegbabaaaaeaaaaaa
egiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaa
dcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaiaebaaaaaaacaaaaaabjaaaaaadiaaaaaihccabaaaaeaaaaaa
egacbaaaaaaaaaaapgipcaaaacaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaa
bkbabaaaaaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaa
ckiacaaaadaaaaaaaeaaaaaaakbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaackiacaaaadaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaa
aaaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaa
aaaaaaaaakaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaa
acaaaaaabjaaaaaaabeaaaaaaaaaiadpdiaaaaaiiccabaaaaeaaaaaabkaabaaa
aaaaaaaaakaabaiaebaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_2.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_2.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_7.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * _Color);
  highp vec2 tmpvar_10;
  tmpvar_10.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_10.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9.xyz * texture2D (_Illum, tmpvar_10).w);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_13.w;
  highp float tmpvar_14;
  tmpvar_14 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_14;
  lowp vec3 tmpvar_15;
  tmpvar_15 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull_4 = tmpvar_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect_3 = tmpvar_16;
  light_6.xyz = (tmpvar_13.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_17;
  lowp float spec_18;
  mediump float tmpvar_19;
  tmpvar_19 = (tmpvar_13.w * tmpvar_8.w);
  spec_18 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = ((tmpvar_9.xyz * light_6.xyz) + ((light_6.xyz * _SpecColor.xyz) * spec_18));
  c_17.xyz = tmpvar_20;
  c_17.w = (tmpvar_9.w + (spec_18 * _SpecColor.w));
  c_2 = c_17;
  c_2.xyz = (c_2.xyz + tmpvar_11);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  tmpvar_2.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_2.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = o_4;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_7.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * _Color);
  highp vec2 tmpvar_10;
  tmpvar_10.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_10.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9.xyz * texture2D (_Illum, tmpvar_10).w);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_6 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_13.w;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp float tmpvar_16;
  tmpvar_16 = ((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((8.0 * tmpvar_14.w) * tmpvar_14.xyz);
  lmFull_4 = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_15.w) * tmpvar_15.xyz);
  lmIndirect_3 = tmpvar_18;
  light_6.xyz = (tmpvar_13.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_19;
  lowp float spec_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_13.w * tmpvar_8.w);
  spec_20 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = ((tmpvar_9.xyz * light_6.xyz) + ((light_6.xyz * _SpecColor.xyz) * spec_20));
  c_19.xyz = tmpvar_22;
  c_19.w = (tmpvar_9.w + (spec_20 * _SpecColor.w));
  c_2 = c_19;
  c_2.xyz = (c_2.xyz + tmpvar_11);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 443
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 429
v2f_surf vert_surf( in appdata_full v ) {
    #line 431
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 435
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    #line 439
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
#line 443
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 371
lowp vec4 LightingBlinnPhong_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    #line 373
    lowp float spec = (light.w * s.Gloss);
    lowp vec4 c;
    c.xyz = ((s.Albedo * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
    c.w = (s.Alpha + (spec * _SpecColor.w));
    #line 377
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 446
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 448
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    #line 452
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 456
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 460
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    #line 464
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    mediump vec4 c = LightingBlinnPhong_PrePass( o, light);
    #line 468
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Matrix 5 [_World2Object]
Vector 11 [unity_Scale]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
Vector 14 [_Illum_ST]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[15] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[9];
MOV R1.w, c[0].y;
DP4 R2.z, R1, c[7];
DP4 R2.x, R1, c[5];
DP4 R2.y, R1, c[6];
MAD R1.xyz, R2, c[11].w, -vertex.position;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[10].x;
DP3 result.texcoord[3].y, R1, R3;
ADD result.texcoord[1].xy, R2, R2.z;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[12], c[12].zwzw;
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Matrix 4 [_World2Object]
Vector 11 [unity_Scale]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
Vector 14 [_Illum_ST]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c8
mov r1.w, c15.y
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r1.xyz, r2, c11.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c15.x
mul r2.y, r2, c9.x
dp3 o4.y, r1, r3
mad o2.xy, r2.z, c10.zwzw, r2
dp3 o4.z, v2, r1
dp3 o4.x, r1, v1
mov o0, r0
mov o2.zw, r0
mad o1.zw, v3.xyxy, c14.xyxy, c14
mad o1.xy, v3, c13, c13.zwzw
mad o3.xy, v4, c12, c12.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 14 vars
Vector 144 [unity_LightmapST] 4
Vector 160 [_MainTex_ST] 4
Vector 176 [_Illum_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedpcmdkmpdafnmbkonjamieiejgphkooapabaaaaaaiaafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadpcbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
acaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
diaaaaahhcaabaaaaaaaaaaajgbebaaaabaaaaaacgbjbaaaacaaaaaadcaaaaak
hcaabaaaaaaaaaaajgbebaaaacaaaaaacgbjbaaaabaaaaaaegacbaiaebaaaaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgbpbaaaabaaaaaa
diaaaaajhcaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaa
bbaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaa
abaaaaaaaeaaaaaaegacbaaaabaaaaaadcaaaaalhcaabaaaabaaaaaaegiccaaa
acaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaabaaaaaaaaaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaal
hcaabaaaabaaaaaaegacbaaaabaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaia
ebaaaaaaaaaaaaaabaaaaaahcccabaaaaeaaaaaaegacbaaaaaaaaaaaegacbaaa
abaaaaaabaaaaaahbccabaaaaeaaaaaaegbcbaaaabaaaaaaegacbaaaabaaaaaa
baaaaaaheccabaaaaeaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = o_5;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize(xlv_TEXCOORD3);
  mediump vec4 tmpvar_11;
  mediump vec3 viewDir_12;
  viewDir_12 = tmpvar_10;
  highp float nh_13;
  mediump vec3 scalePerBasisVector_14;
  mediump vec3 lm_15;
  lowp vec3 tmpvar_16;
  tmpvar_16 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_15 = tmpvar_16;
  lowp vec3 tmpvar_17;
  tmpvar_17 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  scalePerBasisVector_14 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, normalize((normalize((((scalePerBasisVector_14.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_14.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_14.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_12)).z);
  nh_13 = tmpvar_18;
  mediump float arg1_19;
  arg1_19 = (_Shininess * 128.0);
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = lm_15;
  tmpvar_20.w = pow (nh_13, arg1_19);
  tmpvar_11 = tmpvar_20;
  mediump vec4 tmpvar_21;
  tmpvar_21 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_11);
  light_3 = tmpvar_21;
  lowp vec4 c_22;
  lowp float spec_23;
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_21.w * tmpvar_5.w);
  spec_23 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_6.xyz * tmpvar_21.xyz) + ((tmpvar_21.xyz * _SpecColor.xyz) * spec_23));
  c_22.xyz = tmpvar_25;
  c_22.w = (tmpvar_6.w + (spec_23 * _SpecColor.w));
  c_2 = c_22;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = o_5;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform mediump float _Shininess;
uniform lowp vec4 _Color;
uniform highp vec4 _RotIL;
uniform highp vec4 _PanIL;
uniform sampler2D _Illum;
uniform highp vec4 _RotMT;
uniform highp vec4 _PanMT;
uniform sampler2D _MainTex;
uniform lowp vec4 _SpecColor;
uniform highp vec4 _Time;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = ((_RotMT.x - (((xlv_TEXCOORD0.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((xlv_TEXCOORD0.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y));
  tmpvar_4.y = ((_RotMT.y - (((xlv_TEXCOORD0.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((xlv_TEXCOORD0.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y));
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  highp vec2 tmpvar_7;
  tmpvar_7.x = ((_RotIL.x - (((xlv_TEXCOORD0.z - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((xlv_TEXCOORD0.w - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y));
  tmpvar_7.y = ((_RotIL.y - (((xlv_TEXCOORD0.z - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((xlv_TEXCOORD0.w - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y));
  lowp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_6.xyz * texture2D (_Illum, tmpvar_7).w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(xlv_TEXCOORD3);
  mediump vec4 tmpvar_13;
  mediump vec3 viewDir_14;
  viewDir_14 = tmpvar_12;
  highp float nh_15;
  mediump vec3 scalePerBasisVector_16;
  mediump vec3 lm_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  lm_17 = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = ((8.0 * tmpvar_11.w) * tmpvar_11.xyz);
  scalePerBasisVector_16 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = max (0.0, normalize((normalize((((scalePerBasisVector_16.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_16.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_16.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir_14)).z);
  nh_15 = tmpvar_20;
  mediump float arg1_21;
  arg1_21 = (_Shininess * 128.0);
  highp vec4 tmpvar_22;
  tmpvar_22.xyz = lm_17;
  tmpvar_22.w = pow (nh_15, arg1_21);
  tmpvar_13 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_13);
  light_3 = tmpvar_23;
  lowp vec4 c_24;
  lowp float spec_25;
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_23.w * tmpvar_5.w);
  spec_25 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_6.xyz * tmpvar_23.xyz) + ((tmpvar_23.xyz * _SpecColor.xyz) * spec_25));
  c_24.xyz = tmpvar_27;
  c_24.w = (tmpvar_6.w + (spec_25 * _SpecColor.w));
  c_2 = c_24;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
#line 443
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 447
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 429
v2f_surf vert_surf( in appdata_full v ) {
    #line 431
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _Illum_ST.xy) + _Illum_ST.zw);
    #line 435
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 binormal = (cross( v.normal, v.tangent.xyz) * v.tangent.w);
    highp mat3 rotation = xll_transpose_mf3x3(mat3( v.tangent.xyz, binormal, v.normal));
    #line 439
    o.viewDir = (rotation * ObjSpaceViewDir( v.vertex));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.screen);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec3(xl_retval.viewDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 399
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_Illum;
};
#line 417
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec3 viewDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _MainTex;
uniform highp vec4 _PanMT;
#line 393
uniform highp vec4 _RotMT;
uniform sampler2D _Illum;
uniform highp vec4 _PanIL;
uniform highp vec4 _RotIL;
#line 397
uniform lowp vec4 _Color;
uniform mediump float _Shininess;
#line 405
#line 426
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform sampler2D _LightBuffer;
#line 443
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 447
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 379
mediump vec4 LightingBlinnPhong_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 viewDir, in bool surfFuncWritesNormal, out mediump vec3 specColor ) {
    #line 381
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    mediump vec3 lightDir = normalize((((scalePerBasisVector.x * xll_matrixindex_mf3x3_i (unity_DirBasis, 0)) + (scalePerBasisVector.y * xll_matrixindex_mf3x3_i (unity_DirBasis, 1))) + (scalePerBasisVector.z * xll_matrixindex_mf3x3_i (unity_DirBasis, 2))));
    #line 385
    mediump vec3 h = normalize((lightDir + viewDir));
    highp float nh = max( 0.0, dot( s.Normal, h));
    highp float spec = pow( nh, (s.Specular * 128.0));
    specColor = (((lm * _SpecColor.xyz) * s.Gloss) * spec);
    #line 389
    return vec4( lm, spec);
}
#line 371
lowp vec4 LightingBlinnPhong_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    #line 373
    lowp float spec = (light.w * s.Gloss);
    lowp vec4 c;
    c.xyz = ((s.Albedo * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
    c.w = (s.Alpha + (spec * _SpecColor.w));
    #line 377
    return c;
}
#line 405
void surf( in Input IN, inout SurfaceOutput o ) {
    highp vec2 UV_PanMT = vec2( ((_RotMT.x - (((IN.uv_MainTex.x - _RotMT.x) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) - ((IN.uv_MainTex.y - _RotMT.y) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.x * _Time.y)), ((_RotMT.y - (((IN.uv_MainTex.x - _RotMT.x) * sin(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))) + ((IN.uv_MainTex.y - _RotMT.y) * cos(((_RotMT.z * _Time.y) + (3.14159 * (1.0 + (_RotMT.w / 180.0)))))))) + (_PanMT.y * _Time.y)));
    lowp vec4 tex = texture( _MainTex, UV_PanMT);
    #line 409
    lowp vec4 c = (tex * _Color);
    o.Albedo = c.xyz;
    highp vec2 UV_PanIL = vec2( ((_RotIL.x - (((IN.uv_Illum.x - _RotIL.x) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) - ((IN.uv_Illum.y - _RotIL.y) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.x * _Time.y)), ((_RotIL.y - (((IN.uv_Illum.x - _RotIL.x) * sin(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))) + ((IN.uv_Illum.y - _RotIL.y) * cos(((_RotIL.z * _Time.y) + (3.14159 * (1.0 + (_RotIL.w / 180.0)))))))) + (_PanIL.y * _Time.y)));
    o.Emission = (c.xyz * texture( _Illum, UV_PanIL).w);
    #line 413
    o.Gloss = tex.w;
    o.Alpha = c.w;
    o.Specular = _Shininess;
}
#line 447
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 451
    surfIN.uv_Illum = IN.pack0.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 455
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 459
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    o.Normal = vec3( 0.0, 0.0, 1.0);
    mediump vec3 specColor;
    #line 463
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingBlinnPhong_DirLightmap( o, lmtex, lmIndTex, normalize(IN.viewDir), false, specColor);
    light += lm;
    #line 467
    mediump vec4 c = LightingBlinnPhong_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.screen = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 45 to 71, TEX: 3 to 5
//   d3d9 - ALU: 65 to 92, TEX: 3 to 5
//   d3d11 - ALU: 29 to 51, TEX: 3 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
"3.0-!!ARBfp1.0
# 49 ALU, 3 TEX
PARAM c[8] = { program.local[0..6],
		{ 0.0055555557, 3.1415927, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TXP R1, fragment.texcoord[1], texture[2], 2D;
MOV R0.w, c[3];
MOV R2.w, c[0].y;
LG2 R0.x, R1.x;
LG2 R0.y, R1.y;
LG2 R0.z, R1.z;
ADD R1.xyz, -R0, fragment.texcoord[2];
MAD R0.w, R0, c[7].x, c[7].z;
MUL R0.x, R0.w, c[7].y;
MAD R0.x, R2.w, c[3].z, R0;
SIN R0.z, R0.x;
ADD R0.y, fragment.texcoord[0], -c[3];
COS R0.x, R0.x;
MUL R3.x, R0, R0.y;
MUL R0.w, R0.y, R0.z;
ADD R0.y, fragment.texcoord[0].x, -c[3].x;
MAD R0.x, R0.y, R0, -R0.w;
MAD R0.y, R0, R0.z, R3.x;
ADD R0.x, -R0, c[3];
ADD R0.y, -R0, c[3];
MOV R3.x, c[5].w;
MAD R3.x, R3, c[7], c[7].z;
MUL R3.x, R3, c[7].y;
MAD R3.x, R2.w, c[5].z, R3;
COS R3.y, R3.x;
SIN R3.z, R3.x;
ADD R3.x, fragment.texcoord[0].w, -c[5].y;
MUL R3.w, R3.x, R3.z;
MUL R4.x, R3.y, R3;
ADD R3.x, fragment.texcoord[0].z, -c[5];
MAD R3.z, R3.x, R3, R4.x;
MAD R3.x, R3, R3.y, -R3.w;
ADD R3.y, -R3.z, c[5];
ADD R3.x, -R3, c[5];
MAD R3.y, R2.w, c[4], R3;
MAD R3.x, R2.w, c[4], R3;
MAD R0.x, R2.w, c[2], R0;
MAD R0.y, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
LG2 R1.w, R1.w;
MUL R1.w, R0, -R1;
MUL R0, R0, c[6];
MUL R2.xyz, R1, c[1];
TEX R2.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R2.w;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R1, c[1], R0;
END
# 49 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
"ps_3_0
; 69 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00555556, 1.00000000, 3.14159274, 0
def c8, 0.15915491, 0.50000000, 6.28318501, -3.14159298
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
texldp r2, v1, s2
mov r0.x, c3.w
mad r0.x, r0, c7, c7.y
mul r0.y, r0.x, c7.z
mov r0.x, c3.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c8, c8.y
frc r0.x, r0
mad r1.x, r0, c8.z, c8.w
sincos r0.xy, r1.x
log_pp r1.x, r2.x
log_pp r1.z, r2.z
log_pp r1.y, r2.y
add_pp r2.xyz, -r1, v2
add r1.y, v0, -c3
mul r0.w, r1.y, r0.y
add r0.z, v0.x, -c3.x
mad r0.w, r0.z, r0.x, -r0
add r1.x, -r0.w, c3
mov r0.w, c2.x
mad r1.x, c0.y, r0.w, r1
mul r0.x, r1.y, r0
mad r0.x, r0.z, r0.y, r0
add r0.y, -r0.x, c3
mov r0.w, c5
mad r0.z, r0.w, c7.x, c7.y
mov r0.x, c5.z
mul r0.z, r0, c7
mad r0.z, c0.y, r0.x, r0
mov r0.x, c2.y
mad r1.y, c0, r0.x, r0
mad r0.x, r0.z, c8, c8.y
frc r0.y, r0.x
texld r1, r1, s0
log_pp r0.x, r2.w
mad r3.w, r0.y, c8.z, c8
mul_pp r2.w, r1, -r0.x
sincos r0.xy, r3.w
add r0.w, v0, -c5.y
mul_pp r3.xyz, r2, c1
mul r3.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r3.w
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r3.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r3.w
mul_pp r3.xyz, r3, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mad_pp oC0.w, r2, c1, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 192 // 128 used size, 12 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [_LightBuffer] 2D 2
// 36 instructions, 4 temp regs, 0 temp arrays:
// ALU 30 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecediegocojiieiljkaabbfhbiiimggnenieabaaaaaahiagaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefciiafaaaaeaaaaaaagcabaaaafjaaaaaeegiocaaa
aaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadlcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
afaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadcaaaaak
bcaabaaaaaaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaafgbebaaaabaaaaaafgiecaia
ebaaaaaaaaaaaaaaaeaaaaaadiaaaaahgcaabaaaabaaaaaaagaabaaaaaaaaaaa
fgagbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaa
abaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaajdcaabaaaaaaaaaaa
egaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaoaaaaahdcaabaaaaaaaaaaa
egbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaacpaaaaafpcaabaaaacaaaaaa
egaobaaaacaaaaaadiaaaaaibcaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaia
ebaaaaaaacaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaaabaaaaaaegiocaaa
aaaaaaaaahaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaiaebaaaaaaacaaaaaa
egbcbaaaadaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaaegiccaaa
aaaaaaaaacaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaaaaaaaaaegacbaaa
adaaaaaadcaaaaakiccabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaaaaaaaaaa
acaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaacaaaaaaegacbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
abaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 60 ALU, 5 TEX
PARAM c[9] = { program.local[0..7],
		{ 0.0055555557, 3.1415927, 1, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R1, fragment.texcoord[2], texture[3], 2D;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
DP4 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MOV R2.w, c[0].y;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0, c[8].w;
MAD R2.xyz, R1, c[8].w, -R0;
TXP R1, fragment.texcoord[1], texture[2], 2D;
MAD_SAT R0.w, R0, c[7].z, c[7];
MAD R0.xyz, R0.w, R2, R0;
MOV R0.w, c[3];
MAD R0.w, R0, c[8].x, c[8].z;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
ADD R1.xyz, -R1, R0;
MUL R0.x, R0.w, c[8].y;
MAD R0.x, R2.w, c[3].z, R0;
SIN R0.z, R0.x;
ADD R0.y, fragment.texcoord[0], -c[3];
COS R0.x, R0.x;
MUL R3.x, R0, R0.y;
MUL R0.w, R0.y, R0.z;
ADD R0.y, fragment.texcoord[0].x, -c[3].x;
MAD R0.x, R0.y, R0, -R0.w;
MAD R0.y, R0, R0.z, R3.x;
ADD R0.x, -R0, c[3];
ADD R0.y, -R0, c[3];
MOV R3.x, c[5].w;
MAD R3.x, R3, c[8], c[8].z;
MUL R3.x, R3, c[8].y;
MAD R3.x, R2.w, c[5].z, R3;
COS R3.y, R3.x;
SIN R3.z, R3.x;
ADD R3.x, fragment.texcoord[0].w, -c[5].y;
MUL R3.w, R3.x, R3.z;
MUL R4.x, R3.y, R3;
ADD R3.x, fragment.texcoord[0].z, -c[5];
MAD R3.z, R3.x, R3, R4.x;
MAD R3.x, R3, R3.y, -R3.w;
ADD R3.y, -R3.z, c[5];
ADD R3.x, -R3, c[5];
MAD R3.y, R2.w, c[4], R3;
MAD R3.x, R2.w, c[4], R3;
MAD R0.x, R2.w, c[2], R0;
MAD R0.y, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
LG2 R1.w, R1.w;
MUL R1.w, R0, -R1;
MUL R0, R0, c[6];
MUL R2.xyz, R1, c[1];
TEX R2.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R2.w;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R1, c[1], R0;
END
# 60 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 78 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c8, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c9, 0.15915491, 0.50000000, 6.28318501, -3.14159298
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
texld r1, v2, s4
texld r0, v2, s3
mul_pp r1.xyz, r1.w, r1
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1, c8.w
mov r0.w, c3
mad r0.w, r0, c8.x, c8.y
mul r1.w, r0, c8.z
mov r0.w, c3.z
mad r0.w, c0.y, r0, r1
dp4 r2.x, v3, v3
rsq r1.w, r2.x
texldp r2, v1, s2
mad r0.w, r0, c9.x, c9.y
rcp r1.w, r1.w
mad_pp r0.xyz, r0, c8.w, -r1
mad_sat r1.w, r1, c7.z, c7
mad_pp r1.xyz, r1.w, r0, r1
frc r0.w, r0
mad r1.w, r0, c9.z, c9
sincos r0.xy, r1.w
add r0.z, v0.x, -c3.x
log_pp r2.x, r2.x
log_pp r2.y, r2.y
log_pp r2.z, r2.z
add_pp r2.xyz, -r2, r1
add r1.y, v0, -c3
mul r0.w, r1.y, r0.y
mad r0.w, r0.z, r0.x, -r0
add r1.x, -r0.w, c3
mov r0.w, c2.x
mad r1.x, c0.y, r0.w, r1
mul r0.x, r1.y, r0
mad r0.x, r0.z, r0.y, r0
add r0.y, -r0.x, c3
mov r0.w, c5
mad r0.z, r0.w, c8.x, c8.y
mov r0.x, c5.z
mul r0.z, r0, c8
mad r0.z, c0.y, r0.x, r0
mov r0.x, c2.y
mad r1.y, c0, r0.x, r0
mad r0.x, r0.z, c9, c9.y
frc r0.y, r0.x
texld r1, r1, s0
log_pp r0.x, r2.w
mad r3.w, r0.y, c9.z, c9
mul_pp r2.w, r1, -r0.x
sincos r0.xy, r3.w
add r0.w, v0, -c5.y
mul_pp r3.xyz, r2, c1
mul r3.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r3.w
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r3.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r3.w
mul_pp r3.xyz, r3, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mad_pp oC0.w, r2, c1, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 224 // 208 used size, 14 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
Vector 192 [unity_LightmapFade] 4
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 46 instructions, 4 temp regs, 0 temp arrays:
// ALU 38 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedonffegcoedchkhbhehlgdibgainjboifabaaaaaabiaiaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcbaahaaaaeaaaaaaameabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaabbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaaamaaaaaadkiacaaaaaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahccaabaaaaaaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaafgafbaaa
aaaaaaaaegacbaaaacaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaacpaaaaaf
pcaabaaaabaaaaaaegaobaaaabaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaiaebaaaaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaakbcaabaaaacaaaaaadkiacaaa
aaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaa
acaaaaaaakaabaaaacaaaaaaabeaaaaanlapejeadcaaaaalbcaabaaaacaaaaaa
ckiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaacaaaaaa
enaaaaahbcaabaaaacaaaaaabcaabaaaadaaaaaaakaabaaaacaaaaaaaaaaaaaj
gcaabaaaacaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaaaaaaaaaaaeaaaaaa
diaaaaahjcaabaaaacaaaaaaagaabaaaacaaaaaafgajbaaaacaaaaaadcaaaaak
bcaabaaaacaaaaaackaabaaaacaaaaaaakaabaaaadaaaaaaakaabaiaebaaaaaa
acaaaaaadcaaaaajccaabaaaacaaaaaabkaabaaaacaaaaaaakaabaaaadaaaaaa
dkaabaaaacaaaaaaaaaaaaajdcaabaaaacaaaaaaegaabaiaebaaaaaaacaaaaaa
egiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaaadaaaaaabkiacaaaaaaaaaaa
adaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaacaaaaaadcaaaaalbcaabaaa
adaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaadaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaaiicaabaaaabaaaaaadkaabaiaebaaaaaaabaaaaaa
dkaabaaaacaaaaaadiaaaaaipcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaa
abaaaaaadcaaaaakiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaa
acaaaaaadkaabaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
acaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 71 ALU, 5 TEX
PARAM c[12] = { program.local[0..7],
		{ 0.0055555557, 1, 3.1415927, 8 },
		{ -0.40824828, -0.70710677, 0.57735026, 0 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].w;
MUL R1.xyz, R0.y, c[11];
MAD R1.xyz, R0.x, c[10], R1;
MAD R1.xyz, R0.z, c[9], R1;
DP3 R0.x, R1, R1;
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, R1;
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
TXP R1, fragment.texcoord[1], texture[2], 2D;
DP3 R0.x, R0, R0;
RSQ R0.x, R0.x;
MUL R0.y, R0.x, R0.z;
MOV R0.x, c[10].w;
MAX R0.y, R0, c[9].w;
MUL R0.x, R0, c[7];
POW R2.w, R0.y, R0.x;
TEX R0, fragment.texcoord[2], texture[3], 2D;
MUL R2.xyz, R0.w, R0;
MOV R0.x, c[3].w;
MAD R0.x, R0, c[8], c[8].y;
MUL R2.xyz, R2, c[8].w;
ADD R0.z, fragment.texcoord[0].y, -c[3].y;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
LG2 R1.w, R1.w;
ADD R1, -R1, R2;
MOV R2.w, c[0].y;
MUL R0.x, R0, c[8].z;
MAD R0.x, R2.w, c[3].z, R0;
SIN R0.w, R0.x;
COS R0.y, R0.x;
MUL R3.x, R0.z, R0.w;
ADD R0.x, fragment.texcoord[0], -c[3];
MUL R0.z, R0.y, R0;
MAD R3.x, R0, R0.y, -R3;
MAD R0.z, R0.x, R0.w, R0;
ADD R0.y, -R3.x, c[3].x;
MAD R0.x, R2.w, c[2], R0.y;
ADD R0.y, -R0.z, c[3];
MOV R0.z, c[5].w;
MAD R3.x, R0.z, c[8], c[8].y;
MAD R0.y, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
MUL R1.w, R0, R1;
MUL R0, R0, c[6];
MUL R2.xyz, R1, c[1];
MUL R3.x, R3, c[8].z;
MAD R3.x, R2.w, c[5].z, R3;
COS R3.y, R3.x;
SIN R3.z, R3.x;
ADD R3.x, fragment.texcoord[0].w, -c[5].y;
MUL R3.w, R3.x, R3.z;
MUL R4.x, R3.y, R3;
ADD R3.x, fragment.texcoord[0].z, -c[5];
MAD R3.z, R3.x, R3, R4.x;
MAD R3.x, R3, R3.y, -R3.w;
ADD R3.y, -R3.z, c[5];
ADD R3.x, -R3, c[5];
MAD R3.y, R2.w, c[4], R3;
MAD R3.x, R2.w, c[4], R3;
TEX R2.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R2.w;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R1, c[1], R0;
END
# 71 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 92 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c8, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c9, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c10, -0.40824831, 0.70710677, 0.57735026, 0.00000000
def c11, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c12, -0.40824828, -0.70710677, 0.57735026, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
texld r0, v2, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.w
mul r1.xyz, r0.y, c10
mad r1.xyz, r0.x, c11, r1
mad r1.xyz, r0.z, c12, r1
dp3 r0.x, r1, r1
rsq r0.y, r0.x
dp3_pp r0.x, v3, v3
mul r1.xyz, r0.y, r1
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r0.x, r0, r0
mov_pp r0.y, c7.x
rsq_pp r0.x, r0.x
mul_pp r0.x, r0, r0.z
max_pp r1.y, r0.x, c10.w
mov r0.x, c3.w
mul_pp r1.z, c11.w, r0.y
mad r0.x, r0, c8, c8.y
mul r0.y, r0.x, c8.z
mov r0.x, c3.z
mad r1.x, c0.y, r0, r0.y
pow r0, r1.y, r1.z
mad r0.x, r1, c9, c9.y
texldp r1, v1, s2
frc r0.x, r0
mov r3.w, r0
mad r2.x, r0, c9.z, c9.w
sincos r0.xy, r2.x
texld r2, v2, s3
mul_pp r2.xyz, r2.w, r2
mul_pp r3.xyz, r2, c8.w
add r0.w, v0.y, -c3.y
add r0.z, v0.x, -c3.x
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
log_pp r1.w, r1.w
add_pp r2, -r1, r3
mul r1.x, r0.w, r0.y
mad r1.x, r0.z, r0, -r1
add r1.y, -r1.x, c3.x
mul r0.x, r0.w, r0
mad r0.x, r0.z, r0.y, r0
mov r1.x, c2
mad r1.x, c0.y, r1, r1.y
mov r1.y, c5.w
mad r0.w, r1.y, c8.x, c8.y
mul r0.z, r0.w, c8
mov r0.y, c5.z
mad r0.z, c0.y, r0.y, r0
add r0.y, -r0.x, c3
mov r0.x, c2.y
mad r1.y, c0, r0.x, r0
texld r1, r1, s0
mad r0.z, r0, c9.x, c9.y
frc r0.x, r0.z
mad r3.w, r0.x, c9.z, c9
sincos r0.xy, r3.w
add r0.w, v0, -c5.y
mul r3.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r3.w
mul_pp r2.w, r1, r2
mul_pp r3.xyz, r2, c1
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r3.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r3.w
mul_pp r3.xyz, r3, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mad_pp oC0.w, r2, c1, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 224 // 132 used size, 14 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 59 instructions, 4 temp regs, 0 temp arrays:
// ALU 51 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedboohhoclicmcgpnfiglpdgiooicafianabaaaaaahmajaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcheaiaaaaeaaaaaaabnacaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaa
fgafbaaaaaaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaam
hcaabaaaabaaaaaaagaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaadkmnbddp
aaaaaaaaegacbaaaabaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaa
aceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaafbcaabaaa
abaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaah
ocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
ckaabaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaaficaabaaaabaaaaaa
akaabaaaaaaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaacaaaaaapgbpbaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaacpaaaaafpcaabaaaacaaaaaaegaobaaaacaaaaaaefaaaaaj
pcaabaaaadaaaaaaegbabaaaadaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
diaaaaahbcaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdiaaaaah
hcaabaaaabaaaaaaegacbaaaadaaaaaaagaabaaaaaaaaaaaaaaaaaaipcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaiaebaaaaaaacaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaakbcaabaaa
acaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadp
diaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaanlapejeadcaaaaal
bcaabaaaacaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaa
akaabaaaacaaaaaaenaaaaahbcaabaaaacaaaaaabcaabaaaadaaaaaaakaabaaa
acaaaaaaaaaaaaajgcaabaaaacaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaa
aaaaaaaaaeaaaaaadiaaaaahjcaabaaaacaaaaaaagaabaaaacaaaaaafgajbaaa
acaaaaaadcaaaaakbcaabaaaacaaaaaackaabaaaacaaaaaaakaabaaaadaaaaaa
akaabaiaebaaaaaaacaaaaaadcaaaaajccaabaaaacaaaaaabkaabaaaacaaaaaa
akaabaaaadaaaaaadkaabaaaacaaaaaaaaaaaaajdcaabaaaacaaaaaaegaabaia
ebaaaaaaacaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaaadaaaaaa
bkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaacaaaaaa
dcaaaaalbcaabaaaadaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaadkaabaaaacaaaaaadiaaaaaipcaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaabaaaaaadcaaaaakiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaacaaaaaadkaabaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
"3.0-!!ARBfp1.0
# 45 ALU, 3 TEX
PARAM c[8] = { program.local[0..6],
		{ 0.0055555557, 3.1415927, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.x, c[3].w;
MAD R0.x, R0, c[7], c[7].z;
MOV R2.x, c[5].w;
MAD R2.x, R2, c[7], c[7].z;
MOV R2.w, c[0].y;
MUL R3.x, R2, c[7].y;
MAD R3.x, R2.w, c[5].z, R3;
MUL R0.x, R0, c[7].y;
MAD R0.x, R2.w, c[3].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.x, fragment.texcoord[0].y, -c[3].y;
MUL R0.w, R0.x, R0.z;
MUL R1.x, R0.y, R0;
ADD R0.x, fragment.texcoord[0], -c[3];
MAD R0.z, R0.x, R0, R1.x;
MAD R0.x, R0, R0.y, -R0.w;
ADD R0.y, -R0.z, c[3];
TXP R1, fragment.texcoord[1], texture[2], 2D;
ADD R1.xyz, R1, fragment.texcoord[2];
ADD R0.x, -R0, c[3];
COS R3.y, R3.x;
SIN R3.z, R3.x;
ADD R3.x, fragment.texcoord[0].w, -c[5].y;
MUL R3.w, R3.x, R3.z;
MUL R4.x, R3.y, R3;
ADD R3.x, fragment.texcoord[0].z, -c[5];
MAD R3.z, R3.x, R3, R4.x;
MAD R3.x, R3, R3.y, -R3.w;
ADD R3.y, -R3.z, c[5];
ADD R3.x, -R3, c[5];
MAD R3.y, R2.w, c[4], R3;
MAD R3.x, R2.w, c[4], R3;
MAD R0.y, R2.w, c[2], R0;
MAD R0.x, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
MUL R1.w, R0, R1;
MUL R0, R0, c[6];
MUL R2.xyz, R1, c[1];
TEX R2.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R2.w;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R1, c[1], R0;
END
# 45 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
"ps_3_0
; 65 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00555556, 1.00000000, 3.14159274, 0
def c8, 0.15915491, 0.50000000, 6.28318501, -3.14159298
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
mov r0.x, c3.w
mad r0.x, r0, c7, c7.y
mul r0.y, r0.x, c7.z
mov r0.x, c3.z
mad r0.x, c0.y, r0, r0.y
mad r0.x, r0, c8, c8.y
frc r0.x, r0
mad r1.x, r0, c8.z, c8.w
sincos r0.xy, r1.x
add r0.w, v0.y, -c3.y
mul r1.x, r0.w, r0.y
add r0.z, v0.x, -c3.x
mul r0.w, r0, r0.x
mad r1.x, r0.z, r0, -r1
mad r0.y, r0.z, r0, r0.w
add r0.z, -r0.y, c3.y
mov r0.w, c5
mad r0.w, r0, c7.x, c7.y
mov r0.y, c2
mad r0.y, c0, r0, r0.z
add r1.x, -r1, c3
mov r0.x, c2
mad r0.x, c0.y, r0, r1
texld r1, r0, s0
mul r0.w, r0, c7.z
mov r0.z, c5
mad r0.z, c0.y, r0, r0.w
mad r2.x, r0.z, c8, c8.y
texldp r0, v1, s2
frc r2.x, r2
mad r3.x, r2, c8.z, c8.w
mul_pp r2.w, r1, r0
add_pp r2.xyz, r0, v2
sincos r0.xy, r3.x
add r0.w, v0, -c5.y
mul_pp r3.xyz, r2, c1
mul r3.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r3.w
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r3.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r3.w
mul_pp r3.xyz, r3, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mad_pp oC0.w, r2, c1, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 192 // 128 used size, 12 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [_LightBuffer] 2D 2
// 35 instructions, 4 temp regs, 0 temp arrays:
// ALU 29 float, 0 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhmaaodaoigfkaofgmmebonnnlifeniccabaaaaaafmagaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcgmafaaaaeaaaaaaaflabaaaafjaaaaaeegiocaaa
aaaaaaaaaiaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadlcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaadcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaa
gballgdlabeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaanlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaa
bcaabaaaabaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaa
abaaaaaafgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaa
agaabaaaaaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaa
aaaaaaaaakaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaa
aaaaaaaabkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaaj
dcaabaaaaaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaa
dcaaaaalccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaa
aaaaaaaabkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaa
afaaaaaabkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaa
aaaaaaaaegaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaadcaaaaak
bcaabaaaaaaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaa
aaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaanlapejea
dcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaaabaaaaaa
akaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaafgbebaaaabaaaaaafgiecaia
ebaaaaaaaaaaaaaaaeaaaaaadiaaaaahgcaabaaaabaaaaaaagaabaaaaaaaaaaa
fgagbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaaakaabaaa
abaaaaaabkaabaiaebaaaaaaabaaaaaadcaaaaajccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaajdcaabaaaaaaaaaaa
egaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaa
abaaaaaabkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaa
aaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaoaaaaahdcaabaaaaaaaaaaa
egbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaa
aaaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaahbcaabaaaaaaaaaaa
dkaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaaipcaabaaaabaaaaaaegaobaaa
abaaaaaaegiocaaaaaaaaaaaahaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegbcbaaaadaaaaaadiaaaaaihcaabaaaadaaaaaaegacbaaaacaaaaaa
egiccaaaaaaaaaaaacaaaaaadiaaaaahhcaabaaaadaaaaaaagaabaaaaaaaaaaa
egacbaaaadaaaaaadcaaaaakiccabaaaaaaaaaaaakaabaaaaaaaaaaadkiacaaa
aaaaaaaaacaaaaaadkaabaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaacaaaaaaegacbaaaadaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 56 ALU, 5 TEX
PARAM c[9] = { program.local[0..7],
		{ 0.0055555557, 3.1415927, 1, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[2], texture[3], 2D;
MUL R1.xyz, R0.w, R0;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].w;
DP4 R1.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.w, R1.w;
RCP R0.w, R0.w;
MOV R2.w, c[0].y;
MAD R1.xyz, R1, c[8].w, -R0;
MAD_SAT R0.w, R0, c[7].z, c[7];
MAD R2.xyz, R0.w, R1, R0;
TXP R1, fragment.texcoord[1], texture[2], 2D;
ADD R1.xyz, R1, R2;
MOV R0.x, c[3].w;
MAD R0.x, R0, c[8], c[8].z;
MUL R0.x, R0, c[8].y;
MAD R0.x, R2.w, c[3].z, R0;
COS R0.y, R0.x;
SIN R0.z, R0.x;
ADD R0.w, fragment.texcoord[0].y, -c[3].y;
MUL R3.x, R0.w, R0.z;
ADD R0.x, fragment.texcoord[0], -c[3];
MUL R0.w, R0.y, R0;
MAD R3.x, R0, R0.y, -R3;
MAD R0.z, R0.x, R0, R0.w;
ADD R0.y, -R3.x, c[3].x;
MAD R0.x, R2.w, c[2], R0.y;
ADD R0.y, -R0.z, c[3];
MOV R0.z, c[5].w;
MAD R3.x, R0.z, c[8], c[8].z;
MAD R0.y, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
MUL R1.w, R0, R1;
MUL R0, R0, c[6];
MUL R2.xyz, R1, c[1];
MUL R3.x, R3, c[8].y;
MAD R3.x, R2.w, c[5].z, R3;
COS R3.y, R3.x;
SIN R3.z, R3.x;
ADD R3.x, fragment.texcoord[0].w, -c[5].y;
MUL R3.w, R3.x, R3.z;
MUL R4.x, R3.y, R3;
ADD R3.x, fragment.texcoord[0].z, -c[5];
MAD R3.z, R3.x, R3, R4.x;
MAD R3.x, R3, R3.y, -R3.w;
ADD R3.y, -R3.z, c[5];
ADD R3.x, -R3, c[5];
MAD R3.y, R2.w, c[4], R3;
MAD R3.x, R2.w, c[4], R3;
TEX R2.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R2.w;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R1, c[1], R0;
END
# 56 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 74 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c8, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c9, 0.15915491, 0.50000000, 6.28318501, -3.14159298
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
texld r0, v2, s3
texld r1, v2, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r1.w, r1
mul_pp r1.xyz, r1, c8.w
mov r0.w, c3
mad r0.w, r0, c8.x, c8.y
mul r1.w, r0, c8.z
mov r0.w, c3.z
mad r0.w, c0.y, r0, r1
dp4 r1.w, v3, v3
rsq r1.w, r1.w
mad r0.w, r0, c9.x, c9.y
mad_pp r0.xyz, r0, c8.w, -r1
rcp r2.x, r1.w
frc r0.w, r0
mad r1.w, r0, c9.z, c9
mad_sat r0.w, r2.x, c7.z, c7
mad_pp r1.xyz, r0.w, r0, r1
sincos r0.xy, r1.w
texldp r2, v1, s2
add_pp r2.xyz, r2, r1
add r0.w, v0.y, -c3.y
mul r1.x, r0.w, r0.y
add r0.z, v0.x, -c3.x
mad r1.x, r0.z, r0, -r1
add r1.y, -r1.x, c3.x
mul r0.x, r0.w, r0
mad r0.x, r0.z, r0.y, r0
mov r1.x, c2
mad r1.x, c0.y, r1, r1.y
mov r1.y, c5.w
mad r0.w, r1.y, c8.x, c8.y
mul r0.z, r0.w, c8
mov r0.y, c5.z
mad r0.z, c0.y, r0.y, r0
add r0.y, -r0.x, c3
mov r0.x, c2.y
mad r1.y, c0, r0.x, r0
texld r1, r1, s0
mad r0.z, r0, c9.x, c9.y
frc r0.x, r0.z
mad r3.w, r0.x, c9.z, c9
sincos r0.xy, r3.w
add r0.w, v0, -c5.y
mul r3.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r3.w
mul_pp r2.w, r1, r2
mul_pp r3.xyz, r2, c1
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r3.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r3.w
mul_pp r3.xyz, r3, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mad_pp oC0.w, r2, c1, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 224 // 208 used size, 14 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
Vector 192 [unity_LightmapFade] 4
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 45 instructions, 4 temp regs, 0 temp arrays:
// ALU 37 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedpebgiahdkfcfjmkfdklgmchpagiplmngabaaaaaapmahaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcpeagaaaaeaaaaaaalnabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadpcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaabbaaaaahbcaabaaa
aaaaaaaaegbobaaaaeaaaaaaegbobaaaaeaaaaaaelaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadccaaaalbcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaa
aaaaaaaaamaaaaaadkiacaaaaaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaahccaabaaa
aaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaafgafbaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
adaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaadiaaaaahccaabaaaaaaaaaaa
dkaabaaaacaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaafgafbaaa
aaaaaaaaegacbaaaacaaaaaaegacbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaajpcaabaaa
abaaaaaaegaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaah
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadcaaaaakbcaabaaa
acaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdlabeaaaaaaaaaiadp
diaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaanlapejeadcaaaaal
bcaabaaaacaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaaabaaaaaaaaaaaaaa
akaabaaaacaaaaaaenaaaaahbcaabaaaacaaaaaabcaabaaaadaaaaaaakaabaaa
acaaaaaaaaaaaaajgcaabaaaacaaaaaafgbebaaaabaaaaaafgiecaiaebaaaaaa
aaaaaaaaaeaaaaaadiaaaaahjcaabaaaacaaaaaaagaabaaaacaaaaaafgajbaaa
acaaaaaadcaaaaakbcaabaaaacaaaaaackaabaaaacaaaaaaakaabaaaadaaaaaa
akaabaiaebaaaaaaacaaaaaadcaaaaajccaabaaaacaaaaaabkaabaaaacaaaaaa
akaabaaaadaaaaaadkaabaaaacaaaaaaaaaaaaajdcaabaaaacaaaaaaegaabaia
ebaaaaaaacaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaalccaabaaaadaaaaaa
bkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaabkaabaaaacaaaaaa
dcaaaaalbcaabaaaadaaaaaaakiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaa
aaaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegaabaaaadaaaaaa
eghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaa
abaaaaaadkaabaaaacaaaaaadiaaaaaipcaabaaaacaaaaaaegaobaaaacaaaaaa
egiocaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaa
egacbaaaabaaaaaadcaaaaakiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaacaaaaaadkaabaaaacaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaa
acaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 67 ALU, 5 TEX
PARAM c[12] = { program.local[0..7],
		{ 0.0055555557, 1, 3.1415927, 8 },
		{ -0.40824828, -0.70710677, 0.57735026, 0 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].w;
MUL R1.xyz, R0.y, c[11];
MAD R1.xyz, R0.x, c[10], R1;
MAD R1.xyz, R0.z, c[9], R1;
DP3 R0.x, R1, R1;
RSQ R0.y, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, R1;
RSQ R0.x, R0.x;
MAD R0.xyz, R0.x, fragment.texcoord[3], R1;
DP3 R0.x, R0, R0;
RSQ R0.y, R0.x;
TEX R1, fragment.texcoord[2], texture[3], 2D;
MUL R2.xyz, R1.w, R1;
MOV R1.x, c[3].w;
MUL R0.y, R0, R0.z;
MOV R0.x, c[10].w;
MUL R0.z, R0.x, c[7].x;
MAX R0.x, R0.y, c[9].w;
POW R2.w, R0.x, R0.z;
TXP R0, fragment.texcoord[1], texture[2], 2D;
MAD R3.x, R1, c[8], c[8].y;
MUL R2.xyz, R2, c[8].w;
ADD R1, R0, R2;
MOV R2.w, c[0].y;
MUL R0.x, R3, c[8].z;
MAD R0.x, R2.w, c[3].z, R0;
COS R0.y, R0.x;
SIN R0.w, R0.x;
ADD R0.z, fragment.texcoord[0].y, -c[3].y;
MUL R3.x, R0.z, R0.w;
ADD R0.x, fragment.texcoord[0], -c[3];
MUL R0.z, R0.y, R0;
MAD R3.x, R0, R0.y, -R3;
MAD R0.z, R0.x, R0.w, R0;
ADD R0.y, -R3.x, c[3].x;
MAD R0.x, R2.w, c[2], R0.y;
ADD R0.y, -R0.z, c[3];
MOV R0.z, c[5].w;
MAD R3.x, R0.z, c[8], c[8].y;
MAD R0.y, R2.w, c[2], R0;
TEX R0, R0, texture[0], 2D;
MUL R1.w, R0, R1;
MUL R0, R0, c[6];
MUL R2.xyz, R1, c[1];
MUL R3.x, R3, c[8].z;
MAD R3.x, R2.w, c[5].z, R3;
COS R3.y, R3.x;
SIN R3.z, R3.x;
ADD R3.x, fragment.texcoord[0].w, -c[5].y;
MUL R3.w, R3.x, R3.z;
MUL R4.x, R3.y, R3;
ADD R3.x, fragment.texcoord[0].z, -c[5];
MAD R3.z, R3.x, R3, R4.x;
MAD R3.x, R3, R3.y, -R3.w;
ADD R3.y, -R3.z, c[5];
ADD R3.x, -R3, c[5];
MAD R3.y, R2.w, c[4], R3;
MAD R3.x, R2.w, c[4], R3;
TEX R2.w, R3, texture[1], 2D;
MUL R3.xyz, R0, R2.w;
MUL R2.xyz, R2, R1.w;
MAD R0.xyz, R0, R1, R2;
ADD result.color.xyz, R0, R3;
MAD result.color.w, R1, c[1], R0;
END
# 67 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_SpecColor]
Vector 2 [_PanMT]
Vector 3 [_RotMT]
Vector 4 [_PanIL]
Vector 5 [_RotIL]
Vector 6 [_Color]
Float 7 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Illum] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_3_0
; 88 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c8, 0.00555556, 1.00000000, 3.14159274, 8.00000000
def c9, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c10, -0.40824831, 0.70710677, 0.57735026, 0.00000000
def c11, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c12, -0.40824828, -0.70710677, 0.57735026, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xyz
texld r0, v2, s4
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.w
mul r1.xyz, r0.y, c10
mad r1.xyz, r0.x, c11, r1
mad r1.xyz, r0.z, c12, r1
dp3 r0.x, r1, r1
rsq r0.y, r0.x
dp3_pp r0.x, v3, v3
mul r1.xyz, r0.y, r1
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, v3, r1
dp3_pp r0.x, r0, r0
mov_pp r0.y, c7.x
rsq_pp r0.x, r0.x
mul_pp r0.x, r0, r0.z
max_pp r1.y, r0.x, c10.w
mov r0.x, c3.w
mul_pp r1.z, c11.w, r0.y
mad r0.x, r0, c8, c8.y
mul r0.y, r0.x, c8.z
mov r0.x, c3.z
mad r1.x, c0.y, r0, r0.y
pow r0, r1.y, r1.z
mad r0.x, r1, c9, c9.y
frc r0.x, r0
mad r2.x, r0, c9.z, c9.w
mov r2.w, r0
sincos r0.xy, r2.x
texld r1, v2, s3
mul_pp r2.xyz, r1.w, r1
texldp r1, v1, s2
mul_pp r2.xyz, r2, c8.w
add_pp r2, r1, r2
add r0.w, v0.y, -c3.y
mul r1.x, r0.w, r0.y
add r0.z, v0.x, -c3.x
mad r1.x, r0.z, r0, -r1
add r1.y, -r1.x, c3.x
mul r0.x, r0.w, r0
mad r0.x, r0.z, r0.y, r0
mov r1.x, c2
mad r1.x, c0.y, r1, r1.y
mov r1.y, c5.w
mad r0.w, r1.y, c8.x, c8.y
mul r0.z, r0.w, c8
mov r0.y, c5.z
mad r0.z, c0.y, r0.y, r0
add r0.y, -r0.x, c3
mov r0.x, c2.y
mad r1.y, c0, r0.x, r0
texld r1, r1, s0
mad r0.z, r0, c9.x, c9.y
frc r0.x, r0.z
mad r3.w, r0.x, c9.z, c9
sincos r0.xy, r3.w
add r0.w, v0, -c5.y
mul r3.w, r0, r0.x
mul r0.z, r0.w, r0.y
add r0.w, v0.z, -c5.x
mad r0.z, r0.w, r0.x, -r0
mad r0.y, r0.w, r0, r3.w
mul_pp r2.w, r1, r2
mul_pp r3.xyz, r2, c1
mov r0.x, c4.y
add r0.y, -r0, c5
mad r0.y, c0, r0.x, r0
add r0.z, -r0, c5.x
mov r0.x, c4
mad r0.x, c0.y, r0, r0.z
texld r3.w, r0, s1
mul_pp r0, r1, c6
mul r1.xyz, r0, r3.w
mul_pp r3.xyz, r3, r2.w
mad_pp r0.xyz, r0, r2, r3
add_pp oC0.xyz, r0, r1
mad_pp oC0.w, r2, c1, r0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 224 // 132 used size, 14 vars
Vector 32 [_SpecColor] 4
Vector 48 [_PanMT] 4
Vector 64 [_RotMT] 4
Vector 80 [_PanIL] 4
Vector 96 [_RotIL] 4
Vector 112 [_Color] 4
Float 128 [_Shininess]
ConstBuffer "UnityPerCamera" 128 // 16 used size, 8 vars
Vector 0 [_Time] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_Illum] 2D 1
SetTexture 2 [_LightBuffer] 2D 2
SetTexture 3 [unity_Lightmap] 2D 3
SetTexture 4 [unity_LightmapInd] 2D 4
// 58 instructions, 4 temp regs, 0 temp arrays:
// ALU 50 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedobkmhlbdgkijlcngnklpcplfldbdmaloabaaaaaageajaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcfmaiaaaaeaaaaaaabhacaaaafjaaaaaeegiocaaaaaaaaaaaajaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadlcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
dcaaaaakbcaabaaaaaaaaaaadkiacaaaaaaaaaaaagaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaaaaaaaaackiacaaaaaaaaaaaagaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaaaaaaaaaenaaaaahbcaabaaaaaaaaaaabcaabaaa
abaaaaaaakaabaaaaaaaaaaaaaaaaaajgcaabaaaaaaaaaaapgbobaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaagaaaaaadiaaaaahjcaabaaaaaaaaaaaagaabaaa
aaaaaaaafgajbaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaackaabaaaaaaaaaaa
akaabaaaabaaaaaaakaabaiaebaaaaaaaaaaaaaadcaaaaajccaabaaaaaaaaaaa
bkaabaaaaaaaaaaaakaabaaaabaaaaaadkaabaaaaaaaaaaaaaaaaaajdcaabaaa
aaaaaaaaegaabaiaebaaaaaaaaaaaaaaegiacaaaaaaaaaaaagaaaaaadcaaaaal
ccaabaaaabaaaaaabkiacaaaaaaaaaaaafaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaaaaaaaaadcaaaaalbcaabaaaabaaaaaaakiacaaaaaaaaaaaafaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaa
egaabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaadiaaaaah
bcaabaaaaaaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaebdiaaaaahhcaabaaa
aaaaaaaaegacbaaaabaaaaaaagaabaaaaaaaaaaadiaaaaakhcaabaaaabaaaaaa
fgafbaaaaaaaaaaaaceaaaaaomafnblopdaedfdpdkmnbddpaaaaaaaadcaaaaam
hcaabaaaabaaaaaaagaabaaaaaaaaaaaaceaaaaaolaffbdpaaaaaaaadkmnbddp
aaaaaaaaegacbaaaabaaaaaadcaaaaamhcaabaaaaaaaaaaakgakbaaaaaaaaaaa
aceaaaaaolafnblopdaedflpdkmnbddpaaaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaafbcaabaaa
abaaaaaaakaabaaaabaaaaaabaaaaaahccaabaaaabaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaeeaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaah
ocaabaaaabaaaaaafgafbaaaabaaaaaaagbjbaaaaeaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaagaabaaaabaaaaaajgahbaaaabaaaaaabaaaaaah
bcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaafbcaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
ckaabaaaaaaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaacpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaiccaabaaa
aaaaaaaaakiacaaaaaaaaaaaaiaaaaaaabeaaaaaaaaaaaeddiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaabjaaaaaficaabaaaabaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahbcaabaaaaaaaaaaadkaabaaaacaaaaaa
abeaaaaaaaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaaacaaaaaaagaabaaa
aaaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaaaaaaaaaeghobaaaacaaaaaaaagabaaa
acaaaaaaaaaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaacaaaaaa
diaaaaaihcaabaaaaaaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaakbcaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaagballgdl
abeaaaaaaaaaiadpdiaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
nlapejeadcaaaaalbcaabaaaacaaaaaackiacaaaaaaaaaaaaeaaaaaabkiacaaa
abaaaaaaaaaaaaaaakaabaaaacaaaaaaenaaaaahbcaabaaaacaaaaaabcaabaaa
adaaaaaaakaabaaaacaaaaaaaaaaaaajgcaabaaaacaaaaaafgbebaaaabaaaaaa
fgiecaiaebaaaaaaaaaaaaaaaeaaaaaadiaaaaahjcaabaaaacaaaaaaagaabaaa
acaaaaaafgajbaaaacaaaaaadcaaaaakbcaabaaaacaaaaaackaabaaaacaaaaaa
akaabaaaadaaaaaaakaabaiaebaaaaaaacaaaaaadcaaaaajccaabaaaacaaaaaa
bkaabaaaacaaaaaaakaabaaaadaaaaaadkaabaaaacaaaaaaaaaaaaajdcaabaaa
acaaaaaaegaabaiaebaaaaaaacaaaaaaegiacaaaaaaaaaaaaeaaaaaadcaaaaal
ccaabaaaadaaaaaabkiacaaaaaaaaaaaadaaaaaabkiacaaaabaaaaaaaaaaaaaa
bkaabaaaacaaaaaadcaaaaalbcaabaaaadaaaaaaakiacaaaaaaaaaaaadaaaaaa
bkiacaaaabaaaaaaaaaaaaaaakaabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaa
egaabaaaadaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahicaabaaa
abaaaaaadkaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaaipcaabaaaacaaaaaa
egaobaaaacaaaaaaegiocaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaabaaaaaadcaaaaakiccabaaaaaaaaaaadkaabaaa
abaaaaaadkiacaaaaaaaaaaaacaaaaaadkaabaaaacaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

}
	}

#LINE 47

}
FallBack "Animated/Built-in/Self-Illumin/Diffuse"
}
